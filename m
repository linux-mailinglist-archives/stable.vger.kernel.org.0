Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AC1410630
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhIRMLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239660AbhIRMKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 08:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8776127A;
        Sat, 18 Sep 2021 12:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631966957;
        bh=QOkRT3KTc9dZ3R8TMI+DAjRHaeUkOZwWceBTtMeC2Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOEQdZk3Fud5F4rqBbfCMxUap+VjSy8nJP+CXrxZctwFaUDs3nGh83afvAhp/aFnX
         AwVzWUQBdkiW8DWE7fzJLlb8UghYo2KBvAjxAf29DeMb++GZU14gDp54mfS9Zlp4Fw
         ZzvK1UAU45leHs1i4puz267GZFbHYw04pyfsqs6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.19
Date:   Sat, 18 Sep 2021 14:09:03 +0200
Message-Id: <16319668994540@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16319668996036@kroah.com>
References: <16319668996036@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 9c2be821c225..922c23bb4372 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2993,10 +2993,10 @@
 		65 = /dev/infiniband/issm1     Second InfiniBand IsSM device
 		  ...
 		127 = /dev/infiniband/issm63    63rd InfiniBand IsSM device
-		128 = /dev/infiniband/uverbs0   First InfiniBand verbs device
-		129 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
+		192 = /dev/infiniband/uverbs0   First InfiniBand verbs device
+		193 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
 		  ...
-		159 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
+		223 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
 
  232 char	Biometric Devices
 		0 = /dev/biometric/sensor0/fingerprint	first fingerprint sensor on first device
diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
index 38dc56a57760..ecec514b3155 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
@@ -43,19 +43,19 @@ group emmc_nb
 
 group pwm0
  - pin 11 (GPIO1-11)
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm1
  - pin 12
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm2
  - pin 13
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm3
  - pin 14
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pmic1
  - pin 7
diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 53d396650afb..7f52d9079d76 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -185,6 +185,7 @@ fault_type=%d		 Support configuring fault injection type, should be
 			 FAULT_KVMALLOC		  0x000000002
 			 FAULT_PAGE_ALLOC	  0x000000004
 			 FAULT_PAGE_GET		  0x000000008
+			 FAULT_ALLOC_BIO	  0x000000010 (obsolete)
 			 FAULT_ALLOC_NID	  0x000000020
 			 FAULT_ORPHAN		  0x000000040
 			 FAULT_BLOCK		  0x000000080
@@ -289,6 +290,9 @@ compress_mode=%s	 Control file compression mode. This supports "fs" and "user"
 			 choosing the target file and the timing. The user can do manual
 			 compression/decompression on the compression enabled files using
 			 ioctls.
+compress_cache		 Support to use address space of a filesystem managed inode to
+			 cache compressed block, in order to improve cache hit ratio of
+			 random read.
 inlinecrypt		 When possible, encrypt/decrypt the contents of encrypted
 			 files using the blk-crypto framework rather than
 			 filesystem-layer encryption. This allows the use of
diff --git a/Makefile b/Makefile
index ddbd64b92a72..528a5c37bc8d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 18
+SUBLEVEL = 19
 EXTRAVERSION =
 NAME = Opossums on Parade
 
@@ -404,6 +404,11 @@ ifeq ($(ARCH),sparc64)
        SRCARCH := sparc
 endif
 
+# Additional ARCH settings for parisc
+ifeq ($(ARCH),parisc64)
+       SRCARCH := parisc
+endif
+
 export cross_compiling :=
 ifneq ($(SRCARCH),$(SUBARCH))
 cross_compiling := 1
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 8eb70c1febce..356f70cfcd3b 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -85,6 +85,8 @@ compress-$(CONFIG_KERNEL_LZ4)  = lz4
 libfdt_objs := fdt_rw.o fdt_ro.o fdt_wip.o fdt.o
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
+CFLAGS_REMOVE_atags_to_fdt.o += -Wframe-larger-than=${CONFIG_FRAME_WARN}
+CFLAGS_atags_to_fdt.o += -Wframe-larger-than=1280
 OBJS	+= $(libfdt_objs) atags_to_fdt.o
 endif
 ifeq ($(CONFIG_USE_OF),y)
diff --git a/arch/arm/boot/dts/at91-kizbox3_common.dtsi b/arch/arm/boot/dts/at91-kizbox3_common.dtsi
index c4b3750495da..abe27adfa4d6 100644
--- a/arch/arm/boot/dts/at91-kizbox3_common.dtsi
+++ b/arch/arm/boot/dts/at91-kizbox3_common.dtsi
@@ -336,7 +336,7 @@ &pwm0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index ebbc9b23aef1..b1068cca4228 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -662,7 +662,7 @@ &rtt {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	status = "okay";
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index a9e6fee55a2a..8034e5dacc80 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -138,7 +138,7 @@ i2c3: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
 				input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
index ff83967fd008..c145c4e5ef58 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts
@@ -205,7 +205,7 @@ &sdmmc0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index bd64721fa23c..34faca597c35 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -693,7 +693,7 @@ &sdmmc0 {
 };
 
 &shutdown_controller {
-	atmel,shdwc-debouncer = <976>;
+	debounce-delay-us = <976>;
 	atmel,wakeup-rtc-timer;
 
 	input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index dfd150eb0fd8..3f972a4086c3 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -203,7 +203,7 @@ i2c2: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 
 				input@0 {
 					reg = <0>;
diff --git a/arch/arm/boot/dts/at91-sama5d2_xplained.dts b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
index 509c732a0d8b..627b7bf88d83 100644
--- a/arch/arm/boot/dts/at91-sama5d2_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
@@ -347,7 +347,7 @@ i2c2: i2c@600 {
 			};
 
 			shdwc@f8048010 {
-				atmel,shdwc-debouncer = <976>;
+				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
 				input@0 {
diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index be040b6a02fa..1f3ee60fb102 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -70,6 +70,12 @@ cko2_11M: sgtl-clock-cko2 {
 		clock-frequency = <11289600>;
 	};
 
+	achc_24M: achc-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+	};
+
 	sgtlsound: sound {
 		compatible = "fsl,imx53-cpuvo-sgtl5000",
 			     "fsl,imx-audio-sgtl5000";
@@ -314,16 +320,13 @@ &gpio4 11 GPIO_ACTIVE_LOW
 		    &gpio4 12 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	spidev0: spi@0 {
-		compatible = "ge,achc";
-		reg = <0>;
-		spi-max-frequency = <1000000>;
-	};
-
-	spidev1: spi@1 {
-		compatible = "ge,achc";
-		reg = <1>;
-		spi-max-frequency = <1000000>;
+	spidev0: spi@1 {
+		compatible = "ge,achc", "nxp,kinetis-k20";
+		reg = <1>, <0>;
+		vdd-supply = <&reg_3v3>;
+		vdda-supply = <&reg_3v3>;
+		clocks = <&achc_24M>;
+		reset-gpios = <&gpio3 6 GPIO_ACTIVE_LOW>;
 	};
 
 	gpioxra0: gpio@2 {
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 2687c4e890ba..e36d590e8373 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1262,9 +1262,9 @@ dsi0: mdss_dsi@4700000 {
 				<&mmcc DSI1_BYTE_CLK>,
 				<&mmcc DSI_PIXEL_CLK>,
 				<&mmcc DSI1_ESC_CLK>;
-			clock-names = "iface_clk", "bus_clk", "core_mmss_clk",
-					"src_clk", "byte_clk", "pixel_clk",
-					"core_clk";
+			clock-names = "iface", "bus", "core_mmss",
+					"src", "byte", "pixel",
+					"core";
 
 			assigned-clocks = <&mmcc DSI1_BYTE_SRC>,
 					<&mmcc DSI1_ESC_SRC>,
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 6cf1c8b4c6e2..c9577ba2973d 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -172,15 +172,15 @@ sgtl5000_port: port {
 			sgtl5000_tx_endpoint: endpoint@0 {
 				reg = <0>;
 				remote-endpoint = <&sai2a_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&sgtl5000_tx_endpoint>;
+				bitclock-master = <&sgtl5000_tx_endpoint>;
 			};
 
 			sgtl5000_rx_endpoint: endpoint@1 {
 				reg = <1>;
 				remote-endpoint = <&sai2b_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&sgtl5000_rx_endpoint>;
+				bitclock-master = <&sgtl5000_rx_endpoint>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 64dca5b7f748..6885948f3024 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -220,8 +220,8 @@ &i2c2 {	/* X6 I2C2 */
 &i2c4 {
 	hdmi-transmitter@3d {
 		compatible = "adi,adv7513";
-		reg = <0x3d>, <0x2d>, <0x4d>, <0x5d>;
-		reg-names = "main", "cec", "edid", "packet";
+		reg = <0x3d>, <0x4d>, <0x2d>, <0x5d>;
+		reg-names = "main", "edid", "cec", "packet";
 		clocks = <&cec_clock>;
 		clock-names = "cec";
 
@@ -239,8 +239,6 @@ hdmi-transmitter@3d {
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
 		adi,input-clock = "1x";
-		adi,input-style = <1>;
-		adi,input-justification = "evenly";
 
 		ports {
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
index 59f18846cf5d..586aac8a998c 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
@@ -220,15 +220,15 @@ cs42l51_port: port {
 			cs42l51_tx_endpoint: endpoint@0 {
 				reg = <0>;
 				remote-endpoint = <&sai2a_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&cs42l51_tx_endpoint>;
+				bitclock-master = <&cs42l51_tx_endpoint>;
 			};
 
 			cs42l51_rx_endpoint: endpoint@1 {
 				reg = <1>;
 				remote-endpoint = <&sai2b_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&cs42l51_rx_endpoint>;
+				bitclock-master = <&cs42l51_rx_endpoint>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
index 14cd3238355b..2c74993f1a9e 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -716,7 +716,6 @@ usb-phy@c5000000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus1>;
 	};
 
 	usb@c5008000 {
@@ -728,7 +727,7 @@ usb-phy@c5008000 {
 		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
-		vbus-supply = <&vdd_vbus3>;
+		vbus-supply = <&vdd_5v0_sys>;
 	};
 
 	brcm_wifi_pwrseq: wifi-pwrseq {
@@ -988,28 +987,6 @@ vdd_pnl: regulator@3 {
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_vbus1: regulator@4 {
-		compatible = "regulator-fixed";
-		regulator-name = "vdd_usb1_vbus";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		regulator-always-on;
-		gpio = <&gpio TEGRA_GPIO(D, 0) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
-	vdd_vbus3: regulator@5 {
-		compatible = "regulator-fixed";
-		regulator-name = "vdd_usb3_vbus";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		regulator-always-on;
-		gpio = <&gpio TEGRA_GPIO(D, 3) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
 	sound {
 		compatible = "nvidia,tegra-audio-wm8903-picasso",
 			     "nvidia,tegra-audio-wm8903";
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 95e6bccdb4f6..dd4d506683de 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -185,8 +185,9 @@ conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
 					"cdev1", "cdev2", "dap1", "dtb", "gma",
 					"gmb", "gmc", "gmd", "gme", "gpu7",
-					"gpv", "i2cp", "pta", "rm", "slxa",
-					"slxk", "spia", "spib", "uac";
+					"gpv", "i2cp", "irrx", "irtx", "pta",
+					"rm", "slxa", "slxk", "spia", "spib",
+					"uac";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -211,7 +212,7 @@ conf_crtp {
 			conf_ddc {
 				nvidia,pins = "ddc", "dta", "dtd", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
-					"sdc";
+					"sdc", "uad", "uca";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -221,10 +222,9 @@ conf_hdint {
 					"lvp0", "owc", "sdb";
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
-			conf_irrx {
-				nvidia,pins = "irrx", "irtx", "sdd", "spic",
-					"spie", "spih", "uaa", "uab", "uad",
-					"uca", "ucb";
+			conf_sdd {
+				nvidia,pins = "sdd", "spic", "spie", "spih",
+					"uaa", "uab", "ucb";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
index be81330db14f..02641191682e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
@@ -32,14 +32,14 @@ hdmi_con_in: endpoint {
 		};
 	};
 
-	reg_vcc3v3: vcc3v3 {
+	reg_vcc3v3: regulator-vcc3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3";
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 	};
 
-	reg_vdd_cpu_gpu: vdd-cpu-gpu {
+	reg_vdd_cpu_gpu: regulator-vdd-cpu-gpu {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-cpu-gpu";
 		regulator-min-microvolt = <1135000>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
index db3d303093f6..6d22efbd645c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts
@@ -83,15 +83,9 @@ rtc@51 {
 			};
 
 			eeprom@52 {
-				compatible = "atmel,24c512";
+				compatible = "onnn,cat24c04", "atmel,24c04";
 				reg = <0x52>;
 			};
-
-			eeprom@53 {
-				compatible = "atmel,24c512";
-				reg = <0x53>;
-			};
-
 		};
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 60acdf0b689e..7025aad8ae89 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -59,14 +59,9 @@ temp-sensor@4c {
 	};
 
 	eeprom@52 {
-		compatible = "atmel,24c512";
+		compatible = "onnn,cat24c05", "atmel,24c04";
 		reg = <0x52>;
 	};
-
-	eeprom@53 {
-		compatible = "atmel,24c512";
-		reg = <0x53>;
-	};
 };
 
 &i2c3 {
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
index c769fadbd008..00f86cada30d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
@@ -278,70 +278,86 @@ rtc@68 {
 
 	pmic@69 {
 		compatible = "mps,mp5416";
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x69>;
 
 		regulators {
+			/* vdd_0p95: DRAM/GPU/VPU */
 			buck1 {
-				regulator-name = "vdd_0p95";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck1";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1000000>;
-				regulator-max-microamp = <2500000>;
+				regulator-min-microamp  = <3800000>;
+				regulator-max-microamp  = <6800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_soc */
 			buck2 {
-				regulator-name = "vdd_soc";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck2";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
-				regulator-max-microamp = <1000000>;
+				regulator-min-microamp  = <2200000>;
+				regulator-max-microamp  = <5200000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_arm */
 			buck3_reg: buck3 {
-				regulator-name = "vdd_arm";
-				regulator-min-microvolt = <805000>;
+				regulator-name = "buck3";
+				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1000000>;
-				regulator-max-microamp = <2200000>;
-				regulator-boot-on;
+				regulator-min-microamp  = <3800000>;
+				regulator-max-microamp  = <6800000>;
+				regulator-always-on;
 			};
 
+			/* vdd_1p8 */
 			buck4 {
-				regulator-name = "vdd_1p8";
+				regulator-name = "buck4";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-				regulator-max-microamp = <500000>;
+				regulator-min-microamp  = <2200000>;
+				regulator-max-microamp  = <5200000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* nvcc_snvs_1p8 */
 			ldo1 {
-				regulator-name = "nvcc_snvs_1p8";
+				regulator-name = "ldo1";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-				regulator-max-microamp = <300000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_snvs_0p8 */
 			ldo2 {
-				regulator-name = "vdd_snvs_0p8";
+				regulator-name = "ldo2";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_0p9 */
 			ldo3 {
-				regulator-name = "vdd_0p95";
-				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <800000>;
+				regulator-name = "ldo3";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <900000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 
+			/* vdd_1p8 */
 			ldo4 {
-				regulator-name = "vdd_1p8";
+				regulator-name = "ldo4";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
+				regulator-always-on;
 			};
 		};
 	};
@@ -426,12 +442,6 @@ MX8MM_IOMUXC_I2C2_SDA_I2C2_SDA		0x400001c3
 		>;
 	};
 
-	pinctrl_pmic: pmicgrp {
-		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3	0x41
-		>;
-	};
-
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_UART2_RXD_UART2_DCE_RX	0x140
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
index 905b68a3daa5..8e4a0ce99790 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -46,7 +46,7 @@ reg_usb_otg1_vbus: regulator-usb-otg1 {
 		pinctrl-0 = <&pinctrl_reg_usb1_en>;
 		compatible = "regulator-fixed";
 		regulator-name = "usb_otg1_vbus";
-		gpio = <&gpio1 12 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
@@ -156,7 +156,8 @@ MX8MM_IOMUXC_GPIO1_IO15_GPIO1_IO15	0x41
 
 	pinctrl_reg_usb1_en: regusb1grp {
 		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x41
+			MX8MM_IOMUXC_GPIO1_IO10_GPIO1_IO10	0x41
+			MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x141
 			MX8MM_IOMUXC_GPIO1_IO13_USB1_OTG_OC	0x41
 		>;
 	};
diff --git a/arch/arm64/boot/dts/nvidia/tegra132.dtsi b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
index 9928a87f593a..b0bcda8cc51f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -1227,13 +1227,13 @@ cpus {
 
 		cpu@0 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <0>;
 		};
 
 		cpu@1 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <1>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 2e40b6047283..203318aa660f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2005,7 +2005,7 @@ pcie@141a0000 {
 	};
 
 	pcie_ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2037,7 +2037,7 @@ pcie_ep@14160000 {
 	};
 
 	pcie_ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2069,7 +2069,7 @@ pcie_ep@14180000 {
 	};
 
 	pcie_ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 9fa5b028e4f3..23ee1bfa4318 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -151,7 +151,7 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		rpm_msg_ram: memory@0x60000 {
+		rpm_msg_ram: memory@60000 {
 			reg = <0x0 0x60000 0x0 0x6000>;
 			no-map;
 		};
diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index e8c37a1693d3..cc08dc4eb56a 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -20,7 +20,7 @@ chosen {
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index a32e5e79ab0b..e8db62470b23 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -567,10 +567,10 @@ frame@b128000 {
 
 		pcie1: pci@10000000 {
 			compatible = "qcom,pcie-ipq8074";
-			reg =  <0x10000000 0xf1d
-				0x10000f20 0xa8
-				0x00088000 0x2000
-				0x10100000 0x1000>;
+			reg =  <0x10000000 0xf1d>,
+			       <0x10000f20 0xa8>,
+			       <0x00088000 0x2000>,
+			       <0x10100000 0x1000>;
 			reg-names = "dbi", "elbi", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <1>;
@@ -629,10 +629,10 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 
 		pcie0: pci@20000000 {
 			compatible = "qcom,pcie-ipq8074";
-			reg =  <0x20000000 0xf1d
-				0x20000f20 0xa8
-				0x00080000 0x2000
-				0x20100000 0x1000>;
+			reg = <0x20000000 0xf1d>,
+			      <0x20000f20 0xa8>,
+			      <0x00080000 0x2000>,
+			      <0x20100000 0x1000>;
 			reg-names = "dbi", "elbi", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <0>;
diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index f9f0b5aa6a26..87a3217e88ef 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -15,16 +15,18 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
+			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32768>;
+			clock-output-names = "sleep_clk";
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index ce430ba9c118..957487f84ead 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -17,14 +17,14 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
 			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32764>;
diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index f91a928466c3..06a0ae773ad5 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -17,14 +17,14 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
 			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32764>;
@@ -343,10 +343,19 @@ wlan_msa_mem: wlan-msa-mem@85700000 {
 		};
 
 		qhee_code: qhee-code@85800000 {
-			reg = <0x0 0x85800000 0x0 0x3700000>;
+			reg = <0x0 0x85800000 0x0 0x600000>;
 			no-map;
 		};
 
+		rmtfs_mem: memory@85e00000 {
+			compatible = "qcom,rmtfs-mem";
+			reg = <0x0 0x85e00000 0x0 0x200000>;
+			no-map;
+
+			qcom,client-id = <1>;
+			qcom,vmid = <15>;
+		};
+
 		smem_region: smem-mem@86000000 {
 			reg = <0 0x86000000 0 0x200000>;
 			no-map;
@@ -357,58 +366,44 @@ tz_mem: memory@86200000 {
 			no-map;
 		};
 
-		modem_fw_mem: modem-fw-region@8ac00000 {
+		mpss_region: mpss@8ac00000 {
 			reg = <0x0 0x8ac00000 0x0 0x7e00000>;
 			no-map;
 		};
 
-		adsp_fw_mem: adsp-fw-region@92a00000 {
+		adsp_region: adsp@92a00000 {
 			reg = <0x0 0x92a00000 0x0 0x1e00000>;
 			no-map;
 		};
 
-		pil_mba_mem: pil-mba-region@94800000 {
+		mba_region: mba@94800000 {
 			reg = <0x0 0x94800000 0x0 0x200000>;
 			no-map;
 		};
 
-		buffer_mem: buffer-region@94a00000 {
+		buffer_mem: tzbuffer@94a00000 {
 			reg = <0x0 0x94a00000 0x0 0x100000>;
 			no-map;
 		};
 
-		venus_fw_mem: venus-fw-region@9f800000 {
+		venus_region: venus@9f800000 {
 			reg = <0x0 0x9f800000 0x0 0x800000>;
 			no-map;
 		};
 
-		secure_region2: secure-region2@f7c00000 {
-			reg = <0x0 0xf7c00000 0x0 0x5c00000>;
-			no-map;
-		};
-
 		adsp_mem: adsp-region@f6000000 {
 			reg = <0x0 0xf6000000 0x0 0x800000>;
 			no-map;
 		};
 
-		qseecom_ta_mem: qseecom-ta-region@fec00000 {
-			reg = <0x0 0xfec00000 0x0 0x1000000>;
-			no-map;
-		};
-
 		qseecom_mem: qseecom-region@f6800000 {
 			reg = <0x0 0xf6800000 0x0 0x1400000>;
 			no-map;
 		};
 
-		secure_display_memory: secure-region@f5c00000 {
-			reg = <0x0 0xf5c00000 0x0 0x5c00000>;
-			no-map;
-		};
-
-		cont_splash_mem: cont-splash-region@9d400000 {
-			reg = <0x0 0x9d400000 0x0 0x23ff000>;
+		zap_shader_region: gpu@fed00000 {
+			compatible = "shared-dma-pool";
+			reg = <0x0 0xfed00000 0x0 0xa00000>;
 			no-map;
 		};
 	};
@@ -527,14 +522,18 @@ tcsr_mutex_regs: syscon@1f40000 {
 			reg = <0x01f40000 0x20000>;
 		};
 
-		tlmm: pinctrl@3000000 {
+		tlmm: pinctrl@3100000 {
 			compatible = "qcom,sdm630-pinctrl";
-			reg = <0x03000000 0xc00000>;
+			reg = <0x03100000 0x400000>,
+				  <0x03500000 0x400000>,
+				  <0x03900000 0x400000>;
+			reg-names = "south", "center", "north";
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
-			#gpio-cells = <0x2>;
+			gpio-ranges = <&tlmm 0 0 114>;
+			#gpio-cells = <2>;
 			interrupt-controller;
-			#interrupt-cells = <0x2>;
+			#interrupt-cells = <2>;
 
 			blsp1_uart1_default: blsp1-uart1-default {
 				pins = "gpio0", "gpio1", "gpio2", "gpio3";
@@ -554,40 +553,48 @@ blsp1_uart2_default: blsp1-uart2-default {
 				bias-disable;
 			};
 
-			blsp2_uart1_tx_active: blsp2-uart1-tx-active {
-				pins = "gpio16";
-				drive-strength = <2>;
-				bias-disable;
-			};
-
-			blsp2_uart1_tx_sleep: blsp2-uart1-tx-sleep {
-				pins = "gpio16";
-				drive-strength = <2>;
-				bias-pull-up;
-			};
+			blsp2_uart1_default: blsp2-uart1-active {
+				tx-rts {
+					pins = "gpio16", "gpio19";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-disable;
+				};
 
-			blsp2_uart1_rxcts_active: blsp2-uart1-rxcts-active {
-				pins = "gpio17", "gpio18";
-				drive-strength = <2>;
-				bias-disable;
-			};
+				rx {
+					/*
+					 * Avoid garbage data while BT module
+					 * is powered off or not driving signal
+					 */
+					pins = "gpio17";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-pull-up;
+				};
 
-			blsp2_uart1_rxcts_sleep: blsp2-uart1-rxcts-sleep {
-				pins = "gpio17", "gpio18";
-				drive-strength = <2>;
-				bias-no-pull;
+				cts {
+					/* Match the pull of the BT module */
+					pins = "gpio18";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-pull-down;
+				};
 			};
 
-			blsp2_uart1_rfr_active: blsp2-uart1-rfr-active {
-				pins = "gpio19";
-				drive-strength = <2>;
-				bias-disable;
-			};
+			blsp2_uart1_sleep: blsp2-uart1-sleep {
+				tx {
+					pins = "gpio16";
+					function = "gpio";
+					drive-strength = <2>;
+					bias-pull-up;
+				};
 
-			blsp2_uart1_rfr_sleep: blsp2-uart1-rfr-sleep {
-				pins = "gpio19";
-				drive-strength = <2>;
-				bias-no-pull;
+				rx-cts-rts {
+					pins = "gpio17", "gpio18", "gpio19";
+					function = "gpio";
+					drive-strength = <2>;
+					bias-no-pull;
+				};
 			};
 
 			i2c1_default: i2c1-default {
@@ -686,50 +693,106 @@ i2c8_sleep: i2c8-sleep {
 				bias-pull-up;
 			};
 
-			sdc1_clk_on: sdc1-clk-on {
-				pins = "sdc1_clk";
-				bias-disable;
-				drive-strength = <16>;
-			};
+			sdc1_state_on: sdc1-on {
+				clk {
+					pins = "sdc1_clk";
+					bias-disable;
+					drive-strength = <16>;
+				};
 
-			sdc1_clk_off: sdc1-clk-off {
-				pins = "sdc1_clk";
-				bias-disable;
-				drive-strength = <2>;
-			};
+				cmd {
+					pins = "sdc1_cmd";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
 
-			sdc1_cmd_on: sdc1-cmd-on {
-				pins = "sdc1_cmd";
-				bias-pull-up;
-				drive-strength = <10>;
-			};
+				data {
+					pins = "sdc1_data";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
 
-			sdc1_cmd_off: sdc1-cmd-off {
-				pins = "sdc1_cmd";
-				bias-pull-up;
-				drive-strength = <2>;
+				rclk {
+					pins = "sdc1_rclk";
+					bias-pull-down;
+				};
 			};
 
-			sdc1_data_on: sdc1-data-on {
-				pins = "sdc1_data";
-				bias-pull-up;
-				drive-strength = <8>;
-			};
+			sdc1_state_off: sdc1-off {
+				clk {
+					pins = "sdc1_clk";
+					bias-disable;
+					drive-strength = <2>;
+				};
 
-			sdc1_data_off: sdc1-data-off {
-				pins = "sdc1_data";
-				bias-pull-up;
-				drive-strength = <2>;
+				cmd {
+					pins = "sdc1_cmd";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				data {
+					pins = "sdc1_data";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				rclk {
+					pins = "sdc1_rclk";
+					bias-pull-down;
+				};
 			};
 
-			sdc1_rclk_on: sdc1-rclk-on {
-				pins = "sdc1_rclk";
-				bias-pull-down;
+			sdc2_state_on: sdc2-on {
+				clk {
+					pins = "sdc2_clk";
+					bias-disable;
+					drive-strength = <16>;
+				};
+
+				cmd {
+					pins = "sdc2_cmd";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
+
+				data {
+					pins = "sdc2_data";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
+
+				sd-cd {
+					pins = "gpio54";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
 			};
 
-			sdc1_rclk_off: sdc1-rclk-off {
-				pins = "sdc1_rclk";
-				bias-pull-down;
+			sdc2_state_off: sdc2-off {
+				clk {
+					pins = "sdc2_clk";
+					bias-disable;
+					drive-strength = <2>;
+				};
+
+				cmd {
+					pins = "sdc2_cmd";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				data {
+					pins = "sdc2_data";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				sd-cd {
+					pins = "gpio54";
+					bias-disable;
+					drive-strength = <2>;
+				};
 			};
 		};
 
@@ -823,8 +886,8 @@ sdhc_1: sdhci@c0c4000 {
 			clock-names = "core", "iface", "xo", "ice";
 
 			pinctrl-names = "default", "sleep";
-			pinctrl-0 = <&sdc1_clk_on &sdc1_cmd_on &sdc1_data_on &sdc1_rclk_on>;
-			pinctrl-1 = <&sdc1_clk_off &sdc1_cmd_off &sdc1_data_off &sdc1_rclk_off>;
+			pinctrl-0 = <&sdc1_state_on>;
+			pinctrl-1 = <&sdc1_state_off>;
 
 			bus-width = <8>;
 			non-removable;
@@ -969,10 +1032,8 @@ blsp2_uart1: serial@c1af000 {
 			dmas = <&blsp2_dma 0>, <&blsp2_dma 1>;
 			dma-names = "tx", "rx";
 			pinctrl-names = "default", "sleep";
-			pinctrl-0 = <&blsp2_uart1_tx_active &blsp2_uart1_rxcts_active
-				&blsp2_uart1_rfr_active>;
-			pinctrl-1 = <&blsp2_uart1_tx_sleep &blsp2_uart1_rxcts_sleep
-				&blsp2_uart1_rfr_sleep>;
+			pinctrl-0 = <&blsp2_uart1_default>;
+			pinctrl-1 = <&blsp2_uart1_sleep>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 1316bea3eab5..6d28bfd9a8f5 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3773,7 +3773,7 @@ apps_bcm_voter: bcm_voter {
 			};
 		};
 
-		epss_l3: interconnect@18591000 {
+		epss_l3: interconnect@18590000 {
 			compatible = "qcom,sm8250-epss-l3";
 			reg = <0 0x18590000 0 0x1000>;
 
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b83fb24954b7..3198acb2aad8 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -149,8 +149,17 @@
 	ubfx	x1, x1, #ID_AA64MMFR0_FGT_SHIFT, #4
 	cbz	x1, .Lskip_fgt_\@
 
-	msr_s	SYS_HDFGRTR_EL2, xzr
-	msr_s	SYS_HDFGWTR_EL2, xzr
+	mov	x0, xzr
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
+	cmp	x1, #3
+	b.lt	.Lset_fgt_\@
+	/* Disable PMSNEVFR_EL1 read and write traps */
+	orr	x0, x0, #(1 << 62)
+
+.Lset_fgt_\@:
+	msr_s	SYS_HDFGRTR_EL2, x0
+	msr_s	SYS_HDFGWTR_EL2, x0
 	msr_s	SYS_HFGRTR_EL2, xzr
 	msr_s	SYS_HFGWTR_EL2, xzr
 	msr_s	SYS_HFGITR_EL2, xzr
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index d44df9d62fc9..a54ce2646cba 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -65,8 +65,8 @@
 #define EARLY_KASLR	(0)
 #endif
 
-#define EARLY_ENTRIES(vstart, vend, shift) (((vend) >> (shift)) \
-					- ((vstart) >> (shift)) + 1 + EARLY_KASLR)
+#define EARLY_ENTRIES(vstart, vend, shift) \
+	((((vend) - 1) >> (shift)) - ((vstart) >> (shift)) + 1 + EARLY_KASLR)
 
 #define EARLY_PGDS(vstart, vend) (EARLY_ENTRIES(vstart, vend, PGDIR_SHIFT))
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 75beffe2ee8a..e9c30859f80c 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -27,11 +27,32 @@ typedef struct {
 } mm_context_t;
 
 /*
- * This macro is only used by the TLBI and low-level switch_mm() code,
- * neither of which can race with an ASID change. We therefore don't
- * need to reload the counter using atomic64_read().
+ * We use atomic64_read() here because the ASID for an 'mm_struct' can
+ * be reallocated when scheduling one of its threads following a
+ * rollover event (see new_context() and flush_context()). In this case,
+ * a concurrent TLBI (e.g. via try_to_unmap_one() and ptep_clear_flush())
+ * may use a stale ASID. This is fine in principle as the new ASID is
+ * guaranteed to be clean in the TLB, but the TLBI routines have to take
+ * care to handle the following race:
+ *
+ *    CPU 0                    CPU 1                          CPU 2
+ *
+ *    // ptep_clear_flush(mm)
+ *    xchg_relaxed(pte, 0)
+ *    DSB ISHST
+ *    old = ASID(mm)
+ *         |                                                  <rollover>
+ *         |                   new = new_context(mm)
+ *         \-----------------> atomic_set(mm->context.id, new)
+ *                             cpu_switch_mm(mm)
+ *                             // Hardware walk of pte using new ASID
+ *    TLBI(old)
+ *
+ * In this scenario, the barrier on CPU 0 and the dependency on CPU 1
+ * ensure that the page-table walker on CPU 1 *must* see the invalid PTE
+ * written by CPU 0.
  */
-#define ASID(mm)	((mm)->context.id.counter & 0xffff)
+#define ASID(mm)	(atomic64_read(&(mm)->context.id) & 0xffff)
 
 static inline bool arm64_kernel_unmapped_at_el0(void)
 {
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index cc3f5a33ff9c..36f02892e1df 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -245,9 +245,10 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long asid = __TLBI_VADDR(0, ASID(mm));
+	unsigned long asid;
 
 	dsb(ishst);
+	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
 	dsb(ish);
@@ -256,9 +257,10 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 static inline void flush_tlb_page_nosync(struct vm_area_struct *vma,
 					 unsigned long uaddr)
 {
-	unsigned long addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
+	unsigned long addr;
 
 	dsb(ishst);
+	addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
 	__tlbi(vale1is, addr);
 	__tlbi_user(vale1is, addr);
 }
@@ -283,9 +285,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 {
 	int num = 0;
 	int scale = 0;
-	unsigned long asid = ASID(vma->vm_mm);
-	unsigned long addr;
-	unsigned long pages;
+	unsigned long asid, addr, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -305,6 +305,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	}
 
 	dsb(ishst);
+	asid = ASID(vma->vm_mm);
 
 	/*
 	 * When the CPU does not support TLB range operations, flush the TLB
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 96873dfa67fd..3374bbd18fc6 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -176,7 +176,7 @@ SYM_CODE_END(preserve_boot_args)
  * to be composed of multiple pages. (This effectively scales the end index).
  *
  *	vstart:	virtual address of start of range
- *	vend:	virtual address of end of range
+ *	vend:	virtual address of end of range - we map [vstart, vend]
  *	shift:	shift used to transform virtual address into index
  *	ptrs:	number of entries in page table
  *	istart:	index in table corresponding to vstart
@@ -213,17 +213,18 @@ SYM_CODE_END(preserve_boot_args)
  *
  *	tbl:	location of page table
  *	rtbl:	address to be used for first level page table entry (typically tbl + PAGE_SIZE)
- *	vstart:	start address to map
- *	vend:	end address to map - we map [vstart, vend]
+ *	vstart:	virtual address of start of range
+ *	vend:	virtual address of end of range - we map [vstart, vend - 1]
  *	flags:	flags to use to map last level entries
  *	phys:	physical address corresponding to vstart - physical memory is contiguous
  *	pgds:	the number of pgd entries
  *
  * Temporaries:	istart, iend, tmp, count, sv - these need to be different registers
- * Preserves:	vstart, vend, flags
- * Corrupts:	tbl, rtbl, istart, iend, tmp, count, sv
+ * Preserves:	vstart, flags
+ * Corrupts:	tbl, rtbl, vend, istart, iend, tmp, count, sv
  */
 	.macro map_memory, tbl, rtbl, vstart, vend, flags, phys, pgds, istart, iend, tmp, count, sv
+	sub \vend, \vend, #1
 	add \rtbl, \tbl, #PAGE_SIZE
 	mov \sv, \rtbl
 	mov \count, #0
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 709d2c433c5e..f6b1a88245db 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -181,6 +181,8 @@ SECTIONS
 	/* everything from this point to __init_begin will be marked RO NX */
 	RO_DATA(PAGE_SIZE)
 
+	HYPERVISOR_DATA_SECTIONS
+
 	idmap_pg_dir = .;
 	. += IDMAP_DIR_SIZE;
 	idmap_pg_end = .;
@@ -260,8 +262,6 @@ SECTIONS
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
 
-	HYPERVISOR_DATA_SECTIONS
-
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
 	 * cache lines to be invalidated, discarding up to a Cache Writeback
diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
index f1be832e2b74..d1e93a39cd3b 100644
--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -63,7 +63,7 @@ source "drivers/zorro/Kconfig"
 
 endif
 
-if !MMU
+if COLDFIRE
 
 config ISA_DMA_API
 	def_bool !M5272
diff --git a/arch/mips/mti-malta/malta-dtshim.c b/arch/mips/mti-malta/malta-dtshim.c
index 0ddf03df6268..f451268f6c38 100644
--- a/arch/mips/mti-malta/malta-dtshim.c
+++ b/arch/mips/mti-malta/malta-dtshim.c
@@ -22,7 +22,7 @@
 #define  ROCIT_CONFIG_GEN1_MEMMAP_SHIFT	8
 #define  ROCIT_CONFIG_GEN1_MEMMAP_MASK	(0xf << 8)
 
-static unsigned char fdt_buf[16 << 10] __initdata;
+static unsigned char fdt_buf[16 << 10] __initdata __aligned(8);
 
 /* determined physical memory size, not overridden by command line args	 */
 extern unsigned long physical_memsize;
diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index bc657e55c15f..98e4f97db515 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -547,6 +547,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 	l.bnf	1f			// ext irq enabled, all ok.
 	l.nop
 
+#ifdef CONFIG_PRINTK
 	l.addi  r1,r1,-0x8
 	l.movhi r3,hi(42f)
 	l.ori	r3,r3,lo(42f)
@@ -560,6 +561,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 		.string "\n\rESR interrupt bug: in _external_irq_handler (ESR %x)\n\r"
 		.align 4
 	.previous
+#endif
 
 	l.ori	r4,r4,SPR_SR_IEE	// fix the bug
 //	l.sw	PT_SR(r1),r4
diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index aed8ea29268b..2d019aa73b8f 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -25,18 +25,18 @@ CHECKFLAGS	+= -D__hppa__=1
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1
-CC_ARCHES	= hppa64
 LD_BFD		:= elf64-hppa-linux
 else # 32-bit
-CC_ARCHES	= hppa hppa2.0 hppa1.1
 LD_BFD		:= elf32-hppa-linux
 endif
 
 # select defconfig based on actual architecture
-ifeq ($(shell uname -m),parisc64)
+ifeq ($(ARCH),parisc64)
 	KBUILD_DEFCONFIG := generic-64bit_defconfig
+	CC_ARCHES := hppa64
 else
 	KBUILD_DEFCONFIG := generic-32bit_defconfig
+	CC_ARCHES := hppa hppa2.0 hppa1.1
 endif
 
 export LD_BFD
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index fb1e94a3982b..db1a47cf424d 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -237,6 +237,12 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs,
 #endif
 	
 	usp = (regs->gr[30] & ~(0x01UL));
+#ifdef CONFIG_64BIT
+	if (is_compat_task()) {
+		/* The gcc alloca implementation leaves garbage in the upper 32 bits of sp */
+		usp = (compat_uint_t)usp;
+	}
+#endif
 	/*FIXME: frame_size parameter is unused, remove it. */
 	frame = get_sigframe(&ksig->ka, usp, sizeof(*frame));
 
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 949ff9ccda5e..dbf3ff8adc65 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -34,6 +34,7 @@ CONFIG_MTD_CFI_GEOMETRY=y
 # CONFIG_MTD_CFI_I2 is not set
 CONFIG_MTD_CFI_I4=y
 CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 # CONFIG_BLK_DEV is not set
 CONFIG_NETDEVICES=y
diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
index c6bbe9778d3c..3c09109e708e 100644
--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -34,6 +34,13 @@ static inline void ppc_set_pmu_inuse(int inuse)
 #endif
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+static inline int ppc_get_pmu_inuse(void)
+{
+	return get_paca()->pmcregs_in_use;
+}
+#endif
+
 extern void power4_enable_pmcs(void);
 
 #else /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index df6b468976d5..fe505d8ed55b 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1085,7 +1085,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 
 	if (cpu_to_chip_id(boot_cpuid) != -1) {
-		int idx = num_possible_cpus() / threads_per_core;
+		int idx = DIV_ROUND_UP(num_possible_cpus(), threads_per_core);
 
 		/*
 		 * All threads of a core will all belong to the same core,
@@ -1503,6 +1503,7 @@ static void add_cpu_to_masks(int cpu)
 	 * add it to it's own thread sibling mask.
 	 */
 	cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
+	cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 
 	for (i = first_thread; i < first_thread + threads_per_core; i++)
 		if (cpu_online(i))
@@ -1520,11 +1521,6 @@ static void add_cpu_to_masks(int cpu)
 	if (chip_id_lookup_table && ret)
 		chip_id = cpu_to_chip_id(cpu);
 
-	if (chip_id == -1) {
-		cpumask_copy(per_cpu(cpu_core_map, cpu), cpu_cpu_mask(cpu));
-		goto out;
-	}
-
 	if (shared_caches)
 		submask_fn = cpu_l2_cache_mask;
 
@@ -1534,6 +1530,10 @@ static void add_cpu_to_masks(int cpu)
 	/* Skip all CPUs already part of current CPU core mask */
 	cpumask_andnot(mask, cpu_online_mask, cpu_core_mask(cpu));
 
+	/* If chip_id is -1; limit the cpu_core_mask to within DIE*/
+	if (chip_id == -1)
+		cpumask_and(mask, mask, cpu_cpu_mask(cpu));
+
 	for_each_cpu(i, mask) {
 		if (chip_id == cpu_to_chip_id(i)) {
 			or_cpumasks_related(cpu, i, submask_fn, cpu_core_mask);
@@ -1543,7 +1543,6 @@ static void add_cpu_to_masks(int cpu)
 		}
 	}
 
-out:
 	free_cpumask_var(mask);
 }
 
diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index ea0d9c36e177..b64b734a5030 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -8,6 +8,7 @@
  * Copyright 2018 Nick Piggin, Michael Ellerman, IBM Corp.
  */
 
+#include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index d909c069363e..e7924664a944 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -64,10 +64,12 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	}
 	isync();
 
+	pagefault_disable();
 	if (is_load)
-		ret = copy_from_user_nofault(to, (const void __user *)from, n);
+		ret = __copy_from_user_inatomic(to, (const void __user *)from, n);
 	else
-		ret = copy_to_user_nofault((void __user *)to, from, n);
+		ret = __copy_to_user_inatomic((void __user *)to, from, n);
+	pagefault_enable();
 
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..e5ba96c41f3f 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -173,10 +173,13 @@ static void kvmppc_rm_tce_put(struct kvmppc_spapr_tce_table *stt,
 	idx -= stt->offset;
 	page = stt->pages[idx / TCES_PER_PAGE];
 	/*
-	 * page must not be NULL in real mode,
-	 * kvmppc_rm_ioba_validate() must have taken care of this.
+	 * kvmppc_rm_ioba_validate() allows pages not be allocated if TCE is
+	 * being cleared, otherwise it returns H_TOO_HARD and we skip this.
 	 */
-	WARN_ON_ONCE_RM(!page);
+	if (!page) {
+		WARN_ON_ONCE_RM(tce != 0);
+		return;
+	}
 	tbl = kvmppc_page_address(page);
 
 	tbl[idx % TCES_PER_PAGE] = tce;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 395f98158e81..890fbf4baf15 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -59,6 +59,7 @@
 #include <asm/kvm_book3s.h>
 #include <asm/mmu_context.h>
 #include <asm/lppaca.h>
+#include <asm/pmc.h>
 #include <asm/processor.h>
 #include <asm/cputhreads.h>
 #include <asm/page.h>
@@ -3687,6 +3688,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		if (vcpu->arch.vpa.pinned_addr) {
+			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
+		} else {
+			get_lppaca()->pmcregs_in_use = 1;
+		}
+		barrier();
+	}
+#endif
 	kvmhv_load_guest_pmu(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
@@ -3823,6 +3836,13 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index f2bf98bdcea2..094a1076fd1f 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -893,7 +893,7 @@ static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 static void __init find_possible_nodes(void)
 {
 	struct device_node *rtas;
-	const __be32 *domains;
+	const __be32 *domains = NULL;
 	int prop_length, max_nodes;
 	u32 i;
 
@@ -909,9 +909,14 @@ static void __init find_possible_nodes(void)
 	 * it doesn't exist, then fallback on ibm,max-associativity-domains.
 	 * Current denotes what the platform can support compared to max
 	 * which denotes what the Hypervisor can support.
+	 *
+	 * If the LPAR is migratable, new nodes might be activated after a LPM,
+	 * so we should consider the max number in that case.
 	 */
-	domains = of_get_property(rtas, "ibm,current-associativity-domains",
-					&prop_length);
+	if (!of_get_property(of_root, "ibm,migratable-partition", NULL))
+		domains = of_get_property(rtas,
+					  "ibm,current-associativity-domains",
+					  &prop_length);
 	if (!domains) {
 		domains = of_get_property(rtas, "ibm,max-associativity-domains",
 					&prop_length);
@@ -920,6 +925,8 @@ static void __init find_possible_nodes(void)
 	}
 
 	max_nodes = of_read_number(&domains[min_common_depth], 1);
+	pr_info("Partition configured for %d NUMA nodes.\n", max_nodes);
+
 	for (i = 0; i < max_nodes; i++) {
 		if (!node_possible(i))
 			node_set(i, node_possible_map);
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 51622411a7cc..35658b963d5a 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2251,18 +2251,10 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
  */
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	bool use_siar = regs_use_siar(regs);
 	unsigned long siar = mfspr(SPRN_SIAR);
 
-	if (ppmu && (ppmu->flags & PPMU_P10_DD1)) {
-		if (siar)
-			return siar;
-		else
-			return regs->nip;
-	} else if (use_siar && siar_valid(regs))
-		return mfspr(SPRN_SIAR) + perf_ip_adjust(regs);
-	else if (use_siar)
-		return 0;		// no valid instruction pointer
+	if (regs_use_siar(regs) && siar_valid(regs) && siar)
+		return siar + perf_ip_adjust(regs);
 	else
 		return regs->nip;
 }
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index d48413e28c39..c756228a081f 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -175,7 +175,7 @@ static unsigned long single_gpci_request(u32 req, u32 starting_index,
 	 */
 	count = 0;
 	for (i = offset; i < offset + length; i++)
-		count |= arg->bytes[i] << (i - offset);
+		count |= (u64)(arg->bytes[i]) << ((length - 1 - (i - offset)) * 8);
 
 	*value = count;
 out:
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 3e388fa208d4..519d517fedf4 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -36,6 +36,7 @@
 #define MACHINE_FLAG_NX		BIT(15)
 #define MACHINE_FLAG_GS		BIT(16)
 #define MACHINE_FLAG_SCC	BIT(17)
+#define MACHINE_FLAG_PCI_MIO	BIT(18)
 
 #define LPP_MAGIC		BIT(31)
 #define LPP_PID_MASK		_AC(0xffffffff, UL)
@@ -109,6 +110,7 @@ extern unsigned long mio_wb_bit_mask;
 #define MACHINE_HAS_NX		(S390_lowcore.machine_flags & MACHINE_FLAG_NX)
 #define MACHINE_HAS_GS		(S390_lowcore.machine_flags & MACHINE_FLAG_GS)
 #define MACHINE_HAS_SCC		(S390_lowcore.machine_flags & MACHINE_FLAG_SCC)
+#define MACHINE_HAS_PCI_MIO	(S390_lowcore.machine_flags & MACHINE_FLAG_PCI_MIO)
 
 /*
  * Console mode. Override with conmode=
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index e317fd4866c1..f16f4d054ae2 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -18,6 +18,7 @@ extern struct mutex smp_cpu_state_mutex;
 extern unsigned int smp_cpu_mt_shift;
 extern unsigned int smp_cpu_mtid;
 extern __vector128 __initdata boot_cpu_vector_save_area[__NUM_VXRS];
+extern cpumask_t cpu_setup_mask;
 
 extern int __cpu_up(unsigned int cpu, struct task_struct *tidle);
 
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index a361d2e70025..661585587cbe 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -236,6 +236,10 @@ static __init void detect_machine_facilities(void)
 		clock_comparator_max = -1ULL >> 1;
 		__ctl_set_bit(0, 53);
 	}
+	if (IS_ENABLED(CONFIG_PCI) && test_facility(153)) {
+		S390_lowcore.machine_flags |= MACHINE_FLAG_PCI_MIO;
+		/* the control bit is set during PCI initialization */
+	}
 }
 
 static inline void save_vector_registers(void)
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index ab584e8e3527..9156653b56f6 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -36,7 +36,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1fb483e06a64..926ba86f645e 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -96,6 +96,7 @@ __vector128 __initdata boot_cpu_vector_save_area[__NUM_VXRS];
 #endif
 
 static unsigned int smp_max_threads __initdata = -1U;
+cpumask_t cpu_setup_mask;
 
 static int __init early_nosmt(char *s)
 {
@@ -883,13 +884,14 @@ static void smp_init_secondary(void)
 	vtime_init();
 	vdso_getcpu_init();
 	pfault_init();
+	cpumask_set_cpu(cpu, &cpu_setup_mask);
+	update_cpu_masks();
 	notify_cpu_starting(cpu);
 	if (topology_cpu_dedicated(cpu))
 		set_cpu_flag(CIF_DEDICATED_CPU);
 	else
 		clear_cpu_flag(CIF_DEDICATED_CPU);
 	set_cpu_online(cpu, true);
-	update_cpu_masks();
 	inc_irq_stat(CPU_RST);
 	local_irq_enable();
 	cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
@@ -945,10 +947,13 @@ early_param("possible_cpus", _setup_possible_cpus);
 int __cpu_disable(void)
 {
 	unsigned long cregs[16];
+	int cpu;
 
 	/* Handle possible pending IPIs */
 	smp_handle_ext_call();
-	set_cpu_online(smp_processor_id(), false);
+	cpu = smp_processor_id();
+	set_cpu_online(cpu, false);
+	cpumask_clear_cpu(cpu, &cpu_setup_mask);
 	update_cpu_masks();
 	/* Disable pseudo page faults on this cpu. */
 	pfault_fini();
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 26aa2614ee35..eb4047c9da9a 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -67,7 +67,7 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	static cpumask_t mask;
 
 	cpumask_clear(&mask);
-	if (!cpu_online(cpu))
+	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
 		goto out;
 	cpumask_set_cpu(cpu, &mask);
 	switch (topology_mode) {
@@ -88,7 +88,7 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	case TOPOLOGY_MODE_SINGLE:
 		break;
 	}
-	cpumask_and(&mask, &mask, cpu_online_mask);
+	cpumask_and(&mask, &mask, &cpu_setup_mask);
 out:
 	cpumask_copy(dst, &mask);
 }
@@ -99,16 +99,16 @@ static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 	int i;
 
 	cpumask_clear(&mask);
-	if (!cpu_online(cpu))
+	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
 		goto out;
 	cpumask_set_cpu(cpu, &mask);
 	if (topology_mode != TOPOLOGY_MODE_HW)
 		goto out;
 	cpu -= cpu % (smp_cpu_mtid + 1);
-	for (i = 0; i <= smp_cpu_mtid; i++)
-		if (cpu_present(cpu + i))
+	for (i = 0; i <= smp_cpu_mtid; i++) {
+		if (cpumask_test_cpu(cpu + i, &cpu_setup_mask))
 			cpumask_set_cpu(cpu + i, &mask);
-	cpumask_and(&mask, &mask, cpu_online_mask);
+	}
 out:
 	cpumask_copy(dst, &mask);
 }
@@ -569,6 +569,7 @@ void __init topology_init_early(void)
 	alloc_masks(info, &book_info, 2);
 	alloc_masks(info, &drawer_info, 3);
 out:
+	cpumask_set_cpu(0, &cpu_setup_mask);
 	__arch_update_cpu_topology();
 	__arch_update_dedicated_flag(NULL);
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 8ac710de1ab1..07bbee9b7320 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -186,9 +186,9 @@ static void pv_init(void)
 		return;
 
 	/* make sure bounce buffers are shared */
+	swiotlb_force = SWIOTLB_FORCE;
 	swiotlb_init(1);
 	swiotlb_update_mem_attributes();
-	swiotlb_force = SWIOTLB_FORCE;
 }
 
 void __init mem_init(void)
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 77cd965cffef..34839bad33e4 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -893,7 +893,6 @@ static void zpci_mem_exit(void)
 }
 
 static unsigned int s390_pci_probe __initdata = 1;
-static unsigned int s390_pci_no_mio __initdata;
 unsigned int s390_pci_force_floating __initdata;
 static unsigned int s390_pci_initialized;
 
@@ -904,7 +903,7 @@ char * __init pcibios_setup(char *str)
 		return NULL;
 	}
 	if (!strcmp(str, "nomio")) {
-		s390_pci_no_mio = 1;
+		S390_lowcore.machine_flags &= ~MACHINE_FLAG_PCI_MIO;
 		return NULL;
 	}
 	if (!strcmp(str, "force_floating")) {
@@ -935,7 +934,7 @@ static int __init pci_base_init(void)
 		return 0;
 	}
 
-	if (test_facility(153) && !s390_pci_no_mio) {
+	if (MACHINE_HAS_PCI_MIO) {
 		static_branch_enable(&have_mio);
 		ctl_set_bit(2, 5);
 	}
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 4fa0a4280895..ea87d9ed77e9 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -370,8 +370,6 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
 		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-	} else {
-		mark_tsc_unstable("running on Hyper-V");
 	}
 
 	/*
@@ -432,6 +430,13 @@ static void __init ms_hyperv_init_platform(void)
 	/* Register Hyper-V specific clocksource */
 	hv_init_clocksource();
 #endif
+	/*
+	 * TSC should be marked as unstable only after Hyper-V
+	 * clocksource has been initialized. This ensures that the
+	 * stability of the sched_clock is not altered.
+	 */
+	if (!(ms_hyperv.features & HV_ACCESS_TSC_INVARIANT))
+		mark_tsc_unstable("running on Hyper-V");
 }
 
 static bool __init ms_hyperv_x2apic_available(void)
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index ac06ca32e9ef..5e6e236977c7 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -618,8 +618,8 @@ int xen_alloc_p2m_entry(unsigned long pfn)
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index a3dda25a4e45..eed02cf3d6b0 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -143,9 +143,13 @@ static const struct tty_operations serial_ops = {
 
 static int __init rs_init(void)
 {
-	tty_port_init(&serial_port);
+	int ret;
 
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
+	if (!serial_driver)
+		return -ENOMEM;
+
+	tty_port_init(&serial_port);
 
 	/* Initialize the tty_driver structure */
 
@@ -163,8 +167,15 @@ static int __init rs_init(void)
 	tty_set_operations(serial_driver, &serial_ops);
 	tty_port_link_device(&serial_port, serial_driver, 0);
 
-	if (tty_register_driver(serial_driver))
-		panic("Couldn't register serial driver\n");
+	ret = tty_register_driver(serial_driver);
+	if (ret) {
+		pr_err("Couldn't register serial driver\n");
+		tty_driver_kref_put(serial_driver);
+		tty_port_destroy(&serial_port);
+
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 4df33cc08eee..6dfda57349cc 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5258,7 +5258,7 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 	if (bfqq->new_ioprio >= IOPRIO_BE_NR) {
 		pr_crit("bfq_set_next_ioprio_data: new_ioprio %d\n",
 			bfqq->new_ioprio);
-		bfqq->new_ioprio = IOPRIO_BE_NR;
+		bfqq->new_ioprio = IOPRIO_BE_NR - 1;
 	}
 
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 250cb76ee615..457eceabed2e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -288,9 +288,6 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
 
@@ -349,9 +346,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/block/bsg.c b/block/bsg.c
index bd10922d5cbb..4d0ad5846ccf 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -371,10 +371,13 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SCSI_IOCTL_SEND_COMMAND:
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
 	case SG_IO:
 		return bsg_sg_io(bd->queue, file->f_mode, uarg);
+	case SCSI_IOCTL_SEND_COMMAND:
+		pr_warn_ratelimited("%s: calling unsupported SCSI_IOCTL_SEND_COMMAND\n",
+				current->comm);
+		return -EINVAL;
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 44f434acfce0..0e6e73b8023f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3950,6 +3950,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index f0ef844428bb..338c2e50f759 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1259,24 +1259,20 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "no SATA DMA irq\n");
-		err = -ENODEV;
-		goto error_out;
+		return -ENODEV;
 	}
 
 #ifdef CONFIG_SATA_DWC_OLD_DMA
 	if (!of_find_property(np, "dmas", NULL)) {
 		err = sata_dwc_dma_init_old(ofdev, hsdev);
 		if (err)
-			goto error_out;
+			return err;
 	}
 #endif
 
 	hsdev->phy = devm_phy_optional_get(hsdev->dev, "sata-phy");
-	if (IS_ERR(hsdev->phy)) {
-		err = PTR_ERR(hsdev->phy);
-		hsdev->phy = NULL;
-		goto error_out;
-	}
+	if (IS_ERR(hsdev->phy))
+		return PTR_ERR(hsdev->phy);
 
 	err = phy_init(hsdev->phy);
 	if (err)
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 380ad1fdb745..57f78d1cc9d8 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -67,6 +67,8 @@ struct fsl_mc_addr_translation_range {
 #define MC_FAPR_PL	BIT(18)
 #define MC_FAPR_BMT	BIT(17)
 
+static phys_addr_t mc_portal_base_phys_addr;
+
 /**
  * fsl_mc_bus_match - device to driver matching callback
  * @dev: the fsl-mc device to match against
@@ -219,7 +221,7 @@ static int scan_fsl_mc_bus(struct device *dev, void *data)
 	root_mc_dev = to_fsl_mc_device(dev);
 	root_mc_bus = to_fsl_mc_bus(root_mc_dev);
 	mutex_lock(&root_mc_bus->scan_mutex);
-	dprc_scan_objects(root_mc_dev, NULL);
+	dprc_scan_objects(root_mc_dev, false);
 	mutex_unlock(&root_mc_bus->scan_mutex);
 
 exit:
@@ -702,14 +704,30 @@ static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
 		 * If base address is in the region_desc use it otherwise
 		 * revert to old mechanism
 		 */
-		if (region_desc.base_address)
+		if (region_desc.base_address) {
 			regions[i].start = region_desc.base_address +
 						region_desc.base_offset;
-		else
+		} else {
 			error = translate_mc_addr(mc_dev, mc_region_type,
 					  region_desc.base_offset,
 					  &regions[i].start);
 
+			/*
+			 * Some versions of the MC firmware wrongly report
+			 * 0 for register base address of the DPMCP associated
+			 * with child DPRC objects thus rendering them unusable.
+			 * This is particularly troublesome in ACPI boot
+			 * scenarios where the legacy way of extracting this
+			 * base address from the device tree does not apply.
+			 * Given that DPMCPs share the same base address,
+			 * workaround this by using the base address extracted
+			 * from the root DPRC container.
+			 */
+			if (is_fsl_mc_bus_dprc(mc_dev) &&
+			    regions[i].start == region_desc.base_offset)
+				regions[i].start += mc_portal_base_phys_addr;
+		}
+
 		if (error < 0) {
 			dev_err(parent_dev,
 				"Invalid MC offset: %#x (for %s.%d\'s region %d)\n",
@@ -1125,6 +1143,8 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
+	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;
+
 	error = fsl_create_mc_io(&pdev->dev, mc_portal_phys_addr,
 				 mc_portal_size, NULL,
 				 FSL_MC_IO_ATOMIC_CONTEXT_PORTAL, &mc_io);
diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index b4fc8d71daf2..b656d25a9767 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -128,6 +128,12 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 	int i;
 	u32 div;
 
+	/* do not look for a rate that is outside of our range */
+	if (gck->range.max && req->rate > gck->range.max)
+		req->rate = gck->range.max;
+	if (gck->range.min && req->rate < gck->range.min)
+		req->rate = gck->range.min;
+
 	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
 		if (gck->chg_pid == i)
 			continue;
diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index 2c309e3dc8e3..04e728538cef 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -216,7 +216,8 @@ struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 		div->width = PCG_PREDIV_WIDTH;
 		divider_ops = &imx8m_clk_composite_divider_ops;
 		mux_ops = &clk_mux_ops;
-		flags |= CLK_SET_PARENT_GATE;
+		if (!(composite_flags & IMX_COMPOSITE_FW_MANAGED))
+			flags |= CLK_SET_PARENT_GATE;
 	}
 
 	div->lock = &imx_ccm_lock;
diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
index f1919fafb124..e92621fa8b9c 100644
--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -407,10 +407,10 @@ static int imx8mm_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MM_SYS_PLL2_500M] = imx_clk_hw_fixed_factor("sys_pll2_500m", "sys_pll2_500m_cg", 1, 2);
 	hws[IMX8MM_SYS_PLL2_1000M] = imx_clk_hw_fixed_factor("sys_pll2_1000m", "sys_pll2_out", 1, 1);
 
-	hws[IMX8MM_CLK_CLKOUT1_SEL] = imx_clk_hw_mux("clkout1_sel", base + 0x128, 4, 4, clkout_sels, ARRAY_SIZE(clkout_sels));
+	hws[IMX8MM_CLK_CLKOUT1_SEL] = imx_clk_hw_mux2("clkout1_sel", base + 0x128, 4, 4, clkout_sels, ARRAY_SIZE(clkout_sels));
 	hws[IMX8MM_CLK_CLKOUT1_DIV] = imx_clk_hw_divider("clkout1_div", "clkout1_sel", base + 0x128, 0, 4);
 	hws[IMX8MM_CLK_CLKOUT1] = imx_clk_hw_gate("clkout1", "clkout1_div", base + 0x128, 8);
-	hws[IMX8MM_CLK_CLKOUT2_SEL] = imx_clk_hw_mux("clkout2_sel", base + 0x128, 20, 4, clkout_sels, ARRAY_SIZE(clkout_sels));
+	hws[IMX8MM_CLK_CLKOUT2_SEL] = imx_clk_hw_mux2("clkout2_sel", base + 0x128, 20, 4, clkout_sels, ARRAY_SIZE(clkout_sels));
 	hws[IMX8MM_CLK_CLKOUT2_DIV] = imx_clk_hw_divider("clkout2_div", "clkout2_sel", base + 0x128, 16, 4);
 	hws[IMX8MM_CLK_CLKOUT2] = imx_clk_hw_gate("clkout2", "clkout2_div", base + 0x128, 24);
 
@@ -470,10 +470,11 @@ static int imx8mm_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
-	hws[IMX8MM_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mm_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MM_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mm_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MM_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mm_dram_alt_sels, base + 0xa000);
+	hws[IMX8MM_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mm_dram_apb_sels, base + 0xa080);
 
 	/* IP */
 	hws[IMX8MM_CLK_VPU_G1] = imx8m_clk_hw_composite("vpu_g1", imx8mm_vpu_g1_sels, base + 0xa100);
diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 88f6630cd472..0a76f969b28b 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -453,10 +453,11 @@ static int imx8mn_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
-	hws[IMX8MN_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mn_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MN_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mn_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MN_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mn_dram_alt_sels, base + 0xa000);
+	hws[IMX8MN_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mn_dram_apb_sels, base + 0xa080);
 
 	hws[IMX8MN_CLK_DISP_PIXEL] = imx8m_clk_hw_composite("disp_pixel", imx8mn_disp_pixel_sels, base + 0xa500);
 	hws[IMX8MN_CLK_SAI2] = imx8m_clk_hw_composite("sai2", imx8mn_sai2_sels, base + 0xa600);
diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index c491bc9c61ce..83cc2b1c3294 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -449,11 +449,12 @@ static int imx8mq_clocks_probe(struct platform_device *pdev)
 
 	/*
 	 * DRAM clocks are manipulated from TF-A outside clock framework.
-	 * Mark with GET_RATE_NOCACHE to always read div value from hardware
+	 * The fw_managed helper sets GET_RATE_NOCACHE and clears SET_PARENT_GATE
+	 * as div value should always be read from hardware
 	 */
 	hws[IMX8MQ_CLK_DRAM_CORE] = imx_clk_hw_mux2_flags("dram_core_clk", base + 0x9800, 24, 1, imx8mq_dram_core_sels, ARRAY_SIZE(imx8mq_dram_core_sels), CLK_IS_CRITICAL);
-	hws[IMX8MQ_CLK_DRAM_ALT] = __imx8m_clk_hw_composite("dram_alt", imx8mq_dram_alt_sels, base + 0xa000, CLK_GET_RATE_NOCACHE);
-	hws[IMX8MQ_CLK_DRAM_APB] = __imx8m_clk_hw_composite("dram_apb", imx8mq_dram_apb_sels, base + 0xa080, CLK_IS_CRITICAL | CLK_GET_RATE_NOCACHE);
+	hws[IMX8MQ_CLK_DRAM_ALT] = imx8m_clk_hw_fw_managed_composite("dram_alt", imx8mq_dram_alt_sels, base + 0xa000);
+	hws[IMX8MQ_CLK_DRAM_APB] = imx8m_clk_hw_fw_managed_composite_critical("dram_apb", imx8mq_dram_apb_sels, base + 0xa080);
 
 	/* IP */
 	hws[IMX8MQ_CLK_VPU_G1] = imx8m_clk_hw_composite("vpu_g1", imx8mq_vpu_g1_sels, base + 0xa100);
diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index 7571603bee23..e144f983fd8c 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -530,8 +530,9 @@ struct clk_hw *imx_clk_hw_cpu(const char *name, const char *parent_name,
 		struct clk *div, struct clk *mux, struct clk *pll,
 		struct clk *step);
 
-#define IMX_COMPOSITE_CORE	BIT(0)
-#define IMX_COMPOSITE_BUS	BIT(1)
+#define IMX_COMPOSITE_CORE		BIT(0)
+#define IMX_COMPOSITE_BUS		BIT(1)
+#define IMX_COMPOSITE_FW_MANAGED	BIT(2)
 
 struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 					    const char * const *parent_names,
@@ -567,6 +568,17 @@ struct clk_hw *imx8m_clk_hw_composite_flags(const char *name,
 		ARRAY_SIZE(parent_names), reg, 0, \
 		flags | CLK_SET_RATE_NO_REPARENT | CLK_OPS_PARENT_ENABLE)
 
+#define __imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, flags) \
+	imx8m_clk_hw_composite_flags(name, parent_names, \
+		ARRAY_SIZE(parent_names), reg, IMX_COMPOSITE_FW_MANAGED, \
+		flags | CLK_GET_RATE_NOCACHE | CLK_SET_RATE_NO_REPARENT | CLK_OPS_PARENT_ENABLE)
+
+#define imx8m_clk_hw_fw_managed_composite(name, parent_names, reg) \
+	__imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, 0)
+
+#define imx8m_clk_hw_fw_managed_composite_critical(name, parent_names, reg) \
+	__imx8m_clk_hw_fw_managed_composite(name, parent_names, reg, CLK_IS_CRITICAL)
+
 #define __imx8m_clk_composite(name, parent_names, reg, flags) \
 	to_clk(__imx8m_clk_hw_composite(name, parent_names, reg, flags))
 
diff --git a/drivers/clk/ralink/clk-mt7621.c b/drivers/clk/ralink/clk-mt7621.c
index 857da1e274be..a2c045390f00 100644
--- a/drivers/clk/ralink/clk-mt7621.c
+++ b/drivers/clk/ralink/clk-mt7621.c
@@ -131,14 +131,7 @@ static int mt7621_gate_ops_init(struct device *dev,
 				struct mt7621_gate *sclk)
 {
 	struct clk_init_data init = {
-		/*
-		 * Until now no clock driver existed so
-		 * these SoC drivers are not prepared
-		 * yet for the clock. We don't want kernel to
-		 * disable anything so we add CLK_IS_CRITICAL
-		 * flag here.
-		 */
-		.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+		.flags = CLK_SET_RATE_PARENT,
 		.num_parents = 1,
 		.parent_names = &sclk->parent_name,
 		.ops = &mt7621_gate_ops,
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index fe937bcdb487..f7827b3b7fc1 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -940,7 +940,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	switch (pll_type) {
 	case pll_rk3036:
 	case pll_rk3328:
-		if (!pll->rate_table || IS_ERR(ctx->grf))
+		if (!pll->rate_table)
 			init.ops = &rockchip_rk3036_pll_clk_norate_ops;
 		else
 			init.ops = &rockchip_rk3036_pll_clk_ops;
diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 1cb21ea79c64..242e94c0cf8a 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -107,10 +107,10 @@ static const struct clk_parent_data gpio_db_free_mux[] = {
 };
 
 static const struct clk_parent_data psi_ref_free_mux[] = {
-	{ .fw_name = "main_pll_c3",
-	  .name = "main_pll_c3", },
-	{ .fw_name = "peri_pll_c3",
-	  .name = "peri_pll_c3", },
+	{ .fw_name = "main_pll_c2",
+	  .name = "main_pll_c2", },
+	{ .fw_name = "peri_pll_c2",
+	  .name = "peri_pll_c2", },
 	{ .fw_name = "osc1",
 	  .name = "osc1", },
 	{ .fw_name = "cb-intosc-hs-div2-clk",
@@ -195,6 +195,13 @@ static const struct clk_parent_data sdmmc_mux[] = {
 	  .name = "boot_clk", },
 };
 
+static const struct clk_parent_data s2f_user0_mux[] = {
+	{ .fw_name = "s2f_user0_free_clk",
+	  .name = "s2f_user0_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
 static const struct clk_parent_data s2f_user1_mux[] = {
 	{ .fw_name = "s2f_user1_free_clk",
 	  .name = "s2f_user1_free_clk", },
@@ -273,7 +280,7 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
 	{ AGILEX_SDMMC_FREE_CLK, "sdmmc_free_clk", NULL, sdmmc_free_mux,
 	  ARRAY_SIZE(sdmmc_free_mux), 0, 0xE4, 0, 0, 0},
 	{ AGILEX_S2F_USER0_FREE_CLK, "s2f_user0_free_clk", NULL, s2f_usr0_free_mux,
-	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0, 0},
+	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0x30, 2},
 	{ AGILEX_S2F_USER1_FREE_CLK, "s2f_user1_free_clk", NULL, s2f_usr1_free_mux,
 	  ARRAY_SIZE(s2f_usr1_free_mux), 0, 0xEC, 0, 0x88, 5},
 	{ AGILEX_PSI_REF_FREE_CLK, "psi_ref_free_clk", NULL, psi_ref_free_mux,
@@ -319,6 +326,8 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
 	  4, 0x98, 0, 16, 0x88, 3, 0},
 	{ AGILEX_SDMMC_CLK, "sdmmc_clk", NULL, sdmmc_mux, ARRAY_SIZE(sdmmc_mux), 0, 0x7C,
 	  5, 0, 0, 0, 0x88, 4, 4},
+	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_user0_mux, ARRAY_SIZE(s2f_user0_mux), 0, 0x24,
+	  6, 0, 0, 0, 0x30, 2, 0},
 	{ AGILEX_S2F_USER1_CLK, "s2f_user1_clk", NULL, s2f_user1_mux, ARRAY_SIZE(s2f_user1_mux), 0, 0x7C,
 	  6, 0, 0, 0, 0x88, 5, 0},
 	{ AGILEX_PSI_REF_CLK, "psi_ref_clk", NULL, psi_mux, ARRAY_SIZE(psi_mux), 0, 0x7C,
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index e439b43c19eb..8977e4de5915 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -36,6 +36,7 @@
 #define MAX_PSTATE_SHIFT	32
 #define LPSTATE_SHIFT		48
 #define GPSTATE_SHIFT		56
+#define MAX_NR_CHIPS		32
 
 #define MAX_RAMP_DOWN_TIME				5120
 /*
@@ -1051,12 +1052,20 @@ static int init_chip_info(void)
 	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	cpumask_t *chip_cpu_mask;
 	int ret = 0;
 
 	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	/* Allocate a chip cpu mask large enough to fit mask for all chips */
+	chip_cpu_mask = kcalloc(MAX_NR_CHIPS, sizeof(cpumask_t), GFP_KERNEL);
+	if (!chip_cpu_mask) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
 
@@ -1064,22 +1073,25 @@ static int init_chip_info(void)
 			prev_chip_id = id;
 			chip[nr_chips++] = id;
 		}
+		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
 	}
 
 	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
 	if (!chips) {
 		ret = -ENOMEM;
-		goto free_and_return;
+		goto out_free_chip_cpu_mask;
 	}
 
 	for (i = 0; i < nr_chips; i++) {
 		chips[i].id = chip[i];
-		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
+		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
 		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
 		for_each_cpu(cpu, &chips[i].mask)
 			per_cpu(chip_info, cpu) =  &chips[i];
 	}
 
+out_free_chip_cpu_mask:
+	kfree(chip_cpu_mask);
 free_and_return:
 	kfree(chip);
 	return ret;
diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index a2b5c6f60cf0..ff164dec8422 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -402,7 +402,7 @@ static void __init fixup_cede0_latency(void)
  * pseries_idle_probe()
  * Choose state table for shared versus dedicated partition
  */
-static int pseries_idle_probe(void)
+static int __init pseries_idle_probe(void)
 {
 
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
@@ -419,7 +419,21 @@ static int pseries_idle_probe(void)
 			cpuidle_state_table = shared_states;
 			max_idle_state = ARRAY_SIZE(shared_states);
 		} else {
-			fixup_cede0_latency();
+			/*
+			 * Use firmware provided latency values
+			 * starting with POWER10 platforms. In the
+			 * case that we are running on a POWER10
+			 * platform but in an earlier compat mode, we
+			 * can still use the firmware provided values.
+			 *
+			 * However, on platforms prior to POWER10, we
+			 * cannot rely on the accuracy of the firmware
+			 * provided latency values. On such platforms,
+			 * go with the conservative default estimate
+			 * of 10us.
+			 */
+			if (cpu_has_feature(CPU_FTR_ARCH_31) || pvr_version_is(PVR_POWER10))
+				fixup_cede0_latency();
 			cpuidle_state_table = dedicated_states;
 			max_idle_state = NR_DEDICATED_STATES;
 		}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 91808402e0bf..2ecb0e1f65d8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -300,6 +300,9 @@ static int __sev_platform_shutdown_locked(int *error)
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return 0;
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
@@ -1019,6 +1022,20 @@ int sev_dev_init(struct psp_device *psp)
 	return ret;
 }
 
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
+		sev_es_tmr = NULL;
+	}
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1026,6 +1043,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1056,21 +1075,6 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (sev->state != SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		sev->state = SEV_STATE_UNINIT;
-	}
-
 	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
@@ -1115,17 +1119,10 @@ void sev_pci_init(void)
 
 void sev_pci_exit(void)
 {
-	if (!psp_master->sev_data)
-		return;
-
-	sev_platform_shutdown(NULL);
+	struct sev_device *sev = psp_master->sev_data;
 
-	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+	if (!sev)
+		return;
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
-		sev_es_tmr = NULL;
-	}
+	sev_firmware_shutdown(sev);
 }
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 6fb6ba35f89d..9bcc1884c06a 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -241,6 +241,17 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void sp_pci_shutdown(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	if (!sp)
+		return;
+
+	sp_destroy(sp);
+}
+
 static void sp_pci_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -371,6 +382,7 @@ static struct pci_driver sp_pci_driver = {
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f397cc5bf102..d19e5ffb5104 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -300,21 +300,20 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *src = req->src;
-	const int nents = sg_nents(req->src);
+	int dst_nents = sg_nents(dst);
 
 	const int out_off = DCP_BUF_SZ;
 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
 
-	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
 	uint32_t dst_off = 0;
+	uint8_t *src_buf = NULL;
 	uint32_t last_out_len = 0;
 
 	uint8_t *key = sdcp->coh->aes_key;
 
 	int ret = 0;
-	int split = 0;
-	unsigned int i, len, clen, rem = 0, tlen = 0;
+	unsigned int i, len, clen, tlen = 0;
 	int init = 0;
 	bool limit_hit = false;
 
@@ -332,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, nents, i) {
+	for_each_sg(req->src, src, sg_nents(src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
@@ -357,34 +356,17 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * submit the buffer.
 			 */
 			if (actx->fill == out_off || sg_is_last(src) ||
-				limit_hit) {
+			    limit_hit) {
 				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init = 0;
 
-				out_tmp = out_buf;
+				sg_pcopy_from_buffer(dst, dst_nents, out_buf,
+						     actx->fill, dst_off);
+				dst_off += actx->fill;
 				last_out_len = actx->fill;
-				while (dst && actx->fill) {
-					if (!split) {
-						dst_buf = sg_virt(dst);
-						dst_off = 0;
-					}
-					rem = min(sg_dma_len(dst) - dst_off,
-						  actx->fill);
-
-					memcpy(dst_buf + dst_off, out_tmp, rem);
-					out_tmp += rem;
-					dst_off += rem;
-					actx->fill -= rem;
-
-					if (dst_off == sg_dma_len(dst)) {
-						dst = sg_next(dst);
-						split = 0;
-					} else {
-						split = 1;
-					}
-				}
+				actx->fill = 0;
 			}
 		} while (len);
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d5590c08db51..1c636d287112 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -379,7 +379,6 @@ struct sdma_channel {
 	unsigned long			watermark_level;
 	u32				shp_addr, per_addr;
 	enum dma_status			status;
-	bool				context_loaded;
 	struct imx_dma_data		data;
 	struct work_struct		terminate_worker;
 };
@@ -954,9 +953,6 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 	int ret;
 	unsigned long flags;
 
-	if (sdmac->context_loaded)
-		return 0;
-
 	if (sdmac->direction == DMA_DEV_TO_MEM)
 		load_address = sdmac->pc_from_device;
 	else if (sdmac->direction == DMA_DEV_TO_DEV)
@@ -999,8 +995,6 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 
 	spin_unlock_irqrestore(&sdma->channel_0_lock, flags);
 
-	sdmac->context_loaded = true;
-
 	return ret;
 }
 
@@ -1039,7 +1033,6 @@ static void sdma_channel_terminate_work(struct work_struct *work)
 	vchan_get_all_descriptors(&sdmac->vc, &head);
 	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
 	vchan_dma_desc_free_list(&sdmac->vc, &head);
-	sdmac->context_loaded = false;
 }
 
 static int sdma_terminate_all(struct dma_chan *chan)
@@ -1114,7 +1107,6 @@ static void sdma_set_watermarklevel_for_p2p(struct sdma_channel *sdmac)
 static int sdma_config_channel(struct dma_chan *chan)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
-	int ret;
 
 	sdma_disable_channel(chan);
 
@@ -1154,9 +1146,7 @@ static int sdma_config_channel(struct dma_chan *chan)
 		sdmac->watermark_level = 0; /* FIXME: M3_BASE_ADDRESS */
 	}
 
-	ret = sdma_load_context(sdmac);
-
-	return ret;
+	return 0;
 }
 
 static int sdma_set_channel_priority(struct sdma_channel *sdmac,
@@ -1307,7 +1297,6 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 
 	sdmac->event_id0 = 0;
 	sdmac->event_id1 = 0;
-	sdmac->context_loaded = false;
 
 	sdma_set_channel_priority(sdmac, 0);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 311bcdc59eda..3f4b03a2588b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -277,21 +277,18 @@ int amdgpu_gem_create_ioctl(struct drm_device *dev, void *data,
 	r = amdgpu_gem_object_create(adev, size, args->in.alignment,
 				     initial_domain,
 				     flags, ttm_bo_type_device, resv, &gobj);
-	if (r) {
-		if (r != -ERESTARTSYS) {
-			if (flags & AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED) {
-				flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
-				goto retry;
-			}
+	if (r && r != -ERESTARTSYS) {
+		if (flags & AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED) {
+			flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
+			goto retry;
+		}
 
-			if (initial_domain == AMDGPU_GEM_DOMAIN_VRAM) {
-				initial_domain |= AMDGPU_GEM_DOMAIN_GTT;
-				goto retry;
-			}
-			DRM_DEBUG("Failed to allocate GEM object (%llu, %d, %llu, %d)\n",
-				  size, initial_domain, args->in.alignment, r);
+		if (initial_domain == AMDGPU_GEM_DOMAIN_VRAM) {
+			initial_domain |= AMDGPU_GEM_DOMAIN_GTT;
+			goto retry;
 		}
-		return r;
+		DRM_DEBUG("Failed to allocate GEM object (%llu, %d, %llu, %d)\n",
+				size, initial_domain, args->in.alignment, r);
 	}
 
 	if (flags & AMDGPU_GEM_CREATE_VM_ALWAYS_VALID) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index bca4dddd5a15..82608df43396 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -339,7 +339,7 @@ static void amdgpu_i2c_put_byte(struct amdgpu_i2c_chan *i2c_bus,
 void
 amdgpu_i2c_router_select_ddc_port(const struct amdgpu_connector *amdgpu_connector)
 {
-	u8 val;
+	u8 val = 0;
 
 	if (!amdgpu_connector->router.ddc_valid)
 		return;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 3933a42f8d81..67b6eda21529 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -202,7 +202,7 @@ void amdgpu_bo_placement_from_domain(struct amdgpu_bo *abo, u32 domain)
 		c++;
 	}
 
-	BUG_ON(c >= AMDGPU_BO_MAX_PLACEMENTS);
+	BUG_ON(c > AMDGPU_BO_MAX_PLACEMENTS);
 
 	placement->num_placement = c;
 	placement->placement = places;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index f40c871da0c6..fb701c4fd5c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -321,7 +321,7 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control,
 		return ret;
 	}
 
-	__decode_table_header_from_buff(hdr, &buff[2]);
+	__decode_table_header_from_buff(hdr, buff);
 
 	if (hdr->header == EEPROM_TABLE_HDR_VAL) {
 		control->num_recs = (hdr->tbl_size - EEPROM_TABLE_HEADER_SIZE) /
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
index 27b1ced145d2..14ae2bfad59d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -119,7 +119,7 @@ static int vcn_v1_0_sw_init(void *handle)
 		adev->firmware.ucode[AMDGPU_UCODE_ID_VCN].fw = adev->vcn.fw;
 		adev->firmware.fw_size +=
 			ALIGN(le32_to_cpu(hdr->ucode_size_bytes), PAGE_SIZE);
-		DRM_INFO("PSP loading VCN firmware\n");
+		dev_info(adev->dev, "Will use PSP to load VCN firmware\n");
 	}
 
 	r = amdgpu_vcn_resume(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 8af567c546db..f4686e918e0d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -122,7 +122,7 @@ static int vcn_v2_0_sw_init(void *handle)
 		adev->firmware.ucode[AMDGPU_UCODE_ID_VCN].fw = adev->vcn.fw;
 		adev->firmware.fw_size +=
 			ALIGN(le32_to_cpu(hdr->ucode_size_bytes), PAGE_SIZE);
-		DRM_INFO("PSP loading VCN firmware\n");
+		dev_info(adev->dev, "Will use PSP to load VCN firmware\n");
 	}
 
 	r = amdgpu_vcn_resume(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index 888b17d84691..e0c0c3734432 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -152,7 +152,7 @@ static int vcn_v2_5_sw_init(void *handle)
 			adev->firmware.fw_size +=
 				ALIGN(le32_to_cpu(hdr->ucode_size_bytes), PAGE_SIZE);
 		}
-		DRM_INFO("PSP loading VCN firmware\n");
+		dev_info(adev->dev, "Will use PSP to load VCN firmware\n");
 	}
 
 	r = amdgpu_vcn_resume(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 3b23de996db2..c2c5c4af51d2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -152,7 +152,7 @@ static int vcn_v3_0_sw_init(void *handle)
 			adev->firmware.fw_size +=
 				ALIGN(le32_to_cpu(hdr->ucode_size_bytes), PAGE_SIZE);
 		}
-		DRM_INFO("PSP loading VCN firmware\n");
+		dev_info(adev->dev, "Will use PSP to load VCN firmware\n");
 	}
 
 	r = amdgpu_vcn_resume(adev);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
index 88813dad731f..c021519af810 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
@@ -98,36 +98,78 @@ void mqd_symmetrically_map_cu_mask(struct mqd_manager *mm,
 		uint32_t *se_mask)
 {
 	struct kfd_cu_info cu_info;
-	uint32_t cu_per_se[KFD_MAX_NUM_SE] = {0};
-	int i, se, sh, cu = 0;
-
+	uint32_t cu_per_sh[KFD_MAX_NUM_SE][KFD_MAX_NUM_SH_PER_SE] = {0};
+	int i, se, sh, cu;
 	amdgpu_amdkfd_get_cu_info(mm->dev->kgd, &cu_info);
 
 	if (cu_mask_count > cu_info.cu_active_number)
 		cu_mask_count = cu_info.cu_active_number;
 
+	/* Exceeding these bounds corrupts the stack and indicates a coding error.
+	 * Returning with no CU's enabled will hang the queue, which should be
+	 * attention grabbing.
+	 */
+	if (cu_info.num_shader_engines > KFD_MAX_NUM_SE) {
+		pr_err("Exceeded KFD_MAX_NUM_SE, chip reports %d\n", cu_info.num_shader_engines);
+		return;
+	}
+	if (cu_info.num_shader_arrays_per_engine > KFD_MAX_NUM_SH_PER_SE) {
+		pr_err("Exceeded KFD_MAX_NUM_SH, chip reports %d\n",
+			cu_info.num_shader_arrays_per_engine * cu_info.num_shader_engines);
+		return;
+	}
+	/* Count active CUs per SH.
+	 *
+	 * Some CUs in an SH may be disabled.	HW expects disabled CUs to be
+	 * represented in the high bits of each SH's enable mask (the upper and lower
+	 * 16 bits of se_mask) and will take care of the actual distribution of
+	 * disabled CUs within each SH automatically.
+	 * Each half of se_mask must be filled only on bits 0-cu_per_sh[se][sh]-1.
+	 *
+	 * See note on Arcturus cu_bitmap layout in gfx_v9_0_get_cu_info.
+	 */
 	for (se = 0; se < cu_info.num_shader_engines; se++)
 		for (sh = 0; sh < cu_info.num_shader_arrays_per_engine; sh++)
-			cu_per_se[se] += hweight32(cu_info.cu_bitmap[se % 4][sh + (se / 4)]);
-
-	/* Symmetrically map cu_mask to all SEs:
-	 * cu_mask[0] bit0 -> se_mask[0] bit0;
-	 * cu_mask[0] bit1 -> se_mask[1] bit0;
-	 * ... (if # SE is 4)
-	 * cu_mask[0] bit4 -> se_mask[0] bit1;
+			cu_per_sh[se][sh] = hweight32(cu_info.cu_bitmap[se % 4][sh + (se / 4)]);
+
+	/* Symmetrically map cu_mask to all SEs & SHs:
+	 * se_mask programs up to 2 SH in the upper and lower 16 bits.
+	 *
+	 * Examples
+	 * Assuming 1 SH/SE, 4 SEs:
+	 * cu_mask[0] bit0 -> se_mask[0] bit0
+	 * cu_mask[0] bit1 -> se_mask[1] bit0
+	 * ...
+	 * cu_mask[0] bit4 -> se_mask[0] bit1
+	 * ...
+	 *
+	 * Assuming 2 SH/SE, 4 SEs
+	 * cu_mask[0] bit0 -> se_mask[0] bit0 (SE0,SH0,CU0)
+	 * cu_mask[0] bit1 -> se_mask[1] bit0 (SE1,SH0,CU0)
+	 * ...
+	 * cu_mask[0] bit4 -> se_mask[0] bit16 (SE0,SH1,CU0)
+	 * cu_mask[0] bit5 -> se_mask[1] bit16 (SE1,SH1,CU0)
+	 * ...
+	 * cu_mask[0] bit8 -> se_mask[0] bit1 (SE0,SH0,CU1)
 	 * ...
+	 *
+	 * First ensure all CUs are disabled, then enable user specified CUs.
 	 */
-	se = 0;
-	for (i = 0; i < cu_mask_count; i++) {
-		if (cu_mask[i / 32] & (1 << (i % 32)))
-			se_mask[se] |= 1 << cu;
-
-		do {
-			se++;
-			if (se == cu_info.num_shader_engines) {
-				se = 0;
-				cu++;
+	for (i = 0; i < cu_info.num_shader_engines; i++)
+		se_mask[i] = 0;
+
+	i = 0;
+	for (cu = 0; cu < 16; cu++) {
+		for (sh = 0; sh < cu_info.num_shader_arrays_per_engine; sh++) {
+			for (se = 0; se < cu_info.num_shader_engines; se++) {
+				if (cu_per_sh[se][sh] > cu) {
+					if (cu_mask[i / 32] & (1 << (i % 32)))
+						se_mask[se] |= 1 << (cu + sh * 16);
+					i++;
+					if (i == cu_mask_count)
+						return;
+				}
 			}
-		} while (cu >= cu_per_se[se] && cu < 32);
+		}
 	}
 }
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
index b5e2ea7550d4..6e6918ccedfd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -27,6 +27,7 @@
 #include "kfd_priv.h"
 
 #define KFD_MAX_NUM_SE 8
+#define KFD_MAX_NUM_SH_PER_SE 2
 
 /**
  * struct mqd_manager
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ed221f815a1f..8c345f0319b8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1176,7 +1176,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	dc_hardware_init(adev->dm.dc);
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (adev->apu_flags) {
+	if ((adev->flags & AMD_IS_APU) && (adev->asic_type >= CHIP_CARRIZO)) {
 		struct dc_phy_addr_space_config pa_config;
 
 		mmhub_read_system_context(adev, &pa_config);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 1b6b15708b96..08ff1166ffc8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -197,29 +197,29 @@ static ssize_t dp_link_settings_read(struct file *f, char __user *buf,
 
 	rd_buf_ptr = rd_buf;
 
-	str_len = strlen("Current:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Current:  %d  %d  %d  ",
+	str_len = strlen("Current:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Current:  %d  0x%x  %d  ",
 			link->cur_link_settings.lane_count,
 			link->cur_link_settings.link_rate,
 			link->cur_link_settings.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Verified:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Verified:  %d  %d  %d  ",
+	str_len = strlen("Verified:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Verified:  %d  0x%x  %d  ",
 			link->verified_link_cap.lane_count,
 			link->verified_link_cap.link_rate,
 			link->verified_link_cap.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Reported:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Reported:  %d  %d  %d  ",
+	str_len = strlen("Reported:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Reported:  %d  0x%x  %d  ",
 			link->reported_link_cap.lane_count,
 			link->reported_link_cap.link_rate,
 			link->reported_link_cap.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Preferred:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Preferred:  %d  %d  %d\n",
+	str_len = strlen("Preferred:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Preferred:  %d  0x%x  %d\n",
 			link->preferred_link_setting.lane_count,
 			link->preferred_link_setting.link_rate,
 			link->preferred_link_setting.link_spread);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 7c939c0a977b..29f61a8d3e29 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3938,13 +3938,12 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	struct dc_clock_config clock_cfg = {0};
 	struct dc_clocks *current_clocks = &context->bw_ctx.bw.dcn.clk;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->get_clock)
-				dc->clk_mgr->funcs->get_clock(dc->clk_mgr,
-						context, clock_type, &clock_cfg);
-
-	if (!dc->clk_mgr->funcs->get_clock)
+	if (!dc->clk_mgr || !dc->clk_mgr->funcs->get_clock)
 		return DC_FAIL_UNSUPPORTED_1;
 
+	dc->clk_mgr->funcs->get_clock(dc->clk_mgr,
+		context, clock_type, &clock_cfg);
+
 	if (clk_khz > clock_cfg.max_clock_khz)
 		return DC_FAIL_CLK_EXCEED_MAX;
 
@@ -3962,7 +3961,7 @@ enum dc_status dcn10_set_clock(struct dc *dc,
 	else
 		return DC_ERROR_UNEXPECTED;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->update_clocks)
+	if (dc->clk_mgr->funcs->update_clocks)
 				dc->clk_mgr->funcs->update_clocks(dc->clk_mgr,
 				context, true);
 	return DC_OK;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 793554e61c52..03b941e76de2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1703,13 +1703,15 @@ void dcn20_program_front_end_for_ctx(
 				dcn20_program_pipe(dc, pipe, context);
 				pipe = pipe->bottom_pipe;
 			}
-			/* Program secondary blending tree and writeback pipes */
-			pipe = &context->res_ctx.pipe_ctx[i];
-			if (!pipe->prev_odm_pipe && pipe->stream->num_wb_info > 0
-					&& (pipe->update_flags.raw || pipe->plane_state->update_flags.raw || pipe->stream->update_flags.raw)
-					&& hws->funcs.program_all_writeback_pipes_in_tree)
-				hws->funcs.program_all_writeback_pipes_in_tree(dc, pipe->stream, context);
 		}
+		/* Program secondary blending tree and writeback pipes */
+		pipe = &context->res_ctx.pipe_ctx[i];
+		if (!pipe->top_pipe && !pipe->prev_odm_pipe
+				&& pipe->stream && pipe->stream->num_wb_info > 0
+				&& (pipe->update_flags.raw || (pipe->plane_state && pipe->plane_state->update_flags.raw)
+					|| pipe->stream->update_flags.raw)
+				&& hws->funcs.program_all_writeback_pipes_in_tree)
+			hws->funcs.program_all_writeback_pipes_in_tree(dc, pipe->stream, context);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 81f583733fa8..12e92f620483 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2461,7 +2461,7 @@ void dcn20_set_mcif_arb_params(
 				wb_arb_params->cli_watermark[k] = get_wm_writeback_urgent(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 				wb_arb_params->pstate_watermark[k] = get_wm_writeback_dram_clock_change(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 			}
-			wb_arb_params->time_per_pixel = 16.0 / context->res_ctx.pipe_ctx[i].stream->phy_pix_clk; /* 4 bit fraction, ms */
+			wb_arb_params->time_per_pixel = 16.0 * 1000 / (context->res_ctx.pipe_ctx[i].stream->phy_pix_clk / 1000); /* 4 bit fraction, ms */
 			wb_arb_params->slice_lines = 32;
 			wb_arb_params->arbitration_slice = 2;
 			wb_arb_params->max_scaled_time = dcn20_calc_max_scaled_time(wb_arb_params->time_per_pixel,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
index 3fe9e41e4dbd..6a3d3a0ec0a3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -49,6 +49,11 @@
 static void dwb3_get_reg_field_ogam(struct dcn30_dwbc *dwbc30,
 	struct dcn3_xfer_func_reg *reg)
 {
+	reg->shifts.field_region_start_base = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_BASE_B;
+	reg->masks.field_region_start_base = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_BASE_B;
+	reg->shifts.field_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_OFFSET_B;
+	reg->masks.field_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_OFFSET_B;
+
 	reg->shifts.exp_region0_lut_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION0_LUT_OFFSET;
 	reg->masks.exp_region0_lut_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION0_LUT_OFFSET;
 	reg->shifts.exp_region0_num_segments = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION0_NUM_SEGMENTS;
@@ -66,8 +71,6 @@ static void dwb3_get_reg_field_ogam(struct dcn30_dwbc *dwbc30,
 	reg->masks.field_region_end_base = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_END_BASE_B;
 	reg->shifts.field_region_linear_slope = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_SLOPE_B;
 	reg->masks.field_region_linear_slope = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_SLOPE_B;
-	reg->masks.field_offset = dwbc30->dwbc_mask->DWB_OGAM_RAMA_OFFSET_B;
-	reg->shifts.field_offset = dwbc30->dwbc_shift->DWB_OGAM_RAMA_OFFSET_B;
 	reg->shifts.exp_region_start = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_B;
 	reg->masks.exp_region_start = dwbc30->dwbc_mask->DWB_OGAM_RAMA_EXP_REGION_START_B;
 	reg->shifts.exp_resion_start_segment = dwbc30->dwbc_shift->DWB_OGAM_RAMA_EXP_REGION_START_SEGMENT_B;
@@ -147,18 +150,19 @@ static enum dc_lut_mode dwb3_get_ogam_current(
 	uint32_t state_mode;
 	uint32_t ram_select;
 
-	REG_GET(DWB_OGAM_CONTROL,
-		DWB_OGAM_MODE, &state_mode);
-	REG_GET(DWB_OGAM_CONTROL,
-		DWB_OGAM_SELECT, &ram_select);
+	REG_GET_2(DWB_OGAM_CONTROL,
+		DWB_OGAM_MODE_CURRENT, &state_mode,
+		DWB_OGAM_SELECT_CURRENT, &ram_select);
 
 	if (state_mode == 0) {
 		mode = LUT_BYPASS;
 	} else if (state_mode == 2) {
 		if (ram_select == 0)
 			mode = LUT_RAM_A;
-		else
+		else if (ram_select == 1)
 			mode = LUT_RAM_B;
+		else
+			mode = LUT_BYPASS;
 	} else {
 		// Reserved value
 		mode = LUT_BYPASS;
@@ -172,10 +176,10 @@ static void dwb3_configure_ogam_lut(
 	struct dcn30_dwbc *dwbc30,
 	bool is_ram_a)
 {
-	REG_UPDATE(DWB_OGAM_LUT_CONTROL,
-		DWB_OGAM_LUT_READ_COLOR_SEL, 7);
-	REG_UPDATE(DWB_OGAM_CONTROL,
-		DWB_OGAM_SELECT, is_ram_a == true ? 0 : 1);
+	REG_UPDATE_2(DWB_OGAM_LUT_CONTROL,
+		DWB_OGAM_LUT_WRITE_COLOR_MASK, 7,
+		DWB_OGAM_LUT_HOST_SEL, (is_ram_a == true) ? 0 : 1);
+
 	REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
 }
 
@@ -185,17 +189,45 @@ static void dwb3_program_ogam_pwl(struct dcn30_dwbc *dwbc30,
 {
 	uint32_t i;
 
-    // triple base implementation
-	for (i = 0; i < num/2; i++) {
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+0].blue_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+1].blue_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].red_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].green_reg);
-		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[2*i+2].blue_reg);
+	uint32_t last_base_value_red = rgb[num-1].red_reg + rgb[num-1].delta_red_reg;
+	uint32_t last_base_value_green = rgb[num-1].green_reg + rgb[num-1].delta_green_reg;
+	uint32_t last_base_value_blue = rgb[num-1].blue_reg + rgb[num-1].delta_blue_reg;
+
+	if (is_rgb_equal(rgb,  num)) {
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].red_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_red);
+
+	} else {
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 4);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].red_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_red);
+
+		REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 2);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].green_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_green);
+
+		REG_SET(DWB_OGAM_LUT_INDEX, 0, DWB_OGAM_LUT_INDEX, 0);
+
+		REG_UPDATE(DWB_OGAM_LUT_CONTROL,
+				DWB_OGAM_LUT_WRITE_COLOR_MASK, 1);
+
+		for (i = 0 ; i < num; i++)
+			REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, rgb[i].blue_reg);
+
+		REG_SET(DWB_OGAM_LUT_DATA, 0, DWB_OGAM_LUT_DATA, last_base_value_blue);
 	}
 }
 
@@ -211,6 +243,8 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
+	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
+
 	current_mode = dwb3_get_ogam_current(dwbc30);
 	if (current_mode == LUT_BYPASS || current_mode == LUT_RAM_A)
 		next_mode = LUT_RAM_B;
@@ -227,8 +261,7 @@ static bool dwb3_program_ogam_lut(
 	dwb3_program_ogam_pwl(
 		dwbc30, params->rgb_resulted, params->hw_points_num);
 
-	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
-	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_SELECT, next_mode == LUT_RAM_A ? 0 : 1);
+	REG_UPDATE(DWB_OGAM_CONTROL, DWB_OGAM_SELECT, next_mode == LUT_RAM_A ? 0 : 1);
 
 	return true;
 }
@@ -271,14 +304,19 @@ static void dwb3_program_gamut_remap(
 
 	struct color_matrices_reg gam_regs;
 
-	REG_UPDATE(DWB_GAMUT_REMAP_COEF_FORMAT, DWB_GAMUT_REMAP_COEF_FORMAT, coef_format);
-
 	if (regval == NULL || select == CM_GAMUT_REMAP_MODE_BYPASS) {
 		REG_SET(DWB_GAMUT_REMAP_MODE, 0,
 				DWB_GAMUT_REMAP_MODE, 0);
 		return;
 	}
 
+	REG_UPDATE(DWB_GAMUT_REMAP_COEF_FORMAT, DWB_GAMUT_REMAP_COEF_FORMAT, coef_format);
+
+	gam_regs.shifts.csc_c11 = dwbc30->dwbc_shift->DWB_GAMUT_REMAPA_C11;
+	gam_regs.masks.csc_c11  = dwbc30->dwbc_mask->DWB_GAMUT_REMAPA_C11;
+	gam_regs.shifts.csc_c12 = dwbc30->dwbc_shift->DWB_GAMUT_REMAPA_C12;
+	gam_regs.masks.csc_c12 = dwbc30->dwbc_mask->DWB_GAMUT_REMAPA_C12;
+
 	switch (select) {
 	case CM_GAMUT_REMAP_MODE_RAMA_COEFF:
 		gam_regs.csc_c11_c12 = REG(DWB_GAMUT_REMAPA_C11_C12);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index d53f8b39699b..37944f94c693 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -396,12 +396,22 @@ void dcn30_program_all_writeback_pipes_in_tree(
 			for (i_pipe = 0; i_pipe < dc->res_pool->pipe_count; i_pipe++) {
 				struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i_pipe];
 
+				if (!pipe_ctx->plane_state)
+					continue;
+
 				if (pipe_ctx->plane_state == wb_info.writeback_source_plane) {
 					wb_info.mpcc_inst = pipe_ctx->plane_res.mpcc_inst;
 					break;
 				}
 			}
-			ASSERT(wb_info.mpcc_inst != -1);
+
+			if (wb_info.mpcc_inst == -1) {
+				/* Disable writeback pipe and disconnect from MPCC
+				 * if source plane has been removed
+				 */
+				dc->hwss.disable_writeback(dc, wb_info.dwb_pipe_inst);
+				continue;
+			}
 
 			ASSERT(wb_info.dwb_pipe_inst < dc->res_pool->res_cap->num_dwb);
 			dwb = dc->res_pool->dwbc[wb_info.dwb_pipe_inst];
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index a5a1cb62f967..393447ebff6e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2398,16 +2398,37 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 	dc->dml.soc.dispclk_dppclk_vco_speed_mhz = dc->clk_mgr->dentist_vco_freq_khz / 1000.0;
 
 	if (bw_params->clk_table.entries[0].memclk_mhz) {
+		int max_dcfclk_mhz = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0, max_phyclk_mhz = 0;
+
+		for (i = 0; i < MAX_NUM_DPM_LVL; i++) {
+			if (bw_params->clk_table.entries[i].dcfclk_mhz > max_dcfclk_mhz)
+				max_dcfclk_mhz = bw_params->clk_table.entries[i].dcfclk_mhz;
+			if (bw_params->clk_table.entries[i].dispclk_mhz > max_dispclk_mhz)
+				max_dispclk_mhz = bw_params->clk_table.entries[i].dispclk_mhz;
+			if (bw_params->clk_table.entries[i].dppclk_mhz > max_dppclk_mhz)
+				max_dppclk_mhz = bw_params->clk_table.entries[i].dppclk_mhz;
+			if (bw_params->clk_table.entries[i].phyclk_mhz > max_phyclk_mhz)
+				max_phyclk_mhz = bw_params->clk_table.entries[i].phyclk_mhz;
+		}
+
+		if (!max_dcfclk_mhz)
+			max_dcfclk_mhz = dcn3_0_soc.clock_limits[0].dcfclk_mhz;
+		if (!max_dispclk_mhz)
+			max_dispclk_mhz = dcn3_0_soc.clock_limits[0].dispclk_mhz;
+		if (!max_dppclk_mhz)
+			max_dppclk_mhz = dcn3_0_soc.clock_limits[0].dppclk_mhz;
+		if (!max_phyclk_mhz)
+			max_phyclk_mhz = dcn3_0_soc.clock_limits[0].phyclk_mhz;
 
-		if (bw_params->clk_table.entries[1].dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		if (max_dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is greater than the max DCFCLK STA target, insert into the DCFCLK STA target array
-			dcfclk_sta_targets[num_dcfclk_sta_targets] = bw_params->clk_table.entries[1].dcfclk_mhz;
+			dcfclk_sta_targets[num_dcfclk_sta_targets] = max_dcfclk_mhz;
 			num_dcfclk_sta_targets++;
-		} else if (bw_params->clk_table.entries[1].dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		} else if (max_dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is less than the max DCFCLK STA target, cap values and remove duplicates
 			for (i = 0; i < num_dcfclk_sta_targets; i++) {
-				if (dcfclk_sta_targets[i] > bw_params->clk_table.entries[1].dcfclk_mhz) {
-					dcfclk_sta_targets[i] = bw_params->clk_table.entries[1].dcfclk_mhz;
+				if (dcfclk_sta_targets[i] > max_dcfclk_mhz) {
+					dcfclk_sta_targets[i] = max_dcfclk_mhz;
 					break;
 				}
 			}
@@ -2447,7 +2468,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 				dcfclk_mhz[num_states] = dcfclk_sta_targets[i];
 				dram_speed_mts[num_states++] = optimal_uclk_for_dcfclk_sta_targets[i++];
 			} else {
-				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 					dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 					dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 				} else {
@@ -2462,11 +2483,12 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 		}
 
 		while (j < num_uclk_states && num_states < DC__VOLTAGE_STATES &&
-				optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 			dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		dcn3_0_soc.num_states = num_states;
 		for (i = 0; i < dcn3_0_soc.num_states; i++) {
 			dcn3_0_soc.clock_limits[i].state = i;
 			dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];
@@ -2474,9 +2496,9 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
 			dcn3_0_soc.clock_limits[i].dram_speed_mts = dram_speed_mts[i];
 
 			/* Fill all states with max values of all other clocks */
-			dcn3_0_soc.clock_limits[i].dispclk_mhz = bw_params->clk_table.entries[1].dispclk_mhz;
-			dcn3_0_soc.clock_limits[i].dppclk_mhz  = bw_params->clk_table.entries[1].dppclk_mhz;
-			dcn3_0_soc.clock_limits[i].phyclk_mhz  = bw_params->clk_table.entries[1].phyclk_mhz;
+			dcn3_0_soc.clock_limits[i].dispclk_mhz = max_dispclk_mhz;
+			dcn3_0_soc.clock_limits[i].dppclk_mhz  = max_dppclk_mhz;
+			dcn3_0_soc.clock_limits[i].phyclk_mhz  = max_phyclk_mhz;
 			dcn3_0_soc.clock_limits[i].dtbclk_mhz = dcn3_0_soc.clock_limits[0].dtbclk_mhz;
 			/* These clocks cannot come from bw_params, always fill from dcn3_0_soc[1] */
 			/* FCLK, PHYCLK_D18, SOCCLK, DSCCLK */
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 911f9f414774..39ca338eb80b 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -337,6 +337,11 @@ int ast_mode_config_init(struct ast_private *ast);
 #define AST_DP501_LINKRATE	0xf014
 #define AST_DP501_EDID_DATA	0xf020
 
+/* Define for Soc scratched reg */
+#define AST_VRAM_INIT_STATUS_MASK	GENMASK(7, 6)
+//#define AST_VRAM_INIT_BY_BMC		BIT(7)
+//#define AST_VRAM_INIT_READY		BIT(6)
+
 int ast_mm_init(struct ast_private *ast);
 
 /* ast post */
@@ -346,6 +351,7 @@ bool ast_is_vga_enabled(struct drm_device *dev);
 void ast_post_gpu(struct drm_device *dev);
 u32 ast_mindwm(struct ast_private *ast, u32 r);
 void ast_moutdwm(struct ast_private *ast, u32 r, u32 v);
+void ast_patch_ahb_2500(struct ast_private *ast);
 /* ast dp501 */
 void ast_set_dp501_video_output(struct drm_device *dev, u8 mode);
 bool ast_backup_fw(struct drm_device *dev, u8 *addr, u32 size);
diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index 2aff2e6cf450..79a361867955 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -97,6 +97,11 @@ static void ast_detect_config_mode(struct drm_device *dev, u32 *scu_rev)
 	jregd0 = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd0, 0xff);
 	jregd1 = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd1, 0xff);
 	if (!(jregd0 & 0x80) || !(jregd1 & 0x10)) {
+		/* Patch AST2500 */
+		if (((pdev->revision & 0xF0) == 0x40)
+			&& ((jregd0 & AST_VRAM_INIT_STATUS_MASK) == 0))
+			ast_patch_ahb_2500(ast);
+
 		/* Double check it's actually working */
 		data = ast_read32(ast, 0xf004);
 		if ((data != 0xFFFFFFFF) && (data != 0x00)) {
diff --git a/drivers/gpu/drm/ast/ast_post.c b/drivers/gpu/drm/ast/ast_post.c
index 0607658dde51..b5d92f652fd8 100644
--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -2028,6 +2028,40 @@ static bool ast_dram_init_2500(struct ast_private *ast)
 	return true;
 }
 
+void ast_patch_ahb_2500(struct ast_private *ast)
+{
+	u32	data;
+
+	/* Clear bus lock condition */
+	ast_moutdwm(ast, 0x1e600000, 0xAEED1A03);
+	ast_moutdwm(ast, 0x1e600084, 0x00010000);
+	ast_moutdwm(ast, 0x1e600088, 0x00000000);
+	ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
+	data = ast_mindwm(ast, 0x1e6e2070);
+	if (data & 0x08000000) {					/* check fast reset */
+		/*
+		 * If "Fast restet" is enabled for ARM-ICE debugger,
+		 * then WDT needs to enable, that
+		 * WDT04 is WDT#1 Reload reg.
+		 * WDT08 is WDT#1 counter restart reg to avoid system deadlock
+		 * WDT0C is WDT#1 control reg
+		 *	[6:5]:= 01:Full chip
+		 *	[4]:= 1:1MHz clock source
+		 *	[1]:= 1:WDT will be cleeared and disabled after timeout occurs
+		 *	[0]:= 1:WDT enable
+		 */
+		ast_moutdwm(ast, 0x1E785004, 0x00000010);
+		ast_moutdwm(ast, 0x1E785008, 0x00004755);
+		ast_moutdwm(ast, 0x1E78500c, 0x00000033);
+		udelay(1000);
+	}
+	do {
+		ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
+		data = ast_mindwm(ast, 0x1e6e2000);
+	}	while (data != 1);
+	ast_moutdwm(ast, 0x1e6e207c, 0x08000000);	/* clear fast reset */
+}
+
 void ast_post_chip_2500(struct drm_device *dev)
 {
 	struct ast_private *ast = to_ast_private(dev);
@@ -2035,39 +2069,44 @@ void ast_post_chip_2500(struct drm_device *dev)
 	u8 reg;
 
 	reg = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd0, 0xff);
-	if ((reg & 0x80) == 0) {/* vga only */
+	if ((reg & AST_VRAM_INIT_STATUS_MASK) == 0) {/* vga only */
 		/* Clear bus lock condition */
-		ast_moutdwm(ast, 0x1e600000, 0xAEED1A03);
-		ast_moutdwm(ast, 0x1e600084, 0x00010000);
-		ast_moutdwm(ast, 0x1e600088, 0x00000000);
-		ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
-		ast_write32(ast, 0xf004, 0x1e6e0000);
-		ast_write32(ast, 0xf000, 0x1);
-		ast_write32(ast, 0x12000, 0x1688a8a8);
-		while (ast_read32(ast, 0x12000) != 0x1)
-			;
-
-		ast_write32(ast, 0x10000, 0xfc600309);
-		while (ast_read32(ast, 0x10000) != 0x1)
-			;
+		ast_patch_ahb_2500(ast);
+
+		/* Disable watchdog */
+		ast_moutdwm(ast, 0x1E78502C, 0x00000000);
+		ast_moutdwm(ast, 0x1E78504C, 0x00000000);
+
+		/*
+		 * Reset USB port to patch USB unknown device issue
+		 * SCU90 is Multi-function Pin Control #5
+		 *	[29]:= 1:Enable USB2.0 Host port#1 (that the mutually shared USB2.0 Hub
+		 *				port).
+		 * SCU94 is Multi-function Pin Control #6
+		 *	[14:13]:= 1x:USB2.0 Host2 controller
+		 * SCU70 is Hardware Strap reg
+		 *	[23]:= 1:CLKIN is 25MHz and USBCK1 = 24/48 MHz (determined by
+		 *				[18]: 0(24)/1(48) MHz)
+		 * SCU7C is Write clear reg to SCU70
+		 *	[23]:= write 1 and then SCU70[23] will be clear as 0b.
+		 */
+		ast_moutdwm(ast, 0x1E6E2090, 0x20000000);
+		ast_moutdwm(ast, 0x1E6E2094, 0x00004000);
+		if (ast_mindwm(ast, 0x1E6E2070) & 0x00800000) {
+			ast_moutdwm(ast, 0x1E6E207C, 0x00800000);
+			mdelay(100);
+			ast_moutdwm(ast, 0x1E6E2070, 0x00800000);
+		}
+		/* Modify eSPI reset pin */
+		temp = ast_mindwm(ast, 0x1E6E2070);
+		if (temp & 0x02000000)
+			ast_moutdwm(ast, 0x1E6E207C, 0x00004000);
 
 		/* Slow down CPU/AHB CLK in VGA only mode */
 		temp = ast_read32(ast, 0x12008);
 		temp |= 0x73;
 		ast_write32(ast, 0x12008, temp);
 
-		/* Reset USB port to patch USB unknown device issue */
-		ast_moutdwm(ast, 0x1e6e2090, 0x20000000);
-		temp  = ast_mindwm(ast, 0x1e6e2094);
-		temp |= 0x00004000;
-		ast_moutdwm(ast, 0x1e6e2094, temp);
-		temp  = ast_mindwm(ast, 0x1e6e2070);
-		if (temp & 0x00800000) {
-			ast_moutdwm(ast, 0x1e6e207c, 0x00800000);
-			mdelay(100);
-			ast_moutdwm(ast, 0x1e6e2070, 0x00800000);
-		}
-
 		if (!ast_dram_init_2500(ast))
 			drm_err(dev, "DRAM init failed !\n");
 
diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index c65ca860712d..6cac2e58cd15 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -196,7 +196,7 @@ static u32 ps2bc(struct nwl_dsi *dsi, unsigned long long ps)
 	u32 bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
 
 	return DIV64_U64_ROUND_UP(ps * dsi->mode.clock * bpp,
-				  dsi->lanes * 8 * NSEC_PER_SEC);
+				  dsi->lanes * 8ULL * NSEC_PER_SEC);
 }
 
 /*
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 232abbba3686..c7adbeaf10b1 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -135,16 +135,18 @@ static void drm_set_master(struct drm_device *dev, struct drm_file *fpriv,
 static int drm_new_set_master(struct drm_device *dev, struct drm_file *fpriv)
 {
 	struct drm_master *old_master;
+	struct drm_master *new_master;
 
 	lockdep_assert_held_once(&dev->master_mutex);
 
 	WARN_ON(fpriv->is_master);
 	old_master = fpriv->master;
-	fpriv->master = drm_master_create(dev);
-	if (!fpriv->master) {
-		fpriv->master = old_master;
+	new_master = drm_master_create(dev);
+	if (!new_master)
 		return -ENOMEM;
-	}
+	spin_lock(&fpriv->master_lookup_lock);
+	fpriv->master = new_master;
+	spin_unlock(&fpriv->master_lookup_lock);
 
 	fpriv->is_master = 1;
 	fpriv->authenticated = 1;
@@ -302,10 +304,13 @@ int drm_master_open(struct drm_file *file_priv)
 	/* if there is no current master make this fd it, but do not create
 	 * any master object for render clients */
 	mutex_lock(&dev->master_mutex);
-	if (!dev->master)
+	if (!dev->master) {
 		ret = drm_new_set_master(dev, file_priv);
-	else
+	} else {
+		spin_lock(&file_priv->master_lookup_lock);
 		file_priv->master = drm_master_get(dev->master);
+		spin_unlock(&file_priv->master_lookup_lock);
+	}
 	mutex_unlock(&dev->master_mutex);
 
 	return ret;
@@ -371,6 +376,31 @@ struct drm_master *drm_master_get(struct drm_master *master)
 }
 EXPORT_SYMBOL(drm_master_get);
 
+/**
+ * drm_file_get_master - reference &drm_file.master of @file_priv
+ * @file_priv: DRM file private
+ *
+ * Increments the reference count of @file_priv's &drm_file.master and returns
+ * the &drm_file.master. If @file_priv has no &drm_file.master, returns NULL.
+ *
+ * Master pointers returned from this function should be unreferenced using
+ * drm_master_put().
+ */
+struct drm_master *drm_file_get_master(struct drm_file *file_priv)
+{
+	struct drm_master *master = NULL;
+
+	spin_lock(&file_priv->master_lookup_lock);
+	if (!file_priv->master)
+		goto unlock;
+	master = drm_master_get(file_priv->master);
+
+unlock:
+	spin_unlock(&file_priv->master_lookup_lock);
+	return master;
+}
+EXPORT_SYMBOL(drm_file_get_master);
+
 static void drm_master_destroy(struct kref *kref)
 {
 	struct drm_master *master = container_of(kref, struct drm_master, refcount);
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 3d7182001004..b0a826489488 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -91,6 +91,7 @@ static int drm_clients_info(struct seq_file *m, void *data)
 	mutex_lock(&dev->filelist_mutex);
 	list_for_each_entry_reverse(priv, &dev->filelist, lhead) {
 		struct task_struct *task;
+		bool is_current_master = drm_is_current_master(priv);
 
 		rcu_read_lock(); /* locks pid_task()->comm */
 		task = pid_task(priv->pid, PIDTYPE_PID);
@@ -99,7 +100,7 @@ static int drm_clients_info(struct seq_file *m, void *data)
 			   task ? task->comm : "<unknown>",
 			   pid_vnr(priv->pid),
 			   priv->minor->index,
-			   drm_is_current_master(priv) ? 'y' : 'n',
+			   is_current_master ? 'y' : 'n',
 			   priv->authenticated ? 'y' : 'n',
 			   from_kuid_munged(seq_user_ns(m), uid),
 			   priv->magic);
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index a68dc25a19c6..04e7a8d20f25 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2867,11 +2867,13 @@ static int process_single_tx_qlock(struct drm_dp_mst_topology_mgr *mgr,
 	idx += tosend + 1;
 
 	ret = drm_dp_send_sideband_msg(mgr, up, chunk, idx);
-	if (unlikely(ret) && drm_debug_enabled(DRM_UT_DP)) {
-		struct drm_printer p = drm_debug_printer(DBG_PREFIX);
+	if (ret) {
+		if (drm_debug_enabled(DRM_UT_DP)) {
+			struct drm_printer p = drm_debug_printer(DBG_PREFIX);
 
-		drm_printf(&p, "sideband msg failed to send\n");
-		drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
+			drm_printf(&p, "sideband msg failed to send\n");
+			drm_dp_mst_dump_sideband_msg_tx(&p, txmsg);
+		}
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 7efbccffc2ea..c6feeb5651b0 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -176,6 +176,7 @@ struct drm_file *drm_file_alloc(struct drm_minor *minor)
 	init_waitqueue_head(&file->event_wait);
 	file->event_space = 4096; /* set aside 4k for event buffer */
 
+	spin_lock_init(&file->master_lookup_lock);
 	mutex_init(&file->event_read_lock);
 
 	if (drm_core_check_feature(dev, DRIVER_GEM))
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index da4f085fc09e..aef22634005e 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -107,10 +107,19 @@ static bool _drm_has_leased(struct drm_master *master, int id)
  */
 bool _drm_lease_held(struct drm_file *file_priv, int id)
 {
-	if (!file_priv || !file_priv->master)
+	bool ret;
+	struct drm_master *master;
+
+	if (!file_priv)
 		return true;
 
-	return _drm_lease_held_master(file_priv->master, id);
+	master = drm_file_get_master(file_priv);
+	if (!master)
+		return true;
+	ret = _drm_lease_held_master(master, id);
+	drm_master_put(&master);
+
+	return ret;
 }
 
 /**
@@ -129,13 +138,22 @@ bool drm_lease_held(struct drm_file *file_priv, int id)
 	struct drm_master *master;
 	bool ret;
 
-	if (!file_priv || !file_priv->master || !file_priv->master->lessor)
+	if (!file_priv)
 		return true;
 
-	master = file_priv->master;
+	master = drm_file_get_master(file_priv);
+	if (!master)
+		return true;
+	if (!master->lessor) {
+		ret = true;
+		goto out;
+	}
 	mutex_lock(&master->dev->mode_config.idr_mutex);
 	ret = _drm_lease_held_master(master, id);
 	mutex_unlock(&master->dev->mode_config.idr_mutex);
+
+out:
+	drm_master_put(&master);
 	return ret;
 }
 
@@ -155,10 +173,16 @@ uint32_t drm_lease_filter_crtcs(struct drm_file *file_priv, uint32_t crtcs_in)
 	int count_in, count_out;
 	uint32_t crtcs_out = 0;
 
-	if (!file_priv || !file_priv->master || !file_priv->master->lessor)
+	if (!file_priv)
 		return crtcs_in;
 
-	master = file_priv->master;
+	master = drm_file_get_master(file_priv);
+	if (!master)
+		return crtcs_in;
+	if (!master->lessor) {
+		crtcs_out = crtcs_in;
+		goto out;
+	}
 	dev = master->dev;
 
 	count_in = count_out = 0;
@@ -177,6 +201,9 @@ uint32_t drm_lease_filter_crtcs(struct drm_file *file_priv, uint32_t crtcs_in)
 		count_in++;
 	}
 	mutex_unlock(&master->dev->mode_config.idr_mutex);
+
+out:
+	drm_master_put(&master);
 	return crtcs_out;
 }
 
@@ -490,7 +517,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	size_t object_count;
 	int ret = 0;
 	struct idr leases;
-	struct drm_master *lessor = lessor_priv->master;
+	struct drm_master *lessor;
 	struct drm_master *lessee = NULL;
 	struct file *lessee_file = NULL;
 	struct file *lessor_file = lessor_priv->filp;
@@ -502,12 +529,6 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
-	/* Do not allow sub-leases */
-	if (lessor->lessor) {
-		DRM_DEBUG_LEASE("recursive leasing not allowed\n");
-		return -EINVAL;
-	}
-
 	/* need some objects */
 	if (cl->object_count == 0) {
 		DRM_DEBUG_LEASE("no objects in lease\n");
@@ -519,12 +540,22 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		return -EINVAL;
 	}
 
+	lessor = drm_file_get_master(lessor_priv);
+	/* Do not allow sub-leases */
+	if (lessor->lessor) {
+		DRM_DEBUG_LEASE("recursive leasing not allowed\n");
+		ret = -EINVAL;
+		goto out_lessor;
+	}
+
 	object_count = cl->object_count;
 
 	object_ids = memdup_user(u64_to_user_ptr(cl->object_ids),
 			array_size(object_count, sizeof(__u32)));
-	if (IS_ERR(object_ids))
-		return PTR_ERR(object_ids);
+	if (IS_ERR(object_ids)) {
+		ret = PTR_ERR(object_ids);
+		goto out_lessor;
+	}
 
 	idr_init(&leases);
 
@@ -535,14 +566,15 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	if (ret) {
 		DRM_DEBUG_LEASE("lease object lookup failed: %i\n", ret);
 		idr_destroy(&leases);
-		return ret;
+		goto out_lessor;
 	}
 
 	/* Allocate a file descriptor for the lease */
 	fd = get_unused_fd_flags(cl->flags & (O_CLOEXEC | O_NONBLOCK));
 	if (fd < 0) {
 		idr_destroy(&leases);
-		return fd;
+		ret = fd;
+		goto out_lessor;
 	}
 
 	DRM_DEBUG_LEASE("Creating lease\n");
@@ -578,6 +610,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	/* Hook up the fd */
 	fd_install(fd, lessee_file);
 
+	drm_master_put(&lessor);
 	DRM_DEBUG_LEASE("drm_mode_create_lease_ioctl succeeded\n");
 	return 0;
 
@@ -587,6 +620,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 out_leases:
 	put_unused_fd(fd);
 
+out_lessor:
+	drm_master_put(&lessor);
 	DRM_DEBUG_LEASE("drm_mode_create_lease_ioctl failed: %d\n", ret);
 	return ret;
 }
@@ -609,7 +644,7 @@ int drm_mode_list_lessees_ioctl(struct drm_device *dev,
 	struct drm_mode_list_lessees *arg = data;
 	__u32 __user *lessee_ids = (__u32 __user *) (uintptr_t) (arg->lessees_ptr);
 	__u32 count_lessees = arg->count_lessees;
-	struct drm_master *lessor = lessor_priv->master, *lessee;
+	struct drm_master *lessor, *lessee;
 	int count;
 	int ret = 0;
 
@@ -620,6 +655,7 @@ int drm_mode_list_lessees_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
+	lessor = drm_file_get_master(lessor_priv);
 	DRM_DEBUG_LEASE("List lessees for %d\n", lessor->lessee_id);
 
 	mutex_lock(&dev->mode_config.idr_mutex);
@@ -643,6 +679,7 @@ int drm_mode_list_lessees_ioctl(struct drm_device *dev,
 		arg->count_lessees = count;
 
 	mutex_unlock(&dev->mode_config.idr_mutex);
+	drm_master_put(&lessor);
 
 	return ret;
 }
@@ -662,7 +699,7 @@ int drm_mode_get_lease_ioctl(struct drm_device *dev,
 	struct drm_mode_get_lease *arg = data;
 	__u32 __user *object_ids = (__u32 __user *) (uintptr_t) (arg->objects_ptr);
 	__u32 count_objects = arg->count_objects;
-	struct drm_master *lessee = lessee_priv->master;
+	struct drm_master *lessee;
 	struct idr *object_idr;
 	int count;
 	void *entry;
@@ -676,6 +713,7 @@ int drm_mode_get_lease_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
+	lessee = drm_file_get_master(lessee_priv);
 	DRM_DEBUG_LEASE("get lease for %d\n", lessee->lessee_id);
 
 	mutex_lock(&dev->mode_config.idr_mutex);
@@ -703,6 +741,7 @@ int drm_mode_get_lease_ioctl(struct drm_device *dev,
 		arg->count_objects = count;
 
 	mutex_unlock(&dev->mode_config.idr_mutex);
+	drm_master_put(&lessee);
 
 	return ret;
 }
@@ -721,7 +760,7 @@ int drm_mode_revoke_lease_ioctl(struct drm_device *dev,
 				void *data, struct drm_file *lessor_priv)
 {
 	struct drm_mode_revoke_lease *arg = data;
-	struct drm_master *lessor = lessor_priv->master;
+	struct drm_master *lessor;
 	struct drm_master *lessee;
 	int ret = 0;
 
@@ -731,6 +770,7 @@ int drm_mode_revoke_lease_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
+	lessor = drm_file_get_master(lessor_priv);
 	mutex_lock(&dev->mode_config.idr_mutex);
 
 	lessee = _drm_find_lessee(lessor, arg->lessee_id);
@@ -751,6 +791,7 @@ int drm_mode_revoke_lease_ioctl(struct drm_device *dev,
 
 fail:
 	mutex_unlock(&dev->mode_config.idr_mutex);
+	drm_master_put(&lessor);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dma.c b/drivers/gpu/drm/exynos/exynos_drm_dma.c
index 0644936afee2..bf33c3084cb4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dma.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dma.c
@@ -115,6 +115,8 @@ int exynos_drm_register_dma(struct drm_device *drm, struct device *dev,
 				EXYNOS_DEV_ADDR_START, EXYNOS_DEV_ADDR_SIZE);
 		else if (IS_ENABLED(CONFIG_IOMMU_DMA))
 			mapping = iommu_get_domain_for_dev(priv->dma_dev);
+		else
+			mapping = ERR_PTR(-ENODEV);
 
 		if (IS_ERR(mapping))
 			return PTR_ERR(mapping);
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 749a075fe9e4..d1b51c133e27 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -43,6 +43,22 @@
 #define ATTR_INDEX 0x1fc0
 #define ATTR_DATA 0x1fc1
 
+#define WREG_MISC(v)						\
+	WREG8(MGA_MISC_OUT, v)
+
+#define RREG_MISC(v)						\
+	((v) = RREG8(MGA_MISC_IN))
+
+#define WREG_MISC_MASKED(v, mask)				\
+	do {							\
+		u8 misc_;					\
+		u8 mask_ = (mask);				\
+		RREG_MISC(misc_);				\
+		misc_ &= ~mask_;				\
+		misc_ |= ((v) & mask_);				\
+		WREG_MISC(misc_);				\
+	} while (0)
+
 #define WREG_ATTR(reg, v)					\
 	do {							\
 		RREG8(0x1fda);					\
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index cece3e57fb27..45d71d65b6d3 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -174,6 +174,8 @@ static int mgag200_g200_set_plls(struct mga_device *mdev, long clock)
 	drm_dbg_kms(dev, "clock: %ld vco: %ld m: %d n: %d p: %d s: %d\n",
 		    clock, f_vco, m, n, p, s);
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, (p | (s << 3)));
@@ -289,6 +291,8 @@ static int mga_g200se_set_plls(struct mga_device *mdev, long clock)
 		return 1;
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, p);
@@ -385,6 +389,8 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		if (i > 0) {
 			WREG8(MGAREG_CRTC_INDEX, 0x1e);
@@ -522,6 +528,8 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -654,6 +662,9 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 			}
 		}
 	}
+
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
@@ -754,6 +765,8 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -787,8 +800,6 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 
 static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 {
-	u8 misc;
-
 	switch(mdev->type) {
 	case G200_PCI:
 	case G200_AGP:
@@ -808,11 +819,6 @@ static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 		return mga_g200er_set_plls(mdev, clock);
 	}
 
-	misc = RREG8(MGA_MISC_IN);
-	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
-	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
-	WREG8(MGA_MISC_OUT, misc);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_reg.h b/drivers/gpu/drm/mgag200/mgag200_reg.h
index 977be0565c06..60e705283fe8 100644
--- a/drivers/gpu/drm/mgag200/mgag200_reg.h
+++ b/drivers/gpu/drm/mgag200/mgag200_reg.h
@@ -222,11 +222,10 @@
 
 #define MGAREG_MISC_IOADSEL	(0x1 << 0)
 #define MGAREG_MISC_RAMMAPEN	(0x1 << 1)
-#define MGAREG_MISC_CLK_SEL_MASK	GENMASK(3, 2)
-#define MGAREG_MISC_CLK_SEL_VGA25	(0x0 << 2)
-#define MGAREG_MISC_CLK_SEL_VGA28	(0x1 << 2)
-#define MGAREG_MISC_CLK_SEL_MGA_PIX	(0x2 << 2)
-#define MGAREG_MISC_CLK_SEL_MGA_MSK	(0x3 << 2)
+#define MGAREG_MISC_CLKSEL_MASK		GENMASK(3, 2)
+#define MGAREG_MISC_CLKSEL_VGA25	(0x0 << 2)
+#define MGAREG_MISC_CLKSEL_VGA28	(0x1 << 2)
+#define MGAREG_MISC_CLKSEL_MGA		(0x3 << 2)
 #define MGAREG_MISC_VIDEO_DIS	(0x1 << 4)
 #define MGAREG_MISC_HIGH_PG_SEL	(0x1 << 5)
 #define MGAREG_MISC_HSYNCPOL		BIT(6)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 2daf81f63076..b05729557436 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -902,6 +902,7 @@ static const struct dpu_perf_cfg sdm845_perf_data = {
 	.amortizable_threshold = 25,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sdm845_qos_linear),
 		.entries = sdm845_qos_linear
@@ -929,6 +930,7 @@ static const struct dpu_perf_cfg sc7180_perf_data = {
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -956,6 +958,7 @@ static const struct dpu_perf_cfg sm8150_perf_data = {
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff8, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sm8150_qos_linear),
 		.entries = sm8150_qos_linear
@@ -984,6 +987,7 @@ static const struct dpu_perf_cfg sm8250_perf_data = {
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 35,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -1012,6 +1016,7 @@ static const struct dpu_perf_cfg sc7280_perf_data = {
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xffff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xff00, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_macrotile),
 		.entries = sc7180_qos_macrotile
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 0712752742f4..cdcaf470f148 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -89,13 +89,6 @@ static void mdp4_disable_commit(struct msm_kms *kms)
 
 static void mdp4_prepare_commit(struct msm_kms *kms, struct drm_atomic_state *state)
 {
-	int i;
-	struct drm_crtc *crtc;
-	struct drm_crtc_state *crtc_state;
-
-	/* see 119ecb7fd */
-	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
-		drm_crtc_vblank_get(crtc);
 }
 
 static void mdp4_flush_commit(struct msm_kms *kms, unsigned crtc_mask)
@@ -114,12 +107,6 @@ static void mdp4_wait_flush(struct msm_kms *kms, unsigned crtc_mask)
 
 static void mdp4_complete_commit(struct msm_kms *kms, unsigned crtc_mask)
 {
-	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
-	struct drm_crtc *crtc;
-
-	/* see 119ecb7fd */
-	for_each_crtc_mask(mdp4_kms->dev, crtc, crtc_mask)
-		drm_crtc_vblank_put(crtc);
 }
 
 static long mdp4_round_pixclk(struct msm_kms *kms, unsigned long rate,
@@ -412,6 +399,7 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
 	struct mdp4_platform_config *config = mdp4_get_config(pdev);
+	struct msm_drm_private *priv = dev->dev_private;
 	struct mdp4_kms *mdp4_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
@@ -431,7 +419,8 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 		goto fail;
 	}
 
-	kms = &mdp4_kms->base.base;
+	priv->kms = &mdp4_kms->base.base;
+	kms = priv->kms;
 
 	mdp4_kms->dev = dev;
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 6856223e91e1..c1514f2cb409 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -83,13 +83,6 @@ struct dp_ctrl_private {
 	struct completion video_comp;
 };
 
-struct dp_cr_status {
-	u8 lane_0_1;
-	u8 lane_2_3;
-};
-
-#define DP_LANE0_1_CR_DONE	0x11
-
 static int dp_aux_link_configure(struct drm_dp_aux *aux,
 					struct dp_link_info *link)
 {
@@ -1080,7 +1073,7 @@ static int dp_ctrl_read_link_status(struct dp_ctrl_private *ctrl,
 }
 
 static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int tries, old_v_level, ret = 0;
 	u8 link_status[DP_LINK_STATUS_SIZE];
@@ -1109,9 +1102,6 @@ static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
 		if (ret)
 			return ret;
 
-		cr->lane_0_1 = link_status[0];
-		cr->lane_2_3 = link_status[1];
-
 		if (drm_dp_clock_recovery_ok(link_status,
 			ctrl->link->link_params.num_lanes)) {
 			return 0;
@@ -1188,7 +1178,7 @@ static void dp_ctrl_clear_training_pattern(struct dp_ctrl_private *ctrl)
 }
 
 static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int tries = 0, ret = 0;
 	char pattern;
@@ -1204,10 +1194,6 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	else
 		pattern = DP_TRAINING_PATTERN_2;
 
-	ret = dp_ctrl_update_vx_px(ctrl);
-	if (ret)
-		return ret;
-
 	ret = dp_catalog_ctrl_set_pattern(ctrl->catalog, pattern);
 	if (ret)
 		return ret;
@@ -1220,8 +1206,6 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 		ret = dp_ctrl_read_link_status(ctrl, link_status);
 		if (ret)
 			return ret;
-		cr->lane_0_1 = link_status[0];
-		cr->lane_2_3 = link_status[1];
 
 		if (drm_dp_channel_eq_ok(link_status,
 			ctrl->link->link_params.num_lanes)) {
@@ -1241,7 +1225,7 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 static int dp_ctrl_reinitialize_mainlink(struct dp_ctrl_private *ctrl);
 
 static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int ret = 0;
 	u8 encoding = DP_SET_ANSI_8B10B;
@@ -1257,7 +1241,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	drm_dp_dpcd_write(ctrl->aux, DP_MAIN_LINK_CHANNEL_CODING_SET,
 				&encoding, 1);
 
-	ret = dp_ctrl_link_train_1(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train_1(ctrl, training_step);
 	if (ret) {
 		DRM_ERROR("link training #1 failed. ret=%d\n", ret);
 		goto end;
@@ -1266,7 +1250,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	/* print success info as this is a result of user initiated action */
 	DRM_DEBUG_DP("link training #1 successful\n");
 
-	ret = dp_ctrl_link_train_2(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train_2(ctrl, training_step);
 	if (ret) {
 		DRM_ERROR("link training #2 failed. ret=%d\n", ret);
 		goto end;
@@ -1282,7 +1266,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 }
 
 static int dp_ctrl_setup_main_link(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int ret = 0;
 
@@ -1297,7 +1281,7 @@ static int dp_ctrl_setup_main_link(struct dp_ctrl_private *ctrl,
 	 * a link training pattern, we have to first do soft reset.
 	 */
 
-	ret = dp_ctrl_link_train(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train(ctrl, training_step);
 
 	return ret;
 }
@@ -1494,14 +1478,16 @@ static int dp_ctrl_deinitialize_mainlink(struct dp_ctrl_private *ctrl)
 static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
-	struct dp_cr_status cr;
 	int training_step = DP_TRAINING_NONE;
 
 	dp_ctrl_push_idle(&ctrl->dp_ctrl);
 
+	ctrl->link->phy_params.p_level = 0;
+	ctrl->link->phy_params.v_level = 0;
+
 	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
 
-	ret = dp_ctrl_setup_main_link(ctrl, &cr, &training_step);
+	ret = dp_ctrl_setup_main_link(ctrl, &training_step);
 	if (ret)
 		goto end;
 
@@ -1632,6 +1618,35 @@ void dp_ctrl_handle_sink_request(struct dp_ctrl *dp_ctrl)
 	}
 }
 
+static bool dp_ctrl_clock_recovery_any_ok(
+			const u8 link_status[DP_LINK_STATUS_SIZE],
+			int lane_count)
+{
+	int reduced_cnt;
+
+	if (lane_count <= 1)
+		return false;
+
+	/*
+	 * only interested in the lane number after reduced
+	 * lane_count = 4, then only interested in 2 lanes
+	 * lane_count = 2, then only interested in 1 lane
+	 */
+	reduced_cnt = lane_count >> 1;
+
+	return drm_dp_clock_recovery_ok(link_status, reduced_cnt);
+}
+
+static bool dp_ctrl_channel_eq_ok(struct dp_ctrl_private *ctrl)
+{
+	u8 link_status[DP_LINK_STATUS_SIZE];
+	int num_lanes = ctrl->link->link_params.num_lanes;
+
+	dp_ctrl_read_link_status(ctrl, link_status);
+
+	return drm_dp_channel_eq_ok(link_status, num_lanes);
+}
+
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 {
 	int rc = 0;
@@ -1639,7 +1654,7 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	u32 rate = 0;
 	int link_train_max_retries = 5;
 	u32 const phy_cts_pixel_clk_khz = 148500;
-	struct dp_cr_status cr;
+	u8 link_status[DP_LINK_STATUS_SIZE];
 	unsigned int training_step;
 
 	if (!dp_ctrl)
@@ -1666,6 +1681,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 		ctrl->link->link_params.rate,
 		ctrl->link->link_params.num_lanes, ctrl->dp_ctrl.pixel_rate);
 
+	ctrl->link->phy_params.p_level = 0;
+	ctrl->link->phy_params.v_level = 0;
+
 	rc = dp_ctrl_enable_mainlink_clocks(ctrl);
 	if (rc)
 		return rc;
@@ -1679,19 +1697,21 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 		}
 
 		training_step = DP_TRAINING_NONE;
-		rc = dp_ctrl_setup_main_link(ctrl, &cr, &training_step);
+		rc = dp_ctrl_setup_main_link(ctrl, &training_step);
 		if (rc == 0) {
 			/* training completed successfully */
 			break;
 		} else if (training_step == DP_TRAINING_1) {
 			/* link train_1 failed */
-			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+			if (!dp_catalog_link_is_connected(ctrl->catalog))
 				break;
-			}
+
+			dp_ctrl_read_link_status(ctrl, link_status);
 
 			rc = dp_ctrl_link_rate_down_shift(ctrl);
 			if (rc < 0) { /* already in RBR = 1.6G */
-				if (cr.lane_0_1 & DP_LANE0_1_CR_DONE) {
+				if (dp_ctrl_clock_recovery_any_ok(link_status,
+					ctrl->link->link_params.num_lanes)) {
 					/*
 					 * some lanes are ready,
 					 * reduce lane number
@@ -1707,12 +1727,18 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 				}
 			}
 		} else if (training_step == DP_TRAINING_2) {
-			/* link train_2 failed, lower lane rate */
-			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+			/* link train_2 failed */
+			if (!dp_catalog_link_is_connected(ctrl->catalog))
 				break;
-			}
 
-			rc = dp_ctrl_link_lane_down_shift(ctrl);
+			dp_ctrl_read_link_status(ctrl, link_status);
+
+			if (!drm_dp_clock_recovery_ok(link_status,
+					ctrl->link->link_params.num_lanes))
+				rc = dp_ctrl_link_rate_down_shift(ctrl);
+			else
+				rc = dp_ctrl_link_lane_down_shift(ctrl);
+
 			if (rc < 0) {
 				/* end with failure */
 				break; /* lane == 1 already */
@@ -1723,17 +1749,19 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN)
 		return rc;
 
-	/* stop txing train pattern */
-	dp_ctrl_clear_training_pattern(ctrl);
+	if (rc == 0) {  /* link train successfully */
+		/*
+		 * do not stop train pattern here
+		 * stop link training at on_stream
+		 * to pass compliance test
+		 */
+	} else  {
+		/*
+		 * link training failed
+		 * end txing train pattern here
+		 */
+		dp_ctrl_clear_training_pattern(ctrl);
 
-	/*
-	 * keep transmitting idle pattern until video ready
-	 * to avoid main link from loss of sync
-	 */
-	if (rc == 0)  /* link train successfully */
-		dp_ctrl_push_idle(dp_ctrl);
-	else  {
-		/* link training failed */
 		dp_ctrl_deinitialize_mainlink(ctrl);
 		rc = -ECONNRESET;
 	}
@@ -1741,9 +1769,15 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	return rc;
 }
 
+static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
+{
+	int training_step = DP_TRAINING_NONE;
+
+	return dp_ctrl_setup_main_link(ctrl, &training_step);
+}
+
 int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 {
-	u32 rate = 0;
 	int ret = 0;
 	bool mainlink_ready = false;
 	struct dp_ctrl_private *ctrl;
@@ -1753,10 +1787,6 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 
 	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
 
-	rate = ctrl->panel->link_info.rate;
-
-	ctrl->link->link_params.rate = rate;
-	ctrl->link->link_params.num_lanes = ctrl->panel->link_info.num_lanes;
 	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
 
 	DRM_DEBUG_DP("rate=%d, num_lanes=%d, pixel_rate=%d\n",
@@ -1771,6 +1801,12 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		}
 	}
 
+	if (!dp_ctrl_channel_eq_ok(ctrl))
+		dp_ctrl_link_retrain(ctrl);
+
+	/* stop txing train pattern to end link training */
+	dp_ctrl_clear_training_pattern(ctrl);
+
 	ret = dp_ctrl_enable_stream_clocks(ctrl);
 	if (ret) {
 		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 9cc816663668..6eeb9a14b584 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -272,7 +272,7 @@ static u8 dp_panel_get_edid_checksum(struct edid *edid)
 {
 	struct edid *last_block;
 	u8 *raw_edid;
-	bool is_edid_corrupt;
+	bool is_edid_corrupt = false;
 
 	if (!edid) {
 		DRM_ERROR("invalid edid input\n");
@@ -304,7 +304,12 @@ void dp_panel_handle_sink_request(struct dp_panel *dp_panel)
 	panel = container_of(dp_panel, struct dp_panel_private, dp_panel);
 
 	if (panel->link->sink_request & DP_TEST_LINK_EDID_READ) {
-		u8 checksum = dp_panel_get_edid_checksum(dp_panel->edid);
+		u8 checksum;
+
+		if (dp_panel->edid)
+			checksum = dp_panel_get_edid_checksum(dp_panel->edid);
+		else
+			checksum = dp_panel->connector->real_edid_checksum;
 
 		dp_link_send_edid_checksum(panel->link, checksum);
 		dp_link_send_test_response(panel->link);
diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index f3f1c03c7db9..763f127e4621 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -154,7 +154,6 @@ static const struct msm_dsi_config sdm660_dsi_cfg = {
 	.reg_cfg = {
 		.num = 2,
 		.regs = {
-			{"vdd", 73400, 32 },	/* 0.9 V */
 			{"vdda", 12560, 4 },	/* 1.2 V */
 		},
 	},
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index 65d68eb9e3cb..c96fd752fa1d 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -1049,7 +1049,7 @@ const struct msm_dsi_phy_cfg dsi_phy_14nm_660_cfgs = {
 	.reg_cfg = {
 		.num = 1,
 		.regs = {
-			{"vcca", 17000, 32},
+			{"vcca", 73400, 32},
 		},
 	},
 	.ops = {
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 801da917507d..512af976b7e9 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -6,6 +6,7 @@
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 
 #include "omap_dmm_tiler.h"
@@ -29,6 +30,8 @@ static int omap_plane_prepare_fb(struct drm_plane *plane,
 	if (!new_state->fb)
 		return 0;
 
+	drm_gem_plane_helper_prepare_fb(plane, new_state);
+
 	return omap_framebuffer_pin(new_state->fb);
 }
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
index 597cf1459b0a..4c6bdea5537b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -120,8 +120,12 @@ struct panfrost_device {
 };
 
 struct panfrost_mmu {
+	struct panfrost_device *pfdev;
+	struct kref refcount;
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
+	struct drm_mm mm;
+	spinlock_t mm_lock;
 	int as;
 	atomic_t as_count;
 	struct list_head list;
@@ -132,9 +136,7 @@ struct panfrost_file_priv {
 
 	struct drm_sched_entity sched_entity[NUM_JOB_SLOTS];
 
-	struct panfrost_mmu mmu;
-	struct drm_mm mm;
-	spinlock_t mm_lock;
+	struct panfrost_mmu *mmu;
 };
 
 static inline struct panfrost_device *to_panfrost_device(struct drm_device *ddev)
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 83a461bdeea8..b2aa8e050314 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -417,7 +417,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 		 * anyway, so let's not bother.
 		 */
 		if (!list_is_singular(&bo->mappings.list) ||
-		    WARN_ON_ONCE(first->mmu != &priv->mmu)) {
+		    WARN_ON_ONCE(first->mmu != priv->mmu)) {
 			ret = -EINVAL;
 			goto out_unlock_mappings;
 		}
@@ -449,32 +449,6 @@ int panfrost_unstable_ioctl_check(void)
 	return 0;
 }
 
-#define PFN_4G		(SZ_4G >> PAGE_SHIFT)
-#define PFN_4G_MASK	(PFN_4G - 1)
-#define PFN_16M		(SZ_16M >> PAGE_SHIFT)
-
-static void panfrost_drm_mm_color_adjust(const struct drm_mm_node *node,
-					 unsigned long color,
-					 u64 *start, u64 *end)
-{
-	/* Executable buffers can't start or end on a 4GB boundary */
-	if (!(color & PANFROST_BO_NOEXEC)) {
-		u64 next_seg;
-
-		if ((*start & PFN_4G_MASK) == 0)
-			(*start)++;
-
-		if ((*end & PFN_4G_MASK) == 0)
-			(*end)--;
-
-		next_seg = ALIGN(*start, PFN_4G);
-		if (next_seg - *start <= PFN_16M)
-			*start = next_seg + 1;
-
-		*end = min(*end, ALIGN(*start, PFN_4G) - 1);
-	}
-}
-
 static int
 panfrost_open(struct drm_device *dev, struct drm_file *file)
 {
@@ -489,15 +463,11 @@ panfrost_open(struct drm_device *dev, struct drm_file *file)
 	panfrost_priv->pfdev = pfdev;
 	file->driver_priv = panfrost_priv;
 
-	spin_lock_init(&panfrost_priv->mm_lock);
-
-	/* 4G enough for now. can be 48-bit */
-	drm_mm_init(&panfrost_priv->mm, SZ_32M >> PAGE_SHIFT, (SZ_4G - SZ_32M) >> PAGE_SHIFT);
-	panfrost_priv->mm.color_adjust = panfrost_drm_mm_color_adjust;
-
-	ret = panfrost_mmu_pgtable_alloc(panfrost_priv);
-	if (ret)
-		goto err_pgtable;
+	panfrost_priv->mmu = panfrost_mmu_ctx_create(pfdev);
+	if (IS_ERR(panfrost_priv->mmu)) {
+		ret = PTR_ERR(panfrost_priv->mmu);
+		goto err_free;
+	}
 
 	ret = panfrost_job_open(panfrost_priv);
 	if (ret)
@@ -506,9 +476,8 @@ panfrost_open(struct drm_device *dev, struct drm_file *file)
 	return 0;
 
 err_job:
-	panfrost_mmu_pgtable_free(panfrost_priv);
-err_pgtable:
-	drm_mm_takedown(&panfrost_priv->mm);
+	panfrost_mmu_ctx_put(panfrost_priv->mmu);
+err_free:
 	kfree(panfrost_priv);
 	return ret;
 }
@@ -521,8 +490,7 @@ panfrost_postclose(struct drm_device *dev, struct drm_file *file)
 	panfrost_perfcnt_close(file);
 	panfrost_job_close(panfrost_priv);
 
-	panfrost_mmu_pgtable_free(panfrost_priv);
-	drm_mm_takedown(&panfrost_priv->mm);
+	panfrost_mmu_ctx_put(panfrost_priv->mmu);
 	kfree(panfrost_priv);
 }
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 3e0723bc36bd..23377481f4e3 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -60,7 +60,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 
 	mutex_lock(&bo->mappings.lock);
 	list_for_each_entry(iter, &bo->mappings.list, node) {
-		if (iter->mmu == &priv->mmu) {
+		if (iter->mmu == priv->mmu) {
 			kref_get(&iter->refcount);
 			mapping = iter;
 			break;
@@ -74,16 +74,13 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 static void
 panfrost_gem_teardown_mapping(struct panfrost_gem_mapping *mapping)
 {
-	struct panfrost_file_priv *priv;
-
 	if (mapping->active)
 		panfrost_mmu_unmap(mapping);
 
-	priv = container_of(mapping->mmu, struct panfrost_file_priv, mmu);
-	spin_lock(&priv->mm_lock);
+	spin_lock(&mapping->mmu->mm_lock);
 	if (drm_mm_node_allocated(&mapping->mmnode))
 		drm_mm_remove_node(&mapping->mmnode);
-	spin_unlock(&priv->mm_lock);
+	spin_unlock(&mapping->mmu->mm_lock);
 }
 
 static void panfrost_gem_mapping_release(struct kref *kref)
@@ -94,6 +91,7 @@ static void panfrost_gem_mapping_release(struct kref *kref)
 
 	panfrost_gem_teardown_mapping(mapping);
 	drm_gem_object_put(&mapping->obj->base.base);
+	panfrost_mmu_ctx_put(mapping->mmu);
 	kfree(mapping);
 }
 
@@ -143,11 +141,11 @@ int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
 	else
 		align = size >= SZ_2M ? SZ_2M >> PAGE_SHIFT : 0;
 
-	mapping->mmu = &priv->mmu;
-	spin_lock(&priv->mm_lock);
-	ret = drm_mm_insert_node_generic(&priv->mm, &mapping->mmnode,
+	mapping->mmu = panfrost_mmu_ctx_get(priv->mmu);
+	spin_lock(&mapping->mmu->mm_lock);
+	ret = drm_mm_insert_node_generic(&mapping->mmu->mm, &mapping->mmnode,
 					 size >> PAGE_SHIFT, align, color, 0);
-	spin_unlock(&priv->mm_lock);
+	spin_unlock(&mapping->mmu->mm_lock);
 	if (ret)
 		goto err;
 
@@ -176,7 +174,7 @@ void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
 
 	mutex_lock(&bo->mappings.lock);
 	list_for_each_entry(iter, &bo->mappings.list, node) {
-		if (iter->mmu == &priv->mmu) {
+		if (iter->mmu == priv->mmu) {
 			mapping = iter;
 			list_del(&iter->node);
 			break;
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 6003cfeb1322..682f2161b999 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -165,7 +165,7 @@ static void panfrost_job_hw_submit(struct panfrost_job *job, int js)
 		return;
 	}
 
-	cfg = panfrost_mmu_as_get(pfdev, &job->file_priv->mmu);
+	cfg = panfrost_mmu_as_get(pfdev, job->file_priv->mmu);
 
 	job_write(pfdev, JS_HEAD_NEXT_LO(js), jc_head & 0xFFFFFFFF);
 	job_write(pfdev, JS_HEAD_NEXT_HI(js), jc_head >> 32);
@@ -527,7 +527,7 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
 			if (job) {
 				pfdev->jobs[j] = NULL;
 
-				panfrost_mmu_as_put(pfdev, &job->file_priv->mmu);
+				panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
 				panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
 
 				dma_fence_signal_locked(job->done_fence);
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 0581186ebfb3..eea6ade902cb 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -1,5 +1,8 @@
 // SPDX-License-Identifier:	GPL-2.0
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
+
+#include <drm/panfrost_drm.h>
+
 #include <linux/atomic.h>
 #include <linux/bitfield.h>
 #include <linux/delay.h>
@@ -52,25 +55,16 @@ static int write_cmd(struct panfrost_device *pfdev, u32 as_nr, u32 cmd)
 }
 
 static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
-			u64 iova, size_t size)
+			u64 iova, u64 size)
 {
 	u8 region_width;
 	u64 region = iova & PAGE_MASK;
-	/*
-	 * fls returns:
-	 * 1 .. 32
-	 *
-	 * 10 + fls(num_pages)
-	 * results in the range (11 .. 42)
-	 */
-
-	size = round_up(size, PAGE_SIZE);
 
-	region_width = 10 + fls(size >> PAGE_SHIFT);
-	if ((size >> PAGE_SHIFT) != (1ul << (region_width - 11))) {
-		/* not pow2, so must go up to the next pow2 */
-		region_width += 1;
-	}
+	/* The size is encoded as ceil(log2) minus(1), which may be calculated
+	 * with fls. The size must be clamped to hardware bounds.
+	 */
+	size = max_t(u64, size, AS_LOCK_REGION_MIN_SIZE);
+	region_width = fls64(size - 1) - 1;
 	region |= region_width;
 
 	/* Lock the region that needs to be updated */
@@ -81,7 +75,7 @@ static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
 
 
 static int mmu_hw_do_operation_locked(struct panfrost_device *pfdev, int as_nr,
-				      u64 iova, size_t size, u32 op)
+				      u64 iova, u64 size, u32 op)
 {
 	if (as_nr < 0)
 		return 0;
@@ -98,7 +92,7 @@ static int mmu_hw_do_operation_locked(struct panfrost_device *pfdev, int as_nr,
 
 static int mmu_hw_do_operation(struct panfrost_device *pfdev,
 			       struct panfrost_mmu *mmu,
-			       u64 iova, size_t size, u32 op)
+			       u64 iova, u64 size, u32 op)
 {
 	int ret;
 
@@ -115,7 +109,7 @@ static void panfrost_mmu_enable(struct panfrost_device *pfdev, struct panfrost_m
 	u64 transtab = cfg->arm_mali_lpae_cfg.transtab;
 	u64 memattr = cfg->arm_mali_lpae_cfg.memattr;
 
-	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0UL, AS_COMMAND_FLUSH_MEM);
+	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0ULL, AS_COMMAND_FLUSH_MEM);
 
 	mmu_write(pfdev, AS_TRANSTAB_LO(as_nr), transtab & 0xffffffffUL);
 	mmu_write(pfdev, AS_TRANSTAB_HI(as_nr), transtab >> 32);
@@ -131,7 +125,7 @@ static void panfrost_mmu_enable(struct panfrost_device *pfdev, struct panfrost_m
 
 static void panfrost_mmu_disable(struct panfrost_device *pfdev, u32 as_nr)
 {
-	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0UL, AS_COMMAND_FLUSH_MEM);
+	mmu_hw_do_operation_locked(pfdev, as_nr, 0, ~0ULL, AS_COMMAND_FLUSH_MEM);
 
 	mmu_write(pfdev, AS_TRANSTAB_LO(as_nr), 0);
 	mmu_write(pfdev, AS_TRANSTAB_HI(as_nr), 0);
@@ -231,7 +225,7 @@ static size_t get_pgsize(u64 addr, size_t size)
 
 static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 				     struct panfrost_mmu *mmu,
-				     u64 iova, size_t size)
+				     u64 iova, u64 size)
 {
 	if (mmu->as < 0)
 		return;
@@ -337,7 +331,7 @@ static void mmu_tlb_inv_context_s1(void *cookie)
 
 static void mmu_tlb_sync_context(void *cookie)
 {
-	//struct panfrost_device *pfdev = cookie;
+	//struct panfrost_mmu *mmu = cookie;
 	// TODO: Wait 1000 GPU cycles for HW_ISSUE_6367/T60X
 }
 
@@ -352,57 +346,10 @@ static const struct iommu_flush_ops mmu_tlb_ops = {
 	.tlb_flush_walk = mmu_tlb_flush_walk,
 };
 
-int panfrost_mmu_pgtable_alloc(struct panfrost_file_priv *priv)
-{
-	struct panfrost_mmu *mmu = &priv->mmu;
-	struct panfrost_device *pfdev = priv->pfdev;
-
-	INIT_LIST_HEAD(&mmu->list);
-	mmu->as = -1;
-
-	mmu->pgtbl_cfg = (struct io_pgtable_cfg) {
-		.pgsize_bitmap	= SZ_4K | SZ_2M,
-		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
-		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
-		.coherent_walk	= pfdev->coherent,
-		.tlb		= &mmu_tlb_ops,
-		.iommu_dev	= pfdev->dev,
-	};
-
-	mmu->pgtbl_ops = alloc_io_pgtable_ops(ARM_MALI_LPAE, &mmu->pgtbl_cfg,
-					      priv);
-	if (!mmu->pgtbl_ops)
-		return -EINVAL;
-
-	return 0;
-}
-
-void panfrost_mmu_pgtable_free(struct panfrost_file_priv *priv)
-{
-	struct panfrost_device *pfdev = priv->pfdev;
-	struct panfrost_mmu *mmu = &priv->mmu;
-
-	spin_lock(&pfdev->as_lock);
-	if (mmu->as >= 0) {
-		pm_runtime_get_noresume(pfdev->dev);
-		if (pm_runtime_active(pfdev->dev))
-			panfrost_mmu_disable(pfdev, mmu->as);
-		pm_runtime_put_autosuspend(pfdev->dev);
-
-		clear_bit(mmu->as, &pfdev->as_alloc_mask);
-		clear_bit(mmu->as, &pfdev->as_in_use_mask);
-		list_del(&mmu->list);
-	}
-	spin_unlock(&pfdev->as_lock);
-
-	free_io_pgtable_ops(mmu->pgtbl_ops);
-}
-
 static struct panfrost_gem_mapping *
 addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
 {
 	struct panfrost_gem_mapping *mapping = NULL;
-	struct panfrost_file_priv *priv;
 	struct drm_mm_node *node;
 	u64 offset = addr >> PAGE_SHIFT;
 	struct panfrost_mmu *mmu;
@@ -415,11 +362,10 @@ addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
 	goto out;
 
 found_mmu:
-	priv = container_of(mmu, struct panfrost_file_priv, mmu);
 
-	spin_lock(&priv->mm_lock);
+	spin_lock(&mmu->mm_lock);
 
-	drm_mm_for_each_node(node, &priv->mm) {
+	drm_mm_for_each_node(node, &mmu->mm) {
 		if (offset >= node->start &&
 		    offset < (node->start + node->size)) {
 			mapping = drm_mm_node_to_panfrost_mapping(node);
@@ -429,7 +375,7 @@ addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
 		}
 	}
 
-	spin_unlock(&priv->mm_lock);
+	spin_unlock(&mmu->mm_lock);
 out:
 	spin_unlock(&pfdev->as_lock);
 	return mapping;
@@ -542,6 +488,107 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 	return ret;
 }
 
+static void panfrost_mmu_release_ctx(struct kref *kref)
+{
+	struct panfrost_mmu *mmu = container_of(kref, struct panfrost_mmu,
+						refcount);
+	struct panfrost_device *pfdev = mmu->pfdev;
+
+	spin_lock(&pfdev->as_lock);
+	if (mmu->as >= 0) {
+		pm_runtime_get_noresume(pfdev->dev);
+		if (pm_runtime_active(pfdev->dev))
+			panfrost_mmu_disable(pfdev, mmu->as);
+		pm_runtime_put_autosuspend(pfdev->dev);
+
+		clear_bit(mmu->as, &pfdev->as_alloc_mask);
+		clear_bit(mmu->as, &pfdev->as_in_use_mask);
+		list_del(&mmu->list);
+	}
+	spin_unlock(&pfdev->as_lock);
+
+	free_io_pgtable_ops(mmu->pgtbl_ops);
+	drm_mm_takedown(&mmu->mm);
+	kfree(mmu);
+}
+
+void panfrost_mmu_ctx_put(struct panfrost_mmu *mmu)
+{
+	kref_put(&mmu->refcount, panfrost_mmu_release_ctx);
+}
+
+struct panfrost_mmu *panfrost_mmu_ctx_get(struct panfrost_mmu *mmu)
+{
+	kref_get(&mmu->refcount);
+
+	return mmu;
+}
+
+#define PFN_4G		(SZ_4G >> PAGE_SHIFT)
+#define PFN_4G_MASK	(PFN_4G - 1)
+#define PFN_16M		(SZ_16M >> PAGE_SHIFT)
+
+static void panfrost_drm_mm_color_adjust(const struct drm_mm_node *node,
+					 unsigned long color,
+					 u64 *start, u64 *end)
+{
+	/* Executable buffers can't start or end on a 4GB boundary */
+	if (!(color & PANFROST_BO_NOEXEC)) {
+		u64 next_seg;
+
+		if ((*start & PFN_4G_MASK) == 0)
+			(*start)++;
+
+		if ((*end & PFN_4G_MASK) == 0)
+			(*end)--;
+
+		next_seg = ALIGN(*start, PFN_4G);
+		if (next_seg - *start <= PFN_16M)
+			*start = next_seg + 1;
+
+		*end = min(*end, ALIGN(*start, PFN_4G) - 1);
+	}
+}
+
+struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
+{
+	struct panfrost_mmu *mmu;
+
+	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
+	if (!mmu)
+		return ERR_PTR(-ENOMEM);
+
+	mmu->pfdev = pfdev;
+	spin_lock_init(&mmu->mm_lock);
+
+	/* 4G enough for now. can be 48-bit */
+	drm_mm_init(&mmu->mm, SZ_32M >> PAGE_SHIFT, (SZ_4G - SZ_32M) >> PAGE_SHIFT);
+	mmu->mm.color_adjust = panfrost_drm_mm_color_adjust;
+
+	INIT_LIST_HEAD(&mmu->list);
+	mmu->as = -1;
+
+	mmu->pgtbl_cfg = (struct io_pgtable_cfg) {
+		.pgsize_bitmap	= SZ_4K | SZ_2M,
+		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
+		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
+		.coherent_walk	= pfdev->coherent,
+		.tlb		= &mmu_tlb_ops,
+		.iommu_dev	= pfdev->dev,
+	};
+
+	mmu->pgtbl_ops = alloc_io_pgtable_ops(ARM_MALI_LPAE, &mmu->pgtbl_cfg,
+					      mmu);
+	if (!mmu->pgtbl_ops) {
+		kfree(mmu);
+		return ERR_PTR(-EINVAL);
+	}
+
+	kref_init(&mmu->refcount);
+
+	return mmu;
+}
+
 static const char *access_type_name(struct panfrost_device *pfdev,
 		u32 fault_status)
 {
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.h b/drivers/gpu/drm/panfrost/panfrost_mmu.h
index 44fc2edf63ce..cc2a0d307feb 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.h
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.h
@@ -18,7 +18,8 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev);
 u32 panfrost_mmu_as_get(struct panfrost_device *pfdev, struct panfrost_mmu *mmu);
 void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu);
 
-int panfrost_mmu_pgtable_alloc(struct panfrost_file_priv *priv);
-void panfrost_mmu_pgtable_free(struct panfrost_file_priv *priv);
+struct panfrost_mmu *panfrost_mmu_ctx_get(struct panfrost_mmu *mmu);
+void panfrost_mmu_ctx_put(struct panfrost_mmu *mmu);
+struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev);
 
 #endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_regs.h b/drivers/gpu/drm/panfrost/panfrost_regs.h
index eddaa62ad8b0..2ae3a4d301d3 100644
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -318,6 +318,8 @@
 #define AS_FAULTSTATUS_ACCESS_TYPE_READ		(0x2 << 8)
 #define AS_FAULTSTATUS_ACCESS_TYPE_WRITE	(0x3 << 8)
 
+#define AS_LOCK_REGION_MIN_SIZE                 (1ULL << 15)
+
 #define gpu_write(dev, reg, data) writel(data, dev->iomem + reg)
 #define gpu_read(dev, reg) readl(dev->iomem + reg)
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index c22551c2facb..2a06ec1cbefb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -559,6 +559,13 @@ static int rcar_du_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void rcar_du_shutdown(struct platform_device *pdev)
+{
+	struct rcar_du_device *rcdu = platform_get_drvdata(pdev);
+
+	drm_atomic_helper_shutdown(&rcdu->ddev);
+}
+
 static int rcar_du_probe(struct platform_device *pdev)
 {
 	struct rcar_du_device *rcdu;
@@ -615,6 +622,7 @@ static int rcar_du_probe(struct platform_device *pdev)
 static struct platform_driver rcar_du_platform_driver = {
 	.probe		= rcar_du_probe,
 	.remove		= rcar_du_remove,
+	.shutdown	= rcar_du_shutdown,
 	.driver		= {
 		.name	= "rcar-du",
 		.pm	= &rcar_du_pm_ops,
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index edee565334d8..155f305e7c4e 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1205,7 +1205,9 @@ static int vc4_hdmi_audio_trigger(struct snd_pcm_substream *substream, int cmd,
 		HDMI_WRITE(HDMI_MAI_CTL,
 			   VC4_SET_FIELD(vc4_hdmi->audio.channels,
 					 VC4_HD_MAI_CTL_CHNUM) |
-			   VC4_HD_MAI_CTL_ENABLE);
+					 VC4_HD_MAI_CTL_WHOLSMP |
+					 VC4_HD_MAI_CTL_CHALIGN |
+					 VC4_HD_MAI_CTL_ENABLE);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		HDMI_WRITE(HDMI_MAI_CTL,
diff --git a/drivers/gpu/drm/vkms/vkms_plane.c b/drivers/gpu/drm/vkms/vkms_plane.c
index 6d310d31b75d..1b10ab2b80a3 100644
--- a/drivers/gpu/drm/vkms/vkms_plane.c
+++ b/drivers/gpu/drm/vkms/vkms_plane.c
@@ -8,7 +8,6 @@
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_plane_helper.h>
-#include <drm/drm_gem_shmem_helper.h>
 
 #include "vkms_drv.h"
 
@@ -150,45 +149,10 @@ static int vkms_plane_atomic_check(struct drm_plane *plane,
 	return 0;
 }
 
-static int vkms_prepare_fb(struct drm_plane *plane,
-			   struct drm_plane_state *state)
-{
-	struct drm_gem_object *gem_obj;
-	struct dma_buf_map map;
-	int ret;
-
-	if (!state->fb)
-		return 0;
-
-	gem_obj = drm_gem_fb_get_obj(state->fb, 0);
-	ret = drm_gem_shmem_vmap(gem_obj, &map);
-	if (ret)
-		DRM_ERROR("vmap failed: %d\n", ret);
-
-	return drm_gem_plane_helper_prepare_fb(plane, state);
-}
-
-static void vkms_cleanup_fb(struct drm_plane *plane,
-			    struct drm_plane_state *old_state)
-{
-	struct drm_gem_object *gem_obj;
-	struct drm_gem_shmem_object *shmem_obj;
-	struct dma_buf_map map;
-
-	if (!old_state->fb)
-		return;
-
-	gem_obj = drm_gem_fb_get_obj(old_state->fb, 0);
-	shmem_obj = to_drm_gem_shmem_obj(drm_gem_fb_get_obj(old_state->fb, 0));
-	dma_buf_map_set_vaddr(&map, shmem_obj->vaddr);
-	drm_gem_shmem_vunmap(gem_obj, &map);
-}
-
 static const struct drm_plane_helper_funcs vkms_primary_helper_funcs = {
 	.atomic_update		= vkms_plane_atomic_update,
 	.atomic_check		= vkms_plane_atomic_check,
-	.prepare_fb		= vkms_prepare_fb,
-	.cleanup_fb		= vkms_cleanup_fb,
+	DRM_GEM_SHADOW_PLANE_HELPER_FUNCS,
 };
 
 struct drm_plane *vkms_plane_init(struct vkms_device *vkmsdev,
diff --git a/drivers/gpu/drm/vmwgfx/ttm_memory.c b/drivers/gpu/drm/vmwgfx/ttm_memory.c
index aeb0a22a2c34..edd17c30d5a5 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_memory.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_memory.c
@@ -435,8 +435,10 @@ int ttm_mem_global_init(struct ttm_mem_global *glob, struct device *dev)
 
 	si_meminfo(&si);
 
+	spin_lock(&glob->lock);
 	/* set it as 0 by default to keep original behavior of OOM */
 	glob->lower_mem_limit = 0;
+	spin_unlock(&glob->lock);
 
 	ret = ttm_mem_init_kernel_zone(glob, &si);
 	if (unlikely(ret != 0))
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
index 81f525a82b77..4e7de45407c8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
@@ -715,7 +715,7 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biv: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of view id data.
@@ -725,11 +725,9 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * contains the command data.
  */
 static void vmw_collect_view_ids(struct vmw_ctx_binding_state *cbs,
-				 const struct vmw_ctx_bindinfo *bi,
+				 const struct vmw_ctx_bindinfo_view *biv,
 				 u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_view *biv =
-		container_of(bi, struct vmw_ctx_bindinfo_view, bi);
 	unsigned long i;
 
 	cbs->bind_cmd_count = 0;
@@ -838,7 +836,7 @@ static int vmw_emit_set_sr(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->render_targets[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->render_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetRenderTargets body;
@@ -874,7 +872,7 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biso: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of SVGA3dSoTarget data.
@@ -884,11 +882,9 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * contains the command data.
  */
 static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
-				   const struct vmw_ctx_bindinfo *bi,
+				   const struct vmw_ctx_bindinfo_so_target *biso,
 				   u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_so_target *biso =
-		container_of(bi, struct vmw_ctx_bindinfo_so_target, bi);
 	unsigned long i;
 	SVGA3dSoTarget *so_buffer = (SVGA3dSoTarget *) cbs->bind_cmd_buffer;
 
@@ -919,7 +915,7 @@ static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_so_target(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->so_targets[0].bi;
+	const struct vmw_ctx_bindinfo_so_target *loc = &cbs->so_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetSOTargets body;
@@ -1066,7 +1062,7 @@ static int vmw_emit_set_vb(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[0].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[0].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetUAViews body;
@@ -1096,7 +1092,7 @@ static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_cs_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[1].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[1].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetCSUAViews body;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
index 2e23e537cdf5..dac4624c5dc1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
@@ -516,7 +516,7 @@ static void vmw_cmdbuf_work_func(struct work_struct *work)
 	struct vmw_cmdbuf_man *man =
 		container_of(work, struct vmw_cmdbuf_man, work);
 	struct vmw_cmdbuf_header *entry, *next;
-	uint32_t dummy;
+	uint32_t dummy = 0;
 	bool send_fence = false;
 	struct list_head restart_head[SVGA_CB_CONTEXT_MAX];
 	int i;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index b262d61d839d..9487faff5229 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -159,6 +159,7 @@ void vmw_cmdbuf_res_commit(struct list_head *list)
 void vmw_cmdbuf_res_revert(struct list_head *list)
 {
 	struct vmw_cmdbuf_res *entry, *next;
+	int ret;
 
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
@@ -166,7 +167,8 @@ void vmw_cmdbuf_res_revert(struct list_head *list)
 			vmw_cmdbuf_res_free(entry->man, entry);
 			break;
 		case VMW_CMDBUF_RES_DEL:
-			drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			ret = drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			BUG_ON(ret);
 			list_del(&entry->head);
 			list_add_tail(&entry->head, &entry->man->list);
 			entry->state = VMW_CMDBUF_RES_COMMITTED;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index d6a6d8a3387a..319ecca5d1cb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2546,6 +2546,8 @@ static int vmw_cmd_dx_so_define(struct vmw_private *dev_priv,
 
 	so_type = vmw_so_cmd_to_type(header->id);
 	res = vmw_context_cotable(ctx_node->ctx, vmw_so_cotables[so_type]);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 	cmd = container_of(header, typeof(*cmd), header);
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index f2d625415458..2d8caf09f172 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -506,11 +506,13 @@ static void vmw_mob_pt_setup(struct vmw_mob *mob,
 {
 	unsigned long num_pt_pages = 0;
 	struct ttm_buffer_object *bo = mob->pt_bo;
-	struct vmw_piter save_pt_iter;
+	struct vmw_piter save_pt_iter = {0};
 	struct vmw_piter pt_iter;
 	const struct vmw_sg_table *vsgt;
 	int ret;
 
+	BUG_ON(num_data_pages == 0);
+
 	ret = ttm_bo_reserve(bo, false, true, NULL);
 	BUG_ON(ret != 0);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 609269625468..e90fd3d16697 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -154,6 +154,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 	/* HB port can't access encrypted memory. */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_high;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = (uintptr_t) msg;
 		di = channel->cookie_low;
@@ -161,7 +162,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 		VMW_PORT_HB_OUT(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			msg_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16) |
+			VMWARE_HYPERVISOR_HB | channel_id |
 			VMWARE_HYPERVISOR_OUT,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
@@ -209,6 +210,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 	/* HB port can't access encrypted memory */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_low;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = channel->cookie_high;
 		di = (uintptr_t) reply;
@@ -216,7 +218,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 		VMW_PORT_HB_IN(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			reply_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16),
+			VMWARE_HYPERVISOR_HB | channel_id,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 35f02958ee2c..f275a08999ef 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -114,6 +114,7 @@ static void vmw_resource_release(struct kref *kref)
 	    container_of(kref, struct vmw_resource, kref);
 	struct vmw_private *dev_priv = res->dev_priv;
 	int id;
+	int ret;
 	struct idr *idr = &dev_priv->res_idr[res->func->res_type];
 
 	spin_lock(&dev_priv->resource_lock);
@@ -122,7 +123,8 @@ static void vmw_resource_release(struct kref *kref)
 	if (res->backup) {
 		struct ttm_buffer_object *bo = &res->backup->base;
 
-		ttm_bo_reserve(bo, false, false, NULL);
+		ret = ttm_bo_reserve(bo, false, false, NULL);
+		BUG_ON(ret);
 		if (vmw_resource_mob_attached(res) &&
 		    res->func->unbind != NULL) {
 			struct ttm_validate_buffer val_buf;
@@ -1002,7 +1004,9 @@ int vmw_resource_pin(struct vmw_resource *res, bool interruptible)
 		if (res->backup) {
 			vbo = res->backup;
 
-			ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			ret = ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			if (ret)
+				goto out_no_validate;
 			if (!vbo->base.pin_count) {
 				ret = ttm_bo_validate
 					(&vbo->base,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
index 2877c7b43bd7..615bf9ca03d7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
@@ -539,7 +539,8 @@ const SVGACOTableType vmw_so_cotables[] = {
 	[vmw_so_ds] = SVGA_COTABLE_DEPTHSTENCIL,
 	[vmw_so_rs] = SVGA_COTABLE_RASTERIZERSTATE,
 	[vmw_so_ss] = SVGA_COTABLE_SAMPLER,
-	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT
+	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT,
+	[vmw_so_max]= SVGA_COTABLE_MAX
 };
 
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index beab3e19d8e2..0c62cd400b64 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -869,7 +869,7 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 	user_srf->prime.base.shareable = false;
 	user_srf->prime.base.tfile = NULL;
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	/**
 	 * From this point, the generic resource management functions
@@ -1540,7 +1540,7 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 
 	user_srf = container_of(srf, struct vmw_user_surface, srf);
 	if (drm_is_primary_client(file_priv))
-		user_srf->master = drm_master_get(file_priv->master);
+		user_srf->master = drm_file_get_master(file_priv);
 
 	ret = ttm_read_lock(&dev_priv->reservation_sem, true);
 	if (unlikely(ret != 0))
@@ -1883,7 +1883,6 @@ static void vmw_surface_dirty_range_add(struct vmw_resource *res, size_t start,
 static int vmw_surface_dirty_sync(struct vmw_resource *res)
 {
 	struct vmw_private *dev_priv = res->dev_priv;
-	bool has_dx = 0;
 	u32 i, num_dirty;
 	struct vmw_surface_dirty *dirty =
 		(struct vmw_surface_dirty *) res->dirty;
@@ -1910,7 +1909,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
 	if (!num_dirty)
 		goto out;
 
-	alloc_size = num_dirty * ((has_dx) ? sizeof(*cmd1) : sizeof(*cmd2));
+	alloc_size = num_dirty * ((has_sm4_context(dev_priv)) ? sizeof(*cmd1) : sizeof(*cmd2));
 	cmd = VMW_CMD_RESERVE(dev_priv, alloc_size);
 	if (!cmd)
 		return -ENOMEM;
@@ -1928,7 +1927,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
 		 * DX_UPDATE_SUBRESOURCE is aware of array surfaces.
 		 * UPDATE_GB_IMAGE is not.
 		 */
-		if (has_dx) {
+		if (has_sm4_context(dev_priv)) {
 			cmd1->header.id = SVGA_3D_CMD_DX_UPDATE_SUBRESOURCE;
 			cmd1->header.size = sizeof(cmd1->body);
 			cmd1->body.sid = res->id;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index e7570f422400..bf20ca9f3a24 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -586,13 +586,13 @@ int vmw_validation_bo_validate(struct vmw_validation_context *ctx, bool intr)
 			container_of(entry->base.bo, typeof(*vbo), base);
 
 		if (entry->cpu_blit) {
-			struct ttm_operation_ctx ctx = {
+			struct ttm_operation_ctx ttm_ctx = {
 				.interruptible = intr,
 				.no_wait_gpu = false
 			};
 
 			ret = ttm_bo_validate(entry->base.bo,
-					      &vmw_nonfixed_placement, &ctx);
+					      &vmw_nonfixed_placement, &ttm_ctx);
 		} else {
 			ret = vmw_validation_bo_validate_single
 			(entry->base.bo, intr, entry->as_mob);
diff --git a/drivers/gpu/drm/xlnx/zynqmp_disp.c b/drivers/gpu/drm/xlnx/zynqmp_disp.c
index 109d627968ac..01c6ce7784dd 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_disp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_disp.c
@@ -1452,9 +1452,10 @@ zynqmp_disp_crtc_atomic_enable(struct drm_crtc *crtc,
 	struct drm_display_mode *adjusted_mode = &crtc->state->adjusted_mode;
 	int ret, vrefresh;
 
+	pm_runtime_get_sync(disp->dev);
+
 	zynqmp_disp_crtc_setup_clock(crtc, adjusted_mode);
 
-	pm_runtime_get_sync(disp->dev);
 	ret = clk_prepare_enable(disp->pclk);
 	if (ret) {
 		dev_err(disp->dev, "failed to enable a pixel clock\n");
diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index 59d1fb017da0..13811332b349 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -402,10 +402,6 @@ static int zynqmp_dp_phy_init(struct zynqmp_dp *dp)
 		}
 	}
 
-	ret = zynqmp_dp_reset(dp, false);
-	if (ret < 0)
-		return ret;
-
 	zynqmp_dp_clr(dp, ZYNQMP_DP_PHY_RESET, ZYNQMP_DP_PHY_RESET_ALL_RESET);
 
 	/*
@@ -441,8 +437,6 @@ static void zynqmp_dp_phy_exit(struct zynqmp_dp *dp)
 				ret);
 	}
 
-	zynqmp_dp_reset(dp, true);
-
 	for (i = 0; i < dp->num_lanes; i++) {
 		ret = phy_exit(dp->phy[i]);
 		if (ret)
@@ -1682,9 +1676,13 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 		return PTR_ERR(dp->reset);
 	}
 
+	ret = zynqmp_dp_reset(dp, false);
+	if (ret < 0)
+		return ret;
+
 	ret = zynqmp_dp_phy_probe(dp);
 	if (ret)
-		return ret;
+		goto err_reset;
 
 	/* Initialize the hardware. */
 	zynqmp_dp_write(dp, ZYNQMP_DP_TX_PHY_POWER_DOWN,
@@ -1696,7 +1694,7 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 
 	ret = zynqmp_dp_phy_init(dp);
 	if (ret)
-		return ret;
+		goto err_reset;
 
 	zynqmp_dp_write(dp, ZYNQMP_DP_TRANSMITTER_ENABLE, 1);
 
@@ -1708,15 +1706,18 @@ int zynqmp_dp_probe(struct zynqmp_dpsub *dpsub, struct drm_device *drm)
 					zynqmp_dp_irq_handler, IRQF_ONESHOT,
 					dev_name(dp->dev), dp);
 	if (ret < 0)
-		goto error;
+		goto err_phy_exit;
 
 	dev_dbg(dp->dev, "ZynqMP DisplayPort Tx probed with %u lanes\n",
 		dp->num_lanes);
 
 	return 0;
 
-error:
+err_phy_exit:
 	zynqmp_dp_phy_exit(dp);
+err_reset:
+	zynqmp_dp_reset(dp, true);
+
 	return ret;
 }
 
@@ -1734,4 +1735,5 @@ void zynqmp_dp_remove(struct zynqmp_dpsub *dpsub)
 	zynqmp_dp_write(dp, ZYNQMP_DP_INT_DS, 0xffffffff);
 
 	zynqmp_dp_phy_exit(dp);
+	zynqmp_dp_reset(dp, true);
 }
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 1ea1a7c0b20f..e29efcb1c040 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -115,7 +115,6 @@ obj-$(CONFIG_HID_STEELSERIES)	+= hid-steelseries.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o hid-thrustmaster.o
-obj-$(CONFIG_HID_TMINIT)	+= hid-tminit.o
 obj-$(CONFIG_HID_TIVO)		+= hid-tivo.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
 obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 3589d9945da1..9c7b64e5357a 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -186,7 +186,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 			rc = -ENOMEM;
 			goto cleanup;
 		}
-		info.period = msecs_to_jiffies(AMD_SFH_IDLE_LOOP);
+		info.period = AMD_SFH_IDLE_LOOP;
 		info.sensor_idx = cl_idx;
 		info.dma_address = cl_data->sensor_dma_addr[i];
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 68c8644234a4..f43b40450e97 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -419,8 +419,6 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 
 		if (dev->battery_status == HID_BATTERY_UNKNOWN)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else if (dev->battery_capacity == 100)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		break;
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 51b39bda9a9d..2e104682c22b 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -662,8 +662,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb653) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65a) },
-#endif
-#if IS_ENABLED(CONFIG_HID_TMINIT)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65d) },
 #endif
 #if IS_ENABLED(CONFIG_HID_TIVO)
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 46474612e73c..517141138b00 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -171,8 +171,6 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
-	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
-		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ I2C_VENDOR_ID_SYNAPTICS, I2C_PRODUCT_ID_SYNAPTICS_SYNA2393,
@@ -183,7 +181,8 @@ static const struct i2c_hid_quirks {
 	 * Sending the wakeup after reset actually break ELAN touchscreen controller
 	 */
 	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
-		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET },
+		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET |
+		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ 0, 0 }
 };
 
diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index 5668d8305b78..df712ce4b164 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -50,9 +50,9 @@
 #define CFFPS_MFR_VAUX_FAULT			BIT(6)
 #define CFFPS_MFR_CURRENT_SHARE_WARNING		BIT(7)
 
-#define CFFPS_LED_BLINK				BIT(0)
-#define CFFPS_LED_ON				BIT(1)
-#define CFFPS_LED_OFF				BIT(2)
+#define CFFPS_LED_BLINK				(BIT(0) | BIT(6))
+#define CFFPS_LED_ON				(BIT(1) | BIT(6))
+#define CFFPS_LED_OFF				(BIT(2) | BIT(6))
 #define CFFPS_BLINK_RATE_MS			250
 
 enum {
diff --git a/drivers/iio/dac/ad5624r_spi.c b/drivers/iio/dac/ad5624r_spi.c
index 9bde86982912..530529feebb5 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -229,7 +229,7 @@ static int ad5624r_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
+	st->reg = devm_regulator_get_optional(&spi->dev, "vref");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
 		if (ret)
@@ -240,6 +240,22 @@ static int ad5624r_probe(struct spi_device *spi)
 			goto error_disable_reg;
 
 		voltage_uv = ret;
+	} else {
+		if (PTR_ERR(st->reg) != -ENODEV)
+			return PTR_ERR(st->reg);
+		/* Backwards compatibility. This naming is not correct */
+		st->reg = devm_regulator_get_optional(&spi->dev, "vcc");
+		if (!IS_ERR(st->reg)) {
+			ret = regulator_enable(st->reg);
+			if (ret)
+				return ret;
+
+			ret = regulator_get_voltage(st->reg);
+			if (ret < 0)
+				goto error_disable_reg;
+
+			voltage_uv = ret;
+		}
 	}
 
 	spi_set_drvdata(spi, indio_dev);
diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 3b5ba26d7d86..3b4a0e60e605 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -89,6 +89,8 @@
 
 #define	LTC2983_STATUS_START_MASK	BIT(7)
 #define	LTC2983_STATUS_START(x)		FIELD_PREP(LTC2983_STATUS_START_MASK, x)
+#define	LTC2983_STATUS_UP_MASK		GENMASK(7, 6)
+#define	LTC2983_STATUS_UP(reg)		FIELD_GET(LTC2983_STATUS_UP_MASK, reg)
 
 #define	LTC2983_STATUS_CHAN_SEL_MASK	GENMASK(4, 0)
 #define	LTC2983_STATUS_CHAN_SEL(x) \
@@ -1362,17 +1364,16 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
 
 static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
 {
-	u32 iio_chan_t = 0, iio_chan_v = 0, chan, iio_idx = 0;
+	u32 iio_chan_t = 0, iio_chan_v = 0, chan, iio_idx = 0, status;
 	int ret;
-	unsigned long time;
-
-	/* make sure the device is up */
-	time = wait_for_completion_timeout(&st->completion,
-					    msecs_to_jiffies(250));
 
-	if (!time) {
+	/* make sure the device is up: start bit (7) is 0 and done bit (6) is 1 */
+	ret = regmap_read_poll_timeout(st->regmap, LTC2983_STATUS_REG, status,
+				       LTC2983_STATUS_UP(status) == 1, 25000,
+				       25000 * 10);
+	if (ret) {
 		dev_err(&st->spi->dev, "Device startup timed out\n");
-		return -ETIMEDOUT;
+		return ret;
 	}
 
 	st->iio_chan = devm_kzalloc(&st->spi->dev,
@@ -1492,10 +1493,11 @@ static int ltc2983_probe(struct spi_device *spi)
 	ret = ltc2983_parse_dt(st);
 	if (ret)
 		return ret;
-	/*
-	 * let's request the irq now so it is used to sync the device
-	 * startup in ltc2983_setup()
-	 */
+
+	ret = ltc2983_setup(st, true);
+	if (ret)
+		return ret;
+
 	ret = devm_request_irq(&spi->dev, spi->irq, ltc2983_irq_handler,
 			       IRQF_TRIGGER_RISING, name, st);
 	if (ret) {
@@ -1503,10 +1505,6 @@ static int ltc2983_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	ret = ltc2983_setup(st, true);
-	if (ret)
-		return ret;
-
 	indio_dev->name = name;
 	indio_dev->num_channels = st->iio_channels;
 	indio_dev->channels = st->iio_chan;
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index da8adadf4755..75b6da00065a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1187,29 +1187,34 @@ static int __init iw_cm_init(void)
 
 	ret = iwpm_init(RDMA_NL_IWCM);
 	if (ret)
-		pr_err("iw_cm: couldn't init iwpm\n");
-	else
-		rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
+		return ret;
+
 	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", 0);
 	if (!iwcm_wq)
-		return -ENOMEM;
+		goto err_alloc;
 
 	iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
 						 iwcm_ctl_table);
 	if (!iwcm_ctl_table_hdr) {
 		pr_err("iw_cm: couldn't register sysctl paths\n");
-		destroy_workqueue(iwcm_wq);
-		return -ENOMEM;
+		goto err_sysctl;
 	}
 
+	rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
 	return 0;
+
+err_sysctl:
+	destroy_workqueue(iwcm_wq);
+err_alloc:
+	iwpm_exit(RDMA_NL_IWCM);
+	return -ENOMEM;
 }
 
 static void __exit iw_cm_cleanup(void)
 {
+	rdma_nl_unregister(RDMA_NL_IWCM);
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
-	rdma_nl_unregister(RDMA_NL_IWCM);
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 51572f1dc611..72621ecd81f7 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -717,7 +717,6 @@ struct ib_qp *efa_create_qp(struct ib_pd *ibpd,
 
 	qp->qp_handle = create_qp_resp.qp_handle;
 	qp->ibqp.qp_num = create_qp_resp.qp_num;
-	qp->ibqp.qp_type = init_attr->qp_type;
 	qp->max_send_wr = init_attr->cap.max_send_wr;
 	qp->max_recv_wr = init_attr->cap.max_recv_wr;
 	qp->max_send_sge = init_attr->cap.max_send_sge;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e3a8a420c045..c076eed9c3b7 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -650,12 +650,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 
 	ppd->pkeys[default_pkey_idx] = DEFAULT_P_KEY;
 	ppd->part_enforce |= HFI1_PART_ENFORCE_IN;
-
-	if (loopback) {
-		dd_dev_err(dd, "Faking data partition 0x8001 in idx %u\n",
-			   !default_pkey_idx);
-		ppd->pkeys[!default_pkey_idx] = 0x8001;
-	}
+	ppd->pkeys[0] = 0x8001;
 
 	INIT_WORK(&ppd->link_vc_work, handle_verify_cap);
 	INIT_WORK(&ppd->link_up_work, handle_link_up);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index dcbe5e28a4f7..90945e664f5d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4735,8 +4735,10 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	spin_lock_irqsave(&hr_dev->dip_list_lock, flags);
 
 	list_for_each_entry(hr_dip, &hr_dev->dip_list, node) {
-		if (!memcmp(grh->dgid.raw, hr_dip->dgid, 16))
+		if (!memcmp(grh->dgid.raw, hr_dip->dgid, 16)) {
+			*dip_idx = hr_dip->dip_idx;
 			goto out;
+		}
 	}
 
 	/* If no dgid is found, a new dip and a mapping between dgid and
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 23cf2f6bc7a5..d4da840dbc2e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1784,7 +1784,7 @@ struct hns_roce_eq_context {
 
 struct hns_roce_dip {
 	u8 dgid[GID_LEN_V2];
-	u8 dip_idx;
+	u32 dip_idx;
 	struct list_head node;	/* all dips are on a list */
 };
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index b8454dcb0318..39a085f8e605 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -361,7 +361,9 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 free_cmd_mbox:
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 
-	return ERR_PTR(ret);
+	if (ret)
+		return ERR_PTR(ret);
+	return NULL;
 }
 
 int hns_roce_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 230a909ba9bc..5d5dd0b5d507 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -835,7 +835,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_out;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
 		}
 
 		if (user_qp_has_rdb(hr_dev, init_attr, udata, resp)) {
@@ -848,7 +847,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_sdb;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
 		}
 	} else {
 		if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
@@ -1060,6 +1058,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	}
 
 	if (udata) {
+		resp.cap_flags = hr_qp->en_flags;
 		ret = ib_copy_to_udata(udata, &resp,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
@@ -1158,14 +1157,8 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 	if (!hr_qp)
 		return ERR_PTR(-ENOMEM);
 
-	if (init_attr->qp_type == IB_QPT_XRC_INI)
-		init_attr->recv_cq = NULL;
-
-	if (init_attr->qp_type == IB_QPT_XRC_TGT) {
+	if (init_attr->qp_type == IB_QPT_XRC_TGT)
 		hr_qp->xrcdn = to_hr_xrcd(init_attr->xrcd)->xrcdn;
-		init_attr->recv_cq = NULL;
-		init_attr->send_cq = NULL;
-	}
 
 	if (init_attr->qp_type == IB_QPT_GSI) {
 		hr_qp->port = init_attr->port_num - 1;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5851486c0d93..2471f48ea5f3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1896,7 +1896,6 @@ static int get_atomic_mode(struct mlx5_ib_dev *dev,
 static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			     struct mlx5_create_qp_params *params)
 {
-	struct mlx5_ib_create_qp *ucmd = params->ucmd;
 	struct ib_qp_init_attr *attr = params->attr;
 	u32 uidx = params->uidx;
 	struct mlx5_ib_resources *devr = &dev->devr;
@@ -1916,8 +1915,6 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!in)
 		return -ENOMEM;
 
-	if (MLX5_CAP_GEN(mdev, ece_support) && ucmd)
-		MLX5_SET(create_qp_in, in, ece, ucmd->ece_options);
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_XRC);
diff --git a/drivers/input/mouse/elan_i2c.h b/drivers/input/mouse/elan_i2c.h
index dc4a240f4489..3c84deefa327 100644
--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -55,8 +55,9 @@
 #define ETP_FW_PAGE_SIZE_512	512
 #define ETP_FW_SIGNATURE_SIZE	6
 
-#define ETP_PRODUCT_ID_DELBIN	0x00C2
+#define ETP_PRODUCT_ID_WHITEBOX	0x00B8
 #define ETP_PRODUCT_ID_VOXEL	0x00BF
+#define ETP_PRODUCT_ID_DELBIN	0x00C2
 #define ETP_PRODUCT_ID_MAGPIE	0x0120
 #define ETP_PRODUCT_ID_BOBBA	0x0121
 
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index dad22c1ea6a0..47af62c12267 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -105,6 +105,7 @@ static u32 elan_i2c_lookup_quirks(u16 ic_type, u16 product_id)
 		u32 quirks;
 	} elan_i2c_quirks[] = {
 		{ 0x0D, ETP_PRODUCT_ID_DELBIN, ETP_QUIRK_QUICK_WAKEUP },
+		{ 0x0D, ETP_PRODUCT_ID_WHITEBOX, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x10, ETP_PRODUCT_ID_VOXEL, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x14, ETP_PRODUCT_ID_MAGPIE, ETP_QUIRK_QUICK_WAKEUP },
 		{ 0x14, ETP_PRODUCT_ID_BOBBA, ETP_QUIRK_QUICK_WAKEUP },
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index c11bc8b833b8..d5552e2c160d 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -28,12 +28,12 @@
 #define VCMD_CMD_ALLOC			0x1
 #define VCMD_CMD_FREE			0x2
 #define VCMD_VRSP_IP			0x1
-#define VCMD_VRSP_SC(e)			(((e) >> 1) & 0x3)
+#define VCMD_VRSP_SC(e)			(((e) & 0xff) >> 1)
 #define VCMD_VRSP_SC_SUCCESS		0
-#define VCMD_VRSP_SC_NO_PASID_AVAIL	2
-#define VCMD_VRSP_SC_INVALID_PASID	2
-#define VCMD_VRSP_RESULT_PASID(e)	(((e) >> 8) & 0xfffff)
-#define VCMD_CMD_OPERAND(e)		((e) << 8)
+#define VCMD_VRSP_SC_NO_PASID_AVAIL	16
+#define VCMD_VRSP_SC_INVALID_PASID	16
+#define VCMD_VRSP_RESULT_PASID(e)	(((e) >> 16) & 0xfffff)
+#define VCMD_CMD_OPERAND(e)		((e) << 16)
 /*
  * Domain ID reserved for pasid entries programmed for first-level
  * only and pass-through transfer modes.
diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 5665b6ea8119..75378e35c3d6 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -168,7 +168,8 @@ static void cmdq_task_insert_into_thread(struct cmdq_task *task)
 	dma_sync_single_for_cpu(dev, prev_task->pa_base,
 				prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
 	prev_task_base[CMDQ_NUM_CMD(prev_task->pkt) - 1] =
-		(u64)CMDQ_JUMP_BY_PA << 32 | task->pa_base;
+		(u64)CMDQ_JUMP_BY_PA << 32 |
+		(task->pa_base >> task->cmdq->shift_pa);
 	dma_sync_single_for_device(dev, prev_task->pa_base,
 				   prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b0ab080f2567..85f3a1a4fbb3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2661,7 +2661,12 @@ static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
 	struct crypt_config *cc = pool_data;
 	struct page *page;
 
-	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
+	/*
+	 * Note, percpu_counter_read_positive() may over (and under) estimate
+	 * the current usage by at most (batch - 1) * num_online_cpus() pages,
+	 * but avoids potential spinlock contention of an exact result.
+	 */
+	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) >= dm_crypt_pages_per_client) &&
 	    likely(gfp_mask & __GFP_NORETRY))
 		return NULL;
 
diff --git a/drivers/media/cec/platform/stm32/stm32-cec.c b/drivers/media/cec/platform/stm32/stm32-cec.c
index ea4b1ebfca99..0ffd89712536 100644
--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -305,14 +305,16 @@ static int stm32_cec_probe(struct platform_device *pdev)
 
 	cec->clk_hdmi_cec = devm_clk_get(&pdev->dev, "hdmi-cec");
 	if (IS_ERR(cec->clk_hdmi_cec) &&
-	    PTR_ERR(cec->clk_hdmi_cec) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	    PTR_ERR(cec->clk_hdmi_cec) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_unprepare_cec_clk;
+	}
 
 	if (!IS_ERR(cec->clk_hdmi_cec)) {
 		ret = clk_prepare(cec->clk_hdmi_cec);
 		if (ret) {
 			dev_err(&pdev->dev, "Can't prepare hdmi-cec clock\n");
-			return ret;
+			goto err_unprepare_cec_clk;
 		}
 	}
 
@@ -324,19 +326,27 @@ static int stm32_cec_probe(struct platform_device *pdev)
 			CEC_NAME, caps,	CEC_MAX_LOG_ADDRS);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
-		return ret;
+		goto err_unprepare_hdmi_cec_clk;
 
 	ret = cec_register_adapter(cec->adap, &pdev->dev);
-	if (ret) {
-		cec_delete_adapter(cec->adap);
-		return ret;
-	}
+	if (ret)
+		goto err_delete_adapter;
 
 	cec_hw_init(cec);
 
 	platform_set_drvdata(pdev, cec);
 
 	return 0;
+
+err_delete_adapter:
+	cec_delete_adapter(cec->adap);
+
+err_unprepare_hdmi_cec_clk:
+	clk_unprepare(cec->clk_hdmi_cec);
+
+err_unprepare_cec_clk:
+	clk_unprepare(cec->clk_cec);
+	return ret;
 }
 
 static int stm32_cec_remove(struct platform_device *pdev)
diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 1ac0c70a5981..5e907395ca2e 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -366,7 +366,11 @@ static int tegra_cec_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_prepare_enable(cec->clk);
+	ret = clk_prepare_enable(cec->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to prepare clock for CEC\n");
+		return ret;
+	}
 
 	/* set context info. */
 	cec->dev = &pdev->dev;
@@ -446,9 +450,7 @@ static int tegra_cec_resume(struct platform_device *pdev)
 
 	dev_notice(&pdev->dev, "Resuming\n");
 
-	clk_prepare_enable(cec->clk);
-
-	return 0;
+	return clk_prepare_enable(cec->clk);
 }
 #endif
 
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 082796534b0a..bb02354a48b8 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2107,32 +2107,55 @@ static void dib8000_load_ana_fe_coefs(struct dib8000_state *state, const s16 *an
 			dib8000_write_word(state, 117 + mode, ana_fe[mode]);
 }
 
-static const u16 lut_prbs_2k[14] = {
-	0, 0x423, 0x009, 0x5C7, 0x7A6, 0x3D8, 0x527, 0x7FF, 0x79B, 0x3D6, 0x3A2, 0x53B, 0x2F4, 0x213
+static const u16 lut_prbs_2k[13] = {
+	0x423, 0x009, 0x5C7,
+	0x7A6, 0x3D8, 0x527,
+	0x7FF, 0x79B, 0x3D6,
+	0x3A2, 0x53B, 0x2F4,
+	0x213
 };
-static const u16 lut_prbs_4k[14] = {
-	0, 0x208, 0x0C3, 0x7B9, 0x423, 0x5C7, 0x3D8, 0x7FF, 0x3D6, 0x53B, 0x213, 0x029, 0x0D0, 0x48E
+
+static const u16 lut_prbs_4k[13] = {
+	0x208, 0x0C3, 0x7B9,
+	0x423, 0x5C7, 0x3D8,
+	0x7FF, 0x3D6, 0x53B,
+	0x213, 0x029, 0x0D0,
+	0x48E
 };
-static const u16 lut_prbs_8k[14] = {
-	0, 0x740, 0x069, 0x7DD, 0x208, 0x7B9, 0x5C7, 0x7FF, 0x53B, 0x029, 0x48E, 0x4C4, 0x367, 0x684
+
+static const u16 lut_prbs_8k[13] = {
+	0x740, 0x069, 0x7DD,
+	0x208, 0x7B9, 0x5C7,
+	0x7FF, 0x53B, 0x029,
+	0x48E, 0x4C4, 0x367,
+	0x684
 };
 
 static u16 dib8000_get_init_prbs(struct dib8000_state *state, u16 subchannel)
 {
 	int sub_channel_prbs_group = 0;
+	int prbs_group;
 
-	sub_channel_prbs_group = (subchannel / 3) + 1;
-	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
+	sub_channel_prbs_group = subchannel / 3;
+	if (sub_channel_prbs_group >= ARRAY_SIZE(lut_prbs_2k))
+		return 0;
 
 	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
 	case TRANSMISSION_MODE_2K:
-			return lut_prbs_2k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_2k[sub_channel_prbs_group];
+		break;
 	case TRANSMISSION_MODE_4K:
-			return lut_prbs_4k[sub_channel_prbs_group];
+		prbs_group =  lut_prbs_4k[sub_channel_prbs_group];
+		break;
 	default:
 	case TRANSMISSION_MODE_8K:
-			return lut_prbs_8k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_8k[sub_channel_prbs_group];
 	}
+
+	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n",
+		sub_channel_prbs_group, subchannel, prbs_group);
+
+	return prbs_group;
 }
 
 static void dib8000_set_13seg_channel(struct dib8000_state *state)
@@ -2409,10 +2432,8 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	/* TSB or ISDBT ? apply it now */
 	if (c->isdbt_sb_mode) {
 		dib8000_set_sb_channel(state);
-		if (c->isdbt_sb_subchannel < 14)
-			init_prbs = dib8000_get_init_prbs(state, c->isdbt_sb_subchannel);
-		else
-			init_prbs = 0;
+		init_prbs = dib8000_get_init_prbs(state,
+						  c->isdbt_sb_subchannel);
 	} else {
 		dib8000_set_13seg_channel(state);
 		init_prbs = 0xfff;
@@ -3004,6 +3025,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	unsigned long *timeout = &state->timeout;
 	unsigned long now = jiffies;
+	u16 init_prbs;
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1, agc2;
 #endif
@@ -3302,8 +3324,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		break;
 
 	case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
-		if (state->subchannel <= 41) {
-			dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
+		init_prbs = dib8000_get_init_prbs(state, state->subchannel);
+
+		if (init_prbs) {
+			dib8000_set_subchannel_prbs(state, init_prbs);
 			*tune_state = CT_DEMOD_STEP_9;
 		} else {
 			*tune_state = CT_DEMOD_STOP;
diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index a017ec4e0f50..cdeaaec31879 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -23,7 +23,7 @@
 #define IMX258_CHIP_ID			0x0258
 
 /* V_TIMING internal */
-#define IMX258_VTS_30FPS		0x0c98
+#define IMX258_VTS_30FPS		0x0c50
 #define IMX258_VTS_30FPS_2K		0x0638
 #define IMX258_VTS_30FPS_VGA		0x034c
 #define IMX258_VTS_MAX			0xffff
@@ -47,7 +47,7 @@
 /* Analog gain control */
 #define IMX258_REG_ANALOG_GAIN		0x0204
 #define IMX258_ANA_GAIN_MIN		0
-#define IMX258_ANA_GAIN_MAX		0x1fff
+#define IMX258_ANA_GAIN_MAX		480
 #define IMX258_ANA_GAIN_STEP		1
 #define IMX258_ANA_GAIN_DEFAULT		0x0
 
diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 9554c8348c02..17cc69c3227f 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -1695,14 +1695,15 @@ static int tda1997x_query_dv_timings(struct v4l2_subdev *sd,
 				     struct v4l2_dv_timings *timings)
 {
 	struct tda1997x_state *state = to_state(sd);
+	int ret;
 
 	v4l_dbg(1, debug, state->client, "%s\n", __func__);
 	memset(timings, 0, sizeof(struct v4l2_dv_timings));
 	mutex_lock(&state->lock);
-	tda1997x_detect_std(state, timings);
+	ret = tda1997x_detect_std(state, timings);
 	mutex_unlock(&state->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct v4l2_subdev_video_ops tda1997x_video_ops = {
diff --git a/drivers/media/platform/ti-vpe/cal-camerarx.c b/drivers/media/platform/ti-vpe/cal-camerarx.c
index cbe6114908de..63d13bcc83b4 100644
--- a/drivers/media/platform/ti-vpe/cal-camerarx.c
+++ b/drivers/media/platform/ti-vpe/cal-camerarx.c
@@ -842,7 +842,9 @@ struct cal_camerarx *cal_camerarx_create(struct cal_dev *cal,
 	if (ret)
 		goto error;
 
-	cal_camerarx_sd_init_cfg(sd, NULL);
+	ret = cal_camerarx_sd_init_cfg(sd, NULL);
+	if (ret)
+		goto error;
 
 	ret = v4l2_device_register_subdev(&cal->v4l2_dev, sd);
 	if (ret)
diff --git a/drivers/media/platform/ti-vpe/cal-video.c b/drivers/media/platform/ti-vpe/cal-video.c
index 7b7436a355ee..b9405f70af9f 100644
--- a/drivers/media/platform/ti-vpe/cal-video.c
+++ b/drivers/media/platform/ti-vpe/cal-video.c
@@ -694,7 +694,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irq(&ctx->dma.lock);
 	buf = list_first_entry(&ctx->dma.queue, struct cal_buffer, list);
-	ctx->dma.pending = buf;
+	ctx->dma.active = buf;
 	list_del(&buf->list);
 	spin_unlock_irq(&ctx->dma.lock);
 
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 1ba3f96ffa7d..40ab66c850f2 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -42,7 +42,7 @@ static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 252136cc885c..6acb8013de08 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u8 i;
 
 	if (chain->selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -908,22 +908,27 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 		return 0;
 	}
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
 			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
-			     &i, 1);
-	if (ret < 0)
-		return ret;
+			     buf, 1);
+	if (!ret)
+		*input = *buf - 1;
 
-	*input = i - 1;
-	return 0;
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u32 i;
 
 	ret = uvc_acquire_privileges(handle);
 	if (ret < 0)
@@ -939,10 +944,17 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 	if (input >= chain->selector->bNrInPins)
 		return -EINVAL;
 
-	i = input + 1;
-	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
-			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
-			      &i, 1);
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	*buf = input + 1;
+	ret = uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
+			     chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
+			     buf, 1);
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_queryctrl(struct file *file, void *fh,
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 230d65a64217..af48705c704f 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -196,7 +196,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	if (!v4l2_valid_dv_timings(t, cap, fnc, fnc_handle))
 		return false;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
@@ -218,7 +218,7 @@ bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic)
 {
 	unsigned int i;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		const struct v4l2_bt_timings *bt =
 			&v4l2_dv_timings_presets[i].bt;
 
diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 046ce4ecc195..4a3250564442 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -119,4 +119,6 @@ static struct pci_driver pvpanic_pci_driver = {
 	},
 };
 
+MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
+
 module_pci_driver(pvpanic_pci_driver);
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 880c33ab9f47..94ebf7f3fd58 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -2243,7 +2243,8 @@ int vmci_qp_broker_map(struct vmci_handle handle,
 
 	result = VMCI_SUCCESS;
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    !QPBROKERSTATE_HAS_MEM(entry)) {
 		struct vmci_qp_page_store page_store;
 
 		page_store.pages = guest_mem;
@@ -2350,7 +2351,8 @@ int vmci_qp_broker_unmap(struct vmci_handle handle,
 		goto out;
 	}
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    QPBROKERSTATE_HAS_MEM(entry)) {
 		qp_acquire_queue_mutex(entry->produce_q);
 		result = qp_save_headers(entry);
 		if (result < VMCI_SUCCESS)
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 2518bc085659..d47829b9fc0f 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -542,6 +542,7 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 		return mmc_sanitize(card, idata->ic.cmd_timeout_ms);
 
 	mmc_wait_for_req(card->host, &mrq);
+	memcpy(&idata->ic.response, cmd.resp, sizeof(cmd.resp));
 
 	if (cmd.error) {
 		dev_err(mmc_dev(card->host), "%s: cmd error %d\n",
@@ -591,8 +592,6 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 	if (idata->ic.postsleep_min_us)
 		usleep_range(idata->ic.postsleep_min_us, idata->ic.postsleep_max_us);
 
-	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
-
 	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 4ca937415734..58cfaffa3c2d 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -542,9 +542,22 @@ static int sd_write_long_data(struct realtek_pci_sdmmc *host,
 	return 0;
 }
 
+static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
+}
+
+static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+}
+
 static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 {
 	struct mmc_data *data = mrq->data;
+	int err;
 
 	if (host->sg_count < 0) {
 		data->error = host->sg_count;
@@ -553,22 +566,19 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 		return data->error;
 	}
 
-	if (data->flags & MMC_DATA_READ)
-		return sd_read_long_data(host, mrq);
+	if (data->flags & MMC_DATA_READ) {
+		if (host->initial_mode)
+			sd_disable_initial_mode(host);
 
-	return sd_write_long_data(host, mrq);
-}
+		err = sd_read_long_data(host, mrq);
 
-static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
-}
+		if (host->initial_mode)
+			sd_enable_initial_mode(host);
 
-static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+		return err;
+	}
+
+	return sd_write_long_data(host, mrq);
 }
 
 static void sd_normal_rw(struct realtek_pci_sdmmc *host,
diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 839965f7c717..9a630ba37484 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -159,6 +159,12 @@ struct sdhci_arasan_data {
 /* Controller immediately reports SDHCI_CLOCK_INT_STABLE after enabling the
  * internal clock even when the clock isn't stable */
 #define SDHCI_ARASAN_QUIRK_CLOCK_UNSTABLE BIT(1)
+/*
+ * Some of the Arasan variations might not have timing requirements
+ * met at 25MHz for Default Speed mode, those controllers work at
+ * 19MHz instead
+ */
+#define SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN BIT(2)
 };
 
 struct sdhci_arasan_of_data {
@@ -267,7 +273,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 			 * through low speeds without power cycling.
 			 */
 			sdhci_set_clock(host, host->max_clk);
-			phy_power_on(sdhci_arasan->phy);
+			if (phy_power_on(sdhci_arasan->phy)) {
+				pr_err("%s: Cannot power on phy.\n",
+				       mmc_hostname(host->mmc));
+				return;
+			}
+
 			sdhci_arasan->is_phy_on = true;
 
 			/*
@@ -290,6 +301,16 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 		sdhci_arasan->is_phy_on = false;
 	}
 
+	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN) {
+		/*
+		 * Some of the Arasan variations might not have timing
+		 * requirements met at 25MHz for Default Speed mode,
+		 * those controllers work at 19MHz instead.
+		 */
+		if (clock == DEFAULT_SPEED_MAX_DTR)
+			clock = (DEFAULT_SPEED_MAX_DTR * 19) / 25;
+	}
+
 	/* Set the Input and Output Clock Phase Delays */
 	if (clk_data->set_clk_delays)
 		clk_data->set_clk_delays(host);
@@ -307,7 +328,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 		msleep(20);
 
 	if (ctrl_phy) {
-		phy_power_on(sdhci_arasan->phy);
+		if (phy_power_on(sdhci_arasan->phy)) {
+			pr_err("%s: Cannot power on phy.\n",
+			       mmc_hostname(host->mmc));
+			return;
+		}
+
 		sdhci_arasan->is_phy_on = true;
 	}
 }
@@ -463,7 +489,9 @@ static int sdhci_arasan_suspend(struct device *dev)
 		ret = phy_power_off(sdhci_arasan->phy);
 		if (ret) {
 			dev_err(dev, "Cannot power off phy.\n");
-			sdhci_resume_host(host);
+			if (sdhci_resume_host(host))
+				dev_err(dev, "Cannot resume host.\n");
+
 			return ret;
 		}
 		sdhci_arasan->is_phy_on = false;
@@ -1598,6 +1626,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "xlnx,zynqmp-8.9a")) {
 		host->mmc_host_ops.execute_tuning =
 			arasan_zynqmp_execute_tuning;
+
+		sdhci_arasan->quirks |= SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN;
 	}
 
 	arasan_dt_parse_clk_phases(dev, &sdhci_arasan->clk_data);
diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 8b49fd56cf96..29e8a546dcd6 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -631,19 +631,26 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_host->clk_rate = clk_get_rate(ebu_host->clk);
 
 	ebu_host->dma_tx = dma_request_chan(dev, "tx");
-	if (IS_ERR(ebu_host->dma_tx))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->dma_tx),
-				     "failed to request DMA tx chan!.\n");
+	if (IS_ERR(ebu_host->dma_tx)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->dma_tx),
+				    "failed to request DMA tx chan!.\n");
+		goto err_disable_unprepare_clk;
+	}
 
 	ebu_host->dma_rx = dma_request_chan(dev, "rx");
-	if (IS_ERR(ebu_host->dma_rx))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->dma_rx),
-				     "failed to request DMA rx chan!.\n");
+	if (IS_ERR(ebu_host->dma_rx)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->dma_rx),
+				    "failed to request DMA rx chan!.\n");
+		ebu_host->dma_rx = NULL;
+		goto err_cleanup_dma;
+	}
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "addr_sel%d", cs);
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
-	if (!res)
-		return -EINVAL;
+	if (!res) {
+		ret = -EINVAL;
+		goto err_cleanup_dma;
+	}
 	ebu_host->cs[cs].addr_sel = res->start;
 	writel(ebu_host->cs[cs].addr_sel | EBU_ADDR_MASK(5) | EBU_ADDR_SEL_REGEN,
 	       ebu_host->ebu + EBU_ADDR_SEL(cs));
@@ -653,7 +660,8 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	mtd = nand_to_mtd(&ebu_host->chip);
 	if (!mtd->name) {
 		dev_err(ebu_host->dev, "NAND label property is mandatory\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_cleanup_dma;
 	}
 
 	mtd->dev.parent = dev;
@@ -681,6 +689,7 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	nand_cleanup(&ebu_host->chip);
 err_cleanup_dma:
 	ebu_dma_cleanup(ebu_host);
+err_disable_unprepare_clk:
 	clk_disable_unprepare(ebu_host->clk);
 
 	return ret;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9a184c99fbe4..3476ef223736 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2245,7 +2245,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* recompute stats just before removing the slave */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
-	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
@@ -2254,6 +2253,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
 		bond_3ad_unbind_slave(slave);
 
+	bond_upper_dev_unlink(bond, slave);
+
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, slave);
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e78026ef6d8c..64d6dfa83122 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -843,7 +843,8 @@ static int gswip_setup(struct dsa_switch *ds)
 
 	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
 			  GSWIP_MAC_CTRL_2p(cpu_port));
-	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8, GSWIP_MAC_FLEN);
+	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8 + ETH_FCS_LEN,
+		       GSWIP_MAC_FLEN);
 	gswip_switch_mask(priv, 0, GSWIP_BM_QUEUE_GCTRL_GL_MOD,
 			  GSWIP_BM_QUEUE_GCTRL);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 58964d22cb17..e3a3499ba7a2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3231,12 +3231,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       &ethsw->fq[i].napi, dpaa2_switch_poll,
 			       NAPI_POLL_WEIGHT);
 
-	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
-		goto err_free_netdev;
-	}
-
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
 	if (err)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 38b601031db4..95343f6d15e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -10,7 +10,14 @@
 
 static u16 hclge_errno_to_resp(int errno)
 {
-	return abs(errno);
+	int resp = abs(errno);
+
+	/* The status for pf to vf msg cmd is u16, constrainted by HW.
+	 * We need to keep the same type with it.
+	 * The intput errno is the stander error code, it's safely to
+	 * use a u16 to store the abs(errno).
+	 */
+	return (u16)resp;
 }
 
 /* hclge_gen_resp_to_vf: used to generate a synchronous response to VF when PF
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 90793b36126e..68c80f04113c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -186,12 +186,6 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
-enum iavf_critical_section_t {
-	__IAVF_IN_CRITICAL_TASK,	/* cannot be interrupted */
-	__IAVF_IN_CLIENT_TASK,
-	__IAVF_IN_REMOVE_TASK,	/* device being removed */
-};
-
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
@@ -236,6 +230,9 @@ struct iavf_adapter {
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
 	struct list_head mac_filter_list;
+	struct mutex crit_lock;
+	struct mutex client_lock;
+	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index af43fbd8cb75..edbeb27213f8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1352,8 +1352,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	if (!fltr)
 		return -ENOMEM;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0) {
 			kfree(fltr);
 			return -EINVAL;
@@ -1378,7 +1377,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	if (err && fltr)
 		kfree(fltr);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
 
@@ -1563,8 +1562,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 		return -EINVAL;
 	}
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0) {
 			kfree(rss_new);
 			return -EINVAL;
@@ -1600,7 +1598,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 	if (!err)
 		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	if (!rss_new_add)
 		kfree(rss_new);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 606a01ce4073..23762a7ef740 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -131,6 +131,27 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 	return 0;
 }
 
+/**
+ * iavf_lock_timeout - try to lock mutex but give up after timeout
+ * @lock: mutex that should be locked
+ * @msecs: timeout in msecs
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
+{
+	unsigned int wait, delay = 10;
+
+	for (wait = 0; wait < msecs; wait += delay) {
+		if (mutex_trylock(lock))
+			return 0;
+
+		msleep(delay);
+	}
+
+	return -1;
+}
+
 /**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
@@ -1916,7 +1937,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->crit_lock))
 		goto restart_watchdog;
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
@@ -1934,8 +1955,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			adapter->state = __IAVF_STARTUP;
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
-			clear_bit(__IAVF_IN_CRITICAL_TASK,
-				  &adapter->crit_section);
+			mutex_unlock(&adapter->crit_lock);
 			/* Don't reschedule the watchdog, since we've restarted
 			 * the init task. When init_task contacts the PF and
 			 * gets everything set up again, it'll restart the
@@ -1945,14 +1965,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		clear_bit(__IAVF_IN_CRITICAL_TASK,
-			  &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		goto watchdog_done;
 	case __IAVF_RESETTING:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
 		return;
 	case __IAVF_DOWN:
@@ -1975,7 +1994,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		break;
 	case __IAVF_REMOVE:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		return;
 	default:
 		goto restart_watchdog;
@@ -1984,7 +2003,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
@@ -1998,7 +2016,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->state == __IAVF_RUNNING ||
 	    adapter->state == __IAVF_COMM_FAILED)
 		iavf_detect_recover_hung(&adapter->vsi);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
@@ -2062,7 +2080,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	adapter->state = __IAVF_DOWN;
 	wake_up(&adapter->down_waitqueue);
@@ -2095,11 +2113,14 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+	if (mutex_is_locked(&adapter->remove_lock))
 		return;
 
-	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
-				&adapter->crit_section))
+	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
+		schedule_work(&adapter->reset_task);
+		return;
+	}
+	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
 		adapter->flags &= ~(IAVF_FLAG_CLIENT_NEEDS_OPEN |
@@ -2151,7 +2172,7 @@ static void iavf_reset_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
 			reg_val);
 		iavf_disable_vf(adapter);
-		clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->client_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2278,13 +2299,13 @@ static void iavf_reset_task(struct work_struct *work)
 		adapter->state = __IAVF_DOWN;
 		wake_up(&adapter->down_waitqueue);
 	}
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
 
 	return;
 reset_err:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
@@ -2312,6 +2333,8 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (!event.msg_buf)
 		goto out;
 
+	if (iavf_lock_timeout(&adapter->crit_lock, 200))
+		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -2325,6 +2348,7 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
+	mutex_unlock(&adapter->crit_lock);
 
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
@@ -2391,7 +2415,7 @@ static void iavf_client_task(struct work_struct *work)
 	 * later.
 	 */
 
-	if (test_and_set_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->client_lock))
 		return;
 
 	if (adapter->flags & IAVF_FLAG_SERVICE_CLIENT_REQUESTED) {
@@ -2414,7 +2438,7 @@ static void iavf_client_task(struct work_struct *work)
 		adapter->flags &= ~IAVF_FLAG_CLIENT_NEEDS_OPEN;
 	}
 out:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
 }
 
 /**
@@ -3017,8 +3041,7 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	if (!filter)
 		return -ENOMEM;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0)
 			goto err;
 		udelay(1);
@@ -3049,7 +3072,7 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	if (err)
 		kfree(filter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
 
@@ -3196,8 +3219,7 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	if (adapter->state != __IAVF_DOWN) {
@@ -3232,7 +3254,7 @@ static int iavf_open(struct net_device *netdev)
 
 	iavf_irq_enable(adapter, true);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return 0;
 
@@ -3244,7 +3266,7 @@ static int iavf_open(struct net_device *netdev)
 err_setup_tx:
 	iavf_free_all_tx_resources(adapter);
 err_unlock:
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return err;
 }
@@ -3268,8 +3290,7 @@ static int iavf_close(struct net_device *netdev)
 	if (adapter->state <= __IAVF_DOWN_PENDING)
 		return 0;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -3280,7 +3301,7 @@ static int iavf_close(struct net_device *netdev)
 	adapter->state = __IAVF_DOWN_PENDING;
 	iavf_free_traffic_irqs(adapter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	/* We explicitly don't free resources here because the hardware is
 	 * still active and can DMA into memory. Resources are cleared in
@@ -3629,6 +3650,10 @@ static void iavf_init_task(struct work_struct *work)
 						    init_task.work);
 	struct iavf_hw *hw = &adapter->hw;
 
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000)) {
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
+		return;
+	}
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		if (iavf_startup(adapter) < 0)
@@ -3641,14 +3666,14 @@ static void iavf_init_task(struct work_struct *work)
 	case __IAVF_INIT_GET_RESOURCES:
 		if (iavf_init_get_resources(adapter) < 0)
 			goto init_failed;
-		return;
+		goto out;
 	default:
 		goto init_failed;
 	}
 
 	queue_delayed_work(iavf_wq, &adapter->init_task,
 			   msecs_to_jiffies(30));
-	return;
+	goto out;
 init_failed:
 	if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 		dev_err(&adapter->pdev->dev,
@@ -3657,9 +3682,11 @@ static void iavf_init_task(struct work_struct *work)
 		iavf_shutdown_adminq(hw);
 		adapter->state = __IAVF_STARTUP;
 		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
-		return;
+		goto out;
 	}
 	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
+out:
+	mutex_unlock(&adapter->crit_lock);
 }
 
 /**
@@ -3676,9 +3703,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (netif_running(netdev))
 		iavf_close(netdev);
 
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 	/* Prevent the watchdog from running. */
 	adapter->state = __IAVF_REMOVE;
 	adapter->aq_required = 0;
+	mutex_unlock(&adapter->crit_lock);
 
 #ifdef CONFIG_PM
 	pci_save_state(pdev);
@@ -3772,6 +3802,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* set up the locks for the AQ, do this only once in probe
 	 * and destroy them only once in remove
 	 */
+	mutex_init(&adapter->crit_lock);
+	mutex_init(&adapter->client_lock);
+	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -3823,8 +3856,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 
 	netif_device_detach(netdev);
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	if (netif_running(netdev)) {
@@ -3835,7 +3867,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return 0;
 }
@@ -3897,7 +3929,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 	/* Indicate we are in remove and not to run reset_task */
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
+	mutex_lock(&adapter->remove_lock);
 	cancel_delayed_work_sync(&adapter->init_task);
 	cancel_work_sync(&adapter->reset_task);
 	cancel_delayed_work_sync(&adapter->client_task);
@@ -3912,10 +3944,6 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
-	/* Shut down all the garbage mashers on the detention level */
-	adapter->state = __IAVF_REMOVE;
-	adapter->aq_required = 0;
-	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3923,6 +3951,13 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
+
+	/* Shut down all the garbage mashers on the detention level */
+	adapter->state = __IAVF_REMOVE;
+	adapter->aq_required = 0;
+	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
 	iavf_misc_irq_disable(adapter);
@@ -3942,6 +3977,11 @@ static void iavf_remove(struct pci_dev *pdev)
 	/* destroy the locks only once, here */
 	mutex_destroy(&hw->aq.arq_mutex);
 	mutex_destroy(&hw->aq.asq_mutex);
+	mutex_destroy(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
+	mutex_destroy(&adapter->crit_lock);
+	mutex_unlock(&adapter->remove_lock);
+	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9b85fdf01297..3e301c5c5270 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4402,6 +4402,7 @@ static irqreturn_t igc_msix_ring(int irq, void *data)
  */
 static int igc_request_msix(struct igc_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	int i = 0, err = 0, vector = 0, free_vector = 0;
 	struct net_device *netdev = adapter->netdev;
 
@@ -4410,7 +4411,13 @@ static int igc_request_msix(struct igc_adapter *adapter)
 	if (err)
 		goto err_out;
 
-	for (i = 0; i < adapter->num_q_vectors; i++) {
+	if (num_q_vectors > MAX_Q_VECTORS) {
+		num_q_vectors = MAX_Q_VECTORS;
+		dev_warn(&adapter->pdev->dev,
+			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
+			 adapter->num_q_vectors, MAX_Q_VECTORS);
+	}
+	for (i = 0; i < num_q_vectors; i++) {
 		struct igc_q_vector *q_vector = adapter->q_vector[i];
 
 		vector++;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index e0d1af9e7770..6c64fdbef0df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1201,7 +1201,22 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	/* Enable backpressure for RQ aura */
 	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
+		/* If NIX1 LF is attached then specify NIX1_RX.
+		 *
+		 * Below NPA_AURA_S[BP_ENA] is set according to the
+		 * NPA_BPINTF_E enumeration given as:
+		 * 0x0 + a*0x1 where 'a' is 0 for NIX0_RX and 1 for NIX1_RX so
+		 * NIX0_RX is 0x0 + 0*0x1 = 0
+		 * NIX1_RX is 0x0 + 1*0x1 = 1
+		 * But in HRM it is given that
+		 * "NPA_AURA_S[BP_ENA](w1[33:32]) - Enable aura backpressure to
+		 * NIX-RX based on [BP] level. One bit per NIX-RX; index
+		 * enumerated by NPA_BPINTF_E."
+		 */
+		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
+			aq->aura.bp_ena = 1;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
+
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 9d79c5ec31e9..db5dfff585c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -877,7 +877,7 @@ static void cb_timeout_handler(struct work_struct *work)
 	ent->ret = -ETIMEDOUT;
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
 		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 
 out:
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
@@ -994,7 +994,7 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, status, status);
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 		return;
 	}
 
@@ -1008,7 +1008,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
 	}
 }
 
@@ -1068,7 +1068,7 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
 
 	ent->ret = -ETIMEDOUT;
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 }
 
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 43356fad53de..ffdfb5a94b14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -846,9 +846,9 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 			new_htbl = dr_rule_rehash(rule, nic_rule, cur_htbl,
 						  ste_location, send_ste_list);
 			if (!new_htbl) {
-				mlx5dr_htbl_put(cur_htbl);
 				mlx5dr_err(dmn, "Failed creating rehash table, htbl-log_size: %d\n",
 					   cur_htbl->chunk_size);
+				mlx5dr_htbl_put(cur_htbl);
 			} else {
 				cur_htbl = new_htbl;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 9df0e73d1c35..69b49deb66b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -620,6 +620,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..0a0a26376bea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1697,7 +1697,7 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		case NFP_NET_META_RESYNC_INFO:
 			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
 						      pkt_len))
-				return NULL;
+				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
 		default:
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 28dd0ed85a82..f7dc8458cde8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -289,10 +289,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 		val &= ~NSS_COMMON_GMAC_CTL_PHY_IFACE_SEL;
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_GMAC_CTL(gmac->id), val);
 
@@ -309,10 +306,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 			NSS_COMMON_CLK_SRC_CTRL_OFFSET(gmac->id);
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_SRC_CTRL, val);
 
@@ -329,8 +323,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 				NSS_COMMON_CLK_GATE_GMII_TX_EN(gmac->id);
 		break;
 	default:
-		/* We don't get here; the switch above will have errored out */
-		unreachable();
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
@@ -361,6 +354,11 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_unsupported_phy:
+	dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
+		phy_modes(gmac->phy_mode));
+	err = -EINVAL;
+
 err_remove_config_dt:
 	stmmac_remove_config_dt(pdev, plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a5285a8a9eae..4d92fcfe703c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5358,7 +5358,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rxtx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
-	int rx_done, tx_done;
+	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
 	priv->xstats.napi_poll++;
@@ -5368,14 +5368,16 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 
 	rx_done = stmmac_rx_zc(priv, budget, chan);
 
+	rxtx_done = max(tx_done, rx_done);
+
 	/* If either TX or RX work is not complete, return budget
 	 * and keep pooling
 	 */
-	if (tx_done >= budget || rx_done >= budget)
+	if (rxtx_done >= budget)
 		return budget;
 
 	/* all work done, exit the polling mode */
-	if (napi_complete_done(napi, rx_done)) {
+	if (napi_complete_done(napi, rxtx_done)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
@@ -5386,7 +5388,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
 
-	return min(rx_done, budget - 1);
+	return min(rxtx_done, budget - 1);
 }
 
 /**
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index ec5db481c9cd..15e13d6dc5db 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1052,6 +1052,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 525cdf28d9ea..1e43748dcb40 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -159,35 +159,45 @@ static void ipa_cmd_validate_build(void)
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
 #undef TABLE_COUNT_MAX
 #undef TABLE_SIZE
-}
 
-#ifdef IPA_VALIDATE
+	/* Hashed and non-hashed fields are assumed to be the same size */
+	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK) !=
+		     field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
+	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK) !=
+		     field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK));
+}
 
 /* Validate a memory region holding a table */
-bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
-			 bool route, bool ipv6, bool hashed)
+bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem, bool route)
 {
+	u32 offset_max = field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	u32 size_max = field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
+	const char *table = route ? "route" : "filter";
 	struct device *dev = &ipa->pdev->dev;
-	u32 offset_max;
 
-	offset_max = hashed ? field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK)
-			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	/* Size must fit in the immediate command field that holds it */
+	if (mem->size > size_max) {
+		dev_err(dev, "%s table region size too large\n", table);
+		dev_err(dev, "    (0x%04x > 0x%04x)\n",
+			mem->size, size_max);
+
+		return false;
+	}
+
+	/* Offset must fit in the immediate command field that holds it */
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region offset too large\n",
-			ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			route ? "route" : "filter");
+		dev_err(dev, "%s table region offset too large\n", table);
 		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
 			ipa->mem_offset, mem->offset, offset_max);
 
 		return false;
 	}
 
+	/* Entire memory range must fit within IPA-local memory */
 	if (mem->offset > ipa->mem_size ||
 	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region out of range\n",
-			ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			route ? "route" : "filter");
+		dev_err(dev, "%s table region out of range\n", table);
 		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
 			mem->offset, mem->size, ipa->mem_size);
 
@@ -197,6 +207,8 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 	return true;
 }
 
+#ifdef IPA_VALIDATE
+
 /* Validate the memory region that holds headers */
 static bool ipa_cmd_header_valid(struct ipa *ipa)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index b99262281f41..ea723419c826 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -57,20 +57,18 @@ struct ipa_cmd_info {
 	enum dma_data_direction direction;
 };
 
-#ifdef IPA_VALIDATE
-
 /**
  * ipa_cmd_table_valid() - Validate a memory region holding a table
  * @ipa:	- IPA pointer
  * @mem:	- IPA memory region descriptor
  * @route:	- Whether the region holds a route or filter table
- * @ipv6:	- Whether the table is for IPv6 or IPv4
- * @hashed:	- Whether the table is hashed or non-hashed
  *
  * Return:	true if region is valid, false otherwise
  */
 bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
-			    bool route, bool ipv6, bool hashed);
+			    bool route);
+
+#ifdef IPA_VALIDATE
 
 /**
  * ipa_cmd_data_valid() - Validate command-realted configuration is valid
@@ -82,13 +80,6 @@ bool ipa_cmd_data_valid(struct ipa *ipa);
 
 #else /* !IPA_VALIDATE */
 
-static inline bool ipa_cmd_table_valid(struct ipa *ipa,
-				       const struct ipa_mem *mem, bool route,
-				       bool ipv6, bool hashed)
-{
-	return true;
-}
-
 static inline bool ipa_cmd_data_valid(struct ipa *ipa)
 {
 	return true;
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 05806ceae8b5..157f8d47058b 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -346,18 +346,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
-		.peak_bandwidth		= 465000,	/* 465 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps */
-	},
-	/* Average rate is unused for the next two interconnects */
-	{
-		.name			= "imem",
-		.peak_bandwidth		= 68570,	/* 68.57 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps (unused?) */
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
+	/* Average rate is unused for the next interconnect */
 	{
 		.name			= "config",
-		.peak_bandwidth		= 30000,	/* 30 MBps */
+		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
 };
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index e41be790f45e..75b50a50e348 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -392,18 +392,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 /* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
-		.name			= "ipa_to_llcc",
+		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
 		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
-	{
-		.name			= "llcc_to_ebi1",
-		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
-		.average_bandwidth	= 150000,	/* 150 MBps */
-	},
 	/* Average rate is unused for the next interconnect */
 	{
-		.name			= "appss_to_ipa",
+		.name			= "config",
 		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 3168d72f4245..618a84cf669a 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -174,7 +174,7 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
 	}
 
-	if (!ipa_cmd_table_valid(ipa, mem, route, ipv6, hashed))
+	if (!ipa_cmd_table_valid(ipa, mem, route))
 		return false;
 
 	/* mem->size >= size is sufficient, but we'll demand more */
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index f7a2ec150e54..211b5476a6f5 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -326,11 +326,9 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
-	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
-		    DP83822_WOL_SECURE_ON;
-
-	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
-				  MII_DP83822_WOL_CFG, value);
+	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
+				  DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
+				  DP83822_WOL_SECURE_ON);
 }
 
 static int dp83822_read_status(struct phy_device *phydev)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b4885a700296..b0a4ca3559fd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3351,7 +3351,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
-		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
+		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485) ||
+		    (length > cptr)) {
 			ath_dbg(common, EEPROM, "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
 			continue;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2ca3b86714a9..172081ffe477 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1621,7 +1621,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
-		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
@@ -2728,14 +2727,17 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
 static void ath9k_hw_gpio_cfg_soc(struct ath_hw *ah, u32 gpio, bool out,
 				  const char *label)
 {
+	int err;
+
 	if (ah->caps.gpio_requested & BIT(gpio))
 		return;
 
-	/* may be requested by BSP, free anyway */
-	gpio_free(gpio);
-
-	if (gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label))
+	err = gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label);
+	if (err) {
+		ath_err(ath9k_hw_common(ah), "request GPIO%d failed:%d\n",
+			gpio, err);
 		return;
+	}
 
 	ah->caps.gpio_requested |= BIT(gpio);
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index dabed4e3ca45..e8c772a67176 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -405,13 +405,14 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 		wcn36xx_dbg(WCN36XX_DBG_MAC, "wcn36xx_config channel switch=%d\n",
 			    ch);
 
-		if (wcn->sw_scan_opchannel == ch) {
+		if (wcn->sw_scan_opchannel == ch && wcn->sw_scan_channel) {
 			/* If channel is the initial operating channel, we may
 			 * want to receive/transmit regular data packets, then
 			 * simply stop the scan session and exit PS mode.
 			 */
 			wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
 						wcn->sw_scan_vif);
+			wcn->sw_scan_channel = 0;
 		} else if (wcn->sw_scan) {
 			/* A scan is ongoing, do not change the operating
 			 * channel, but start a scan session on the channel.
@@ -419,6 +420,7 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
 					      wcn->sw_scan_vif);
 			wcn36xx_smd_start_scan(wcn, ch);
+			wcn->sw_scan_channel = ch;
 		} else {
 			wcn36xx_change_opchannel(wcn, ch);
 		}
@@ -699,6 +701,7 @@ static void wcn36xx_sw_scan_start(struct ieee80211_hw *hw,
 
 	wcn->sw_scan = true;
 	wcn->sw_scan_vif = vif;
+	wcn->sw_scan_channel = 0;
 	if (vif_priv->sta_assoc)
 		wcn->sw_scan_opchannel = WCN36XX_HW_CHANNEL(wcn);
 	else
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 1b831157ede1..cab196bb38cd 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -287,6 +287,10 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		status.rate_idx = 0;
 	}
 
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		status.boottime_ns = ktime_get_boottime_ns();
+
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 71fa9992b118..d0fcce86903a 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -232,6 +232,7 @@ struct wcn36xx {
 	struct cfg80211_scan_request *scan_req;
 	bool			sw_scan;
 	u8			sw_scan_opchannel;
+	u8			sw_scan_channel;
 	struct ieee80211_vif	*sw_scan_vif;
 	struct mutex		scan_lock;
 	bool			scan_aborted;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index b2605aefc290..8b200379f7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -874,7 +874,7 @@ struct iwl_scan_probe_params_v3 {
 	u8 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_3 */
 
 /**
@@ -894,7 +894,7 @@ struct iwl_scan_probe_params_v4 {
 	__le16 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_4 */
 
 #define SCAN_MAX_NUM_CHANS_V3 67
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index cc4e18ca9566..a27849419d29 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2314,7 +2314,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		return;
 
 	if (dump_data->monitor_only)
-		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+		dump_mask &= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 
 	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index fd5e08961651..7f0c82189808 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1005,8 +1005,10 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->beacon_inject_active)
+	if (mvm->beacon_inject_active) {
+		dev_kfree_skb(beacon);
 		return -EBUSY;
+	}
 #endif
 
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 141d9fc299b0..6981608ef165 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2987,16 +2987,20 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 						    void *_data)
 {
 	struct iwl_mvm_he_obss_narrow_bw_ru_data *data = _data;
+	const struct cfg80211_bss_ies *ies;
 	const struct element *elem;
 
-	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, bss->ies->data,
-				  bss->ies->len);
+	rcu_read_lock();
+	ies = rcu_dereference(bss->ies);
+	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
+				  ies->len);
 
 	if (!elem || elem->datalen < 10 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
 	}
+	rcu_read_unlock();
 }
 
 static void iwl_mvm_check_he_obss_narrow_bw_ru(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ebed82c590e5..31611542e1aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -754,10 +754,26 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	mvm->fw_restart = iwlwifi_mod_params.fw_restart ? -1 : 0;
 
-	mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
-	mvm->snif_queue = IWL_MVM_DQA_INJECT_MONITOR_QUEUE;
-	mvm->probe_queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
-	mvm->p2p_dev_queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		/*
+		 * If we have the new TX/queue allocation API initialize them
+		 * all to invalid numbers. We'll rewrite the ones that we need
+		 * later, but that doesn't happen for all of them all of the
+		 * time (e.g. P2P Device is optional), and if a dynamic queue
+		 * ends up getting number 2 (IWL_MVM_DQA_P2P_DEVICE_QUEUE) then
+		 * iwl_mvm_is_static_queue() erroneously returns true, and we
+		 * might have things getting stuck.
+		 */
+		mvm->aux_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->snif_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->probe_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->p2p_dev_queue = IWL_MVM_INVALID_QUEUE;
+	} else {
+		mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
+		mvm->snif_queue = IWL_MVM_DQA_INJECT_MONITOR_QUEUE;
+		mvm->probe_queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		mvm->p2p_dev_queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	}
 
 	mvm->sf_state = SF_UNINIT;
 	if (iwl_mvm_has_unified_ucode(mvm))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5a0696c44f6d..ee3aff8bf7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1648,7 +1648,7 @@ iwl_mvm_umac_scan_cfg_channels_v6(struct iwl_mvm *mvm,
 		struct iwl_scan_channel_cfg_umac *cfg = &cp->channel_config[i];
 		u32 n_aps_flag =
 			iwl_mvm_scan_ch_n_aps_flag(vif_type,
-						   cfg->v2.channel_num);
+						   channels[i]->hw_value);
 
 		cfg->flags = cpu_to_le32(flags | n_aps_flag);
 		cfg->v2.channel_num = channels[i]->hw_value;
@@ -2368,14 +2368,17 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
-					  &bitmap_ssid);
 	if (!params->scan_6ghz) {
+		iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
+					  &bitmap_ssid);
 		iwl_mvm_scan_umac_fill_ch_p_v6(mvm, params, vif,
-					       &scan_p->channel_params, bitmap_ssid);
+				       &scan_p->channel_params, bitmap_ssid);
 
 		return 0;
+	} else {
+		pb->preq = params->preq;
 	}
+
 	cp->flags = iwl_mvm_scan_umac_chan_flags_v2(mvm, params, vif);
 	cp->n_aps_override[0] = IWL_SCAN_ADWELL_N_APS_GO_FRIENDLY;
 	cp->n_aps_override[1] = IWL_SCAN_ADWELL_N_APS_SOCIAL_CHS;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f618368eda83..c310c366c38e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -316,8 +316,9 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 }
 
 static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			       int queue, u8 tid, u8 flags)
+			       u16 *queueptr, u8 tid, u8 flags)
 {
+	int queue = *queueptr;
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
@@ -326,6 +327,7 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		iwl_trans_txq_free(mvm->trans, queue);
+		*queueptr = IWL_MVM_INVALID_QUEUE;
 
 		return 0;
 	}
@@ -487,6 +489,7 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	u8 sta_id, tid;
 	unsigned long disable_agg_tids = 0;
 	bool same_sta;
+	u16 queue_tmp = queue;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -509,7 +512,7 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 		iwl_mvm_invalidate_sta_queue(mvm, queue,
 					     disable_agg_tids, false);
 
-	ret = iwl_mvm_disable_txq(mvm, old_sta, queue, tid, 0);
+	ret = iwl_mvm_disable_txq(mvm, old_sta, &queue_tmp, tid, 0);
 	if (ret) {
 		IWL_ERR(mvm,
 			"Failed to free inactive queue %d (ret=%d)\n",
@@ -1184,6 +1187,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
 	int queue = -1;
+	u16 queue_tmp;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
 	bool shared_queue = false, inc_ssn;
@@ -1332,7 +1336,8 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return 0;
 
 out_err:
-	iwl_mvm_disable_txq(mvm, sta, queue, tid, 0);
+	queue_tmp = queue;
+	iwl_mvm_disable_txq(mvm, sta, &queue_tmp, tid, 0);
 
 	return ret;
 }
@@ -1779,7 +1784,7 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 		if (mvm_sta->tid_data[i].txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
-		iwl_mvm_disable_txq(mvm, sta, mvm_sta->tid_data[i].txq_id, i,
+		iwl_mvm_disable_txq(mvm, sta, &mvm_sta->tid_data[i].txq_id, i,
 				    0);
 		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
@@ -1987,7 +1992,7 @@ static int iwl_mvm_add_int_sta_with_queue(struct iwl_mvm *mvm, int macidx,
 	ret = iwl_mvm_add_int_sta_common(mvm, sta, addr, macidx, maccolor);
 	if (ret) {
 		if (!iwl_mvm_has_new_tx_api(mvm))
-			iwl_mvm_disable_txq(mvm, NULL, *queue,
+			iwl_mvm_disable_txq(mvm, NULL, queue,
 					    IWL_MAX_TID_COUNT, 0);
 		return ret;
 	}
@@ -2060,7 +2065,7 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN_ON_ONCE(mvm->snif_sta.sta_id == IWL_MVM_INVALID_STA))
 		return -EINVAL;
 
-	iwl_mvm_disable_txq(mvm, NULL, mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -2077,7 +2082,7 @@ int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 	if (WARN_ON_ONCE(mvm->aux_sta.sta_id == IWL_MVM_INVALID_STA))
 		return -EINVAL;
 
-	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -2173,7 +2178,7 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int queue;
+	u16 *queueptr, queue;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -2182,10 +2187,10 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
-		queue = mvm->probe_queue;
+		queueptr = &mvm->probe_queue;
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		queue = mvm->p2p_dev_queue;
+		queueptr = &mvm->p2p_dev_queue;
 		break;
 	default:
 		WARN(1, "Can't free bcast queue on vif type %d\n",
@@ -2193,7 +2198,8 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 		return;
 	}
 
-	iwl_mvm_disable_txq(mvm, NULL, queue, IWL_MAX_TID_COUNT, 0);
+	queue = *queueptr;
+	iwl_mvm_disable_txq(mvm, NULL, queueptr, IWL_MAX_TID_COUNT, 0);
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
@@ -2428,7 +2434,7 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	iwl_mvm_flush_sta(mvm, &mvmvif->mcast_sta, true);
 
-	iwl_mvm_disable_txq(mvm, NULL, mvmvif->cab_queue, 0, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvmvif->cab_queue, 0, 0);
 
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index fb8491412be4..586c4104edf2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -487,6 +487,9 @@ void iwl_pcie_free_rbs_pool(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
+	if (!trans_pcie->rx_pool)
+		return;
+
 	for (i = 0; i < RX_POOL_SIZE(trans_pcie->num_rx_bufs); i++) {
 		if (!trans_pcie->rx_pool[i].page)
 			continue;
@@ -1093,7 +1096,7 @@ static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 	INIT_LIST_HEAD(&rba->rbd_empty);
 	spin_unlock_bh(&rba->lock);
 
-	/* free all first - we might be reconfigured for a different size */
+	/* free all first - we overwrite everything here */
 	iwl_pcie_free_rbs_pool(trans);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 239bc177a3e5..a7a495dbf64d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1866,6 +1866,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	/* free all first - we might be reconfigured for a different size */
+	iwl_pcie_free_rbs_pool(trans);
+
 	trans->txqs.cmd.q_id = trans_cfg->cmd_queue;
 	trans->txqs.cmd.fifo = trans_cfg->cmd_fifo;
 	trans->txqs.cmd.wdg_timeout = trans_cfg->cmd_q_wdg_timeout;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 01735776345a..7ddce3c3f0c4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1378,6 +1378,8 @@ struct rtl8xxxu_priv {
 	u8 no_pape:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
 	u8 rssi_level;
+	DECLARE_BITMAP(tx_aggr_started, IEEE80211_NUM_TIDS);
+	DECLARE_BITMAP(tid_tx_operational, IEEE80211_NUM_TIDS);
 	/*
 	 * Only one virtual interface permitted because only STA mode
 	 * is supported and no iface_combinations are provided.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9ff09cf7eb62..ce8e2438f86b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4805,6 +4805,8 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u32 rate;
 	u16 rate_flags = tx_info->control.rates[0].flags;
 	u16 seq_number;
@@ -4828,7 +4830,7 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 
 	tx_desc->txdw3 = cpu_to_le32((u32)seq_number << TXDESC32_SEQ_SHIFT);
 
-	if (ampdu_enable)
+	if (ampdu_enable && test_bit(tid, priv->tid_tx_operational))
 		tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_ENABLE);
 	else
 		tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_BREAK);
@@ -4876,6 +4878,8 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
 	struct rtl8xxxu_txdesc40 *tx_desc40;
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u32 rate;
 	u16 rate_flags = tx_info->control.rates[0].flags;
 	u16 seq_number;
@@ -4902,7 +4906,7 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 
 	tx_desc40->txdw9 = cpu_to_le32((u32)seq_number << TXDESC40_SEQ_SHIFT);
 
-	if (ampdu_enable)
+	if (ampdu_enable && test_bit(tid, priv->tid_tx_operational))
 		tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_ENABLE);
 	else
 		tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_BREAK);
@@ -5015,12 +5019,19 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (ieee80211_is_data_qos(hdr->frame_control) && sta) {
 		if (sta->ht_cap.ht_supported) {
 			u32 ampdu, val32;
+			u8 *qc = ieee80211_get_qos_ctl(hdr);
+			u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 
 			ampdu = (u32)sta->ht_cap.ampdu_density;
 			val32 = ampdu << TXDESC_AMPDU_DENSITY_SHIFT;
 			tx_desc->txdw2 |= cpu_to_le32(val32);
 
 			ampdu_enable = true;
+
+			if (!test_bit(tid, priv->tx_aggr_started) &&
+			    !(skb->protocol == cpu_to_be16(ETH_P_PAE)))
+				if (!ieee80211_start_tx_ba_session(sta, tid, 0))
+					set_bit(tid, priv->tx_aggr_started);
 		}
 	}
 
@@ -6089,6 +6100,7 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct device *dev = &priv->udev->dev;
 	u8 ampdu_factor, ampdu_density;
 	struct ieee80211_sta *sta = params->sta;
+	u16 tid = params->tid;
 	enum ieee80211_ampdu_mlme_action action = params->action;
 
 	switch (action) {
@@ -6101,17 +6113,20 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		dev_dbg(dev,
 			"Changed HT: ampdu_factor %02x, ampdu_density %02x\n",
 			ampdu_factor, ampdu_density);
-		break;
+		return IEEE80211_AMPDU_TX_START_IMMEDIATE;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH\n", __func__);
-		rtl8xxxu_set_ampdu_factor(priv, 0);
-		rtl8xxxu_set_ampdu_min_space(priv, 0);
-		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH_CONT\n",
-			 __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP\n", __func__);
 		rtl8xxxu_set_ampdu_factor(priv, 0);
 		rtl8xxxu_set_ampdu_min_space(priv, 0);
+		clear_bit(tid, priv->tx_aggr_started);
+		clear_bit(tid, priv->tid_tx_operational);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_OPERATIONAL\n", __func__);
+		set_bit(tid, priv->tid_tx_operational);
 		break;
 	case IEEE80211_AMPDU_RX_START:
 		dev_dbg(dev, "%s: IEEE80211_AMPDU_RX_START\n", __func__);
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index c0e4b111c8b4..73d6807a8cdf 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -15,9 +15,9 @@ rtw88_core-y += main.o \
 	   ps.o \
 	   sec.o \
 	   bf.o \
-	   wow.o \
 	   regd.o
 
+rtw88_core-$(CONFIG_PM) += wow.o
 
 obj-$(CONFIG_RTW88_8822B)	+= rtw88_8822b.o
 rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index ea2cd4db1d3c..ce57932e38a4 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -715,7 +715,7 @@ static u16 rtw_get_rsvd_page_probe_req_size(struct rtw_dev *rtwdev,
 			continue;
 		if ((!ssid && !rsvd_pkt->ssid) ||
 		    rtw_ssid_equal(rsvd_pkt->ssid, ssid))
-			size = rsvd_pkt->skb->len;
+			size = rsvd_pkt->probe_req_size;
 	}
 
 	return size;
@@ -943,6 +943,8 @@ static struct sk_buff *rtw_get_rsvd_page_skb(struct ieee80211_hw *hw,
 							 ssid->ssid_len, 0);
 		else
 			skb_new = ieee80211_probereq_get(hw, vif->addr, NULL, 0, 0);
+		if (skb_new)
+			rsvd_pkt->probe_req_size = (u16)skb_new->len;
 		break;
 	case RSVD_NLO_INFO:
 		skb_new = rtw_nlo_info_get(hw);
@@ -1539,6 +1541,7 @@ int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
 static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 				u8 location)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 	u16 total_size = H2C_PKT_HDR_SIZE + H2C_PKT_UPDATE_PKT_LEN;
 
@@ -1549,6 +1552,7 @@ static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 	UPDATE_PKT_SET_LOCATION(h2c_pkt, location);
 
 	/* include txdesc size */
+	size += chip->tx_pkt_desc_sz;
 	UPDATE_PKT_SET_SIZE(h2c_pkt, size);
 
 	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
@@ -1558,7 +1562,7 @@ void rtw_fw_update_pkt_probe_req(struct rtw_dev *rtwdev,
 				 struct cfg80211_ssid *ssid)
 {
 	u8 loc;
-	u32 size;
+	u16 size;
 
 	loc = rtw_get_rsvd_page_probe_req_location(rtwdev, ssid);
 	if (!loc) {
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 7c5b1d75e26f..35bc9e10dcba 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -126,6 +126,7 @@ struct rtw_rsvd_page {
 	u8 page;
 	bool add_txdesc;
 	struct cfg80211_ssid *ssid;
+	u16 probe_req_size;
 };
 
 enum rtw_keep_alive_pkt_type {
diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index fc9544f4e5e4..bdccfa70dddc 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -283,15 +283,26 @@ static void rtw_wow_rx_dma_start(struct rtw_dev *rtwdev)
 
 static int rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool wow_enable)
 {
-	/* wait 100ms for wow firmware to finish work */
-	msleep(100);
+	int ret;
+	u8 check;
+	u32 check_dis;
 
 	if (wow_enable) {
-		if (rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
+		ret = read_poll_timeout(rtw_read8, check, !check, 1000,
+					100000, true, rtwdev,
+					REG_WOWLAN_WAKE_REASON);
+		if (ret)
 			goto wow_fail;
 	} else {
-		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) ||
-		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM, BIT_RW_RELEASE))
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, true, rtwdev,
+					REG_FE1IMR, BIT_FS_RXDONE);
+		if (ret)
+			goto wow_fail;
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, false, rtwdev,
+					REG_RXPKT_NUM, BIT_RW_RELEASE);
+		if (ret)
 			goto wow_fail;
 	}
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ed10a8b66068..3c7c4f1d55cd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -449,11 +449,11 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pfn_flags |= PFN_MAP;
 		bb_range = pmem->pgmap.range;
 	} else {
+		addr = devm_memremap(dev, pmem->phys_addr,
+				pmem->size, ARCH_MEMREMAP_PMEM);
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
 					&pmem->pgmap))
 			return -ENOMEM;
-		addr = devm_memremap(dev, pmem->phys_addr,
-				pmem->size, ARCH_MEMREMAP_PMEM);
 		bb_range.start =  res->start;
 		bb_range.end = res->end;
 	}
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 148e756857a8..a13eec2fca5a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1009,7 +1009,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 		return BLK_STS_IOERR;
 	}
 
-	cmd->common.command_id = req->tag;
+	nvme_req(req)->genctr++;
+	cmd->common.command_id = nvme_cid(req);
 	trace_nvme_setup_cmd(req, cmd);
 	return ret;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 0015860ec12b..632076b9c1c9 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -158,6 +158,7 @@ enum nvme_quirks {
 struct nvme_request {
 	struct nvme_command	*cmd;
 	union nvme_result	result;
+	u8			genctr;
 	u8			retries;
 	u8			flags;
 	u16			status;
@@ -497,6 +498,49 @@ struct nvme_ctrl_ops {
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
+/*
+ * nvme command_id is constructed as such:
+ * | xxxx | xxxxxxxxxxxx |
+ *   gen    request tag
+ */
+#define nvme_genctr_mask(gen)			(gen & 0xf)
+#define nvme_cid_install_genctr(gen)		(nvme_genctr_mask(gen) << 12)
+#define nvme_genctr_from_cid(cid)		((cid & 0xf000) >> 12)
+#define nvme_tag_from_cid(cid)			(cid & 0xfff)
+
+static inline u16 nvme_cid(struct request *rq)
+{
+	return nvme_cid_install_genctr(nvme_req(rq)->genctr) | rq->tag;
+}
+
+static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
+		u16 command_id)
+{
+	u8 genctr = nvme_genctr_from_cid(command_id);
+	u16 tag = nvme_tag_from_cid(command_id);
+	struct request *rq;
+
+	rq = blk_mq_tag_to_rq(tags, tag);
+	if (unlikely(!rq)) {
+		pr_err("could not locate request for tag %#x\n",
+			tag);
+		return NULL;
+	}
+	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
+		dev_err(nvme_req(rq)->ctrl->device,
+			"request %#x genctr mismatch (got %#x expected %#x)\n",
+			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
+		return NULL;
+	}
+	return rq;
+}
+
+static inline struct request *nvme_cid_to_rq(struct blk_mq_tags *tags,
+                u16 command_id)
+{
+	return blk_mq_tag_to_rq(tags, nvme_tag_from_cid(command_id));
+}
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 void nvme_fault_inject_init(struct nvme_fault_inject *fault_inj,
 			    const char *dev_name);
@@ -594,7 +638,8 @@ static inline void nvme_put_ctrl(struct nvme_ctrl *ctrl)
 
 static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
 {
-	return !qid && command_id >= NVME_AQ_BLK_MQ_DEPTH;
+	return !qid &&
+		nvme_tag_from_cid(command_id) >= NVME_AQ_BLK_MQ_DEPTH;
 }
 
 void nvme_complete_rq(struct request *req);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d963f25fc7ae..01feb1c2278d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1017,7 +1017,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 		return;
 	}
 
-	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), command_id);
+	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
 		dev_warn(nvmeq->dev->ctrl.device,
 			"invalid id %d completed on queue %d\n",
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f80682f7df54..b95945c58b3b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1731,10 +1731,10 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	struct request *rq;
 	struct nvme_rdma_request *req;
 
-	rq = blk_mq_tag_to_rq(nvme_rdma_tagset(queue), cqe->command_id);
+	rq = nvme_find_rq(nvme_rdma_tagset(queue), cqe->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"tag 0x%x on QP %#x not found\n",
+			"got bad command_id %#x on QP %#x\n",
 			cqe->command_id, queue->qp->qp_num);
 		nvme_rdma_error_recovery(queue->ctrl);
 		return;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index ab1ea5b0888e..258d71807367 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -487,11 +487,11 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 {
 	struct request *rq;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), cqe->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag 0x%x not found\n",
-			nvme_tcp_queue_id(queue), cqe->command_id);
+			"got bad cqe.command_id %#x on queue %d\n",
+			cqe->command_id, nvme_tcp_queue_id(queue));
 		nvme_tcp_error_recovery(&queue->ctrl->ctrl);
 		return -EINVAL;
 	}
@@ -508,11 +508,11 @@ static int nvme_tcp_handle_c2h_data(struct nvme_tcp_queue *queue,
 {
 	struct request *rq;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
+			"got bad c2hdata.command_id %#x on queue %d\n",
+			pdu->command_id, nvme_tcp_queue_id(queue));
 		return -ENOENT;
 	}
 
@@ -606,7 +606,7 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	data->hdr.plen =
 		cpu_to_le32(data->hdr.hlen + hdgst + req->pdu_len + ddgst);
 	data->ttag = pdu->ttag;
-	data->command_id = rq->tag;
+	data->command_id = nvme_cid(rq);
 	data->data_offset = cpu_to_le32(req->data_sent);
 	data->data_length = cpu_to_le32(req->pdu_len);
 	return 0;
@@ -619,11 +619,11 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	struct request *rq;
 	int ret;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
+			"got bad r2t.command_id %#x on queue %d\n",
+			pdu->command_id, nvme_tcp_queue_id(queue));
 		return -ENOENT;
 	}
 	req = blk_mq_rq_to_pdu(rq);
@@ -702,17 +702,9 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			      unsigned int *offset, size_t *len)
 {
 	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
-	struct nvme_tcp_request *req;
-	struct request *rq;
-
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
-	if (!rq) {
-		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
-		return -ENOENT;
-	}
-	req = blk_mq_rq_to_pdu(rq);
+	struct request *rq =
+		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 	while (true) {
 		int recv_len, ret;
@@ -804,8 +796,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	}
 
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
-						pdu->command_id);
+		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
+					pdu->command_id);
 
 		nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
 		queue->nr_cqe++;
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index a5c4a1865026..f6ee47de3038 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -107,10 +107,10 @@ static void nvme_loop_queue_response(struct nvmet_req *req)
 	} else {
 		struct request *rq;
 
-		rq = blk_mq_tag_to_rq(nvme_loop_tagset(queue), cqe->command_id);
+		rq = nvme_find_rq(nvme_loop_tagset(queue), cqe->command_id);
 		if (!rq) {
 			dev_err(queue->ctrl->ctrl.device,
-				"tag 0x%x on queue %d not found\n",
+				"got bad command_id %#x on queue %d\n",
 				cqe->command_id, nvme_loop_queue_idx(queue));
 			return;
 		}
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index f9c9c9859919..30691b50731f 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -818,8 +818,11 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
-		if (rval)
-			goto err_put_device;
+		if (rval) {
+			ida_free(&nvmem_ida, nvmem->id);
+			kfree(nvmem);
+			return ERR_PTR(rval);
+		}
 	}
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
index d6d3f24685a8..f372eda2b255 100644
--- a/drivers/nvmem/qfprom.c
+++ b/drivers/nvmem/qfprom.c
@@ -138,6 +138,9 @@ static void qfprom_disable_fuse_blowing(const struct qfprom_priv *priv,
 {
 	int ret;
 
+	writel(old->timer_val, priv->qfpconf + QFPROM_BLOW_TIMER_OFFSET);
+	writel(old->accel_val, priv->qfpconf + QFPROM_ACCEL_OFFSET);
+
 	/*
 	 * This may be a shared rail and may be able to run at a lower rate
 	 * when we're not blowing fuses.  At the moment, the regulator framework
@@ -158,9 +161,6 @@ static void qfprom_disable_fuse_blowing(const struct qfprom_priv *priv,
 			 "Failed to set clock rate for disable (ignoring)\n");
 
 	clk_disable_unprepare(priv->secclk);
-
-	writel(old->timer_val, priv->qfpconf + QFPROM_BLOW_TIMER_OFFSET);
-	writel(old->accel_val, priv->qfpconf + QFPROM_ACCEL_OFFSET);
 }
 
 /**
diff --git a/drivers/of/kobj.c b/drivers/of/kobj.c
index a32e60b024b8..6675b5e56960 100644
--- a/drivers/of/kobj.c
+++ b/drivers/of/kobj.c
@@ -119,7 +119,7 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!of_kset)
+	if (!IS_ENABLED(CONFIG_SYSFS) || !of_kset)
 		return 0;
 
 	np->kobj.kset = of_kset;
diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 01feeba78426..de550ee48e77 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -95,15 +95,7 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
 static struct device_node *of_parse_required_opp(struct device_node *np,
 						 int index)
 {
-	struct device_node *required_np;
-
-	required_np = of_parse_phandle(np, "required-opps", index);
-	if (unlikely(!required_np)) {
-		pr_err("%s: Unable to parse required-opps: %pOF, index: %d\n",
-		       __func__, np, index);
-	}
-
-	return required_np;
+	return of_parse_phandle(np, "required-opps", index);
 }
 
 /* The caller must call dev_pm_opp_put_opp_table() after the table is used */
@@ -1349,7 +1341,7 @@ int of_get_required_opp_performance_state(struct device_node *np, int index)
 
 	required_np = of_parse_required_opp(np, index);
 	if (!required_np)
-		return -EINVAL;
+		return -ENODEV;
 
 	opp_table = _find_table_of_opp_np(required_np);
 	if (IS_ERR(opp_table)) {
diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 2c11bd3fe1fd..17061f1df0f4 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -518,7 +518,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index c95ebe808f92..fdbf05158697 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -58,6 +58,7 @@
 #define   PIO_COMPLETION_STATUS_CRS		2
 #define   PIO_COMPLETION_STATUS_CA		4
 #define   PIO_NON_POSTED_REQ			BIT(10)
+#define   PIO_ERR_STATUS			BIT(11)
 #define PIO_ADDR_LS				(PIO_BASE_ADDR + 0x8)
 #define PIO_ADDR_MS				(PIO_BASE_ADDR + 0xc)
 #define PIO_WR_DATA				(PIO_BASE_ADDR + 0x10)
@@ -118,6 +119,46 @@
 #define PCIE_MSI_MASK_REG			(CONTROL_BASE_ADDR + 0x5C)
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
 
+/* PCIe window configuration */
+#define OB_WIN_BASE_ADDR			0x4c00
+#define OB_WIN_BLOCK_SIZE			0x20
+#define OB_WIN_COUNT				8
+#define OB_WIN_REG_ADDR(win, offset)		(OB_WIN_BASE_ADDR + \
+						 OB_WIN_BLOCK_SIZE * (win) + \
+						 (offset))
+#define OB_WIN_MATCH_LS(win)			OB_WIN_REG_ADDR(win, 0x00)
+#define     OB_WIN_ENABLE			BIT(0)
+#define OB_WIN_MATCH_MS(win)			OB_WIN_REG_ADDR(win, 0x04)
+#define OB_WIN_REMAP_LS(win)			OB_WIN_REG_ADDR(win, 0x08)
+#define OB_WIN_REMAP_MS(win)			OB_WIN_REG_ADDR(win, 0x0c)
+#define OB_WIN_MASK_LS(win)			OB_WIN_REG_ADDR(win, 0x10)
+#define OB_WIN_MASK_MS(win)			OB_WIN_REG_ADDR(win, 0x14)
+#define OB_WIN_ACTIONS(win)			OB_WIN_REG_ADDR(win, 0x18)
+#define OB_WIN_DEFAULT_ACTIONS			(OB_WIN_ACTIONS(OB_WIN_COUNT-1) + 0x4)
+#define     OB_WIN_FUNC_NUM_MASK		GENMASK(31, 24)
+#define     OB_WIN_FUNC_NUM_SHIFT		24
+#define     OB_WIN_FUNC_NUM_ENABLE		BIT(23)
+#define     OB_WIN_BUS_NUM_BITS_MASK		GENMASK(22, 20)
+#define     OB_WIN_BUS_NUM_BITS_SHIFT		20
+#define     OB_WIN_MSG_CODE_ENABLE		BIT(22)
+#define     OB_WIN_MSG_CODE_MASK		GENMASK(21, 14)
+#define     OB_WIN_MSG_CODE_SHIFT		14
+#define     OB_WIN_MSG_PAYLOAD_LEN		BIT(12)
+#define     OB_WIN_ATTR_ENABLE			BIT(11)
+#define     OB_WIN_ATTR_TC_MASK			GENMASK(10, 8)
+#define     OB_WIN_ATTR_TC_SHIFT		8
+#define     OB_WIN_ATTR_RELAXED			BIT(7)
+#define     OB_WIN_ATTR_NOSNOOP			BIT(6)
+#define     OB_WIN_ATTR_POISON			BIT(5)
+#define     OB_WIN_ATTR_IDO			BIT(4)
+#define     OB_WIN_TYPE_MASK			GENMASK(3, 0)
+#define     OB_WIN_TYPE_SHIFT			0
+#define     OB_WIN_TYPE_MEM			0x0
+#define     OB_WIN_TYPE_IO			0x4
+#define     OB_WIN_TYPE_CONFIG_TYPE0		0x8
+#define     OB_WIN_TYPE_CONFIG_TYPE1		0x9
+#define     OB_WIN_TYPE_MSG			0xc
+
 /* LMI registers base address and register offsets */
 #define LMI_BASE_ADDR				0x6000
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
@@ -166,7 +207,7 @@
 #define PCIE_CONFIG_WR_TYPE0			0xa
 #define PCIE_CONFIG_WR_TYPE1			0xb
 
-#define PIO_RETRY_CNT			500
+#define PIO_RETRY_CNT			750000 /* 1.5 s */
 #define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10
@@ -180,8 +221,16 @@
 struct advk_pcie {
 	struct platform_device *pdev;
 	void __iomem *base;
+	struct {
+		phys_addr_t match;
+		phys_addr_t remap;
+		phys_addr_t mask;
+		u32 actions;
+	} wins[OB_WIN_COUNT];
+	u8 wins_count;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
+	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
 	struct irq_chip msi_bottom_irq_chip;
@@ -366,9 +415,39 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
 	dev_err(dev, "link never came up\n");
 }
 
+/*
+ * Set PCIe address window register which could be used for memory
+ * mapping.
+ */
+static void advk_pcie_set_ob_win(struct advk_pcie *pcie, u8 win_num,
+				 phys_addr_t match, phys_addr_t remap,
+				 phys_addr_t mask, u32 actions)
+{
+	advk_writel(pcie, OB_WIN_ENABLE |
+			  lower_32_bits(match), OB_WIN_MATCH_LS(win_num));
+	advk_writel(pcie, upper_32_bits(match), OB_WIN_MATCH_MS(win_num));
+	advk_writel(pcie, lower_32_bits(remap), OB_WIN_REMAP_LS(win_num));
+	advk_writel(pcie, upper_32_bits(remap), OB_WIN_REMAP_MS(win_num));
+	advk_writel(pcie, lower_32_bits(mask), OB_WIN_MASK_LS(win_num));
+	advk_writel(pcie, upper_32_bits(mask), OB_WIN_MASK_MS(win_num));
+	advk_writel(pcie, actions, OB_WIN_ACTIONS(win_num));
+}
+
+static void advk_pcie_disable_ob_win(struct advk_pcie *pcie, u8 win_num)
+{
+	advk_writel(pcie, 0, OB_WIN_MATCH_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MATCH_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_REMAP_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_REMAP_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MASK_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MASK_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_ACTIONS(win_num));
+}
+
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
+	int i;
 
 	/* Enable TX */
 	reg = advk_readl(pcie, PCIE_CORE_REF_CLK_REG);
@@ -447,15 +526,51 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg = PCIE_IRQ_ALL_MASK & (~PCIE_IRQ_ENABLE_INTS_MASK);
 	advk_writel(pcie, reg, HOST_CTRL_INT_MASK_REG);
 
+	/*
+	 * Enable AXI address window location generation:
+	 * When it is enabled, the default outbound window
+	 * configurations (Default User Field: 0xD0074CFC)
+	 * are used to transparent address translation for
+	 * the outbound transactions. Thus, PCIe address
+	 * windows are not required for transparent memory
+	 * access when default outbound window configuration
+	 * is set for memory access.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL2_REG);
 	reg |= PCIE_CORE_CTRL2_OB_WIN_ENABLE;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL2_REG);
 
-	/* Bypass the address window mapping for PIO */
+	/*
+	 * Set memory access in Default User Field so it
+	 * is not required to configure PCIe address for
+	 * transparent memory access.
+	 */
+	advk_writel(pcie, OB_WIN_TYPE_MEM, OB_WIN_DEFAULT_ACTIONS);
+
+	/*
+	 * Bypass the address window mapping for PIO:
+	 * Since PIO access already contains all required
+	 * info over AXI interface by PIO registers, the
+	 * address window is not required.
+	 */
 	reg = advk_readl(pcie, PIO_CTRL);
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
+	/*
+	 * Configure PCIe address windows for non-memory or
+	 * non-transparent access as by default PCIe uses
+	 * transparent memory access.
+	 */
+	for (i = 0; i < pcie->wins_count; i++)
+		advk_pcie_set_ob_win(pcie, i,
+				     pcie->wins[i].match, pcie->wins[i].remap,
+				     pcie->wins[i].mask, pcie->wins[i].actions);
+
+	/* Disable remaining PCIe outbound windows */
+	for (i = pcie->wins_count; i < OB_WIN_COUNT; i++)
+		advk_pcie_disable_ob_win(pcie, i);
+
 	advk_pcie_train_link(pcie);
 
 	/*
@@ -472,7 +587,7 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
 }
 
-static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
+static int advk_pcie_check_pio_status(struct advk_pcie *pcie, u32 *val)
 {
 	struct device *dev = &pcie->pdev->dev;
 	u32 reg;
@@ -483,14 +598,49 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 	status = (reg & PIO_COMPLETION_STATUS_MASK) >>
 		PIO_COMPLETION_STATUS_SHIFT;
 
-	if (!status)
-		return;
-
+	/*
+	 * According to HW spec, the PIO status check sequence as below:
+	 * 1) even if COMPLETION_STATUS(bit9:7) indicates successful,
+	 *    it still needs to check Error Status(bit11), only when this bit
+	 *    indicates no error happen, the operation is successful.
+	 * 2) value Unsupported Request(1) of COMPLETION_STATUS(bit9:7) only
+	 *    means a PIO write error, and for PIO read it is successful with
+	 *    a read value of 0xFFFFFFFF.
+	 * 3) value Completion Retry Status(CRS) of COMPLETION_STATUS(bit9:7)
+	 *    only means a PIO write error, and for PIO read it is successful
+	 *    with a read value of 0xFFFF0001.
+	 * 4) value Completer Abort (CA) of COMPLETION_STATUS(bit9:7) means
+	 *    error for both PIO read and PIO write operation.
+	 * 5) other errors are indicated as 'unknown'.
+	 */
 	switch (status) {
+	case PIO_COMPLETION_STATUS_OK:
+		if (reg & PIO_ERR_STATUS) {
+			strcomp_status = "COMP_ERR";
+			break;
+		}
+		/* Get the read result */
+		if (val)
+			*val = advk_readl(pcie, PIO_RD_DATA);
+		/* No error */
+		strcomp_status = NULL;
+		break;
 	case PIO_COMPLETION_STATUS_UR:
 		strcomp_status = "UR";
 		break;
 	case PIO_COMPLETION_STATUS_CRS:
+		/* PCIe r4.0, sec 2.3.2, says:
+		 * If CRS Software Visibility is not enabled, the Root Complex
+		 * must re-issue the Configuration Request as a new Request.
+		 * A Root Complex implementation may choose to limit the number
+		 * of Configuration Request/CRS Completion Status loops before
+		 * determining that something is wrong with the target of the
+		 * Request and taking appropriate action, e.g., complete the
+		 * Request to the host as a failed transaction.
+		 *
+		 * To simplify implementation do not re-issue the Configuration
+		 * Request and complete the Request as a failed transaction.
+		 */
 		strcomp_status = "CRS";
 		break;
 	case PIO_COMPLETION_STATUS_CA:
@@ -501,6 +651,9 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 		break;
 	}
 
+	if (!strcomp_status)
+		return 0;
+
 	if (reg & PIO_NON_POSTED_REQ)
 		str_posted = "Non-posted";
 	else
@@ -508,6 +661,8 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 
 	dev_err(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
+
+	return -EFAULT;
 }
 
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
@@ -745,10 +900,13 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 		return PCIBIOS_SET_FAILED;
 	}
 
-	advk_pcie_check_pio_status(pcie);
+	/* Check PIO status and get the read result */
+	ret = advk_pcie_check_pio_status(pcie, val);
+	if (ret < 0) {
+		*val = 0xffffffff;
+		return PCIBIOS_SET_FAILED;
+	}
 
-	/* Get the read result */
-	*val = advk_readl(pcie, PIO_RD_DATA);
 	if (size == 1)
 		*val = (*val >> (8 * (where & 3))) & 0xff;
 	else if (size == 2)
@@ -812,7 +970,9 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	advk_pcie_check_pio_status(pcie);
+	ret = advk_pcie_check_pio_status(pcie, NULL);
+	if (ret < 0)
+		return PCIBIOS_SET_FAILED;
 
 	return PCIBIOS_SUCCESSFUL;
 }
@@ -886,22 +1046,28 @@ static void advk_pcie_irq_mask(struct irq_data *d)
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask |= PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static void advk_pcie_irq_unmask(struct irq_data *d)
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask &= ~PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static int advk_pcie_irq_map(struct irq_domain *h,
@@ -985,6 +1151,8 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	struct irq_chip *irq_chip;
 	int ret = 0;
 
+	raw_spin_lock_init(&pcie->irq_lock);
+
 	pcie_intc_node =  of_get_next_child(node, NULL);
 	if (!pcie_intc_node) {
 		dev_err(dev, "No PCIe Intc node found\n");
@@ -1162,6 +1330,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct advk_pcie *pcie;
 	struct pci_host_bridge *bridge;
+	struct resource_entry *entry;
 	int ret, irq;
 
 	bridge = devm_pci_alloc_host_bridge(dev, sizeof(struct advk_pcie));
@@ -1172,6 +1341,80 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	pcie->pdev = pdev;
 	platform_set_drvdata(pdev, pcie);
 
+	resource_list_for_each_entry(entry, &bridge->windows) {
+		resource_size_t start = entry->res->start;
+		resource_size_t size = resource_size(entry->res);
+		unsigned long type = resource_type(entry->res);
+		u64 win_size;
+
+		/*
+		 * Aardvark hardware allows to configure also PCIe window
+		 * for config type 0 and type 1 mapping, but driver uses
+		 * only PIO for issuing configuration transfers which does
+		 * not use PCIe window configuration.
+		 */
+		if (type != IORESOURCE_MEM && type != IORESOURCE_MEM_64 &&
+		    type != IORESOURCE_IO)
+			continue;
+
+		/*
+		 * Skip transparent memory resources. Default outbound access
+		 * configuration is set to transparent memory access so it
+		 * does not need window configuration.
+		 */
+		if ((type == IORESOURCE_MEM || type == IORESOURCE_MEM_64) &&
+		    entry->offset == 0)
+			continue;
+
+		/*
+		 * The n-th PCIe window is configured by tuple (match, remap, mask)
+		 * and an access to address A uses this window if A matches the
+		 * match with given mask.
+		 * So every PCIe window size must be a power of two and every start
+		 * address must be aligned to window size. Minimal size is 64 KiB
+		 * because lower 16 bits of mask must be zero. Remapped address
+		 * may have set only bits from the mask.
+		 */
+		while (pcie->wins_count < OB_WIN_COUNT && size > 0) {
+			/* Calculate the largest aligned window size */
+			win_size = (1ULL << (fls64(size)-1)) |
+				   (start ? (1ULL << __ffs64(start)) : 0);
+			win_size = 1ULL << __ffs64(win_size);
+			if (win_size < 0x10000)
+				break;
+
+			dev_dbg(dev,
+				"Configuring PCIe window %d: [0x%llx-0x%llx] as %lu\n",
+				pcie->wins_count, (unsigned long long)start,
+				(unsigned long long)start + win_size, type);
+
+			if (type == IORESOURCE_IO) {
+				pcie->wins[pcie->wins_count].actions = OB_WIN_TYPE_IO;
+				pcie->wins[pcie->wins_count].match = pci_pio_to_address(start);
+			} else {
+				pcie->wins[pcie->wins_count].actions = OB_WIN_TYPE_MEM;
+				pcie->wins[pcie->wins_count].match = start;
+			}
+			pcie->wins[pcie->wins_count].remap = start - entry->offset;
+			pcie->wins[pcie->wins_count].mask = ~(win_size - 1);
+
+			if (pcie->wins[pcie->wins_count].remap & (win_size - 1))
+				break;
+
+			start += win_size;
+			size -= win_size;
+			pcie->wins_count++;
+		}
+
+		if (size > 0) {
+			dev_err(&pcie->pdev->dev,
+				"Invalid PCIe region [0x%llx-0x%llx]\n",
+				(unsigned long long)entry->res->start,
+				(unsigned long long)entry->res->end + 1);
+			return -EINVAL;
+		}
+	}
+
 	pcie->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pcie->base))
 		return PTR_ERR(pcie->base);
@@ -1252,6 +1495,7 @@ static int advk_pcie_remove(struct platform_device *pdev)
 {
 	struct advk_pcie *pcie = platform_get_drvdata(pdev);
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
+	int i;
 
 	pci_lock_rescan_remove();
 	pci_stop_root_bus(bridge->bus);
@@ -1261,6 +1505,10 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 
+	/* Disable outbound address windows mapping */
+	for (i = 0; i < OB_WIN_COUNT; i++)
+		advk_pcie_disable_ob_win(pcie, i);
+
 	return 0;
 }
 
diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index 8689311c5ef6..1c3d5b87ef20 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -6,6 +6,7 @@
  * (C) Copyright 2014 - 2015, Xilinx, Inc.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -169,6 +170,7 @@ struct nwl_pcie {
 	u8 last_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -823,6 +825,16 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pcie->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(pcie->clk))
+		return PTR_ERR(pcie->clk);
+
+	err = clk_prepare_enable(pcie->clk);
+	if (err) {
+		dev_err(dev, "can't enable PCIe ref clock\n");
+		return err;
+	}
+
 	err = nwl_pcie_bridge_init(pcie);
 	if (err) {
 		dev_err(dev, "HW Initialization failed\n");
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5516647e53a8..9f320fba2d9b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -776,6 +776,9 @@ static void msix_mask_all(void __iomem *base, int tsize)
 	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	int i;
 
+	if (pci_msi_ignore_mask)
+		return;
+
 	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
 		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a9d0530b7846..8b3cb62c63cc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1906,11 +1906,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	 * so that things like MSI message writing will behave as expected
 	 * (e.g. if the device really is in D0 at enable time).
 	 */
-	if (dev->pm_cap) {
-		u16 pmcsr;
-		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
-		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	}
+	pci_update_current_state(dev, dev->current_state);
 
 	if (atomic_inc_return(&dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index e1fed6649c41..3ee63968deaa 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -257,8 +257,13 @@ static int get_port_device_capability(struct pci_dev *dev)
 		services |= PCIE_PORT_SERVICE_DPC;
 
 	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||
-	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT)
-		services |= PCIE_PORT_SERVICE_BWNOTIF;
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
+		u32 linkcap;
+
+		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &linkcap);
+		if (linkcap & PCI_EXP_LNKCAP_LBNC)
+			services |= PCIE_PORT_SERVICE_BWNOTIF;
+	}
 
 	return services;
 }
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7b1c81b899cd..1905ee0297a4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3241,6 +3241,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index 8b003c890b87..c9f03418e71e 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -22,8 +22,10 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	long err;
 	int cfg_ret;
 
+	err = -EPERM;
+	dev = NULL;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		goto error;
 
 	err = -ENODEV;
 	dev = pci_get_domain_bus_and_slot(0, bus, dfn);
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 5a68e242f6b3..5cb018f98800 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -167,10 +167,14 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
 	PIN_GRP_GPIO("jtag", 20, 5, BIT(0), "jtag"),
 	PIN_GRP_GPIO("sdio0", 8, 3, BIT(1), "sdio"),
 	PIN_GRP_GPIO("emmc_nb", 27, 9, BIT(2), "emmc"),
-	PIN_GRP_GPIO("pwm0", 11, 1, BIT(3), "pwm"),
-	PIN_GRP_GPIO("pwm1", 12, 1, BIT(4), "pwm"),
-	PIN_GRP_GPIO("pwm2", 13, 1, BIT(5), "pwm"),
-	PIN_GRP_GPIO("pwm3", 14, 1, BIT(6), "pwm"),
+	PIN_GRP_GPIO_3("pwm0", 11, 1, BIT(3) | BIT(20), 0, BIT(20), BIT(3),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm1", 12, 1, BIT(4) | BIT(21), 0, BIT(21), BIT(4),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm2", 13, 1, BIT(5) | BIT(22), 0, BIT(22), BIT(5),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm3", 14, 1, BIT(6) | BIT(23), 0, BIT(23), BIT(6),
+		       "pwm", "led"),
 	PIN_GRP_GPIO("pmic1", 7, 1, BIT(7), "pmic"),
 	PIN_GRP_GPIO("pmic0", 6, 1, BIT(8), "pmic"),
 	PIN_GRP_GPIO("i2c2", 2, 2, BIT(9), "i2c"),
@@ -184,10 +188,6 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
 	PIN_GRP_EXTRA("uart2", 9, 2, BIT(1) | BIT(13) | BIT(14) | BIT(19),
 		      BIT(1) | BIT(13) | BIT(14), BIT(1) | BIT(19),
 		      18, 2, "gpio", "uart"),
-	PIN_GRP_GPIO_2("led0_od", 11, 1, BIT(20), BIT(20), 0, "led"),
-	PIN_GRP_GPIO_2("led1_od", 12, 1, BIT(21), BIT(21), 0, "led"),
-	PIN_GRP_GPIO_2("led2_od", 13, 1, BIT(22), BIT(22), 0, "led"),
-	PIN_GRP_GPIO_2("led3_od", 14, 1, BIT(23), BIT(23), 0, "led"),
 };
 
 static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 983ba9865f77..263498be8e31 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -710,7 +710,7 @@ static const struct ingenic_chip_info jz4755_chip_info = {
 };
 
 static const u32 jz4760_pull_ups[6] = {
-	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
+	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
 };
 
 static const u32 jz4760_pull_downs[6] = {
@@ -936,11 +936,11 @@ static const struct ingenic_chip_info jz4760_chip_info = {
 };
 
 static const u32 jz4770_pull_ups[6] = {
-	0x3fffffff, 0xfff0030c, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0xffa7f00f,
+	0x3fffffff, 0xfff0f3fc, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0x0024f00f,
 };
 
 static const u32 jz4770_pull_downs[6] = {
-	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x00580ff0,
+	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x005b0ff0,
 };
 
 static int jz4770_uart0_data_pins[] = { 0xa0, 0xa3, };
@@ -3441,17 +3441,17 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 {
 	if (jzpc->info->version >= ID_X2000) {
 		switch (bias) {
-		case PIN_CONFIG_BIAS_PULL_UP:
+		case GPIO_PULL_UP:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, true);
 			break;
 
-		case PIN_CONFIG_BIAS_PULL_DOWN:
+		case GPIO_PULL_DOWN:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, true);
 			break;
 
-		case PIN_CONFIG_BIAS_DISABLE:
+		case GPIO_PULL_DIS:
 		default:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2c9c9835f375..b1f6e4e8bcbb 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1221,6 +1221,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 
 	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
+		res = -ENOTSUPP;
 		goto free_pingroups;
 	}
 
diff --git a/drivers/pinctrl/pinctrl-stmfx.c b/drivers/pinctrl/pinctrl-stmfx.c
index 008c83107a3c..5fa2488fae87 100644
--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -566,7 +566,7 @@ static irqreturn_t stmfx_pinctrl_irq_thread_fn(int irq, void *dev_id)
 	u8 pending[NR_GPIO_REGS];
 	u8 src[NR_GPIO_REGS] = {0, 0, 0};
 	unsigned long n, status;
-	int ret;
+	int i, ret;
 
 	ret = regmap_bulk_read(pctl->stmfx->map, STMFX_REG_IRQ_GPI_PENDING,
 			       &pending, NR_GPIO_REGS);
@@ -576,7 +576,9 @@ static irqreturn_t stmfx_pinctrl_irq_thread_fn(int irq, void *dev_id)
 	regmap_bulk_write(pctl->stmfx->map, STMFX_REG_IRQ_GPI_SRC,
 			  src, NR_GPIO_REGS);
 
-	status = *(unsigned long *)pending;
+	BUILD_BUG_ON(NR_GPIO_REGS > sizeof(status));
+	for (i = 0, status = 0; i < NR_GPIO_REGS; i++)
+		status |= (unsigned long)pending[i] << (i * 8);
 	for_each_set_bit(n, &status, gc->ngpio) {
 		handle_nested_irq(irq_find_mapping(gc->irq.domain, n));
 		stmfx_pinctrl_irq_toggle_trigger(pctl, n);
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 376876bd6605..2975b4369f32 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -918,7 +918,7 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 		pin_bank->grange.pin_base = drvdata->pin_base
 						+ pin_bank->pin_base;
 		pin_bank->grange.base = pin_bank->grange.pin_base;
-		pin_bank->grange.npins = pin_bank->gpio_chip.ngpio;
+		pin_bank->grange.npins = pin_bank->nr_pins;
 		pin_bank->grange.gc = &pin_bank->gpio_chip;
 		pinctrl_add_gpio_range(drvdata->pctl_dev, &pin_bank->grange);
 	}
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index aa7f7aa77297..a7404d69b2d3 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -279,6 +279,15 @@ static int cros_ec_host_command_proto_query(struct cros_ec_device *ec_dev,
 	msg->insize = sizeof(struct ec_response_get_protocol_info);
 
 	ret = send_command(ec_dev, msg);
+	/*
+	 * Send command once again when timeout occurred.
+	 * Fingerprint MCU (FPMCU) is restarted during system boot which
+	 * introduces small window in which FPMCU won't respond for any
+	 * messages sent by kernel. There is no need to wait before next
+	 * attempt because we waited at least EC_MSG_DEADLINE_MS.
+	 */
+	if (ret == -ETIMEDOUT)
+		ret = send_command(ec_dev, msg);
 
 	if (ret < 0) {
 		dev_dbg(ec_dev->dev,
diff --git a/drivers/platform/x86/dell/dell-smbios-wmi.c b/drivers/platform/x86/dell/dell-smbios-wmi.c
index 33f823772733..8e761991455a 100644
--- a/drivers/platform/x86/dell/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell/dell-smbios-wmi.c
@@ -69,6 +69,7 @@ static int run_smbios_call(struct wmi_device *wdev)
 		if (obj->type == ACPI_TYPE_INTEGER)
 			dev_dbg(&wdev->dev, "SMBIOS call failed: %llu\n",
 				obj->integer.value);
+		kfree(output.pointer);
 		return -EIO;
 	}
 	memcpy(&priv->buf->std, obj->buffer.pointer, obj->buffer.length);
diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 215e77d3b6d9..622bdae6182c 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -869,8 +869,12 @@ static irqreturn_t max17042_thread_handler(int id, void *dev)
 {
 	struct max17042_chip *chip = dev;
 	u32 val;
+	int ret;
+
+	ret = regmap_read(chip->regmap, MAX17042_STATUS, &val);
+	if (ret)
+		return IRQ_HANDLED;
 
-	regmap_read(chip->regmap, MAX17042_STATUS, &val);
 	if ((val & STATUS_INTR_SOCMIN_BIT) ||
 		(val & STATUS_INTR_SOCMAX_BIT)) {
 		dev_info(&chip->client->dev, "SOC threshold INTR\n");
diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index bc89c62ccb9b..75e4c2d777b9 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -467,6 +467,6 @@ static struct platform_driver tps65910_rtc_driver = {
 };
 
 module_platform_driver(tps65910_rtc_driver);
-MODULE_ALIAS("platform:rtc-tps65910");
+MODULE_ALIAS("platform:tps65910-rtc");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 307ce7ff5ca4..2d672aa27a54 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -886,6 +886,33 @@ static void qdio_shutdown_queues(struct qdio_irq *irq_ptr)
 	}
 }
 
+static int qdio_cancel_ccw(struct qdio_irq *irq, int how)
+{
+	struct ccw_device *cdev = irq->cdev;
+	int rc;
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	qdio_set_state(irq, QDIO_IRQ_STATE_CLEANUP);
+	if (how & QDIO_FLAG_CLEANUP_USING_CLEAR)
+		rc = ccw_device_clear(cdev, QDIO_DOING_CLEANUP);
+	else
+		/* default behaviour is halt */
+		rc = ccw_device_halt(cdev, QDIO_DOING_CLEANUP);
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+	if (rc) {
+		DBF_ERROR("%4x SHUTD ERR", irq->schid.sch_no);
+		DBF_ERROR("rc:%4d", rc);
+		return rc;
+	}
+
+	wait_event_interruptible_timeout(cdev->private->wait_q,
+					 irq->state == QDIO_IRQ_STATE_INACTIVE ||
+					 irq->state == QDIO_IRQ_STATE_ERR,
+					 10 * HZ);
+
+	return 0;
+}
+
 /**
  * qdio_shutdown - shut down a qdio subchannel
  * @cdev: associated ccw device
@@ -923,27 +950,7 @@ int qdio_shutdown(struct ccw_device *cdev, int how)
 	qdio_shutdown_queues(irq_ptr);
 	qdio_shutdown_debug_entries(irq_ptr);
 
-	/* cleanup subchannel */
-	spin_lock_irq(get_ccwdev_lock(cdev));
-	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_CLEANUP);
-	if (how & QDIO_FLAG_CLEANUP_USING_CLEAR)
-		rc = ccw_device_clear(cdev, QDIO_DOING_CLEANUP);
-	else
-		/* default behaviour is halt */
-		rc = ccw_device_halt(cdev, QDIO_DOING_CLEANUP);
-	spin_unlock_irq(get_ccwdev_lock(cdev));
-	if (rc) {
-		DBF_ERROR("%4x SHUTD ERR", irq_ptr->schid.sch_no);
-		DBF_ERROR("rc:%4d", rc);
-		goto no_cleanup;
-	}
-
-	wait_event_interruptible_timeout(cdev->private->wait_q,
-		irq_ptr->state == QDIO_IRQ_STATE_INACTIVE ||
-		irq_ptr->state == QDIO_IRQ_STATE_ERR,
-		10 * HZ);
-
-no_cleanup:
+	rc = qdio_cancel_ccw(irq_ptr, how);
 	qdio_shutdown_thinint(irq_ptr);
 	qdio_shutdown_irq(irq_ptr);
 
@@ -1079,6 +1086,7 @@ int qdio_establish(struct ccw_device *cdev,
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct subchannel_id schid;
+	long timeout;
 	int rc;
 
 	ccw_device_get_schid(cdev, &schid);
@@ -1107,11 +1115,8 @@ int qdio_establish(struct ccw_device *cdev,
 	qdio_setup_irq(irq_ptr, init_data);
 
 	rc = qdio_establish_thinint(irq_ptr);
-	if (rc) {
-		qdio_shutdown_irq(irq_ptr);
-		mutex_unlock(&irq_ptr->setup_mutex);
-		return rc;
-	}
+	if (rc)
+		goto err_thinint;
 
 	/* establish q */
 	irq_ptr->ccw.cmd_code = irq_ptr->equeue.cmd;
@@ -1127,15 +1132,16 @@ int qdio_establish(struct ccw_device *cdev,
 	if (rc) {
 		DBF_ERROR("%4x est IO ERR", irq_ptr->schid.sch_no);
 		DBF_ERROR("rc:%4x", rc);
-		qdio_shutdown_thinint(irq_ptr);
-		qdio_shutdown_irq(irq_ptr);
-		mutex_unlock(&irq_ptr->setup_mutex);
-		return rc;
+		goto err_ccw_start;
 	}
 
-	wait_event_interruptible_timeout(cdev->private->wait_q,
-		irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
-		irq_ptr->state == QDIO_IRQ_STATE_ERR, HZ);
+	timeout = wait_event_interruptible_timeout(cdev->private->wait_q,
+						   irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
+						   irq_ptr->state == QDIO_IRQ_STATE_ERR, HZ);
+	if (timeout <= 0) {
+		rc = (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
+		goto err_ccw_timeout;
+	}
 
 	if (irq_ptr->state != QDIO_IRQ_STATE_ESTABLISHED) {
 		mutex_unlock(&irq_ptr->setup_mutex);
@@ -1152,6 +1158,16 @@ int qdio_establish(struct ccw_device *cdev,
 	qdio_print_subchannel_info(irq_ptr);
 	qdio_setup_debug_entries(irq_ptr);
 	return 0;
+
+err_ccw_timeout:
+	qdio_cancel_ccw(irq_ptr, QDIO_FLAG_CLEANUP_USING_CLEAR);
+err_ccw_start:
+	qdio_shutdown_thinint(irq_ptr);
+err_thinint:
+	qdio_shutdown_irq(irq_ptr);
+	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_INACTIVE);
+	mutex_unlock(&irq_ptr->setup_mutex);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(qdio_establish);
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index adddcd589941..0df93d2cd3c3 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1711,7 +1711,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
 		blogic_info("  DMA Channel: None, ", adapter);
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%lX, ", adapter,
+			blogic_info("BIOS Address: 0x%X, ", adapter,
 					adapter->bios_addr);
 		else
 			blogic_info("BIOS Address: None, ", adapter);
@@ -3451,7 +3451,7 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			if (buf[0] != '\n' || len > 1)
 				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	} else {
 		if (begin) {
 			if (adapter != NULL && adapter->adapter_initd)
@@ -3459,7 +3459,7 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			else
 				printk("%s%s", blogic_msglevelmap[msglevel], buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	}
 	begin = (buf[len - 1] == '\n');
 }
diff --git a/drivers/scsi/pcmcia/fdomain_cs.c b/drivers/scsi/pcmcia/fdomain_cs.c
index e42acf314d06..33df6a9ba9b5 100644
--- a/drivers/scsi/pcmcia/fdomain_cs.c
+++ b/drivers/scsi/pcmcia/fdomain_cs.c
@@ -45,8 +45,10 @@ static int fdomain_probe(struct pcmcia_device *link)
 		goto fail_disable;
 
 	if (!request_region(link->resource[0]->start, FDOMAIN_REGION_SIZE,
-			    "fdomain_cs"))
+			    "fdomain_cs")) {
+		ret = -EBUSY;
 		goto fail_disable;
+	}
 
 	sh = fdomain_create(link->resource[0]->start, link->irq, 7, &link->dev);
 	if (!sh) {
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index b92570a7c309..98981a61b012 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3000,7 +3000,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -3012,7 +3012,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 */
 	if (!qedf->num_queues) {
 		QEDF_ERR(&(qedf->dbg_ctx), "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/*
@@ -3020,7 +3020,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 * addresses of our queues
 	 */
 	if (!qedf->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
 		goto mem_alloc_failure;
 	}
@@ -3036,8 +3036,8 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		   "qedf->global_queues=%p.\n", qedf->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedf_alloc_bdq(qedf);
-	if (rc) {
+	status = qedf_alloc_bdq(qedf);
+	if (status) {
 		QEDF_ERR(&qedf->dbg_ctx, "Unable to allocate bdq.\n");
 		goto mem_alloc_failure;
 	}
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index edf915432704..99e1a323807d 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1621,7 +1621,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -1632,14 +1632,14 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 	 */
 	if (!qedi->num_queues) {
 		QEDI_ERR(&qedi->dbg_ctx, "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/* Make sure we allocated the PBL that will contain the physical
 	 * addresses of our queues
 	 */
 	if (!qedi->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		goto mem_alloc_failure;
 	}
 
@@ -1654,13 +1654,13 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		  "qedi->global_queues=%p.\n", qedi->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedi_alloc_bdq(qedi);
-	if (rc)
+	status = qedi_alloc_bdq(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate DMA coherent buffers for NVM_ISCSI_CFG */
-	rc = qedi_alloc_nvm_iscsi_cfg(qedi);
-	if (rc)
+	status = qedi_alloc_nvm_iscsi_cfg(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate a CQ and an associated PBL for each MSI-X
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0cacb667a88b..adc912997211 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -91,8 +91,9 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
 
-	if (!qidx)
-		qidx++;
+	/* Map admin queue and 1st IO queue to index 0 */
+	if (qidx)
+		qidx--;
 
 	vha = (struct scsi_qla_host *)lport->private;
 	ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..df4199fd44d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/refcount.h>
+#include <linux/crash_dump.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2818,6 +2819,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			return ret;
 	}
 
+	if (is_kdump_kernel()) {
+		ql2xmqsupport = 0;
+		ql2xallocfwdump = 0;
+	}
+
 	/* This may fail but that's ok */
 	pci_enable_pcie_error_reporting(pdev);
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5db16509b6e1..f573517e8f6e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1322,6 +1322,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 				"requested %u bytes, received %u bytes\n",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
+			rc = -EINVAL;
 			goto error;
 		}
 	}
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 70647eacf195..3e5690c45e63 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -259,7 +259,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	struct ufs_hba *hba = ufs->hba;
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	u32 pclk_rate;
+	unsigned long pclk_rate;
 	u32 f_min, f_max;
 	u8 div = 0;
 	int ret = 0;
@@ -298,7 +298,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	}
 
 	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
-		dev_err(hba->dev, "not available pclk range %d\n", pclk_rate);
+		dev_err(hba->dev, "not available pclk range %lu\n", pclk_rate);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 06ee565f7eb0..a5804e8eb358 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -184,7 +184,7 @@ struct exynos_ufs {
 	u32 pclk_div;
 	u32 pclk_avail_min;
 	u32 pclk_avail_max;
-	u32 mclk_rate;
+	unsigned long mclk_rate;
 	int avail_ln_rx;
 	int avail_ln_tx;
 	int rx_sel_idx;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 72fd41bfbd54..90837e54c2fe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3326,9 +3326,11 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	if (is_kmalloc) {
 		/* Make sure we don't copy more data than available */
-		if (param_offset + param_size > buff_len)
-			param_size = buff_len - param_offset;
-		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+		if (param_offset >= buff_len)
+			ret = -EINVAL;
+		else
+			memcpy(param_read_buf, &desc_buf[param_offset],
+			       min_t(u32, param_size, buff_len - param_offset));
 	}
 out:
 	if (is_kmalloc)
diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index c557ffd0992c..55e46fa6cf42 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -51,7 +51,7 @@ static int aspeed_lpc_ctrl_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long vsize = vma->vm_end - vma->vm_start;
 	pgprot_t prot = vma->vm_page_prot;
 
-	if (vma->vm_pgoff + vsize > lpc_ctrl->mem_base + lpc_ctrl->mem_size)
+	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
diff --git a/drivers/soc/aspeed/aspeed-p2a-ctrl.c b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
index b60fbeaffcbd..20b5fb2a207c 100644
--- a/drivers/soc/aspeed/aspeed-p2a-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
@@ -110,7 +110,7 @@ static int aspeed_p2a_mmap(struct file *file, struct vm_area_struct *vma)
 	vsize = vma->vm_end - vma->vm_start;
 	prot = vma->vm_page_prot;
 
-	if (vma->vm_pgoff + vsize > ctrl->mem_base + ctrl->mem_size)
+	if (vma->vm_pgoff + vma_pages(vma) > ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
diff --git a/drivers/soc/mediatek/mtk-mmsys.h b/drivers/soc/mediatek/mtk-mmsys.h
index 5f3e2bf0c40b..9e2b81bd38db 100644
--- a/drivers/soc/mediatek/mtk-mmsys.h
+++ b/drivers/soc/mediatek/mtk-mmsys.h
@@ -262,6 +262,10 @@ static const struct mtk_mmsys_routes mmsys_default_routing_table[] = {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
 		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
 		DSI3_SEL_IN_RDMA2
+	}, {
+		DDP_COMPONENT_UFOE, DDP_COMPONENT_DSI0,
+		DISP_REG_CONFIG_DISP_UFOE_MOUT_EN, UFOE_MOUT_EN_DSI0,
+		UFOE_MOUT_EN_DSI0
 	}
 };
 
diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index 934fcc4d2b05..7b6b94332510 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -476,12 +476,12 @@ static int qmp_cooling_device_add(struct qmp *qmp,
 static int qmp_cooling_devices_register(struct qmp *qmp)
 {
 	struct device_node *np, *child;
-	int count = QMP_NUM_COOLING_RESOURCES;
+	int count = 0;
 	int ret;
 
 	np = qmp->dev->of_node;
 
-	qmp->cooling_devs = devm_kcalloc(qmp->dev, count,
+	qmp->cooling_devs = devm_kcalloc(qmp->dev, QMP_NUM_COOLING_RESOURCES,
 					 sizeof(*qmp->cooling_devs),
 					 GFP_KERNEL);
 
@@ -497,12 +497,16 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
 			goto unroll;
 	}
 
+	if (!count)
+		devm_kfree(qmp->dev, qmp->cooling_devs);
+
 	return 0;
 
 unroll:
 	while (--count >= 0)
 		thermal_cooling_device_unregister
 			(qmp->cooling_devs[count].cdev);
+	devm_kfree(qmp->dev, qmp->cooling_devs);
 
 	return ret;
 }
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index fd95f94630b1..c03d51ad40bf 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -537,12 +537,14 @@ static int intel_link_power_down(struct sdw_intel *sdw)
 
 	mutex_lock(sdw->link_res->shim_lock);
 
-	intel_shim_master_ip_to_glue(sdw);
-
 	if (!(*shim_mask & BIT(link_id)))
 		dev_err(sdw->cdns.dev,
 			"%s: Unbalanced power-up/down calls\n", __func__);
 
+	sdw->cdns.link_up = false;
+
+	intel_shim_master_ip_to_glue(sdw);
+
 	*shim_mask &= ~BIT(link_id);
 
 	if (!*shim_mask) {
@@ -559,18 +561,19 @@ static int intel_link_power_down(struct sdw_intel *sdw)
 		link_control &=  spa_mask;
 
 		ret = intel_clear_bit(shim, SDW_SHIM_LCTL, link_control, cpa_mask);
+		if (ret < 0) {
+			dev_err(sdw->cdns.dev, "%s: could not power down link\n", __func__);
+
+			/*
+			 * we leave the sdw->cdns.link_up flag as false since we've disabled
+			 * the link at this point and cannot handle interrupts any longer.
+			 */
+		}
 	}
 
 	mutex_unlock(sdw->link_res->shim_lock);
 
-	if (ret < 0) {
-		dev_err(sdw->cdns.dev, "%s: could not power down link\n", __func__);
-
-		return ret;
-	}
-
-	sdw->cdns.link_up = false;
-	return 0;
+	return ret;
 }
 
 static void intel_shim_sync_arm(struct sdw_intel *sdw)
diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index 87f8829c3995..829770b8ec74 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -25,16 +25,11 @@
 
 #define SPI_FSI_BASE			0x70000
 #define SPI_FSI_INIT_TIMEOUT_MS		1000
-#define SPI_FSI_MAX_XFR_SIZE		2048
-#define SPI_FSI_MAX_XFR_SIZE_RESTRICTED	8
+#define SPI_FSI_MAX_RX_SIZE		8
+#define SPI_FSI_MAX_TX_SIZE		40
 
 #define SPI_FSI_ERROR			0x0
 #define SPI_FSI_COUNTER_CFG		0x1
-#define  SPI_FSI_COUNTER_CFG_LOOPS(x)	 (((u64)(x) & 0xffULL) << 32)
-#define  SPI_FSI_COUNTER_CFG_N2_RX	 BIT_ULL(8)
-#define  SPI_FSI_COUNTER_CFG_N2_TX	 BIT_ULL(9)
-#define  SPI_FSI_COUNTER_CFG_N2_IMPLICIT BIT_ULL(10)
-#define  SPI_FSI_COUNTER_CFG_N2_RELOAD	 BIT_ULL(11)
 #define SPI_FSI_CFG1			0x2
 #define SPI_FSI_CLOCK_CFG		0x3
 #define  SPI_FSI_CLOCK_CFG_MM_ENABLE	 BIT_ULL(32)
@@ -76,8 +71,6 @@ struct fsi_spi {
 	struct device *dev;	/* SPI controller device */
 	struct fsi_device *fsi;	/* FSI2SPI CFAM engine device */
 	u32 base;
-	size_t max_xfr_size;
-	bool restricted;
 };
 
 struct fsi_spi_sequence {
@@ -241,7 +234,7 @@ static int fsi_spi_reset(struct fsi_spi *ctx)
 	return fsi_spi_write_reg(ctx, SPI_FSI_STATUS, 0ULL);
 }
 
-static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
+static void fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
 {
 	/*
 	 * Add the next byte of instruction to the 8-byte sequence register.
@@ -251,8 +244,6 @@ static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
 	 */
 	seq->data |= (u64)val << seq->bit;
 	seq->bit -= 8;
-
-	return ((64 - seq->bit) / 8) - 2;
 }
 
 static void fsi_spi_sequence_init(struct fsi_spi_sequence *seq)
@@ -261,71 +252,11 @@ static void fsi_spi_sequence_init(struct fsi_spi_sequence *seq)
 	seq->data = 0ULL;
 }
 
-static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
-				     struct fsi_spi_sequence *seq,
-				     struct spi_transfer *transfer)
-{
-	int loops;
-	int idx;
-	int rc;
-	u8 val = 0;
-	u8 len = min(transfer->len, 8U);
-	u8 rem = transfer->len % len;
-
-	loops = transfer->len / len;
-
-	if (transfer->tx_buf) {
-		val = SPI_FSI_SEQUENCE_SHIFT_OUT(len);
-		idx = fsi_spi_sequence_add(seq, val);
-
-		if (rem)
-			rem = SPI_FSI_SEQUENCE_SHIFT_OUT(rem);
-	} else if (transfer->rx_buf) {
-		val = SPI_FSI_SEQUENCE_SHIFT_IN(len);
-		idx = fsi_spi_sequence_add(seq, val);
-
-		if (rem)
-			rem = SPI_FSI_SEQUENCE_SHIFT_IN(rem);
-	} else {
-		return -EINVAL;
-	}
-
-	if (ctx->restricted && loops > 1) {
-		dev_warn(ctx->dev,
-			 "Transfer too large; no branches permitted.\n");
-		return -EINVAL;
-	}
-
-	if (loops > 1) {
-		u64 cfg = SPI_FSI_COUNTER_CFG_LOOPS(loops - 1);
-
-		fsi_spi_sequence_add(seq, SPI_FSI_SEQUENCE_BRANCH(idx));
-
-		if (transfer->rx_buf)
-			cfg |= SPI_FSI_COUNTER_CFG_N2_RX |
-				SPI_FSI_COUNTER_CFG_N2_TX |
-				SPI_FSI_COUNTER_CFG_N2_IMPLICIT |
-				SPI_FSI_COUNTER_CFG_N2_RELOAD;
-
-		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, cfg);
-		if (rc)
-			return rc;
-	} else {
-		fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, 0ULL);
-	}
-
-	if (rem)
-		fsi_spi_sequence_add(seq, rem);
-
-	return 0;
-}
-
 static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 				 struct spi_transfer *transfer)
 {
 	int rc = 0;
 	u64 status = 0ULL;
-	u64 cfg = 0ULL;
 
 	if (transfer->tx_buf) {
 		int nb;
@@ -363,16 +294,6 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		u64 in = 0ULL;
 		u8 *rx = transfer->rx_buf;
 
-		rc = fsi_spi_read_reg(ctx, SPI_FSI_COUNTER_CFG, &cfg);
-		if (rc)
-			return rc;
-
-		if (cfg & SPI_FSI_COUNTER_CFG_N2_IMPLICIT) {
-			rc = fsi_spi_write_reg(ctx, SPI_FSI_DATA_TX, 0);
-			if (rc)
-				return rc;
-		}
-
 		while (transfer->len > recv) {
 			do {
 				rc = fsi_spi_read_reg(ctx, SPI_FSI_STATUS,
@@ -439,6 +360,10 @@ static int fsi_spi_transfer_init(struct fsi_spi *ctx)
 		}
 	} while (seq_state && (seq_state != SPI_FSI_STATUS_SEQ_STATE_IDLE));
 
+	rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, 0ULL);
+	if (rc)
+		return rc;
+
 	rc = fsi_spi_read_reg(ctx, SPI_FSI_CLOCK_CFG, &clock_cfg);
 	if (rc)
 		return rc;
@@ -459,6 +384,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 {
 	int rc;
 	u8 seq_slave = SPI_FSI_SEQUENCE_SEL_SLAVE(mesg->spi->chip_select + 1);
+	unsigned int len;
 	struct spi_transfer *transfer;
 	struct fsi_spi *ctx = spi_controller_get_devdata(ctlr);
 
@@ -471,8 +397,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 		struct spi_transfer *next = NULL;
 
 		/* Sequencer must do shift out (tx) first. */
-		if (!transfer->tx_buf ||
-		    transfer->len > (ctx->max_xfr_size + 8)) {
+		if (!transfer->tx_buf || transfer->len > SPI_FSI_MAX_TX_SIZE) {
 			rc = -EINVAL;
 			goto error;
 		}
@@ -486,9 +411,13 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 		fsi_spi_sequence_init(&seq);
 		fsi_spi_sequence_add(&seq, seq_slave);
 
-		rc = fsi_spi_sequence_transfer(ctx, &seq, transfer);
-		if (rc)
-			goto error;
+		len = transfer->len;
+		while (len > 8) {
+			fsi_spi_sequence_add(&seq,
+					     SPI_FSI_SEQUENCE_SHIFT_OUT(8));
+			len -= 8;
+		}
+		fsi_spi_sequence_add(&seq, SPI_FSI_SEQUENCE_SHIFT_OUT(len));
 
 		if (!list_is_last(&transfer->transfer_list,
 				  &mesg->transfers)) {
@@ -496,7 +425,9 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 			/* Sequencer can only do shift in (rx) after tx. */
 			if (next->rx_buf) {
-				if (next->len > ctx->max_xfr_size) {
+				u8 shift;
+
+				if (next->len > SPI_FSI_MAX_RX_SIZE) {
 					rc = -EINVAL;
 					goto error;
 				}
@@ -504,10 +435,8 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 				dev_dbg(ctx->dev, "Sequence rx of %d bytes.\n",
 					next->len);
 
-				rc = fsi_spi_sequence_transfer(ctx, &seq,
-							       next);
-				if (rc)
-					goto error;
+				shift = SPI_FSI_SEQUENCE_SHIFT_IN(next->len);
+				fsi_spi_sequence_add(&seq, shift);
 			} else {
 				next = NULL;
 			}
@@ -541,9 +470,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 static size_t fsi_spi_max_transfer_size(struct spi_device *spi)
 {
-	struct fsi_spi *ctx = spi_controller_get_devdata(spi->controller);
-
-	return ctx->max_xfr_size;
+	return SPI_FSI_MAX_RX_SIZE;
 }
 
 static int fsi_spi_probe(struct device *dev)
@@ -582,14 +509,6 @@ static int fsi_spi_probe(struct device *dev)
 		ctx->fsi = fsi;
 		ctx->base = base + SPI_FSI_BASE;
 
-		if (of_device_is_compatible(np, "ibm,fsi2spi-restricted")) {
-			ctx->restricted = true;
-			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE_RESTRICTED;
-		} else {
-			ctx->restricted = false;
-			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE;
-		}
-
 		rc = devm_spi_register_controller(dev, ctlr);
 		if (rc)
 			spi_controller_put(ctlr);
diff --git a/drivers/staging/board/board.c b/drivers/staging/board/board.c
index cb6feb34dd40..f980af037345 100644
--- a/drivers/staging/board/board.c
+++ b/drivers/staging/board/board.c
@@ -136,6 +136,7 @@ int __init board_staging_register_clock(const struct board_staging_clk *bsc)
 static int board_staging_add_dev_domain(struct platform_device *pdev,
 					const char *domain)
 {
+	struct device *dev = &pdev->dev;
 	struct of_phandle_args pd_args;
 	struct device_node *np;
 
@@ -148,7 +149,11 @@ static int board_staging_add_dev_domain(struct platform_device *pdev,
 	pd_args.np = np;
 	pd_args.args_count = 0;
 
-	return of_genpd_add_device(&pd_args, &pdev->dev);
+	/* Initialization similar to device_pm_init_common() */
+	spin_lock_init(&dev->power.lock);
+	dev->power.early_init = true;
+
+	return of_genpd_add_device(&pd_args, dev);
 }
 #else
 static inline int board_staging_add_dev_domain(struct platform_device *pdev,
diff --git a/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml b/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
index 3b23ad56b31a..ef664b4458fb 100644
--- a/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
+++ b/drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml
@@ -42,6 +42,8 @@ properties:
   regulators:
     type: object
 
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -50,11 +52,13 @@ properties:
         const: 0
 
     patternProperties:
-      '^ldo[0-9]+@[0-9a-f]$':
+      '^(ldo|LDO)[0-9]+$':
         type: object
 
         $ref: "/schemas/regulator/regulator.yaml#"
 
+        unevaluatedProperties: false
+
 required:
   - compatible
   - reg
diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index cbc0032c1604..98d759e7cc95 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -939,9 +939,9 @@ static void ks7010_private_init(struct ks_wlan_private *priv,
 	memset(&priv->wstats, 0, sizeof(priv->wstats));
 
 	/* sleep mode */
+	atomic_set(&priv->sleepstatus.status, 0);
 	atomic_set(&priv->sleepstatus.doze_request, 0);
 	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
 
 	trx_device_init(priv);
 	hostif_init(priv);
diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index 0295e2e32d79..fa1bd99cd6f1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -1763,7 +1763,8 @@ static int atomisp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (err < 0)
 		goto register_entities_fail;
 	/* init atomisp wdts */
-	if (init_atomisp_wdts(isp) != 0)
+	err = init_atomisp_wdts(isp);
+	if (err != 0)
 		goto wdt_work_queue_fail;
 
 	/* save the iunit context only once after all the values are init'ed. */
@@ -1815,6 +1816,7 @@ static int atomisp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	hmm_cleanup();
 	hmm_pool_unregister(HMM_POOL_TYPE_RESERVED);
 hmm_pool_fail:
+	pm_runtime_get_noresume(&pdev->dev);
 	destroy_workqueue(isp->wdt_work_queue);
 wdt_work_queue_fail:
 	atomisp_acc_cleanup(isp);
diff --git a/drivers/staging/media/hantro/hantro_g1_vp8_dec.c b/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
index 57002ba70176..3cd90637ac63 100644
--- a/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
+++ b/drivers/staging/media/hantro/hantro_g1_vp8_dec.c
@@ -376,12 +376,17 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vb2_dst = hantro_get_dst_buf(ctx);
 
 	ref = hantro_get_ref(ctx, hdr->last_frame_ts);
-	if (!ref)
+	if (!ref) {
+		vpu_debug(0, "failed to find last frame ts=%llu\n",
+			  hdr->last_frame_ts);
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
+	}
 	vdpu_write_relaxed(vpu, ref, G1_REG_ADDR_REF(0));
 
 	ref = hantro_get_ref(ctx, hdr->golden_frame_ts);
-	WARN_ON(!ref && hdr->golden_frame_ts);
+	if (!ref && hdr->golden_frame_ts)
+		vpu_debug(0, "failed to find golden frame ts=%llu\n",
+			  hdr->golden_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_GOLDEN)
@@ -389,7 +394,9 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vdpu_write_relaxed(vpu, ref, G1_REG_ADDR_REF(4));
 
 	ref = hantro_get_ref(ctx, hdr->alt_frame_ts);
-	WARN_ON(!ref && hdr->alt_frame_ts);
+	if (!ref && hdr->alt_frame_ts)
+		vpu_debug(0, "failed to find alt frame ts=%llu\n",
+			  hdr->alt_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_ALT)
diff --git a/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c b/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
index 8661a3cc1e6b..361619201605 100644
--- a/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
+++ b/drivers/staging/media/hantro/rk3399_vpu_hw_vp8_dec.c
@@ -453,12 +453,17 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vb2_dst = hantro_get_dst_buf(ctx);
 
 	ref = hantro_get_ref(ctx, hdr->last_frame_ts);
-	if (!ref)
+	if (!ref) {
+		vpu_debug(0, "failed to find last frame ts=%llu\n",
+			  hdr->last_frame_ts);
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
+	}
 	vdpu_write_relaxed(vpu, ref, VDPU_REG_VP8_ADDR_REF0);
 
 	ref = hantro_get_ref(ctx, hdr->golden_frame_ts);
-	WARN_ON(!ref && hdr->golden_frame_ts);
+	if (!ref && hdr->golden_frame_ts)
+		vpu_debug(0, "failed to find golden frame ts=%llu\n",
+			  hdr->golden_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_GOLDEN)
@@ -466,7 +471,9 @@ static void cfg_ref(struct hantro_ctx *ctx,
 	vdpu_write_relaxed(vpu, ref, VDPU_REG_VP8_ADDR_REF2_5(2));
 
 	ref = hantro_get_ref(ctx, hdr->alt_frame_ts);
-	WARN_ON(!ref && hdr->alt_frame_ts);
+	if (!ref && hdr->alt_frame_ts)
+		vpu_debug(0, "failed to find alt frame ts=%llu\n",
+			  hdr->alt_frame_ts);
 	if (!ref)
 		ref = vb2_dma_contig_plane_dma_addr(&vb2_dst->vb2_buf, 0);
 	if (hdr->flags & V4L2_VP8_FRAME_FLAG_SIGN_BIAS_ALT)
diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index f85a2f5f1413..ad1bca3fe047 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -361,6 +361,7 @@ static void imx7_csi_dma_unsetup_vb2_buf(struct imx7_csi *csi,
 
 			vb->timestamp = ktime_get_ns();
 			vb2_buffer_done(vb, return_status);
+			csi->active_vb2_buf[i] = NULL;
 		}
 	}
 }
@@ -386,9 +387,10 @@ static int imx7_csi_dma_setup(struct imx7_csi *csi)
 	return 0;
 }
 
-static void imx7_csi_dma_cleanup(struct imx7_csi *csi)
+static void imx7_csi_dma_cleanup(struct imx7_csi *csi,
+				 enum vb2_buffer_state return_status)
 {
-	imx7_csi_dma_unsetup_vb2_buf(csi, VB2_BUF_STATE_ERROR);
+	imx7_csi_dma_unsetup_vb2_buf(csi, return_status);
 	imx_media_free_dma_buf(csi->dev, &csi->underrun_buf);
 }
 
@@ -537,9 +539,10 @@ static int imx7_csi_init(struct imx7_csi *csi)
 	return 0;
 }
 
-static void imx7_csi_deinit(struct imx7_csi *csi)
+static void imx7_csi_deinit(struct imx7_csi *csi,
+			    enum vb2_buffer_state return_status)
 {
-	imx7_csi_dma_cleanup(csi);
+	imx7_csi_dma_cleanup(csi, return_status);
 	imx7_csi_init_default(csi);
 	imx7_csi_dmareq_rff_disable(csi);
 	clk_disable_unprepare(csi->mclk);
@@ -702,7 +705,7 @@ static int imx7_csi_s_stream(struct v4l2_subdev *sd, int enable)
 
 		ret = v4l2_subdev_call(csi->src_sd, video, s_stream, 1);
 		if (ret < 0) {
-			imx7_csi_deinit(csi);
+			imx7_csi_deinit(csi, VB2_BUF_STATE_QUEUED);
 			goto out_unlock;
 		}
 
@@ -712,7 +715,7 @@ static int imx7_csi_s_stream(struct v4l2_subdev *sd, int enable)
 
 		v4l2_subdev_call(csi->src_sd, video, s_stream, 0);
 
-		imx7_csi_deinit(csi);
+		imx7_csi_deinit(csi, VB2_BUF_STATE_ERROR);
 	}
 
 	csi->is_streaming = !!enable;
diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
index 94d11689b4ac..33ff80da3277 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -707,7 +707,7 @@ static void PHY_StoreTxPowerByRateNew(
 	if (RfPath > ODM_RF_PATH_D)
 		return;
 
-	if (TxNum > ODM_RF_PATH_D)
+	if (TxNum > RF_MAX_TX_NUM)
 		return;
 
 	for (i = 0; i < rateNum; ++i) {
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index 1deb74112ad4..11d9d9155eef 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -2802,10 +2802,10 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	if (dev_info_id == 0x15) {
-		buf_len = 0x3A;
+		buf_len = 0x3C;
 		data_len = 0x3A;
 	} else {
-		buf_len = 0x6A;
+		buf_len = 0x6C;
 		data_len = 0x6A;
 	}
 
@@ -2855,11 +2855,7 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	rtsx_stor_set_xfer_buf(buf, buf_len, srb);
-
-	if (dev_info_id == 0x15)
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x3C);
-	else
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x6C);
+	scsi_set_resid(srb, scsi_bufflen(srb) - buf_len);
 
 	kfree(buf);
 	return STATUS_SUCCESS;
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index a82032c081e8..03229350ea73 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2308,7 +2308,7 @@ static void tb_switch_default_link_ports(struct tb_switch *sw)
 {
 	int i;
 
-	for (i = 1; i <= sw->config.max_port_number; i += 2) {
+	for (i = 1; i <= sw->config.max_port_number; i++) {
 		struct tb_port *port = &sw->ports[i];
 		struct tb_port *subordinate;
 
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index e8c58f9bd263..d6afaae1729a 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1038,7 +1038,7 @@ static const struct tty_operations hvsi_ops = {
 
 static int __init hvsi_init(void)
 {
-	int i;
+	int i, ret;
 
 	hvsi_driver = alloc_tty_driver(hvsi_count);
 	if (!hvsi_driver)
@@ -1069,12 +1069,25 @@ static int __init hvsi_init(void)
 	}
 	hvsi_wait = wait_for_state; /* irqs active now */
 
-	if (tty_register_driver(hvsi_driver))
-		panic("Couldn't register hvsi console driver\n");
+	ret = tty_register_driver(hvsi_driver);
+	if (ret) {
+		pr_err("Couldn't register hvsi console driver\n");
+		goto err_free_irq;
+	}
 
 	printk(KERN_DEBUG "HVSI: registered %i devices\n", hvsi_count);
 
 	return 0;
+err_free_irq:
+	hvsi_wait = poll_for_state;
+	for (i = 0; i < hvsi_count; i++) {
+		struct hvsi_struct *hp = &hvsi_ports[i];
+
+		free_irq(hp->virq, hp);
+	}
+	tty_driver_kref_put(hvsi_driver);
+
+	return ret;
 }
 device_initcall(hvsi_init);
 
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 79418d4beb48..b6c731a267d2 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -617,7 +617,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 	struct uart_port *port = dev_id;
 	struct omap8250_priv *priv = port->private_data;
 	struct uart_8250_port *up = up_to_u8250p(port);
-	unsigned int iir;
+	unsigned int iir, lsr;
 	int ret;
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -628,6 +628,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 #endif
 
 	serial8250_rpm_get(up);
+	lsr = serial_port_in(port, UART_LSR);
 	iir = serial_port_in(port, UART_IIR);
 	ret = serial8250_handle_irq(port, iir);
 
@@ -642,6 +643,24 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 		serial_port_in(port, UART_RX);
 	}
 
+	/* Stop processing interrupts on input overrun */
+	if ((lsr & UART_LSR_OE) && up->overrun_backoff_time_ms > 0) {
+		unsigned long delay;
+
+		up->ier = port->serial_in(port, UART_IER);
+		if (up->ier & (UART_IER_RLSI | UART_IER_RDI)) {
+			port->ops->stop_rx(port);
+		} else {
+			/* Keep restarting the timer until
+			 * the input overrun subsides.
+			 */
+			cancel_delayed_work(&up->overrun_backoff);
+		}
+
+		delay = msecs_to_jiffies(up->overrun_backoff_time_ms);
+		schedule_delayed_work(&up->overrun_backoff, delay);
+	}
+
 	serial8250_rpm_put(up);
 
 	return IRQ_RETVAL(ret);
@@ -1353,6 +1372,10 @@ static int omap8250_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (of_property_read_u32(np, "overrun-throttle-ms",
+				 &up.overrun_backoff_time_ms) != 0)
+		up.overrun_backoff_time_ms = 0;
+
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
 	pdata = of_device_get_match_data(&pdev->dev);
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 1934940b9617..2ad136dcfcc8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -87,7 +87,7 @@ static void moan_device(const char *str, struct pci_dev *dev)
 
 static int
 setup_port(struct serial_private *priv, struct uart_8250_port *port,
-	   int bar, int offset, int regshift)
+	   u8 bar, unsigned int offset, int regshift)
 {
 	struct pci_dev *dev = priv->dev;
 
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 9422284bb3f3..81bafcf77bb2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -122,7 +122,8 @@ static const struct serial8250_config uart_config[] = {
 		.name		= "16C950/954",
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01,
+		.rxtrig_bytes	= {16, 32, 112, 120},
 		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
 		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index bf0e2a4cb0ce..c6f927a76c3b 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -815,7 +815,9 @@ static void neo_parse_isr(struct jsm_board *brd, u32 port)
 		/* Parse any modem signal changes */
 		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
 			"MOD_STAT: sending to parse_modem_sigs\n");
+		spin_lock_irqsave(&ch->uart_port.lock, lock_flags);
 		neo_parse_modem(ch, readb(&ch->ch_neo_uart->msr));
+		spin_unlock_irqrestore(&ch->uart_port.lock, lock_flags);
 	}
 }
 
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 8e42a7682c63..d74cbbbf33c6 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -187,6 +187,7 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 
 static int jsm_tty_open(struct uart_port *port)
 {
+	unsigned long lock_flags;
 	struct jsm_board *brd;
 	struct jsm_channel *channel =
 		container_of(port, struct jsm_channel, uart_port);
@@ -240,6 +241,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_cached_lsr = 0;
 	channel->ch_stops_sent = 0;
 
+	spin_lock_irqsave(&port->lock, lock_flags);
 	termios = &port->state->port.tty->termios;
 	channel->ch_c_cflag	= termios->c_cflag;
 	channel->ch_c_iflag	= termios->c_iflag;
@@ -259,6 +261,7 @@ static int jsm_tty_open(struct uart_port *port)
 	jsm_carrier(channel);
 
 	channel->ch_open_count++;
+	spin_unlock_irqrestore(&port->lock, lock_flags);
 
 	jsm_dbg(OPEN, &channel->ch_bd->pci_dev, "finish\n");
 	return 0;
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 2d5487bf6855..a2e62f372e10 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1760,6 +1760,10 @@ static irqreturn_t sci_br_interrupt(int irq, void *ptr)
 
 	/* Handle BREAKs */
 	sci_handle_breaks(port);
+
+	/* drop invalid character received before break was detected */
+	serial_port_in(port, SCxRDR);
+
 	sci_clear_SCxSR(port, SCxSR_BREAK_CLEAR(port));
 
 	return IRQ_HANDLED;
@@ -1839,7 +1843,8 @@ static irqreturn_t sci_mpxed_interrupt(int irq, void *ptr)
 		ret = sci_er_interrupt(irq, ptr);
 
 	/* Break Interrupt */
-	if ((ssr_status & SCxSR_BRK(port)) && err_enabled)
+	if (s->irqs[SCIx_ERI_IRQ] != s->irqs[SCIx_BRI_IRQ] &&
+	    (ssr_status & SCxSR_BRK(port)) && err_enabled)
 		ret = sci_br_interrupt(irq, ptr);
 
 	/* Overrun Interrupt */
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index e86d13c04bdb..bdc3885c0d49 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -240,15 +240,18 @@ static int ci_ehci_hub_control(
 )
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	unsigned int	ports = HCS_N_PORTS(ehci->hcs_params);
 	u32 __iomem	*status_reg;
-	u32		temp;
+	u32		temp, port_index;
 	unsigned long	flags;
 	int		retval = 0;
 	bool		done = false;
 	struct device *dev = hcd->self.controller;
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
 
-	status_reg = &ehci->regs->port_status[(wIndex & 0xff) - 1];
+	port_index = wIndex & 0xff;
+	port_index -= (port_index > 0);
+	status_reg = &ehci->regs->port_status[port_index];
 
 	spin_lock_irqsave(&ehci->lock, flags);
 
@@ -260,6 +263,11 @@ static int ci_ehci_hub_control(
 	}
 
 	if (typeReq == SetPortFeature && wValue == USB_PORT_FEAT_SUSPEND) {
+		if (!wIndex || wIndex > ports) {
+			retval = -EPIPE;
+			goto done;
+		}
+
 		temp = ehci_readl(ehci, status_reg);
 		if ((temp & PORT_PE) == 0 || (temp & PORT_RESET) != 0) {
 			retval = -EPIPE;
@@ -288,7 +296,7 @@ static int ci_ehci_hub_control(
 			ehci_writel(ehci, temp, status_reg);
 		}
 
-		set_bit((wIndex & 0xff) - 1, &ehci->suspended_ports);
+		set_bit(port_index, &ehci->suspended_ports);
 		goto done;
 	}
 
diff --git a/drivers/usb/dwc3/dwc3-imx8mp.c b/drivers/usb/dwc3/dwc3-imx8mp.c
index 756faa46d33a..d328d20abfbc 100644
--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -152,13 +152,6 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 	}
 	dwc3_imx->irq = irq;
 
-	err = devm_request_threaded_irq(dev, irq, NULL, dwc3_imx8mp_interrupt,
-					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
-	if (err) {
-		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
-		goto disable_clks;
-	}
-
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	err = pm_runtime_get_sync(dev);
@@ -186,6 +179,13 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 	}
 	of_node_put(dwc3_np);
 
+	err = devm_request_threaded_irq(dev, irq, NULL, dwc3_imx8mp_interrupt,
+					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
+	if (err) {
+		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
+		goto depopulate;
+	}
+
 	device_set_wakeup_capable(dev, true);
 	pm_runtime_put(dev);
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 72a9797dbbae..504c1cbc255d 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -482,7 +482,7 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 {
 	unsigned val;
 
-	if (c->MaxPower)
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 		val = c->MaxPower;
 	else
 		val = CONFIG_USB_GADGET_VBUS_DRAW;
@@ -936,7 +936,11 @@ static int set_config(struct usb_composite_dev *cdev,
 	}
 
 	/* when we return, be sure our power usage is valid */
-	power = c->MaxPower ? c->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+		power = c->MaxPower;
+	else
+		power = CONFIG_USB_GADGET_VBUS_DRAW;
+
 	if (gadget->speed < USB_SPEED_SUPER)
 		power = min(power, 500U);
 	else
diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index d1d044d9f859..85a3f6d4b5af 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -492,8 +492,9 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	if (skb && !in) {
-		dev_kfree_skb_any(skb);
+	if (!in) {
+		if (skb)
+			dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index cffdc8d01b2a..8fd27249ad25 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -42,26 +42,25 @@ struct ehci_hcd_mv {
 	int (*set_vbus)(unsigned int vbus);
 };
 
-static void ehci_clock_enable(struct ehci_hcd_mv *ehci_mv)
+static int mv_ehci_enable(struct ehci_hcd_mv *ehci_mv)
 {
-	clk_prepare_enable(ehci_mv->clk);
-}
+	int retval;
 
-static void ehci_clock_disable(struct ehci_hcd_mv *ehci_mv)
-{
-	clk_disable_unprepare(ehci_mv->clk);
-}
+	retval = clk_prepare_enable(ehci_mv->clk);
+	if (retval)
+		return retval;
 
-static int mv_ehci_enable(struct ehci_hcd_mv *ehci_mv)
-{
-	ehci_clock_enable(ehci_mv);
-	return phy_init(ehci_mv->phy);
+	retval = phy_init(ehci_mv->phy);
+	if (retval)
+		clk_disable_unprepare(ehci_mv->clk);
+
+	return retval;
 }
 
 static void mv_ehci_disable(struct ehci_hcd_mv *ehci_mv)
 {
 	phy_exit(ehci_mv->phy);
-	ehci_clock_disable(ehci_mv);
+	clk_disable_unprepare(ehci_mv->clk);
 }
 
 static int mv_ehci_reset(struct usb_hcd *hcd)
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 9c2eda0918e1..670a2fecc9c7 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -2509,11 +2509,6 @@ static unsigned qh_completions(struct fotg210_hcd *fotg210,
 	return count;
 }
 
-/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
-#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
-/* ... and packet size, for any kind of endpoint descriptor */
-#define max_packet(wMaxPacketSize) ((wMaxPacketSize) & 0x07ff)
-
 /* reverse of qh_urb_transaction:  free a list of TDs.
  * used for cleanup after errors, before HC sees an URB's TDs.
  */
@@ -2599,7 +2594,7 @@ static struct list_head *qh_urb_transaction(struct fotg210_hcd *fotg210,
 		token |= (1 /* "in" */ << 8);
 	/* else it's already initted to "out" pid (0 << 8) */
 
-	maxpacket = max_packet(usb_maxpacket(urb->dev, urb->pipe, !is_input));
+	maxpacket = usb_maxpacket(urb->dev, urb->pipe, !is_input);
 
 	/*
 	 * buffer gets wrapped in one or more qtds;
@@ -2713,9 +2708,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 		gfp_t flags)
 {
 	struct fotg210_qh *qh = fotg210_qh_alloc(fotg210, flags);
+	struct usb_host_endpoint *ep;
 	u32 info1 = 0, info2 = 0;
 	int is_input, type;
 	int maxp = 0;
+	int mult;
 	struct usb_tt *tt = urb->dev->tt;
 	struct fotg210_qh_hw *hw;
 
@@ -2730,14 +2727,15 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 
 	is_input = usb_pipein(urb->pipe);
 	type = usb_pipetype(urb->pipe);
-	maxp = usb_maxpacket(urb->dev, urb->pipe, !is_input);
+	ep = usb_pipe_endpoint(urb->dev, urb->pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
+	mult = usb_endpoint_maxp_mult(&ep->desc);
 
 	/* 1024 byte maxpacket is a hardware ceiling.  High bandwidth
 	 * acts like up to 3KB, but is built from smaller packets.
 	 */
-	if (max_packet(maxp) > 1024) {
-		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n",
-				max_packet(maxp));
+	if (maxp > 1024) {
+		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n", maxp);
 		goto done;
 	}
 
@@ -2751,8 +2749,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 	 */
 	if (type == PIPE_INTERRUPT) {
 		qh->usecs = NS_TO_US(usb_calc_bus_time(USB_SPEED_HIGH,
-				is_input, 0,
-				hb_mult(maxp) * max_packet(maxp)));
+				is_input, 0, mult * maxp));
 		qh->start = NO_FRAME;
 
 		if (urb->dev->speed == USB_SPEED_HIGH) {
@@ -2789,7 +2786,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			think_time = tt ? tt->think_time : 0;
 			qh->tt_usecs = NS_TO_US(think_time +
 					usb_calc_bus_time(urb->dev->speed,
-					is_input, 0, max_packet(maxp)));
+					is_input, 0, maxp));
 			qh->period = urb->interval;
 			if (qh->period > fotg210->periodic_size) {
 				qh->period = fotg210->periodic_size;
@@ -2852,11 +2849,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			 * to help them do so.  So now people expect to use
 			 * such nonconformant devices with Linux too; sigh.
 			 */
-			info1 |= max_packet(maxp) << 16;
+			info1 |= maxp << 16;
 			info2 |= (FOTG210_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
-			info1 |= max_packet(maxp) << 16;
-			info2 |= hb_mult(maxp) << 30;
+			info1 |= maxp << 16;
+			info2 |= mult << 30;
 		}
 		break;
 	default:
@@ -3926,6 +3923,7 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	int is_input;
 	long bandwidth;
 	unsigned multi;
+	struct usb_host_endpoint *ep;
 
 	/*
 	 * this might be a "high bandwidth" highspeed endpoint,
@@ -3933,14 +3931,14 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	 */
 	epnum = usb_pipeendpoint(pipe);
 	is_input = usb_pipein(pipe) ? USB_DIR_IN : 0;
-	maxp = usb_maxpacket(dev, pipe, !is_input);
+	ep = usb_pipe_endpoint(dev, pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
 	if (is_input)
 		buf1 = (1 << 11);
 	else
 		buf1 = 0;
 
-	maxp = max_packet(maxp);
-	multi = hb_mult(maxp);
+	multi = usb_endpoint_maxp_mult(&ep->desc);
 	buf1 |= maxp;
 	maxp *= multi;
 
@@ -4461,13 +4459,12 @@ static bool itd_complete(struct fotg210_hcd *fotg210, struct fotg210_itd *itd)
 
 			/* HC need not update length with this error */
 			if (!(t & FOTG210_ISOC_BABBLE)) {
-				desc->actual_length =
-					fotg210_itdlen(urb, desc, t);
+				desc->actual_length = FOTG210_ITD_LENGTH(t);
 				urb->actual_length += desc->actual_length;
 			}
 		} else if (likely((t & FOTG210_ISOC_ACTIVE) == 0)) {
 			desc->status = 0;
-			desc->actual_length = fotg210_itdlen(urb, desc, t);
+			desc->actual_length = FOTG210_ITD_LENGTH(t);
 			urb->actual_length += desc->actual_length;
 		} else {
 			/* URB was too late */
diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index 6cee40ec65b4..67f59517ebad 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -686,11 +686,6 @@ static inline unsigned fotg210_read_frame_index(struct fotg210_hcd *fotg210)
 	return fotg210_readl(fotg210, &fotg210->regs->frame_index);
 }
 
-#define fotg210_itdlen(urb, desc, t) ({			\
-	usb_pipein((urb)->pipe) ?				\
-	(desc)->length - FOTG210_ITD_LENGTH(t) :			\
-	FOTG210_ITD_LENGTH(t);					\
-})
 /*-------------------------------------------------------------------------*/
 
 #endif /* __LINUX_FOTG210_H */
diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index b2058b3bc834..86e5710a5307 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -571,7 +571,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	xhci_mtk_ldos_disable(mtk);
 
 disable_pm:
-	pm_runtime_put_sync_autosuspend(dev);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	return ret;
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9248ce8d09a4..cb21add9d7be 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4705,19 +4705,19 @@ static u16 xhci_calculate_u1_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
-	else
-		timeout_ns = udev->u1_params.sel;
-
 	/* Prevent U1 if service interval is shorter than U1 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u1_params.mel) {
 			dev_dbg(&udev->dev, "Disable U1, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
+	else
+		timeout_ns = udev->u1_params.sel;
+
 	/* The U1 timeout is encoded in 1us intervals.
 	 * Don't return a timeout of zero, because that's USB3_LPM_DISABLED.
 	 */
@@ -4769,19 +4769,19 @@ static u16 xhci_calculate_u2_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
-	else
-		timeout_ns = udev->u2_params.sel;
-
 	/* Prevent U2 if service interval is shorter than U2 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u2_params.mel) {
 			dev_dbg(&udev->dev, "Disable U2, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
+	else
+		timeout_ns = udev->u2_params.sel;
+
 	/* The U2 timeout is encoded in 256us intervals */
 	timeout_ns = DIV_ROUND_UP_ULL(timeout_ns, 256 * 1000);
 	/* If the necessary timeout value is bigger than what we can set in the
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 5892f3ce0cdc..ce9fc46c9266 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -890,23 +890,22 @@ static int dsps_probe(struct platform_device *pdev)
 	if (!glue->usbss_base)
 		return -ENXIO;
 
-	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
-		ret = dsps_setup_optional_vbus_irq(pdev, glue);
-		if (ret)
-			goto err_iounmap;
-	}
-
 	platform_set_drvdata(pdev, glue);
 	pm_runtime_enable(&pdev->dev);
 	ret = dsps_create_musb_pdev(glue, pdev);
 	if (ret)
 		goto err;
 
+	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
+		ret = dsps_setup_optional_vbus_irq(pdev, glue);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
 	pm_runtime_disable(&pdev->dev);
-err_iounmap:
 	iounmap(glue->usbss_base);
 	return ret;
 }
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 4ba6bcdaa8e9..b07b2925ff78 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -455,8 +455,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			vhci_hcd->port_status[rhport] &= ~(1 << USB_PORT_FEAT_RESET);
 			vhci_hcd->re_timeout = 0;
 
+			/*
+			 * A few drivers do usb reset during probe when
+			 * the device could be in VDEV_ST_USED state
+			 */
 			if (vhci_hcd->vdev[rhport].ud.status ==
-			    VDEV_ST_NOTASSIGNED) {
+				VDEV_ST_NOTASSIGNED ||
+			    vhci_hcd->vdev[rhport].ud.status ==
+				VDEV_ST_USED) {
 				usbip_dbg_vhci_rh(
 					" enable rhport %d (status %u)\n",
 					rhport,
@@ -957,8 +963,32 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		struct urb *urb;
+
+		/* give back urb of unsent unlink request */
 		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		usb_hcd_unlink_urb_from_ep(hcd, urb);
+
 		list_del(&unlink->list);
+
+		spin_unlock(&vdev->priv_lock);
+		spin_unlock_irqrestore(&vhci->lock, flags);
+
+		usb_hcd_giveback_urb(hcd, urb, urb->status);
+
+		spin_lock_irqsave(&vhci->lock, flags);
+		spin_lock(&vdev->priv_lock);
+
 		kfree(unlink);
 	}
 
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 67d0bf4efa16..e44bf736e2b2 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -29,7 +29,7 @@ menuconfig VFIO
 
 	  If you don't know what to do here, say N.
 
-menuconfig VFIO_NOIOMMU
+config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	depends on VFIO
 	help
diff --git a/drivers/video/fbdev/asiliantfb.c b/drivers/video/fbdev/asiliantfb.c
index 3e006da47752..84c56f525889 100644
--- a/drivers/video/fbdev/asiliantfb.c
+++ b/drivers/video/fbdev/asiliantfb.c
@@ -227,6 +227,9 @@ static int asiliantfb_check_var(struct fb_var_screeninfo *var,
 {
 	unsigned long Ftarget, ratio, remainder;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ratio = 1000000 / var->pixclock;
 	remainder = 1000000 % var->pixclock;
 	Ftarget = 1000000 * ratio + (1000000 * remainder) / var->pixclock;
diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 8fbde92ae8b9..25801e8e3f74 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -372,6 +372,11 @@ static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight
 		/* probably haven't called CreateOverlay yet */
 		return -EINVAL;
 
+	if (ulWidth == 0 || ulWidth == 0xffffffff ||
+	    ulHeight == 0 || ulHeight == 0xffffffff ||
+	    (x < 2 && ulWidth + 2 == 0))
+		return -EINVAL;
+
 	/* Stop Ramdac Output */
 	DisableRamdacOutput(deviceInfo.pSTGReg);
 
@@ -394,6 +399,9 @@ static int kyrofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct kyrofb_info *par = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->bits_per_pixel != 16 && var->bits_per_pixel != 32) {
 		printk(KERN_WARNING "kyrofb: depth not supported: %u\n", var->bits_per_pixel);
 		return -EINVAL;
diff --git a/drivers/video/fbdev/riva/fbdev.c b/drivers/video/fbdev/riva/fbdev.c
index 55554b0433cb..84d5e23ad7d3 100644
--- a/drivers/video/fbdev/riva/fbdev.c
+++ b/drivers/video/fbdev/riva/fbdev.c
@@ -1084,6 +1084,9 @@ static int rivafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	int mode_valid = 0;
 	
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 1 ... 8:
 		var->red.offset = var->green.offset = var->blue.offset = 0;
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index cf53713f8aa0..a29b5ffca99b 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1550,7 +1550,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 				bg->start, div64_u64(bg->used * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret)
+		if (ret && ret != -EAGAIN)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8d386a5587ee..51395cfb7574 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3329,6 +3329,30 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
+	/*
+	 * Flag our filesystem as having big metadata blocks if they are bigger
+	 * than the page size.
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
+	/* Set up fs_info before parsing mount options */
+	nodesize = btrfs_super_nodesize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = sectorsize;
+	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
+
+	fs_info->nodesize = nodesize;
+	fs_info->sectorsize = sectorsize;
+	fs_info->sectorsize_bits = ilog2(sectorsize);
+	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
+	fs_info->stripesize = stripesize;
+
 	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
 	if (ret) {
 		err = ret;
@@ -3355,30 +3379,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		btrfs_info(fs_info, "has skinny extents");
 
-	/*
-	 * flag our filesystem as having big metadata blocks if
-	 * they are bigger than the page size
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
-	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
-	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
-
-	/* Cache block sizes */
-	fs_info->nodesize = nodesize;
-	fs_info->sectorsize = sectorsize;
-	fs_info->sectorsize_bits = ilog2(sectorsize);
-	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
-	fs_info->stripesize = stripesize;
-
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4806295116d8..c3510c8fdaf8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2652,8 +2652,11 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
 		 * btrfs_pin_extent_for_log_replay() when replaying the log.
 		 * Advance the pointer not to overwrite the tree-log nodes.
 		 */
-		if (block_group->alloc_offset < offset + bytes)
-			block_group->alloc_offset = offset + bytes;
+		if (block_group->start + block_group->alloc_offset <
+		    offset + bytes) {
+			block_group->alloc_offset =
+				offset + bytes - block_group->start;
+		}
 		return 0;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6328deb27d12..044300db5e22 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1248,11 +1248,6 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
-	/* atomic_sub_return implies a barrier */
-	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
-	    5 * SZ_1M)
-		cond_wake_up_nomb(&fs_info->async_submit_wait);
-
 	/*
 	 * ->inode could be NULL if async_chunk_start has failed to compress,
 	 * in which case we don't have anything to submit, yet we need to
@@ -1261,6 +1256,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	 */
 	if (async_chunk->inode)
 		submit_compressed_extents(async_chunk);
+
+	/* atomic_sub_return implies a barrier */
+	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
+	    5 * SZ_1M)
+		cond_wake_up_nomb(&fs_info->async_submit_wait);
 }
 
 static noinline void async_cow_free(struct btrfs_work *work)
@@ -5064,15 +5064,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct btrfs_inode *inode,
 	int ret;
 
 	/*
-	 * Still need to make sure the inode looks like it's been updated so
-	 * that any holes get logged if we fsync.
+	 * If NO_HOLES is enabled, we don't need to do anything.
+	 * Later, up in the call chain, either btrfs_set_inode_last_sub_trans()
+	 * or btrfs_update_inode() will be called, which guarantee that the next
+	 * fsync will know this inode was changed and needs to be logged.
 	 */
-	if (btrfs_fs_incompat(fs_info, NO_HOLES)) {
-		inode->last_trans = fs_info->generation;
-		inode->last_sub_trans = root->log_transid;
-		inode->last_log_commit = root->last_log_commit;
+	if (btrfs_fs_incompat(fs_info, NO_HOLES))
 		return 0;
-	}
 
 	/*
 	 * 1 - for the one we're dropping
@@ -9774,10 +9772,6 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 					 &work->work);
 		} else {
 			ret = sync_inode(inode, wbc);
-			if (!ret &&
-			    test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-				     &BTRFS_I(inode)->runtime_flags))
-				ret = sync_inode(inode, wbc);
 			btrfs_add_delayed_iput(inode);
 			if (ret || wbc->nr_to_write <= 0)
 				goto out;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 6c413bb451a3..8326f4bee89f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -917,6 +917,7 @@ static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pos,
 				u64 len)
 {
 	struct inode *inode = ordered->inode;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	u64 file_offset = ordered->file_offset + pos;
 	u64 disk_bytenr = ordered->disk_bytenr + pos;
 	u64 num_bytes = len;
@@ -934,6 +935,13 @@ static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pos,
 	else
 		type = __ffs(flags_masked);
 
+	/*
+	 * The splitting extent is already counted and will be added again
+	 * in btrfs_add_ordered_extent_*(). Subtract num_bytes to avoid
+	 * double counting.
+	 */
+	percpu_counter_add_batch(&fs_info->ordered_bytes, -num_bytes,
+				 fs_info->delalloc_batch);
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered->flags)) {
 		WARN_ON_ONCE(1);
 		ret = btrfs_add_ordered_extent_compress(BTRFS_I(inode),
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 2dc674b7c3b1..088220539788 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -539,9 +539,49 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 	while ((delalloc_bytes || ordered_bytes) && loops < 3) {
 		u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
 		long nr_pages = min_t(u64, temp, LONG_MAX);
+		int async_pages;
 
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
 
+		/*
+		 * We need to make sure any outstanding async pages are now
+		 * processed before we continue.  This is because things like
+		 * sync_inode() try to be smart and skip writing if the inode is
+		 * marked clean.  We don't use filemap_fwrite for flushing
+		 * because we want to control how many pages we write out at a
+		 * time, thus this is the only safe way to make sure we've
+		 * waited for outstanding compressed workers to have started
+		 * their jobs and thus have ordered extents set up properly.
+		 *
+		 * This exists because we do not want to wait for each
+		 * individual inode to finish its async work, we simply want to
+		 * start the IO on everybody, and then come back here and wait
+		 * for all of the async work to catch up.  Once we're done with
+		 * that we know we'll have ordered extents for everything and we
+		 * can decide if we wait for that or not.
+		 *
+		 * If we choose to replace this in the future, make absolutely
+		 * sure that the proper waiting is being done in the async case,
+		 * as there have been bugs in that area before.
+		 */
+		async_pages = atomic_read(&fs_info->async_delalloc_pages);
+		if (!async_pages)
+			goto skip_async;
+
+		/*
+		 * We don't want to wait forever, if we wrote less pages in this
+		 * loop than we have outstanding, only wait for that number of
+		 * pages, otherwise we can wait for all async pages to finish
+		 * before continuing.
+		 */
+		if (async_pages > nr_pages)
+			async_pages -= nr_pages;
+		else
+			async_pages = 0;
+		wait_event(fs_info->async_submit_wait,
+			   atomic_read(&fs_info->async_delalloc_pages) <=
+			   async_pages);
+skip_async:
 		loops++;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, 0, (u64)-1);
@@ -793,7 +833,7 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 				    struct btrfs_space_info *space_info)
 {
 	u64 ordered, delalloc;
-	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
+	u64 thresh = div_factor_fine(space_info->total_bytes, 90);
 	u64 used;
 
 	/* If we're just plain full then async reclaim just slows us down. */
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 24555cc1f42d..9e9ab41df7da 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -753,7 +753,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			 */
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
-			if (ret == 0) {
+			if (ret < 0) {
+				goto out;
+			} else if (ret == 0) {
 				btrfs_init_generic_ref(&ref,
 						BTRFS_ADD_DELAYED_REF,
 						ins.objectid, ins.offset, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7d5875824be7..dc1f31cf3d4a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1130,6 +1130,9 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 		fs_devices->rw_devices--;
 	}
 
+	if (device->devid == BTRFS_DEV_REPLACE_DEVID)
+		clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
+
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		fs_devices->missing_devices--;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 805c656a2e72..f602e51c0006 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1756,6 +1756,9 @@ struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 	struct ceph_cap_flush *cf;
 
 	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	if (!cf)
+		return NULL;
+
 	cf->is_capsnap = false;
 	return cf;
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index a92a1fb7cb52..4c22f73b3123 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -889,7 +889,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f795049e63d5..6c208108d69c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -444,7 +444,7 @@ static int f2fs_set_meta_page_dirty(struct page *page)
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
 		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_META);
-		f2fs_set_page_private(page, 0);
+		set_page_private_reference(page);
 		return 1;
 	}
 	return 0;
@@ -1018,7 +1018,7 @@ void f2fs_update_dirty_page(struct inode *inode, struct page *page)
 	inode_inc_dirty_pages(inode);
 	spin_unlock(&sbi->inode_lock[type]);
 
-	f2fs_set_page_private(page, 0);
+	set_page_private_reference(page);
 }
 
 void f2fs_remove_dirty_inode(struct inode *inode)
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 925a5ca3744a..14e6a78503f1 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -12,9 +12,11 @@
 #include <linux/lzo.h>
 #include <linux/lz4.h>
 #include <linux/zstd.h>
+#include <linux/pagevec.h>
 
 #include "f2fs.h"
 #include "node.h"
+#include "segment.h"
 #include <trace/events/f2fs.h>
 
 static struct kmem_cache *cic_entry_slab;
@@ -74,7 +76,7 @@ bool f2fs_is_compressed_page(struct page *page)
 		return false;
 	if (!page_private(page))
 		return false;
-	if (IS_ATOMIC_WRITTEN_PAGE(page) || IS_DUMMY_WRITTEN_PAGE(page))
+	if (page_private_nonpointer(page))
 		return false;
 
 	f2fs_bug_on(F2FS_M_SB(page->mapping),
@@ -85,8 +87,7 @@ bool f2fs_is_compressed_page(struct page *page)
 static void f2fs_set_compressed_page(struct page *page,
 		struct inode *inode, pgoff_t index, void *data)
 {
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)data);
+	attach_page_private(page, (void *)data);
 
 	/* i_crypto_info and iv index */
 	page->index = index;
@@ -589,8 +590,7 @@ static void f2fs_compress_free_page(struct page *page)
 {
 	if (!page)
 		return;
-	set_page_private(page, (unsigned long)NULL);
-	ClearPagePrivate(page);
+	detach_page_private(page);
 	page->mapping = NULL;
 	unlock_page(page);
 	mempool_free(page, compress_page_pool);
@@ -738,7 +738,7 @@ static int f2fs_compress_pages(struct compress_ctx *cc)
 	return ret;
 }
 
-static void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
+void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
 	struct f2fs_inode_info *fi = F2FS_I(dic->inode);
@@ -837,7 +837,8 @@ static void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
  * page being waited on in the cluster, and if so, it decompresses the cluster
  * (or in the case of a failure, cleans up without actually decompressing).
  */
-void f2fs_end_read_compressed_page(struct page *page, bool failed)
+void f2fs_end_read_compressed_page(struct page *page, bool failed,
+						block_t blkaddr)
 {
 	struct decompress_io_ctx *dic =
 			(struct decompress_io_ctx *)page_private(page);
@@ -847,6 +848,9 @@ void f2fs_end_read_compressed_page(struct page *page, bool failed)
 
 	if (failed)
 		WRITE_ONCE(dic->failed, true);
+	else if (blkaddr)
+		f2fs_cache_compressed_page(sbi, page,
+					dic->inode->i_ino, blkaddr);
 
 	if (atomic_dec_and_test(&dic->remaining_pages))
 		f2fs_decompress_cluster(dic);
@@ -1359,12 +1363,6 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 	for (--i; i >= 0; i--)
 		fscrypt_finalize_bounce_page(&cc->cpages[i]);
-	for (i = 0; i < cc->nr_cpages; i++) {
-		if (!cc->cpages[i])
-			continue;
-		f2fs_compress_free_page(cc->cpages[i]);
-		cc->cpages[i] = NULL;
-	}
 out_put_cic:
 	kmem_cache_free(cic_entry_slab, cic);
 out_put_dnode:
@@ -1375,6 +1373,12 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	else
 		f2fs_unlock_op(sbi);
 out_free:
+	for (i = 0; i < cc->nr_cpages; i++) {
+		if (!cc->cpages[i])
+			continue;
+		f2fs_compress_free_page(cc->cpages[i]);
+		cc->cpages[i] = NULL;
+	}
 	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
 	return -EAGAIN;
@@ -1399,7 +1403,7 @@ void f2fs_compress_write_end_io(struct bio *bio, struct page *page)
 
 	for (i = 0; i < cic->nr_rpages; i++) {
 		WARN_ON(!cic->rpages[i]);
-		clear_cold_data(cic->rpages[i]);
+		clear_page_private_gcing(cic->rpages[i]);
 		end_page_writeback(cic->rpages[i]);
 	}
 
@@ -1685,6 +1689,164 @@ void f2fs_put_page_dic(struct page *page)
 	f2fs_put_dic(dic);
 }
 
+const struct address_space_operations f2fs_compress_aops = {
+	.releasepage = f2fs_release_page,
+	.invalidatepage = f2fs_invalidate_page,
+};
+
+struct address_space *COMPRESS_MAPPING(struct f2fs_sb_info *sbi)
+{
+	return sbi->compress_inode->i_mapping;
+}
+
+void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi, block_t blkaddr)
+{
+	if (!sbi->compress_inode)
+		return;
+	invalidate_mapping_pages(COMPRESS_MAPPING(sbi), blkaddr, blkaddr);
+}
+
+void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t ino, block_t blkaddr)
+{
+	struct page *cpage;
+	int ret;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return;
+
+	if (!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE_READ))
+		return;
+
+	if (!f2fs_available_free_memory(sbi, COMPRESS_PAGE))
+		return;
+
+	cpage = find_get_page(COMPRESS_MAPPING(sbi), blkaddr);
+	if (cpage) {
+		f2fs_put_page(cpage, 0);
+		return;
+	}
+
+	cpage = alloc_page(__GFP_NOWARN | __GFP_IO);
+	if (!cpage)
+		return;
+
+	ret = add_to_page_cache_lru(cpage, COMPRESS_MAPPING(sbi),
+						blkaddr, GFP_NOFS);
+	if (ret) {
+		f2fs_put_page(cpage, 0);
+		return;
+	}
+
+	set_page_private_data(cpage, ino);
+
+	if (!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE_READ))
+		goto out;
+
+	memcpy(page_address(cpage), page_address(page), PAGE_SIZE);
+	SetPageUptodate(cpage);
+out:
+	f2fs_put_page(cpage, 1);
+}
+
+bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+								block_t blkaddr)
+{
+	struct page *cpage;
+	bool hitted = false;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return false;
+
+	cpage = f2fs_pagecache_get_page(COMPRESS_MAPPING(sbi),
+				blkaddr, FGP_LOCK | FGP_NOWAIT, GFP_NOFS);
+	if (cpage) {
+		if (PageUptodate(cpage)) {
+			atomic_inc(&sbi->compress_page_hit);
+			memcpy(page_address(page),
+				page_address(cpage), PAGE_SIZE);
+			hitted = true;
+		}
+		f2fs_put_page(cpage, 1);
+	}
+
+	return hitted;
+}
+
+void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino)
+{
+	struct address_space *mapping = sbi->compress_inode->i_mapping;
+	struct pagevec pvec;
+	pgoff_t index = 0;
+	pgoff_t end = MAX_BLKADDR(sbi);
+
+	if (!mapping->nrpages)
+		return;
+
+	pagevec_init(&pvec);
+
+	do {
+		unsigned int nr_pages;
+		int i;
+
+		nr_pages = pagevec_lookup_range(&pvec, mapping,
+						&index, end - 1);
+		if (!nr_pages)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			if (page->index > end)
+				break;
+
+			lock_page(page);
+			if (page->mapping != mapping) {
+				unlock_page(page);
+				continue;
+			}
+
+			if (ino != get_page_private_data(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			generic_error_remove_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	} while (index < end);
+}
+
+int f2fs_init_compress_inode(struct f2fs_sb_info *sbi)
+{
+	struct inode *inode;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return 0;
+
+	inode = f2fs_iget(sbi->sb, F2FS_COMPRESS_INO(sbi));
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	sbi->compress_inode = inode;
+
+	sbi->compress_percent = COMPRESS_PERCENT;
+	sbi->compress_watermark = COMPRESS_WATERMARK;
+
+	atomic_set(&sbi->compress_page_hit, 0);
+
+	return 0;
+}
+
+void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi)
+{
+	if (!sbi->compress_inode)
+		return;
+	iput(sbi->compress_inode);
+	sbi->compress_inode = NULL;
+}
+
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi)
 {
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index e2d0c7d9673e..198e5ad7c98b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -58,18 +58,19 @@ static bool __is_cp_guaranteed(struct page *page)
 	if (!mapping)
 		return false;
 
-	if (f2fs_is_compressed_page(page))
-		return false;
-
 	inode = mapping->host;
 	sbi = F2FS_I_SB(inode);
 
 	if (inode->i_ino == F2FS_META_INO(sbi) ||
 			inode->i_ino == F2FS_NODE_INO(sbi) ||
-			S_ISDIR(inode->i_mode) ||
-			(S_ISREG(inode->i_mode) &&
+			S_ISDIR(inode->i_mode))
+		return true;
+
+	if (f2fs_is_compressed_page(page))
+		return false;
+	if ((S_ISREG(inode->i_mode) &&
 			(f2fs_is_atomic_file(inode) || IS_NOQUOTA(inode))) ||
-			is_cold_data(page))
+			page_private_gcing(page))
 		return true;
 	return false;
 }
@@ -131,7 +132,7 @@ static void f2fs_finish_read_bio(struct bio *bio)
 
 		if (f2fs_is_compressed_page(page)) {
 			if (bio->bi_status)
-				f2fs_end_read_compressed_page(page, true);
+				f2fs_end_read_compressed_page(page, true, 0);
 			f2fs_put_page_dic(page);
 			continue;
 		}
@@ -227,15 +228,19 @@ static void f2fs_handle_step_decompress(struct bio_post_read_ctx *ctx)
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 	bool all_compressed = true;
+	block_t blkaddr = SECTOR_TO_BLOCK(ctx->bio->bi_iter.bi_sector);
 
 	bio_for_each_segment_all(bv, ctx->bio, iter_all) {
 		struct page *page = bv->bv_page;
 
 		/* PG_error was set if decryption failed. */
 		if (f2fs_is_compressed_page(page))
-			f2fs_end_read_compressed_page(page, PageError(page));
+			f2fs_end_read_compressed_page(page, PageError(page),
+						blkaddr);
 		else
 			all_compressed = false;
+
+		blkaddr++;
 	}
 
 	/*
@@ -299,9 +304,8 @@ static void f2fs_write_end_io(struct bio *bio)
 		struct page *page = bvec->bv_page;
 		enum count_type type = WB_DATA_TYPE(page);
 
-		if (IS_DUMMY_WRITTEN_PAGE(page)) {
-			set_page_private(page, (unsigned long)NULL);
-			ClearPagePrivate(page);
+		if (page_private_dummy(page)) {
+			clear_page_private_dummy(page);
 			unlock_page(page);
 			mempool_free(page, sbi->write_io_dummy);
 
@@ -331,7 +335,7 @@ static void f2fs_write_end_io(struct bio *bio)
 		dec_page_count(sbi, type);
 		if (f2fs_in_warm_node_list(sbi, page))
 			f2fs_del_fsync_node_entry(sbi, page);
-		clear_cold_data(page);
+		clear_page_private_gcing(page);
 		end_page_writeback(page);
 	}
 	if (!get_pages(sbi, F2FS_WB_CP_DATA) &&
@@ -455,10 +459,11 @@ static inline void __submit_bio(struct f2fs_sb_info *sbi,
 					      GFP_NOIO | __GFP_NOFAIL);
 			f2fs_bug_on(sbi, !page);
 
-			zero_user_segment(page, 0, PAGE_SIZE);
-			SetPagePrivate(page);
-			set_page_private(page, DUMMY_WRITTEN_PAGE);
 			lock_page(page);
+
+			zero_user_segment(page, 0, PAGE_SIZE);
+			set_page_private_dummy(page);
+
 			if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE)
 				f2fs_bug_on(sbi, 1);
 		}
@@ -1351,9 +1356,11 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	old_blkaddr = dn->data_blkaddr;
 	f2fs_allocate_data_block(sbi, NULL, old_blkaddr, &dn->data_blkaddr,
 				&sum, seg_type, NULL);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
+	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(sbi),
 					old_blkaddr, old_blkaddr);
+		f2fs_invalidate_compress_page(sbi, old_blkaddr);
+	}
 	f2fs_update_data_blkaddr(dn, dn->data_blkaddr);
 
 	/*
@@ -1483,7 +1490,21 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 	if (err) {
 		if (flag == F2FS_GET_BLOCK_BMAP)
 			map->m_pblk = 0;
+
 		if (err == -ENOENT) {
+			/*
+			 * There is one exceptional case that read_node_page()
+			 * may return -ENOENT due to filesystem has been
+			 * shutdown or cp_error, so force to convert error
+			 * number to EIO for such case.
+			 */
+			if (map->m_may_create &&
+				(is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN) ||
+				f2fs_cp_error(sbi))) {
+				err = -EIO;
+				goto unlock_out;
+			}
+
 			err = 0;
 			if (map->m_next_pgofs)
 				*map->m_next_pgofs =
@@ -2130,6 +2151,8 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 			continue;
 		}
 		unlock_page(page);
+		if (for_write)
+			put_page(page);
 		cc->rpages[i] = NULL;
 		cc->nr_rpages--;
 	}
@@ -2173,7 +2196,7 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 		goto out_put_dnode;
 	}
 
-	for (i = 0; i < dic->nr_cpages; i++) {
+	for (i = 0; i < cc->nr_cpages; i++) {
 		struct page *page = dic->cpages[i];
 		block_t blkaddr;
 		struct bio_post_read_ctx *ctx;
@@ -2181,6 +2204,14 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 		blkaddr = data_blkaddr(dn.inode, dn.node_page,
 						dn.ofs_in_node + i + 1);
 
+		f2fs_wait_on_block_writeback(inode, blkaddr);
+
+		if (f2fs_load_compressed_page(sbi, page, blkaddr)) {
+			if (atomic_dec_and_test(&dic->remaining_pages))
+				f2fs_decompress_cluster(dic);
+			continue;
+		}
+
 		if (bio && (!page_is_mergeable(sbi, bio,
 					*last_block_in_bio, blkaddr) ||
 		    !f2fs_crypt_mergeable_bio(bio, inode, page->index, NULL))) {
@@ -2202,8 +2233,6 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 			}
 		}
 
-		f2fs_wait_on_block_writeback(inode, blkaddr);
-
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
 			goto submit_and_realloc;
 
@@ -2482,9 +2511,9 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	if (f2fs_is_atomic_file(inode))
 		return true;
 	if (fio) {
-		if (is_cold_data(fio->page))
+		if (page_private_gcing(fio->page))
 			return true;
-		if (IS_ATOMIC_WRITTEN_PAGE(fio->page))
+		if (page_private_dummy(fio->page))
 			return true;
 		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
 			f2fs_is_checkpointed_data(sbi, fio->old_blkaddr)))
@@ -2540,7 +2569,7 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 	/* This page is already truncated */
 	if (fio->old_blkaddr == NULL_ADDR) {
 		ClearPageUptodate(page);
-		clear_cold_data(page);
+		clear_page_private_gcing(page);
 		goto out_writepage;
 	}
 got_it:
@@ -2750,7 +2779,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	inode_dec_dirty_pages(inode);
 	if (err) {
 		ClearPageUptodate(page);
-		clear_cold_data(page);
+		clear_page_private_gcing(page);
 	}
 
 	if (wbc->for_reclaim) {
@@ -3224,7 +3253,7 @@ static int prepare_write_begin(struct f2fs_sb_info *sbi,
 			f2fs_do_read_inline_data(page, ipage);
 			set_inode_flag(inode, FI_DATA_EXIST);
 			if (inode->i_nlink)
-				set_inline_node(ipage);
+				set_page_private_inline(ipage);
 		} else {
 			err = f2fs_convert_inline_page(&dn, page);
 			if (err)
@@ -3615,12 +3644,20 @@ void f2fs_invalidate_page(struct page *page, unsigned int offset,
 		}
 	}
 
-	clear_cold_data(page);
+	clear_page_private_gcing(page);
 
-	if (IS_ATOMIC_WRITTEN_PAGE(page))
+	if (test_opt(sbi, COMPRESS_CACHE)) {
+		if (f2fs_compressed_file(inode))
+			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
+			clear_page_private_data(page);
+	}
+
+	if (page_private_atomic(page))
 		return f2fs_drop_inmem_page(inode, page);
 
-	f2fs_clear_page_private(page);
+	detach_page_private(page);
+	set_page_private(page, 0);
 }
 
 int f2fs_release_page(struct page *page, gfp_t wait)
@@ -3630,11 +3667,23 @@ int f2fs_release_page(struct page *page, gfp_t wait)
 		return 0;
 
 	/* This is atomic written page, keep Private */
-	if (IS_ATOMIC_WRITTEN_PAGE(page))
+	if (page_private_atomic(page))
 		return 0;
 
-	clear_cold_data(page);
-	f2fs_clear_page_private(page);
+	if (test_opt(F2FS_P_SB(page), COMPRESS_CACHE)) {
+		struct f2fs_sb_info *sbi = F2FS_P_SB(page);
+		struct inode *inode = page->mapping->host;
+
+		if (f2fs_compressed_file(inode))
+			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
+			clear_page_private_data(page);
+	}
+
+	clear_page_private_gcing(page);
+
+	detach_page_private(page);
+	set_page_private(page, 0);
 	return 1;
 }
 
@@ -3650,7 +3699,7 @@ static int f2fs_set_data_page_dirty(struct page *page)
 		return __set_page_dirty_nobuffers(page);
 
 	if (f2fs_is_atomic_file(inode) && !f2fs_is_commit_atomic_write(inode)) {
-		if (!IS_ATOMIC_WRITTEN_PAGE(page)) {
+		if (!page_private_atomic(page)) {
 			f2fs_register_inmem_page(inode, page);
 			return 1;
 		}
@@ -3742,7 +3791,7 @@ int f2fs_migrate_page(struct address_space *mapping,
 {
 	int rc, extra_count;
 	struct f2fs_inode_info *fi = F2FS_I(mapping->host);
-	bool atomic_written = IS_ATOMIC_WRITTEN_PAGE(page);
+	bool atomic_written = page_private_atomic(page);
 
 	BUG_ON(PageWriteback(page));
 
@@ -3778,8 +3827,13 @@ int f2fs_migrate_page(struct address_space *mapping,
 	}
 
 	if (PagePrivate(page)) {
-		f2fs_set_page_private(newpage, page_private(page));
-		f2fs_clear_page_private(page);
+		set_page_private(newpage, page_private(page));
+		SetPagePrivate(newpage);
+		get_page(newpage);
+
+		set_page_private(page, 0);
+		ClearPagePrivate(page);
+		put_page(page);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index c03949a7ccff..833325038ef3 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -152,6 +152,12 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 		si->node_pages = NODE_MAPPING(sbi)->nrpages;
 	if (sbi->meta_inode)
 		si->meta_pages = META_MAPPING(sbi)->nrpages;
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (sbi->compress_inode) {
+		si->compress_pages = COMPRESS_MAPPING(sbi)->nrpages;
+		si->compress_page_hit = atomic_read(&sbi->compress_page_hit);
+	}
+#endif
 	si->nats = NM_I(sbi)->nat_cnt[TOTAL_NAT];
 	si->dirty_nats = NM_I(sbi)->nat_cnt[DIRTY_NAT];
 	si->sits = MAIN_SEGS(sbi);
@@ -309,6 +315,12 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 
 		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
 	}
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (sbi->compress_inode) {
+		unsigned npages = COMPRESS_MAPPING(sbi)->nrpages;
+		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
+	}
+#endif
 }
 
 static int stat_show(struct seq_file *s, void *v)
@@ -476,6 +488,7 @@ static int stat_show(struct seq_file *s, void *v)
 			"volatile IO: %4d (Max. %4d)\n",
 			   si->inmem_pages, si->aw_cnt, si->max_aw_cnt,
 			   si->vw_cnt, si->max_vw_cnt);
+		seq_printf(s, "  - compress: %4d, hit:%8d\n", si->compress_pages, si->compress_page_hit);
 		seq_printf(s, "  - nodes: %4d in %4d\n",
 			   si->ndirty_node, si->node_pages);
 		seq_printf(s, "  - dents: %4d in dirs:%4d (%4d)\n",
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index dc7ce79672b8..c821015c0a46 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -929,11 +929,15 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 		!f2fs_truncate_hole(dir, page->index, page->index + 1)) {
 		f2fs_clear_page_cache_dirty_tag(page);
 		clear_page_dirty_for_io(page);
-		f2fs_clear_page_private(page);
 		ClearPageUptodate(page);
-		clear_cold_data(page);
+
+		clear_page_private_gcing(page);
+
 		inode_dec_dirty_pages(dir);
 		f2fs_remove_dirty_inode(dir);
+
+		detach_page_private(page);
+		set_page_private(page, 0);
 	}
 	f2fs_put_page(page, 1);
 
@@ -991,6 +995,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(d->inode);
 	struct blk_plug plug;
 	bool readdir_ra = sbi->readdir_ra == 1;
+	bool found_valid_dirent = false;
 	int err = 0;
 
 	bit_pos = ((unsigned long)ctx->pos % d->max);
@@ -1005,13 +1010,15 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 
 		de = &d->dentry[bit_pos];
 		if (de->name_len == 0) {
+			if (found_valid_dirent || !bit_pos) {
+				printk_ratelimited(
+					"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
+					KERN_WARNING, sbi->sb->s_id,
+					le32_to_cpu(de->ino));
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
+			}
 			bit_pos++;
 			ctx->pos = start_pos + bit_pos;
-			printk_ratelimited(
-				"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
-				KERN_WARNING, sbi->sb->s_id,
-				le32_to_cpu(de->ino));
-			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			continue;
 		}
 
@@ -1054,6 +1061,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 			f2fs_ra_node_page(sbi, le32_to_cpu(de->ino));
 
 		ctx->pos = start_pos + bit_pos;
+		found_valid_dirent = true;
 	}
 out:
 	if (readdir_ra)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a5de48e768d7..395f18e90a8f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -43,6 +43,7 @@ enum {
 	FAULT_KVMALLOC,
 	FAULT_PAGE_ALLOC,
 	FAULT_PAGE_GET,
+	FAULT_ALLOC_BIO,	/* it's obsolete due to bio_alloc() will never fail */
 	FAULT_ALLOC_NID,
 	FAULT_ORPHAN,
 	FAULT_BLOCK,
@@ -98,6 +99,7 @@ extern const char *f2fs_fault_name[FAULT_MAX];
 #define F2FS_MOUNT_ATGC			0x08000000
 #define F2FS_MOUNT_MERGE_CHECKPOINT	0x10000000
 #define	F2FS_MOUNT_GC_MERGE		0x20000000
+#define F2FS_MOUNT_COMPRESS_CACHE	0x40000000
 
 #define F2FS_OPTION(sbi)	((sbi)->mount_opt)
 #define clear_opt(sbi, option)	(F2FS_OPTION(sbi).opt &= ~F2FS_MOUNT_##option)
@@ -1291,17 +1293,116 @@ enum {
 				 */
 };
 
+static inline int f2fs_test_bit(unsigned int nr, char *addr);
+static inline void f2fs_set_bit(unsigned int nr, char *addr);
+static inline void f2fs_clear_bit(unsigned int nr, char *addr);
+
 /*
- * this value is set in page as a private data which indicate that
- * the page is atomically written, and it is in inmem_pages list.
+ * Layout of f2fs page.private:
+ *
+ * Layout A: lowest bit should be 1
+ * | bit0 = 1 | bit1 | bit2 | ... | bit MAX | private data .... |
+ * bit 0	PAGE_PRIVATE_NOT_POINTER
+ * bit 1	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 2	PAGE_PRIVATE_DUMMY_WRITE
+ * bit 3	PAGE_PRIVATE_ONGOING_MIGRATION
+ * bit 4	PAGE_PRIVATE_INLINE_INODE
+ * bit 5	PAGE_PRIVATE_REF_RESOURCE
+ * bit 6-	f2fs private data
+ *
+ * Layout B: lowest bit should be 0
+ * page.private is a wrapped pointer.
  */
-#define ATOMIC_WRITTEN_PAGE		((unsigned long)-1)
-#define DUMMY_WRITTEN_PAGE		((unsigned long)-2)
+enum {
+	PAGE_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
+	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
+	PAGE_PRIVATE_DUMMY_WRITE,		/* data page for padding aligned IO */
+	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
+	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
+	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	PAGE_PRIVATE_MAX
+};
+
+#define PAGE_PRIVATE_GET_FUNC(name, flagname) \
+static inline bool page_private_##name(struct page *page) \
+{ \
+	return test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
+		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
+}
+
+#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
+static inline void set_page_private_##name(struct page *page) \
+{ \
+	if (!PagePrivate(page)) { \
+		get_page(page); \
+		SetPagePrivate(page); \
+	} \
+	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
+}
+
+#define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
+static inline void clear_page_private_##name(struct page *page) \
+{ \
+	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
+	if (page_private(page) == 1 << PAGE_PRIVATE_NOT_POINTER) { \
+		set_page_private(page, 0); \
+		if (PagePrivate(page)) { \
+			ClearPagePrivate(page); \
+			put_page(page); \
+		}\
+	} \
+}
+
+PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
+PAGE_PRIVATE_GET_FUNC(reference, REF_RESOURCE);
+PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
+PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
+PAGE_PRIVATE_GET_FUNC(dummy, DUMMY_WRITE);
 
-#define IS_ATOMIC_WRITTEN_PAGE(page)			\
-		(page_private(page) == ATOMIC_WRITTEN_PAGE)
-#define IS_DUMMY_WRITTEN_PAGE(page)			\
-		(page_private(page) == DUMMY_WRITTEN_PAGE)
+PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
+PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
+PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
+PAGE_PRIVATE_SET_FUNC(dummy, DUMMY_WRITE);
+
+PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
+PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
+PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
+PAGE_PRIVATE_CLEAR_FUNC(dummy, DUMMY_WRITE);
+
+static inline unsigned long get_page_private_data(struct page *page)
+{
+	unsigned long data = page_private(page);
+
+	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+		return 0;
+	return data >> PAGE_PRIVATE_MAX;
+}
+
+static inline void set_page_private_data(struct page *page, unsigned long data)
+{
+	if (!PagePrivate(page)) {
+		get_page(page);
+		SetPagePrivate(page);
+	}
+	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page));
+	page_private(page) |= data << PAGE_PRIVATE_MAX;
+}
+
+static inline void clear_page_private_data(struct page *page)
+{
+	page_private(page) &= (1 << PAGE_PRIVATE_MAX) - 1;
+	if (page_private(page) == 1 << PAGE_PRIVATE_NOT_POINTER) {
+		set_page_private(page, 0);
+		if (PagePrivate(page)) {
+			ClearPagePrivate(page);
+			put_page(page);
+		}
+	}
+}
 
 /* For compression */
 enum compress_algorithm_type {
@@ -1317,6 +1418,9 @@ enum compress_flag {
 	COMPRESS_MAX_FLAG,
 };
 
+#define	COMPRESS_WATERMARK			20
+#define	COMPRESS_PERCENT			20
+
 #define COMPRESS_DATA_RESERVED_SIZE		4
 struct compress_data {
 	__le32 clen;			/* compressed data size */
@@ -1626,6 +1730,12 @@ struct f2fs_sb_info {
 	u64 compr_written_block;
 	u64 compr_saved_block;
 	u32 compr_new_inode;
+
+	/* For compressed block cache */
+	struct inode *compress_inode;		/* cache compressed blocks */
+	unsigned int compress_percent;		/* cache page percentage */
+	unsigned int compress_watermark;	/* cache page watermark */
+	atomic_t compress_page_hit;		/* cache hit count */
 #endif
 };
 
@@ -3169,20 +3279,6 @@ static inline bool __is_valid_data_blkaddr(block_t blkaddr)
 	return true;
 }
 
-static inline void f2fs_set_page_private(struct page *page,
-						unsigned long data)
-{
-	if (PagePrivate(page))
-		return;
-
-	attach_page_private(page, (void *)data);
-}
-
-static inline void f2fs_clear_page_private(struct page *page)
-{
-	detach_page_private(page);
-}
-
 /*
  * file.c
  */
@@ -3606,7 +3702,8 @@ struct f2fs_stat_info {
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
 	int rsvd_segs, overp_segs;
-	int dirty_count, node_pages, meta_pages;
+	int dirty_count, node_pages, meta_pages, compress_pages;
+	int compress_page_hit;
 	int prefree_count, call_count, cp_count, bg_cp_count;
 	int tot_segs, node_segs, data_segs, free_segs, free_secs;
 	int bg_node_segs, bg_data_segs;
@@ -3942,7 +4039,9 @@ void f2fs_compress_write_end_io(struct bio *bio, struct page *page);
 bool f2fs_is_compress_backend_ready(struct inode *inode);
 int f2fs_init_compress_mempool(void);
 void f2fs_destroy_compress_mempool(void);
-void f2fs_end_read_compressed_page(struct page *page, bool failed);
+void f2fs_decompress_cluster(struct decompress_io_ctx *dic);
+void f2fs_end_read_compressed_page(struct page *page, bool failed,
+							block_t blkaddr);
 bool f2fs_cluster_is_empty(struct compress_ctx *cc);
 bool f2fs_cluster_can_merge_page(struct compress_ctx *cc, pgoff_t index);
 void f2fs_compress_ctx_add_page(struct compress_ctx *cc, struct page *page);
@@ -3960,10 +4059,19 @@ void f2fs_put_page_dic(struct page *page);
 int f2fs_init_compress_ctx(struct compress_ctx *cc);
 void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse);
 void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
+int f2fs_init_compress_inode(struct f2fs_sb_info *sbi);
+void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi);
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi);
 void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi);
 int __init f2fs_init_compress_cache(void);
 void f2fs_destroy_compress_cache(void);
+struct address_space *COMPRESS_MAPPING(struct f2fs_sb_info *sbi);
+void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi, block_t blkaddr);
+void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t ino, block_t blkaddr);
+bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+								block_t blkaddr);
+void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino);
 #define inc_compr_inode_stat(inode)					\
 	do {								\
 		struct f2fs_sb_info *sbi = F2FS_I_SB(inode);		\
@@ -3992,7 +4100,9 @@ static inline struct page *f2fs_compress_control_page(struct page *page)
 }
 static inline int f2fs_init_compress_mempool(void) { return 0; }
 static inline void f2fs_destroy_compress_mempool(void) { }
-static inline void f2fs_end_read_compressed_page(struct page *page, bool failed)
+static inline void f2fs_decompress_cluster(struct decompress_io_ctx *dic) { }
+static inline void f2fs_end_read_compressed_page(struct page *page,
+						bool failed, block_t blkaddr)
 {
 	WARN_ON_ONCE(1);
 }
@@ -4000,10 +4110,20 @@ static inline void f2fs_put_page_dic(struct page *page)
 {
 	WARN_ON_ONCE(1);
 }
+static inline int f2fs_init_compress_inode(struct f2fs_sb_info *sbi) { return 0; }
+static inline void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi) { }
 static inline int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi) { return 0; }
 static inline void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi) { }
 static inline int __init f2fs_init_compress_cache(void) { return 0; }
 static inline void f2fs_destroy_compress_cache(void) { }
+static inline void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi,
+				block_t blkaddr) { }
+static inline void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi,
+				struct page *page, nid_t ino, block_t blkaddr) { }
+static inline bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi,
+				struct page *page, block_t blkaddr) { return false; }
+static inline void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi,
+							nid_t ino) { }
 #define inc_compr_inode_stat(inode)		do { } while (0)
 #endif
 
@@ -4020,7 +4140,8 @@ static inline void set_compress_context(struct inode *inode)
 				1 << COMPRESS_CHKSUM : 0;
 	F2FS_I(inode)->i_cluster_size =
 			1 << F2FS_I(inode)->i_log_cluster_size;
-	if (F2FS_I(inode)->i_compress_algorithm == COMPRESS_LZ4 &&
+	if ((F2FS_I(inode)->i_compress_algorithm == COMPRESS_LZ4 ||
+		F2FS_I(inode)->i_compress_algorithm == COMPRESS_ZSTD) &&
 			F2FS_OPTION(sbi).compress_level)
 		F2FS_I(inode)->i_compress_flag |=
 				F2FS_OPTION(sbi).compress_level <<
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fb27d49e4da7..3a11e81fdf65 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1086,7 +1086,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		if (pg_start < pg_end) {
-			struct address_space *mapping = inode->i_mapping;
 			loff_t blk_start, blk_end;
 			struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
@@ -1098,8 +1097,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 			down_write(&F2FS_I(inode)->i_mmap_sem);
 
-			truncate_inode_pages_range(mapping, blk_start,
-					blk_end - 1);
+			truncate_pagecache_range(inode, blk_start, blk_end - 1);
 
 			f2fs_lock_op(sbi);
 			ret = f2fs_truncate_hole(inode, pg_start, pg_end);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ab63951c08cb..1c05e156d9d5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1261,6 +1261,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	f2fs_put_page(mpage, 1);
 	invalidate_mapping_pages(META_MAPPING(fio.sbi),
 				fio.old_blkaddr, fio.old_blkaddr);
+	f2fs_invalidate_compress_page(fio.sbi, fio.old_blkaddr);
 
 	set_page_dirty(fio.encrypted_page);
 	if (clear_page_dirty_for_io(fio.encrypted_page))
@@ -1336,7 +1337,7 @@ static int move_data_page(struct inode *inode, block_t bidx, int gc_type,
 			goto out;
 		}
 		set_page_dirty(page);
-		set_cold_data(page);
+		set_page_private_gcing(page);
 	} else {
 		struct f2fs_io_info fio = {
 			.sbi = F2FS_I_SB(inode),
@@ -1362,11 +1363,11 @@ static int move_data_page(struct inode *inode, block_t bidx, int gc_type,
 			f2fs_remove_dirty_inode(inode);
 		}
 
-		set_cold_data(page);
+		set_page_private_gcing(page);
 
 		err = f2fs_do_write_data_page(&fio);
 		if (err) {
-			clear_cold_data(page);
+			clear_page_private_gcing(page);
 			if (err == -ENOMEM) {
 				congestion_wait(BLK_RW_ASYNC,
 						DEFAULT_IO_TIMEOUT);
@@ -1496,8 +1497,10 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 			int err;
 
 			if (S_ISREG(inode->i_mode)) {
-				if (!down_write_trylock(&fi->i_gc_rwsem[READ]))
+				if (!down_write_trylock(&fi->i_gc_rwsem[READ])) {
+					sbi->skipped_gc_rwsem++;
 					continue;
+				}
 				if (!down_write_trylock(
 						&fi->i_gc_rwsem[WRITE])) {
 					sbi->skipped_gc_rwsem++;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 92652ca7a7c8..56a20d5c15da 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -173,7 +173,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 
 	/* clear inline data and flag after data writeback */
 	f2fs_truncate_inline_inode(dn->inode, dn->inode_page, 0);
-	clear_inline_node(dn->inode_page);
+	clear_page_private_inline(dn->inode_page);
 clear_out:
 	stat_dec_inline_inode(dn->inode);
 	clear_inode_flag(dn->inode, FI_INLINE_DATA);
@@ -255,7 +255,7 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	set_inode_flag(inode, FI_APPEND_WRITE);
 	set_inode_flag(inode, FI_DATA_EXIST);
 
-	clear_inline_node(dn.inode_page);
+	clear_page_private_inline(dn.inode_page);
 	f2fs_put_dnode(&dn);
 	return 0;
 }
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index b401f08569f7..9141147b5bb0 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -18,6 +18,10 @@
 
 #include <trace/events/f2fs.h>
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+extern const struct address_space_operations f2fs_compress_aops;
+#endif
+
 void f2fs_mark_inode_dirty_sync(struct inode *inode, bool sync)
 {
 	if (is_inode_flag_set(inode, FI_NEW_INODE))
@@ -494,6 +498,11 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
 		goto make_now;
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (ino == F2FS_COMPRESS_INO(sbi))
+		goto make_now;
+#endif
+
 	ret = do_read_inode(inode);
 	if (ret)
 		goto bad_inode;
@@ -504,6 +513,12 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	} else if (ino == F2FS_META_INO(sbi)) {
 		inode->i_mapping->a_ops = &f2fs_meta_aops;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
+	} else if (ino == F2FS_COMPRESS_INO(sbi)) {
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		inode->i_mapping->a_ops = &f2fs_compress_aops;
+#endif
+		mapping_set_gfp_mask(inode->i_mapping,
+			GFP_NOFS | __GFP_HIGHMEM | __GFP_MOVABLE);
 	} else if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &f2fs_file_inode_operations;
 		inode->i_fop = &f2fs_file_operations;
@@ -646,7 +661,7 @@ void f2fs_update_inode(struct inode *inode, struct page *node_page)
 
 	/* deleted inode */
 	if (inode->i_nlink == 0)
-		clear_inline_node(node_page);
+		clear_page_private_inline(node_page);
 
 	F2FS_I(inode)->i_disk_time[0] = inode->i_atime;
 	F2FS_I(inode)->i_disk_time[1] = inode->i_ctime;
@@ -723,8 +738,12 @@ void f2fs_evict_inode(struct inode *inode)
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
+	if (test_opt(sbi, COMPRESS_CACHE) && f2fs_compressed_file(inode))
+		f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
-			inode->i_ino == F2FS_META_INO(sbi))
+			inode->i_ino == F2FS_META_INO(sbi) ||
+			inode->i_ino == F2FS_COMPRESS_INO(sbi))
 		goto out_clear;
 
 	f2fs_bug_on(sbi, get_dirty_pages(inode));
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e67ce5f13b98..dd611efa8aa4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -97,6 +97,20 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		mem_size = (atomic_read(&dcc->discard_cmd_cnt) *
 				sizeof(struct discard_cmd)) >> PAGE_SHIFT;
 		res = mem_size < (avail_ram * nm_i->ram_thresh / 100);
+	} else if (type == COMPRESS_PAGE) {
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		unsigned long free_ram = val.freeram;
+
+		/*
+		 * free memory is lower than watermark or cached page count
+		 * exceed threshold, deny caching compress page.
+		 */
+		res = (free_ram > avail_ram * sbi->compress_watermark / 100) &&
+			(COMPRESS_MAPPING(sbi)->nrpages <
+			 free_ram * sbi->compress_percent / 100);
+#else
+		res = false;
+#endif
 	} else {
 		if (!sbi->sb->s_bdi->wb.dirty_exceeded)
 			return true;
@@ -1860,8 +1874,8 @@ void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 			}
 
 			/* flush inline_data, if it's async context. */
-			if (is_inline_node(page)) {
-				clear_inline_node(page);
+			if (page_private_inline(page)) {
+				clear_page_private_inline(page);
 				unlock_page(page);
 				flush_inline_data(sbi, ino_of_node(page));
 				continue;
@@ -1941,8 +1955,8 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 				goto write_node;
 
 			/* flush inline_data */
-			if (is_inline_node(page)) {
-				clear_inline_node(page);
+			if (page_private_inline(page)) {
+				clear_page_private_inline(page);
 				unlock_page(page);
 				flush_inline_data(sbi, ino_of_node(page));
 				goto lock_node;
@@ -2096,7 +2110,7 @@ static int f2fs_set_node_page_dirty(struct page *page)
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
 		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_NODES);
-		f2fs_set_page_private(page, 0);
+		set_page_private_reference(page);
 		return 1;
 	}
 	return 0;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 7a45c0f10629..84d45385d1f2 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -148,6 +148,7 @@ enum mem_type {
 	EXTENT_CACHE,	/* indicates extent cache */
 	INMEM_PAGES,	/* indicates inmemory pages */
 	DISCARD_CACHE,	/* indicates memory of cached discard cmds */
+	COMPRESS_PAGE,	/* indicates memory of cached compressed pages */
 	BASE_CHECK,	/* check kernel status */
 };
 
@@ -389,20 +390,6 @@ static inline nid_t get_nid(struct page *p, int off, bool i)
  *  - Mark cold node blocks in their node footer
  *  - Mark cold data pages in page cache
  */
-static inline int is_cold_data(struct page *page)
-{
-	return PageChecked(page);
-}
-
-static inline void set_cold_data(struct page *page)
-{
-	SetPageChecked(page);
-}
-
-static inline void clear_cold_data(struct page *page)
-{
-	ClearPageChecked(page);
-}
 
 static inline int is_node(struct page *page, int type)
 {
@@ -414,21 +401,6 @@ static inline int is_node(struct page *page, int type)
 #define is_fsync_dnode(page)	is_node(page, FSYNC_BIT_SHIFT)
 #define is_dent_dnode(page)	is_node(page, DENT_BIT_SHIFT)
 
-static inline int is_inline_node(struct page *page)
-{
-	return PageChecked(page);
-}
-
-static inline void set_inline_node(struct page *page)
-{
-	SetPageChecked(page);
-}
-
-static inline void clear_inline_node(struct page *page)
-{
-	ClearPageChecked(page);
-}
-
 static inline void set_cold_node(struct page *page, bool is_dir)
 {
 	struct f2fs_node *rn = F2FS_NODE(page);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 51dc79fad4fe..406a6b244782 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -186,10 +186,7 @@ void f2fs_register_inmem_page(struct inode *inode, struct page *page)
 {
 	struct inmem_pages *new;
 
-	if (PagePrivate(page))
-		set_page_private(page, (unsigned long)ATOMIC_WRITTEN_PAGE);
-	else
-		f2fs_set_page_private(page, ATOMIC_WRITTEN_PAGE);
+	set_page_private_atomic(page);
 
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
@@ -272,9 +269,10 @@ static int __revoke_inmem_pages(struct inode *inode,
 		/* we don't need to invalidate this in the sccessful status */
 		if (drop || recover) {
 			ClearPageUptodate(page);
-			clear_cold_data(page);
+			clear_page_private_gcing(page);
 		}
-		f2fs_clear_page_private(page);
+		detach_page_private(page);
+		set_page_private(page, 0);
 		f2fs_put_page(page, 1);
 
 		list_del(&cur->list);
@@ -357,7 +355,7 @@ void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
 	struct list_head *head = &fi->inmem_pages;
 	struct inmem_pages *cur = NULL;
 
-	f2fs_bug_on(sbi, !IS_ATOMIC_WRITTEN_PAGE(page));
+	f2fs_bug_on(sbi, !page_private_atomic(page));
 
 	mutex_lock(&fi->inmem_lock);
 	list_for_each_entry(cur, head, list) {
@@ -373,9 +371,12 @@ void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
 	kmem_cache_free(inmem_entry_slab, cur);
 
 	ClearPageUptodate(page);
-	f2fs_clear_page_private(page);
+	clear_page_private_atomic(page);
 	f2fs_put_page(page, 0);
 
+	detach_page_private(page);
+	set_page_private(page, 0);
+
 	trace_f2fs_commit_inmem_page(page, INMEM_INVALIDATE);
 }
 
@@ -2321,6 +2322,7 @@ void f2fs_invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 		return;
 
 	invalidate_mapping_pages(META_MAPPING(sbi), addr, addr);
+	f2fs_invalidate_compress_page(sbi, addr);
 
 	/* add it into sit main buffer */
 	down_write(&sit_i->sentry_lock);
@@ -3289,7 +3291,7 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 	if (fio->type == DATA) {
 		struct inode *inode = fio->page->mapping->host;
 
-		if (is_cold_data(fio->page)) {
+		if (page_private_gcing(fio->page)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
 				(fio->sbi->gc_mode != GC_URGENT_HIGH))
@@ -3468,9 +3470,11 @@ static void do_write_page(struct f2fs_summary *sum, struct f2fs_io_info *fio)
 reallocate:
 	f2fs_allocate_data_block(fio->sbi, fio->page, fio->old_blkaddr,
 			&fio->new_blkaddr, sum, type, fio);
-	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO)
+	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(fio->sbi),
 					fio->old_blkaddr, fio->old_blkaddr);
+		f2fs_invalidate_compress_page(fio->sbi, fio->old_blkaddr);
+	}
 
 	/* writeout dirty page into bdev */
 	f2fs_submit_page_write(fio);
@@ -3660,6 +3664,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(sbi),
 					old_blkaddr, old_blkaddr);
+		f2fs_invalidate_compress_page(sbi, old_blkaddr);
 		if (!from_gc)
 			update_segment_mtime(sbi, old_blkaddr, 0);
 		update_sit_entry(sbi, old_blkaddr, -1);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8553e8e5de0d..d61f7fcdc66b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -150,6 +150,7 @@ enum {
 	Opt_compress_extension,
 	Opt_compress_chksum,
 	Opt_compress_mode,
+	Opt_compress_cache,
 	Opt_atgc,
 	Opt_gc_merge,
 	Opt_nogc_merge,
@@ -224,6 +225,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_compress_extension, "compress_extension=%s"},
 	{Opt_compress_chksum, "compress_chksum"},
 	{Opt_compress_mode, "compress_mode=%s"},
+	{Opt_compress_cache, "compress_cache"},
 	{Opt_atgc, "atgc"},
 	{Opt_gc_merge, "gc_merge"},
 	{Opt_nogc_merge, "nogc_merge"},
@@ -1066,12 +1068,16 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			}
 			kfree(name);
 			break;
+		case Opt_compress_cache:
+			set_opt(sbi, COMPRESS_CACHE);
+			break;
 #else
 		case Opt_compress_algorithm:
 		case Opt_compress_log_size:
 		case Opt_compress_extension:
 		case Opt_compress_chksum:
 		case Opt_compress_mode:
+		case Opt_compress_cache:
 			f2fs_info(sbi, "compression options not supported");
 			break;
 #endif
@@ -1403,6 +1409,8 @@ static void f2fs_put_super(struct super_block *sb)
 
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
+	f2fs_destroy_compress_inode(sbi);
+
 	iput(sbi->node_inode);
 	sbi->node_inode = NULL;
 
@@ -1672,6 +1680,9 @@ static inline void f2fs_show_compress_options(struct seq_file *seq,
 		seq_printf(seq, ",compress_mode=%s", "fs");
 	else if (F2FS_OPTION(sbi).compress_mode == COMPR_MODE_USER)
 		seq_printf(seq, ",compress_mode=%s", "user");
+
+	if (test_opt(sbi, COMPRESS_CACHE))
+		seq_puts(seq, ",compress_cache");
 }
 #endif
 
@@ -1955,10 +1966,10 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	bool need_restart_ckpt = false, need_stop_ckpt = false;
 	bool need_restart_flush = false, need_stop_flush = false;
 	bool no_extent_cache = !test_opt(sbi, EXTENT_CACHE);
-	bool disable_checkpoint = test_opt(sbi, DISABLE_CHECKPOINT);
+	bool enable_checkpoint = !test_opt(sbi, DISABLE_CHECKPOINT);
 	bool no_io_align = !F2FS_IO_ALIGNED(sbi);
 	bool no_atgc = !test_opt(sbi, ATGC);
-	bool checkpoint_changed;
+	bool no_compress_cache = !test_opt(sbi, COMPRESS_CACHE);
 #ifdef CONFIG_QUOTA
 	int i, j;
 #endif
@@ -2003,8 +2014,6 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	err = parse_options(sb, data, true);
 	if (err)
 		goto restore_opts;
-	checkpoint_changed =
-			disable_checkpoint != test_opt(sbi, DISABLE_CHECKPOINT);
 
 	/*
 	 * Previous and new state of filesystem is RO,
@@ -2050,6 +2059,12 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if (no_compress_cache == !!test_opt(sbi, COMPRESS_CACHE)) {
+		err = -EINVAL;
+		f2fs_warn(sbi, "switch compress_cache option is not allowed");
+		goto restore_opts;
+	}
+
 	if ((*flags & SB_RDONLY) && test_opt(sbi, DISABLE_CHECKPOINT)) {
 		err = -EINVAL;
 		f2fs_warn(sbi, "disabling checkpoint not compatible with read-only");
@@ -2115,7 +2130,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 		need_stop_flush = true;
 	}
 
-	if (checkpoint_changed) {
+	if (enable_checkpoint == !!test_opt(sbi, DISABLE_CHECKPOINT)) {
 		if (test_opt(sbi, DISABLE_CHECKPOINT)) {
 			err = f2fs_disable_checkpoint(sbi);
 			if (err)
@@ -2399,6 +2414,33 @@ static int f2fs_enable_quotas(struct super_block *sb)
 	return 0;
 }
 
+static int f2fs_quota_sync_file(struct f2fs_sb_info *sbi, int type)
+{
+	struct quota_info *dqopt = sb_dqopt(sbi->sb);
+	struct address_space *mapping = dqopt->files[type]->i_mapping;
+	int ret = 0;
+
+	ret = dquot_writeback_dquots(sbi->sb, type);
+	if (ret)
+		goto out;
+
+	ret = filemap_fdatawrite(mapping);
+	if (ret)
+		goto out;
+
+	/* if we are using journalled quota */
+	if (is_journalled_quota(sbi))
+		goto out;
+
+	ret = filemap_fdatawait(mapping);
+
+	truncate_inode_pages(&dqopt->files[type]->i_data, 0);
+out:
+	if (ret)
+		set_sbi_flag(sbi, SBI_QUOTA_NEED_REPAIR);
+	return ret;
+}
+
 int f2fs_quota_sync(struct super_block *sb, int type)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
@@ -2406,57 +2448,42 @@ int f2fs_quota_sync(struct super_block *sb, int type)
 	int cnt;
 	int ret;
 
-	/*
-	 * do_quotactl
-	 *  f2fs_quota_sync
-	 *  down_read(quota_sem)
-	 *  dquot_writeback_dquots()
-	 *  f2fs_dquot_commit
-	 *                            block_operation
-	 *                            down_read(quota_sem)
-	 */
-	f2fs_lock_op(sbi);
-
-	down_read(&sbi->quota_sem);
-	ret = dquot_writeback_dquots(sb, type);
-	if (ret)
-		goto out;
-
 	/*
 	 * Now when everything is written we can discard the pagecache so
 	 * that userspace sees the changes.
 	 */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		struct address_space *mapping;
 
 		if (type != -1 && cnt != type)
 			continue;
-		if (!sb_has_quota_active(sb, cnt))
-			continue;
 
-		mapping = dqopt->files[cnt]->i_mapping;
+		if (!sb_has_quota_active(sb, type))
+			return 0;
 
-		ret = filemap_fdatawrite(mapping);
-		if (ret)
-			goto out;
+		inode_lock(dqopt->files[cnt]);
 
-		/* if we are using journalled quota */
-		if (is_journalled_quota(sbi))
-			continue;
+		/*
+		 * do_quotactl
+		 *  f2fs_quota_sync
+		 *  down_read(quota_sem)
+		 *  dquot_writeback_dquots()
+		 *  f2fs_dquot_commit
+		 *			      block_operation
+		 *			      down_read(quota_sem)
+		 */
+		f2fs_lock_op(sbi);
+		down_read(&sbi->quota_sem);
 
-		ret = filemap_fdatawait(mapping);
-		if (ret)
-			set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
+		ret = f2fs_quota_sync_file(sbi, cnt);
+
+		up_read(&sbi->quota_sem);
+		f2fs_unlock_op(sbi);
 
-		inode_lock(dqopt->files[cnt]);
-		truncate_inode_pages(&dqopt->files[cnt]->i_data, 0);
 		inode_unlock(dqopt->files[cnt]);
+
+		if (ret)
+			break;
 	}
-out:
-	if (ret)
-		set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
-	up_read(&sbi->quota_sem);
-	f2fs_unlock_op(sbi);
 	return ret;
 }
 
@@ -3089,11 +3116,13 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		return -EFSCORRUPTED;
 	}
 
-	if (le32_to_cpu(raw_super->cp_payload) >
-				(blocks_per_seg - F2FS_CP_PACKS)) {
-		f2fs_info(sbi, "Insane cp_payload (%u > %u)",
+	if (le32_to_cpu(raw_super->cp_payload) >=
+				(blocks_per_seg - F2FS_CP_PACKS -
+				NR_CURSEG_PERSIST_TYPE)) {
+		f2fs_info(sbi, "Insane cp_payload (%u >= %u)",
 			  le32_to_cpu(raw_super->cp_payload),
-			  blocks_per_seg - F2FS_CP_PACKS);
+			  blocks_per_seg - F2FS_CP_PACKS -
+			  NR_CURSEG_PERSIST_TYPE);
 		return -EFSCORRUPTED;
 	}
 
@@ -3129,6 +3158,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	unsigned int cp_pack_start_sum, cp_payload;
 	block_t user_block_count, valid_user_blocks;
 	block_t avail_node_count, valid_node_count;
+	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -3249,6 +3279,17 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 		return 1;
 	}
 
+	nat_blocks = nat_segs << log_blocks_per_seg;
+	nat_bits_bytes = nat_blocks / BITS_PER_BYTE;
+	nat_bits_blocks = F2FS_BLK_ALIGN((nat_bits_bytes << 1) + 8);
+	if (__is_set_ckpt_flags(ckpt, CP_NAT_BITS_FLAG) &&
+		(cp_payload + F2FS_CP_PACKS +
+		NR_CURSEG_PERSIST_TYPE + nat_bits_blocks >= blocks_per_seg)) {
+		f2fs_warn(sbi, "Insane cp_payload: %u, nat_bits_blocks: %u)",
+			  cp_payload, nat_bits_blocks);
+		return -EFSCORRUPTED;
+	}
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		f2fs_err(sbi, "A bug case: need to run fsck");
 		return 1;
@@ -3949,10 +3990,14 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_node_inode;
 	}
 
-	err = f2fs_register_sysfs(sbi);
+	err = f2fs_init_compress_inode(sbi);
 	if (err)
 		goto free_root_inode;
 
+	err = f2fs_register_sysfs(sbi);
+	if (err)
+		goto free_compress_inode;
+
 #ifdef CONFIG_QUOTA
 	/* Enable quota usage during mount */
 	if (f2fs_sb_has_quota_ino(sbi) && !f2fs_readonly(sb)) {
@@ -4093,6 +4138,8 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* evict some inodes being cached by GC */
 	evict_inodes(sb);
 	f2fs_unregister_sysfs(sbi);
+free_compress_inode:
+	f2fs_destroy_compress_inode(sbi);
 free_root_inode:
 	dput(sb->s_root);
 	sb->s_root = NULL;
@@ -4171,6 +4218,15 @@ static void kill_f2fs_super(struct super_block *sb)
 		f2fs_stop_gc_thread(sbi);
 		f2fs_stop_discard_thread(sbi);
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		/*
+		 * latter evict_inode() can bypass checking and invalidating
+		 * compress inode cache.
+		 */
+		if (test_opt(sbi, COMPRESS_CACHE))
+			truncate_inode_pages_final(COMPRESS_MAPPING(sbi));
+#endif
+
 		if (is_sbi_flag_set(sbi, SBI_IS_DIRTY) ||
 				!is_set_ckpt_flags(sbi, CP_UMOUNT_FLAG)) {
 			struct cp_control cpc = {
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 751bc5b1cddf..6104f627cc71 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -74,10 +74,8 @@ void fscache_free_cookie(struct fscache_cookie *cookie)
 static int fscache_set_key(struct fscache_cookie *cookie,
 			   const void *index_key, size_t index_key_len)
 {
-	unsigned long long h;
 	u32 *buf;
 	int bufs;
-	int i;
 
 	bufs = DIV_ROUND_UP(index_key_len, sizeof(*buf));
 
@@ -91,17 +89,7 @@ static int fscache_set_key(struct fscache_cookie *cookie,
 	}
 
 	memcpy(buf, index_key, index_key_len);
-
-	/* Calculate a hash and combine this with the length in the first word
-	 * or first half word
-	 */
-	h = (unsigned long)cookie->parent;
-	h += index_key_len + cookie->type;
-
-	for (i = 0; i < bufs; i++)
-		h += buf[i];
-
-	cookie->key_hash = h ^ (h >> 32);
+	cookie->key_hash = fscache_hash(0, buf, bufs);
 	return 0;
 }
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index c483863b740a..aee639d980ba 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -97,6 +97,8 @@ extern struct workqueue_struct *fscache_object_wq;
 extern struct workqueue_struct *fscache_op_wq;
 DECLARE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
 
+extern unsigned int fscache_hash(unsigned int salt, unsigned int *data, unsigned int n);
+
 static inline bool fscache_object_congested(void)
 {
 	return workqueue_congested(WORK_CPU_UNBOUND, fscache_object_wq);
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index c1e6cc9091aa..4207f98e405f 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -93,6 +93,45 @@ static struct ctl_table fscache_sysctls_root[] = {
 };
 #endif
 
+/*
+ * Mixing scores (in bits) for (7,20):
+ * Input delta: 1-bit      2-bit
+ * 1 round:     330.3     9201.6
+ * 2 rounds:   1246.4    25475.4
+ * 3 rounds:   1907.1    31295.1
+ * 4 rounds:   2042.3    31718.6
+ * Perfect:    2048      31744
+ *            (32*64)   (32*31/2 * 64)
+ */
+#define HASH_MIX(x, y, a)	\
+	(	x ^= (a),	\
+	y ^= x,	x = rol32(x, 7),\
+	x += y,	y = rol32(y,20),\
+	y *= 9			)
+
+static inline unsigned int fold_hash(unsigned long x, unsigned long y)
+{
+	/* Use arch-optimized multiply if one exists */
+	return __hash_32(y ^ __hash_32(x));
+}
+
+/*
+ * Generate a hash.  This is derived from full_name_hash(), but we want to be
+ * sure it is arch independent and that it doesn't change as bits of the
+ * computed hash value might appear on disk.  The caller also guarantees that
+ * the hashed data will be a series of aligned 32-bit words.
+ */
+unsigned int fscache_hash(unsigned int salt, unsigned int *data, unsigned int n)
+{
+	unsigned int a, x = 0, y = salt;
+
+	for (; n; n--) {
+		a = *data++;
+		HASH_MIX(x, y, a);
+	}
+	return fold_hash(x, y);
+}
+
 /*
  * initialise the fs caching module
  */
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 54d3fbeb3002..384565d63eea 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -610,16 +610,13 @@ static int freeze_go_xmote_bh(struct gfs2_glock *gl)
 		j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 		error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-		if (error)
-			gfs2_consist(sdp);
-		if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT))
-			gfs2_consist(sdp);
-
-		/*  Initialize some head of the log stuff  */
-		if (!gfs2_withdrawn(sdp)) {
-			sdp->sd_log_sequence = head.lh_sequence + 1;
-			gfs2_log_pointers_init(sdp, head.lh_blkno);
-		}
+		if (gfs2_assert_withdraw_delayed(sdp, !error))
+			return error;
+		if (gfs2_assert_withdraw_delayed(sdp, head.lh_flags &
+						 GFS2_LOG_HEAD_UNMOUNT))
+			return -EIO;
+		sdp->sd_log_sequence = head.lh_sequence + 1;
+		gfs2_log_pointers_init(sdp, head.lh_blkno);
 	}
 	return 0;
 }
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index dac040162ecc..50578f881e6d 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -299,6 +299,11 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
+	/* don't want to call dlm if we've unmounted the lock protocol */
+	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
+		gfs2_glock_free(gl);
+		return;
+	}
 	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
diff --git a/fs/io-wq.c b/fs/io-wq.c
index c7171d975896..6612d0aa497e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -237,9 +237,9 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool ret;
+	bool do_create = false, first = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -248,25 +248,18 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock_irq(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock_irq(&wqe->lock);
-		if (do_create)
-			create_io_worker(wqe->wq, wqe, acct->index, first);
+	raw_spin_lock_irq(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock_irq(&wqe->lock);
+	if (do_create) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -798,7 +791,8 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	unsigned work_flags = work->flags;
+	bool do_create;
 	unsigned long flags;
 
 	/*
@@ -811,15 +805,19 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe);
+	rcu_read_unlock();
+
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
-		io_wqe_wake_worker(wqe, acct);
+	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	    !atomic_read(&acct->nr_running)))
+		io_wqe_create_worker(wqe, acct);
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58ae2eab99ef..925f7f27af1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1307,6 +1307,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail_links(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
@@ -3474,7 +3476,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3525,7 +3527,8 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3571,8 +3574,8 @@ static int io_shutdown_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
-	    sqe->buf_index)
+	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->shutdown.how = READ_ONCE(sqe->len);
@@ -3720,7 +3723,8 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3753,7 +3757,8 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3784,7 +3789,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3909,7 +3914,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -3980,7 +3986,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4067,7 +4073,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4113,7 +4119,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4148,7 +4154,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4186,7 +4192,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4222,7 +4228,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4283,7 +4289,8 @@ static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4710,7 +4717,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4758,7 +4765,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5368,7 +5376,7 @@ static int io_poll_update_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
@@ -5603,7 +5611,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tr->addr = READ_ONCE(sqe->addr);
@@ -5662,7 +5670,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5811,7 +5820,8 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5868,7 +5878,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
@@ -6281,6 +6291,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -7195,11 +7206,11 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 {
 	struct io_rsrc_data *data;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return NULL;
 
-	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
+	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL_ACCOUNT);
 	if (!data->tags) {
 		kfree(data);
 		return NULL;
@@ -7477,7 +7488,7 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
 
-	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
+	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL_ACCOUNT);
 	if (!table->files)
 		return false;
 
@@ -7485,7 +7496,7 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 
 		table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!table->files[i])
 			break;
 		nr_files -= this_files;
@@ -9090,8 +9101,8 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 9023717c5188..35839acd0004 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1045,7 +1045,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 498cb70c2c0d..273a81971ed5 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -395,28 +395,10 @@ nlmsvc_release_lockowner(struct nlm_lock *lock)
 		nlmsvc_put_lockowner(lock->fl.fl_owner);
 }
 
-static void nlmsvc_locks_copy_lock(struct file_lock *new, struct file_lock *fl)
-{
-	struct nlm_lockowner *nlm_lo = (struct nlm_lockowner *)fl->fl_owner;
-	new->fl_owner = nlmsvc_get_lockowner(nlm_lo);
-}
-
-static void nlmsvc_locks_release_private(struct file_lock *fl)
-{
-	nlmsvc_put_lockowner((struct nlm_lockowner *)fl->fl_owner);
-}
-
-static const struct file_lock_operations nlmsvc_lock_ops = {
-	.fl_copy_lock = nlmsvc_locks_copy_lock,
-	.fl_release_private = nlmsvc_locks_release_private,
-};
-
 void nlmsvc_locks_init_private(struct file_lock *fl, struct nlm_host *host,
 						pid_t pid)
 {
 	fl->fl_owner = nlmsvc_find_lockowner(host, pid);
-	if (fl->fl_owner != NULL)
-		fl->fl_ops = &nlmsvc_lock_ops;
 }
 
 /*
@@ -788,9 +770,21 @@ nlmsvc_notify_blocked(struct file_lock *fl)
 	printk(KERN_WARNING "lockd: notification for unknown block!\n");
 }
 
+static fl_owner_t nlmsvc_get_owner(fl_owner_t owner)
+{
+	return nlmsvc_get_lockowner(owner);
+}
+
+static void nlmsvc_put_owner(fl_owner_t owner)
+{
+	nlmsvc_put_lockowner(owner);
+}
+
 const struct lock_manager_operations nlmsvc_lock_operations = {
 	.lm_notify = nlmsvc_notify_blocked,
 	.lm_grant = nlmsvc_grant_deferred,
+	.lm_get_owner = nlmsvc_get_owner,
+	.lm_put_owner = nlmsvc_put_owner,
 };
 
 /*
diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 37a1a88df771..d772c20bbfd1 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -180,5 +180,5 @@ const struct export_operations nfs_export_ops = {
 	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR,
+		EXPORT_OP_NOATOMIC_ATTR|EXPORT_OP_SYNC_LOCKS,
 };
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index be960e47d7f6..28350d62b9bd 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -335,7 +335,7 @@ static bool pnfs_seqid_is_newer(u32 s1, u32 s2)
 
 static void pnfs_barrier_update(struct pnfs_layout_hdr *lo, u32 newseq)
 {
-	if (pnfs_seqid_is_newer(newseq, lo->plh_barrier))
+	if (pnfs_seqid_is_newer(newseq, lo->plh_barrier) || !lo->plh_barrier)
 		lo->plh_barrier = newseq;
 }
 
@@ -347,11 +347,15 @@ pnfs_set_plh_return_info(struct pnfs_layout_hdr *lo, enum pnfs_iomode iomode,
 		iomode = IOMODE_ANY;
 	lo->plh_return_iomode = iomode;
 	set_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags);
-	if (seq != 0) {
-		WARN_ON_ONCE(lo->plh_return_seq != 0 && lo->plh_return_seq != seq);
+	/*
+	 * We must set lo->plh_return_seq to avoid livelocks with
+	 * pnfs_layout_need_return()
+	 */
+	if (seq == 0)
+		seq = be32_to_cpu(lo->plh_stateid.seqid);
+	if (!lo->plh_return_seq || pnfs_seqid_is_newer(seq, lo->plh_return_seq))
 		lo->plh_return_seq = seq;
-		pnfs_barrier_update(lo, seq);
-	}
+	pnfs_barrier_update(lo, seq);
 }
 
 static void
@@ -1000,7 +1004,7 @@ pnfs_layout_stateid_blocked(const struct pnfs_layout_hdr *lo,
 {
 	u32 seqid = be32_to_cpu(stateid->seqid);
 
-	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier) && lo->plh_barrier;
+	return lo->plh_barrier && pnfs_seqid_is_newer(lo->plh_barrier, seqid);
 }
 
 /* lget is set to 1 if called from inside send_layoutget call chain */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ab81e8ae3265..42c42ee3f00a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6727,6 +6727,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
+	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6748,6 +6749,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
+	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6796,7 +6798,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6808,7 +6811,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
@@ -6928,8 +6932,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 /*
  * The NFSv4 spec allows a client to do a LOCKT without holding an OPEN,
  * so we do a temporary open here just to get an open file to pass to
- * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
- * inode operation.)
+ * vfs_test_lock.
  */
 static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
@@ -6944,7 +6947,9 @@ static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct
 							NFSD_MAY_READ));
 	if (err)
 		goto out;
+	lock->fl_file = nf->nf_file;
 	err = nfserrno(vfs_test_lock(nf->nf_file, lock));
+	lock->fl_file = NULL;
 out:
 	fh_unlock(fhp);
 	nfsd_file_put(nf);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 93efe7048a77..7c1850adec28 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -542,8 +542,10 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			goto out_cleanup;
 	}
 	err = ovl_instantiate(dentry, inode, newdentry, hardlink);
-	if (err)
-		goto out_cleanup;
+	if (err) {
+		ovl_cleanup(udir, newdentry);
+		dput(newdentry);
+	}
 out_dput:
 	dput(upper);
 out_unlock:
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 8fc8bbf9635b..e55f861d23fd 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -33,11 +33,6 @@ int sysctl_unprivileged_userfaultfd __read_mostly;
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
-enum userfaultfd_state {
-	UFFD_STATE_WAIT_API,
-	UFFD_STATE_RUNNING,
-};
-
 /*
  * Start with fault_pending_wqh and fault_wqh so they're more likely
  * to be in the same cacheline.
@@ -69,8 +64,6 @@ struct userfaultfd_ctx {
 	unsigned int flags;
 	/* features requested from the userspace */
 	unsigned int features;
-	/* state machine */
-	enum userfaultfd_state state;
 	/* released */
 	bool released;
 	/* memory mappings are changing because of non-cooperative event */
@@ -104,6 +97,14 @@ struct userfaultfd_wake_range {
 	unsigned long len;
 };
 
+/* internal indication that UFFD_API ioctl was successfully executed */
+#define UFFD_FEATURE_INITIALIZED		(1u << 31)
+
+static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
+{
+	return ctx->features & UFFD_FEATURE_INITIALIZED;
+}
+
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -666,7 +667,6 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 
 		refcount_set(&ctx->refcount, 1);
 		ctx->flags = octx->flags;
-		ctx->state = UFFD_STATE_RUNNING;
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mmap_changing = false;
@@ -943,38 +943,33 @@ static __poll_t userfaultfd_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &ctx->fd_wqh, wait);
 
-	switch (ctx->state) {
-	case UFFD_STATE_WAIT_API:
+	if (!userfaultfd_is_initialized(ctx))
 		return EPOLLERR;
-	case UFFD_STATE_RUNNING:
-		/*
-		 * poll() never guarantees that read won't block.
-		 * userfaults can be waken before they're read().
-		 */
-		if (unlikely(!(file->f_flags & O_NONBLOCK)))
-			return EPOLLERR;
-		/*
-		 * lockless access to see if there are pending faults
-		 * __pollwait last action is the add_wait_queue but
-		 * the spin_unlock would allow the waitqueue_active to
-		 * pass above the actual list_add inside
-		 * add_wait_queue critical section. So use a full
-		 * memory barrier to serialize the list_add write of
-		 * add_wait_queue() with the waitqueue_active read
-		 * below.
-		 */
-		ret = 0;
-		smp_mb();
-		if (waitqueue_active(&ctx->fault_pending_wqh))
-			ret = EPOLLIN;
-		else if (waitqueue_active(&ctx->event_wqh))
-			ret = EPOLLIN;
 
-		return ret;
-	default:
-		WARN_ON_ONCE(1);
+	/*
+	 * poll() never guarantees that read won't block.
+	 * userfaults can be waken before they're read().
+	 */
+	if (unlikely(!(file->f_flags & O_NONBLOCK)))
 		return EPOLLERR;
-	}
+	/*
+	 * lockless access to see if there are pending faults
+	 * __pollwait last action is the add_wait_queue but
+	 * the spin_unlock would allow the waitqueue_active to
+	 * pass above the actual list_add inside
+	 * add_wait_queue critical section. So use a full
+	 * memory barrier to serialize the list_add write of
+	 * add_wait_queue() with the waitqueue_active read
+	 * below.
+	 */
+	ret = 0;
+	smp_mb();
+	if (waitqueue_active(&ctx->fault_pending_wqh))
+		ret = EPOLLIN;
+	else if (waitqueue_active(&ctx->event_wqh))
+		ret = EPOLLIN;
+
+	return ret;
 }
 
 static const struct file_operations userfaultfd_fops;
@@ -1169,7 +1164,7 @@ static ssize_t userfaultfd_read(struct file *file, char __user *buf,
 	int no_wait = file->f_flags & O_NONBLOCK;
 	struct inode *inode = file_inode(file);
 
-	if (ctx->state == UFFD_STATE_WAIT_API)
+	if (!userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	for (;;) {
@@ -1905,9 +1900,10 @@ static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
-	 * For the current set of features the bits just coincide
+	 * For the current set of features the bits just coincide. Set
+	 * UFFD_FEATURE_INITIALIZED to mark the features as enabled.
 	 */
-	return (unsigned int)user_features;
+	return (unsigned int)user_features | UFFD_FEATURE_INITIALIZED;
 }
 
 /*
@@ -1920,12 +1916,10 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 {
 	struct uffdio_api uffdio_api;
 	void __user *buf = (void __user *)arg;
+	unsigned int ctx_features;
 	int ret;
 	__u64 features;
 
-	ret = -EINVAL;
-	if (ctx->state != UFFD_STATE_WAIT_API)
-		goto out;
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
@@ -1945,9 +1939,13 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 		goto out;
-	ctx->state = UFFD_STATE_RUNNING;
+
 	/* only enable the requested features for this uffd context */
-	ctx->features = uffd_ctx_features(features);
+	ctx_features = uffd_ctx_features(features);
+	ret = -EINVAL;
+	if (cmpxchg(&ctx->features, 0, ctx_features) != 0)
+		goto err_out;
+
 	ret = 0;
 out:
 	return ret;
@@ -1964,7 +1962,7 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	int ret = -EINVAL;
 	struct userfaultfd_ctx *ctx = file->private_data;
 
-	if (cmd != UFFDIO_API && ctx->state == UFFD_STATE_WAIT_API)
+	if (cmd != UFFDIO_API && !userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	switch(cmd) {
@@ -2078,7 +2076,6 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	refcount_set(&ctx->refcount, 1);
 	ctx->flags = flags;
 	ctx->features = 0;
-	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
 	ctx->mmap_changing = false;
 	ctx->mm = current->mm;
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 47accec68cb0..f603325c0c30 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -38,9 +38,9 @@ extern void public_key_free(struct public_key *key);
 struct public_key_signature {
 	struct asymmetric_key_id *auth_ids[2];
 	u8 *s;			/* Signature */
-	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;		/* Number of bytes in digest */
+	u32 s_size;		/* Number of bytes in signature */
+	u32 digest_size;	/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
 	const char *encoding;
diff --git a/include/drm/drm_auth.h b/include/drm/drm_auth.h
index 6bf8b2b78991..f99d3417f304 100644
--- a/include/drm/drm_auth.h
+++ b/include/drm/drm_auth.h
@@ -107,6 +107,7 @@ struct drm_master {
 };
 
 struct drm_master *drm_master_get(struct drm_master *master);
+struct drm_master *drm_file_get_master(struct drm_file *file_priv);
 void drm_master_put(struct drm_master **master);
 bool drm_is_current_master(struct drm_file *fpriv);
 
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index b81b3bfb08c8..726cfe0ff5f5 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -226,15 +226,27 @@ struct drm_file {
 	/**
 	 * @master:
 	 *
-	 * Master this node is currently associated with. Only relevant if
-	 * drm_is_primary_client() returns true. Note that this only
-	 * matches &drm_device.master if the master is the currently active one.
+	 * Master this node is currently associated with. Protected by struct
+	 * &drm_device.master_mutex, and serialized by @master_lookup_lock.
+	 *
+	 * Only relevant if drm_is_primary_client() returns true. Note that
+	 * this only matches &drm_device.master if the master is the currently
+	 * active one.
+	 *
+	 * When dereferencing this pointer, either hold struct
+	 * &drm_device.master_mutex for the duration of the pointer's use, or
+	 * use drm_file_get_master() if struct &drm_device.master_mutex is not
+	 * currently held and there is no other need to hold it. This prevents
+	 * @master from being freed during use.
 	 *
 	 * See also @authentication and @is_master and the :ref:`section on
 	 * primary nodes and authentication <drm_primary_node>`.
 	 */
 	struct drm_master *master;
 
+	/** @master_lock: Serializes @master. */
+	spinlock_t master_lookup_lock;
+
 	/** @pid: Process that opened this file. */
 	struct pid *pid;
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e030f7510cd3..b21a553e2e06 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -17,8 +17,6 @@
 #include <linux/compat.h>
 #include <uapi/linux/ethtool.h>
 
-#ifdef CONFIG_COMPAT
-
 struct compat_ethtool_rx_flow_spec {
 	u32		flow_type;
 	union ethtool_flow_union h_u;
@@ -38,8 +36,6 @@ struct compat_ethtool_rxnfc {
 	u32				rule_locs[];
 };
 
-#endif /* CONFIG_COMPAT */
-
 #include <linux/rculist.h>
 
 /**
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fe848901fcc3..3260fe714846 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,6 +221,8 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
+#define EXPORT_OP_SYNC_LOCKS		(0x20) /* Filesystem can't do
+						  asychronous blocking locks */
 	unsigned long	flags;
 };
 
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 5487a80617a3..0021ea8f7c3b 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -34,6 +34,7 @@
 #define F2FS_ROOT_INO(sbi)	((sbi)->root_ino_num)
 #define F2FS_NODE_INO(sbi)	((sbi)->node_ino_num)
 #define F2FS_META_INO(sbi)	((sbi)->meta_ino_num)
+#define F2FS_COMPRESS_INO(sbi)	(NM_I(sbi)->max_nid)
 
 #define F2FS_MAX_QUOTAS		3
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 28a110ec2a0d..0b9a894c20c8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -835,6 +835,11 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -1019,6 +1024,10 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 	return &mm->page_table_lock;
 }
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+}
+
 static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
 {
 }
diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 0bff345c4bc6..171bf1be4011 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -118,6 +118,13 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 	css_put(&h_cg->css);
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+	if (resv_map->css)
+		css_get(resv_map->css);
+}
+
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
 extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
@@ -196,6 +203,11 @@ static inline void hugetlb_cgroup_put_rsvd_cgroup(struct hugetlb_cgroup *h_cg)
 {
 }
 
+static inline void resv_map_dup_hugetlb_cgroup_uncharge_info(
+						struct resv_map *resv_map)
+{
+}
+
 static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					       struct hugetlb_cgroup **ptr)
 {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 03faf20a6817..cf2dafe3ce60 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -124,9 +124,9 @@
 #define DMAR_MTRR_PHYSMASK8_REG 0x208
 #define DMAR_MTRR_PHYSBASE9_REG 0x210
 #define DMAR_MTRR_PHYSMASK9_REG 0x218
-#define DMAR_VCCAP_REG		0xe00 /* Virtual command capability register */
-#define DMAR_VCMD_REG		0xe10 /* Virtual command register */
-#define DMAR_VCRSP_REG		0xe20 /* Virtual command response register */
+#define DMAR_VCCAP_REG		0xe30 /* Virtual command capability register */
+#define DMAR_VCMD_REG		0xe00 /* Virtual command register */
+#define DMAR_VCRSP_REG		0xe10 /* Virtual command response register */
 
 #define DMAR_IQER_REG_IQEI(reg)		FIELD_GET(GENMASK_ULL(3, 0), reg)
 #define DMAR_IQER_REG_ITESID(reg)	FIELD_GET(GENMASK_ULL(47, 32), reg)
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 28f32fd00fe9..57a8aa463ccb 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -366,8 +366,8 @@ extern void sparse_remove_section(struct mem_section *ms,
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages);
+extern struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages);
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1199ffd305d1..fcd8ec0b7408 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -167,7 +167,7 @@ void synchronize_rcu_tasks(void);
 # define synchronize_rcu_tasks synchronize_rcu
 # endif
 
-# ifdef CONFIG_TASKS_RCU_TRACE
+# ifdef CONFIG_TASKS_TRACE_RCU
 # define rcu_tasks_trace_qs(t)						\
 	do {								\
 		if (!likely(READ_ONCE((t)->trc_reader_checked)) &&	\
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index d1672de9ca89..87b325aec508 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -52,17 +52,22 @@ do { \
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname) \
-	, .dep_map = { .name = #mutexname }
+#define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)	\
+	.dep_map = {					\
+		.name = #mutexname,			\
+		.wait_type_inner = LD_WAIT_SLEEP,	\
+	}
 #else
 #define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)
 #endif
 
-#define __RT_MUTEX_INITIALIZER(mutexname) \
-	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .waiters = RB_ROOT_CACHED \
-	, .owner = NULL \
-	__DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)}
+#define __RT_MUTEX_INITIALIZER(mutexname)				\
+{									\
+	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock),	\
+	.waiters = RB_ROOT_CACHED,					\
+	.owner = NULL,							\
+	__DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)			\
+}
 
 #define DEFINE_RT_MUTEX(mutexname) \
 	struct rt_mutex mutexname = __RT_MUTEX_INITIALIZER(mutexname)
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 61b622e334ee..52e5b11e4b6a 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -422,6 +422,7 @@ void			xprt_unlock_connect(struct rpc_xprt *, void *);
 #define XPRT_CONGESTED		(9)
 #define XPRT_CWND_WAIT		(10)
 #define XPRT_WRITE_SPACE	(11)
+#define XPRT_SND_IS_COOKIE	(12)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 3c1423ee74b4..8c2a712cb242 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -10,6 +10,7 @@
 
 int		init_socket_xprt(void);
 void		cleanup_socket_xprt(void);
+unsigned short	get_srcport(struct rpc_xprt *);
 
 #define RPC_MIN_RESVPORT	(1U)
 #define RPC_MAX_RESVPORT	(65535U)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 34a92d5ed12b..22a60291f203 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1411,6 +1411,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 				!hci_dev_test_flag(dev, HCI_AUTO_OFF))
 #define bredr_sc_enabled(dev)  (lmp_sc_capable(dev) && \
 				hci_dev_test_flag(dev, HCI_SC_ENABLED))
+#define rpa_valid(dev)         (bacmp(&dev->rpa, BDADDR_ANY) && \
+				!hci_dev_test_flag(dev, HCI_RPA_EXPIRED))
+#define adv_rpa_valid(adv)     (bacmp(&adv->random_addr, BDADDR_ANY) && \
+				!adv->rpa_expired)
 
 #define scan_1m(dev) (((dev)->le_tx_def_phys & HCI_LE_SET_PHY_1M) || \
 		      ((dev)->le_rx_def_phys & HCI_LE_SET_PHY_1M))
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..26788244d75b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -451,6 +451,7 @@ struct flow_block_offload {
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
 	struct Qdisc *sch;
+	struct list_head *cb_list_head;
 };
 
 enum tc_setup_type;
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index be07b5470f4b..f51bc8f36813 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -62,6 +62,7 @@
  * ST16C654:	 8  16  56  60		 8  16  32  56	PORT_16654
  * TI16C750:	 1  16  32  56		xx  xx  xx  xx	PORT_16750
  * TI16C752:	 8  16  56  60		 8  16  32  56
+ * OX16C950:	16  32 112 120		16  32  64 112	PORT_16C950
  * Tegra:	 1   4   8  14		16   8   4   1	PORT_TEGRA
  */
 #define UART_FCR_R_TRIG_00	0x00
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 14de1271463f..445754529917 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -794,7 +794,7 @@ static int dump_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(dump);
 
-static void dma_debug_fs_init(void)
+static int __init dma_debug_fs_init(void)
 {
 	struct dentry *dentry = debugfs_create_dir("dma-api", NULL);
 
@@ -807,7 +807,10 @@ static void dma_debug_fs_init(void)
 	debugfs_create_u32("nr_total_entries", 0444, dentry, &nr_total_entries);
 	debugfs_create_file("driver_filter", 0644, dentry, NULL, &filter_fops);
 	debugfs_create_file("dump", 0444, dentry, NULL, &dump_fops);
+
+	return 0;
 }
+core_initcall_sync(dma_debug_fs_init);
 
 static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
@@ -892,8 +895,6 @@ static int dma_debug_init(void)
 		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
-	dma_debug_fs_init();
-
 	nr_pages = DIV_ROUND_UP(nr_prealloc_entries, DMA_DEBUG_DYNAMIC_ENTRIES);
 	for (i = 0; i < nr_pages; ++i)
 		dma_debug_create_entries(GFP_KERNEL);
diff --git a/kernel/fork.c b/kernel/fork.c
index 567fee340500..268f1e7321cb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1045,6 +1045,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 3c20afbc19e1..ae5afba2162b 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1556,7 +1556,7 @@ void __sched __rt_mutex_init(struct rt_mutex *lock, const char *name,
 		     struct lock_class_key *key)
 {
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
 
 	__rt_mutex_basic_init(lock);
 }
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index ca43239a255a..cb5a25a8a0cc 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cachep(unsigned int level)
 	mutex_lock(&pid_caches_mutex);
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
-		*pkc = kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
+		*pkc = kmem_cache_create(name, len, 0,
+					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
 	mutex_unlock(&pid_caches_mutex);
 	/* current can fail, but someone else can succeed. */
 	return READ_ONCE(*pkc);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 421c35571797..d6731384dd47 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2545,6 +2545,7 @@ void console_unlock(void)
 	bool do_cond_resched, retry;
 	struct printk_info info;
 	struct printk_record r;
+	u64 __maybe_unused next_seq;
 
 	if (console_suspended) {
 		up_console_sem();
@@ -2654,8 +2655,10 @@ void console_unlock(void)
 			cond_resched();
 	}
 
-	console_locked = 0;
+	/* Get consistent value of the next-to-be-used sequence number. */
+	next_seq = console_seq;
 
+	console_locked = 0;
 	up_console_sem();
 
 	/*
@@ -2664,7 +2667,7 @@ void console_unlock(void)
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	retry = prb_read_valid(prb, console_seq, NULL);
+	retry = prb_read_valid(prb, next_seq, NULL);
 	printk_safe_exit_irqrestore(flags);
 
 	if (retry && console_trylock())
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index ad0156b86937..d14905051535 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2995,17 +2995,17 @@ static void noinstr rcu_dynticks_task_exit(void)
 /* Turn on heavyweight RCU tasks trace readers on idle/user entry. */
 static void rcu_dynticks_task_trace_enter(void)
 {
-#ifdef CONFIG_TASKS_RCU_TRACE
+#ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
 		current->trc_reader_special.b.need_mb = true;
-#endif /* #ifdef CONFIG_TASKS_RCU_TRACE */
+#endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
 
 /* Turn off heavyweight RCU tasks trace readers on idle/user exit. */
 static void rcu_dynticks_task_trace_exit(void)
 {
-#ifdef CONFIG_TASKS_RCU_TRACE
+#ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
 		current->trc_reader_special.b.need_mb = false;
-#endif /* #ifdef CONFIG_TASKS_RCU_TRACE */
+#endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f148eacda55a..542c2d03dab6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5902,6 +5902,13 @@ static void __init wq_numa_init(void)
 		return;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (WARN_ON(cpu_to_node(cpu) == NUMA_NO_NODE)) {
+			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
+			return;
+		}
+	}
+
 	wq_update_unbound_numa_attrs_buf = alloc_workqueue_attrs();
 	BUG_ON(!wq_update_unbound_numa_attrs_buf);
 
@@ -5919,11 +5926,6 @@ static void __init wq_numa_init(void)
 
 	for_each_possible_cpu(cpu) {
 		node = cpu_to_node(cpu);
-		if (WARN_ON(node == NUMA_NO_NODE)) {
-			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
-			/* happens iff arch is bonkers, let's just proceed */
-			return;
-		}
 		cpumask_set_cpu(cpu, tbl[node]);
 	}
 
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 4dc4dcbecd12..acf825d81671 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4286,8 +4286,8 @@ static struct bpf_test tests[] = {
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0),
 			BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
-			BPF_STX_MEM(BPF_W, R10, R1, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
 			BPF_EXIT_INSN(),
 		},
 		INTERNAL,
@@ -6659,7 +6659,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 		u64 duration;
 		u32 ret;
 
-		if (test->test[i].data_size == 0 &&
+		/*
+		 * NOTE: Several sub-tests may be present, in which case
+		 * a zero {data_size, result} tuple indicates the end of
+		 * the sub-test array. The first test is always run,
+		 * even if both data_size and result happen to be zero.
+		 */
+		if (i > 0 &&
+		    test->test[i].data_size == 0 &&
 		    test->test[i].result == 0)
 			break;
 
diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
index f93b1e145ada..16b1d3a3a497 100644
--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -67,10 +67,10 @@ static bool range_contains(char *haystack_start, size_t haystack_size,
 #define INIT_STRUCT_none		/**/
 #define INIT_STRUCT_zero		= { }
 #define INIT_STRUCT_static_partial	= { .two = 0, }
-#define INIT_STRUCT_static_all		= { .one = arg->one,		\
-					    .two = arg->two,		\
-					    .three = arg->three,	\
-					    .four = arg->four,		\
+#define INIT_STRUCT_static_all		= { .one = 0,			\
+					    .two = 0,			\
+					    .three = 0,			\
+					    .four = 0,			\
 					}
 #define INIT_STRUCT_dynamic_partial	= { .two = arg->two, }
 #define INIT_STRUCT_dynamic_all		= { .one = arg->one,		\
@@ -84,8 +84,7 @@ static bool range_contains(char *haystack_start, size_t haystack_size,
 					var.one = 0;			\
 					var.two = 0;			\
 					var.three = 0;			\
-					memset(&var.four, 0,		\
-					       sizeof(var.four))
+					var.four = 0
 
 /*
  * @name: unique string name for the test
@@ -210,18 +209,13 @@ struct test_small_hole {
 	unsigned long four;
 };
 
-/* Try to trigger unhandled padding in a structure. */
-struct test_aligned {
-	u32 internal1;
-	u64 internal2;
-} __aligned(64);
-
+/* Trigger unhandled padding in a structure. */
 struct test_big_hole {
 	u8 one;
 	u8 two;
 	u8 three;
 	/* 61 byte padding hole here. */
-	struct test_aligned four;
+	u8 four __aligned(64);
 } __aligned(64);
 
 struct test_trailing_hole {
diff --git a/mm/hmm.c b/mm/hmm.c
index 943cb2ba4442..fb617054f963 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -291,10 +291,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		goto fault;
 
 	/*
+	 * Bypass devmap pte such as DAX page when all pfn requested
+	 * flags(pfn_req_flags) are fulfilled.
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {
+	if (pte_special(pte) && !pte_devmap(pte) &&
+	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
 			return -EFAULT;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6ad419e7e0a4..dcc6ded8ff22 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3840,8 +3840,10 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		resv_map_dup_hugetlb_cgroup_uncharge_info(resv);
 		kref_get(&resv->refs);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1bf3f8681250..8b2bec1963b4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -834,8 +834,8 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages)
+struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (online_type == MMOP_ONLINE_KERNEL)
 		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f62d81f61b56..6b06e472a07d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2576,7 +2576,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			cgroup_size = max(cgroup_size, protection);
 
 			scan = lruvec_size - lruvec_size * protection /
-				cgroup_size;
+				(cgroup_size + 1);
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index f4fea28e05da..3ec1a51a6944 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
 
 static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 {
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
 	u32 size = p9_req->tc.size;
@@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 			break;
 	}
 	read_unlock(&xen_9pfs_lock);
-	if (!priv || priv->client != client)
+	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
 		return -EINVAL;
 
 	num = p9_req->tc.tag % priv->num_rings;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 62c99e015609..89f37f26f253 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -40,6 +40,8 @@
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
 
+#define secs_to_jiffies(_secs) msecs_to_jiffies((_secs) * 1000)
+
 /* Handle HCI Event packets */
 
 static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb,
@@ -1171,6 +1173,12 @@ static void hci_cc_le_set_random_addr(struct hci_dev *hdev, struct sk_buff *skb)
 
 	bacpy(&hdev->random_addr, sent);
 
+	if (!bacmp(&hdev->rpa, sent)) {
+		hci_dev_clear_flag(hdev, HCI_RPA_EXPIRED);
+		queue_delayed_work(hdev->workqueue, &hdev->rpa_expired,
+				   secs_to_jiffies(hdev->rpa_timeout));
+	}
+
 	hci_dev_unlock(hdev);
 }
 
@@ -1201,24 +1209,30 @@ static void hci_cc_le_set_adv_set_random_addr(struct hci_dev *hdev,
 {
 	__u8 status = *((__u8 *) skb->data);
 	struct hci_cp_le_set_adv_set_rand_addr *cp;
-	struct adv_info *adv_instance;
+	struct adv_info *adv;
 
 	if (status)
 		return;
 
 	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_ADV_SET_RAND_ADDR);
-	if (!cp)
+	/* Update only in case the adv instance since handle 0x00 shall be using
+	 * HCI_OP_LE_SET_RANDOM_ADDR since that allows both extended and
+	 * non-extended adverting.
+	 */
+	if (!cp || !cp->handle)
 		return;
 
 	hci_dev_lock(hdev);
 
-	if (!cp->handle) {
-		/* Store in hdev for instance 0 (Set adv and Directed advs) */
-		bacpy(&hdev->random_addr, &cp->bdaddr);
-	} else {
-		adv_instance = hci_find_adv_instance(hdev, cp->handle);
-		if (adv_instance)
-			bacpy(&adv_instance->random_addr, &cp->bdaddr);
+	adv = hci_find_adv_instance(hdev, cp->handle);
+	if (adv) {
+		bacpy(&adv->random_addr, &cp->bdaddr);
+		if (!bacmp(&hdev->rpa, &cp->bdaddr)) {
+			adv->rpa_expired = false;
+			queue_delayed_work(hdev->workqueue,
+					   &adv->rpa_expired_cb,
+					   secs_to_jiffies(hdev->rpa_timeout));
+		}
 	}
 
 	hci_dev_unlock(hdev);
@@ -4373,6 +4387,21 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 
 	switch (ev->status) {
 	case 0x00:
+		/* The synchronous connection complete event should only be
+		 * sent once per new connection. Receiving a successful
+		 * complete event when the connection status is already
+		 * BT_CONNECTED means that the device is misbehaving and sent
+		 * multiple complete event packets for the same new connection.
+		 *
+		 * Registering the device more than once can corrupt kernel
+		 * memory, hence upon detecting this invalid event, we report
+		 * an error and ignore the packet.
+		 */
+		if (conn->state == BT_CONNECTED) {
+			bt_dev_err(hdev, "Ignoring connect complete event for existing connection");
+			goto unlock;
+		}
+
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
@@ -5095,9 +5124,64 @@ static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 }
 #endif
 
+static void le_conn_update_addr(struct hci_conn *conn, bdaddr_t *bdaddr,
+				u8 bdaddr_type, bdaddr_t *local_rpa)
+{
+	if (conn->out) {
+		conn->dst_type = bdaddr_type;
+		conn->resp_addr_type = bdaddr_type;
+		bacpy(&conn->resp_addr, bdaddr);
+
+		/* Check if the controller has set a Local RPA then it must be
+		 * used instead or hdev->rpa.
+		 */
+		if (local_rpa && bacmp(local_rpa, BDADDR_ANY)) {
+			conn->init_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->init_addr, local_rpa);
+		} else if (hci_dev_test_flag(conn->hdev, HCI_PRIVACY)) {
+			conn->init_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->init_addr, &conn->hdev->rpa);
+		} else {
+			hci_copy_identity_address(conn->hdev, &conn->init_addr,
+						  &conn->init_addr_type);
+		}
+	} else {
+		conn->resp_addr_type = conn->hdev->adv_addr_type;
+		/* Check if the controller has set a Local RPA then it must be
+		 * used instead or hdev->rpa.
+		 */
+		if (local_rpa && bacmp(local_rpa, BDADDR_ANY)) {
+			conn->resp_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->resp_addr, local_rpa);
+		} else if (conn->hdev->adv_addr_type == ADDR_LE_DEV_RANDOM) {
+			/* In case of ext adv, resp_addr will be updated in
+			 * Adv Terminated event.
+			 */
+			if (!ext_adv_capable(conn->hdev))
+				bacpy(&conn->resp_addr,
+				      &conn->hdev->random_addr);
+		} else {
+			bacpy(&conn->resp_addr, &conn->hdev->bdaddr);
+		}
+
+		conn->init_addr_type = bdaddr_type;
+		bacpy(&conn->init_addr, bdaddr);
+
+		/* For incoming connections, set the default minimum
+		 * and maximum connection interval. They will be used
+		 * to check if the parameters are in range and if not
+		 * trigger the connection update procedure.
+		 */
+		conn->le_conn_min_interval = conn->hdev->le_conn_min_interval;
+		conn->le_conn_max_interval = conn->hdev->le_conn_max_interval;
+	}
+}
+
 static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
-			bdaddr_t *bdaddr, u8 bdaddr_type, u8 role, u16 handle,
-			u16 interval, u16 latency, u16 supervision_timeout)
+				 bdaddr_t *bdaddr, u8 bdaddr_type,
+				 bdaddr_t *local_rpa, u8 role, u16 handle,
+				 u16 interval, u16 latency,
+				 u16 supervision_timeout)
 {
 	struct hci_conn_params *params;
 	struct hci_conn *conn;
@@ -5145,32 +5229,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		cancel_delayed_work(&conn->le_conn_timeout);
 	}
 
-	if (!conn->out) {
-		/* Set the responder (our side) address type based on
-		 * the advertising address type.
-		 */
-		conn->resp_addr_type = hdev->adv_addr_type;
-		if (hdev->adv_addr_type == ADDR_LE_DEV_RANDOM) {
-			/* In case of ext adv, resp_addr will be updated in
-			 * Adv Terminated event.
-			 */
-			if (!ext_adv_capable(hdev))
-				bacpy(&conn->resp_addr, &hdev->random_addr);
-		} else {
-			bacpy(&conn->resp_addr, &hdev->bdaddr);
-		}
-
-		conn->init_addr_type = bdaddr_type;
-		bacpy(&conn->init_addr, bdaddr);
-
-		/* For incoming connections, set the default minimum
-		 * and maximum connection interval. They will be used
-		 * to check if the parameters are in range and if not
-		 * trigger the connection update procedure.
-		 */
-		conn->le_conn_min_interval = hdev->le_conn_min_interval;
-		conn->le_conn_max_interval = hdev->le_conn_max_interval;
-	}
+	le_conn_update_addr(conn, bdaddr, bdaddr_type, local_rpa);
 
 	/* Lookup the identity address from the stored connection
 	 * address and address type.
@@ -5264,7 +5323,7 @@ static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
-			     ev->role, le16_to_cpu(ev->handle),
+			     NULL, ev->role, le16_to_cpu(ev->handle),
 			     le16_to_cpu(ev->interval),
 			     le16_to_cpu(ev->latency),
 			     le16_to_cpu(ev->supervision_timeout));
@@ -5278,7 +5337,7 @@ static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
-			     ev->role, le16_to_cpu(ev->handle),
+			     &ev->local_rpa, ev->role, le16_to_cpu(ev->handle),
 			     le16_to_cpu(ev->interval),
 			     le16_to_cpu(ev->latency),
 			     le16_to_cpu(ev->supervision_timeout));
@@ -5314,7 +5373,8 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (conn) {
 		struct adv_info *adv_instance;
 
-		if (hdev->adv_addr_type != ADDR_LE_DEV_RANDOM)
+		if (hdev->adv_addr_type != ADDR_LE_DEV_RANDOM ||
+		    bacmp(&conn->resp_addr, BDADDR_ANY))
 			return;
 
 		if (!ev->handle) {
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index b069f640394d..477519ab63b8 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -2053,8 +2053,6 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 	 * current RPA has expired then generate a new one.
 	 */
 	if (use_rpa) {
-		int to;
-
 		/* If Controller supports LL Privacy use own address type is
 		 * 0x03
 		 */
@@ -2065,14 +2063,10 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 			*own_addr_type = ADDR_LE_DEV_RANDOM;
 
 		if (adv_instance) {
-			if (!adv_instance->rpa_expired &&
-			    !bacmp(&adv_instance->random_addr, &hdev->rpa))
+			if (adv_rpa_valid(adv_instance))
 				return 0;
-
-			adv_instance->rpa_expired = false;
 		} else {
-			if (!hci_dev_test_and_clear_flag(hdev, HCI_RPA_EXPIRED) &&
-			    !bacmp(&hdev->random_addr, &hdev->rpa))
+			if (rpa_valid(hdev))
 				return 0;
 		}
 
@@ -2084,14 +2078,6 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 
 		bacpy(rand_addr, &hdev->rpa);
 
-		to = msecs_to_jiffies(hdev->rpa_timeout * 1000);
-		if (adv_instance)
-			queue_delayed_work(hdev->workqueue,
-					   &adv_instance->rpa_expired_cb, to);
-		else
-			queue_delayed_work(hdev->workqueue,
-					   &hdev->rpa_expired, to);
-
 		return 0;
 	}
 
@@ -2134,6 +2120,30 @@ void __hci_req_clear_ext_adv_sets(struct hci_request *req)
 	hci_req_add(req, HCI_OP_LE_CLEAR_ADV_SETS, 0, NULL);
 }
 
+static void set_random_addr(struct hci_request *req, bdaddr_t *rpa)
+{
+	struct hci_dev *hdev = req->hdev;
+
+	/* If we're advertising or initiating an LE connection we can't
+	 * go ahead and change the random address at this time. This is
+	 * because the eventual initiator address used for the
+	 * subsequently created connection will be undefined (some
+	 * controllers use the new address and others the one we had
+	 * when the operation started).
+	 *
+	 * In this kind of scenario skip the update and let the random
+	 * address be updated at the next cycle.
+	 */
+	if (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
+	    hci_lookup_le_connect(hdev)) {
+		bt_dev_dbg(hdev, "Deferring random address update");
+		hci_dev_set_flag(hdev, HCI_RPA_EXPIRED);
+		return;
+	}
+
+	hci_req_add(req, HCI_OP_LE_SET_RANDOM_ADDR, 6, rpa);
+}
+
 int __hci_req_setup_ext_adv_instance(struct hci_request *req, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
@@ -2236,6 +2246,13 @@ int __hci_req_setup_ext_adv_instance(struct hci_request *req, u8 instance)
 		} else {
 			if (!bacmp(&random_addr, &hdev->random_addr))
 				return 0;
+			/* Instance 0x00 doesn't have an adv_info, instead it
+			 * uses hdev->random_addr to track its address so
+			 * whenever it needs to be updated this also set the
+			 * random address since hdev->random_addr is shared with
+			 * scan state machine.
+			 */
+			set_random_addr(req, &random_addr);
 		}
 
 		memset(&cp, 0, sizeof(cp));
@@ -2493,30 +2510,6 @@ void hci_req_clear_adv_instance(struct hci_dev *hdev, struct sock *sk,
 						false);
 }
 
-static void set_random_addr(struct hci_request *req, bdaddr_t *rpa)
-{
-	struct hci_dev *hdev = req->hdev;
-
-	/* If we're advertising or initiating an LE connection we can't
-	 * go ahead and change the random address at this time. This is
-	 * because the eventual initiator address used for the
-	 * subsequently created connection will be undefined (some
-	 * controllers use the new address and others the one we had
-	 * when the operation started).
-	 *
-	 * In this kind of scenario skip the update and let the random
-	 * address be updated at the next cycle.
-	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
-	    hci_lookup_le_connect(hdev)) {
-		bt_dev_dbg(hdev, "Deferring random address update");
-		hci_dev_set_flag(hdev, HCI_RPA_EXPIRED);
-		return;
-	}
-
-	hci_req_add(req, HCI_OP_LE_SET_RANDOM_ADDR, 6, rpa);
-}
-
 int hci_update_random_address(struct hci_request *req, bool require_privacy,
 			      bool use_rpa, u8 *own_addr_type)
 {
@@ -2528,8 +2521,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	 * the current RPA in use, then generate a new one.
 	 */
 	if (use_rpa) {
-		int to;
-
 		/* If Controller supports LL Privacy use own address type is
 		 * 0x03
 		 */
@@ -2539,8 +2530,7 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 		else
 			*own_addr_type = ADDR_LE_DEV_RANDOM;
 
-		if (!hci_dev_test_and_clear_flag(hdev, HCI_RPA_EXPIRED) &&
-		    !bacmp(&hdev->random_addr, &hdev->rpa))
+		if (rpa_valid(hdev))
 			return 0;
 
 		err = smp_generate_rpa(hdev, hdev->irk, &hdev->rpa);
@@ -2551,9 +2541,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 
 		set_random_addr(req, &hdev->rpa);
 
-		to = msecs_to_jiffies(hdev->rpa_timeout * 1000);
-		queue_delayed_work(hdev->workqueue, &hdev->rpa_expired, to);
-
 		return 0;
 	}
 
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 9769a7ceb689..bd0d616dbc37 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -48,6 +48,8 @@ struct sco_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
+	struct delayed_work	timeout_work;
+
 	unsigned int    mtu;
 };
 
@@ -74,9 +76,20 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
-static void sco_sock_timeout(struct timer_list *t)
+static void sco_sock_timeout(struct work_struct *work)
 {
-	struct sock *sk = from_timer(sk, t, sk_timer);
+	struct sco_conn *conn = container_of(work, struct sco_conn,
+					     timeout_work.work);
+	struct sock *sk;
+
+	sco_conn_lock(conn);
+	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
+	sco_conn_unlock(conn);
+
+	if (!sk)
+		return;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
@@ -90,14 +103,21 @@ static void sco_sock_timeout(struct timer_list *t)
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
+	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
 }
 
 /* ---- SCO connections ---- */
@@ -177,6 +197,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
 		sock_put(sk);
+
+		/* Ensure no more work items will run before freeing conn. */
+		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
 	hcon->sco_data = NULL;
@@ -191,6 +214,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
+
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
@@ -210,44 +235,32 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	return err;
 }
 
-static int sco_connect(struct sock *sk)
+static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 {
 	struct sco_conn *conn;
 	struct hci_conn *hcon;
-	struct hci_dev  *hdev;
 	int err, type;
 
 	BT_DBG("%pMR -> %pMR", &sco_pi(sk)->src, &sco_pi(sk)->dst);
 
-	hdev = hci_get_route(&sco_pi(sk)->dst, &sco_pi(sk)->src, BDADDR_BREDR);
-	if (!hdev)
-		return -EHOSTUNREACH;
-
-	hci_dev_lock(hdev);
-
 	if (lmp_esco_capable(hdev) && !disable_esco)
 		type = ESCO_LINK;
 	else
 		type = SCO_LINK;
 
 	if (sco_pi(sk)->setting == BT_VOICE_TRANSPARENT &&
-	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev))) {
-		err = -EOPNOTSUPP;
-		goto done;
-	}
+	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev)))
+		return -EOPNOTSUPP;
 
 	hcon = hci_connect_sco(hdev, type, &sco_pi(sk)->dst,
 			       sco_pi(sk)->setting);
-	if (IS_ERR(hcon)) {
-		err = PTR_ERR(hcon);
-		goto done;
-	}
+	if (IS_ERR(hcon))
+		return PTR_ERR(hcon);
 
 	conn = sco_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
-		err = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
 	/* Update source addr of the socket */
@@ -255,7 +268,7 @@ static int sco_connect(struct sock *sk)
 
 	err = sco_chan_add(conn, sk, NULL);
 	if (err)
-		goto done;
+		return err;
 
 	if (hcon->state == BT_CONNECTED) {
 		sco_sock_clear_timer(sk);
@@ -265,9 +278,6 @@ static int sco_connect(struct sock *sk)
 		sco_sock_set_timer(sk, sk->sk_sndtimeo);
 	}
 
-done:
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
 	return err;
 }
 
@@ -496,8 +506,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }
@@ -562,6 +570,7 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 {
 	struct sockaddr_sco *sa = (struct sockaddr_sco *) addr;
 	struct sock *sk = sock->sk;
+	struct hci_dev  *hdev;
 	int err;
 
 	BT_DBG("sk %p", sk);
@@ -576,12 +585,19 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	if (sk->sk_type != SOCK_SEQPACKET)
 		return -EINVAL;
 
+	hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
+	if (!hdev)
+		return -EHOSTUNREACH;
+	hci_dev_lock(hdev);
+
 	lock_sock(sk);
 
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 
-	err = sco_connect(sk);
+	err = sco_connect(hdev, sk);
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 	if (err)
 		goto done;
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3ed7c98a98e1..6076c75706d0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1056,8 +1056,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v4addrs, &iph->saddr,
-			       sizeof(key_addrs->v4addrs));
+			memcpy(&key_addrs->v4addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v4addrs.src));
+			memcpy(&key_addrs->v4addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v4addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
@@ -1101,8 +1103,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v6addrs, &iph->saddr,
-			       sizeof(key_addrs->v6addrs));
+			memcpy(&key_addrs->v6addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v6addrs.src));
+			memcpy(&key_addrs->v6addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v6addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		}
 
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..e3f0d5906811 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -321,6 +321,7 @@ EXPORT_SYMBOL(flow_block_cb_setup_simple);
 static DEFINE_MUTEX(flow_indr_block_lock);
 static LIST_HEAD(flow_block_indr_list);
 static LIST_HEAD(flow_block_indr_dev_list);
+static LIST_HEAD(flow_indir_dev_list);
 
 struct flow_indr_dev {
 	struct list_head		list;
@@ -346,6 +347,33 @@ static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
 	return indr_dev;
 }
 
+struct flow_indir_dev_info {
+	void *data;
+	struct net_device *dev;
+	struct Qdisc *sch;
+	enum tc_setup_type type;
+	void (*cleanup)(struct flow_block_cb *block_cb);
+	struct list_head list;
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct list_head *cb_list;
+};
+
+static void existing_qdiscs_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
+{
+	struct flow_block_offload bo;
+	struct flow_indir_dev_info *cur;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		memset(&bo, 0, sizeof(bo));
+		bo.command = cur->command;
+		bo.binder_type = cur->binder_type;
+		INIT_LIST_HEAD(&bo.cb_list);
+		cb(cur->dev, cur->sch, cb_priv, cur->type, &bo, cur->data, cur->cleanup);
+		list_splice(&bo.cb_list, cur->cb_list);
+	}
+}
+
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_indr_dev *indr_dev;
@@ -367,6 +395,7 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	}
 
 	list_add(&indr_dev->list, &flow_block_indr_dev_list);
+	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
 	return 0;
@@ -463,7 +492,59 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
+static struct flow_indir_dev_info *find_indir_dev(void *data)
+{
+	struct flow_indir_dev_info *cur;
+
+	list_for_each_entry(cur, &flow_indir_dev_list, list) {
+		if (cur->data == data)
+			return cur;
+	}
+	return NULL;
+}
+
+static int indir_dev_add(void *data, struct net_device *dev, struct Qdisc *sch,
+			 enum tc_setup_type type, void (*cleanup)(struct flow_block_cb *block_cb),
+			 struct flow_block_offload *bo)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (info)
+		return -EEXIST;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->data = data;
+	info->dev = dev;
+	info->sch = sch;
+	info->type = type;
+	info->cleanup = cleanup;
+	info->command = bo->command;
+	info->binder_type = bo->binder_type;
+	info->cb_list = bo->cb_list_head;
+
+	list_add(&info->list, &flow_indir_dev_list);
+	return 0;
+}
+
+static int indir_dev_remove(void *data)
+{
+	struct flow_indir_dev_info *info;
+
+	info = find_indir_dev(data);
+	if (!info)
+		return -ENOENT;
+
+	list_del(&info->list);
+
+	kfree(info);
+	return 0;
+}
+
+int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb))
@@ -471,6 +552,12 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 	struct flow_indr_dev *this;
 
 	mutex_lock(&flow_indr_block_lock);
+
+	if (bo->command == FLOW_BLOCK_BIND)
+		indir_dev_add(data, dev, sch, type, cleanup, bo);
+	else if (bo->command == FLOW_BLOCK_UNBIND)
+		indir_dev_remove(data);
+
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
 		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index baa5d10043cb..6134b180f59f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -7,6 +7,7 @@
  * the information ethtool needs.
  */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/capability.h>
@@ -807,6 +808,120 @@ static noinline_for_stack int ethtool_get_sset_info(struct net_device *dev,
 	return ret;
 }
 
+static noinline_for_stack int
+ethtool_rxnfc_copy_from_compat(struct ethtool_rxnfc *rxnfc,
+			       const struct compat_ethtool_rxnfc __user *useraddr,
+			       size_t size)
+{
+	struct compat_ethtool_rxnfc crxnfc = {};
+
+	/* We expect there to be holes between fs.m_ext and
+	 * fs.ring_cookie and at the end of fs, but nowhere else.
+	 * On non-x86, no conversion should be needed.
+	 */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_X86_64) &&
+		     sizeof(struct compat_ethtool_rxnfc) !=
+		     sizeof(struct ethtool_rxnfc));
+	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
+		     sizeof(useraddr->fs.m_ext) !=
+		     offsetof(struct ethtool_rxnfc, fs.m_ext) +
+		     sizeof(rxnfc->fs.m_ext));
+	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.location) -
+		     offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
+		     offsetof(struct ethtool_rxnfc, fs.location) -
+		     offsetof(struct ethtool_rxnfc, fs.ring_cookie));
+
+	if (copy_from_user(&crxnfc, useraddr, min(size, sizeof(crxnfc))))
+		return -EFAULT;
+
+	*rxnfc = (struct ethtool_rxnfc) {
+		.cmd		= crxnfc.cmd,
+		.flow_type	= crxnfc.flow_type,
+		.data		= crxnfc.data,
+		.fs		= {
+			.flow_type	= crxnfc.fs.flow_type,
+			.h_u		= crxnfc.fs.h_u,
+			.h_ext		= crxnfc.fs.h_ext,
+			.m_u		= crxnfc.fs.m_u,
+			.m_ext		= crxnfc.fs.m_ext,
+			.ring_cookie	= crxnfc.fs.ring_cookie,
+			.location	= crxnfc.fs.location,
+		},
+		.rule_cnt	= crxnfc.rule_cnt,
+	};
+
+	return 0;
+}
+
+static int ethtool_rxnfc_copy_from_user(struct ethtool_rxnfc *rxnfc,
+					const void __user *useraddr,
+					size_t size)
+{
+	if (compat_need_64bit_alignment_fixup())
+		return ethtool_rxnfc_copy_from_compat(rxnfc, useraddr, size);
+
+	if (copy_from_user(rxnfc, useraddr, size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ethtool_rxnfc_copy_to_compat(void __user *useraddr,
+					const struct ethtool_rxnfc *rxnfc,
+					size_t size, const u32 *rule_buf)
+{
+	struct compat_ethtool_rxnfc crxnfc;
+
+	memset(&crxnfc, 0, sizeof(crxnfc));
+	crxnfc = (struct compat_ethtool_rxnfc) {
+		.cmd		= rxnfc->cmd,
+		.flow_type	= rxnfc->flow_type,
+		.data		= rxnfc->data,
+		.fs		= {
+			.flow_type	= rxnfc->fs.flow_type,
+			.h_u		= rxnfc->fs.h_u,
+			.h_ext		= rxnfc->fs.h_ext,
+			.m_u		= rxnfc->fs.m_u,
+			.m_ext		= rxnfc->fs.m_ext,
+			.ring_cookie	= rxnfc->fs.ring_cookie,
+			.location	= rxnfc->fs.location,
+		},
+		.rule_cnt	= rxnfc->rule_cnt,
+	};
+
+	if (copy_to_user(useraddr, &crxnfc, min(size, sizeof(crxnfc))))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
+				      const struct ethtool_rxnfc *rxnfc,
+				      size_t size, const u32 *rule_buf)
+{
+	int ret;
+
+	if (compat_need_64bit_alignment_fixup()) {
+		ret = ethtool_rxnfc_copy_to_compat(useraddr, rxnfc, size,
+						   rule_buf);
+		useraddr += offsetof(struct compat_ethtool_rxnfc, rule_locs);
+	} else {
+		ret = copy_to_user(useraddr, &rxnfc, size);
+		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
+	}
+
+	if (ret)
+		return -EFAULT;
+
+	if (rule_buf) {
+		if (copy_to_user(useraddr, rule_buf,
+				 rxnfc->rule_cnt * sizeof(u32)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 						u32 cmd, void __user *useraddr)
 {
@@ -825,7 +940,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		info_size = (offsetof(struct ethtool_rxnfc, data) +
 			     sizeof(info.data));
 
-	if (copy_from_user(&info, useraddr, info_size))
+	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
 	rc = dev->ethtool_ops->set_rxnfc(dev, &info);
@@ -833,7 +948,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		return rc;
 
 	if (cmd == ETHTOOL_SRXCLSRLINS &&
-	    copy_to_user(useraddr, &info, info_size))
+	    ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL))
 		return -EFAULT;
 
 	return 0;
@@ -859,7 +974,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 		info_size = (offsetof(struct ethtool_rxnfc, data) +
 			     sizeof(info.data));
 
-	if (copy_from_user(&info, useraddr, info_size))
+	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
 	/* If FLOW_RSS was requested then user-space must be using the
@@ -867,7 +982,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 	 */
 	if (cmd == ETHTOOL_GRXFH && info.flow_type & FLOW_RSS) {
 		info_size = sizeof(info);
-		if (copy_from_user(&info, useraddr, info_size))
+		if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 			return -EFAULT;
 		/* Since malicious users may modify the original data,
 		 * we need to check whether FLOW_RSS is still requested.
@@ -893,18 +1008,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 	if (ret < 0)
 		goto err_out;
 
-	ret = -EFAULT;
-	if (copy_to_user(useraddr, &info, info_size))
-		goto err_out;
-
-	if (rule_buf) {
-		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
-		if (copy_to_user(useraddr, rule_buf,
-				 info.rule_cnt * sizeof(u32)))
-			goto err_out;
-	}
-	ret = 0;
-
+	ret = ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, rule_buf);
 err_out:
 	kfree(rule_buf);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8d8a8da3ae7e..a202dcec0dc2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -446,8 +446,9 @@ static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 {
 	BUILD_BUG_ON(offsetof(typeof(*fl4), daddr) !=
 		     offsetof(typeof(*fl4), saddr) + sizeof(fl4->saddr));
-	memcpy(&iph->saddr, &fl4->saddr,
-	       sizeof(fl4->saddr) + sizeof(fl4->daddr));
+
+	iph->saddr = fl4->saddr;
+	iph->daddr = fl4->daddr;
 }
 
 /* Note: skb->sk can be different from sk, in case of tunnels */
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index d49709ba8e16..107111984384 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -379,8 +379,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (syn_data &&
-	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
+	if (tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;
 
 	if (foc->len == 0) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 137fa4c50e07..8df7ab34911c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1985,9 +1985,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
-		/* MTU range: 256 - 2304 */
+		/* MTU range is normally 256 - 2304, where the upper limit is
+		 * the maximum MSDU size. Monitor interfaces send and receive
+		 * MPDU and A-MSDU frames which may be much larger so we do
+		 * not impose an upper limit in that case.
+		 */
 		ndev->min_mtu = 256;
-		ndev->max_mtu = local->hw.max_mtu;
+		if (type == NL80211_IFTYPE_MONITOR)
+			ndev->max_mtu = 0;
+		else
+			ndev->max_mtu = local->hw.max_mtu;
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 528b2f172684..0587f071e504 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1097,6 +1097,7 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &flowtable->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b58d73a96523..9656c1646222 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -353,6 +353,7 @@ static void nft_flow_block_offload_init(struct flow_block_offload *bo,
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->cb_list_head = &basechain->flow_block.cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5415ab14400d..31e6da30da5f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -680,14 +680,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
+	ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 out_put:
 	rcu_read_lock();
 	module_put(THIS_MODULE);
-	return ret == -EAGAIN ? -ENOBUFS : ret;
+
+	return ret;
 }
 
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 50f40943c815..f3f1df1b0f8e 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -144,8 +144,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		return -ENOMEM;
 	doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
 	if (doi_def->map.std == NULL) {
-		ret_val = -ENOMEM;
-		goto add_std_failure;
+		kfree(doi_def);
+		return -ENOMEM;
 	}
 	doi_def->type = CIPSO_V4_MAP_TRANS;
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6133e412b948..b9ed16ff09c1 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2545,13 +2545,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		/* errors reported via destination sk->sk_err, but propagate
 		 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */
 		err = nlmsg_multicast(sk, skb, exclude_portid, group, flags);
+		if (err == -ESRCH)
+			err = 0;
 	}
 
 	if (report) {
 		int err2;
 
 		err2 = nlmsg_unicast(sk, skb, portid);
-		if (!err || err == -ESRCH)
+		if (!err)
 			err = err2;
 	}
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e3e79e9bd706..9b276d14be4c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -634,6 +634,7 @@ static void tcf_block_offload_init(struct flow_block_offload *bo,
 	bo->block_shared = shared;
 	bo->extack = extack;
 	bo->sch = sch;
+	bo->cb_list_head = &flow_block->cb_list;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5c91df52b8c2..b0d6385fff9e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1547,7 +1547,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	taprio_set_picos_per_byte(dev, q);
 
 	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
 		for (i = 0; i < mqprio->num_tc; i++)
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
diff --git a/net/socket.c b/net/socket.c
index 877f1fb61719..caac290ba7ec 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3099,128 +3099,6 @@ static int compat_dev_ifconf(struct net *net, struct compat_ifconf __user *uifc3
 	return 0;
 }
 
-static int ethtool_ioctl(struct net *net, struct compat_ifreq __user *ifr32)
-{
-	struct compat_ethtool_rxnfc __user *compat_rxnfc;
-	bool convert_in = false, convert_out = false;
-	size_t buf_size = 0;
-	struct ethtool_rxnfc __user *rxnfc = NULL;
-	struct ifreq ifr;
-	u32 rule_cnt = 0, actual_rule_cnt;
-	u32 ethcmd;
-	u32 data;
-	int ret;
-
-	if (get_user(data, &ifr32->ifr_ifru.ifru_data))
-		return -EFAULT;
-
-	compat_rxnfc = compat_ptr(data);
-
-	if (get_user(ethcmd, &compat_rxnfc->cmd))
-		return -EFAULT;
-
-	/* Most ethtool structures are defined without padding.
-	 * Unfortunately struct ethtool_rxnfc is an exception.
-	 */
-	switch (ethcmd) {
-	default:
-		break;
-	case ETHTOOL_GRXCLSRLALL:
-		/* Buffer size is variable */
-		if (get_user(rule_cnt, &compat_rxnfc->rule_cnt))
-			return -EFAULT;
-		if (rule_cnt > KMALLOC_MAX_SIZE / sizeof(u32))
-			return -ENOMEM;
-		buf_size += rule_cnt * sizeof(u32);
-		fallthrough;
-	case ETHTOOL_GRXRINGS:
-	case ETHTOOL_GRXCLSRLCNT:
-	case ETHTOOL_GRXCLSRULE:
-	case ETHTOOL_SRXCLSRLINS:
-		convert_out = true;
-		fallthrough;
-	case ETHTOOL_SRXCLSRLDEL:
-		buf_size += sizeof(struct ethtool_rxnfc);
-		convert_in = true;
-		rxnfc = compat_alloc_user_space(buf_size);
-		break;
-	}
-
-	if (copy_from_user(&ifr.ifr_name, &ifr32->ifr_name, IFNAMSIZ))
-		return -EFAULT;
-
-	ifr.ifr_data = convert_in ? rxnfc : (void __user *)compat_rxnfc;
-
-	if (convert_in) {
-		/* We expect there to be holes between fs.m_ext and
-		 * fs.ring_cookie and at the end of fs, but nowhere else.
-		 */
-		BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
-			     sizeof(compat_rxnfc->fs.m_ext) !=
-			     offsetof(struct ethtool_rxnfc, fs.m_ext) +
-			     sizeof(rxnfc->fs.m_ext));
-		BUILD_BUG_ON(
-			offsetof(struct compat_ethtool_rxnfc, fs.location) -
-			offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
-			offsetof(struct ethtool_rxnfc, fs.location) -
-			offsetof(struct ethtool_rxnfc, fs.ring_cookie));
-
-		if (copy_in_user(rxnfc, compat_rxnfc,
-				 (void __user *)(&rxnfc->fs.m_ext + 1) -
-				 (void __user *)rxnfc) ||
-		    copy_in_user(&rxnfc->fs.ring_cookie,
-				 &compat_rxnfc->fs.ring_cookie,
-				 (void __user *)(&rxnfc->fs.location + 1) -
-				 (void __user *)&rxnfc->fs.ring_cookie))
-			return -EFAULT;
-		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
-			if (put_user(rule_cnt, &rxnfc->rule_cnt))
-				return -EFAULT;
-		} else if (copy_in_user(&rxnfc->rule_cnt,
-					&compat_rxnfc->rule_cnt,
-					sizeof(rxnfc->rule_cnt)))
-			return -EFAULT;
-	}
-
-	ret = dev_ioctl(net, SIOCETHTOOL, &ifr, NULL);
-	if (ret)
-		return ret;
-
-	if (convert_out) {
-		if (copy_in_user(compat_rxnfc, rxnfc,
-				 (const void __user *)(&rxnfc->fs.m_ext + 1) -
-				 (const void __user *)rxnfc) ||
-		    copy_in_user(&compat_rxnfc->fs.ring_cookie,
-				 &rxnfc->fs.ring_cookie,
-				 (const void __user *)(&rxnfc->fs.location + 1) -
-				 (const void __user *)&rxnfc->fs.ring_cookie) ||
-		    copy_in_user(&compat_rxnfc->rule_cnt, &rxnfc->rule_cnt,
-				 sizeof(rxnfc->rule_cnt)))
-			return -EFAULT;
-
-		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
-			/* As an optimisation, we only copy the actual
-			 * number of rules that the underlying
-			 * function returned.  Since Mallory might
-			 * change the rule count in user memory, we
-			 * check that it is less than the rule count
-			 * originally given (as the user buffer size),
-			 * which has been range-checked.
-			 */
-			if (get_user(actual_rule_cnt, &rxnfc->rule_cnt))
-				return -EFAULT;
-			if (actual_rule_cnt < rule_cnt)
-				rule_cnt = actual_rule_cnt;
-			if (copy_in_user(&compat_rxnfc->rule_locs[0],
-					 &rxnfc->rule_locs[0],
-					 rule_cnt * sizeof(u32)))
-				return -EFAULT;
-		}
-	}
-
-	return 0;
-}
-
 static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32)
 {
 	compat_uptr_t uptr32;
@@ -3377,8 +3255,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return old_bridge_ioctl(argp);
 	case SIOCGIFCONF:
 		return compat_dev_ifconf(net, argp);
-	case SIOCETHTOOL:
-		return ethtool_ioctl(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
 	case SIOCGIFMAP:
@@ -3391,6 +3267,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return sock->ops->gettstamp(sock, argp, cmd == SIOCGSTAMP_OLD,
 					    !COMPAT_USE_64BIT_TIME);
 
+	case SIOCETHTOOL:
 	case SIOCBONDSLAVEINFOQUERY:
 	case SIOCBONDINFOQUERY:
 	case SIOCSHWTSTAMP:
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 6dff64374bfe..e22f2d65457d 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1980,7 +1980,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 3509a7f139b9..8d3983c8b4d6 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -774,9 +774,9 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
 	/* Try to schedule an autoclose RPC call */
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	else if (xprt->snd_task)
+	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
 		rpc_wake_up_queued_task_set_status(&xprt->pending,
-				xprt->snd_task, -ENOTCONN);
+						   xprt->snd_task, -ENOTCONN);
 	spin_unlock(&xprt->transport_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_force_disconnect);
@@ -865,12 +865,14 @@ bool xprt_lock_connect(struct rpc_xprt *xprt,
 		goto out;
 	if (xprt->snd_task != task)
 		goto out;
+	set_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->snd_task = cookie;
 	ret = true;
 out:
 	spin_unlock(&xprt->transport_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xprt_lock_connect);
 
 void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 {
@@ -880,12 +882,14 @@ void xprt_unlock_connect(struct rpc_xprt *xprt, void *cookie)
 	if (!test_bit(XPRT_LOCKED, &xprt->state))
 		goto out;
 	xprt->snd_task =NULL;
+	clear_bit(XPRT_SND_IS_COOKIE, &xprt->state);
 	xprt->ops->release_xprt(xprt, NULL);
 	xprt_schedule_autodisconnect(xprt);
 out:
 	spin_unlock(&xprt->transport_lock);
 	wake_up_bit(&xprt->state, XPRT_LOCKED);
 }
+EXPORT_SYMBOL_GPL(xprt_unlock_connect);
 
 /**
  * xprt_connect - schedule a transport connect operation
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 19a49d26b1e4..d2052f06acfa 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -249,12 +249,9 @@ xprt_rdma_connect_worker(struct work_struct *work)
 					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
 		rc = -EAGAIN;
-	} else {
-		/* Force a call to xprt_rdma_close to clean up */
-		spin_lock(&xprt->transport_lock);
-		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-		spin_unlock(&xprt->transport_lock);
-	}
+	} else
+		rpcrdma_xprt_disconnect(r_xprt);
+	xprt_unlock_connect(xprt, r_xprt);
 	xprt_wake_pending_tasks(xprt, rc);
 }
 
@@ -487,6 +484,8 @@ xprt_rdma_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 	struct rpcrdma_ep *ep = r_xprt->rx_ep;
 	unsigned long delay;
 
+	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, r_xprt));
+
 	delay = 0;
 	if (ep && ep->re_connect_status != 0) {
 		delay = xprt_reconnect_delay(xprt);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 649c23518ec0..5a11e318a0d9 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1416,11 +1416,6 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 
 	rc = ib_post_recv(ep->re_id->qp, wr,
 			  (const struct ib_recv_wr **)&bad_wr);
-	if (atomic_dec_return(&ep->re_receiving) > 0)
-		complete(&ep->re_done);
-
-out:
-	trace_xprtrdma_post_recvs(r_xprt, count, rc);
 	if (rc) {
 		for (wr = bad_wr; wr;) {
 			struct rpcrdma_rep *rep;
@@ -1431,6 +1426,11 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 			--count;
 		}
 	}
+	if (atomic_dec_return(&ep->re_receiving) > 0)
+		complete(&ep->re_done);
+
+out:
+	trace_xprtrdma_post_recvs(r_xprt, count, rc);
 	ep->re_receive_count += count;
 	return;
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 3228b7a1836a..b836b4c322fc 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1648,6 +1648,13 @@ static int xs_get_srcport(struct sock_xprt *transport)
 	return port;
 }
 
+unsigned short get_srcport(struct rpc_xprt *xprt)
+{
+	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
+	return xs_sock_getport(sock->sock);
+}
+EXPORT_SYMBOL(get_srcport);
+
 static unsigned short xs_next_srcport(struct sock_xprt *transport, unsigned short port)
 {
 	if (transport->srcport != 0)
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index a0dce194a404..5d036b9c15d2 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1905,6 +1905,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	bool connected = !tipc_sk_type_connectionless(sk);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	int rc, err, hlen, dlen, copy;
+	struct tipc_skb_cb *skb_cb;
 	struct sk_buff_head xmitq;
 	struct tipc_msg *hdr;
 	struct sk_buff *skb;
@@ -1928,6 +1929,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		if (unlikely(rc))
 			goto exit;
 		skb = skb_peek(&sk->sk_receive_queue);
+		skb_cb = TIPC_SKB_CB(skb);
 		hdr = buf_msg(skb);
 		dlen = msg_data_sz(hdr);
 		hlen = msg_hdr_sz(hdr);
@@ -1947,18 +1949,33 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 
 	/* Capture data if non-error msg, otherwise just set return value */
 	if (likely(!err)) {
-		copy = min_t(int, dlen, buflen);
-		if (unlikely(copy != dlen))
-			m->msg_flags |= MSG_TRUNC;
-		rc = skb_copy_datagram_msg(skb, hlen, m, copy);
+		int offset = skb_cb->bytes_read;
+
+		copy = min_t(int, dlen - offset, buflen);
+		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
+		if (unlikely(rc))
+			goto exit;
+		if (unlikely(offset + copy < dlen)) {
+			if (flags & MSG_EOR) {
+				if (!(flags & MSG_PEEK))
+					skb_cb->bytes_read = offset + copy;
+			} else {
+				m->msg_flags |= MSG_TRUNC;
+				skb_cb->bytes_read = 0;
+			}
+		} else {
+			if (flags & MSG_EOR)
+				m->msg_flags |= MSG_EOR;
+			skb_cb->bytes_read = 0;
+		}
 	} else {
 		copy = 0;
 		rc = 0;
-		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control)
+		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control) {
 			rc = -ECONNRESET;
+			goto exit;
+		}
 	}
-	if (unlikely(rc))
-		goto exit;
 
 	/* Mark message as group event if applicable */
 	if (unlikely(grp_evt)) {
@@ -1981,9 +1998,10 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	tsk_advance_rx_queue(sk);
+	if (!skb_cb->bytes_read)
+		tsk_advance_rx_queue(sk);
 
-	if (likely(!connected))
+	if (likely(!connected) || skb_cb->bytes_read)
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */
diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
index e68b9ee6814b..35db26f736b9 100755
--- a/samples/bpf/test_override_return.sh
+++ b/samples/bpf/test_override_return.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+rm -r tmpmnt
 rm -f testfile.img
 dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
 DEVICE=$(losetup --show -f testfile.img)
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index fdcd6580dd73..8be7ce18d3ba 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -14,6 +14,11 @@ int main(int argc, char **argv)
 	int ret = 0;
 	FILE *f;
 
+	if (!argv[1]) {
+		fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
+		return 0;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index 5adcf954de73..c12198d5bbe5 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -83,7 +83,7 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 done
 
 # Run if user hits control-c
-function control_c() {
+function print_result() {
     # Print results
     for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	dev=${DEV}@${thread}
@@ -92,11 +92,13 @@ function control_c() {
     done
 }
 # trap keyboard interrupt (Ctrl-C)
-trap control_c SIGINT
+trap true SIGINT
 
 if [ -z "$APPEND" ]; then
     echo "Running... ctrl^C to stop" >&2
     pg_ctrl "start"
+
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
diff --git a/scripts/gen_ksymdeps.sh b/scripts/gen_ksymdeps.sh
index 1324986e1362..725e8c9c1b53 100755
--- a/scripts/gen_ksymdeps.sh
+++ b/scripts/gen_ksymdeps.sh
@@ -4,7 +4,13 @@
 set -e
 
 # List of exported symbols
-ksyms=$($NM $1 | sed -n 's/.*__ksym_marker_\(.*\)/\1/p' | tr A-Z a-z)
+#
+# If the object has no symbol, $NM warns 'no symbols'.
+# Suppress the stderr.
+# TODO:
+#   Use -q instead of 2>/dev/null when we upgrade the minimum version of
+#   binutils to 2.37, llvm to 13.0.0.
+ksyms=$($NM $1 2>/dev/null | sed -n 's/.*__ksym_marker_\(.*\)/\1/p' | tr A-Z a-z)
 
 if [ -z "$ksyms" ]; then
 	exit 0
diff --git a/scripts/subarch.include b/scripts/subarch.include
index 650682821126..776849a3c500 100644
--- a/scripts/subarch.include
+++ b/scripts/subarch.include
@@ -7,7 +7,7 @@
 SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
-				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				  -e s/s390x/s390/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
 				  -e s/riscv.*/riscv/)
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 7eabb448acab..169929c6c4eb 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -81,23 +81,22 @@ int log_policy = SMACK_AUDIT_DENIED;
 int smk_access_entry(char *subject_label, char *object_label,
 			struct list_head *rule_list)
 {
-	int may = -ENOENT;
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_object->smk_known == object_label &&
 		    srp->smk_subject->smk_known == subject_label) {
-			may = srp->smk_access;
-			break;
+			int may = srp->smk_access;
+			/*
+			 * MAY_WRITE implies MAY_LOCK.
+			 */
+			if ((may & MAY_WRITE) == MAY_WRITE)
+				may |= MAY_LOCK;
+			return may;
 		}
 	}
 
-	/*
-	 * MAY_WRITE implies MAY_LOCK.
-	 */
-	if ((may & MAY_WRITE) == MAY_WRITE)
-		may |= MAY_LOCK;
-	return may;
+	return -ENOENT;
 }
 
 /**
diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index ec04e3386bc0..8617793ed955 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -11,7 +11,6 @@ if SND_ATMEL_SOC
 
 config SND_ATMEL_SOC_PDC
 	bool
-	depends on HAS_DMA
 
 config SND_ATMEL_SOC_DMA
 	bool
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 22dbd9d93c1e..4bddb969176f 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -290,9 +290,6 @@ static const struct snd_soc_dapm_widget byt_rt5640_widgets[] = {
 static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 	{"Headphone", NULL, "Platform Clock"},
 	{"Headset Mic", NULL, "Platform Clock"},
-	{"Internal Mic", NULL, "Platform Clock"},
-	{"Speaker", NULL, "Platform Clock"},
-
 	{"Headset Mic", NULL, "MICBIAS1"},
 	{"IN2P", NULL, "Headset Mic"},
 	{"Headphone", NULL, "HPOL"},
@@ -300,19 +297,23 @@ static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC1", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic2_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC2", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN1P", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in3_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN3P", NULL, "Internal Mic"},
 };
@@ -354,6 +355,7 @@ static const struct snd_soc_dapm_route byt_rt5640_ssp0_aif2_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 	{"Speaker", NULL, "SPORP"},
@@ -361,6 +363,7 @@ static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_mono_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 };
diff --git a/sound/soc/intel/boards/sof_pcm512x.c b/sound/soc/intel/boards/sof_pcm512x.c
index 8620d4f38493..335c212c1961 100644
--- a/sound/soc/intel/boards/sof_pcm512x.c
+++ b/sound/soc/intel/boards/sof_pcm512x.c
@@ -26,11 +26,16 @@
 
 #define SOF_PCM512X_SSP_CODEC(quirk)		((quirk) & GENMASK(3, 0))
 #define SOF_PCM512X_SSP_CODEC_MASK			(GENMASK(3, 0))
+#define SOF_PCM512X_ENABLE_SSP_CAPTURE		BIT(4)
+#define SOF_PCM512X_ENABLE_DMIC			BIT(5)
 
 #define IDISP_CODEC_MASK	0x4
 
 /* Default: SSP5 */
-static unsigned long sof_pcm512x_quirk = SOF_PCM512X_SSP_CODEC(5);
+static unsigned long sof_pcm512x_quirk =
+	SOF_PCM512X_SSP_CODEC(5) |
+	SOF_PCM512X_ENABLE_SSP_CAPTURE |
+	SOF_PCM512X_ENABLE_DMIC;
 
 static bool is_legacy_cpu;
 
@@ -245,8 +250,9 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 	links[id].dpcm_playback = 1;
 	/*
 	 * capture only supported with specific versions of the Hifiberry DAC+
-	 * links[id].dpcm_capture = 1;
 	 */
+	if (sof_pcm512x_quirk & SOF_PCM512X_ENABLE_SSP_CAPTURE)
+		links[id].dpcm_capture = 1;
 	links[id].no_pcm = 1;
 	links[id].cpus = &cpus[id];
 	links[id].num_cpus = 1;
@@ -381,6 +387,9 @@ static int sof_audio_probe(struct platform_device *pdev)
 
 	ssp_codec = sof_pcm512x_quirk & SOF_PCM512X_SSP_CODEC_MASK;
 
+	if (!(sof_pcm512x_quirk & SOF_PCM512X_ENABLE_DMIC))
+		dmic_be_num = 0;
+
 	/* compute number of dai links */
 	sof_audio_card_pcm512x.num_links = 1 + dmic_be_num + hdmi_num;
 
diff --git a/sound/soc/intel/skylake/skl-messages.c b/sound/soc/intel/skylake/skl-messages.c
index 476ef1897961..79c6cf2c14bf 100644
--- a/sound/soc/intel/skylake/skl-messages.c
+++ b/sound/soc/intel/skylake/skl-messages.c
@@ -802,9 +802,12 @@ static u16 skl_get_module_param_size(struct skl_dev *skl,
 
 	case SKL_MODULE_TYPE_BASE_OUTFMT:
 	case SKL_MODULE_TYPE_MIC_SELECT:
-	case SKL_MODULE_TYPE_KPB:
 		return sizeof(struct skl_base_outfmt_cfg);
 
+	case SKL_MODULE_TYPE_MIXER:
+	case SKL_MODULE_TYPE_KPB:
+		return sizeof(struct skl_base_cfg);
+
 	default:
 		/*
 		 * return only base cfg when no specific module type is
@@ -857,10 +860,14 @@ static int skl_set_module_format(struct skl_dev *skl,
 
 	case SKL_MODULE_TYPE_BASE_OUTFMT:
 	case SKL_MODULE_TYPE_MIC_SELECT:
-	case SKL_MODULE_TYPE_KPB:
 		skl_set_base_outfmt_format(skl, module_config, *param_data);
 		break;
 
+	case SKL_MODULE_TYPE_MIXER:
+	case SKL_MODULE_TYPE_KPB:
+		skl_set_base_module_format(skl, module_config, *param_data);
+		break;
+
 	default:
 		skl_set_base_module_format(skl, module_config, *param_data);
 		break;
diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index b1ca64d2f7ea..031d5dc7e660 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1317,21 +1317,6 @@ static int skl_get_module_info(struct skl_dev *skl,
 		return -EIO;
 	}
 
-	list_for_each_entry(module, &skl->uuid_list, list) {
-		if (guid_equal(uuid_mod, &module->uuid)) {
-			mconfig->id.module_id = module->id;
-			if (mconfig->module)
-				mconfig->module->loadable = module->is_loadable;
-			ret = 0;
-			break;
-		}
-	}
-
-	if (ret)
-		return ret;
-
-	uuid_mod = &module->uuid;
-	ret = -EIO;
 	for (i = 0; i < skl->nr_modules; i++) {
 		skl_module = skl->modules[i];
 		uuid_tplg = &skl_module->uuid;
@@ -1341,10 +1326,18 @@ static int skl_get_module_info(struct skl_dev *skl,
 			break;
 		}
 	}
+
 	if (skl->nr_modules && ret)
 		return ret;
 
+	ret = -EIO;
 	list_for_each_entry(module, &skl->uuid_list, list) {
+		if (guid_equal(uuid_mod, &module->uuid)) {
+			mconfig->id.module_id = module->id;
+			mconfig->module->loadable = module->is_loadable;
+			ret = 0;
+		}
+
 		for (i = 0; i < MAX_IN_QUEUE; i++) {
 			pin_id = &mconfig->m_in_pin[i].id;
 			if (guid_equal(&pin_id->mod_uuid, &module->uuid))
@@ -1358,7 +1351,7 @@ static int skl_get_module_info(struct skl_dev *skl,
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int skl_populate_modules(struct skl_dev *skl)
diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 0740764e7f71..ac9980ed266e 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -186,7 +186,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_i2s_dev *i2s = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret = 0;
 
+	pm_runtime_get_sync(cpu_dai->dev);
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
@@ -199,7 +201,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		i2s->is_master_mode = false;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -213,7 +216,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		val = I2S_CKR_CKP_POS;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -229,14 +233,15 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_TXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_TXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_TXCR_TFS_PCM | I2S_TXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_TXCR_TFS_PCM;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_TXCR, mask, val);
@@ -252,19 +257,23 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_RXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_RXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_RXCR_TFS_PCM | I2S_RXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_RXCR_TFS_PCM;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_RXCR, mask, val);
 
-	return 0;
+err_pm_put:
+	pm_runtime_put(cpu_dai->dev);
+
+	return ret;
 }
 
 static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d1c570ca21ea..b944f56a469a 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2001,6 +2001,8 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 	struct snd_soc_pcm_runtime *be;
 	struct snd_soc_dpcm *dpcm;
 	int ret = 0;
+	unsigned long flags;
+	enum snd_soc_dpcm_state state;
 
 	for_each_dpcm_be(fe, stream, dpcm) {
 		struct snd_pcm_substream *be_substream;
@@ -2017,76 +2019,141 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 
 		switch (cmd) {
 		case SNDRV_PCM_TRIGGER_START:
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_PREPARE) &&
 			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
-			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED)) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
 			break;
 		case SNDRV_PCM_TRIGGER_RESUME:
-			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND))
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
 			break;
 		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
 			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_START) &&
-			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED)) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))
 				continue;
 
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_STOP;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
+
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_STOP;
 			break;
 		case SNDRV_PCM_TRIGGER_SUSPEND:
-			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))
 				continue;
 
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_STOP;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
+
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_SUSPEND;
 			break;
 		case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START) {
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				continue;
+			}
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))
 				continue;
 
+			spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+			state = be->dpcm[stream].state;
+			be->dpcm[stream].state = SND_SOC_DPCM_STATE_PAUSED;
+			spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
+
 			ret = soc_pcm_trigger(be_substream, cmd);
-			if (ret)
+			if (ret) {
+				spin_lock_irqsave(&fe->card->dpcm_lock, flags);
+				be->dpcm[stream].state = state;
+				spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
 				goto end;
+			}
 
-			be->dpcm[stream].state = SND_SOC_DPCM_STATE_PAUSED;
 			break;
 		}
 	}
diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index b94220306d1a..41d7cb132198 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -83,6 +83,8 @@ struct davinci_mcasp {
 	struct snd_pcm_substream *substreams[2];
 	unsigned int dai_fmt;
 
+	u32 iec958_status;
+
 	/* Audio can not be enabled due to missing parameter(s) */
 	bool	missing_audio_param;
 
@@ -757,6 +759,9 @@ static int davinci_mcasp_set_tdm_slot(struct snd_soc_dai *dai,
 {
 	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(dai);
 
+	if (mcasp->op_mode == DAVINCI_MCASP_DIT_MODE)
+		return 0;
+
 	dev_dbg(mcasp->dev,
 		 "%s() tx_mask 0x%08x rx_mask 0x%08x slots %d width %d\n",
 		 __func__, tx_mask, rx_mask, slots, slot_width);
@@ -827,6 +832,20 @@ static int davinci_config_channel_size(struct davinci_mcasp *mcasp,
 		mcasp_mod_bits(mcasp, DAVINCI_MCASP_RXFMT_REG, RXROT(rx_rotate),
 			       RXROT(7));
 		mcasp_set_reg(mcasp, DAVINCI_MCASP_RXMASK_REG, mask);
+	} else {
+		/*
+		 * according to the TRM it should be TXROT=0, this one works:
+		 * 16 bit to 23-8 (TXROT=6, rotate 24 bits)
+		 * 24 bit to 23-0 (TXROT=0, rotate 0 bits)
+		 *
+		 * TXROT = 0 only works with 24bit samples
+		 */
+		tx_rotate = (sample_width / 4 + 2) & 0x7;
+
+		mcasp_mod_bits(mcasp, DAVINCI_MCASP_TXFMT_REG, TXROT(tx_rotate),
+			       TXROT(7));
+		mcasp_mod_bits(mcasp, DAVINCI_MCASP_TXFMT_REG, TXSSZ(15),
+			       TXSSZ(0x0F));
 	}
 
 	mcasp_set_reg(mcasp, DAVINCI_MCASP_TXMASK_REG, mask);
@@ -842,10 +861,16 @@ static int mcasp_common_hw_param(struct davinci_mcasp *mcasp, int stream,
 	u8 tx_ser = 0;
 	u8 rx_ser = 0;
 	u8 slots = mcasp->tdm_slots;
-	u8 max_active_serializers = (channels + slots - 1) / slots;
-	u8 max_rx_serializers, max_tx_serializers;
+	u8 max_active_serializers, max_rx_serializers, max_tx_serializers;
 	int active_serializers, numevt;
 	u32 reg;
+
+	/* In DIT mode we only allow maximum of one serializers for now */
+	if (mcasp->op_mode == DAVINCI_MCASP_DIT_MODE)
+		max_active_serializers = 1;
+	else
+		max_active_serializers = (channels + slots - 1) / slots;
+
 	/* Default configuration */
 	if (mcasp->version < MCASP_VERSION_3)
 		mcasp_set_bits(mcasp, DAVINCI_MCASP_PWREMUMGT_REG, MCASP_SOFT);
@@ -1031,16 +1056,18 @@ static int mcasp_i2s_hw_param(struct davinci_mcasp *mcasp, int stream,
 static int mcasp_dit_hw_param(struct davinci_mcasp *mcasp,
 			      unsigned int rate)
 {
-	u32 cs_value = 0;
-	u8 *cs_bytes = (u8*) &cs_value;
+	u8 *cs_bytes = (u8 *)&mcasp->iec958_status;
 
-	/* Set the TX format : 24 bit right rotation, 32 bit slot, Pad 0
-	   and LSB first */
-	mcasp_set_bits(mcasp, DAVINCI_MCASP_TXFMT_REG, TXROT(6) | TXSSZ(15));
+	if (!mcasp->dat_port)
+		mcasp_set_bits(mcasp, DAVINCI_MCASP_TXFMT_REG, TXSEL);
+	else
+		mcasp_clr_bits(mcasp, DAVINCI_MCASP_TXFMT_REG, TXSEL);
 
 	/* Set TX frame synch : DIT Mode, 1 bit width, internal, rising edge */
 	mcasp_set_reg(mcasp, DAVINCI_MCASP_TXFMCTL_REG, AFSXE | FSXMOD(0x180));
 
+	mcasp_set_reg(mcasp, DAVINCI_MCASP_TXMASK_REG, 0xFFFF);
+
 	/* Set the TX tdm : for all the slots */
 	mcasp_set_reg(mcasp, DAVINCI_MCASP_TXTDM_REG, 0xFFFFFFFF);
 
@@ -1049,16 +1076,8 @@ static int mcasp_dit_hw_param(struct davinci_mcasp *mcasp,
 
 	mcasp_clr_bits(mcasp, DAVINCI_MCASP_XEVTCTL_REG, TXDATADMADIS);
 
-	/* Only 44100 and 48000 are valid, both have the same setting */
-	mcasp_set_bits(mcasp, DAVINCI_MCASP_AHCLKXCTL_REG, AHCLKXDIV(3));
-
-	/* Enable the DIT */
-	mcasp_set_bits(mcasp, DAVINCI_MCASP_TXDITCTL_REG, DITEN);
-
 	/* Set S/PDIF channel status bits */
-	cs_bytes[0] = IEC958_AES0_CON_NOT_COPYRIGHT;
-	cs_bytes[1] = IEC958_AES1_CON_PCM_CODER;
-
+	cs_bytes[3] &= ~IEC958_AES3_CON_FS;
 	switch (rate) {
 	case 22050:
 		cs_bytes[3] |= IEC958_AES3_CON_FS_22050;
@@ -1088,12 +1107,15 @@ static int mcasp_dit_hw_param(struct davinci_mcasp *mcasp,
 		cs_bytes[3] |= IEC958_AES3_CON_FS_192000;
 		break;
 	default:
-		printk(KERN_WARNING "unsupported sampling rate: %d\n", rate);
+		dev_err(mcasp->dev, "unsupported sampling rate: %d\n", rate);
 		return -EINVAL;
 	}
 
-	mcasp_set_reg(mcasp, DAVINCI_MCASP_DITCSRA_REG, cs_value);
-	mcasp_set_reg(mcasp, DAVINCI_MCASP_DITCSRB_REG, cs_value);
+	mcasp_set_reg(mcasp, DAVINCI_MCASP_DITCSRA_REG, mcasp->iec958_status);
+	mcasp_set_reg(mcasp, DAVINCI_MCASP_DITCSRB_REG, mcasp->iec958_status);
+
+	/* Enable the DIT */
+	mcasp_set_bits(mcasp, DAVINCI_MCASP_TXDITCTL_REG, DITEN);
 
 	return 0;
 }
@@ -1237,12 +1259,18 @@ static int davinci_mcasp_hw_params(struct snd_pcm_substream *substream,
 		int slots = mcasp->tdm_slots;
 		int rate = params_rate(params);
 		int sbits = params_width(params);
+		unsigned int bclk_target;
 
 		if (mcasp->slot_width)
 			sbits = mcasp->slot_width;
 
+		if (mcasp->op_mode == DAVINCI_MCASP_IIS_MODE)
+			bclk_target = rate * sbits * slots;
+		else
+			bclk_target = rate * 128;
+
 		davinci_mcasp_calc_clk_div(mcasp, mcasp->sysclk_freq,
-					   rate * sbits * slots, true);
+					   bclk_target, true);
 	}
 
 	ret = mcasp_common_hw_param(mcasp, substream->stream,
@@ -1598,6 +1626,77 @@ static const struct snd_soc_dai_ops davinci_mcasp_dai_ops = {
 	.set_tdm_slot	= davinci_mcasp_set_tdm_slot,
 };
 
+static int davinci_mcasp_iec958_info(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_IEC958;
+	uinfo->count = 1;
+
+	return 0;
+}
+
+static int davinci_mcasp_iec958_get(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *uctl)
+{
+	struct snd_soc_dai *cpu_dai = snd_kcontrol_chip(kcontrol);
+	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(cpu_dai);
+
+	memcpy(uctl->value.iec958.status, &mcasp->iec958_status,
+	       sizeof(mcasp->iec958_status));
+
+	return 0;
+}
+
+static int davinci_mcasp_iec958_put(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *uctl)
+{
+	struct snd_soc_dai *cpu_dai = snd_kcontrol_chip(kcontrol);
+	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(cpu_dai);
+
+	memcpy(&mcasp->iec958_status, uctl->value.iec958.status,
+	       sizeof(mcasp->iec958_status));
+
+	return 0;
+}
+
+static int davinci_mcasp_iec958_con_mask_get(struct snd_kcontrol *kcontrol,
+					     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_dai *cpu_dai = snd_kcontrol_chip(kcontrol);
+	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(cpu_dai);
+
+	memset(ucontrol->value.iec958.status, 0xff, sizeof(mcasp->iec958_status));
+	return 0;
+}
+
+static const struct snd_kcontrol_new davinci_mcasp_iec958_ctls[] = {
+	{
+		.access = (SNDRV_CTL_ELEM_ACCESS_READWRITE |
+			   SNDRV_CTL_ELEM_ACCESS_VOLATILE),
+		.iface = SNDRV_CTL_ELEM_IFACE_PCM,
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
+		.info = davinci_mcasp_iec958_info,
+		.get = davinci_mcasp_iec958_get,
+		.put = davinci_mcasp_iec958_put,
+	}, {
+		.access = SNDRV_CTL_ELEM_ACCESS_READ,
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, CON_MASK),
+		.info = davinci_mcasp_iec958_info,
+		.get = davinci_mcasp_iec958_con_mask_get,
+	},
+};
+
+static void davinci_mcasp_init_iec958_status(struct davinci_mcasp *mcasp)
+{
+	unsigned char *cs = (u8 *)&mcasp->iec958_status;
+
+	cs[0] = IEC958_AES0_CON_NOT_COPYRIGHT | IEC958_AES0_CON_EMPHASIS_NONE;
+	cs[1] = IEC958_AES1_CON_PCM_CODER;
+	cs[2] = IEC958_AES2_CON_SOURCE_UNSPEC | IEC958_AES2_CON_CHANNEL_UNSPEC;
+	cs[3] = IEC958_AES3_CON_CLOCK_1000PPM;
+}
+
 static int davinci_mcasp_dai_probe(struct snd_soc_dai *dai)
 {
 	struct davinci_mcasp *mcasp = snd_soc_dai_get_drvdata(dai);
@@ -1605,6 +1704,12 @@ static int davinci_mcasp_dai_probe(struct snd_soc_dai *dai)
 	dai->playback_dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
 	dai->capture_dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE];
 
+	if (mcasp->op_mode == DAVINCI_MCASP_DIT_MODE) {
+		davinci_mcasp_init_iec958_status(mcasp);
+		snd_soc_add_dai_controls(dai, davinci_mcasp_iec958_ctls,
+					 ARRAY_SIZE(davinci_mcasp_iec958_ctls));
+	}
+
 	return 0;
 }
 
@@ -1651,7 +1756,8 @@ static struct snd_soc_dai_driver davinci_mcasp_dai[] = {
 			.channels_min	= 1,
 			.channels_max	= 384,
 			.rates		= DAVINCI_MCASP_RATES,
-			.formats	= DAVINCI_MCASP_PCM_FMTS,
+			.formats	= SNDRV_PCM_FMTBIT_S16_LE |
+					  SNDRV_PCM_FMTBIT_S24_LE,
 		},
 		.ops 		= &davinci_mcasp_dai_ops,
 	},
@@ -1871,6 +1977,8 @@ static int davinci_mcasp_get_config(struct davinci_mcasp *mcasp,
 		} else {
 			mcasp->tdm_slots = pdata->tdm_slots;
 		}
+	} else {
+		mcasp->tdm_slots = 32;
 	}
 
 	mcasp->num_serializer = pdata->num_serializer;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f6ebda75b030..533512d933c6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3844,6 +3844,42 @@ static int bpf_map_find_btf_info(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
+static int bpf_get_map_info_from_fdinfo(int fd, struct bpf_map_info *info)
+{
+	char file[PATH_MAX], buff[4096];
+	FILE *fp;
+	__u32 val;
+	int err;
+
+	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	memset(info, 0, sizeof(*info));
+
+	fp = fopen(file, "r");
+	if (!fp) {
+		err = -errno;
+		pr_warn("failed to open %s: %d. No procfs support?\n", file,
+			err);
+		return err;
+	}
+
+	while (fgets(buff, sizeof(buff), fp)) {
+		if (sscanf(buff, "map_type:\t%u", &val) == 1)
+			info->type = val;
+		else if (sscanf(buff, "key_size:\t%u", &val) == 1)
+			info->key_size = val;
+		else if (sscanf(buff, "value_size:\t%u", &val) == 1)
+			info->value_size = val;
+		else if (sscanf(buff, "max_entries:\t%u", &val) == 1)
+			info->max_entries = val;
+		else if (sscanf(buff, "map_flags:\t%i", &val) == 1)
+			info->map_flags = val;
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
 int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 {
 	struct bpf_map_info info = {};
@@ -3852,6 +3888,8 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	char *new_name;
 
 	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (err && errno == EINVAL)
+		err = bpf_get_map_info_from_fdinfo(fd, &info);
 	if (err)
 		return err;
 
@@ -4318,12 +4356,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
 	struct bpf_map_info map_info = {};
 	char msg[STRERR_BUFSIZE];
 	__u32 map_info_len;
+	int err;
 
 	map_info_len = sizeof(map_info);
 
-	if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len)) {
-		pr_warn("failed to get map info for map FD %d: %s\n",
-			map_fd, libbpf_strerror_r(errno, msg, sizeof(msg)));
+	err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+	if (err && errno == EINVAL)
+		err = bpf_get_map_info_from_fdinfo(map_fd, &map_info);
+	if (err) {
+		pr_warn("failed to get map info for map FD %d: %s\n", map_fd,
+			libbpf_strerror_r(errno, msg, sizeof(msg)));
 		return false;
 	}
 
@@ -4528,10 +4570,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	unsigned int i, j;
 	int err;
+	bool retried;
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		map = &obj->maps[i];
 
+		retried = false;
+retry:
 		if (map->pin_path) {
 			err = bpf_object__reuse_map(map);
 			if (err) {
@@ -4539,6 +4584,12 @@ bpf_object__create_maps(struct bpf_object *obj)
 					map->name);
 				goto err_out;
 			}
+			if (retried && map->fd < 0) {
+				pr_warn("map '%s': cannot find pinned map\n",
+					map->name);
+				err = -ENOENT;
+				goto err_out;
+			}
 		}
 
 		if (map->fd >= 0) {
@@ -4572,9 +4623,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->pin_path && !map->pinned) {
 			err = bpf_map__pin(map, NULL);
 			if (err) {
+				zclose(map->fd);
+				if (!retried && err == -EEXIST) {
+					retried = true;
+					goto retry;
+				}
 				pr_warn("map '%s': failed to auto-pin at '%s': %d\n",
 					map->name, map->pin_path, err);
-				zclose(map->fd);
 				goto err_out;
 			}
 		}
diff --git a/tools/testing/selftests/arm64/mte/mte_common_util.c b/tools/testing/selftests/arm64/mte/mte_common_util.c
index f50ac31920d1..0328a1e08f65 100644
--- a/tools/testing/selftests/arm64/mte/mte_common_util.c
+++ b/tools/testing/selftests/arm64/mte/mte_common_util.c
@@ -298,7 +298,7 @@ int mte_default_setup(void)
 	int ret;
 
 	if (!(hwcaps2 & HWCAP2_MTE)) {
-		ksft_print_msg("FAIL: MTE features unavailable\n");
+		ksft_print_msg("SKIP: MTE features unavailable\n");
 		return KSFT_SKIP;
 	}
 	/* Get current mte mode */
diff --git a/tools/testing/selftests/arm64/pauth/pac.c b/tools/testing/selftests/arm64/pauth/pac.c
index 592fe538506e..b743daa772f5 100644
--- a/tools/testing/selftests/arm64/pauth/pac.c
+++ b/tools/testing/selftests/arm64/pauth/pac.c
@@ -25,13 +25,15 @@
 do { \
 	unsigned long hwcaps = getauxval(AT_HWCAP); \
 	/* data key instructions are not in NOP space. This prevents a SIGILL */ \
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled"); \
+	if (!(hwcaps & HWCAP_PACA))					\
+		SKIP(return, "PAUTH not enabled"); \
 } while (0)
 #define ASSERT_GENERIC_PAUTH_ENABLED() \
 do { \
 	unsigned long hwcaps = getauxval(AT_HWCAP); \
 	/* generic key instructions are not in NOP space. This prevents a SIGILL */ \
-	ASSERT_NE(0, hwcaps & HWCAP_PACG) TH_LOG("Generic PAUTH not enabled"); \
+	if (!(hwcaps & HWCAP_PACG)) \
+		SKIP(return, "Generic PAUTH not enabled");	\
 } while (0)
 
 void sign_specific(struct signatures *sign, size_t val)
@@ -256,7 +258,7 @@ TEST(single_thread_different_keys)
 	unsigned long hwcaps = getauxval(AT_HWCAP);
 
 	/* generic and data key instructions are not in NOP space. This prevents a SIGILL */
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled");
+	ASSERT_PAUTH_ENABLED();
 	if (!(hwcaps & HWCAP_PACG)) {
 		TH_LOG("WARNING: Generic PAUTH not enabled. Skipping generic key checks");
 		nkeys = NKEYS - 1;
@@ -299,7 +301,7 @@ TEST(exec_changed_keys)
 	unsigned long hwcaps = getauxval(AT_HWCAP);
 
 	/* generic and data key instructions are not in NOP space. This prevents a SIGILL */
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled");
+	ASSERT_PAUTH_ENABLED();
 	if (!(hwcaps & HWCAP_PACG)) {
 		TH_LOG("WARNING: Generic PAUTH not enabled. Skipping generic key checks");
 		nkeys = NKEYS - 1;
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 7043e6ded0e6..75b72c751772 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include "test_send_signal_kern.skel.h"
 
 static volatile int sigusr1_received = 0;
@@ -41,12 +43,23 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 	}
 
 	if (pid == 0) {
+		int old_prio;
+
 		/* install signal handler and notify parent */
 		signal(SIGUSR1, sigusr1_handler);
 
 		close(pipe_c2p[0]); /* close read */
 		close(pipe_p2c[1]); /* close write */
 
+		/* boost with a high priority so we got a higher chance
+		 * that if an interrupt happens, the underlying task
+		 * is this process.
+		 */
+		errno = 0;
+		old_prio = getpriority(PRIO_PROCESS, 0);
+		ASSERT_OK(errno, "getpriority");
+		ASSERT_OK(setpriority(PRIO_PROCESS, 0, -20), "setpriority");
+
 		/* notify parent signal handler is installed */
 		CHECK(write(pipe_c2p[1], buf, 1) != 1, "pipe_write", "err %d\n", -errno);
 
@@ -62,6 +75,9 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 		/* wait for parent notification and exit */
 		CHECK(read(pipe_p2c[0], buf, 1) != 1, "pipe_read", "err %d\n", -errno);
 
+		/* restore the old priority */
+		ASSERT_OK(setpriority(PRIO_PROCESS, 0, old_prio), "setpriority");
+
 		close(pipe_c2p[1]);
 		close(pipe_p2c[0]);
 		exit(0);
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index ec281b0363b8..86f97681ad89 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -195,8 +195,10 @@ static void run_test(int cgroup_fd)
 
 	pthread_mutex_lock(&server_started_mtx);
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
-				      (void *)&server_fd)))
+				      (void *)&server_fd))) {
+		pthread_mutex_unlock(&server_started_mtx);
 		goto close_server_fd;
+	}
 	pthread_cond_wait(&server_started, &server_started_mtx);
 	pthread_mutex_unlock(&server_started_mtx);
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
index 94e6c2b281cb..5f725c720e00 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-SEC("tx")
+SEC("xdp")
 int xdp_tx(struct xdp_md *xdp)
 {
 	return XDP_TX;
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index aa38dc4a5e85..90f38c6528a1 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -968,7 +968,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 6396932b97e2..9ed13187136c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -148,18 +148,18 @@ void test__end_subtest()
 	struct prog_test_def *test = env.test;
 	int sub_error_cnt = test->error_cnt - test->old_error_cnt;
 
-	if (sub_error_cnt)
-		env.fail_cnt++;
-	else if (test->skip_cnt == 0)
-		env.sub_succ_cnt++;
-	skip_account();
-
 	dump_test_log(test, sub_error_cnt);
 
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num, test->subtest_name,
 	       sub_error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
 
+	if (sub_error_cnt)
+		env.fail_cnt++;
+	else if (test->skip_cnt == 0)
+		env.sub_succ_cnt++;
+	skip_account();
+
 	free(test->subtest_name);
 	test->subtest_name = NULL;
 }
@@ -783,17 +783,18 @@ int main(int argc, char **argv)
 			test__end_subtest();
 
 		test->tested = true;
-		if (test->error_cnt)
-			env.fail_cnt++;
-		else
-			env.succ_cnt++;
-		skip_account();
 
 		dump_test_log(test, test->error_cnt);
 
 		fprintf(env.stdout, "#%d %s:%s\n",
 			test->test_num, test->test_name,
-			test->error_cnt ? "FAIL" : "OK");
+			test->error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
+
+		if (test->error_cnt)
+			env.fail_cnt++;
+		else
+			env.succ_cnt++;
+		skip_account();
 
 		reset_affinity();
 		restore_netns();
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index ba8ffcdaac30..995278e684b6 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
 ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
 ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
 
 trap cleanup EXIT
diff --git a/tools/testing/selftests/firmware/fw_namespace.c b/tools/testing/selftests/firmware/fw_namespace.c
index 0e393cb5f42d..4c6f0cd83c5b 100644
--- a/tools/testing/selftests/firmware/fw_namespace.c
+++ b/tools/testing/selftests/firmware/fw_namespace.c
@@ -129,7 +129,8 @@ int main(int argc, char **argv)
 		die("mounting tmpfs to /lib/firmware failed\n");
 
 	sys_path = argv[1];
-	asprintf(&fw_path, "/lib/firmware/%s", fw_name);
+	if (asprintf(&fw_path, "/lib/firmware/%s", fw_name) < 0)
+		die("error: failed to build full fw_path\n");
 
 	setup_fw(fw_path);
 
diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index a6fac927ee82..0cee6b067a37 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -115,7 +115,7 @@ check_requires() { # Check required files and tracers
                 echo "Required tracer $t is not configured."
                 exit_unsupported
             fi
-        elif [ $r != $i ]; then
+        elif [ "$r" != "$i" ]; then
             if ! grep -Fq "$r" README ; then
                 echo "Required feature pattern \"$r\" is not in README."
                 exit_unsupported
diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 57b505cb1561..acd4125ff39f 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -110,11 +110,11 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		na->nla_type = nla_type[cnt];
 		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
 
-		if (nla_len > 0)
+		if (nla_len[cnt] > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
-		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
-		prv_len = na->nla_len;
+		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
+		msg.n.nlmsg_len += prv_len;
 	}
 
 	buf = (char *)&msg;
diff --git a/tools/thermal/tmon/Makefile b/tools/thermal/tmon/Makefile
index 9db867df7679..610334f86f63 100644
--- a/tools/thermal/tmon/Makefile
+++ b/tools/thermal/tmon/Makefile
@@ -10,7 +10,7 @@ override CFLAGS+= $(call cc-option,-O3,-O1) ${WARNFLAGS}
 # Add "-fstack-protector" only if toolchain supports it.
 override CFLAGS+= $(call cc-option,-fstack-protector-strong)
 CC?= $(CROSS_COMPILE)gcc
-PKG_CONFIG?= pkg-config
+PKG_CONFIG?= $(CROSS_COMPILE)pkg-config
 
 override CFLAGS+=-D VERSION=\"$(VERSION)\"
 LDFLAGS+=
