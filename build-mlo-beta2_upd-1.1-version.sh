#!/bin/bash

rm -rf openwrt
rm -rf mtk-openwrt-feeds

git clone --branch openwrt-24.10 https://git.openwrt.org/openwrt/openwrt.git openwrt || true
cd openwrt; git checkout 68bf4844a1cbc9f404f6e93b70a2657e74f1dce9; cd -;
 
git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout 42df09d4cf568c795e71427668fae0eea4f112c5; cd -;

rm -rf openwrt/package/firmware/wireless-regdb/patches/*.*
rm -rf mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches/*.*
\cp -r my_files/500-tx_power.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/package/firmware/wireless-regdb/patches
\cp -r my_files/regdb.Makefile openwrt/package/firmware/wireless-regdb/Makefile
\cp -r my_files/rules mtk-openwrt-feeds/autobuild/unified
\cp -r my_files/mt7988a-rfb-spim-nand-nmbm.dtso openwrt/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek
\cp -r my_files/mt7981-rfb-spim-nor.dtso openwrt/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek
\cp -r my_files/mt7988d-rfb.dts openwrt/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek
\cp -r my_files/mt7988a-rfb-spidev.dtso openwrt/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek
# \cp -r my_files/750-mtk-eth-add-jumbo-frame-support-mt7998.patch openwrt/target/linux/mediatek/patches-6.6

\cp -r my_files/ethtool/Makefile openwrt/package/network/utils/ethtool/Makefile
\cp -r my_files/999-2709-net-ethernet-mtk_eth_soc-add-rss-lro-reg.patch mtk-openwrt-feeds/autobuild/unified/global/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/999-2710-net-ethernet-mtk_eth_soc-add-rss-support.patch mtk-openwrt-feeds/autobuild/unified/global/24.10/files/target/linux/mediatek/patches-6.6/
\cp -r my_files/0006-arch-arm64-dts-mt7988a-add-adma-intrrupts.patch mtk-openwrt-feeds/autobuild/unified/global/24.10/patches-base/
\cp -r my_files/mediatek/*.* mtk-openwrt-feeds/autobuild/unified/global/24.10/files/target/linux/mediatek/files-6.6/drivers/net/ethernet/mediatek/
\cp -r my_files/999-3000-netfilter-add-bridging-support-to-xt_FLOWOFFLOAD.patch mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/files/target/linux/mediatek/patches-6.6/999-3000-netfilter-add-bridging-support-to-xt_FLOWOFFLOAD.patch
\cp -r my_files/debugfs.c mtk-openwrt-feeds/feed/kernel/pce/src/debugfs.c
\cp -r my_files/nl.c mtk-openwrt-feeds/feed/app/atenl/src/nl.c

sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config
sed -i 's/CONFIG_PACKAGE_perf=y/# CONFIG_PACKAGE_perf is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config

sed -i 's/CONFIG_PACKAGE_kmod-thermal=y/# CONFIG_PACKAGE_kmod-thermal is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7988_wifi7_mac80211_mlo/.config
sed -i 's/CONFIG_PACKAGE_kmod-thermal=y/# CONFIG_PACKAGE_kmod-thermal is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7981_mac80211/.config
sed -i 's/CONFIG_PACKAGE_kmod-thermal=y/# CONFIG_PACKAGE_kmod-thermal is not set/' mtk-openwrt-feeds/autobuild/autobuild_5.4_mac80211_release/mt7986_mac80211/.config

cd openwrt
bash ../mtk-openwrt-feeds/autobuild/unified/autobuild.sh filogic-mac80211-bpi-r4 log_file=make


\cp -r my_files/w-mt7988a.dtsi openwrt/target/linux/mediatek/files-6.6/arch/arm64/boot/dts/mediatek/mt7988a.dtsi

\cp -r my_files/luci-app-3ginfo-lite-main/sms-tool/ openwrt/feeds/packages/utils/sms-tool
\cp -r my_files/luci-app-3ginfo-lite-main/luci-app-3ginfo-lite/ openwrt/feeds/luci/applications
\cp -r my_files/luci-app-atinout-mod-main/luci-app-atinout-mod/ openwrt/feeds/luci/applications
\cp -r my_files/luci-app-atinout-mod-main/atinout/ openwrt/feeds/packages/net/atinout
\cp -r my_files/luci-app-modemband-main/luci-app-modemband/ openwrt/feeds/luci/applications
\cp -r my_files/luci-app-modemband-main/modemband/ openwrt/feeds/packages/net/modemband

cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

\cp -r ../configs/config.ext-upd-1.0 ./.config

make menuconfig
make -j$(nproc)

