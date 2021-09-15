Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA8340C14C
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 10:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhIOILX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 04:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhIOIK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 04:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27FE961185;
        Wed, 15 Sep 2021 08:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631693378;
        bh=6bzNIt9bzKb8nDT1yN9O05t/kYgs44WPVi0Tz/5S4Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6wo/FfSRSroTktXS8sRIbGWLXkT3NjLq9H5eSakc/GDRry5ORfd6NdmXOkjQkpbV
         CtPns2CSfy0GJfHt/6FK1/5gjuzFnlT5WFnbnmgneuyAfdoSboe+sKAOwol8THizST
         R0fKDiJ99d+ccO4wpKh410ljt8RzZJF+w9aWbMDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.17
Date:   Wed, 15 Sep 2021 10:09:27 +0200
Message-Id: <163169336618218@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163169336668242@kroah.com>
References: <163169336668242@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/fault-injection/provoke-crashes.rst b/Documentation/fault-injection/provoke-crashes.rst
index a20ba5d93932..18de17354206 100644
--- a/Documentation/fault-injection/provoke-crashes.rst
+++ b/Documentation/fault-injection/provoke-crashes.rst
@@ -29,7 +29,7 @@ recur_count
 cpoint_name
 	Where in the kernel to trigger the action. It can be
 	one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
-	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
+	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ,
 	IDE_CORE_CP, or DIRECT
 
 cpoint_type
diff --git a/Makefile b/Makefile
index cbb2f35baedb..c79a2c70a22b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 16
+SUBLEVEL = 17
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index 7028e21bdd98..910eacc8ad3b 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -208,12 +208,12 @@ pinctrl_gpiu7_default: gpiu7_default {
 	};
 
 	pinctrl_hvi3c3_default: hvi3c3_default {
-		function = "HVI3C3";
+		function = "I3C3";
 		groups = "HVI3C3";
 	};
 
 	pinctrl_hvi3c4_default: hvi3c4_default {
-		function = "HVI3C4";
+		function = "I3C4";
 		groups = "HVI3C4";
 	};
 
diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index edca66c232c1..ebbc9b23aef1 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -92,6 +92,8 @@ sw1 {
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
 		status = "okay"; /* Conflict with pwm0. */
 
 		red {
@@ -537,6 +539,10 @@ AT91_PIOA 18 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_H
 				 AT91_PIOA 19 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA19 DAT2 periph A with pullup */
 				 AT91_PIOA 20 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)>;	/* PA20 DAT3 periph A with pullup */
 		};
+		pinctrl_sdmmc0_cd: sdmmc0_cd {
+			atmel,pins =
+				<AT91_PIOA 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+		};
 	};
 
 	sdmmc1 {
@@ -569,6 +575,14 @@ pinctrl_usb_default: usb_default {
 				      AT91_PIOD 16 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
 		};
 	};
+
+	leds {
+		pinctrl_gpio_leds: gpio_leds {
+			atmel,pins = <AT91_PIOB 11 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+				      AT91_PIOB 12 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+				      AT91_PIOB 13 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+		};
+	};
 }; /* pinctrl */
 
 &pwm0 {
@@ -580,7 +594,7 @@ &pwm0 {
 &sdmmc0 {
 	bus-width = <4>;
 	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_sdmmc0_default>;
+	pinctrl-0 = <&pinctrl_sdmmc0_default &pinctrl_sdmmc0_cd>;
 	status = "okay";
 	cd-gpios = <&pioA 23 GPIO_ACTIVE_LOW>;
 	disable-wp;
diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 9c55a921263b..cc55d1684322 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -57,6 +57,8 @@ slot@0 {
 			};
 
 			spi0: spi@f0004000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
 				status = "okay";
 			};
@@ -169,6 +171,8 @@ slot@0 {
 			};
 
 			spi1: spi@f8008000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioC 25 0>;
 				status = "okay";
 			};
@@ -248,6 +252,26 @@ pinctrl_usb_default: usb_default {
 							<AT91_PIOE 3 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
 							 AT91_PIOE 4 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
 					};
+
+					pinctrl_gpio_leds: gpio_leds_default {
+						atmel,pins =
+							<AT91_PIOE 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+							 AT91_PIOE 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_spi0_cs: spi0_cs_default {
+						atmel,pins =
+							<AT91_PIOD 13 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+							 AT91_PIOD 16 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_spi1_cs: spi1_cs_default {
+						atmel,pins = <AT91_PIOC 25 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_vcc_mmc0_reg_gpio: vcc_mmc0_reg_gpio_default {
+						atmel,pins = <AT91_PIOE 2 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
 				};
 			};
 		};
@@ -339,6 +363,8 @@ rootfs@800000 {
 
 	vcc_mmc0_reg: fixedregulator_mmc0 {
 		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_vcc_mmc0_reg_gpio>;
 		gpio = <&pioE 2 GPIO_ACTIVE_LOW>;
 		regulator-name = "mmc0-card-supply";
 		regulator-min-microvolt = <3300000>;
@@ -362,6 +388,9 @@ bp3 {
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
+		status = "okay";
 
 		d2 {
 			label = "d2";
diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index 0b3ad1b580b8..e42dae06b582 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -90,6 +90,8 @@ usart4: serial@fc010000 {
 			};
 
 			spi1: spi@fc018000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioB 21 0>;
 				status = "okay";
 			};
@@ -147,6 +149,19 @@ pinctrl_macb0_phy_irq: macb0_phy_irq_0 {
 						atmel,pins =
 							<AT91_PIOE 1 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
 					};
+					pinctrl_spi0_cs: spi0_cs_default {
+						atmel,pins =
+							<AT91_PIOB 21 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_gpio_leds: gpio_leds_default {
+						atmel,pins =
+							<AT91_PIOD 30 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
+							 AT91_PIOE 15 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_vcc_mmc1_reg: vcc_mmc1_reg {
+						atmel,pins =
+							<AT91_PIOE 4 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
 				};
 			};
 		};
@@ -252,6 +267,8 @@ pb_user1 {
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
 		status = "okay";
 
 		d8 {
@@ -278,6 +295,8 @@ vcc_3v3_reg: fixedregulator_3v3 {
 
 	vcc_mmc1_reg: fixedregulator_mmc1 {
 		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_vcc_mmc1_reg>;
 		gpio = <&pioE 4 GPIO_ACTIVE_LOW>;
 		regulator-name = "VDD MCI1";
 		regulator-min-microvolt = <3300000>;
diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 157a950a55d3..686c7b7c79d5 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -304,8 +304,13 @@ mali: gpu@c0000 {
 					  "pp2", "ppmmu2", "pp4", "ppmmu4",
 					  "pp5", "ppmmu5", "pp6", "ppmmu6";
 			resets = <&reset RESET_MALI>;
+
 			clocks = <&clkc CLKID_CLK81>, <&clkc CLKID_MALI>;
 			clock-names = "bus", "core";
+
+			assigned-clocks = <&clkc CLKID_MALI>;
+			assigned-clock-rates = <318750000>;
+
 			operating-points-v2 = <&gpu_opp_table>;
 			#cooling-cells = <2>; /* min followed by max */
 		};
diff --git a/arch/arm/boot/dts/meson8b-ec100.dts b/arch/arm/boot/dts/meson8b-ec100.dts
index 8e48ccc6b634..7e8ddc6f1252 100644
--- a/arch/arm/boot/dts/meson8b-ec100.dts
+++ b/arch/arm/boot/dts/meson8b-ec100.dts
@@ -148,7 +148,7 @@ vcck: regulator-vcck {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 0 1148 0>;
 		pwm-dutycycle-range = <100 0>;
@@ -232,7 +232,7 @@ vddee: regulator-vddee {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 1 1148 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm/boot/dts/meson8b-mxq.dts b/arch/arm/boot/dts/meson8b-mxq.dts
index f3937d55472d..7adedd3258c3 100644
--- a/arch/arm/boot/dts/meson8b-mxq.dts
+++ b/arch/arm/boot/dts/meson8b-mxq.dts
@@ -34,6 +34,8 @@ vcck: regulator-vcck {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
+		pwm-supply = <&vcc_5v>;
+
 		pwms = <&pwm_cd 0 1148 0>;
 		pwm-dutycycle-range = <100 0>;
 
@@ -79,7 +81,7 @@ vddee: regulator-vddee {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&vcc_5v>;
+		pwm-supply = <&vcc_5v>;
 
 		pwms = <&pwm_cd 1 1148 0>;
 		pwm-dutycycle-range = <100 0>;
diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
index c440ef94e082..04356bc639fa 100644
--- a/arch/arm/boot/dts/meson8b-odroidc1.dts
+++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
@@ -131,7 +131,7 @@ vcck: regulator-vcck {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&p5v0>;
+		pwm-supply = <&p5v0>;
 
 		pwms = <&pwm_cd 0 12218 0>;
 		pwm-dutycycle-range = <91 0>;
@@ -163,7 +163,7 @@ vddee: regulator-vddee {
 		regulator-min-microvolt = <860000>;
 		regulator-max-microvolt = <1140000>;
 
-		vin-supply = <&p5v0>;
+		pwm-supply = <&p5v0>;
 
 		pwms = <&pwm_cd 1 12218 0>;
 		pwm-dutycycle-range = <91 0>;
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 10244e59d56d..56a0bb7eb0e6 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -102,7 +102,7 @@ gic: interrupt-controller@11001000 {
 			#address-cells = <0>;
 			interrupt-controller;
 			reg =	<0x11001000 0x1000>,
-				<0x11002000 0x1000>,
+				<0x11002000 0x2000>,
 				<0x11004000 0x2000>,
 				<0x11006000 0x2000>;
 		};
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index a05b1ab2dd12..04da07ae4420 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -135,6 +135,23 @@ &pcie0 {
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
 	status = "okay";
 	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
+	/*
+	 * U-Boot port for Turris Mox has a bug which always expects that "ranges" DT property
+	 * contains exactly 2 ranges with 3 (child) address cells, 2 (parent) address cells and
+	 * 2 size cells and also expects that the second range starts at 16 MB offset. If these
+	 * conditions are not met then U-Boot crashes during loading kernel DTB file. PCIe address
+	 * space is 128 MB long, so the best split between MEM and IO is to use fixed 16 MB window
+	 * for IO and the rest 112 MB (64+32+16) for MEM, despite that maximal IO size is just 64 kB.
+	 * This bug is not present in U-Boot ports for other Armada 3700 devices and is fixed in
+	 * U-Boot version 2021.07. See relevant U-Boot commits (the last one contains fix):
+	 * https://source.denx.de/u-boot/u-boot/-/commit/cb2ddb291ee6fcbddd6d8f4ff49089dfe580f5d7
+	 * https://source.denx.de/u-boot/u-boot/-/commit/c64ac3b3185aeb3846297ad7391fc6df8ecd73bf
+	 * https://source.denx.de/u-boot/u-boot/-/commit/4a82fca8e330157081fc132a591ebd99ba02ee33
+	 */
+	#address-cells = <3>;
+	#size-cells = <2>;
+	ranges = <0x81000000 0 0xe8000000   0 0xe8000000   0 0x01000000   /* Port 0 IO */
+		  0x82000000 0 0xe9000000   0 0xe9000000   0 0x07000000>; /* Port 0 MEM */
 
 	/* enabled by U-Boot if PCIe module is present */
 	status = "disabled";
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 5db81a416cd6..9acc5d2b5a00 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -489,8 +489,15 @@ pcie0: pcie@d0070000 {
 			#interrupt-cells = <1>;
 			msi-parent = <&pcie0>;
 			msi-controller;
-			ranges = <0x82000000 0 0xe8000000   0 0xe8000000 0 0x1000000 /* Port 0 MEM */
-				  0x81000000 0 0xe9000000   0 0xe9000000 0 0x10000>; /* Port 0 IO*/
+			/*
+			 * The 128 MiB address range [0xe8000000-0xf0000000] is
+			 * dedicated for PCIe and can be assigned to 8 windows
+			 * with size a power of two. Use one 64 KiB window for
+			 * IO at the end and the remaining seven windows
+			 * (totaling 127 MiB) for MEM.
+			 */
+			ranges = <0x82000000 0 0xe8000000   0 0xe8000000   0 0x07f00000   /* Port 0 MEM */
+				  0x81000000 0 0xefff0000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc 0>,
 					<0 0 0 2 &pcie_intc 1>,
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 3eb8550da1fc..3fa1ad1d0f02 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -23,7 +23,7 @@ / {
 	adau7002: audio-codec-1 {
 		compatible = "adi,adau7002";
 		IOVDD-supply = <&pp1800_l15a>;
-		wakeup-delay-ms = <15>;
+		wakeup-delay-ms = <80>;
 		#sound-dai-cells = <0>;
 	};
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 09b552396557..1316bea3eab5 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2123,7 +2123,7 @@ usb_2_qmpphy: phy@88eb000 {
 				 <&gcc GCC_USB3_PHY_SEC_BCR>;
 			reset-names = "phy", "common";
 
-			usb_2_ssphy: lane@88eb200 {
+			usb_2_ssphy: lanes@88eb200 {
 				reg = <0 0x088eb200 0 0x200>,
 				      <0 0x088eb400 0 0x200>,
 				      <0 0x088eb800 0 0x800>;
diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index 202c4fc88bd5..dde3a07bc417 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -20,6 +20,7 @@ &avb {
 	pinctrl-names = "default";
 	phy-handle = <&phy0>;
 	tx-internal-delay-ps = <2000>;
+	rx-internal-delay-ps = <1800>;
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
diff --git a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
index 6783c3ad0856..57784341f39d 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
@@ -277,10 +277,6 @@ hdmi-encoder@39 {
 		interrupt-parent = <&gpio1>;
 		interrupts = <28 IRQ_TYPE_LEVEL_LOW>;
 
-		/* Depends on LVDS */
-		max-clock = <135000000>;
-		min-vrefresh = <50>;
-
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
 		adi,input-clock = "1x";
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index facf4d41d32a..3ed09e7f81f0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/kmemleak.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
@@ -1957,6 +1958,12 @@ static int finalize_hyp_mode(void)
 	if (ret)
 		return ret;
 
+	/*
+	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
+	 * at, which would end badly once the section is inaccessible.
+	 * None of other sections should ever be introspected.
+	 */
+	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
 	ret = pkvm_mark_hyp_section(__hyp_bss);
 	if (ret)
 		return ret;
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index f4d23977d2a5..1127d64b6c1d 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -26,6 +26,7 @@ config COLDFIRE
 	bool "Coldfire CPU family support"
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select GENERIC_CSUM
 	select GPIOLIB
@@ -39,6 +40,7 @@ config M68000
 	bool
 	depends on !MMU
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
 	select CPU_HAS_NO_UNALIGNED
 	select GENERIC_CSUM
@@ -54,6 +56,7 @@ config M68000
 config MCPU32
 	bool
 	select CPU_HAS_NO_BITFIELDS
+	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_UNALIGNED
 	select CPU_NO_EFFICIENT_FFS
 	help
@@ -383,7 +386,7 @@ config ADVANCED
 
 config RMW_INSNS
 	bool "Use read-modify-write instructions"
-	depends on ADVANCED
+	depends on ADVANCED && !CPU_HAS_NO_CAS
 	help
 	  This allows to use certain instructions that work with indivisible
 	  read-modify-write bus cycles. While this is faster than the
@@ -459,6 +462,9 @@ config NODES_SHIFT
 config CPU_HAS_NO_BITFIELDS
 	bool
 
+config CPU_HAS_NO_CAS
+	bool
+
 config CPU_HAS_NO_MULDIV64
 	bool
 
diff --git a/arch/m68k/coldfire/clk.c b/arch/m68k/coldfire/clk.c
index 076a9caa9557..c895a189c5ae 100644
--- a/arch/m68k/coldfire/clk.c
+++ b/arch/m68k/coldfire/clk.c
@@ -92,7 +92,7 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	spin_lock_irqsave(&clk_lock, flags);
 	if ((clk->enabled++ == 0) && clk->clk_ops)
diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index d2875e32abfc..79e55421cfb1 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -254,8 +254,8 @@ static void __exit nfeth_cleanup(void)
 
 	for (i = 0; i < MAX_UNIT; i++) {
 		if (nfeth_dev[i]) {
-			unregister_netdev(nfeth_dev[0]);
-			free_netdev(nfeth_dev[0]);
+			unregister_netdev(nfeth_dev[i]);
+			free_netdev(nfeth_dev[i]);
 		}
 	}
 	free_irq(nfEtherIRQ, nfeth_interrupt);
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8925f3969478..5445ae106077 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -962,6 +962,7 @@ struct kvm_arch{
 	atomic64_t cmma_dirty_pages;
 	/* subset of available cpu features enabled by user space */
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
+	/* indexed by vcpu_idx */
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index bb958d32bd81..a142671c449b 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/minmax.h>
 #include <linux/debugfs.h>
 
 #include <asm/debug.h>
@@ -92,6 +93,8 @@ static int debug_hex_ascii_format_fn(debug_info_t *id, struct debug_view *view,
 				     char *out_buf, const char *in_buf);
 static int debug_sprintf_format_fn(debug_info_t *id, struct debug_view *view,
 				   char *out_buf, debug_sprintf_entry_t *curr_event);
+static void debug_areas_swap(debug_info_t *a, debug_info_t *b);
+static void debug_events_append(debug_info_t *dest, debug_info_t *src);
 
 /* globals */
 
@@ -311,24 +314,6 @@ static debug_info_t *debug_info_create(const char *name, int pages_per_area,
 		goto out;
 
 	rc->mode = mode & ~S_IFMT;
-
-	/* create root directory */
-	rc->debugfs_root_entry = debugfs_create_dir(rc->name,
-						    debug_debugfs_root_entry);
-
-	/* append new element to linked list */
-	if (!debug_area_first) {
-		/* first element in list */
-		debug_area_first = rc;
-		rc->prev = NULL;
-	} else {
-		/* append element to end of list */
-		debug_area_last->next = rc;
-		rc->prev = debug_area_last;
-	}
-	debug_area_last = rc;
-	rc->next = NULL;
-
 	refcount_set(&rc->ref_count, 1);
 out:
 	return rc;
@@ -388,27 +373,10 @@ static void debug_info_get(debug_info_t *db_info)
  */
 static void debug_info_put(debug_info_t *db_info)
 {
-	int i;
-
 	if (!db_info)
 		return;
-	if (refcount_dec_and_test(&db_info->ref_count)) {
-		for (i = 0; i < DEBUG_MAX_VIEWS; i++) {
-			if (!db_info->views[i])
-				continue;
-			debugfs_remove(db_info->debugfs_entries[i]);
-		}
-		debugfs_remove(db_info->debugfs_root_entry);
-		if (db_info == debug_area_first)
-			debug_area_first = db_info->next;
-		if (db_info == debug_area_last)
-			debug_area_last = db_info->prev;
-		if (db_info->prev)
-			db_info->prev->next = db_info->next;
-		if (db_info->next)
-			db_info->next->prev = db_info->prev;
+	if (refcount_dec_and_test(&db_info->ref_count))
 		debug_info_free(db_info);
-	}
 }
 
 /*
@@ -632,6 +600,31 @@ static int debug_close(struct inode *inode, struct file *file)
 	return 0; /* success */
 }
 
+/* Create debugfs entries and add to internal list. */
+static void _debug_register(debug_info_t *id)
+{
+	/* create root directory */
+	id->debugfs_root_entry = debugfs_create_dir(id->name,
+						    debug_debugfs_root_entry);
+
+	/* append new element to linked list */
+	if (!debug_area_first) {
+		/* first element in list */
+		debug_area_first = id;
+		id->prev = NULL;
+	} else {
+		/* append element to end of list */
+		debug_area_last->next = id;
+		id->prev = debug_area_last;
+	}
+	debug_area_last = id;
+	id->next = NULL;
+
+	debug_register_view(id, &debug_level_view);
+	debug_register_view(id, &debug_flush_view);
+	debug_register_view(id, &debug_pages_view);
+}
+
 /**
  * debug_register_mode() - creates and initializes debug area.
  *
@@ -661,19 +654,16 @@ debug_info_t *debug_register_mode(const char *name, int pages_per_area,
 	if ((uid != 0) || (gid != 0))
 		pr_warn("Root becomes the owner of all s390dbf files in sysfs\n");
 	BUG_ON(!initialized);
-	mutex_lock(&debug_mutex);
 
 	/* create new debug_info */
 	rc = debug_info_create(name, pages_per_area, nr_areas, buf_size, mode);
-	if (!rc)
-		goto out;
-	debug_register_view(rc, &debug_level_view);
-	debug_register_view(rc, &debug_flush_view);
-	debug_register_view(rc, &debug_pages_view);
-out:
-	if (!rc)
+	if (rc) {
+		mutex_lock(&debug_mutex);
+		_debug_register(rc);
+		mutex_unlock(&debug_mutex);
+	} else {
 		pr_err("Registering debug feature %s failed\n", name);
-	mutex_unlock(&debug_mutex);
+	}
 	return rc;
 }
 EXPORT_SYMBOL(debug_register_mode);
@@ -702,6 +692,27 @@ debug_info_t *debug_register(const char *name, int pages_per_area,
 }
 EXPORT_SYMBOL(debug_register);
 
+/* Remove debugfs entries and remove from internal list. */
+static void _debug_unregister(debug_info_t *id)
+{
+	int i;
+
+	for (i = 0; i < DEBUG_MAX_VIEWS; i++) {
+		if (!id->views[i])
+			continue;
+		debugfs_remove(id->debugfs_entries[i]);
+	}
+	debugfs_remove(id->debugfs_root_entry);
+	if (id == debug_area_first)
+		debug_area_first = id->next;
+	if (id == debug_area_last)
+		debug_area_last = id->prev;
+	if (id->prev)
+		id->prev->next = id->next;
+	if (id->next)
+		id->next->prev = id->prev;
+}
+
 /**
  * debug_unregister() - give back debug area.
  *
@@ -715,8 +726,10 @@ void debug_unregister(debug_info_t *id)
 	if (!id)
 		return;
 	mutex_lock(&debug_mutex);
-	debug_info_put(id);
+	_debug_unregister(id);
 	mutex_unlock(&debug_mutex);
+
+	debug_info_put(id);
 }
 EXPORT_SYMBOL(debug_unregister);
 
@@ -726,35 +739,28 @@ EXPORT_SYMBOL(debug_unregister);
  */
 static int debug_set_size(debug_info_t *id, int nr_areas, int pages_per_area)
 {
-	debug_entry_t ***new_areas;
+	debug_info_t *new_id;
 	unsigned long flags;
-	int rc = 0;
 
 	if (!id || (nr_areas <= 0) || (pages_per_area < 0))
 		return -EINVAL;
-	if (pages_per_area > 0) {
-		new_areas = debug_areas_alloc(pages_per_area, nr_areas);
-		if (!new_areas) {
-			pr_info("Allocating memory for %i pages failed\n",
-				pages_per_area);
-			rc = -ENOMEM;
-			goto out;
-		}
-	} else {
-		new_areas = NULL;
+
+	new_id = debug_info_alloc("", pages_per_area, nr_areas, id->buf_size,
+				  id->level, ALL_AREAS);
+	if (!new_id) {
+		pr_info("Allocating memory for %i pages failed\n",
+			pages_per_area);
+		return -ENOMEM;
 	}
+
 	spin_lock_irqsave(&id->lock, flags);
-	debug_areas_free(id);
-	id->areas = new_areas;
-	id->nr_areas = nr_areas;
-	id->pages_per_area = pages_per_area;
-	id->active_area = 0;
-	memset(id->active_entries, 0, sizeof(int)*id->nr_areas);
-	memset(id->active_pages, 0, sizeof(int)*id->nr_areas);
+	debug_events_append(new_id, id);
+	debug_areas_swap(new_id, id);
+	debug_info_free(new_id);
 	spin_unlock_irqrestore(&id->lock, flags);
 	pr_info("%s: set new size (%i pages)\n", id->name, pages_per_area);
-out:
-	return rc;
+
+	return 0;
 }
 
 /**
@@ -821,6 +827,42 @@ static inline debug_entry_t *get_active_entry(debug_info_t *id)
 				  id->active_entries[id->active_area]);
 }
 
+/* Swap debug areas of a and b. */
+static void debug_areas_swap(debug_info_t *a, debug_info_t *b)
+{
+	swap(a->nr_areas, b->nr_areas);
+	swap(a->pages_per_area, b->pages_per_area);
+	swap(a->areas, b->areas);
+	swap(a->active_area, b->active_area);
+	swap(a->active_pages, b->active_pages);
+	swap(a->active_entries, b->active_entries);
+}
+
+/* Append all debug events in active area from source to destination log. */
+static void debug_events_append(debug_info_t *dest, debug_info_t *src)
+{
+	debug_entry_t *from, *to, *last;
+
+	if (!src->areas || !dest->areas)
+		return;
+
+	/* Loop over all entries in src, starting with oldest. */
+	from = get_active_entry(src);
+	last = from;
+	do {
+		if (from->clock != 0LL) {
+			to = get_active_entry(dest);
+			memset(to, 0, dest->entry_size);
+			memcpy(to, from, min(src->entry_size,
+					     dest->entry_size));
+			proceed_active_entry(dest);
+		}
+
+		proceed_active_entry(src);
+		from = get_active_entry(src);
+	} while (from != last);
+}
+
 /*
  * debug_finish_entry:
  * - set timestamp, caller address, cpu number etc.
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index d548d60caed2..16256e17a544 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
-	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
@@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu, __u8 __user *buf, int len)
 
 static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 {
-	int vcpu_id, online_vcpus = atomic_read(&kvm->online_vcpus);
+	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
 	struct kvm_vcpu *vcpu;
 
-	for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
-		vcpu = kvm_get_vcpu(kvm, vcpu_id);
+	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
+		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
 		if (psw_ioint_disabled(vcpu))
 			continue;
 		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
 		if (deliverable_mask) {
 			/* lately kicked but not yet running */
-			if (test_and_set_bit(vcpu_id, gi->kicked_mask))
+			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
 			kvm_s390_vcpu_wakeup(vcpu);
 			return;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 876fc1f7282a..32173fffad3f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4020,7 +4020,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 		kvm_s390_patch_guest_per_regs(vcpu);
 	}
 
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
 
 	vcpu->arch.sie_block->icptcode = 0;
 	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 9fad25109b0d..ecd741ee3276 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)
diff --git a/arch/s390/mm/kasan_init.c b/arch/s390/mm/kasan_init.c
index db4d303aaaa9..d7fcfe97d168 100644
--- a/arch/s390/mm/kasan_init.c
+++ b/arch/s390/mm/kasan_init.c
@@ -108,6 +108,9 @@ static void __init kasan_early_pgtable_populate(unsigned long address,
 		sgt_prot &= ~_SEGMENT_ENTRY_NOEXEC;
 	}
 
+	/*
+	 * The first 1MB of 1:1 mapping is mapped with 4KB pages
+	 */
 	while (address < end) {
 		pg_dir = pgd_offset_k(address);
 		if (pgd_none(*pg_dir)) {
@@ -158,30 +161,26 @@ static void __init kasan_early_pgtable_populate(unsigned long address,
 
 		pm_dir = pmd_offset(pu_dir, address);
 		if (pmd_none(*pm_dir)) {
-			if (mode == POPULATE_ZERO_SHADOW &&
-			    IS_ALIGNED(address, PMD_SIZE) &&
+			if (IS_ALIGNED(address, PMD_SIZE) &&
 			    end - address >= PMD_SIZE) {
-				pmd_populate(&init_mm, pm_dir,
-						kasan_early_shadow_pte);
-				address = (address + PMD_SIZE) & PMD_MASK;
-				continue;
-			}
-			/* the first megabyte of 1:1 is mapped with 4k pages */
-			if (has_edat && address && end - address >= PMD_SIZE &&
-			    mode != POPULATE_ZERO_SHADOW) {
-				void *page;
-
-				if (mode == POPULATE_ONE2ONE) {
-					page = (void *)address;
-				} else {
-					page = kasan_early_alloc_segment();
-					memset(page, 0, _SEGMENT_SIZE);
+				if (mode == POPULATE_ZERO_SHADOW) {
+					pmd_populate(&init_mm, pm_dir, kasan_early_shadow_pte);
+					address = (address + PMD_SIZE) & PMD_MASK;
+					continue;
+				} else if (has_edat && address) {
+					void *page;
+
+					if (mode == POPULATE_ONE2ONE) {
+						page = (void *)address;
+					} else {
+						page = kasan_early_alloc_segment();
+						memset(page, 0, _SEGMENT_SIZE);
+					}
+					pmd_val(*pm_dir) = __pa(page) | sgt_prot;
+					address = (address + PMD_SIZE) & PMD_MASK;
+					continue;
 				}
-				pmd_val(*pm_dir) = __pa(page) | sgt_prot;
-				address = (address + PMD_SIZE) & PMD_MASK;
-				continue;
 			}
-
 			pt_dir = kasan_early_pte_alloc();
 			pmd_populate(&init_mm, pm_dir, pt_dir);
 		} else if (pmd_large(*pm_dir)) {
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 8fcb7ecb7225..77cd965cffef 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -661,9 +661,10 @@ int zpci_enable_device(struct zpci_dev *zdev)
 {
 	int rc;
 
-	rc = clp_enable_fh(zdev, ZPCI_NR_DMA_SPACES);
-	if (rc)
+	if (clp_enable_fh(zdev, ZPCI_NR_DMA_SPACES)) {
+		rc = -EIO;
 		goto out;
+	}
 
 	rc = zpci_dma_init_device(zdev);
 	if (rc)
@@ -684,7 +685,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
 	 * The zPCI function may already be disabled by the platform, this is
 	 * detected in clp_disable_fh() which becomes a no-op.
 	 */
-	return clp_disable_fh(zdev);
+	return clp_disable_fh(zdev) ? -EIO : 0;
 }
 
 /**
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index d3331596ddbe..0a0e8b8293be 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -213,15 +213,19 @@ int clp_query_pci_fn(struct zpci_dev *zdev)
 }
 
 static int clp_refresh_fh(u32 fid);
-/*
- * Enable/Disable a given PCI function and update its function handle if
- * necessary
+/**
+ * clp_set_pci_fn() - Execute a command on a PCI function
+ * @zdev: Function that will be affected
+ * @nr_dma_as: DMA address space number
+ * @command: The command code to execute
+ *
+ * Returns: 0 on success, < 0 for Linux errors (e.g. -ENOMEM), and
+ * > 0 for non-success platform responses
  */
 static int clp_set_pci_fn(struct zpci_dev *zdev, u8 nr_dma_as, u8 command)
 {
 	struct clp_req_rsp_set_pci *rrb;
 	int rc, retries = 100;
-	u32 fid = zdev->fid;
 
 	rrb = clp_alloc_block(GFP_KERNEL);
 	if (!rrb)
@@ -245,17 +249,16 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u8 nr_dma_as, u8 command)
 		}
 	} while (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY);
 
-	if (rc || rrb->response.hdr.rsp != CLP_RC_OK) {
-		zpci_err("Set PCI FN:\n");
-		zpci_err_clp(rrb->response.hdr.rsp, rc);
-	}
-
 	if (!rc && rrb->response.hdr.rsp == CLP_RC_OK) {
 		zdev->fh = rrb->response.fh;
-	} else if (!rc && rrb->response.hdr.rsp == CLP_RC_SETPCIFN_ALRDY &&
-			rrb->response.fh == 0) {
+	} else if (!rc && rrb->response.hdr.rsp == CLP_RC_SETPCIFN_ALRDY) {
 		/* Function is already in desired state - update handle */
-		rc = clp_refresh_fh(fid);
+		rc = clp_refresh_fh(zdev->fid);
+	} else {
+		zpci_err("Set PCI FN:\n");
+		zpci_err_clp(rrb->response.hdr.rsp, rc);
+		if (!rc)
+			rc = rrb->response.hdr.rsp;
 	}
 	clp_free_block(rrb);
 	return rc;
@@ -301,17 +304,13 @@ int clp_enable_fh(struct zpci_dev *zdev, u8 nr_dma_as)
 
 	rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_PCI_FN);
 	zpci_dbg(3, "ena fid:%x, fh:%x, rc:%d\n", zdev->fid, zdev->fh, rc);
-	if (rc)
-		goto out;
-
-	if (zpci_use_mio(zdev)) {
+	if (!rc && zpci_use_mio(zdev)) {
 		rc = clp_set_pci_fn(zdev, nr_dma_as, CLP_SET_ENABLE_MIO);
 		zpci_dbg(3, "ena mio fid:%x, fh:%x, rc:%d\n",
 				zdev->fid, zdev->fh, rc);
 		if (rc)
 			clp_disable_fh(zdev);
 	}
-out:
 	return rc;
 }
 
diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
index 95a223b3e56a..8bb92e9f4e97 100644
--- a/arch/x86/boot/compressed/efi_thunk_64.S
+++ b/arch/x86/boot/compressed/efi_thunk_64.S
@@ -5,9 +5,8 @@
  * Early support for invoking 32-bit EFI services from a 64-bit kernel.
  *
  * Because this thunking occurs before ExitBootServices() we have to
- * restore the firmware's 32-bit GDT before we make EFI service calls,
- * since the firmware's 32-bit IDT is still currently installed and it
- * needs to be able to service interrupts.
+ * restore the firmware's 32-bit GDT and IDT before we make EFI service
+ * calls.
  *
  * On the plus side, we don't have to worry about mangling 64-bit
  * addresses into 32-bits because we're executing with an identity
@@ -39,7 +38,7 @@ SYM_FUNC_START(__efi64_thunk)
 	/*
 	 * Convert x86-64 ABI params to i386 ABI
 	 */
-	subq	$32, %rsp
+	subq	$64, %rsp
 	movl	%esi, 0x0(%rsp)
 	movl	%edx, 0x4(%rsp)
 	movl	%ecx, 0x8(%rsp)
@@ -49,14 +48,19 @@ SYM_FUNC_START(__efi64_thunk)
 	leaq	0x14(%rsp), %rbx
 	sgdt	(%rbx)
 
+	addq	$16, %rbx
+	sidt	(%rbx)
+
 	/*
-	 * Switch to gdt with 32-bit segments. This is the firmware GDT
-	 * that was installed when the kernel started executing. This
-	 * pointer was saved at the EFI stub entry point in head_64.S.
+	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
+	 * and IDT that was installed when the kernel started executing. The
+	 * pointers were saved at the EFI stub entry point in head_64.S.
 	 *
 	 * Pass the saved DS selector to the 32-bit code, and use far return to
 	 * restore the saved CS selector.
 	 */
+	leaq	efi32_boot_idt(%rip), %rax
+	lidt	(%rax)
 	leaq	efi32_boot_gdt(%rip), %rax
 	lgdt	(%rax)
 
@@ -67,7 +71,7 @@ SYM_FUNC_START(__efi64_thunk)
 	pushq	%rax
 	lretq
 
-1:	addq	$32, %rsp
+1:	addq	$64, %rsp
 	movq	%rdi, %rax
 
 	pop	%rbx
@@ -128,10 +132,13 @@ SYM_FUNC_START_LOCAL(efi_enter32)
 
 	/*
 	 * Some firmware will return with interrupts enabled. Be sure to
-	 * disable them before we switch GDTs.
+	 * disable them before we switch GDTs and IDTs.
 	 */
 	cli
 
+	lidtl	(%ebx)
+	subl	$16, %ebx
+
 	lgdtl	(%ebx)
 
 	movl	%cr4, %eax
@@ -166,6 +173,11 @@ SYM_DATA_START(efi32_boot_gdt)
 	.quad	0
 SYM_DATA_END(efi32_boot_gdt)
 
+SYM_DATA_START(efi32_boot_idt)
+	.word	0
+	.quad	0
+SYM_DATA_END(efi32_boot_idt)
+
 SYM_DATA_START(efi32_boot_cs)
 	.word	0
 SYM_DATA_END(efi32_boot_cs)
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index a2347ded77ea..572c535cf45b 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -319,6 +319,9 @@ SYM_INNER_LABEL(efi32_pe_stub_entry, SYM_L_LOCAL)
 	movw	%cs, rva(efi32_boot_cs)(%ebp)
 	movw	%ds, rva(efi32_boot_ds)(%ebp)
 
+	/* Store firmware IDT descriptor */
+	sidtl	rva(efi32_boot_idt)(%ebp)
+
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2144e54a6c89..388643ca2177 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,6 +849,8 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
 		int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
@@ -862,7 +864,10 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		skcipher_request_set_crypt(&subreq, req->src, req->dst,
 					   blocks * AES_BLOCK_SIZE, req->iv);
 		req = &subreq;
+
 		err = skcipher_walk_virt(&walk, req, false);
+		if (err)
+			return err;
 	} else {
 		tail = 0;
 	}
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 921f47b9bb24..ccc9ee1971e8 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -571,6 +571,7 @@ static struct perf_ibs perf_ibs_op = {
 		.start		= perf_ibs_start,
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
+		.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index ddfb3cad8dff..2a8319fad0b7 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -265,6 +265,7 @@ enum mcp_flags {
 	MCP_TIMESTAMP	= BIT(0),	/* log time stamp */
 	MCP_UC		= BIT(1),	/* log uncorrected errors */
 	MCP_DONTLOG	= BIT(2),	/* only clear, don't log */
+	MCP_QUEUE_LOG	= BIT(3),	/* only queue to genpool */
 };
 bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index bf7fe87a7e88..01ff4014b7f6 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -817,7 +817,10 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (mca_cfg.dont_log_ce && !mce_usable_address(&m))
 			goto clear_it;
 
-		mce_log(&m);
+		if (flags & MCP_QUEUE_LOG)
+			mce_gen_pool_add(&m);
+		else
+			mce_log(&m);
 
 clear_it:
 		/*
@@ -1630,10 +1633,12 @@ static void __mcheck_cpu_init_generic(void)
 		m_fl = MCP_DONTLOG;
 
 	/*
-	 * Log the machine checks left over from the previous reset.
+	 * Log the machine checks left over from the previous reset. Log them
+	 * only, do not start processing them. That will happen in mcheck_late_init()
+	 * when all consumers have been registered on the notifier chain.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
-	machine_check_poll(MCP_UC | m_fl, &all_banks);
+	machine_check_poll(MCP_UC | MCP_QUEUE_LOG | m_fl, &all_banks);
 
 	cr4_set_bits(X86_CR4_MCE);
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 57e4bb695ff9..8caf871b796f 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -304,6 +304,12 @@ static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m = &rr->d->mbm_local[rmid];
 		break;
+	default:
+		/*
+		 * Code would never reach here because an invalid
+		 * event id would fail the __rmid_read.
+		 */
+		return RMID_VAL_ERROR;
 	}
 
 	if (rr->first) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d3783800c8c..9d76c3368364 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -257,12 +257,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
-	/* Check if guest physical address doesn't exceed guest maximum */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, gpa)) {
-		exception->error_code |= PFERR_RSVD_MASK;
-		return UNMAPPED_GVA;
-	}
-
         return gpa;
 }
 
@@ -2760,6 +2754,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      kvm_pfn_t pfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
+	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -2771,7 +2766,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	return host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	return min(host_level, max_level);
 }
 
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2795,17 +2791,12 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PG_LEVEL_4K;
 
-	level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
-	if (level == PG_LEVEL_4K)
-		return level;
-
-	*req_level = level = min(level, max_level);
-
 	/*
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	if (huge_page_disallowed)
+	*req_level = level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
+	if (level == PG_LEVEL_4K || huge_page_disallowed)
 		return PG_LEVEL_4K;
 
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 41ef3ed5349f..3c225bc0c082 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -410,6 +410,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_large, is_large;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -443,13 +444,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
-	if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
-		if (is_large_pte(old_spte))
-			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
-		else
-			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
-	}
-
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
@@ -475,6 +469,18 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		return;
 	}
 
+	/*
+	 * Update large page stats if a large page is being zapped, created, or
+	 * is replacing an existing shadow page.
+	 */
+	was_large = was_leaf && is_large_pte(old_spte);
+	is_large = is_leaf && is_large_pte(new_spte);
+	if (was_large != is_large) {
+		if (was_large)
+			atomic64_sub(1, (atomic64_t *)&kvm->stat.lpages);
+		else
+			atomic64_add(1, (atomic64_t *)&kvm->stat.lpages);
+	}
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index df3b7e564416..1d47f2dbe3e9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2226,12 +2226,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
-	if (nested_cpu_has_posted_intr(vmcs12)) {
+	vmx->nested.pi_pending = false;
+	if (nested_cpu_has_posted_intr(vmcs12))
 		vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
-		vmx->nested.pi_pending = false;
-	} else {
+	else
 		exec_control &= ~PIN_BASED_POSTED_INTR;
-	}
 	pin_controls_set(vmx, exec_control);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcd4f43c23de..6af7d0b0c154 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6452,6 +6452,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->emulation_required)
+		return;
+
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e11198f8993..93e851041c9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3223,6 +3223,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				/* Before back to guest, tsc_timestamp must be adjusted
+				 * as well, otherwise guest's percpu pvclock time could jump.
+				 */
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index eccbe2aed7c3..4df33cc08eee 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2333,6 +2333,9 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	__rq = bfq_find_rq_fmerge(bfqd, bio, q);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_FRONT_MERGE;
 	}
 
diff --git a/block/bio.c b/block/bio.c
index 1fab762e079b..d95e3456ba0c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -979,6 +979,14 @@ static int bio_iov_bvec_set_append(struct bio *bio, struct iov_iter *iter)
 	return 0;
 }
 
+static void bio_put_pages(struct page **pages, size_t size, size_t off)
+{
+	size_t i, nr = DIV_ROUND_UP(size + (off & ~PAGE_MASK), PAGE_SIZE);
+
+	for (i = 0; i < nr; i++)
+		put_page(pages[i]);
+}
+
 #define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
 
 /**
@@ -1023,8 +1031,10 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio, len)))
-                                return -EINVAL;
+			if (WARN_ON_ONCE(bio_full(bio, len))) {
+				bio_put_pages(pages + i, left, offset);
+				return -EINVAL;
+			}
 			__bio_add_page(bio, page, len, offset);
 		}
 		offset = 0;
@@ -1069,6 +1079,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 		if (bio_add_hw_page(q, bio, page, len, offset,
 				max_append_sectors, &same_page) != len) {
+			bio_put_pages(pages + i, left, offset);
 			ret = -EINVAL;
 			break;
 		}
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index c5bdaafffa29..103c2e2d50d6 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -332,7 +332,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	if (mode->keysize == 0)
 		return -EINVAL;
 
-	if (dun_bytes == 0 || dun_bytes > BLK_CRYPTO_MAX_IV_SIZE)
+	if (dun_bytes == 0 || dun_bytes > mode->ivsize)
 		return -EINVAL;
 
 	if (!is_power_of_2(data_unit_size))
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bcdff1879c34..526953525e35 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -348,6 +348,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
+
+		blk_throtl_charge_bio_split(*bio);
 	}
 }
 
@@ -705,22 +707,6 @@ static void blk_account_io_merge_request(struct request *req)
 	}
 }
 
-/*
- * Two cases of handling DISCARD merge:
- * If max_discard_segments > 1, the driver takes every bio
- * as a range and send them to controller together. The ranges
- * needn't to be contiguous.
- * Otherwise, the bios/requests will be handled as same as
- * others which should be contiguous.
- */
-static inline bool blk_discard_mergable(struct request *req)
-{
-	if (req_op(req) == REQ_OP_DISCARD &&
-	    queue_max_discard_segments(req->q) > 1)
-		return true;
-	return false;
-}
-
 static enum elv_merge blk_try_req_merge(struct request *req,
 					struct request *next)
 {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b1b22d863bdf..55c49015e533 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -178,6 +178,9 @@ struct throtl_grp {
 	unsigned int bad_bio_cnt; /* bios exceeding latency threshold */
 	unsigned long bio_cnt_reset_time;
 
+	atomic_t io_split_cnt[2];
+	atomic_t last_io_split_cnt[2];
+
 	struct blkg_rwstat stat_bytes;
 	struct blkg_rwstat stat_ios;
 };
@@ -777,6 +780,8 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
 
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	/*
 	 * Previous slice has expired. We must have trimmed it after last
 	 * bio dispatch. That means since start of last slice, we never used
@@ -799,6 +804,9 @@ static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
 	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
+
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	throtl_log(&tg->service_queue,
 		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
 		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
@@ -1031,6 +1039,9 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 				jiffies + tg->td->throtl_slice);
 	}
 
+	if (iops_limit != UINT_MAX)
+		tg->io_disp[rw] += atomic_xchg(&tg->io_split_cnt[rw], 0);
+
 	if (tg_with_in_bps_limit(tg, bio, bps_limit, &bps_wait) &&
 	    tg_with_in_iops_limit(tg, bio, iops_limit, &iops_wait)) {
 		if (wait)
@@ -2052,12 +2063,14 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 	}
 
 	if (tg->iops[READ][LIMIT_LOW]) {
+		tg->last_io_disp[READ] += atomic_xchg(&tg->last_io_split_cnt[READ], 0);
 		iops = tg->last_io_disp[READ] * HZ / elapsed_time;
 		if (iops >= tg->iops[READ][LIMIT_LOW])
 			tg->last_low_overflow_time[READ] = now;
 	}
 
 	if (tg->iops[WRITE][LIMIT_LOW]) {
+		tg->last_io_disp[WRITE] += atomic_xchg(&tg->last_io_split_cnt[WRITE], 0);
 		iops = tg->last_io_disp[WRITE] * HZ / elapsed_time;
 		if (iops >= tg->iops[WRITE][LIMIT_LOW])
 			tg->last_low_overflow_time[WRITE] = now;
@@ -2176,6 +2189,25 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
+void blk_throtl_charge_bio_split(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct throtl_grp *parent = blkg_to_tg(blkg);
+	struct throtl_service_queue *parent_sq;
+	bool rw = bio_data_dir(bio);
+
+	do {
+		if (!parent->has_rules[rw])
+			break;
+
+		atomic_inc(&parent->io_split_cnt[rw]);
+		atomic_inc(&parent->last_io_split_cnt[rw]);
+
+		parent_sq = parent->service_queue.parent_sq;
+		parent = sq_to_tg(parent_sq);
+	} while (parent);
+}
+
 bool blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
diff --git a/block/blk.h b/block/blk.h
index 54d48987c21b..40b00d18bdb2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -290,11 +290,13 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_mask, int node);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern void blk_throtl_register_queue(struct request_queue *q);
+extern void blk_throtl_charge_bio_split(struct bio *bio);
 bool blk_throtl_bio(struct bio *bio);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
+static inline void blk_throtl_charge_bio_split(struct bio *bio) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
diff --git a/block/elevator.c b/block/elevator.c
index 440699c28119..73e0591acfd4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -336,6 +336,9 @@ enum elv_merge elv_merge(struct request_queue *q, struct request **req,
 	__rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_BACK_MERGE;
 	}
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 8eea2cbf2bf4..8dca7255d04c 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -454,6 +454,8 @@ static int dd_request_merge(struct request_queue *q, struct request **rq,
 
 		if (elv_bio_merge_ok(__rq, bio)) {
 			*rq = __rq;
+			if (blk_discard_mergable(__rq))
+				return ELEVATOR_DISCARD_MERGE;
 			return ELEVATOR_FRONT_MERGE;
 		}
 	}
diff --git a/certs/Makefile b/certs/Makefile
index 359239a0ee9e..f9344e52ecda 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -57,11 +57,19 @@ endif
 redirect_openssl	= 2>&1
 quiet_redirect_openssl	= 2>&1
 silent_redirect_openssl = 2>/dev/null
+openssl_available       = $(shell openssl help 2>/dev/null && echo yes)
 
 # We do it this way rather than having a boolean option for enabling an
 # external private key, because 'make randconfig' might enable such a
 # boolean option and we unfortunately can't make it depend on !RANDCONFIG.
 ifeq ($(CONFIG_MODULE_SIG_KEY),"certs/signing_key.pem")
+
+ifeq ($(openssl_available),yes)
+X509TEXT=$(shell openssl x509 -in "certs/signing_key.pem" -text 2>/dev/null)
+
+$(if $(findstring rsaEncryption,$(X509TEXT)),,$(shell rm -f "certs/signing_key.pem"))
+endif
+
 $(obj)/signing_key.pem: $(obj)/x509.genkey
 	@$(kecho) "###"
 	@$(kecho) "### Now generating an X.509 key pair to be used for signing modules."
diff --git a/crypto/Makefile b/crypto/Makefile
index 10526d4559b8..c633f15a0481 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,7 +74,6 @@ obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
-obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
diff --git a/crypto/ecc.h b/crypto/ecc.h
index a006132646a4..1350e8eb6ac2 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -27,6 +27,7 @@
 #define _CRYPTO_ECC_H
 
 #include <crypto/ecc_curve.h>
+#include <asm/unaligned.h>
 
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
@@ -46,13 +47,13 @@
  * @out:      Output array
  * @ndigits:  Number of digits to copy
  */
-static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
+static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigits)
 {
 	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
+		out[i] = get_unaligned_be64(&src[ndigits - 1 - i]);
 }
 
 /**
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6b7c158dc508..f9c00875bc0e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -290,6 +290,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	}
 
 	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_free_tfm;
+	}
 
 	for (i = 0; i < num_mb; ++i)
 		if (testmgr_alloc_buf(data[i].xbuf)) {
@@ -315,7 +320,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			pr_err("alg: aead: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				aead_request_free(data[i].req);
@@ -567,13 +572,19 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	sgout = &sg[9];
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
-
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		goto out_notfm;
 	}
 
+	ret = crypto_aead_setauthsize(tfm, authsize);
+	if (ret) {
+		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
+		       ret);
+		goto out_noreq;
+	}
+
 	crypto_init_wait(&wait);
 	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
 			get_driver_name(crypto_aead, tfm), e);
@@ -611,8 +622,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 					break;
 				}
 			}
+
 			ret = crypto_aead_setkey(tfm, key, *keysize);
-			ret = crypto_aead_setauthsize(tfm, authsize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x: %d\n",
+					crypto_aead_get_flags(tfm), ret);
+				goto out;
+			}
 
 			iv_len = crypto_aead_ivsize(tfm);
 			if (iv_len)
@@ -622,15 +638,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
 					i, *keysize * 8, bs);
 
-
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
-			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
-						crypto_aead_get_flags(tfm));
-				goto out;
-			}
-
 			sg_init_aead(sg, xbuf, bs + (enc ? 0 : authsize),
 				     assoc, aad_size);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..44f434acfce0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 2e5e7c993933..8b2a0eb3f32a 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -323,8 +323,8 @@ static int hd44780_remove(struct platform_device *pdev)
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
 
-	kfree(lcd->drvdata);
 	charlcd_unregister(lcd);
+	kfree(lcd->drvdata);
 
 	kfree(lcd);
 	return 0;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 592b3955abe2..a421da0c9c01 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -560,7 +560,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
-	if (driver_sysfs_add(dev)) {
+	ret = driver_sysfs_add(dev);
+	if (ret) {
 		pr_err("%s: driver_sysfs_add(%s) failed\n",
 		       __func__, dev_name(dev));
 		goto probe_failed;
@@ -582,15 +583,18 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
-	if (device_add_groups(dev, drv->dev_groups)) {
+	ret = device_add_groups(dev, drv->dev_groups);
+	if (ret) {
 		dev_err(dev, "device_add_groups() failed\n");
 		goto dev_groups_failed;
 	}
 
-	if (dev_has_sync_state(dev) &&
-	    device_create_file(dev, &dev_attr_state_synced)) {
-		dev_err(dev, "state_synced sysfs add failed\n");
-		goto dev_sysfs_state_synced_failed;
+	if (dev_has_sync_state(dev)) {
+		ret = device_create_file(dev, &dev_attr_state_synced);
+		if (ret) {
+			dev_err(dev, "state_synced sysfs add failed\n");
+			goto dev_sysfs_state_synced_failed;
+		}
 	}
 
 	if (test_remove) {
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 68c549d71230..bdbedc6660a8 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -165,7 +165,7 @@ static inline int fw_state_wait(struct fw_priv *fw_priv)
 	return __fw_state_wait_common(fw_priv, MAX_SCHEDULE_TIMEOUT);
 }
 
-static int fw_cache_piggyback_on_request(const char *name);
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv);
 
 static struct fw_priv *__allocate_fw_priv(const char *fw_name,
 					  struct firmware_cache *fwc,
@@ -707,10 +707,8 @@ int assign_fw(struct firmware *fw, struct device *device)
 	 * on request firmware.
 	 */
 	if (!(fw_priv->opt_flags & FW_OPT_NOCACHE) &&
-	    fw_priv->fwc->state == FW_LOADER_START_CACHE) {
-		if (fw_cache_piggyback_on_request(fw_priv->fw_name))
-			kref_get(&fw_priv->ref);
-	}
+	    fw_priv->fwc->state == FW_LOADER_START_CACHE)
+		fw_cache_piggyback_on_request(fw_priv);
 
 	/* pass the pages buffer to driver at the last minute */
 	fw_set_page_data(fw_priv, fw);
@@ -1259,11 +1257,11 @@ static int __fw_entry_found(const char *name)
 	return 0;
 }
 
-static int fw_cache_piggyback_on_request(const char *name)
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv)
 {
-	struct firmware_cache *fwc = &fw_cache;
+	const char *name = fw_priv->fw_name;
+	struct firmware_cache *fwc = fw_priv->fwc;
 	struct fw_cache_entry *fce;
-	int ret = 0;
 
 	spin_lock(&fwc->name_lock);
 	if (__fw_entry_found(name))
@@ -1271,13 +1269,12 @@ static int fw_cache_piggyback_on_request(const char *name)
 
 	fce = alloc_fw_cache_entry(name);
 	if (fce) {
-		ret = 1;
 		list_add(&fce->list, &fwc->fw_names);
+		kref_get(&fw_priv->ref);
 		pr_debug("%s: fw: %s\n", __func__, name);
 	}
 found:
 	spin_unlock(&fwc->name_lock);
-	return ret;
 }
 
 static void free_fw_cache_entry(struct fw_cache_entry *fce)
@@ -1508,9 +1505,8 @@ static inline void unregister_fw_pm_ops(void)
 	unregister_pm_notifier(&fw_cache.pm_notify);
 }
 #else
-static int fw_cache_piggyback_on_request(const char *name)
+static void fw_cache_piggyback_on_request(struct fw_priv *fw_priv)
 {
-	return 0;
 }
 static inline int register_fw_pm_ops(void)
 {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 297e95be25b3..cf1dca0cde2c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1652,7 +1652,7 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 			if (ret) {
 				dev_err(map->dev,
 					"Error in caching of register: %x ret: %d\n",
-					reg + i, ret);
+					reg + regmap_get_offset(map, i), ret);
 				return ret;
 			}
 		}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 6535614a7dc1..1df2b5801c3b 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -236,6 +236,7 @@ EXPORT_SYMBOL(bcma_core_irq);
 
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
+	device_initialize(&core->dev);
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
@@ -277,11 +278,10 @@ static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
 
-	err = device_register(&core->dev);
+	err = device_add(&core->dev);
 	if (err) {
 		bcma_err(bus, "Could not register dev for core 0x%03X\n",
 			 core->id.id);
-		put_device(&core->dev);
 		return;
 	}
 	core->dev_registered = true;
@@ -372,7 +372,7 @@ void bcma_unregister_cores(struct bcma_bus *bus)
 	/* Now noone uses internally-handled cores, we can free them */
 	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
 		list_del(&core->list);
-		kfree(core);
+		put_device(&core->dev);
 	}
 }
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 1061894a55df..4acf5c6cb80d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1369,6 +1369,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		       unsigned int cmd, unsigned long arg)
 {
 	struct nbd_config *config = nbd->config;
+	loff_t bytesize;
 
 	switch (cmd) {
 	case NBD_DISCONNECT:
@@ -1383,8 +1384,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_SIZE:
 		return nbd_set_size(nbd, arg, config->blksize);
 	case NBD_SET_SIZE_BLOCKS:
-		return nbd_set_size(nbd, arg * config->blksize,
-				    config->blksize);
+		if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
+			return -EINVAL;
+		return nbd_set_size(nbd, bytesize, config->blksize);
 	case NBD_SET_TIMEOUT:
 		nbd_set_cmd_timeout(nbd, arg);
 		return 0;
@@ -1715,7 +1717,17 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
+
+	/* Too big first_minor can cause duplicate creation of
+	 * sysfs files/links, since first_minor will be truncated to
+	 * byte in __device_add_disk().
+	 */
 	disk->first_minor = index << part_shift;
+	if (disk->first_minor > 0xff) {
+		err = -EINVAL;
+		goto out_free_idr;
+	}
+
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9122f9cc97cb..ae0cf5e71584 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2912,10 +2912,11 @@ static int btusb_setup_intel_new(struct hci_dev *hdev)
 	/* Read the Intel supported features and if new exception formats
 	 * supported, need to load the additional DDC config to enable.
 	 */
-	btintel_read_debug_features(hdev, &features);
-
-	/* Set DDC mask for available debug features */
-	btintel_set_debug_features(hdev, &features);
+	err = btintel_read_debug_features(hdev, &features);
+	if (!err) {
+		/* Set DDC mask for available debug features */
+		btintel_set_debug_features(hdev, &features);
+	}
 
 	/* Read the Intel version information after loading the FW  */
 	err = btintel_read_version(hdev, &ver);
@@ -3008,10 +3009,11 @@ static int btusb_setup_intel_newgen(struct hci_dev *hdev)
 	/* Read the Intel supported features and if new exception formats
 	 * supported, need to load the additional DDC config to enable.
 	 */
-	btintel_read_debug_features(hdev, &features);
-
-	/* Set DDC mask for available debug features */
-	btintel_set_debug_features(hdev, &features);
+	err = btintel_read_debug_features(hdev, &features);
+	if (!err) {
+		/* Set DDC mask for available debug features */
+		btintel_set_debug_features(hdev, &features);
+	}
 
 	/* Read the Intel version information after loading the FW  */
 	err = btintel_read_version_tlv(hdev, &version);
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 4308f9ca7a43..d6ba644f6b00 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -89,7 +89,6 @@ config TCG_TIS_SYNQUACER
 config TCG_TIS_I2C_CR50
 	tristate "TPM Interface Specification 2.0 Interface (I2C - CR50)"
 	depends on I2C
-	select TCG_CR50
 	help
 	  This is a driver for the Google cr50 I2C TPM interface which is a
 	  custom microcontroller and requires a custom i2c protocol interface
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 903604769de9..3af4c07a9342 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -106,17 +106,12 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
 	u16 len;
-	int sig;
 
 	if (!ibmvtpm->rtce_buf) {
 		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
 		return 0;
 	}
 
-	sig = wait_event_interruptible(ibmvtpm->wq, !ibmvtpm->tpm_processing_cmd);
-	if (sig)
-		return -EINTR;
-
 	len = ibmvtpm->res_len;
 
 	if (count < len) {
@@ -237,7 +232,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	 * set the processing flag before the Hcall, since we may get the
 	 * result (interrupt) before even being able to check rc.
 	 */
-	ibmvtpm->tpm_processing_cmd = true;
+	ibmvtpm->tpm_processing_cmd = 1;
 
 again:
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
@@ -255,7 +250,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 			goto again;
 		}
 		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
-		ibmvtpm->tpm_processing_cmd = false;
+		ibmvtpm->tpm_processing_cmd = 0;
 	}
 
 	spin_unlock(&ibmvtpm->rtce_lock);
@@ -269,7 +264,9 @@ static void tpm_ibmvtpm_cancel(struct tpm_chip *chip)
 
 static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
 {
-	return 0;
+	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+
+	return ibmvtpm->tpm_processing_cmd;
 }
 
 /**
@@ -457,7 +454,7 @@ static const struct tpm_class_ops tpm_ibmvtpm = {
 	.send = tpm_ibmvtpm_send,
 	.cancel = tpm_ibmvtpm_cancel,
 	.status = tpm_ibmvtpm_status,
-	.req_complete_mask = 0,
+	.req_complete_mask = 1,
 	.req_complete_val = 0,
 	.req_canceled = tpm_ibmvtpm_req_canceled,
 };
@@ -550,7 +547,7 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 		case VTPM_TPM_COMMAND_RES:
 			/* len of the data in rtce buffer */
 			ibmvtpm->res_len = be16_to_cpu(crq->len);
-			ibmvtpm->tpm_processing_cmd = false;
+			ibmvtpm->tpm_processing_cmd = 0;
 			wake_up_interruptible(&ibmvtpm->wq);
 			return;
 		default:
@@ -688,8 +685,15 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 		goto init_irq_cleanup;
 	}
 
-	if (!strcmp(id->compat, "IBM,vtpm20")) {
+
+	if (!strcmp(id->compat, "IBM,vtpm20"))
 		chip->flags |= TPM_CHIP_FLAG_TPM2;
+
+	rc = tpm_get_timeouts(chip);
+	if (rc)
+		goto init_irq_cleanup;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_get_cc_attrs_tbl(chip);
 		if (rc)
 			goto init_irq_cleanup;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
index b92aa7d3e93e..51198b137461 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.h
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -41,7 +41,7 @@ struct ibmvtpm_dev {
 	wait_queue_head_t wq;
 	u16 res_len;
 	u32 vtpm_version;
-	bool tpm_processing_cmd;
+	u8 tpm_processing_cmd;
 };
 
 #define CRQ_RES_BUF_SIZE	PAGE_SIZE
diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index 47680237d0be..8bc893df4736 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -265,6 +265,7 @@ static const char *powersave_parents[] = {
 static const struct clk_muxing_soc_desc kirkwood_mux_desc[] __initconst = {
 	{ "powersave", powersave_parents, ARRAY_SIZE(powersave_parents),
 		11, 1, 0 },
+	{ }
 };
 
 static struct clk *clk_muxing_get_src(
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index d7ed99f0001f..dd0956ad969c 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -579,7 +579,8 @@ static int sh_cmt_start(struct sh_cmt_channel *ch, unsigned long flag)
 	ch->flags |= flag;
 
 	/* setup timeout if no clockevent */
-	if ((flag == FLAG_CLOCKSOURCE) && (!(ch->flags & FLAG_CLOCKEVENT)))
+	if (ch->cmt->num_channels == 1 &&
+	    flag == FLAG_CLOCKSOURCE && (!(ch->flags & FLAG_CLOCKEVENT)))
 		__sh_cmt_set_next(ch, ch->max_match_value);
  out:
 	raw_spin_unlock_irqrestore(&ch->lock, flags);
@@ -621,20 +622,25 @@ static struct sh_cmt_channel *cs_to_sh_cmt(struct clocksource *cs)
 static u64 sh_cmt_clocksource_read(struct clocksource *cs)
 {
 	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
-	unsigned long flags;
 	u32 has_wrapped;
-	u64 value;
-	u32 raw;
 
-	raw_spin_lock_irqsave(&ch->lock, flags);
-	value = ch->total_cycles;
-	raw = sh_cmt_get_counter(ch, &has_wrapped);
+	if (ch->cmt->num_channels == 1) {
+		unsigned long flags;
+		u64 value;
+		u32 raw;
 
-	if (unlikely(has_wrapped))
-		raw += ch->match_value + 1;
-	raw_spin_unlock_irqrestore(&ch->lock, flags);
+		raw_spin_lock_irqsave(&ch->lock, flags);
+		value = ch->total_cycles;
+		raw = sh_cmt_get_counter(ch, &has_wrapped);
+
+		if (unlikely(has_wrapped))
+			raw += ch->match_value + 1;
+		raw_spin_unlock_irqrestore(&ch->lock, flags);
+
+		return value + raw;
+	}
 
-	return value + raw;
+	return sh_cmt_get_counter(ch, &has_wrapped);
 }
 
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
@@ -697,7 +703,7 @@ static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
 	cs->disable = sh_cmt_clocksource_disable;
 	cs->suspend = sh_cmt_clocksource_suspend;
 	cs->resume = sh_cmt_clocksource_resume;
-	cs->mask = CLOCKSOURCE_MASK(sizeof(u64) * 8);
+	cs->mask = CLOCKSOURCE_MASK(ch->cmt->info->width);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
 	dev_info(&ch->cmt->pdev->dev, "ch%u: used as clock source\n",
diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 9691f8612be8..8de776f3b142 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -715,12 +715,13 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	case 1:
 	case 3:
 		quad8_preset_register_set(priv, count->id, ceiling);
-		break;
+		mutex_unlock(&priv->lock);
+		return len;
 	}
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return -EINVAL;
 }
 
 static ssize_t quad8_count_preset_enable_read(struct counter_device *counter,
diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index dfdce2f21e65..1aeb53f28edd 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -140,11 +140,6 @@ struct sec_ctx {
 	struct device *dev;
 };
 
-enum sec_endian {
-	SEC_LE = 0,
-	SEC_32BE,
-	SEC_64BE
-};
 
 enum sec_debug_file_index {
 	SEC_CLEAR_ENABLE,
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 6f0062d4408c..0305e656b477 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -304,31 +304,20 @@ static const struct pci_device_id sec_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, sec_dev_ids);
 
-static u8 sec_get_endian(struct hisi_qm *qm)
+static void sec_set_endian(struct hisi_qm *qm)
 {
 	u32 reg;
 
-	/*
-	 * As for VF, it is a wrong way to get endian setting by
-	 * reading a register of the engine
-	 */
-	if (qm->pdev->is_virtfn) {
-		dev_err_ratelimited(&qm->pdev->dev,
-				    "cannot access a register in VF!\n");
-		return SEC_LE;
-	}
 	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	/* BD little endian mode */
-	if (!(reg & BIT(0)))
-		return SEC_LE;
+	reg &= ~(BIT(1) | BIT(0));
+	if (!IS_ENABLED(CONFIG_64BIT))
+		reg |= BIT(1);
 
-	/* BD 32-bits big endian mode */
-	else if (!(reg & BIT(1)))
-		return SEC_32BE;
 
-	/* BD 64-bits big endian mode */
-	else
-		return SEC_64BE;
+	if (!IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+		reg |= BIT(0);
+
+	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
 static int sec_engine_init(struct hisi_qm *qm)
@@ -382,9 +371,7 @@ static int sec_engine_init(struct hisi_qm *qm)
 		       qm->io_base + SEC_BD_ERR_CHK_EN_REG3);
 
 	/* config endian */
-	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	reg |= sec_get_endian(qm);
-	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
+	sec_set_endian(qm);
 
 	return 0;
 }
@@ -921,7 +908,8 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_alg_unregister:
-	hisi_qm_alg_unregister(qm, &sec_devices);
+	if (qm->qp_num >= ctx_q_num)
+		hisi_qm_alg_unregister(qm, &sec_devices);
 err_qm_stop:
 	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6a7784d2988..f397cc5bf102 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -170,15 +170,19 @@ static struct dcp *global_sdcp;
 
 static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 {
+	int dma_err;
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
 	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
 					      DMA_TO_DEVICE);
 
+	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
+	if (dma_err)
+		return dma_err;
+
 	reinit_completion(&sdcp->completion[chan]);
 
 	/* Clear status register. */
@@ -216,18 +220,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
-	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
-					     2 * AES_KEYSIZE_128,
-					     DMA_TO_DEVICE);
-	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
-					     DCP_BUF_SZ, DMA_FROM_DEVICE);
+	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
+				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
+
+	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
+				  DCP_BUF_SZ, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, src_phys);
+	if (ret)
+		goto err_src;
+
+	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
+				  DCP_BUF_SZ, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, dst_phys);
+	if (ret)
+		goto err_dst;
 
 	if (actx->fill % AES_BLOCK_SIZE) {
 		dev_err(sdcp->dev, "Invalid block size!\n");
@@ -265,10 +280,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	ret = mxs_dcp_start_dma(actx);
 
 aes_done_run:
+	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
+err_dst:
+	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
+err_src:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
 
 	return ret;
 }
@@ -557,6 +574,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
+	ret = dma_mapping_error(sdcp->dev, buf_phys);
+	if (ret)
+		return ret;
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -589,6 +610,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	if (rctx->fini) {
 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
+		ret = dma_mapping_error(sdcp->dev, digest_phys);
+		if (ret)
+			goto done_run;
+
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 0dd4c6b157de..9b968ac4ee7b 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1175,9 +1175,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	spin_lock_init(&dd->lock);
 
 	INIT_LIST_HEAD(&dd->list);
-	spin_lock(&list_lock);
+	spin_lock_bh(&list_lock);
 	list_add_tail(&dd->list, &dev_list);
-	spin_unlock(&list_lock);
+	spin_unlock_bh(&list_lock);
 
 	/* Initialize crypto engine */
 	dd->engine = crypto_engine_alloc_init(dev, 1);
@@ -1264,9 +1264,9 @@ static int omap_aes_remove(struct platform_device *pdev)
 	if (!dd)
 		return -ENODEV;
 
-	spin_lock(&list_lock);
+	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
-	spin_unlock(&list_lock);
+	spin_unlock_bh(&list_lock);
 
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--) {
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index c9d38bcfd1c7..7fdf38e07adf 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1035,9 +1035,9 @@ static int omap_des_probe(struct platform_device *pdev)
 
 
 	INIT_LIST_HEAD(&dd->list);
-	spin_lock(&list_lock);
+	spin_lock_bh(&list_lock);
 	list_add_tail(&dd->list, &dev_list);
-	spin_unlock(&list_lock);
+	spin_unlock_bh(&list_lock);
 
 	/* Initialize des crypto engine */
 	dd->engine = crypto_engine_alloc_init(dev, 1);
@@ -1096,9 +1096,9 @@ static int omap_des_remove(struct platform_device *pdev)
 	if (!dd)
 		return -ENODEV;
 
-	spin_lock(&list_lock);
+	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
-	spin_unlock(&list_lock);
+	spin_unlock_bh(&list_lock);
 
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index dd53ad9987b0..63beea7cdba5 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1736,7 +1736,7 @@ static void omap_sham_done_task(unsigned long data)
 		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
 			goto finish;
 	} else if (test_bit(FLAGS_DMA_READY, &dd->flags)) {
-		if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
+		if (test_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
 			omap_sham_update_dma_stop(dd);
 			if (dd->err) {
 				err = dd->err;
@@ -2144,9 +2144,9 @@ static int omap_sham_probe(struct platform_device *pdev)
 		(rev & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		(rev & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	spin_lock(&sham.lock);
+	spin_lock_bh(&sham.lock);
 	list_add_tail(&dd->list, &sham.dev_list);
-	spin_unlock(&sham.lock);
+	spin_unlock_bh(&sham.lock);
 
 	dd->engine = crypto_engine_alloc_init(dev, 1);
 	if (!dd->engine) {
@@ -2194,9 +2194,9 @@ static int omap_sham_probe(struct platform_device *pdev)
 err_engine_start:
 	crypto_engine_exit(dd->engine);
 err_engine:
-	spin_lock(&sham.lock);
+	spin_lock_bh(&sham.lock);
 	list_del(&dd->list);
-	spin_unlock(&sham.lock);
+	spin_unlock_bh(&sham.lock);
 err_pm:
 	pm_runtime_disable(dev);
 	if (!dd->polling_mode)
@@ -2215,9 +2215,9 @@ static int omap_sham_remove(struct platform_device *pdev)
 	dd = platform_get_drvdata(pdev);
 	if (!dd)
 		return -ENODEV;
-	spin_lock(&sham.lock);
+	spin_lock_bh(&sham.lock);
 	list_del(&dd->list);
-	spin_unlock(&sham.lock);
+	spin_unlock_bh(&sham.lock);
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--) {
 			crypto_unregister_ahash(
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 15f6b9bdfb22..ddf42fb32625 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index d231583428c9..7e202ef92523 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index c61476553728..dd4a811b7e89 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -198,8 +198,8 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
@@ -222,12 +222,12 @@ static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
 
-static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 744c40351428..02864985dbb0 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -61,6 +61,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int ret;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -127,9 +128,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 
 	hw_data->enable_error_correction(accel_dev);
-	hw_data->enable_vf2pf_comms(accel_dev);
+	ret = hw_data->enable_vf2pf_comms(accel_dev);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_dev_init);
 
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index e3ad5587be49..daab02011717 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -15,6 +15,8 @@
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
+#define ADF_MAX_NUM_VFS	32
+
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -72,7 +74,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-		u32 vf_mask;
+		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
 		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
@@ -93,8 +95,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			 * unless the VF is malicious and is attempting to
 			 * flood the host OS with VF2PF interrupts.
 			 */
-			for_each_set_bit(i, (const unsigned long *)&vf_mask,
-					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
 				vf_info = accel_dev->pf.vf_info + i;
 
 				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index a1b77bd7a894..efa4bffb4f60 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -186,7 +186,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
@@ -316,6 +315,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index e85bd62d134a..3e25fac051b2 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -5,14 +5,14 @@
 #include "adf_pf2vf_msg.h"
 
 /**
- * adf_vf2pf_init() - send init msg to PF
+ * adf_vf2pf_notify_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends an init message from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -25,17 +25,17 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_init);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
 
 /**
- * adf_vf2pf_shutdown() - send shutdown msg to PF
+ * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends a shutdown message from the VF to a PF
  *
  * Return: void
  */
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -45,4 +45,4 @@ void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send Shutdown event to PF\n");
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 888388acb6bd..3e4f64d248f9 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -160,6 +160,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	bool handled = false;
 	u32 v_int;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
@@ -172,7 +173,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 
 		/* Schedule tasklet to handle interrupt BH */
 		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
 	/* Check bundle interrupt */
@@ -184,10 +185,10 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 		csr_ops->write_csr_int_flag_and_col(bank->csr_addr,
 						    bank->bank_number, 0);
 		tasklet_hi_schedule(&bank->resp_handler);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
-	return IRQ_NONE;
+	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index f14fb82ed6df..744734caaf7b 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 37b4e875420e..1cea5d8fa434 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -26,8 +26,8 @@
 	pci_read_config_dword((d)->uracu, 0xd8 + (i) * 4, &(reg))
 #define I10NM_GET_DIMMMTR(m, i, j)	\
 	readl((m)->mbase + 0x2080c + (i) * (m)->chan_mmio_sz + (j) * 4)
-#define I10NM_GET_MCDDRTCFG(m, i, j)	\
-	readl((m)->mbase + 0x20970 + (i) * (m)->chan_mmio_sz + (j) * 4)
+#define I10NM_GET_MCDDRTCFG(m, i)	\
+	readl((m)->mbase + 0x20970 + (i) * (m)->chan_mmio_sz)
 #define I10NM_GET_MCMTR(m, i)		\
 	readl((m)->mbase + 0x20ef8 + (i) * (m)->chan_mmio_sz)
 #define I10NM_GET_AMAP(m, i)		\
@@ -185,10 +185,10 @@ static int i10nm_get_dimm_config(struct mem_ctl_info *mci,
 
 		ndimms = 0;
 		amap = I10NM_GET_AMAP(imc, i);
+		mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i);
 		for (j = 0; j < I10NM_NUM_DIMMS; j++) {
 			dimm = edac_get_dimm(mci, i, j, 0);
 			mtr = I10NM_GET_DIMMMTR(imc, i, j);
-			mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i, j);
 			edac_dbg(1, "dimmmtr 0x%x mcddrtcfg 0x%x (mc%d ch%d dimm%d)\n",
 				 mtr, mcddrtcfg, imc->mc, i, j);
 
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5dd905a3f30c..1a1629166aa3 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1176,6 +1176,9 @@ static int __init mce_amd_init(void)
 	    c->x86_vendor != X86_VENDOR_HYGON)
 		return -ENODEV;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	if (boot_cpu_has(X86_FEATURE_SMCA)) {
 		xec_mask = 0x3f;
 		goto out;
diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index 250e01680742..4b8978b254f9 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -329,12 +329,18 @@ struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 
 	fw = platform_get_drvdata(pdev);
 	if (!fw)
-		return NULL;
+		goto err_put_device;
 
 	if (!kref_get_unless_zero(&fw->consumers))
-		return NULL;
+		goto err_put_device;
+
+	put_device(&pdev->dev);
 
 	return fw;
+
+err_put_device:
+	put_device(&pdev->dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_get);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
index b8655ff73a65..cc9c9f8b23b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -160,17 +160,28 @@ static int acp_poweron(struct generic_pm_domain *genpd)
 	return 0;
 }
 
-static struct device *get_mfd_cell_dev(const char *device_name, int r)
+static int acp_genpd_add_device(struct device *dev, void *data)
 {
-	char auto_dev_name[25];
-	struct device *dev;
+	struct generic_pm_domain *gpd = data;
+	int ret;
 
-	snprintf(auto_dev_name, sizeof(auto_dev_name),
-		 "%s.%d.auto", device_name, r);
-	dev = bus_find_device_by_name(&platform_bus_type, NULL, auto_dev_name);
-	dev_info(dev, "device %s added to pm domain\n", auto_dev_name);
+	ret = pm_genpd_add_device(gpd, dev);
+	if (ret)
+		dev_err(dev, "Failed to add dev to genpd %d\n", ret);
 
-	return dev;
+	return ret;
+}
+
+static int acp_genpd_remove_device(struct device *dev, void *data)
+{
+	int ret;
+
+	ret = pm_genpd_remove_device(dev);
+	if (ret)
+		dev_err(dev, "Failed to remove dev from genpd %d\n", ret);
+
+	/* Continue to remove */
+	return 0;
 }
 
 /**
@@ -181,11 +192,10 @@ static struct device *get_mfd_cell_dev(const char *device_name, int r)
  */
 static int acp_hw_init(void *handle)
 {
-	int r, i;
+	int r;
 	uint64_t acp_base;
 	u32 val = 0;
 	u32 count = 0;
-	struct device *dev;
 	struct i2s_platform_data *i2s_pdata = NULL;
 
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -341,15 +351,10 @@ static int acp_hw_init(void *handle)
 	if (r)
 		goto failure;
 
-	for (i = 0; i < ACP_DEVS ; i++) {
-		dev = get_mfd_cell_dev(adev->acp.acp_cell[i].name, i);
-		r = pm_genpd_add_device(&adev->acp.acp_genpd->gpd, dev);
-		if (r) {
-			dev_err(dev, "Failed to add dev to genpd\n");
-			goto failure;
-		}
-	}
-
+	r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
+				  acp_genpd_add_device);
+	if (r)
+		goto failure;
 
 	/* Assert Soft reset of ACP */
 	val = cgs_read_register(adev->acp.cgs_device, mmACP_SOFT_RESET);
@@ -410,10 +415,8 @@ static int acp_hw_init(void *handle)
  */
 static int acp_hw_fini(void *handle)
 {
-	int i, ret;
 	u32 val = 0;
 	u32 count = 0;
-	struct device *dev;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* return early if no ACP */
@@ -458,13 +461,8 @@ static int acp_hw_fini(void *handle)
 		udelay(100);
 	}
 
-	for (i = 0; i < ACP_DEVS ; i++) {
-		dev = get_mfd_cell_dev(adev->acp.acp_cell[i].name, i);
-		ret = pm_genpd_remove_device(dev);
-		/* If removal fails, dont giveup and try rest */
-		if (ret)
-			dev_err(dev, "remove dev from genpd failed\n");
-	}
+	device_for_each_child(adev->acp.parent, NULL,
+			      acp_genpd_remove_device);
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index dc7d2e71aa6f..5d1743f3321e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -104,8 +104,8 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 
 	ret = smu_cmn_wait_for_response(smu);
 	if (ret != 0x1) {
-		dev_err(adev->dev, "Msg issuing pre-check failed and "
-		       "SMU may be not in the right state!\n");
+		dev_err(adev->dev, "Msg issuing pre-check failed(0x%x) and "
+		       "SMU may be not in the right state!\n", ret);
 		if (ret != -ETIME)
 			ret = -EIO;
 		return ret;
diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index ca04c34e8251..997b8827fed2 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -315,7 +315,7 @@ static int drm_of_lvds_get_remote_pixels_type(
 
 		remote_port = of_graph_get_remote_port(endpoint);
 		if (!remote_port) {
-			of_node_put(remote_port);
+			of_node_put(endpoint);
 			return -EPIPE;
 		}
 
@@ -331,8 +331,10 @@ static int drm_of_lvds_get_remote_pixels_type(
 		 * configurations by passing the endpoints explicitly to
 		 * drm_of_lvds_get_dual_link_pixel_order().
 		 */
-		if (!current_pt || pixels_type != current_pt)
+		if (!current_pt || pixels_type != current_pt) {
+			of_node_put(endpoint);
 			return -EINVAL;
+		}
 	}
 
 	return pixels_type;
diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 432bdcc57ac9..a1332878857b 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -117,7 +117,7 @@ static void oaktrail_lvds_mode_set(struct drm_encoder *encoder,
 			continue;
 	}
 
-	if (!connector) {
+	if (list_entry_is_head(connector, &mode_config->connector_list, head)) {
 		DRM_ERROR("Couldn't find connector when setting mode");
 		gma_power_end(dev);
 		return;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index 2d4645e01ebf..e01135b7a404 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -345,10 +345,12 @@ static void dpu_hw_ctl_clear_all_blendstages(struct dpu_hw_ctl *ctx)
 	int i;
 
 	for (i = 0; i < ctx->mixer_count; i++) {
-		DPU_REG_WRITE(c, CTL_LAYER(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT2(LM_0 + i), 0);
-		DPU_REG_WRITE(c, CTL_LAYER_EXT3(LM_0 + i), 0);
+		enum dpu_lm mixer_id = ctx->mixer_hw_caps[i].id;
+
+		DPU_REG_WRITE(c, CTL_LAYER(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT2(mixer_id), 0);
+		DPU_REG_WRITE(c, CTL_LAYER_EXT3(mixer_id), 0);
 	}
 
 	DPU_REG_WRITE(c, CTL_FETCH_PIPE_ACTIVE, 0);
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 4a5b518288b0..0712752742f4 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -19,30 +19,12 @@ static int mdp4_hw_init(struct msm_kms *kms)
 {
 	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
 	struct drm_device *dev = mdp4_kms->dev;
-	uint32_t version, major, minor, dmap_cfg, vg_cfg;
+	u32 dmap_cfg, vg_cfg;
 	unsigned long clk;
 	int ret = 0;
 
 	pm_runtime_get_sync(dev->dev);
 
-	mdp4_enable(mdp4_kms);
-	version = mdp4_read(mdp4_kms, REG_MDP4_VERSION);
-	mdp4_disable(mdp4_kms);
-
-	major = FIELD(version, MDP4_VERSION_MAJOR);
-	minor = FIELD(version, MDP4_VERSION_MINOR);
-
-	DBG("found MDP4 version v%d.%d", major, minor);
-
-	if (major != 4) {
-		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
-				major, minor);
-		ret = -ENXIO;
-		goto out;
-	}
-
-	mdp4_kms->rev = minor;
-
 	if (mdp4_kms->rev > 1) {
 		mdp4_write(mdp4_kms, REG_MDP4_CS_CONTROLLER0, 0x0707ffff);
 		mdp4_write(mdp4_kms, REG_MDP4_CS_CONTROLLER1, 0x03073f3f);
@@ -88,7 +70,6 @@ static int mdp4_hw_init(struct msm_kms *kms)
 	if (mdp4_kms->rev > 1)
 		mdp4_write(mdp4_kms, REG_MDP4_RESET_STATUS, 1);
 
-out:
 	pm_runtime_put_sync(dev->dev);
 
 	return ret;
@@ -411,6 +392,22 @@ static int modeset_init(struct mdp4_kms *mdp4_kms)
 	return ret;
 }
 
+static void read_mdp_hw_revision(struct mdp4_kms *mdp4_kms,
+				 u32 *major, u32 *minor)
+{
+	struct drm_device *dev = mdp4_kms->dev;
+	u32 version;
+
+	mdp4_enable(mdp4_kms);
+	version = mdp4_read(mdp4_kms, REG_MDP4_VERSION);
+	mdp4_disable(mdp4_kms);
+
+	*major = FIELD(version, MDP4_VERSION_MAJOR);
+	*minor = FIELD(version, MDP4_VERSION_MINOR);
+
+	DRM_DEV_INFO(dev->dev, "MDP4 version v%d.%d", *major, *minor);
+}
+
 struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev->dev);
@@ -419,6 +416,7 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
 	int irq, ret;
+	u32 major, minor;
 
 	mdp4_kms = kzalloc(sizeof(*mdp4_kms), GFP_KERNEL);
 	if (!mdp4_kms) {
@@ -479,15 +477,6 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	if (IS_ERR(mdp4_kms->pclk))
 		mdp4_kms->pclk = NULL;
 
-	if (mdp4_kms->rev >= 2) {
-		mdp4_kms->lut_clk = devm_clk_get(&pdev->dev, "lut_clk");
-		if (IS_ERR(mdp4_kms->lut_clk)) {
-			DRM_DEV_ERROR(dev->dev, "failed to get lut_clk\n");
-			ret = PTR_ERR(mdp4_kms->lut_clk);
-			goto fail;
-		}
-	}
-
 	mdp4_kms->axi_clk = devm_clk_get(&pdev->dev, "bus_clk");
 	if (IS_ERR(mdp4_kms->axi_clk)) {
 		DRM_DEV_ERROR(dev->dev, "failed to get axi_clk\n");
@@ -496,8 +485,27 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	}
 
 	clk_set_rate(mdp4_kms->clk, config->max_clk);
-	if (mdp4_kms->lut_clk)
+
+	read_mdp_hw_revision(mdp4_kms, &major, &minor);
+
+	if (major != 4) {
+		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
+			      major, minor);
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	mdp4_kms->rev = minor;
+
+	if (mdp4_kms->rev >= 2) {
+		mdp4_kms->lut_clk = devm_clk_get(&pdev->dev, "lut_clk");
+		if (IS_ERR(mdp4_kms->lut_clk)) {
+			DRM_DEV_ERROR(dev->dev, "failed to get lut_clk\n");
+			ret = PTR_ERR(mdp4_kms->lut_clk);
+			goto fail;
+		}
 		clk_set_rate(mdp4_kms->lut_clk, config->max_clk);
+	}
 
 	pm_runtime_enable(dev->dev);
 	mdp4_kms->rpm_enabled = true;
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index cdec0a367a2c..2b1e127390e4 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -55,7 +55,6 @@ enum {
 	EV_HPD_INIT_SETUP,
 	EV_HPD_PLUG_INT,
 	EV_IRQ_HPD_INT,
-	EV_HPD_REPLUG_INT,
 	EV_HPD_UNPLUG_INT,
 	EV_USER_NOTIFICATION,
 	EV_CONNECT_PENDING_TIMEOUT,
@@ -1119,9 +1118,6 @@ static int hpd_event_thread(void *data)
 		case EV_IRQ_HPD_INT:
 			dp_irq_hpd_handle(dp_priv, todo->data);
 			break;
-		case EV_HPD_REPLUG_INT:
-			/* do nothing */
-			break;
 		case EV_USER_NOTIFICATION:
 			dp_display_send_hpd_notification(dp_priv,
 						todo->data);
@@ -1165,10 +1161,8 @@ static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 
 	if (hpd_isr_status & 0x0F) {
 		/* hpd related interrupts */
-		if (hpd_isr_status & DP_DP_HPD_PLUG_INT_MASK ||
-			hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK) {
+		if (hpd_isr_status & DP_DP_HPD_PLUG_INT_MASK)
 			dp_add_event(dp, EV_HPD_PLUG_INT, 0, 0);
-		}
 
 		if (hpd_isr_status & DP_DP_IRQ_HPD_INT_MASK) {
 			/* stop sentinel connect pending checking */
@@ -1176,8 +1170,10 @@ static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 			dp_add_event(dp, EV_IRQ_HPD_INT, 0, 0);
 		}
 
-		if (hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK)
-			dp_add_event(dp, EV_HPD_REPLUG_INT, 0, 0);
+		if (hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK) {
+			dp_add_event(dp, EV_HPD_UNPLUG_INT, 0, 0);
+			dp_add_event(dp, EV_HPD_PLUG_INT, 0, 3);
+		}
 
 		if (hpd_isr_status & DP_DP_HPD_UNPLUG_INT_MASK)
 			dp_add_event(dp, EV_HPD_UNPLUG_INT, 0, 0);
@@ -1286,7 +1282,7 @@ static int dp_pm_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct msm_dp *dp_display = platform_get_drvdata(pdev);
 	struct dp_display_private *dp;
-	u32 status;
+	int sink_count = 0;
 
 	dp = container_of(dp_display, struct dp_display_private, dp_display);
 
@@ -1300,14 +1296,25 @@ static int dp_pm_resume(struct device *dev)
 
 	dp_catalog_ctrl_hpd_config(dp->catalog);
 
-	status = dp_catalog_link_is_connected(dp->catalog);
+	/*
+	 * set sink to normal operation mode -- D0
+	 * before dpcd read
+	 */
+	dp_link_psm_config(dp->link, &dp->panel->link_info, false);
+
+	if (dp_catalog_link_is_connected(dp->catalog)) {
+		sink_count = drm_dp_read_sink_count(dp->aux);
+		if (sink_count < 0)
+			sink_count = 0;
+	}
 
+	dp->link->sink_count = sink_count;
 	/*
 	 * can not declared display is connected unless
 	 * HDMI cable is plugged in and sink_count of
 	 * dongle become 1
 	 */
-	if (status && dp->link->sink_count)
+	if (dp->link->sink_count)
 		dp->dp_display.is_connected = true;
 	else
 		dp->dp_display.is_connected = false;
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 627048851d99..7e364b9c9f9e 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -26,8 +26,10 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 	}
 
 	phy_pdev = of_find_device_by_node(phy_node);
-	if (phy_pdev)
+	if (phy_pdev) {
 		msm_dsi->phy = platform_get_drvdata(phy_pdev);
+		msm_dsi->phy_dev = &phy_pdev->dev;
+	}
 
 	of_node_put(phy_node);
 
@@ -36,8 +38,6 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 		return -EPROBE_DEFER;
 	}
 
-	msm_dsi->phy_dev = get_device(&phy_pdev->dev);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.c b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
index 6da93551e2e5..c277d3f61a5e 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -51,6 +51,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0xff,
 		.hs_wdth_shift	= 24,
 		.has_overlay	= false,
+		.has_ctrl2	= false,
 	},
 	[MXSFB_V4] = {
 		.transfer_count	= LCDC_V4_TRANSFER_COUNT,
@@ -59,6 +60,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0x3fff,
 		.hs_wdth_shift	= 18,
 		.has_overlay	= false,
+		.has_ctrl2	= true,
 	},
 	[MXSFB_V6] = {
 		.transfer_count	= LCDC_V4_TRANSFER_COUNT,
@@ -67,6 +69,7 @@ static const struct mxsfb_devdata mxsfb_devdata[] = {
 		.hs_wdth_mask	= 0x3fff,
 		.hs_wdth_shift	= 18,
 		.has_overlay	= true,
+		.has_ctrl2	= true,
 	},
 };
 
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.h b/drivers/gpu/drm/mxsfb/mxsfb_drv.h
index 399d23e91ed1..7c720e226fdf 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.h
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.h
@@ -22,6 +22,7 @@ struct mxsfb_devdata {
 	unsigned int	hs_wdth_mask;
 	unsigned int	hs_wdth_shift;
 	bool		has_overlay;
+	bool		has_ctrl2;
 };
 
 struct mxsfb_drm_private {
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index 300e7bab0f43..54f905ac75c0 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -107,6 +107,14 @@ static void mxsfb_enable_controller(struct mxsfb_drm_private *mxsfb)
 		clk_prepare_enable(mxsfb->clk_disp_axi);
 	clk_prepare_enable(mxsfb->clk);
 
+	/* Increase number of outstanding requests on all supported IPs */
+	if (mxsfb->devdata->has_ctrl2) {
+		reg = readl(mxsfb->base + LCDC_V4_CTRL2);
+		reg &= ~CTRL2_SET_OUTSTANDING_REQS_MASK;
+		reg |= CTRL2_SET_OUTSTANDING_REQS_16;
+		writel(reg, mxsfb->base + LCDC_V4_CTRL2);
+	}
+
 	/* If it was disabled, re-enable the mode again */
 	writel(CTRL_DOTCLK_MODE, mxsfb->base + LCDC_CTRL + REG_SET);
 
@@ -115,6 +123,35 @@ static void mxsfb_enable_controller(struct mxsfb_drm_private *mxsfb)
 	reg |= VDCTRL4_SYNC_SIGNALS_ON;
 	writel(reg, mxsfb->base + LCDC_VDCTRL4);
 
+	/*
+	 * Enable recovery on underflow.
+	 *
+	 * There is some sort of corner case behavior of the controller,
+	 * which could rarely be triggered at least on i.MX6SX connected
+	 * to 800x480 DPI panel and i.MX8MM connected to DPI->DSI->LVDS
+	 * bridged 1920x1080 panel (and likely on other setups too), where
+	 * the image on the panel shifts to the right and wraps around.
+	 * This happens either when the controller is enabled on boot or
+	 * even later during run time. The condition does not correct
+	 * itself automatically, i.e. the display image remains shifted.
+	 *
+	 * It seems this problem is known and is due to sporadic underflows
+	 * of the LCDIF FIFO. While the LCDIF IP does have underflow/overflow
+	 * IRQs, neither of the IRQs trigger and neither IRQ status bit is
+	 * asserted when this condition occurs.
+	 *
+	 * All known revisions of the LCDIF IP have CTRL1 RECOVER_ON_UNDERFLOW
+	 * bit, which is described in the reference manual since i.MX23 as
+	 * "
+	 *   Set this bit to enable the LCDIF block to recover in the next
+	 *   field/frame if there was an underflow in the current field/frame.
+	 * "
+	 * Enable this bit to mitigate the sporadic underflows.
+	 */
+	reg = readl(mxsfb->base + LCDC_CTRL1);
+	reg |= CTRL1_RECOVER_ON_UNDERFLOW;
+	writel(reg, mxsfb->base + LCDC_CTRL1);
+
 	writel(CTRL_RUN, mxsfb->base + LCDC_CTRL + REG_SET);
 }
 
@@ -206,6 +243,9 @@ static void mxsfb_crtc_mode_set_nofb(struct mxsfb_drm_private *mxsfb)
 
 	/* Clear the FIFOs */
 	writel(CTRL1_FIFO_CLEAR, mxsfb->base + LCDC_CTRL1 + REG_SET);
+	readl(mxsfb->base + LCDC_CTRL1);
+	writel(CTRL1_FIFO_CLEAR, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+	readl(mxsfb->base + LCDC_CTRL1);
 
 	if (mxsfb->devdata->has_overlay)
 		writel(0, mxsfb->base + LCDC_AS_CTRL);
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_regs.h b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
index 55d28a27f912..694fea13e893 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_regs.h
+++ b/drivers/gpu/drm/mxsfb/mxsfb_regs.h
@@ -15,6 +15,7 @@
 #define LCDC_CTRL			0x00
 #define LCDC_CTRL1			0x10
 #define LCDC_V3_TRANSFER_COUNT		0x20
+#define LCDC_V4_CTRL2			0x20
 #define LCDC_V4_TRANSFER_COUNT		0x30
 #define LCDC_V4_CUR_BUF			0x40
 #define LCDC_V4_NEXT_BUF		0x50
@@ -54,12 +55,20 @@
 #define CTRL_DF24			BIT(1)
 #define CTRL_RUN			BIT(0)
 
+#define CTRL1_RECOVER_ON_UNDERFLOW	BIT(24)
 #define CTRL1_FIFO_CLEAR		BIT(21)
 #define CTRL1_SET_BYTE_PACKAGING(x)	(((x) & 0xf) << 16)
 #define CTRL1_GET_BYTE_PACKAGING(x)	(((x) >> 16) & 0xf)
 #define CTRL1_CUR_FRAME_DONE_IRQ_EN	BIT(13)
 #define CTRL1_CUR_FRAME_DONE_IRQ	BIT(9)
 
+#define CTRL2_SET_OUTSTANDING_REQS_1	0
+#define CTRL2_SET_OUTSTANDING_REQS_2	(0x1 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_4	(0x2 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_8	(0x3 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_16	(0x4 << 21)
+#define CTRL2_SET_OUTSTANDING_REQS_MASK	(0x7 << 21)
+
 #define TRANSFER_COUNT_SET_VCOUNT(x)	(((x) & 0xffff) << 16)
 #define TRANSFER_COUNT_GET_VCOUNT(x)	(((x) >> 16) & 0xffff)
 #define TRANSFER_COUNT_SET_HCOUNT(x)	((x) & 0xffff)
diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index fbcf5edbe367..9275cd0b2793 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -54,7 +54,8 @@ static int panfrost_clk_init(struct panfrost_device *pfdev)
 	if (IS_ERR(pfdev->bus_clock)) {
 		dev_err(pfdev->dev, "get bus_clock failed %ld\n",
 			PTR_ERR(pfdev->bus_clock));
-		return PTR_ERR(pfdev->bus_clock);
+		err = PTR_ERR(pfdev->bus_clock);
+		goto disable_clock;
 	}
 
 	if (pfdev->bus_clock) {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index bfbff90588cb..c22551c2facb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -556,8 +556,6 @@ static int rcar_du_remove(struct platform_device *pdev)
 
 	drm_kms_helper_poll_fini(ddev);
 
-	drm_dev_put(ddev);
-
 	return 0;
 }
 
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 59e78bc212cf..ae66c8ce4eef 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_SENSORS_ADT7462)	+= adt7462.o
 obj-$(CONFIG_SENSORS_ADT7470)	+= adt7470.o
 obj-$(CONFIG_SENSORS_ADT7475)	+= adt7475.o
 obj-$(CONFIG_SENSORS_AHT10)	+= aht10.o
-obj-$(CONFIG_SENSORS_AMD_ENERGY) += amd_energy.o
 obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
 obj-$(CONFIG_SENSORS_ARM_SCMI)	+= scmi-hwmon.o
 obj-$(CONFIG_SENSORS_ARM_SCPI)	+= scpi-hwmon.o
diff --git a/drivers/hwmon/pmbus/bpa-rs600.c b/drivers/hwmon/pmbus/bpa-rs600.c
index 2be69fedfa36..be76efe67d83 100644
--- a/drivers/hwmon/pmbus/bpa-rs600.c
+++ b/drivers/hwmon/pmbus/bpa-rs600.c
@@ -12,15 +12,6 @@
 #include <linux/pmbus.h>
 #include "pmbus.h"
 
-#define BPARS600_MFR_VIN_MIN	0xa0
-#define BPARS600_MFR_VIN_MAX	0xa1
-#define BPARS600_MFR_IIN_MAX	0xa2
-#define BPARS600_MFR_PIN_MAX	0xa3
-#define BPARS600_MFR_VOUT_MIN	0xa4
-#define BPARS600_MFR_VOUT_MAX	0xa5
-#define BPARS600_MFR_IOUT_MAX	0xa6
-#define BPARS600_MFR_POUT_MAX	0xa7
-
 static int bpa_rs600_read_byte_data(struct i2c_client *client, int page, int reg)
 {
 	int ret;
@@ -81,29 +72,13 @@ static int bpa_rs600_read_word_data(struct i2c_client *client, int page, int pha
 
 	switch (reg) {
 	case PMBUS_VIN_UV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VIN_MIN);
-		break;
 	case PMBUS_VIN_OV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VIN_MAX);
-		break;
 	case PMBUS_VOUT_UV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VOUT_MIN);
-		break;
 	case PMBUS_VOUT_OV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VOUT_MAX);
-		break;
 	case PMBUS_IIN_OC_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_IIN_MAX);
-		break;
 	case PMBUS_IOUT_OC_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_IOUT_MAX);
-		break;
 	case PMBUS_PIN_OP_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_PIN_MAX);
-		break;
 	case PMBUS_POUT_OP_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_POUT_MAX);
-		break;
 	case PMBUS_VIN_UV_FAULT_LIMIT:
 	case PMBUS_VIN_OV_FAULT_LIMIT:
 	case PMBUS_VOUT_UV_FAULT_LIMIT:
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 803dad70e2a7..a2add128d084 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -379,7 +379,7 @@ static int highlander_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	dev->irq = platform_get_irq(pdev, 0);
-	if (iic_force_poll)
+	if (dev->irq < 0 || iic_force_poll)
 		dev->irq = 0;
 
 	if (dev->irq) {
diff --git a/drivers/i2c/busses/i2c-hix5hd2.c b/drivers/i2c/busses/i2c-hix5hd2.c
index aa00ba8bcb70..61ae58f57047 100644
--- a/drivers/i2c/busses/i2c-hix5hd2.c
+++ b/drivers/i2c/busses/i2c-hix5hd2.c
@@ -413,7 +413,7 @@ static int hix5hd2_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->regs);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index cfecaf18ccbb..4a6ff54d87fe 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -469,16 +469,14 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		ret = -ENXIO;
+		ret = irq;
 		goto unmap;
 	}
 	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
 				pdev->name, adapter_data);
 
-	if (ret) {
-		ret = -EIO;
+	if (ret)
 		goto unmap;
-	}
 
 	memcpy(new_adapter->name, pdev->name, strlen(pdev->name));
 	new_adapter->owner = THIS_MODULE;
diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 4e9fb6b44436..d90d80d046bd 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1211,7 +1211,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c->pdmabase);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	init_completion(&i2c->msg_complete);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 4d82761e1585..b49a1b170bb2 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1137,7 +1137,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	 */
 	if (!(i2c->quirks & QUIRK_POLL)) {
 		i2c->irq = ret = platform_get_irq(pdev, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			dev_err(&pdev->dev, "cannot find IRQ\n");
 			clk_unprepare(i2c->clk);
 			return ret;
diff --git a/drivers/i2c/busses/i2c-synquacer.c b/drivers/i2c/busses/i2c-synquacer.c
index 31be1811d5e6..e4026c5416b1 100644
--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -578,7 +578,7 @@ static int synquacer_i2c_probe(struct platform_device *pdev)
 
 	i2c->irq = platform_get_irq(pdev, 0);
 	if (i2c->irq < 0)
-		return -ENODEV;
+		return i2c->irq;
 
 	ret = devm_request_irq(&pdev->dev, i2c->irq, synquacer_i2c_isr,
 			       0, dev_name(&pdev->dev), i2c);
diff --git a/drivers/i2c/busses/i2c-xlp9xx.c b/drivers/i2c/busses/i2c-xlp9xx.c
index f2241cedf5d3..6d24dc385522 100644
--- a/drivers/i2c/busses/i2c-xlp9xx.c
+++ b/drivers/i2c/busses/i2c-xlp9xx.c
@@ -517,7 +517,7 @@ static int xlp9xx_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 
 	priv->irq = platform_get_irq(pdev, 0);
-	if (priv->irq <= 0)
+	if (priv->irq < 0)
 		return priv->irq;
 	/* SMBAlert irq */
 	priv->alert_data.irq = platform_get_irq(pdev, 1);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fd113ddf6e86..8193fa5c3fed 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1022,7 +1022,7 @@ static void *mlx5_ib_alloc_xlt(size_t *nents, size_t ent_size, gfp_t gfp_mask)
 
 	if (size > MLX5_SPARE_UMR_CHUNK) {
 		size = MLX5_SPARE_UMR_CHUNK;
-		*nents = get_order(size) / ent_size;
+		*nents = size / ent_size;
 		res = (void *)__get_free_pages(gfp_mask | __GFP_NOWARN,
 					       get_order(size));
 		if (res)
diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index c179e27062fd..151aab408fa6 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -225,7 +225,7 @@ static void aic_irq_eoi(struct irq_data *d)
 	 * Reading the interrupt reason automatically acknowledges and masks
 	 * the IRQ, so we just unmask it here if needed.
 	 */
-	if (!irqd_irq_disabled(d) && !irqd_irq_masked(d))
+	if (!irqd_irq_masked(d))
 		aic_irq_unmask(d);
 }
 
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 66d623f91678..20a2d606b4c9 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -100,6 +100,27 @@ EXPORT_SYMBOL(gic_pmr_sync);
 DEFINE_STATIC_KEY_FALSE(gic_nonsecure_priorities);
 EXPORT_SYMBOL(gic_nonsecure_priorities);
 
+/*
+ * When the Non-secure world has access to group 0 interrupts (as a
+ * consequence of SCR_EL3.FIQ == 0), reading the ICC_RPR_EL1 register will
+ * return the Distributor's view of the interrupt priority.
+ *
+ * When GIC security is enabled (GICD_CTLR.DS == 0), the interrupt priority
+ * written by software is moved to the Non-secure range by the Distributor.
+ *
+ * If both are true (which is when gic_nonsecure_priorities gets enabled),
+ * we need to shift down the priority programmed by software to match it
+ * against the value returned by ICC_RPR_EL1.
+ */
+#define GICD_INT_RPR_PRI(priority)					\
+	({								\
+		u32 __priority = (priority);				\
+		if (static_branch_unlikely(&gic_nonsecure_priorities))	\
+			__priority = 0x80 | (__priority >> 1);		\
+									\
+		__priority;						\
+	})
+
 /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
 static refcount_t *ppi_nmi_refs;
 
@@ -687,7 +708,7 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		return;
 
 	if (gic_supports_nmi() &&
-	    unlikely(gic_read_rpr() == GICD_INT_NMI_PRI)) {
+	    unlikely(gic_read_rpr() == GICD_INT_RPR_PRI(GICD_INT_NMI_PRI))) {
 		gic_handle_nmi(irqnr, regs);
 		return;
 	}
diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index f790ca6d78aa..a4eb8a2181c7 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -92,18 +92,22 @@ static int pch_pic_set_type(struct irq_data *d, unsigned int type)
 	case IRQ_TYPE_EDGE_RISING:
 		pch_pic_bitset(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitclr(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		pch_pic_bitset(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitset(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		pch_pic_bitclr(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitclr(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_level_irq);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		pch_pic_bitclr(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitset(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_level_irq);
 		break;
 	default:
 		ret = -EINVAL;
@@ -113,11 +117,24 @@ static int pch_pic_set_type(struct irq_data *d, unsigned int type)
 	return ret;
 }
 
+static void pch_pic_ack_irq(struct irq_data *d)
+{
+	unsigned int reg;
+	struct pch_pic *priv = irq_data_get_irq_chip_data(d);
+
+	reg = readl(priv->base + PCH_PIC_EDGE + PIC_REG_IDX(d->hwirq) * 4);
+	if (reg & BIT(PIC_REG_BIT(d->hwirq))) {
+		writel(BIT(PIC_REG_BIT(d->hwirq)),
+			priv->base + PCH_PIC_CLR + PIC_REG_IDX(d->hwirq) * 4);
+	}
+	irq_chip_ack_parent(d);
+}
+
 static struct irq_chip pch_pic_irq_chip = {
 	.name			= "PCH PIC",
 	.irq_mask		= pch_pic_mask_irq,
 	.irq_unmask		= pch_pic_unmask_irq,
-	.irq_ack		= irq_chip_ack_parent,
+	.irq_ack		= pch_pic_ack_irq,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
 	.irq_set_type		= pch_pic_set_type,
 };
diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 7d5f0bf2817a..24736f29d363 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -630,8 +630,10 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 
 	fwnode_for_each_child_node(fw_ssoled, fwnode_child) {
 		led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
-		if (!led)
-			return -ENOMEM;
+		if (!led) {
+			ret = -ENOMEM;
+			goto __dt_err;
+		}
 
 		INIT_LIST_HEAD(&led->list);
 		led->priv = priv;
@@ -641,7 +643,7 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 							      fwnode_child,
 							      GPIOD_ASIS, NULL);
 		if (IS_ERR(led->gpiod)) {
-			dev_err(dev, "led: get gpio fail!\n");
+			ret = dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
 			goto __dt_err;
 		}
 
@@ -661,8 +663,11 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 			desc->panic_indicator = 1;
 
 		ret = fwnode_property_read_u32(fwnode_child, "reg", &prop);
-		if (ret != 0 || prop >= SSO_LED_MAX_NUM) {
+		if (ret)
+			goto __dt_err;
+		if (prop >= SSO_LED_MAX_NUM) {
 			dev_err(dev, "invalid LED pin:%u\n", prop);
+			ret = -EINVAL;
 			goto __dt_err;
 		}
 		desc->pin = prop;
@@ -698,21 +703,22 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 				desc->brightness = LED_FULL;
 		}
 
-		if (sso_create_led(priv, led, fwnode_child))
+		ret = sso_create_led(priv, led, fwnode_child);
+		if (ret)
 			goto __dt_err;
 	}
-	fwnode_handle_put(fw_ssoled);
 
 	return 0;
+
 __dt_err:
-	fwnode_handle_put(fw_ssoled);
+	fwnode_handle_put(fwnode_child);
 	/* unregister leds */
 	list_for_each(p, &priv->led_list) {
 		led = list_entry(p, struct sso_led, list);
 		sso_led_shutdown(led);
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 static int sso_led_dt_parse(struct sso_led_priv *priv)
@@ -730,6 +736,7 @@ static int sso_led_dt_parse(struct sso_led_priv *priv)
 	fw_ssoled = fwnode_get_named_child_node(fwnode, "ssoled");
 	if (fw_ssoled) {
 		ret = __sso_led_dt_parse(priv, fw_ssoled);
+		fwnode_handle_put(fw_ssoled);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/leds/flash/leds-rt8515.c b/drivers/leds/flash/leds-rt8515.c
index 590bfa180d10..44904fdee3cc 100644
--- a/drivers/leds/flash/leds-rt8515.c
+++ b/drivers/leds/flash/leds-rt8515.c
@@ -343,8 +343,9 @@ static int rt8515_probe(struct platform_device *pdev)
 
 	ret = devm_led_classdev_flash_register_ext(dev, fled, &init_data);
 	if (ret) {
-		dev_err(dev, "can't register LED %s\n", led->name);
+		fwnode_handle_put(child);
 		mutex_destroy(&rt->lock);
+		dev_err(dev, "can't register LED %s\n", led->name);
 		return ret;
 	}
 
@@ -362,6 +363,7 @@ static int rt8515_probe(struct platform_device *pdev)
 		 */
 	}
 
+	fwnode_handle_put(child);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-is31fl32xx.c b/drivers/leds/leds-is31fl32xx.c
index 2180255ad339..899ed94b6687 100644
--- a/drivers/leds/leds-is31fl32xx.c
+++ b/drivers/leds/leds-is31fl32xx.c
@@ -385,6 +385,7 @@ static int is31fl32xx_parse_dt(struct device *dev,
 			dev_err(dev,
 				"Node %pOF 'reg' conflicts with another LED\n",
 				child);
+			ret = -EINVAL;
 			goto err;
 		}
 
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index 68e06434ac08..7dab08773a34 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -99,10 +99,9 @@ static int lt3593_led_probe(struct platform_device *pdev)
 	init_data.default_label = ":";
 
 	ret = devm_led_classdev_register_ext(dev, &led_data->cdev, &init_data);
-	if (ret < 0) {
-		fwnode_handle_put(child);
+	fwnode_handle_put(child);
+	if (ret < 0)
 		return ret;
-	}
 
 	platform_set_drvdata(pdev, led_data);
 
diff --git a/drivers/leds/trigger/ledtrig-audio.c b/drivers/leds/trigger/ledtrig-audio.c
index f76621e88482..c6b437e6369b 100644
--- a/drivers/leds/trigger/ledtrig-audio.c
+++ b/drivers/leds/trigger/ledtrig-audio.c
@@ -6,10 +6,33 @@
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include "../leds.h"
 
-static struct led_trigger *ledtrig_audio[NUM_AUDIO_LEDS];
 static enum led_brightness audio_state[NUM_AUDIO_LEDS];
 
+static int ledtrig_audio_mute_activate(struct led_classdev *led_cdev)
+{
+	led_set_brightness_nosleep(led_cdev, audio_state[LED_AUDIO_MUTE]);
+	return 0;
+}
+
+static int ledtrig_audio_micmute_activate(struct led_classdev *led_cdev)
+{
+	led_set_brightness_nosleep(led_cdev, audio_state[LED_AUDIO_MICMUTE]);
+	return 0;
+}
+
+static struct led_trigger ledtrig_audio[NUM_AUDIO_LEDS] = {
+	[LED_AUDIO_MUTE] = {
+		.name     = "audio-mute",
+		.activate = ledtrig_audio_mute_activate,
+	},
+	[LED_AUDIO_MICMUTE] = {
+		.name     = "audio-micmute",
+		.activate = ledtrig_audio_micmute_activate,
+	},
+};
+
 enum led_brightness ledtrig_audio_get(enum led_audio type)
 {
 	return audio_state[type];
@@ -19,24 +42,22 @@ EXPORT_SYMBOL_GPL(ledtrig_audio_get);
 void ledtrig_audio_set(enum led_audio type, enum led_brightness state)
 {
 	audio_state[type] = state;
-	led_trigger_event(ledtrig_audio[type], state);
+	led_trigger_event(&ledtrig_audio[type], state);
 }
 EXPORT_SYMBOL_GPL(ledtrig_audio_set);
 
 static int __init ledtrig_audio_init(void)
 {
-	led_trigger_register_simple("audio-mute",
-				    &ledtrig_audio[LED_AUDIO_MUTE]);
-	led_trigger_register_simple("audio-micmute",
-				    &ledtrig_audio[LED_AUDIO_MICMUTE]);
+	led_trigger_register(&ledtrig_audio[LED_AUDIO_MUTE]);
+	led_trigger_register(&ledtrig_audio[LED_AUDIO_MICMUTE]);
 	return 0;
 }
 module_init(ledtrig_audio_init);
 
 static void __exit ledtrig_audio_exit(void)
 {
-	led_trigger_unregister_simple(ledtrig_audio[LED_AUDIO_MUTE]);
-	led_trigger_unregister_simple(ledtrig_audio[LED_AUDIO_MICMUTE]);
+	led_trigger_unregister(&ledtrig_audio[LED_AUDIO_MUTE]);
+	led_trigger_unregister(&ledtrig_audio[LED_AUDIO_MICMUTE]);
 }
 module_exit(ledtrig_audio_exit);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bea8c4429ae8..a407e3be0f17 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -935,20 +935,20 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
 	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
 	if (!d->full_dirty_stripes)
-		return -ENOMEM;
+		goto out_free_stripe_sectors_dirty;
 
 	idx = ida_simple_get(&bcache_device_idx, 0,
 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
 	if (idx < 0)
-		return idx;
+		goto out_free_full_dirty_stripes;
 
 	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
-		goto err;
+		goto out_ida_remove;
 
 	d->disk = alloc_disk(BCACHE_MINORS);
 	if (!d->disk)
-		goto err;
+		goto out_bioset_exit;
 
 	set_capacity(d->disk, sectors);
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -994,8 +994,14 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
 	return 0;
 
-err:
+out_bioset_exit:
+	bioset_exit(&d->bio_split);
+out_ida_remove:
 	ida_simple_remove(&bcache_device_idx, idx);
+out_free_full_dirty_stripes:
+	kvfree(d->full_dirty_stripes);
+out_free_stripe_sectors_dirty:
+	kvfree(d->stripe_sectors_dirty);
 	return -ENOMEM;
 
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 753822ca9613..6b8e58ae3f9e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1324,6 +1324,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
 	int max_sectors;
+	bool write_behind = false;
 
 	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1376,6 +1377,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
+		/*
+		 * The write-behind io is only attempted on drives marked as
+		 * write-mostly, which means we could allocate write behind
+		 * bio later.
+		 */
+		if (rdev && test_bit(WriteMostly, &rdev->flags))
+			write_behind = true;
+
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
@@ -1449,6 +1459,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		goto retry_write;
 	}
 
+	/*
+	 * When using a bitmap, we may call alloc_behind_master_bio below.
+	 * alloc_behind_master_bio allocates a copy of the data payload a page
+	 * at a time and thus needs a new bio that can fit the whole payload
+	 * this bio in page sized chunks.
+	 */
+	if (write_behind && bitmap)
+		max_sectors = min_t(int, max_sectors,
+				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 40e845fb9717..92b490aac93e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1706,6 +1706,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	} else
 		r10_bio->master_bio = (struct bio *)first_r10bio;
 
+	/*
+	 * first select target devices under rcu_lock and
+	 * inc refcount on their rdev.  Record them by setting
+	 * bios[x] to bio
+	 */
 	rcu_read_lock();
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
@@ -1737,9 +1742,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		sector_t dev_start, dev_end;
 		struct bio *mbio, *rbio = NULL;
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[disk].replacement);
 
 		/*
 		 * Now start to calculate the start and end address for each disk.
@@ -1769,9 +1771,12 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 		/*
 		 * It only handles discard bio which size is >= stripe size, so
-		 * dev_end > dev_start all the time
+		 * dev_end > dev_start all the time.
+		 * It doesn't need to use rcu lock to get rdev here. We already
+		 * add rdev->nr_pending in the first loop.
 		 */
 		if (r10_bio->devs[disk].bio) {
+			struct md_rdev *rdev = conf->mirrors[disk].rdev;
 			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			mbio->bi_end_io = raid10_end_discard_request;
 			mbio->bi_private = r10_bio;
@@ -1784,6 +1789,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 			bio_endio(mbio);
 		}
 		if (r10_bio->devs[disk].repl_bio) {
+			struct md_rdev *rrdev = conf->mirrors[disk].replacement;
 			rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			rbio->bi_end_io = raid10_end_discard_request;
 			rbio->bi_private = r10_bio;
diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 89bb7e6dc7a4..9554c8348c02 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2233,6 +2233,7 @@ static int tda1997x_core_init(struct v4l2_subdev *sd)
 	/* get initial HDMI status */
 	state->hdmi_status = io_read(sd, REG_HDMI_FLAGS);
 
+	io_write(sd, REG_EDID_ENABLE, EDID_ENABLE_A_EN | EDID_ENABLE_B_EN);
 	return 0;
 }
 
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2f42808c43a4..c484c008ab02 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2053,17 +2053,25 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	u32 src_fourcc, dst_fourcc;
 	int ret;
 
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	src_fourcc = q_data_src->fourcc;
+	dst_fourcc = q_data_dst->fourcc;
+
 	if (!ctx->initialized) {
 		ret = __coda_decoder_seq_init(ctx);
 		if (ret < 0)
 			return ret;
+	} else {
+		ctx->frame_mem_ctrl &= ~(CODA_FRAME_CHROMA_INTERLEAVE | (0x3 << 9) |
+					 CODA9_FRAME_TILED2LINEAR);
+		if (dst_fourcc == V4L2_PIX_FMT_NV12 || dst_fourcc == V4L2_PIX_FMT_YUYV)
+			ctx->frame_mem_ctrl |= CODA_FRAME_CHROMA_INTERLEAVE;
+		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+			ctx->frame_mem_ctrl |= (0x3 << 9) |
+				((ctx->use_vdoa) ? 0 : CODA9_FRAME_TILED2LINEAR);
 	}
 
-	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	src_fourcc = q_data_src->fourcc;
-	dst_fourcc = q_data_dst->fourcc;
-
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
 
 	ret = coda_alloc_framebuffers(ctx, q_data_dst, src_fourcc);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 53025c8c7531..20f59c59ff8a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2037,8 +2037,10 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	mutex_lock(&isp->media_dev.graph_mutex);
 
 	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&isp->media_dev.graph_mutex);
 		return ret;
+	}
 
 	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
 		if (sd->notifier != &isp->notifier)
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index b813d6dba481..3a0871f0bea6 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1138,6 +1138,9 @@ int venus_helper_set_format_constraints(struct venus_inst *inst)
 	if (!IS_V6(inst->core))
 		return 0;
 
+	if (inst->opb_fmt == HFI_COLOR_FORMAT_NV12_UBWC)
+		return 0;
+
 	pconstraint.buffer_type = HFI_BUFFER_OUTPUT2;
 	pconstraint.num_planes = 2;
 	pconstraint.plane_format[0].stride_multiples = 128;
diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index a2d436d407b2..e8776ac45b02 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -261,7 +261,7 @@ sys_get_prop_image_version(struct device *dev,
 
 	smem_tbl_ptr = qcom_smem_get(QCOM_SMEM_HOST_ANY,
 		SMEM_IMG_VER_TBL, &smem_blk_sz);
-	if (smem_tbl_ptr && smem_blk_sz >= SMEM_IMG_OFFSET_VENUS + VER_STR_SZ)
+	if (!IS_ERR(smem_tbl_ptr) && smem_blk_sz >= SMEM_IMG_OFFSET_VENUS + VER_STR_SZ)
 		memcpy(smem_tbl_ptr + SMEM_IMG_OFFSET_VENUS,
 		       img_ver, VER_STR_SZ);
 }
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 4a7291f934b6..2c443c1afd3a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -183,6 +183,8 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),
diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index bf9a75b75083..81508ed5abf3 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -79,9 +79,8 @@ static int rga_buf_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct rockchip_rga *rga = ctx->rga;
 	int ret;
 
-	ret = pm_runtime_get_sync(rga->dev);
+	ret = pm_runtime_resume_and_get(rga->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(rga->dev);
 		rga_buf_return_buffers(q, VB2_BUF_STATE_QUEUED);
 		return ret;
 	}
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 9d122429706e..6759091b15e0 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -863,10 +863,12 @@ static int rga_probe(struct platform_device *pdev)
 	if (IS_ERR(rga->m2m_dev)) {
 		v4l2_err(&rga->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(rga->m2m_dev);
-		goto unreg_video_dev;
+		goto rel_vdev;
 	}
 
-	pm_runtime_get_sync(rga->dev);
+	ret = pm_runtime_resume_and_get(rga->dev);
+	if (ret < 0)
+		goto rel_vdev;
 
 	rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
 	rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
@@ -880,11 +882,23 @@ static int rga_probe(struct platform_device *pdev)
 	rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
 					   &rga->cmdbuf_phy, GFP_KERNEL,
 					   DMA_ATTR_WRITE_COMBINE);
+	if (!rga->cmdbuf_virt) {
+		ret = -ENOMEM;
+		goto rel_vdev;
+	}
 
 	rga->src_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->src_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_dma;
+	}
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (rga->dst_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_src_pages;
+	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 	def_frame.size = def_frame.stride * def_frame.height;
@@ -892,7 +906,7 @@ static int rga_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, -1);
 	if (ret) {
 		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto free_dst_pages;
 	}
 
 	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
@@ -900,10 +914,15 @@ static int rga_probe(struct platform_device *pdev)
 
 	return 0;
 
+free_dst_pages:
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
+free_src_pages:
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+free_dma:
+	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
+		       rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
 rel_vdev:
 	video_device_release(vfd);
-unreg_video_dev:
-	video_unregister_device(rga->vfd);
 unreg_v4l2_dev:
 	v4l2_device_unregister(&rga->v4l2_dev);
 err_put_clk:
diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 931ec0727cd3..a280e4bd80c2 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -524,13 +524,13 @@ cxd2880_spi_probe(struct spi_device *spi)
 	if (IS_ERR(dvb_spi->vcc_supply)) {
 		if (PTR_ERR(dvb_spi->vcc_supply) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
-			goto fail_adapter;
+			goto fail_regulator;
 		}
 		dvb_spi->vcc_supply = NULL;
 	} else {
 		ret = regulator_enable(dvb_spi->vcc_supply);
 		if (ret)
-			goto fail_adapter;
+			goto fail_regulator;
 	}
 
 	dvb_spi->spi = spi;
@@ -618,6 +618,9 @@ cxd2880_spi_probe(struct spi_device *spi)
 fail_attach:
 	dvb_unregister_adapter(&dvb_spi->adapter);
 fail_adapter:
+	if (!dvb_spi->vcc_supply)
+		regulator_disable(dvb_spi->vcc_supply);
+fail_regulator:
 	kfree(dvb_spi);
 	return ret;
 }
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
index 2e07106f4680..bc4b2abdde1a 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
@@ -17,7 +17,8 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 
 	if (d->props.i2c_algo == NULL) {
 		err("no i2c algorithm specified");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	strscpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
@@ -27,11 +28,15 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 
 	i2c_set_adapdata(&d->i2c_adap, d);
 
-	if ((ret = i2c_add_adapter(&d->i2c_adap)) < 0)
+	ret = i2c_add_adapter(&d->i2c_adap);
+	if (ret < 0) {
 		err("could not add i2c adapter");
+		goto err;
+	}
 
 	d->state |= DVB_USB_STATE_I2C;
 
+err:
 	return ret;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 28e1fd64dd3c..61439c8f33ca 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -194,8 +194,8 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 
 err_adapter_init:
 	dvb_usb_adapter_exit(d);
-err_i2c_init:
 	dvb_usb_i2c_exit(d);
+err_i2c_init:
 	if (d->priv && d->props.priv_destroy)
 		d->props.priv_destroy(d);
 err_priv_init:
diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index e7b290552b66..9c0eb0d40822 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -130,7 +130,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 {
-	int i;
+	int i, ret;
 	u8 b;
 
 	mac[0] = 0x00;
@@ -139,7 +139,9 @@ static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 
 	/* this is a complete guess, but works for my box */
 	for (i = 136; i < 139; i++) {
-		dibusb_read_eeprom_byte(d,i, &b);
+		ret = dibusb_read_eeprom_byte(d, i, &b);
+		if (ret)
+			return ret;
 
 		mac[5 - (i - 136)] = b;
 	}
diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index bf54747e2e01..a1d9e4801a2b 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -291,16 +291,22 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
 	u8 i, *buf;
+	int ret;
 	struct vp702x_device_state *st = d->priv;
 
 	mutex_lock(&st->buf_mutex);
 	buf = st->buf;
-	for (i = 6; i < 12; i++)
-		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
+	for (i = 6; i < 12; i++) {
+		ret = vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1,
+				       &buf[i - 6], 1);
+		if (ret < 0)
+			goto err;
+	}
 
 	memcpy(mac, buf, 6);
+err:
 	mutex_unlock(&st->buf_mutex);
-	return 0;
+	return ret;
 }
 
 static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 59529cbf9cd0..0b6d77c3bec8 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -842,7 +842,6 @@ static int em28xx_ir_init(struct em28xx *dev)
 	kfree(ir);
 ref_put:
 	em28xx_shutdown_buttons(dev);
-	kref_put(&dev->ref, em28xx_free_device);
 	return err;
 }
 
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index f1767be9d868..6650eab913d8 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -691,49 +691,23 @@ struct go7007 *go7007_alloc(const struct go7007_board_info *board,
 						struct device *dev)
 {
 	struct go7007 *go;
-	int i;
 
 	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
 	go->board_info = board;
-	go->board_id = 0;
 	go->tuner_type = -1;
-	go->channel_number = 0;
-	go->name[0] = 0;
 	mutex_init(&go->hw_lock);
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
 	go->status = STATUS_INIT;
-	memset(&go->i2c_adapter, 0, sizeof(go->i2c_adapter));
-	go->i2c_adapter_online = 0;
-	go->interrupt_available = 0;
 	init_waitqueue_head(&go->interrupt_waitq);
-	go->input = 0;
 	go7007_update_board(go);
-	go->encoder_h_halve = 0;
-	go->encoder_v_halve = 0;
-	go->encoder_subsample = 0;
 	go->format = V4L2_PIX_FMT_MJPEG;
 	go->bitrate = 1500000;
 	go->fps_scale = 1;
-	go->pali = 0;
 	go->aspect_ratio = GO7007_RATIO_1_1;
-	go->gop_size = 0;
-	go->ipb = 0;
-	go->closed_gop = 0;
-	go->repeat_seqhead = 0;
-	go->seq_header_enable = 0;
-	go->gop_header_enable = 0;
-	go->dvd_mode = 0;
-	go->interlace_coding = 0;
-	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;
-	for (i = 0; i < 1624; ++i)
-		go->modet_map[i] = 0;
-	go->audio_deliver = NULL;
-	go->audio_enabled = 0;
 
 	return go;
 }
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index dbf0455d5d50..eeb85981e02b 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1134,7 +1134,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 
 	ep = usb->usbdev->ep_in[4];
 	if (!ep)
-		return -ENODEV;
+		goto allocfail;
 
 	/* Allocate the URB and buffer for receiving incoming interrupts */
 	usb->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index cd833011f285..4757e29b42c0 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -81,7 +81,7 @@ static struct crashpoint crashpoints[] = {
 	CRASHPOINT("FS_DEVRW",		 "ll_rw_block"),
 	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
 	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
-	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_dispatch_cmd"),
+	CRASHPOINT("SCSI_QUEUE_RQ",	 "scsi_queue_rq"),
 	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
 #endif
 };
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index c3229d8c7041..33cb70aa02aa 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -782,6 +782,7 @@ static int dw_mci_edmac_start_dma(struct dw_mci *host,
 	int ret = 0;
 
 	/* Set external dma config: burst size, burst width */
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.dst_addr = host->phy_regs + fifo_offset;
 	cfg.src_addr = cfg.dst_addr;
 	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index bde298887579..6c9d38132f74 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -628,6 +628,7 @@ static int moxart_probe(struct platform_device *pdev)
 			 host->dma_chan_tx, host->dma_chan_rx);
 		host->have_dma = true;
 
+		memset(&cfg, 0, sizeof(cfg));
 		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6b39126fbf06..a1df6d4e9e86 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1222,6 +1222,7 @@ static int sdhci_external_dma_setup(struct sdhci_host *host,
 	if (!host->mapbase)
 		return -EINVAL;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = host->mapbase + SDHCI_BUFFER;
 	cfg.dst_addr = host->mapbase + SDHCI_BUFFER;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..54b273d85861 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1993,15 +1993,6 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_flags);
 
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack)
-{
-	b53_port_set_mcast_flood(ds->priv, port, mrouter);
-
-	return 0;
-}
-EXPORT_SYMBOL(b53_set_mrouter);
-
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -2245,7 +2236,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_bridge_leave	= b53_br_leave,
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 82700a5714c1..9bf8319342b0 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -328,8 +328,6 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
 int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct switchdev_brport_flags flags,
 		 struct netlink_ext_ack *extack);
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3b018fcf4412..6ce9ec1283e0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1199,7 +1199,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
 	.port_stp_state_set	= b53_br_set_stp_state,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2b01efad1a51..647f8e5c16da 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1172,18 +1172,6 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-mt7530_port_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-			struct netlink_ext_ack *extack)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
-		   mrouter ? UNM_FFP(BIT(port)) : 0);
-
-	return 0;
-}
-
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct net_device *bridge)
@@ -2847,7 +2835,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_stp_state_set	= mt7530_stp_state_set,
 	.port_pre_bridge_flags	= mt7530_port_pre_bridge_flags,
 	.port_bridge_flags	= mt7530_port_bridge_flags,
-	.port_set_mrouter	= mt7530_port_set_mrouter,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
 	.port_fdb_add		= mt7530_port_fdb_add,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 272b0535d946..111a6d5985da 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5781,23 +5781,6 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	return err;
 }
 
-static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
-				      bool mrouter,
-				      struct netlink_ext_ack *extack)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	if (!chip->info->ops->port_set_mcast_flood)
-		return -EOPNOTSUPP;
-
-	mv88e6xxx_reg_lock(chip);
-	err = chip->info->ops->port_set_mcast_flood(chip, port, mrouter);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
@@ -6099,7 +6082,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
 	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
-	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 59253846e885..f26d03735619 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -417,6 +417,9 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_restore_state(pdev);
 
 	if (deep) {
+		/* Reinitialize Nic/Vecs objects */
+		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+
 		ret = aq_nic_init(nic);
 		if (ret)
 			goto err_exit;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 53864f200599..b175f2b2f5bc 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -233,7 +233,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
 
 	// Check if next command will overflow the buffer.
-	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+	if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+	    (tail & priv->adminq_mask)) {
 		int err;
 
 		// Flush existing commands to make room.
@@ -243,7 +244,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 
 		// Retry.
 		tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
-		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
+		if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
+		    (tail & priv->adminq_mask)) {
 			// This should never happen. We just flushed the
 			// command queue so there should be enough space.
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index eff0a30790dd..472f56b360b8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1160,12 +1160,12 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 }
 
 /**
- * i40e_getnum_vf_vsi_vlan_filters
+ * __i40e_getnum_vf_vsi_vlan_filters
  * @vsi: pointer to the vsi
  *
  * called to get the number of VLANs offloaded on this VF
  **/
-static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+static int __i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
 	u16 num_vlans = 0, bkt;
@@ -1178,6 +1178,23 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 	return num_vlans;
 }
 
+/**
+ * i40e_getnum_vf_vsi_vlan_filters
+ * @vsi: pointer to the vsi
+ *
+ * wrapper for __i40e_getnum_vf_vsi_vlan_filters() with spinlock held
+ **/
+static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+{
+	int num_vlans;
+
+	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
+	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+	return num_vlans;
+}
+
 /**
  * i40e_get_vlan_list_sync
  * @vsi: pointer to the VSI
@@ -1195,7 +1212,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, u16 *num_vlans,
 	int bkt;
 
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	*num_vlans = i40e_getnum_vf_vsi_vlan_filters(vsi);
+	*num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
 	*vlan_list = kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
 	if (!(*vlan_list))
 		goto err;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a7f2f5c490e3..e16d20b77a3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4911,6 +4911,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	struct ice_hw *hw = &pf->hw;
 	struct sockaddr *addr = pi;
 	enum ice_status status;
+	u8 old_mac[ETH_ALEN];
 	u8 flags = 0;
 	int err = 0;
 	u8 *mac;
@@ -4933,8 +4934,13 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	}
 
 	netif_addr_lock_bh(netdev);
+	ether_addr_copy(old_mac, netdev->dev_addr);
+	/* change the netdev's MAC address */
+	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	netif_addr_unlock_bh(netdev);
+
 	/* Clean up old MAC filter. Not an error if old filter doesn't exist */
-	status = ice_fltr_remove_mac(vsi, netdev->dev_addr, ICE_FWD_TO_VSI);
+	status = ice_fltr_remove_mac(vsi, old_mac, ICE_FWD_TO_VSI);
 	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
 		err = -EADDRNOTAVAIL;
 		goto err_update_filters;
@@ -4957,13 +4963,12 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	if (err) {
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
+		netif_addr_lock_bh(netdev);
+		ether_addr_copy(netdev->dev_addr, old_mac);
 		netif_addr_unlock_bh(netdev);
 		return err;
 	}
 
-	/* change the netdev's MAC address */
-	memcpy(netdev->dev_addr, mac, netdev->addr_len);
-	netif_addr_unlock_bh(netdev);
 	netdev_dbg(vsi->netdev, "updated MAC address to %pM\n",
 		   netdev->dev_addr);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e66109367487..c1e11cb68d26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -195,8 +195,6 @@ enum nix_scheduler {
 #define NIX_CHAN_LBK_CHX(a, b)		(0 + 0x100 * (a) + (b))
 #define NIX_CHAN_SDP_CH_START		(0x700ull)
 
-#define SDP_CHANNELS			256
-
 /* NIX LSO format indices.
  * As of now TSO is the only one using, so statically assigning indices.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 7d9e71c6965f..7a2157709dde 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -12,9 +12,10 @@
 
 int rvu_set_channels_base(struct rvu *rvu)
 {
+	u16 nr_lbk_chans, nr_sdp_chans, nr_cgx_chans, nr_cpt_chans;
+	u16 sdp_chan_base, cgx_chan_base, cpt_chan_base;
 	struct rvu_hwinfo *hw = rvu->hw;
-	u16 cpt_chan_base;
-	u64 nix_const;
+	u64 nix_const, nix_const1;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
@@ -22,6 +23,7 @@ int rvu_set_channels_base(struct rvu *rvu)
 		return blkaddr;
 
 	nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 
 	hw->cgx = (nix_const >> 12) & 0xFULL;
 	hw->lmac_per_cgx = (nix_const >> 8) & 0xFULL;
@@ -44,14 +46,24 @@ int rvu_set_channels_base(struct rvu *rvu)
 	 * channels such that all channel numbers are contiguous
 	 * leaving no holes. This way the new CPT channels can be
 	 * accomodated. The order of channel numbers assigned is
-	 * LBK, SDP, CGX and CPT.
+	 * LBK, SDP, CGX and CPT. Also the base channel number
+	 * of a block must be multiple of number of channels
+	 * of the block.
 	 */
-	hw->sdp_chan_base = hw->lbk_chan_base + hw->lbk_links *
-				((nix_const >> 16) & 0xFFULL);
-	hw->cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * SDP_CHANNELS;
+	nr_lbk_chans = (nix_const >> 16) & 0xFFULL;
+	nr_sdp_chans = nix_const1 & 0xFFFULL;
+	nr_cgx_chans = nix_const & 0xFFULL;
+	nr_cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
-	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links *
-				(nix_const & 0xFFULL);
+	sdp_chan_base = hw->lbk_chan_base + hw->lbk_links * nr_lbk_chans;
+	/* Round up base channel to multiple of number of channels */
+	hw->sdp_chan_base = ALIGN(sdp_chan_base, nr_sdp_chans);
+
+	cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * nr_sdp_chans;
+	hw->cgx_chan_base = ALIGN(cgx_chan_base, nr_cgx_chans);
+
+	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links * nr_cgx_chans;
+	hw->cpt_chan_base = ALIGN(cpt_chan_base, nr_cpt_chans);
 
 	/* Out of 4096 channels start CPT from 2048 so
 	 * that MSB for CPT channels is always set
@@ -155,6 +167,7 @@ static void rvu_lbk_set_channels(struct rvu *rvu)
 
 static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 {
+	u64 nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 	u64 nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	u16 cgx_chans, lbk_chans, sdp_chans, cpt_chans;
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -164,7 +177,7 @@ static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 
 	cgx_chans = nix_const & 0xFFULL;
 	lbk_chans = (nix_const >> 16) & 0xFFULL;
-	sdp_chans = SDP_CHANNELS;
+	sdp_chans = nix_const1 & 0xFFFULL;
 	cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
 	start = hw->cgx_chan_base;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0bc4529691ec..d413078fc043 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -23,7 +23,7 @@
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
-#define NPC_HW_TSTAMP_OFFSET		8
+#define NPC_HW_TSTAMP_OFFSET		8ULL
 #define NPC_KEX_CHAN_MASK		0xFFFULL
 #define NPC_KEX_PF_FUNC_MASK		0xFFFFULL
 
@@ -823,7 +823,7 @@ void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
-	int actindex, index, bank;
+	int actindex, index, bank, entry;
 	bool enable;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
@@ -834,7 +834,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
-			index &= (mcam->banksize - 1);
+			entry = index & (mcam->banksize - 1);
 
 			/* read vf flow entry enable status */
 			enable = is_mcam_entry_enabled(rvu, mcam, blkaddr,
@@ -844,7 +844,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 					      false);
 			/* update 'action' */
 			rvu_write64(rvu, blkaddr,
-				    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
+				    NPC_AF_MCAMEX_BANKX_ACTION(entry, bank),
 				    rx_action);
 			if (enable)
 				npc_enable_mcam_entry(rvu, mcam, blkaddr,
@@ -1619,14 +1619,15 @@ int rvu_npc_init(struct rvu *rvu)
 
 	/* Enable below for Rx pkts.
 	 * - Outer IPv4 header checksum validation.
-	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2M].
+	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2B].
+	 * - Detect outer L2 multicast address and set NPC_RESULT_S[L2M].
 	 * - Inner IPv4 header checksum validation.
 	 * - Set non zero checksum error code value
 	 */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_CFG,
 		    rvu_read64(rvu, blkaddr, NPC_AF_PCK_CFG) |
-		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
-		    BIT_ULL(2) | BIT_ULL(1));
+		    ((u64)NPC_EC_OIP4_CSUM << 32) | (NPC_EC_IIP4_CSUM << 24) |
+		    BIT_ULL(7) | BIT_ULL(6) | BIT_ULL(2) | BIT_ULL(1));
 
 	rvu_npc_setup_interfaces(rvu, blkaddr);
 
@@ -1751,7 +1752,7 @@ static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
 					  int blkaddr, u16 entry, u16 cntr)
 {
 	u16 index = entry & (mcam->banksize - 1);
-	u16 bank = npc_get_bank(mcam, entry);
+	u32 bank = npc_get_bank(mcam, entry);
 
 	/* Remove mapping and reduce counter's refcnt */
 	mcam->entry2cntr_map[entry] = NPC_MCAM_INVALID_MAP;
@@ -2365,8 +2366,8 @@ int rvu_mbox_handler_npc_mcam_shift_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
 	u16 old_entry, new_entry;
+	int blkaddr, rc = 0;
 	u16 index, cntr;
-	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -2567,10 +2568,11 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
 		if (index >= mcam->bmap_entries)
 			break;
+		entry = index + 1;
+
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
 
-		entry = index + 1;
 		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
 					      index, req->cntr);
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 16ba457197a2..e0d1af9e7770 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -208,7 +208,8 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data)) {
 		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 		/* update dmac field in vlan offload rule */
-		if (pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+		if (netif_running(netdev) &&
+		    pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 			otx2_install_rxvlan_offload_flow(pfvf);
 	} else {
 		return -EPERM;
@@ -265,6 +266,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct nix_rss_flowkey_cfg_rsp *rsp;
 	struct nix_rss_flowkey_cfg *req;
 	int err;
 
@@ -279,6 +281,18 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	req->group = DEFAULT_RSS_CONTEXT_GROUP;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	rsp = (struct nix_rss_flowkey_cfg_rsp *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
+		goto fail;
+	}
+
+	pfvf->hw.flowkey_alg_idx = rsp->alg_idx;
+fail:
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 45730d0d92f2..c652c27cd345 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -195,6 +195,9 @@ struct otx2_hw {
 	u8			lso_udpv4_idx;
 	u8			lso_udpv6_idx;
 
+	/* RSS */
+	u8			flowkey_alg_idx;
+
 	/* MSI-X */
 	u8			cint_cnt; /* CQ interrupt count */
 	u16			npa_msixoff; /* Offset of NPA vectors */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0b4fa92ba821..81265dbf91e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -682,6 +682,7 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 		if (flow->flow_spec.flow_type & FLOW_RSS) {
 			req->op = NIX_RX_ACTIONOP_RSS;
 			req->index = flow->rss_ctx_id;
+			req->flow_key_alg = pfvf->hw.flowkey_alg_idx;
 		} else {
 			req->op = NIX_RX_ACTIONOP_UCAST;
 			req->index = ethtool_get_flow_spec_ring(ring_cookie);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 51157b283f6f..463d2368c118 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -385,8 +385,8 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 				   match.key->vlan_priority << 13;
 
 			vlan_tci_mask = match.mask->vlan_id |
-					match.key->vlan_dei << 12 |
-					match.key->vlan_priority << 13;
+					match.mask->vlan_dei << 12 |
+					match.mask->vlan_priority << 13;
 
 			flow_spec->vlan_tci = htons(vlan_tci);
 			flow_mask->vlan_tci = htons(vlan_tci_mask);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index def2156e50ee..20bb37266254 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -397,7 +397,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
 	mutex_lock(&mlx5_intf_mutex);
-	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 44c458443428..4794173f8fdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -664,6 +664,7 @@ int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 1d5ce07b83f4..43b092f5565a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -248,18 +248,12 @@ struct ttc_params {
 
 void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv, struct ttc_params *ttc_params);
 void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params);
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params);
 
 int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
 			   struct mlx5e_ttc_table *ttc);
 void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv,
 			     struct mlx5e_ttc_table *ttc);
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc);
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc);
-
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type,
 		       struct mlx5_flow_destination *new_dest);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 5efe3278b0f6..1fd8baf19829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -733,8 +733,8 @@ static void mlx5e_reset_qdisc(struct net_device *dev, u16 qid)
 	spin_unlock_bh(qdisc_lock(qdisc));
 }
 
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
-		       u16 *new_qid, struct netlink_ext_ack *extack)
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
+		       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node;
 	struct netdev_queue *txq;
@@ -742,11 +742,9 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	bool opened;
 	int err;
 
-	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL classid %04x\n", classid);
-
-	*old_qid = *new_qid = 0;
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL classid %04x\n", *classid);
 
-	node = mlx5e_sw_node_find(priv, classid);
+	node = mlx5e_sw_node_find(priv, *classid);
 	if (!node)
 		return -ENOENT;
 
@@ -764,7 +762,7 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	err = mlx5_qos_destroy_node(priv->mdev, node->hw_id);
 	if (err) /* Not fatal. */
 		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
-			 node->hw_id, classid, err);
+			 node->hw_id, *classid, err);
 
 	mlx5e_sw_node_delete(priv, node);
 
@@ -826,8 +824,7 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	if (opened)
 		mlx5e_reactivate_qos_sq(priv, moved_qid, txq);
 
-	*old_qid = mlx5e_qid_from_qos(&priv->channels, moved_qid);
-	*new_qid = mlx5e_qid_from_qos(&priv->channels, qid);
+	*classid = node->classid;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index 5af7991fcd19..757682b7c0e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -34,8 +34,8 @@ int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
 			       struct netlink_ext_ack *extack);
 int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
 			    u64 rate, u64 ceil, struct netlink_ext_ack *extack);
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
-		       u16 *new_qid, struct netlink_ext_ack *extack);
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
+		       struct netlink_ext_ack *extack);
 int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
 			    struct netlink_ext_ack *extack);
 int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 490131e06efb..aa4dc7d624f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -143,7 +143,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	mlx5e_rep_queue_neigh_stats_work(priv);
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || !flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
@@ -184,7 +184,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
+		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 0b75fab41ae8..6464ac3f294e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1324,7 +1324,7 @@ void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
 	ttc_params->inner_ttc = &priv->fs.inner_ttc;
 }
 
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
+static void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
 
@@ -1343,8 +1343,8 @@ void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params)
 	ft_attr->prio = MLX5E_NIC_PRIO;
 }
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc)
+static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
+					struct mlx5e_ttc_table *ttc)
 {
 	struct mlx5e_flow_table *ft = &ttc->ft;
 	int err;
@@ -1374,8 +1374,8 @@ int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *par
 	return err;
 }
 
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc)
+static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
+					  struct mlx5e_ttc_table *ttc)
 {
 	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 779a4abead01..814ff51db1a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2563,6 +2563,14 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
 		if (err)
 			goto free_in;
+
+		/* Verify inner tirs resources allocated */
+		if (!priv->inner_indir_tir[0].tirn)
+			continue;
+
+		err = mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
+		if (err)
+			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
@@ -3439,8 +3447,7 @@ static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offloa
 		return mlx5e_htb_leaf_to_inner(priv, htb->parent_classid, htb->classid,
 					       htb->rate, htb->ceil, htb->extack);
 	case TC_HTB_LEAF_DEL:
-		return mlx5e_htb_leaf_del(priv, htb->classid, &htb->moved_qid, &htb->qid,
-					  htb->extack);
+		return mlx5e_htb_leaf_del(priv, &htb->classid, htb->extack);
 	case TC_HTB_LEAF_DEL_LAST:
 	case TC_HTB_LEAF_DEL_LAST_FORCE:
 		return mlx5e_htb_leaf_del_last(priv, htb->classid,
@@ -4806,7 +4813,14 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_TX;
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_RX;
 
+	/* Tunneled LRO is not supported in the driver, and the same RQs are
+	 * shared between inner and outer TIRs, so the driver can't disable LRO
+	 * for inner TIRs while having it enabled for outer TIRs. Due to this,
+	 * block LRO altogether if the firmware declares tunneled LRO support.
+	 */
 	if (!!MLX5_CAP_ETH(mdev, lro_cap) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
 		netdev->vlan_features    |= NETIF_F_LRO;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 47bd20ad8108..ced6ff0bc916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1310,6 +1310,7 @@ bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_
 int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev, u16 *vport)
 {
 	struct mlx5e_priv *out_priv, *route_priv;
+	struct mlx5_devcom *devcom = NULL;
 	struct mlx5_core_dev *route_mdev;
 	struct mlx5_eswitch *esw;
 	u16 vhca_id;
@@ -1321,7 +1322,24 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	route_mdev = route_priv->mdev;
 
 	vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
+	if (mlx5_lag_is_active(out_priv->mdev)) {
+		/* In lag case we may get devices from different eswitch instances.
+		 * If we failed to get vport num, it means, mostly, that we on the wrong
+		 * eswitch.
+		 */
+		err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+		if (err != -ENOENT)
+			return err;
+
+		devcom = out_priv->mdev->priv.devcom;
+		esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		if (!esw)
+			return -ENODEV;
+	}
+
 	err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	if (devcom)
+		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 3da7becc1069..425c91814b34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -364,6 +364,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	e->fwd_rule = mlx5_add_flow_rules(e->ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(e->fwd_rule)) {
 		mlx5_destroy_flow_group(e->fwd_grp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d0e4daa55a4a..c6d3348d759e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3074,8 +3074,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
-		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
+		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
+			err = 0;
 			goto out;
+		}
+
 		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 7d7ed025db0d..620d638e1e8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -331,17 +331,6 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	}
 
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-	mlx5e_set_inner_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
-
-	err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
-	if (err) {
-		netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
-			   err);
-		goto err_destroy_arfs_tables;
-	}
-
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
@@ -350,13 +339,11 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
-		goto err_destroy_inner_ttc_table;
+		goto err_destroy_arfs_tables;
 	}
 
 	return 0;
 
-err_destroy_inner_ttc_table:
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -366,7 +353,6 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 }
 
@@ -392,7 +378,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_indirect_rqts;
 
-	err = mlx5e_create_indirect_tirs(priv, true);
+	err = mlx5e_create_indirect_tirs(priv, false);
 	if (err)
 		goto err_destroy_direct_rqts;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index b41301a5b0df..cd520e4c5522 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -91,20 +91,20 @@ int ionic_devlink_register(struct ionic *ionic)
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
-	if (err)
+	if (err) {
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else
-		devlink_port_type_eth_set(&ionic->dl_port,
-					  ionic->lif->netdev);
+		devlink_unregister(dl);
+		return err;
+	}
 
-	return err;
+	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
+	return 0;
 }
 
 void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	if (ionic->dl_port.registered)
-		devlink_port_unregister(&ionic->dl_port);
+	devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
 }
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index ab9b02574a15..38018f024823 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -434,7 +434,7 @@ qcaspi_receive(struct qcaspi *qca)
 				skb_put(qca->rx_skb, retcode);
 				qca->rx_skb->protocol = eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
-				qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+				skb_checksum_none_assert(qca->rx_skb);
 				netif_rx_ni(qca->rx_skb);
 				qca->rx_skb = netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index bcdeca7b3366..ce3f7ce31adc 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -107,7 +107,7 @@ qca_tty_receive(struct serdev_device *serdev, const unsigned char *data,
 			skb_put(qca->rx_skb, retcode);
 			qca->rx_skb->protocol = eth_type_trans(
 						qca->rx_skb, qca->rx_skb->dev);
-			qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb_checksum_none_assert(qca->rx_skb);
 			netif_rx_ni(qca->rx_skb);
 			qca->rx_skb = netdev_alloc_skb_ip_align(netdev,
 								netdev->mtu +
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index e63270267578..f83db62938dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -172,11 +172,12 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 		x->rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (DMA_CHAN_STATUS_TI |
-		DMA_CHAN_STATUS_TBU))) {
+	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
 		x->tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
+	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
+		ret |= handle_tx;
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
 		x->rx_early_irq++;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 67a08cbba859..e967cd1ade36 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -518,6 +518,10 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	}
 
 	napi_enable(&common->napi_rx);
+	if (common->rx_irq_disabled) {
+		common->rx_irq_disabled = false;
+		enable_irq(common->rx_chns.irq);
+	}
 
 	dev_dbg(common->dev, "cpsw_nuss started\n");
 	return 0;
@@ -871,8 +875,12 @@ static int am65_cpsw_nuss_rx_poll(struct napi_struct *napi_rx, int budget)
 
 	dev_dbg(common->dev, "%s num_rx:%d %d\n", __func__, num_rx, budget);
 
-	if (num_rx < budget && napi_complete_done(napi_rx, num_rx))
-		enable_irq(common->rx_chns.irq);
+	if (num_rx < budget && napi_complete_done(napi_rx, num_rx)) {
+		if (common->rx_irq_disabled) {
+			common->rx_irq_disabled = false;
+			enable_irq(common->rx_chns.irq);
+		}
+	}
 
 	return num_rx;
 }
@@ -1090,6 +1098,7 @@ static irqreturn_t am65_cpsw_nuss_rx_irq(int irq, void *dev_id)
 {
 	struct am65_cpsw_common *common = dev_id;
 
+	common->rx_irq_disabled = true;
 	disable_irq_nosync(irq);
 	napi_schedule(&common->napi_rx);
 
@@ -2388,21 +2397,6 @@ static const struct devlink_param am65_cpsw_devlink_params[] = {
 			     am65_cpsw_dl_switch_mode_set, NULL),
 };
 
-static void am65_cpsw_unregister_devlink_ports(struct am65_cpsw_common *common)
-{
-	struct devlink_port *dl_port;
-	struct am65_cpsw_port *port;
-	int i;
-
-	for (i = 1; i <= common->port_num; i++) {
-		port = am65_common_get_port(common, i);
-		dl_port = &port->devlink_port;
-
-		if (dl_port->registered)
-			devlink_port_unregister(dl_port);
-	}
-}
-
 static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 {
 	struct devlink_port_attrs attrs = {};
@@ -2464,7 +2458,12 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	return ret;
 
 dl_port_unreg:
-	am65_cpsw_unregister_devlink_ports(common);
+	for (i = i - 1; i >= 1; i--) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
 dl_unreg:
 	devlink_unregister(common->devlink);
 dl_free:
@@ -2475,6 +2474,17 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 
 static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 {
+	struct devlink_port *dl_port;
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 1; i <= common->port_num; i++) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
+
 	if (!AM65_CPSW_IS_CPSW2G(common) &&
 	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
 		devlink_params_unpublish(common->devlink);
@@ -2482,7 +2492,6 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 					  ARRAY_SIZE(am65_cpsw_devlink_params));
 	}
 
-	am65_cpsw_unregister_devlink_ports(common);
 	devlink_unregister(common->devlink);
 	devlink_free(common->devlink);
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 5d93e346f05e..048ed10143c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -126,6 +126,8 @@ struct am65_cpsw_common {
 	struct am65_cpsw_rx_chn	rx_chns;
 	struct napi_struct	napi_rx;
 
+	bool			rx_irq_disabled;
+
 	u32			nuss_ver;
 	u32			cpsw_ver;
 	unsigned long		bus_freq;
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 53a433442803..f4d758f8a1ee 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -987,11 +987,19 @@ static int mv3310_get_number_of_ports(struct phy_device *phydev)
 
 static int mv3310_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
+	     MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 1;
 }
 
 static int mv3340_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
+	     MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 4;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index b137e7f34397..bd1ef6334997 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2504,8 +2504,10 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 		goto free_data_skb;
 
 	for (index = 0; index < num_pri_streams; index++) {
-		if (WARN_ON(!data_sync_bufs[index].skb))
+		if (WARN_ON(!data_sync_bufs[index].skb)) {
+			ret = -ENOMEM;
 			goto free_data_skb;
+		}
 
 		ep_id = ath6kl_ac2_endpoint_id(wmi->parent_dev,
 					       data_sync_bufs[index].
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 143a705b5cb3..4800e19bdcc3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2075,7 +2075,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
+		__brcmf_err(NULL, __func__, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index e31bba836c6f..dfa4047f97a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -243,7 +243,7 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 		goto out_free;
 	}
 
-	enabled = !!wifi_pkg->package.elements[0].integer.value;
+	enabled = !!wifi_pkg->package.elements[1].integer.value;
 
 	if (!enabled) {
 		*block_list_size = -1;
@@ -252,15 +252,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 		goto out_free;
 	}
 
-	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER ||
-	    wifi_pkg->package.elements[1].integer.value >
+	if (wifi_pkg->package.elements[2].type != ACPI_TYPE_INTEGER ||
+	    wifi_pkg->package.elements[2].integer.value >
 	    APCI_WTAS_BLACK_LIST_MAX) {
 		IWL_DEBUG_RADIO(fwrt, "TAS invalid array size %llu\n",
 				wifi_pkg->package.elements[1].integer.value);
 		ret = -EINVAL;
 		goto out_free;
 	}
-	*block_list_size = wifi_pkg->package.elements[1].integer.value;
+	*block_list_size = wifi_pkg->package.elements[2].integer.value;
 
 	IWL_DEBUG_RADIO(fwrt, "TAS array size %d\n", *block_list_size);
 	if (*block_list_size > APCI_WTAS_BLACK_LIST_MAX) {
@@ -273,15 +273,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 	for (i = 0; i < *block_list_size; i++) {
 		u32 country;
 
-		if (wifi_pkg->package.elements[2 + i].type !=
+		if (wifi_pkg->package.elements[3 + i].type !=
 		    ACPI_TYPE_INTEGER) {
 			IWL_DEBUG_RADIO(fwrt,
-					"TAS invalid array elem %d\n", 2 + i);
+					"TAS invalid array elem %d\n", 3 + i);
 			ret = -EINVAL;
 			goto out_free;
 		}
 
-		country = wifi_pkg->package.elements[2 + i].integer.value;
+		country = wifi_pkg->package.elements[3 + i].integer.value;
 		block_list_array[i] = cpu_to_le32(country);
 		IWL_DEBUG_RADIO(fwrt, "TAS block list country %d\n", country);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 9f11a1d5d034..81e881da7f15 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -556,6 +556,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0xA0F0, 0x6074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0070, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x0074, iwl_ax201_cfg_quz_hr, NULL),
 	IWL_DEV_INFO(0x02F0, 0x6074, iwl_ax201_cfg_quz_hr, NULL),
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 99b21a2c8386..f4a26f16f00f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -1038,8 +1038,10 @@ static int rsi_load_9116_firmware(struct rsi_hw *adapter)
 	}
 
 	ta_firmware = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!ta_firmware)
+	if (!ta_firmware) {
+		status = -ENOMEM;
 		goto fail_release_fw;
+	}
 	fw_p = ta_firmware;
 	instructions_sz = fw_entry->size;
 	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", instructions_sz);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 3fbe2a3c1455..416976f09888 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -816,6 +816,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
 			__func__, id->idProduct);
+		status = -ENODEV;
 		goto err1;
 	}
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4697a94c0945..f80682f7df54 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -736,13 +736,13 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->ctrl.queue_count = nr_io_queues + 1;
-	if (ctrl->ctrl.queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->ctrl.device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->ctrl.queue_count = nr_io_queues + 1;
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 79a463090dd3..ab1ea5b0888e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1755,13 +1755,13 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->queue_count = nr_io_queues + 1;
-	if (ctrl->queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->queue_count = nr_io_queues + 1;
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 7d0f3523fdab..8ef564c3b32c 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -120,6 +120,7 @@ static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 	if (!sqsize) {
 		pr_warn("queue size zero!\n");
 		req->error_loc = offsetof(struct nvmf_connect_command, sqsize);
+		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(sqsize);
 		ret = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 		goto err;
 	}
@@ -260,11 +261,11 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	}
 
 	status = nvmet_install_queue(ctrl, req);
-	if (status) {
-		/* pass back cntlid that had the issue of installing queue */
-		req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
+	if (status)
 		goto out_ctrl_put;
-	}
+
+	/* pass back cntlid for successful completion */
+	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
 
 	pr_debug("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8d4ebe095d0c..a9d0530b7846 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2495,7 +2495,14 @@ static int __pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable
 	if (enable) {
 		int error;
 
-		if (pci_pme_capable(dev, state))
+		/*
+		 * Enable PME signaling if the device can signal PME from
+		 * D3cold regardless of whether or not it can signal PME from
+		 * the current target state, because that will allow it to
+		 * signal PME when the hierarchy above it goes into D3cold and
+		 * the device itself ends up in D3cold as a result of that.
+		 */
+		if (pci_pme_capable(dev, state) || pci_pme_capable(dev, PCI_D3cold))
 			pci_pme_active(dev, true);
 		else
 			ret = 1;
@@ -2599,16 +2606,20 @@ static pci_power_t pci_target_state(struct pci_dev *dev, bool wakeup)
 	if (dev->current_state == PCI_D3cold)
 		target_state = PCI_D3cold;
 
-	if (wakeup) {
+	if (wakeup && dev->pme_support) {
+		pci_power_t state = target_state;
+
 		/*
 		 * Find the deepest state from which the device can generate
 		 * PME#.
 		 */
-		if (dev->pme_support) {
-			while (target_state
-			      && !(dev->pme_support & (1 << target_state)))
-				target_state--;
-		}
+		while (state && !(dev->pme_support & (1 << state)))
+			state--;
+
+		if (state)
+			return state;
+		else if (dev->pme_support & 1)
+			return PCI_D0;
 	}
 
 	return target_state;
diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 37af0e216bc3..225adaffaa28 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -149,7 +149,7 @@ static int fuel_gauge_reg_readb(struct axp288_fg_info *info, int reg)
 	}
 
 	if (ret < 0) {
-		dev_err(&info->pdev->dev, "axp288 reg read err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error reading reg 0x%02x err: %d\n", reg, ret);
 		return ret;
 	}
 
@@ -163,7 +163,7 @@ static int fuel_gauge_reg_writeb(struct axp288_fg_info *info, int reg, u8 val)
 	ret = regmap_write(info->regmap, reg, (unsigned int)val);
 
 	if (ret < 0)
-		dev_err(&info->pdev->dev, "axp288 reg write err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error writing reg 0x%02x err: %d\n", reg, ret);
 
 	return ret;
 }
diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index d110597746b0..091868e9e9e8 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -679,7 +679,9 @@ static int cw_bat_probe(struct i2c_client *client)
 						    &cw2015_bat_desc,
 						    &psy_cfg);
 	if (IS_ERR(cw_bat->rk_bat)) {
-		dev_err(cw_bat->dev, "Failed to register power supply\n");
+		/* try again if this happens */
+		dev_err_probe(&client->dev, PTR_ERR(cw_bat->rk_bat),
+			"Failed to register power supply\n");
 		return PTR_ERR(cw_bat->rk_bat);
 	}
 
diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index ce2041b30a06..215e77d3b6d9 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -748,7 +748,7 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 	struct max17042_config_data *config = chip->pdata->config_data;
 
 	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_TOFF, config->toff);
 	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
 	max17042_override_por(map, MAX17042_COFF, config->coff);
 
diff --git a/drivers/power/supply/smb347-charger.c b/drivers/power/supply/smb347-charger.c
index 3376f42d46c3..25d239f2330e 100644
--- a/drivers/power/supply/smb347-charger.c
+++ b/drivers/power/supply/smb347-charger.c
@@ -56,6 +56,7 @@
 #define CFG_PIN_EN_CTRL_ACTIVE_LOW		0x60
 #define CFG_PIN_EN_APSD_IRQ			BIT(1)
 #define CFG_PIN_EN_CHARGER_ERROR		BIT(2)
+#define CFG_PIN_EN_CTRL				BIT(4)
 #define CFG_THERM				0x07
 #define CFG_THERM_SOFT_HOT_COMPENSATION_MASK	0x03
 #define CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT	0
@@ -725,6 +726,15 @@ static int smb347_hw_init(struct smb347_charger *smb)
 	if (ret < 0)
 		goto fail;
 
+	/* Activate pin control, making it writable. */
+	switch (smb->enable_control) {
+	case SMB3XX_CHG_ENABLE_PIN_ACTIVE_LOW:
+	case SMB3XX_CHG_ENABLE_PIN_ACTIVE_HIGH:
+		ret = regmap_set_bits(smb->regmap, CFG_PIN, CFG_PIN_EN_CTRL);
+		if (ret < 0)
+			goto fail;
+	}
+
 	/*
 	 * Make the charging functionality controllable by a write to the
 	 * command register unless pin control is specified in the platform
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 1d5b0a1b86f7..06cbe60c990f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1211,12 +1211,10 @@ static int tps65910_probe(struct platform_device *pdev)
 
 		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[i],
 					       &config);
-		if (IS_ERR(rdev)) {
-			dev_err(tps65910->dev,
-				"failed to register %s regulator\n",
-				pdev->name);
-			return PTR_ERR(rdev);
-		}
+		if (IS_ERR(rdev))
+			return dev_err_probe(tps65910->dev, PTR_ERR(rdev),
+					     "failed to register %s regulator\n",
+					     pdev->name);
 
 		/* Save regulator for cleanup */
 		pmic->rdev[i] = rdev;
diff --git a/drivers/regulator/vctrl-regulator.c b/drivers/regulator/vctrl-regulator.c
index cbadb1c99679..d2a37978fc3a 100644
--- a/drivers/regulator/vctrl-regulator.c
+++ b/drivers/regulator/vctrl-regulator.c
@@ -37,7 +37,6 @@ struct vctrl_voltage_table {
 struct vctrl_data {
 	struct regulator_dev *rdev;
 	struct regulator_desc desc;
-	struct regulator *ctrl_reg;
 	bool enabled;
 	unsigned int min_slew_down_rate;
 	unsigned int ovp_threshold;
@@ -82,7 +81,12 @@ static int vctrl_calc_output_voltage(struct vctrl_data *vctrl, int ctrl_uV)
 static int vctrl_get_voltage(struct regulator_dev *rdev)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	int ctrl_uV = regulator_get_voltage_rdev(vctrl->ctrl_reg->rdev);
+	int ctrl_uV;
+
+	if (!rdev->supply)
+		return -EPROBE_DEFER;
+
+	ctrl_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
 
 	return vctrl_calc_output_voltage(vctrl, ctrl_uV);
 }
@@ -92,14 +96,19 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 			     unsigned int *selector)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	struct regulator *ctrl_reg = vctrl->ctrl_reg;
-	int orig_ctrl_uV = regulator_get_voltage_rdev(ctrl_reg->rdev);
-	int uV = vctrl_calc_output_voltage(vctrl, orig_ctrl_uV);
+	int orig_ctrl_uV;
+	int uV;
 	int ret;
 
+	if (!rdev->supply)
+		return -EPROBE_DEFER;
+
+	orig_ctrl_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
+	uV = vctrl_calc_output_voltage(vctrl, orig_ctrl_uV);
+
 	if (req_min_uV >= uV || !vctrl->ovp_threshold)
 		/* voltage rising or no OVP */
-		return regulator_set_voltage_rdev(ctrl_reg->rdev,
+		return regulator_set_voltage_rdev(rdev->supply->rdev,
 			vctrl_calc_ctrl_voltage(vctrl, req_min_uV),
 			vctrl_calc_ctrl_voltage(vctrl, req_max_uV),
 			PM_SUSPEND_ON);
@@ -117,7 +126,7 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 		next_uV = max_t(int, req_min_uV, uV - max_drop_uV);
 		next_ctrl_uV = vctrl_calc_ctrl_voltage(vctrl, next_uV);
 
-		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
+		ret = regulator_set_voltage_rdev(rdev->supply->rdev,
 					    next_ctrl_uV,
 					    next_ctrl_uV,
 					    PM_SUSPEND_ON);
@@ -134,7 +143,7 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 
 err:
 	/* Try to go back to original voltage */
-	regulator_set_voltage_rdev(ctrl_reg->rdev, orig_ctrl_uV, orig_ctrl_uV,
+	regulator_set_voltage_rdev(rdev->supply->rdev, orig_ctrl_uV, orig_ctrl_uV,
 				   PM_SUSPEND_ON);
 
 	return ret;
@@ -151,16 +160,18 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 				 unsigned int selector)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	struct regulator *ctrl_reg = vctrl->ctrl_reg;
 	unsigned int orig_sel = vctrl->sel;
 	int ret;
 
+	if (!rdev->supply)
+		return -EPROBE_DEFER;
+
 	if (selector >= rdev->desc->n_voltages)
 		return -EINVAL;
 
 	if (selector >= vctrl->sel || !vctrl->ovp_threshold) {
 		/* voltage rising or no OVP */
-		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
+		ret = regulator_set_voltage_rdev(rdev->supply->rdev,
 					    vctrl->vtable[selector].ctrl,
 					    vctrl->vtable[selector].ctrl,
 					    PM_SUSPEND_ON);
@@ -179,7 +190,7 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 		else
 			next_sel = vctrl->vtable[vctrl->sel].ovp_min_sel;
 
-		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
+		ret = regulator_set_voltage_rdev(rdev->supply->rdev,
 					    vctrl->vtable[next_sel].ctrl,
 					    vctrl->vtable[next_sel].ctrl,
 					    PM_SUSPEND_ON);
@@ -202,7 +213,7 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 err:
 	if (vctrl->sel != orig_sel) {
 		/* Try to go back to original voltage */
-		if (!regulator_set_voltage_rdev(ctrl_reg->rdev,
+		if (!regulator_set_voltage_rdev(rdev->supply->rdev,
 					   vctrl->vtable[orig_sel].ctrl,
 					   vctrl->vtable[orig_sel].ctrl,
 					   PM_SUSPEND_ON))
@@ -234,10 +245,6 @@ static int vctrl_parse_dt(struct platform_device *pdev,
 	u32 pval;
 	u32 vrange_ctrl[2];
 
-	vctrl->ctrl_reg = devm_regulator_get(&pdev->dev, "ctrl");
-	if (IS_ERR(vctrl->ctrl_reg))
-		return PTR_ERR(vctrl->ctrl_reg);
-
 	ret = of_property_read_u32(np, "ovp-threshold-percent", &pval);
 	if (!ret) {
 		vctrl->ovp_threshold = pval;
@@ -315,11 +322,11 @@ static int vctrl_cmp_ctrl_uV(const void *a, const void *b)
 	return at->ctrl - bt->ctrl;
 }
 
-static int vctrl_init_vtable(struct platform_device *pdev)
+static int vctrl_init_vtable(struct platform_device *pdev,
+			     struct regulator *ctrl_reg)
 {
 	struct vctrl_data *vctrl = platform_get_drvdata(pdev);
 	struct regulator_desc *rdesc = &vctrl->desc;
-	struct regulator *ctrl_reg = vctrl->ctrl_reg;
 	struct vctrl_voltage_range *vrange_ctrl = &vctrl->vrange.ctrl;
 	int n_voltages;
 	int ctrl_uV;
@@ -395,23 +402,19 @@ static int vctrl_init_vtable(struct platform_device *pdev)
 static int vctrl_enable(struct regulator_dev *rdev)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	int ret = regulator_enable(vctrl->ctrl_reg);
 
-	if (!ret)
-		vctrl->enabled = true;
+	vctrl->enabled = true;
 
-	return ret;
+	return 0;
 }
 
 static int vctrl_disable(struct regulator_dev *rdev)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	int ret = regulator_disable(vctrl->ctrl_reg);
 
-	if (!ret)
-		vctrl->enabled = false;
+	vctrl->enabled = false;
 
-	return ret;
+	return 0;
 }
 
 static int vctrl_is_enabled(struct regulator_dev *rdev)
@@ -447,6 +450,7 @@ static int vctrl_probe(struct platform_device *pdev)
 	struct regulator_desc *rdesc;
 	struct regulator_config cfg = { };
 	struct vctrl_voltage_range *vrange_ctrl;
+	struct regulator *ctrl_reg;
 	int ctrl_uV;
 	int ret;
 
@@ -461,15 +465,20 @@ static int vctrl_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ctrl_reg = devm_regulator_get(&pdev->dev, "ctrl");
+	if (IS_ERR(ctrl_reg))
+		return PTR_ERR(ctrl_reg);
+
 	vrange_ctrl = &vctrl->vrange.ctrl;
 
 	rdesc = &vctrl->desc;
 	rdesc->name = "vctrl";
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->owner = THIS_MODULE;
+	rdesc->supply_name = "ctrl";
 
-	if ((regulator_get_linear_step(vctrl->ctrl_reg) == 1) ||
-	    (regulator_count_voltages(vctrl->ctrl_reg) == -EINVAL)) {
+	if ((regulator_get_linear_step(ctrl_reg) == 1) ||
+	    (regulator_count_voltages(ctrl_reg) == -EINVAL)) {
 		rdesc->continuous_voltage_range = true;
 		rdesc->ops = &vctrl_ops_cont;
 	} else {
@@ -486,11 +495,12 @@ static int vctrl_probe(struct platform_device *pdev)
 	cfg.init_data = init_data;
 
 	if (!rdesc->continuous_voltage_range) {
-		ret = vctrl_init_vtable(pdev);
+		ret = vctrl_init_vtable(pdev, ctrl_reg);
 		if (ret)
 			return ret;
 
-		ctrl_uV = regulator_get_voltage_rdev(vctrl->ctrl_reg->rdev);
+		/* Use locked consumer API when not in regulator framework */
+		ctrl_uV = regulator_get_voltage(ctrl_reg);
 		if (ctrl_uV < 0) {
 			dev_err(&pdev->dev, "failed to get control voltage\n");
 			return ctrl_uV;
@@ -513,6 +523,9 @@ static int vctrl_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Drop ctrl-supply here in favor of regulator core managed supply */
+	devm_regulator_put(ctrl_reg);
+
 	vctrl->rdev = devm_regulator_register(&pdev->dev, rdesc, &cfg);
 	if (IS_ERR(vctrl->rdev)) {
 		ret = PTR_ERR(vctrl->rdev);
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index a974943c27da..9fcdb8d81eee 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -430,9 +430,26 @@ static ssize_t pimpampom_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(pimpampom);
 
+static ssize_t dev_busid_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct subchannel *sch = to_subchannel(dev);
+	struct pmcw *pmcw = &sch->schib.pmcw;
+
+	if ((pmcw->st == SUBCHANNEL_TYPE_IO ||
+	     pmcw->st == SUBCHANNEL_TYPE_MSG) && pmcw->dnv)
+		return sysfs_emit(buf, "0.%x.%04x\n", sch->schid.ssid,
+				  pmcw->dev);
+	else
+		return sysfs_emit(buf, "none\n");
+}
+static DEVICE_ATTR_RO(dev_busid);
+
 static struct attribute *io_subchannel_type_attrs[] = {
 	&dev_attr_chpids.attr,
 	&dev_attr_pimpampom.attr,
+	&dev_attr_dev_busid.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(io_subchannel_type);
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 2758d05a802d..179ceb01e040 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -121,22 +121,13 @@ static struct bus_type ap_bus_type;
 /* Adapter interrupt definitions */
 static void ap_interrupt_handler(struct airq_struct *airq, bool floating);
 
-static int ap_airq_flag;
+static bool ap_irq_flag;
 
 static struct airq_struct ap_airq = {
 	.handler = ap_interrupt_handler,
 	.isc = AP_ISC,
 };
 
-/**
- * ap_using_interrupts() - Returns non-zero if interrupt support is
- * available.
- */
-static inline int ap_using_interrupts(void)
-{
-	return ap_airq_flag;
-}
-
 /**
  * ap_airq_ptr() - Get the address of the adapter interrupt indicator
  *
@@ -146,7 +137,7 @@ static inline int ap_using_interrupts(void)
  */
 void *ap_airq_ptr(void)
 {
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		return ap_airq.lsi_ptr;
 	return NULL;
 }
@@ -376,7 +367,7 @@ void ap_wait(enum ap_sm_wait wait)
 	switch (wait) {
 	case AP_SM_WAIT_AGAIN:
 	case AP_SM_WAIT_INTERRUPT:
-		if (ap_using_interrupts())
+		if (ap_irq_flag)
 			break;
 		if (ap_poll_kthread) {
 			wake_up(&ap_poll_wait);
@@ -451,7 +442,7 @@ static void ap_tasklet_fn(unsigned long dummy)
 	 * be received. Doing it in the beginning of the tasklet is therefor
 	 * important that no requests on any AP get lost.
 	 */
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		xchg(ap_airq.lsi_ptr, 0);
 
 	spin_lock_bh(&ap_queues_lock);
@@ -521,7 +512,7 @@ static int ap_poll_thread_start(void)
 {
 	int rc;
 
-	if (ap_using_interrupts() || ap_poll_kthread)
+	if (ap_irq_flag || ap_poll_kthread)
 		return 0;
 	mutex_lock(&ap_poll_thread_mutex);
 	ap_poll_kthread = kthread_run(ap_poll_thread, NULL, "appoll");
@@ -1119,7 +1110,7 @@ static BUS_ATTR_RO(ap_adapter_mask);
 static ssize_t ap_interrupts_show(struct bus_type *bus, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n",
-			 ap_using_interrupts() ? 1 : 0);
+			 ap_irq_flag ? 1 : 0);
 }
 
 static BUS_ATTR_RO(ap_interrupts);
@@ -1832,7 +1823,7 @@ static int __init ap_module_init(void)
 	/* enable interrupts if available */
 	if (ap_interrupts_available()) {
 		rc = register_adapter_interrupt(&ap_airq);
-		ap_airq_flag = (rc == 0);
+		ap_irq_flag = (rc == 0);
 	}
 
 	/* Create /sys/bus/ap. */
@@ -1876,7 +1867,7 @@ static int __init ap_module_init(void)
 out_bus:
 	bus_unregister(&ap_bus_type);
 out:
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		unregister_adapter_interrupt(&ap_airq);
 	kfree(ap_qci_info);
 	return rc;
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 472efd3a755c..2940bc8aa43d 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -77,12 +77,6 @@ static inline int ap_test_bit(unsigned int *ptr, unsigned int nr)
 #define AP_FUNC_EP11  5
 #define AP_FUNC_APXA  6
 
-/*
- * AP interrupt states
- */
-#define AP_INTR_DISABLED	0	/* AP interrupt disabled */
-#define AP_INTR_ENABLED		1	/* AP interrupt enabled */
-
 /*
  * AP queue state machine states
  */
@@ -109,7 +103,7 @@ enum ap_sm_event {
  * AP queue state wait behaviour
  */
 enum ap_sm_wait {
-	AP_SM_WAIT_AGAIN,	/* retry immediately */
+	AP_SM_WAIT_AGAIN = 0,	/* retry immediately */
 	AP_SM_WAIT_TIMEOUT,	/* wait for timeout */
 	AP_SM_WAIT_INTERRUPT,	/* wait for thin interrupt (if available) */
 	AP_SM_WAIT_NONE,	/* no wait */
@@ -182,7 +176,7 @@ struct ap_queue {
 	enum ap_dev_state dev_state;	/* queue device state */
 	bool config;			/* configured state */
 	ap_qid_t qid;			/* AP queue id. */
-	int interrupt;			/* indicate if interrupts are enabled */
+	bool interrupt;			/* indicate if interrupts are enabled */
 	int queue_count;		/* # messages currently on AP queue. */
 	int pendingq_count;		/* # requests on pendingq list. */
 	int requestq_count;		/* # requests on requestq list. */
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 337353c9655e..639f8d25679c 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -19,7 +19,7 @@
 static void __ap_flush_queue(struct ap_queue *aq);
 
 /**
- * ap_queue_enable_interruption(): Enable interruption on an AP queue.
+ * ap_queue_enable_irq(): Enable interrupt support on this AP queue.
  * @qid: The AP queue number
  * @ind: the notification indicator byte
  *
@@ -27,7 +27,7 @@ static void __ap_flush_queue(struct ap_queue *aq);
  * value it waits a while and tests the AP queue if interrupts
  * have been switched on using ap_test_queue().
  */
-static int ap_queue_enable_interruption(struct ap_queue *aq, void *ind)
+static int ap_queue_enable_irq(struct ap_queue *aq, void *ind)
 {
 	struct ap_queue_status status;
 	struct ap_qirq_ctrl qirqctrl = { 0 };
@@ -198,7 +198,8 @@ static enum ap_sm_wait ap_sm_read(struct ap_queue *aq)
 		return AP_SM_WAIT_NONE;
 	case AP_RESPONSE_NO_PENDING_REPLY:
 		if (aq->queue_count > 0)
-			return AP_SM_WAIT_INTERRUPT;
+			return aq->interrupt ?
+				AP_SM_WAIT_INTERRUPT : AP_SM_WAIT_TIMEOUT;
 		aq->sm_state = AP_SM_STATE_IDLE;
 		return AP_SM_WAIT_NONE;
 	default:
@@ -252,7 +253,8 @@ static enum ap_sm_wait ap_sm_write(struct ap_queue *aq)
 		fallthrough;
 	case AP_RESPONSE_Q_FULL:
 		aq->sm_state = AP_SM_STATE_QUEUE_FULL;
-		return AP_SM_WAIT_INTERRUPT;
+		return aq->interrupt ?
+			AP_SM_WAIT_INTERRUPT : AP_SM_WAIT_TIMEOUT;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
 		return AP_SM_WAIT_TIMEOUT;
@@ -302,7 +304,7 @@ static enum ap_sm_wait ap_sm_reset(struct ap_queue *aq)
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
-		aq->interrupt = AP_INTR_DISABLED;
+		aq->interrupt = false;
 		return AP_SM_WAIT_TIMEOUT;
 	default:
 		aq->dev_state = AP_DEV_STATE_ERROR;
@@ -335,7 +337,7 @@ static enum ap_sm_wait ap_sm_reset_wait(struct ap_queue *aq)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		lsi_ptr = ap_airq_ptr();
-		if (lsi_ptr && ap_queue_enable_interruption(aq, lsi_ptr) == 0)
+		if (lsi_ptr && ap_queue_enable_irq(aq, lsi_ptr) == 0)
 			aq->sm_state = AP_SM_STATE_SETIRQ_WAIT;
 		else
 			aq->sm_state = (aq->queue_count > 0) ?
@@ -376,7 +378,7 @@ static enum ap_sm_wait ap_sm_setirq_wait(struct ap_queue *aq)
 
 	if (status.irq_enabled == 1) {
 		/* Irqs are now enabled */
-		aq->interrupt = AP_INTR_ENABLED;
+		aq->interrupt = true;
 		aq->sm_state = (aq->queue_count > 0) ?
 			AP_SM_STATE_WORKING : AP_SM_STATE_IDLE;
 	}
@@ -566,7 +568,7 @@ static ssize_t interrupt_show(struct device *dev,
 	spin_lock_bh(&aq->lock);
 	if (aq->sm_state == AP_SM_STATE_SETIRQ_WAIT)
 		rc = scnprintf(buf, PAGE_SIZE, "Enable Interrupt pending.\n");
-	else if (aq->interrupt == AP_INTR_ENABLED)
+	else if (aq->interrupt)
 		rc = scnprintf(buf, PAGE_SIZE, "Interrupts enabled.\n");
 	else
 		rc = scnprintf(buf, PAGE_SIZE, "Interrupts disabled.\n");
@@ -747,7 +749,7 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type)
 	aq->ap_dev.device.type = &ap_queue_type;
 	aq->ap_dev.device_type = device_type;
 	aq->qid = qid;
-	aq->interrupt = AP_INTR_DISABLED;
+	aq->interrupt = false;
 	spin_lock_init(&aq->lock);
 	INIT_LIST_HEAD(&aq->pendingq);
 	INIT_LIST_HEAD(&aq->requestq);
diff --git a/drivers/s390/crypto/zcrypt_ccamisc.c b/drivers/s390/crypto/zcrypt_ccamisc.c
index d68c0ed5e0dd..f5d0212fb4fe 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1724,10 +1724,10 @@ static int fetch_cca_info(u16 cardnr, u16 domain, struct cca_info *ci)
 	rlen = vlen = PAGE_SIZE/2;
 	rc = cca_query_crypto_facility(cardnr, domain, "STATICSB",
 				       rarray, &rlen, varray, &vlen);
-	if (rc == 0 && rlen >= 10*8 && vlen >= 240) {
-		ci->new_apka_mk_state = (char) rarray[7*8];
-		ci->cur_apka_mk_state = (char) rarray[8*8];
-		ci->old_apka_mk_state = (char) rarray[9*8];
+	if (rc == 0 && rlen >= 13*8 && vlen >= 240) {
+		ci->new_apka_mk_state = (char) rarray[10*8];
+		ci->cur_apka_mk_state = (char) rarray[11*8];
+		ci->old_apka_mk_state = (char) rarray[12*8];
 		if (ci->old_apka_mk_state == '2')
 			memcpy(&ci->old_apka_mkvp, varray + 208, 8);
 		if (ci->cur_apka_mk_state == '2')
diff --git a/drivers/soc/mediatek/mt8183-mmsys.h b/drivers/soc/mediatek/mt8183-mmsys.h
index 579dfc8dc8fc..9dee485807c9 100644
--- a/drivers/soc/mediatek/mt8183-mmsys.h
+++ b/drivers/soc/mediatek/mt8183-mmsys.h
@@ -28,25 +28,32 @@
 static const struct mtk_mmsys_routes mmsys_mt8183_routing_table[] = {
 	{
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_OVL_2L0,
-		MT8183_DISP_OVL0_MOUT_EN, MT8183_OVL0_MOUT_EN_OVL0_2L
+		MT8183_DISP_OVL0_MOUT_EN, MT8183_OVL0_MOUT_EN_OVL0_2L,
+		MT8183_OVL0_MOUT_EN_OVL0_2L
 	}, {
 		DDP_COMPONENT_OVL_2L0, DDP_COMPONENT_RDMA0,
-		MT8183_DISP_OVL0_2L_MOUT_EN, MT8183_OVL0_2L_MOUT_EN_DISP_PATH0
+		MT8183_DISP_OVL0_2L_MOUT_EN, MT8183_OVL0_2L_MOUT_EN_DISP_PATH0,
+		MT8183_OVL0_2L_MOUT_EN_DISP_PATH0
 	}, {
 		DDP_COMPONENT_OVL_2L1, DDP_COMPONENT_RDMA1,
-		MT8183_DISP_OVL1_2L_MOUT_EN, MT8183_OVL1_2L_MOUT_EN_RDMA1
+		MT8183_DISP_OVL1_2L_MOUT_EN, MT8183_OVL1_2L_MOUT_EN_RDMA1,
+		MT8183_OVL1_2L_MOUT_EN_RDMA1
 	}, {
 		DDP_COMPONENT_DITHER, DDP_COMPONENT_DSI0,
-		MT8183_DISP_DITHER0_MOUT_EN, MT8183_DITHER0_MOUT_IN_DSI0
+		MT8183_DISP_DITHER0_MOUT_EN, MT8183_DITHER0_MOUT_IN_DSI0,
+		MT8183_DITHER0_MOUT_IN_DSI0
 	}, {
 		DDP_COMPONENT_OVL_2L0, DDP_COMPONENT_RDMA0,
-		MT8183_DISP_PATH0_SEL_IN, MT8183_DISP_PATH0_SEL_IN_OVL0_2L
+		MT8183_DISP_PATH0_SEL_IN, MT8183_DISP_PATH0_SEL_IN_OVL0_2L,
+		MT8183_DISP_PATH0_SEL_IN_OVL0_2L
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
-		MT8183_DISP_DPI0_SEL_IN, MT8183_DPI0_SEL_IN_RDMA1
+		MT8183_DISP_DPI0_SEL_IN, MT8183_DPI0_SEL_IN_RDMA1,
+		MT8183_DPI0_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_COLOR0,
-		MT8183_DISP_RDMA0_SOUT_SEL_IN, MT8183_RDMA0_SOUT_COLOR0
+		MT8183_DISP_RDMA0_SOUT_SEL_IN, MT8183_RDMA0_SOUT_COLOR0,
+		MT8183_RDMA0_SOUT_COLOR0
 	}
 };
 
diff --git a/drivers/soc/mediatek/mtk-mmsys.c b/drivers/soc/mediatek/mtk-mmsys.c
index 080660ef11bf..0f949896fd06 100644
--- a/drivers/soc/mediatek/mtk-mmsys.c
+++ b/drivers/soc/mediatek/mtk-mmsys.c
@@ -68,7 +68,9 @@ void mtk_mmsys_ddp_connect(struct device *dev,
 
 	for (i = 0; i < mmsys->data->num_routes; i++)
 		if (cur == routes[i].from_comp && next == routes[i].to_comp) {
-			reg = readl_relaxed(mmsys->regs + routes[i].addr) | routes[i].val;
+			reg = readl_relaxed(mmsys->regs + routes[i].addr);
+			reg &= ~routes[i].mask;
+			reg |= routes[i].val;
 			writel_relaxed(reg, mmsys->regs + routes[i].addr);
 		}
 }
@@ -85,7 +87,8 @@ void mtk_mmsys_ddp_disconnect(struct device *dev,
 
 	for (i = 0; i < mmsys->data->num_routes; i++)
 		if (cur == routes[i].from_comp && next == routes[i].to_comp) {
-			reg = readl_relaxed(mmsys->regs + routes[i].addr) & ~routes[i].val;
+			reg = readl_relaxed(mmsys->regs + routes[i].addr);
+			reg &= ~routes[i].mask;
 			writel_relaxed(reg, mmsys->regs + routes[i].addr);
 		}
 }
diff --git a/drivers/soc/mediatek/mtk-mmsys.h b/drivers/soc/mediatek/mtk-mmsys.h
index a760a34e6eca..5f3e2bf0c40b 100644
--- a/drivers/soc/mediatek/mtk-mmsys.h
+++ b/drivers/soc/mediatek/mtk-mmsys.h
@@ -35,41 +35,54 @@
 #define RDMA0_SOUT_DSI1				0x1
 #define RDMA0_SOUT_DSI2				0x4
 #define RDMA0_SOUT_DSI3				0x5
+#define RDMA0_SOUT_MASK				0x7
 #define RDMA1_SOUT_DPI0				0x2
 #define RDMA1_SOUT_DPI1				0x3
 #define RDMA1_SOUT_DSI1				0x1
 #define RDMA1_SOUT_DSI2				0x4
 #define RDMA1_SOUT_DSI3				0x5
+#define RDMA1_SOUT_MASK				0x7
 #define RDMA2_SOUT_DPI0				0x2
 #define RDMA2_SOUT_DPI1				0x3
 #define RDMA2_SOUT_DSI1				0x1
 #define RDMA2_SOUT_DSI2				0x4
 #define RDMA2_SOUT_DSI3				0x5
+#define RDMA2_SOUT_MASK				0x7
 #define DPI0_SEL_IN_RDMA1			0x1
 #define DPI0_SEL_IN_RDMA2			0x3
+#define DPI0_SEL_IN_MASK			0x3
 #define DPI1_SEL_IN_RDMA1			(0x1 << 8)
 #define DPI1_SEL_IN_RDMA2			(0x3 << 8)
+#define DPI1_SEL_IN_MASK			(0x3 << 8)
 #define DSI0_SEL_IN_RDMA1			0x1
 #define DSI0_SEL_IN_RDMA2			0x4
+#define DSI0_SEL_IN_MASK			0x7
 #define DSI1_SEL_IN_RDMA1			0x1
 #define DSI1_SEL_IN_RDMA2			0x4
+#define DSI1_SEL_IN_MASK			0x7
 #define DSI2_SEL_IN_RDMA1			(0x1 << 16)
 #define DSI2_SEL_IN_RDMA2			(0x4 << 16)
+#define DSI2_SEL_IN_MASK			(0x7 << 16)
 #define DSI3_SEL_IN_RDMA1			(0x1 << 16)
 #define DSI3_SEL_IN_RDMA2			(0x4 << 16)
+#define DSI3_SEL_IN_MASK			(0x7 << 16)
 #define COLOR1_SEL_IN_OVL1			0x1
 
 #define OVL_MOUT_EN_RDMA			0x1
 #define BLS_TO_DSI_RDMA1_TO_DPI1		0x8
 #define BLS_TO_DPI_RDMA1_TO_DSI			0x2
+#define BLS_RDMA1_DSI_DPI_MASK			0xf
 #define DSI_SEL_IN_BLS				0x0
 #define DPI_SEL_IN_BLS				0x0
+#define DPI_SEL_IN_MASK				0x1
 #define DSI_SEL_IN_RDMA				0x1
+#define DSI_SEL_IN_MASK				0x1
 
 struct mtk_mmsys_routes {
 	u32 from_comp;
 	u32 to_comp;
 	u32 addr;
+	u32 mask;
 	u32 val;
 };
 
@@ -91,124 +104,164 @@ struct mtk_mmsys_driver_data {
 static const struct mtk_mmsys_routes mmsys_default_routing_table[] = {
 	{
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_OUT_SEL, BLS_TO_DSI_RDMA1_TO_DPI1
+		DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
+		BLS_TO_DSI_RDMA1_TO_DPI1
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_BLS
+		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
+		DSI_SEL_IN_BLS
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_OUT_SEL, BLS_TO_DPI_RDMA1_TO_DSI
+		DISP_REG_CONFIG_OUT_SEL, BLS_RDMA1_DSI_DPI_MASK,
+		BLS_TO_DPI_RDMA1_TO_DSI
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_RDMA
+		DISP_REG_CONFIG_DSI_SEL, DSI_SEL_IN_MASK,
+		DSI_SEL_IN_RDMA
 	}, {
 		DDP_COMPONENT_BLS, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_BLS
+		DISP_REG_CONFIG_DPI_SEL, DPI_SEL_IN_MASK,
+		DPI_SEL_IN_BLS
 	}, {
 		DDP_COMPONENT_GAMMA, DDP_COMPONENT_RDMA1,
-		DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1
+		DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN, GAMMA_MOUT_EN_RDMA1,
+		GAMMA_MOUT_EN_RDMA1
 	}, {
 		DDP_COMPONENT_OD0, DDP_COMPONENT_RDMA0,
-		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0
+		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD_MOUT_EN_RDMA0,
+		OD_MOUT_EN_RDMA0
 	}, {
 		DDP_COMPONENT_OD1, DDP_COMPONENT_RDMA1,
-		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1
+		DISP_REG_CONFIG_DISP_OD_MOUT_EN, OD1_MOUT_EN_RDMA1,
+		OD1_MOUT_EN_RDMA1
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
-		DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0
+		DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0,
+		OVL0_MOUT_EN_COLOR0
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
-		DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0
+		DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0,
+		COLOR0_SEL_IN_OVL0
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_RDMA0,
-		DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA
+		DISP_REG_CONFIG_DISP_OVL_MOUT_EN, OVL_MOUT_EN_RDMA,
+		OVL_MOUT_EN_RDMA
 	}, {
 		DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
-		DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1
+		DISP_REG_CONFIG_DISP_OVL1_MOUT_EN, OVL1_MOUT_EN_COLOR1,
+		OVL1_MOUT_EN_COLOR1
 	}, {
 		DDP_COMPONENT_OVL1, DDP_COMPONENT_COLOR1,
-		DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1
+		DISP_REG_CONFIG_DISP_COLOR1_SEL_IN, COLOR1_SEL_IN_OVL1,
+		COLOR1_SEL_IN_OVL1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA0_SOUT_EN, RDMA0_SOUT_MASK,
+		RDMA0_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
+		DPI0_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
+		DPI1_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
+		DSI0_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
+		DSI1_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
+		DSI2_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA1_SOUT_EN, RDMA1_SOUT_MASK,
+		RDMA1_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA1
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
+		DSI3_SEL_IN_RDMA1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI0
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DPI0
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI0,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI0_SEL_IN_MASK,
+		DPI0_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DPI1
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DPI1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DPI1,
-		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DPI_SEL_IN, DPI1_SEL_IN_MASK,
+		DPI1_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI0,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI0_SEL_IN_MASK,
+		DSI0_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI1
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI1
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI1,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI1_SEL_IN_MASK,
+		DSI1_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI2
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI2,
-		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIE_SEL_IN, DSI2_SEL_IN_MASK,
+		DSI2_SEL_IN_RDMA2
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_DSI3
+		DISP_REG_CONFIG_DISP_RDMA2_SOUT, RDMA2_SOUT_MASK,
+		RDMA2_SOUT_DSI3
 	}, {
 		DDP_COMPONENT_RDMA2, DDP_COMPONENT_DSI3,
-		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_RDMA2
+		DISP_REG_CONFIG_DSIO_SEL_IN, DSI3_SEL_IN_MASK,
+		DSI3_SEL_IN_RDMA2
 	}
 };
 
diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index bb21c4f1c0c4..90d2e5817371 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -382,12 +382,11 @@ static int rpmhpd_power_on(struct generic_pm_domain *domain)
 static int rpmhpd_power_off(struct generic_pm_domain *domain)
 {
 	struct rpmhpd *pd = domain_to_rpmhpd(domain);
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&rpmhpd_lock);
 
-	ret = rpmhpd_aggregate_corner(pd, pd->level[0]);
-
+	ret = rpmhpd_aggregate_corner(pd, 0);
 	if (!ret)
 		pd->enabled = false;
 
diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 1d3d5e3ec2b0..6e9a9cd28b17 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -109,7 +109,7 @@ struct smsm_entry {
 	DECLARE_BITMAP(irq_enabled, 32);
 	DECLARE_BITMAP(irq_rising, 32);
 	DECLARE_BITMAP(irq_falling, 32);
-	u32 last_value;
+	unsigned long last_value;
 
 	u32 *remote_state;
 	u32 *subscription;
@@ -204,8 +204,7 @@ static irqreturn_t smsm_intr(int irq, void *data)
 	u32 val;
 
 	val = readl(entry->remote_state);
-	changed = val ^ entry->last_value;
-	entry->last_value = val;
+	changed = val ^ xchg(&entry->last_value, val);
 
 	for_each_set_bit(i, entry->irq_enabled, 32) {
 		if (!(changed & BIT(i)))
@@ -264,6 +263,12 @@ static void smsm_unmask_irq(struct irq_data *irqd)
 	struct qcom_smsm *smsm = entry->smsm;
 	u32 val;
 
+	/* Make sure our last cached state is up-to-date */
+	if (readl(entry->remote_state) & BIT(irq))
+		set_bit(irq, &entry->last_value);
+	else
+		clear_bit(irq, &entry->last_value);
+
 	set_bit(irq, entry->irq_enabled);
 
 	if (entry->subscription) {
diff --git a/drivers/soc/rockchip/Kconfig b/drivers/soc/rockchip/Kconfig
index 2c13bf4dd5db..25eb2c1e31bb 100644
--- a/drivers/soc/rockchip/Kconfig
+++ b/drivers/soc/rockchip/Kconfig
@@ -6,8 +6,8 @@ if ARCH_ROCKCHIP || COMPILE_TEST
 #
 
 config ROCKCHIP_GRF
-	bool
-	default y
+	bool "Rockchip General Register Files support" if COMPILE_TEST
+	default y if ARCH_ROCKCHIP
 	help
 	  The General Register Files are a central component providing
 	  special additional settings registers for a lot of soc-components.
diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index 8996115ce736..263ce9047327 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -444,7 +444,7 @@ static int mcfqspi_remove(struct platform_device *pdev)
 	mcfqspi_wr_qmr(mcfqspi, MCFQSPI_QMR_MSTR);
 
 	mcfqspi_cs_teardown(mcfqspi);
-	clk_disable(mcfqspi->clk);
+	clk_disable_unprepare(mcfqspi->clk);
 
 	return 0;
 }
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index e114e6fe5ea5..d112c2cac042 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -213,12 +213,6 @@ static void davinci_spi_chipselect(struct spi_device *spi, int value)
 	 * line for the controller
 	 */
 	if (spi->cs_gpiod) {
-		/*
-		 * FIXME: is this code ever executed? This host does not
-		 * set SPI_MASTER_GPIO_SS so this chipselect callback should
-		 * not get called from the SPI core when we are using
-		 * GPIOs for chip select.
-		 */
 		if (value == BITBANG_CS_ACTIVE)
 			gpiod_set_value(spi->cs_gpiod, 1);
 		else
@@ -945,7 +939,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = pdata->num_chipselect;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(2, 16);
-	master->flags = SPI_MASTER_MUST_RX;
+	master->flags = SPI_MASTER_MUST_RX | SPI_MASTER_GPIO_SS;
 	master->setup = davinci_spi_setup;
 	master->cleanup = davinci_spi_cleanup;
 	master->can_dma = davinci_spi_can_dma;
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index fb45e6af6638..fd004c9db9dc 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -530,6 +530,7 @@ static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 		goto err_rx_dma_buf;
 	}
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = phy_addr + SPI_POPR;
 	cfg.dst_addr = phy_addr + SPI_PUSHR;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
diff --git a/drivers/spi/spi-pic32.c b/drivers/spi/spi-pic32.c
index 104bde153efd..5eb7b61bbb4d 100644
--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -361,6 +361,7 @@ static int pic32_spi_dma_config(struct pic32_spi *pic32s, u32 dma_width)
 	struct dma_slave_config cfg;
 	int ret;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.device_fc = true;
 	cfg.src_addr = pic32s->dma_base + buf_offset;
 	cfg.dst_addr = pic32s->dma_base + buf_offset;
diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index ab19068be867..98ef17389952 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -103,7 +103,7 @@
 #define HWRST_STATUS_WATCHDOG		0xf0
 
 /* Use default timeout 50 ms that converts to watchdog values */
-#define WDG_LOAD_VAL			((50 * 1000) / 32768)
+#define WDG_LOAD_VAL			((50 * 32768) / 1000)
 #define WDG_LOAD_MASK			GENMASK(15, 0)
 #define WDG_UNLOCK_KEY			0xe551
 
diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 9262c6418463..cfa222c9bd5e 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -545,7 +545,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
@@ -563,7 +563,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
@@ -579,7 +579,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 
@@ -603,7 +603,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
diff --git a/drivers/staging/clocking-wizard/Kconfig b/drivers/staging/clocking-wizard/Kconfig
index 69cf51445f08..2324b5d73788 100644
--- a/drivers/staging/clocking-wizard/Kconfig
+++ b/drivers/staging/clocking-wizard/Kconfig
@@ -5,6 +5,6 @@
 
 config COMMON_CLK_XLNX_CLKWZRD
 	tristate "Xilinx Clocking Wizard"
-	depends on COMMON_CLK && OF && IOMEM
+	depends on COMMON_CLK && OF && HAS_IOMEM
 	help
 	  Support for the Xilinx Clocking Wizard IP core clock generator.
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index f5de81132177..77293579a134 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -1533,16 +1533,19 @@ static struct v4l2_ctrl_config mt9m114_controls[] = {
 static int mt9m114_detect(struct mt9m114_device *dev, struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	u32 retvalue;
+	u32 model;
+	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		dev_err(&client->dev, "%s: i2c error", __func__);
 		return -ENODEV;
 	}
-	mt9m114_read_reg(client, MISENSOR_16BIT, (u32)MT9M114_PID, &retvalue);
-	dev->real_model_id = retvalue;
+	ret = mt9m114_read_reg(client, MISENSOR_16BIT, MT9M114_PID, &model);
+	if (ret)
+		return ret;
+	dev->real_model_id = model;
 
-	if (retvalue != MT9M114_MOD_ID) {
+	if (model != MT9M114_MOD_ID) {
 		dev_err(&client->dev, "%s: failed: client->addr = %x\n",
 			__func__, client->addr);
 		return -ENODEV;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 0d7ea144a4a6..1ed4e33cc8cf 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2595,7 +2595,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	sport->devtype = sdata->devtype;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 5b5e99604989..87e3f20e120b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2294,8 +2294,6 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2311,8 +2309,10 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld)
 		return -EIO;
+	tty_buffer_lock_exclusive(tty->port);
 	if (ld->ops->receive_buf)
 		ld->ops->receive_buf(tty, &ch, &mbz, 1);
+	tty_buffer_unlock_exclusive(tty->port);
 	tty_ldisc_deref(ld);
 	return 0;
 }
diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index ffe301d6ea35..d0f9b7c296b0 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -598,6 +598,8 @@ static int dwc3_meson_g12a_otg_init(struct platform_device *pdev,
 				   USB_R5_ID_DIG_IRQ, 0);
 
 		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						dwc3_meson_g12a_irq_thread,
 						IRQF_ONESHOT, pdev->name, priv);
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 49e6ca94486d..cfbb96f6627e 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -614,6 +614,10 @@ static int dwc3_qcom_acpi_register_core(struct platform_device *pdev)
 		qcom->acpi_pdata->dwc3_core_base_size;
 
 	irq = platform_get_irq(pdev_irq, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto out;
+	}
 	child_res[1].flags = IORESOURCE_IRQ;
 	child_res[1].start = child_res[1].end = irq;
 
diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index eede5cedacb4..d9ad9adf7348 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1876,7 +1876,9 @@ static int at91udc_probe(struct platform_device *pdev)
 	clk_disable(udc->iclk);
 
 	/* request UDC and maybe VBUS irqs */
-	udc->udp_irq = platform_get_irq(pdev, 0);
+	udc->udp_irq = retval = platform_get_irq(pdev, 0);
+	if (retval < 0)
+		goto err_unprepare_iclk;
 	retval = devm_request_irq(dev, udc->udp_irq, at91_udc_irq, 0,
 				  driver_name, udc);
 	if (retval) {
diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 0bef6b3f049b..fa1a3908ec3b 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -488,27 +488,14 @@ static int bdc_probe(struct platform_device *pdev)
 	int irq;
 	u32 temp;
 	struct device *dev = &pdev->dev;
-	struct clk *clk;
 	int phy_num;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	clk = devm_clk_get_optional(dev, "sw_usbd");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	ret = clk_prepare_enable(clk);
-	if (ret) {
-		dev_err(dev, "could not enable clock\n");
-		return ret;
-	}
-
 	bdc = devm_kzalloc(dev, sizeof(*bdc), GFP_KERNEL);
 	if (!bdc)
 		return -ENOMEM;
 
-	bdc->clk = clk;
-
 	bdc->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdc->regs))
 		return PTR_ERR(bdc->regs);
@@ -545,10 +532,20 @@ static int bdc_probe(struct platform_device *pdev)
 		}
 	}
 
+	bdc->clk = devm_clk_get_optional(dev, "sw_usbd");
+	if (IS_ERR(bdc->clk))
+		return PTR_ERR(bdc->clk);
+
+	ret = clk_prepare_enable(bdc->clk);
+	if (ret) {
+		dev_err(dev, "could not enable clock\n");
+		return ret;
+	}
+
 	ret = bdc_phy_init(bdc);
 	if (ret) {
 		dev_err(bdc->dev, "BDC phy init failure:%d\n", ret);
-		return ret;
+		goto disable_clk;
 	}
 
 	temp = bdc_readl(bdc->regs, BDC_BDCCAP1);
@@ -560,7 +557,8 @@ static int bdc_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(dev,
 				"No suitable DMA config available, abort\n");
-			return -ENOTSUPP;
+			ret = -ENOTSUPP;
+			goto phycleanup;
 		}
 		dev_dbg(dev, "Using 32-bit address\n");
 	}
@@ -580,6 +578,8 @@ static int bdc_probe(struct platform_device *pdev)
 	bdc_hw_exit(bdc);
 phycleanup:
 	bdc_phy_exit(bdc);
+disable_clk:
+	clk_disable_unprepare(bdc->clk);
 	return ret;
 }
 
diff --git a/drivers/usb/gadget/udc/mv_u3d_core.c b/drivers/usb/gadget/udc/mv_u3d_core.c
index 5486f5a70868..0db97fecf99e 100644
--- a/drivers/usb/gadget/udc/mv_u3d_core.c
+++ b/drivers/usb/gadget/udc/mv_u3d_core.c
@@ -1921,14 +1921,6 @@ static int mv_u3d_probe(struct platform_device *dev)
 		goto err_get_irq;
 	}
 	u3d->irq = r->start;
-	if (request_irq(u3d->irq, mv_u3d_irq,
-		IRQF_SHARED, driver_name, u3d)) {
-		u3d->irq = 0;
-		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
-			u3d->irq);
-		retval = -ENODEV;
-		goto err_request_irq;
-	}
 
 	/* initialize gadget structure */
 	u3d->gadget.ops = &mv_u3d_ops;	/* usb_gadget_ops */
@@ -1941,6 +1933,15 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 	mv_u3d_eps_init(u3d);
 
+	if (request_irq(u3d->irq, mv_u3d_irq,
+		IRQF_SHARED, driver_name, u3d)) {
+		u3d->irq = 0;
+		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
+			u3d->irq);
+		retval = -ENODEV;
+		goto err_request_irq;
+	}
+
 	/* external vbus detection */
 	if (u3d->vbus) {
 		u3d->clock_gating = 1;
@@ -1964,8 +1965,8 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 err_unregister:
 	free_irq(u3d->irq, u3d);
-err_request_irq:
 err_get_irq:
+err_request_irq:
 	kfree(u3d->status_req);
 err_alloc_status_req:
 	kfree(u3d->eps);
diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index f1b35a39d1ba..57d417a7c3e0 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2707,10 +2707,15 @@ static const struct renesas_usb3_priv renesas_usb3_priv_r8a77990 = {
 
 static const struct of_device_id usb3_of_match[] = {
 	{
+		.compatible = "renesas,r8a774c0-usb3-peri",
+		.data = &renesas_usb3_priv_r8a77990,
+	}, {
 		.compatible = "renesas,r8a7795-usb3-peri",
 		.data = &renesas_usb3_priv_gen3,
-	},
-	{
+	}, {
+		.compatible = "renesas,r8a77990-usb3-peri",
+		.data = &renesas_usb3_priv_r8a77990,
+	}, {
 		.compatible = "renesas,rcar-gen3-usb3-peri",
 		.data = &renesas_usb3_priv_gen3,
 	},
@@ -2719,18 +2724,10 @@ static const struct of_device_id usb3_of_match[] = {
 MODULE_DEVICE_TABLE(of, usb3_of_match);
 
 static const struct soc_device_attribute renesas_usb3_quirks_match[] = {
-	{
-		.soc_id = "r8a774c0",
-		.data = &renesas_usb3_priv_r8a77990,
-	},
 	{
 		.soc_id = "r8a7795", .revision = "ES1.*",
 		.data = &renesas_usb3_priv_r8a7795_es1,
 	},
-	{
-		.soc_id = "r8a77990",
-		.data = &renesas_usb3_priv_r8a77990,
-	},
 	{ /* sentinel */ },
 };
 
diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index b154b62abefa..82c4f3fb2dae 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -1784,6 +1784,10 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	s3c2410_udc_reinit(udc);
 
 	irq_usbd = platform_get_irq(pdev, 0);
+	if (irq_usbd < 0) {
+		retval = irq_usbd;
+		goto err_udc_clk;
+	}
 
 	/* irq setup after old hardware state is cleaned up */
 	retval = request_irq(irq_usbd, s3c2410_udc_irq,
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index a319b1df3011..3626758b3e2a 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -264,8 +264,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 * the clock does not exists.
 	 */
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(priv->clk))
-		clk_prepare_enable(priv->clk);
+	if (!IS_ERR(priv->clk)) {
+		err = clk_prepare_enable(priv->clk);
+		if (err)
+			goto err_put_hcd;
+	}
 
 	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
 	if (IS_ERR(priv->phy)) {
@@ -311,6 +314,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 err_dis_clk:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+err_put_hcd:
 	usb_put_hcd(hcd);
 err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 7f857bad9e95..08ec2ab0d95a 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -202,6 +202,9 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (!cell)
 		return -EINVAL;
 
+	if (irq < 0)
+		return irq;
+
 	hcd = usb_create_hcd(&ohci_tmio_hc_driver, &dev->dev, dev_name(&dev->dev));
 	if (!hcd) {
 		ret = -ENOMEM;
diff --git a/drivers/usb/misc/brcmstb-usb-pinmap.c b/drivers/usb/misc/brcmstb-usb-pinmap.c
index 336653091e3b..2b2019c19cde 100644
--- a/drivers/usb/misc/brcmstb-usb-pinmap.c
+++ b/drivers/usb/misc/brcmstb-usb-pinmap.c
@@ -293,6 +293,8 @@ static int __init brcmstb_usb_pinmap_probe(struct platform_device *pdev)
 
 		/* Enable interrupt for out pins */
 		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
 		err = devm_request_irq(&pdev->dev, irq,
 				       brcmstb_usb_pinmap_ovr_isr,
 				       IRQF_TRIGGER_RISING,
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index f34c9437a182..972704262b02 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -873,6 +873,8 @@ int usb_otg_start(struct platform_device *pdev)
 
 	/* request irq */
 	p_otg->irq = platform_get_irq(pdev, 0);
+	if (p_otg->irq < 0)
+		return p_otg->irq;
 	status = request_irq(p_otg->irq, fsl_otg_isr,
 				IRQF_SHARED, driver_name, p_otg);
 	if (status) {
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index baebb1f5a973..a3e043e3e4aa 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -393,7 +393,9 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, tu);
 
-	tu->irq = platform_get_irq(pdev, 0);
+	tu->irq = ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
 	ret = request_threaded_irq(tu->irq, NULL, tahvo_usb_vbus_interrupt,
 				   IRQF_ONESHOT,
 				   "tahvo-vbus", tu);
diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 8ba6c5a91557..ab3c38a7d8ac 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -348,6 +348,11 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->linkstat		= MUSB_UNKNOWN;
 
+	if (twl->irq1 < 0)
+		return twl->irq1;
+	if (twl->irq2 < 0)
+		return twl->irq2;
+
 	twl->comparator.set_vbus	= twl6030_set_vbus;
 	twl->comparator.start_srp	= twl6030_start_srp;
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index e48fded3e414..8d8959a70e44 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -409,6 +409,33 @@ static bool pwm_backlight_is_linear(struct platform_pwm_backlight_data *data)
 static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 {
 	struct device_node *node = pb->dev->of_node;
+	bool active = true;
+
+	/*
+	 * If the enable GPIO is present, observable (either as input
+	 * or output) and off then the backlight is not currently active.
+	 * */
+	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
+		active = false;
+
+	if (!regulator_is_enabled(pb->power_supply))
+		active = false;
+
+	if (!pwm_is_enabled(pb->pwm))
+		active = false;
+
+	/*
+	 * Synchronize the enable_gpio with the observed state of the
+	 * hardware.
+	 */
+	if (pb->enable_gpio)
+		gpiod_direction_output(pb->enable_gpio, active);
+
+	/*
+	 * Do not change pb->enabled here! pb->enabled essentially
+	 * tells us if we own one of the regulator's use counts and
+	 * right now we do not.
+	 */
 
 	/* Not booted with device tree or no phandle link to the node */
 	if (!node || !node->phandle)
@@ -420,20 +447,7 @@ static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 	 * assume that another driver will enable the backlight at the
 	 * appropriate time. Therefore, if it is disabled, keep it so.
 	 */
-
-	/* if the enable GPIO is disabled, do not enable the backlight */
-	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
-		return FB_BLANK_POWERDOWN;
-
-	/* The regulator is disabled, do not enable the backlight */
-	if (!regulator_is_enabled(pb->power_supply))
-		return FB_BLANK_POWERDOWN;
-
-	/* The PWM is disabled, keep it like this */
-	if (!pwm_is_enabled(pb->pwm))
-		return FB_BLANK_POWERDOWN;
-
-	return FB_BLANK_UNBLANK;
+	return active ? FB_BLANK_UNBLANK: FB_BLANK_POWERDOWN;
 }
 
 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -486,18 +500,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	/*
-	 * If the GPIO is not known to be already configured as output, that
-	 * is, if gpiod_get_direction returns either 1 or -EINVAL, change the
-	 * direction to output and set the GPIO as active.
-	 * Do not force the GPIO to active when it was already output as it
-	 * could cause backlight flickering or we would enable the backlight too
-	 * early. Leave the decision of the initial backlight state for later.
-	 */
-	if (pb->enable_gpio &&
-	    gpiod_get_direction(pb->enable_gpio) != 0)
-		gpiod_direction_output(pb->enable_gpio, 1);
-
 	pb->power_supply = devm_regulator_get(&pdev->dev, "power");
 	if (IS_ERR(pb->power_supply)) {
 		ret = PTR_ERR(pb->power_supply);
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 1c855145711b..63e2f17f3c61 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -962,6 +962,7 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	struct fb_var_screeninfo old_var;
 	struct fb_videomode mode;
 	struct fb_event event;
+	u32 unused;
 
 	if (var->activate & FB_ACTIVATE_INV_MODE) {
 		struct fb_videomode mode1, mode2;
@@ -1008,6 +1009,11 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	if (var->xres < 8 || var->yres < 8)
 		return -EINVAL;
 
+	/* Too huge resolution causes multiplication overflow. */
+	if (check_mul_overflow(var->xres, var->yres, &unused) ||
+	    check_mul_overflow(var->xres_virtual, var->yres_virtual, &unused))
+		return -EINVAL;
+
 	ret = info->fbops->fb_check_var(var, info);
 
 	if (ret)
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9bd03a231032..171ad8b42107 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -358,14 +358,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
 		if (!dst)
 			return NULL;
 		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
-			       NO_MAP_UNI_RSVD);
+				NO_MAP_UNI_RSVD);
 	} else {
-		len = strnlen(src, maxlen);
-		len++;
-		dst = kmalloc(len, GFP_KERNEL);
-		if (!dst)
-			return NULL;
-		strlcpy(dst, src, len);
+		dst = kstrndup(src, maxlen, GFP_KERNEL);
 	}
 
 	return dst;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 72742eb1df4a..626bb7c55206 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1259,10 +1259,17 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			ctx->posix_paths = 1;
 		break;
 	case Opt_unix:
-		if (result.negated)
+		if (result.negated) {
+			if (ctx->linux_ext == 1)
+				pr_warn_once("conflicting posix mount options specified\n");
 			ctx->linux_ext = 0;
-		else
 			ctx->no_linux_ext = 1;
+		} else {
+			if (ctx->no_linux_ext == 1)
+				pr_warn_once("conflicting posix mount options specified\n");
+			ctx->linux_ext = 1;
+			ctx->no_linux_ext = 0;
+		}
 		break;
 	case Opt_nocase:
 		ctx->nocase = 1;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 63bfc533c9fb..6927b68fe852 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -381,7 +381,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
  */
 
 static int
-initiate_cifs_search(const unsigned int xid, struct file *file,
+_initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
 {
 	__u16 search_flags;
@@ -463,6 +463,27 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
 	return rc;
 }
 
+static int
+initiate_cifs_search(const unsigned int xid, struct file *file,
+		     const char *full_path)
+{
+	int rc, retry_count = 0;
+
+	do {
+		rc = _initiate_cifs_search(xid, file, full_path);
+		/*
+		 * If we don't have enough credits to start reading the
+		 * directory just try again after short wait.
+		 */
+		if (rc != -EDEADLK)
+			break;
+
+		usleep_range(512, 2048);
+	} while (retry_count++ < 5);
+
+	return rc;
+}
+
 /* return length of unicode string in bytes */
 static int cifs_unicode_bytelen(const char *str)
 {
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index ba7c01cd9a5d..36f2dbe6061f 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -179,8 +179,10 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 	if (!fops_get(real_fops)) {
 #ifdef CONFIG_MODULES
 		if (real_fops->owner &&
-		    real_fops->owner->state == MODULE_STATE_GOING)
+		    real_fops->owner->state == MODULE_STATE_GOING) {
+			r = -ENXIO;
 			goto out;
+		}
 #endif
 
 		/* Huh? Module did not clean up after itself at exit? */
@@ -314,8 +316,10 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 	if (!fops_get(real_fops)) {
 #ifdef CONFIG_MODULES
 		if (real_fops->owner &&
-		    real_fops->owner->state == MODULE_STATE_GOING)
+		    real_fops->owner->state == MODULE_STATE_GOING) {
+			r = -ENXIO;
 			goto out;
+		}
 #endif
 
 		/* Huh? Module did not cleanup after itself at exit? */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ceb575f99048..fb27d49e4da7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -263,8 +263,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 	};
 	unsigned int seq_id = 0;
 
-	if (unlikely(f2fs_readonly(inode->i_sb) ||
-				is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
+	if (unlikely(f2fs_readonly(inode->i_sb)))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
@@ -278,7 +277,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 	ret = file_write_and_wait_range(file, start, end);
 	clear_inode_flag(inode, FI_NEED_IPU);
 
-	if (ret) {
+	if (ret || is_sbi_flag_set(sbi, SBI_CP_DISABLED)) {
 		trace_f2fs_sync_file_exit(inode, cp_reason, datasync, ret);
 		return ret;
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b29de80ab60e..8553e8e5de0d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1923,8 +1923,17 @@ static int f2fs_disable_checkpoint(struct f2fs_sb_info *sbi)
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
+	int retry = DEFAULT_RETRY_IO_COUNT;
+
 	/* we should flush all the data to keep data consistency */
-	sync_inodes_sb(sbi->sb);
+	do {
+		sync_inodes_sb(sbi->sb);
+		cond_resched();
+		congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+	} while (get_pages(sbi, F2FS_DIRTY_DATA) && retry--);
+
+	if (unlikely(retry < 0))
+		f2fs_warn(sbi, "checkpoint=enable has some unwritten data.");
 
 	down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index dfc72f15be7f..887db4918a89 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -150,7 +150,8 @@ void f_delown(struct file *filp)
 pid_t f_getown(struct file *filp)
 {
 	pid_t pid = 0;
-	read_lock(&filp->f_owner.lock);
+
+	read_lock_irq(&filp->f_owner.lock);
 	rcu_read_lock();
 	if (pid_task(filp->f_owner.pid, filp->f_owner.pid_type)) {
 		pid = pid_vnr(filp->f_owner.pid);
@@ -158,7 +159,7 @@ pid_t f_getown(struct file *filp)
 			pid = -pid;
 	}
 	rcu_read_unlock();
-	read_unlock(&filp->f_owner.lock);
+	read_unlock_irq(&filp->f_owner.lock);
 	return pid;
 }
 
@@ -208,7 +209,7 @@ static int f_getown_ex(struct file *filp, unsigned long arg)
 	struct f_owner_ex owner = {};
 	int ret = 0;
 
-	read_lock(&filp->f_owner.lock);
+	read_lock_irq(&filp->f_owner.lock);
 	rcu_read_lock();
 	if (pid_task(filp->f_owner.pid, filp->f_owner.pid_type))
 		owner.pid = pid_vnr(filp->f_owner.pid);
@@ -231,7 +232,7 @@ static int f_getown_ex(struct file *filp, unsigned long arg)
 		ret = -EINVAL;
 		break;
 	}
-	read_unlock(&filp->f_owner.lock);
+	read_unlock_irq(&filp->f_owner.lock);
 
 	if (!ret) {
 		ret = copy_to_user(owner_p, &owner, sizeof(owner));
@@ -249,10 +250,10 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
 	uid_t src[2];
 	int err;
 
-	read_lock(&filp->f_owner.lock);
+	read_lock_irq(&filp->f_owner.lock);
 	src[0] = from_kuid(user_ns, filp->f_owner.uid);
 	src[1] = from_kuid(user_ns, filp->f_owner.euid);
-	read_unlock(&filp->f_owner.lock);
+	read_unlock_irq(&filp->f_owner.lock);
 
 	err  = put_user(src[0], &dst[0]);
 	err |= put_user(src[1], &dst[1]);
@@ -1003,13 +1004,14 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 {
 	while (fa) {
 		struct fown_struct *fown;
+		unsigned long flags;
 
 		if (fa->magic != FASYNC_MAGIC) {
 			printk(KERN_ERR "kill_fasync: bad magic number in "
 			       "fasync_struct!\n");
 			return;
 		}
-		read_lock(&fa->fa_lock);
+		read_lock_irqsave(&fa->fa_lock, flags);
 		if (fa->fa_file) {
 			fown = &fa->fa_file->f_owner;
 			/* Don't send SIGURG to processes which have not set a
@@ -1018,7 +1020,7 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 			if (!(sig == SIGURG && fown->signum == 0))
 				send_sigio(fown, fa->fa_fd, band);
 		}
-		read_unlock(&fa->fa_lock);
+		read_unlock_irqrestore(&fa->fa_lock, flags);
 		fa = rcu_dereference(fa->fa_next);
 	}
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 09ef2a4d25ed..f4e1a6387f90 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -198,12 +198,11 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
-	if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_STREAM)
 		stream_open(inode, file);
 	else if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+
 	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
@@ -211,10 +210,14 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, 0);
 		spin_unlock(&fi->lock);
+		truncate_pagecache(inode, 0);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache)
 			file_update_time(file);
+	} else if (!(ff->open_flags & FOPEN_KEEP_CACHE)) {
+		invalidate_inode_pages2(inode->i_mapping);
 	}
+
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
 }
@@ -389,6 +392,7 @@ struct fuse_writepage_args {
 	struct list_head queue_entry;
 	struct fuse_writepage_args *next;
 	struct inode *inode;
+	struct fuse_sync_bucket *bucket;
 };
 
 static struct fuse_writepage_args *fuse_find_writeback(struct fuse_inode *fi,
@@ -1610,6 +1614,9 @@ static void fuse_writepage_free(struct fuse_writepage_args *wpa)
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	int i;
 
+	if (wpa->bucket)
+		fuse_sync_bucket_dec(wpa->bucket);
+
 	for (i = 0; i < ap->num_pages; i++)
 		__free_page(ap->pages[i]);
 
@@ -1873,6 +1880,20 @@ static struct fuse_writepage_args *fuse_writepage_args_alloc(void)
 
 }
 
+static void fuse_writepage_add_to_bucket(struct fuse_conn *fc,
+					 struct fuse_writepage_args *wpa)
+{
+	if (!fc->sync_fs)
+		return;
+
+	rcu_read_lock();
+	/* Prevent resurrection of dead bucket in unlikely race with syncfs */
+	do {
+		wpa->bucket = rcu_dereference(fc->curr_bucket);
+	} while (unlikely(!atomic_inc_not_zero(&wpa->bucket->count)));
+	rcu_read_unlock();
+}
+
 static int fuse_writepage_locked(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -1900,6 +1921,7 @@ static int fuse_writepage_locked(struct page *page)
 	if (!wpa->ia.ff)
 		goto err_nofile;
 
+	fuse_writepage_add_to_bucket(fc, wpa);
 	fuse_write_args_fill(&wpa->ia, wpa->ia.ff, page_offset(page), 0);
 
 	copy_highpage(tmp_page, page);
@@ -2150,6 +2172,8 @@ static int fuse_writepages_fill(struct page *page,
 			__free_page(tmp_page);
 			goto out_unlock;
 		}
+		fuse_writepage_add_to_bucket(fc, wpa);
+
 		data->max_pages = 1;
 
 		ap = &wpa->ia.ap;
@@ -2883,7 +2907,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static int fuse_writeback_range(struct inode *inode, loff_t start, loff_t end)
 {
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, -1);
 
 	if (!err)
 		fuse_sync_writes(inode);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 120f9c5908d1..e840c4a5f9f5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -515,6 +515,13 @@ struct fuse_fs_context {
 	void **fudptr;
 };
 
+struct fuse_sync_bucket {
+	/* count is a possible scalability bottleneck */
+	atomic_t count;
+	wait_queue_head_t waitq;
+	struct rcu_head rcu;
+};
+
 /**
  * A Fuse connection.
  *
@@ -807,6 +814,9 @@ struct fuse_conn {
 
 	/** List of filesystems using this connection */
 	struct list_head mounts;
+
+	/* New writepages go into this bucket */
+	struct fuse_sync_bucket __rcu *curr_bucket;
 };
 
 /*
@@ -910,6 +920,15 @@ static inline void fuse_page_descs_length_init(struct fuse_page_desc *descs,
 		descs[i].length = PAGE_SIZE - descs[i].offset;
 }
 
+static inline void fuse_sync_bucket_dec(struct fuse_sync_bucket *bucket)
+{
+	/* Need RCU protection to prevent use after free after the decrement */
+	rcu_read_lock();
+	if (atomic_dec_and_test(&bucket->count))
+		wake_up(&bucket->waitq);
+	rcu_read_unlock();
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index cf16d6d3a603..eda92e3d26b8 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -506,6 +506,57 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+static struct fuse_sync_bucket *fuse_sync_bucket_alloc(void)
+{
+	struct fuse_sync_bucket *bucket;
+
+	bucket = kzalloc(sizeof(*bucket), GFP_KERNEL | __GFP_NOFAIL);
+	if (bucket) {
+		init_waitqueue_head(&bucket->waitq);
+		/* Initial active count */
+		atomic_set(&bucket->count, 1);
+	}
+	return bucket;
+}
+
+static void fuse_sync_fs_writes(struct fuse_conn *fc)
+{
+	struct fuse_sync_bucket *bucket, *new_bucket;
+	int count;
+
+	new_bucket = fuse_sync_bucket_alloc();
+	spin_lock(&fc->lock);
+	bucket = rcu_dereference_protected(fc->curr_bucket, 1);
+	count = atomic_read(&bucket->count);
+	WARN_ON(count < 1);
+	/* No outstanding writes? */
+	if (count == 1) {
+		spin_unlock(&fc->lock);
+		kfree(new_bucket);
+		return;
+	}
+
+	/*
+	 * Completion of new bucket depends on completion of this bucket, so add
+	 * one more count.
+	 */
+	atomic_inc(&new_bucket->count);
+	rcu_assign_pointer(fc->curr_bucket, new_bucket);
+	spin_unlock(&fc->lock);
+	/*
+	 * Drop initial active count.  At this point if all writes in this and
+	 * ancestor buckets complete, the count will go to zero and this task
+	 * will be woken up.
+	 */
+	atomic_dec(&bucket->count);
+
+	wait_event(bucket->waitq, atomic_read(&bucket->count) == 0);
+
+	/* Drop temp count on descendant bucket */
+	fuse_sync_bucket_dec(new_bucket);
+	kfree_rcu(bucket, rcu);
+}
+
 static int fuse_sync_fs(struct super_block *sb, int wait)
 {
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
@@ -528,6 +579,8 @@ static int fuse_sync_fs(struct super_block *sb, int wait)
 	if (!fc->sync_fs)
 		return 0;
 
+	fuse_sync_fs_writes(fc);
+
 	memset(&inarg, 0, sizeof(inarg));
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
@@ -763,6 +816,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
 		struct fuse_iqueue *fiq = &fc->iq;
+		struct fuse_sync_bucket *bucket;
 
 		if (IS_ENABLED(CONFIG_FUSE_DAX))
 			fuse_dax_conn_free(fc);
@@ -770,6 +824,11 @@ void fuse_conn_put(struct fuse_conn *fc)
 			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
 		put_user_ns(fc->user_ns);
+		bucket = rcu_dereference_protected(fc->curr_bucket, 1);
+		if (bucket) {
+			WARN_ON(atomic_read(&bucket->count) != 1);
+			kfree(bucket);
+		}
 		fc->release(fc);
 	}
 }
@@ -1366,6 +1425,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	if (sb->s_flags & SB_MANDLOCK)
 		goto err;
 
+	rcu_assign_pointer(fc->curr_bucket, fuse_sync_bucket_alloc());
 	fuse_sb_defaults(sb);
 
 	if (ctx->is_bdev) {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5f4504dd0875..ca76e3b8792c 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -677,6 +677,7 @@ static int init_statfs(struct gfs2_sbd *sdp)
 			error = PTR_ERR(lsi->si_sc_inode);
 			fs_err(sdp, "can't find local \"sc\" file#%u: %d\n",
 			       jd->jd_jid, error);
+			kfree(lsi);
 			goto free_local;
 		}
 		lsi->si_jid = jd->jd_jid;
@@ -1088,6 +1089,34 @@ void gfs2_online_uevent(struct gfs2_sbd *sdp)
 	kobject_uevent_env(&sdp->sd_kobj, KOBJ_ONLINE, envp);
 }
 
+static int init_threads(struct gfs2_sbd *sdp)
+{
+	struct task_struct *p;
+	int error = 0;
+
+	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		fs_err(sdp, "can't start logd thread: %d\n", error);
+		return error;
+	}
+	sdp->sd_logd_process = p;
+
+	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		fs_err(sdp, "can't start quotad thread: %d\n", error);
+		goto fail;
+	}
+	sdp->sd_quotad_process = p;
+	return 0;
+
+fail:
+	kthread_stop(sdp->sd_logd_process);
+	sdp->sd_logd_process = NULL;
+	return error;
+}
+
 /**
  * gfs2_fill_super - Read in superblock
  * @sb: The VFS superblock
@@ -1216,6 +1245,14 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto fail_per_node;
 	}
 
+	if (!sb_rdonly(sb)) {
+		error = init_threads(sdp);
+		if (error) {
+			gfs2_withdraw_delayed(sdp);
+			goto fail_per_node;
+		}
+	}
+
 	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
 	if (error)
 		goto fail_per_node;
@@ -1225,6 +1262,12 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	gfs2_freeze_unlock(&freeze_gh);
 	if (error) {
+		if (sdp->sd_quotad_process)
+			kthread_stop(sdp->sd_quotad_process);
+		sdp->sd_quotad_process = NULL;
+		if (sdp->sd_logd_process)
+			kthread_stop(sdp->sd_logd_process);
+		sdp->sd_logd_process = NULL;
 		fs_err(sdp, "can't make FS RW: %d\n", error);
 		goto fail_per_node;
 	}
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4d4ceb0b6903..2bdbba5ea8d7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -119,34 +119,6 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 	return 0;
 }
 
-static int init_threads(struct gfs2_sbd *sdp)
-{
-	struct task_struct *p;
-	int error = 0;
-
-	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		fs_err(sdp, "can't start logd thread: %d\n", error);
-		return error;
-	}
-	sdp->sd_logd_process = p;
-
-	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		fs_err(sdp, "can't start quotad thread: %d\n", error);
-		goto fail;
-	}
-	sdp->sd_quotad_process = p;
-	return 0;
-
-fail:
-	kthread_stop(sdp->sd_logd_process);
-	sdp->sd_logd_process = NULL;
-	return error;
-}
-
 /**
  * gfs2_make_fs_rw - Turn a Read-Only FS into a Read-Write one
  * @sdp: the filesystem
@@ -161,26 +133,17 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	struct gfs2_log_header_host head;
 	int error;
 
-	error = init_threads(sdp);
-	if (error) {
-		gfs2_withdraw_delayed(sdp);
-		return error;
-	}
-
 	j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
-	if (gfs2_withdrawn(sdp)) {
-		error = -EIO;
-		goto fail;
-	}
+	if (gfs2_withdrawn(sdp))
+		return -EIO;
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
 	if (error || gfs2_withdrawn(sdp))
-		goto fail;
+		return error;
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
 		gfs2_consist(sdp);
-		error = -EIO;
-		goto fail;
+		return -EIO;
 	}
 
 	/*  Initialize some head of the log stuff  */
@@ -188,20 +151,8 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	gfs2_log_pointers_init(sdp, head.lh_blkno);
 
 	error = gfs2_quota_init(sdp);
-	if (error || gfs2_withdrawn(sdp))
-		goto fail;
-
-	set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
-
-	return 0;
-
-fail:
-	if (sdp->sd_quotad_process)
-		kthread_stop(sdp->sd_quotad_process);
-	sdp->sd_quotad_process = NULL;
-	if (sdp->sd_logd_process)
-		kthread_stop(sdp->sd_logd_process);
-	sdp->sd_logd_process = NULL;
+	if (!error && !gfs2_withdrawn(sdp))
+		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	return error;
 }
 
diff --git a/fs/io-wq.c b/fs/io-wq.c
index 91b0d1fb90eb..c7171d975896 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -53,6 +53,10 @@ struct io_worker {
 
 	struct completion ref_done;
 
+	unsigned long create_state;
+	struct callback_head create_work;
+	int create_index;
+
 	struct rcu_head rcu;
 };
 
@@ -273,24 +277,18 @@ static void io_wqe_inc_running(struct io_worker *worker)
 	atomic_inc(&acct->nr_running);
 }
 
-struct create_worker_data {
-	struct callback_head work;
-	struct io_wqe *wqe;
-	int index;
-};
-
 static void create_worker_cb(struct callback_head *cb)
 {
-	struct create_worker_data *cwd;
+	struct io_worker *worker;
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
 	bool do_create = false, first = false;
 
-	cwd = container_of(cb, struct create_worker_data, work);
-	wqe = cwd->wqe;
+	worker = container_of(cb, struct io_worker, create_work);
+	wqe = worker->wqe;
 	wq = wqe->wq;
-	acct = &wqe->acct[cwd->index];
+	acct = &wqe->acct[worker->create_index];
 	raw_spin_lock_irq(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
 		if (!acct->nr_workers)
@@ -300,33 +298,42 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock_irq(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, cwd->index, first);
+		create_io_worker(wq, wqe, worker->create_index, first);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
 	}
-	kfree(cwd);
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
 }
 
-static void io_queue_worker_create(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_queue_worker_create(struct io_wqe *wqe, struct io_worker *worker,
+				   struct io_wqe_acct *acct)
 {
-	struct create_worker_data *cwd;
 	struct io_wq *wq = wqe->wq;
 
 	/* raced with exit, just ignore create call */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		goto fail;
+	if (!io_worker_get(worker))
+		goto fail;
+	/*
+	 * create_state manages ownership of create_work/index. We should
+	 * only need one entry per worker, as the worker going to sleep
+	 * will trigger the condition, and waking will clear it once it
+	 * runs the task_work.
+	 */
+	if (test_bit(0, &worker->create_state) ||
+	    test_and_set_bit_lock(0, &worker->create_state))
+		goto fail_release;
 
-	cwd = kmalloc(sizeof(*cwd), GFP_ATOMIC);
-	if (cwd) {
-		init_task_work(&cwd->work, create_worker_cb);
-		cwd->wqe = wqe;
-		cwd->index = acct->index;
-		if (!task_work_add(wq->task, &cwd->work, TWA_SIGNAL))
-			return;
-
-		kfree(cwd);
-	}
+	init_task_work(&worker->create_work, create_worker_cb);
+	worker->create_index = acct->index;
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+		return;
+	clear_bit_unlock(0, &worker->create_state);
+fail_release:
+	io_worker_release(worker);
 fail:
 	atomic_dec(&acct->nr_running);
 	io_worker_ref_put(wq);
@@ -344,7 +351,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		io_queue_worker_create(wqe, acct);
+		io_queue_worker_create(wqe, worker, acct);
 	}
 }
 
@@ -417,7 +424,28 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	spin_unlock(&wq->hash->wait.lock);
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
+/*
+ * We can always run the work if the worker is currently the same type as
+ * the work (eg both are bound, or both are unbound). If they are not the
+ * same, only allow it if incrementing the worker count would be allowed.
+ */
+static bool io_worker_can_run_work(struct io_worker *worker,
+				   struct io_wq_work *work)
+{
+	struct io_wqe_acct *acct;
+
+	if (!(worker->flags & IO_WORKER_F_BOUND) !=
+	    !(work->flags & IO_WQ_WORK_UNBOUND))
+		return true;
+
+	/* not the same type, check if we'd go over the limit */
+	acct = io_work_get_acct(worker->wqe, work);
+	return acct->nr_workers < acct->max_workers;
+}
+
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+					   struct io_worker *worker,
+					   bool *stalled)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -429,6 +457,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 
 		work = container_of(node, struct io_wq_work, list);
 
+		if (!io_worker_can_run_work(worker, work))
+			break;
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&wqe->work_list, node, prev);
@@ -455,6 +486,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		*stalled = true;
 	}
 
 	return NULL;
@@ -494,6 +526,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
+		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -502,10 +535,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		stalled = false;
+		work = io_get_next_work(wqe, worker, &stalled);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (!wq_list_empty(&wqe->work_list))
+		else if (stalled)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock_irq(&wqe->lock);
@@ -1010,12 +1044,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 static bool io_task_work_match(struct callback_head *cb, void *data)
 {
-	struct create_worker_data *cwd;
+	struct io_worker *worker;
 
 	if (cb->func != create_worker_cb)
 		return false;
-	cwd = container_of(cb, struct create_worker_data, work);
-	return cwd->wqe->wq == data;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker->wqe->wq == data;
 }
 
 void io_wq_exit_start(struct io_wq *wq)
@@ -1032,12 +1066,13 @@ static void io_wq_exit_workers(struct io_wq *wq)
 		return;
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
-		struct create_worker_data *cwd;
+		struct io_worker *worker;
 
-		cwd = container_of(cb, struct create_worker_data, work);
-		atomic_dec(&cwd->wqe->acct[cwd->index].nr_running);
+		worker = container_of(cb, struct io_worker, create_work);
+		atomic_dec(&worker->wqe->acct[worker->create_index].nr_running);
 		io_worker_ref_put(wq);
-		kfree(cwd);
+		clear_bit_unlock(0, &worker->create_state);
+		io_worker_release(worker);
 	}
 
 	rcu_read_lock();
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f6ddc7182943..58ae2eab99ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -990,6 +990,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.plug			= 1,
@@ -1060,8 +1061,7 @@ static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx);
+static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
@@ -1901,7 +1901,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 		return;
 	if (ctx->submit_state.comp.nr) {
 		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
@@ -2147,9 +2147,9 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 		list_add(&req->compl.list, &state->comp.free_list);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx)
+static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
+	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
 	struct io_kiocb *req;
 	struct req_batch rb;
@@ -6462,7 +6462,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 
 			cs->reqs[cs->nr++] = req;
 			if (cs->nr == ARRAY_SIZE(cs->reqs))
-				io_submit_flush_completions(cs, ctx);
+				io_submit_flush_completions(ctx);
 		} else {
 			io_put_req(req);
 		}
@@ -6676,7 +6676,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
 	if (state->comp.nr)
-		io_submit_flush_completions(&state->comp, ctx);
+		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
@@ -7670,6 +7670,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index 6250ca6a1f85..4ecf4e1f68ef 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -31,11 +31,16 @@ static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
 {
 	struct iomap *iomap = &isi->iomap;
 	unsigned long nr_pages;
+	unsigned long max_pages;
 	uint64_t first_ppage;
 	uint64_t first_ppage_reported;
 	uint64_t next_ppage;
 	int error;
 
+	if (unlikely(isi->nr_pages >= isi->sis->max))
+		return 0;
+	max_pages = isi->sis->max - isi->nr_pages;
+
 	/*
 	 * Round the start up and the end down so that the physical
 	 * extent aligns to a page boundary.
@@ -48,6 +53,7 @@ static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
 	if (first_ppage >= next_ppage)
 		return 0;
 	nr_pages = next_ppage - first_ppage;
+	nr_pages = min(nr_pages, max_pages);
 
 	/*
 	 * Calculate how much swap space we're adding; the first page contains
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 21edc423b79f..678e2c51b855 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -155,7 +155,6 @@ struct iso9660_options{
 	unsigned int overriderockperm:1;
 	unsigned int uid_set:1;
 	unsigned int gid_set:1;
-	unsigned int utf8:1;
 	unsigned char map;
 	unsigned char check;
 	unsigned int blocksize;
@@ -356,7 +355,6 @@ static int parse_options(char *options, struct iso9660_options *popt)
 	popt->gid = GLOBAL_ROOT_GID;
 	popt->uid = GLOBAL_ROOT_UID;
 	popt->iocharset = NULL;
-	popt->utf8 = 0;
 	popt->overriderockperm = 0;
 	popt->session=-1;
 	popt->sbsector=-1;
@@ -389,10 +387,13 @@ static int parse_options(char *options, struct iso9660_options *popt)
 		case Opt_cruft:
 			popt->cruft = 1;
 			break;
+#ifdef CONFIG_JOLIET
 		case Opt_utf8:
-			popt->utf8 = 1;
+			kfree(popt->iocharset);
+			popt->iocharset = kstrdup("utf8", GFP_KERNEL);
+			if (!popt->iocharset)
+				return 0;
 			break;
-#ifdef CONFIG_JOLIET
 		case Opt_iocharset:
 			kfree(popt->iocharset);
 			popt->iocharset = match_strdup(&args[0]);
@@ -495,7 +496,6 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 	if (sbi->s_nocompress)		seq_puts(m, ",nocompress");
 	if (sbi->s_overriderockperm)	seq_puts(m, ",overriderockperm");
 	if (sbi->s_showassoc)		seq_puts(m, ",showassoc");
-	if (sbi->s_utf8)		seq_puts(m, ",utf8");
 
 	if (sbi->s_check)		seq_printf(m, ",check=%c", sbi->s_check);
 	if (sbi->s_mapping)		seq_printf(m, ",map=%c", sbi->s_mapping);
@@ -518,9 +518,10 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",fmode=%o", sbi->s_fmode);
 
 #ifdef CONFIG_JOLIET
-	if (sbi->s_nls_iocharset &&
-	    strcmp(sbi->s_nls_iocharset->charset, CONFIG_NLS_DEFAULT) != 0)
+	if (sbi->s_nls_iocharset)
 		seq_printf(m, ",iocharset=%s", sbi->s_nls_iocharset->charset);
+	else
+		seq_puts(m, ",iocharset=utf8");
 #endif
 	return 0;
 }
@@ -863,14 +864,13 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	sbi->s_nls_iocharset = NULL;
 
 #ifdef CONFIG_JOLIET
-	if (joliet_level && opt.utf8 == 0) {
+	if (joliet_level) {
 		char *p = opt.iocharset ? opt.iocharset : CONFIG_NLS_DEFAULT;
-		sbi->s_nls_iocharset = load_nls(p);
-		if (! sbi->s_nls_iocharset) {
-			/* Fail only if explicit charset specified */
-			if (opt.iocharset)
+		if (strcmp(p, "utf8") != 0) {
+			sbi->s_nls_iocharset = opt.iocharset ?
+				load_nls(opt.iocharset) : load_nls_default();
+			if (!sbi->s_nls_iocharset)
 				goto out_freesbi;
-			sbi->s_nls_iocharset = load_nls_default();
 		}
 	}
 #endif
@@ -886,7 +886,6 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	sbi->s_gid = opt.gid;
 	sbi->s_uid_set = opt.uid_set;
 	sbi->s_gid_set = opt.gid_set;
-	sbi->s_utf8 = opt.utf8;
 	sbi->s_nocompress = opt.nocompress;
 	sbi->s_overriderockperm = opt.overriderockperm;
 	/*
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 055ec6c586f7..dcdc191ed183 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -44,7 +44,6 @@ struct isofs_sb_info {
 	unsigned char s_session;
 	unsigned int  s_high_sierra:1;
 	unsigned int  s_rock:2;
-	unsigned int  s_utf8:1;
 	unsigned int  s_cruft:1; /* Broken disks with high byte of length
 				  * containing junk */
 	unsigned int  s_nocompress:1;
diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index be8b6a9d0b92..c0f04a1e7f69 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -41,14 +41,12 @@ uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
 int
 get_joliet_filename(struct iso_directory_record * de, unsigned char *outname, struct inode * inode)
 {
-	unsigned char utf8;
 	struct nls_table *nls;
 	unsigned char len = 0;
 
-	utf8 = ISOFS_SB(inode->i_sb)->s_utf8;
 	nls = ISOFS_SB(inode->i_sb)->s_nls_iocharset;
 
-	if (utf8) {
+	if (!nls) {
 		len = utf16s_to_utf8s((const wchar_t *) de->name,
 				de->name_len[0] >> 1, UTF16_BIG_ENDIAN,
 				outname, PAGE_SIZE);
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 61d3cc2283dc..498cb70c2c0d 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -634,7 +634,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	conflock->caller = "somehost";	/* FIXME */
 	conflock->len = strlen(conflock->caller);
 	conflock->oh.len = 0;		/* don't return OH info */
-	conflock->svid = ((struct nlm_lockowner *)lock->fl.fl_owner)->pid;
+	conflock->svid = lock->fl.fl_pid;
 	conflock->fl.fl_type = lock->fl.fl_type;
 	conflock->fl.fl_start = lock->fl.fl_start;
 	conflock->fl.fl_end = lock->fl.fl_end;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 90e81f6491ff..ab81e8ae3265 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2665,9 +2665,9 @@ static void force_expire_client(struct nfs4_client *clp)
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 	bool already_expired;
 
-	spin_lock(&clp->cl_lock);
+	spin_lock(&nn->client_lock);
 	clp->cl_time = 0;
-	spin_unlock(&clp->cl_lock);
+	spin_unlock(&nn->client_lock);
 
 	wait_event(expiry_wq, atomic_read(&clp->cl_rpc_users) == 0);
 	spin_lock(&nn->client_lock);
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index eab94527340d..1614d308d0f0 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -173,13 +173,22 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < iinfo->i_lenEAttr) {
+		while (offset + sizeof(*gaf) < iinfo->i_lenEAttr) {
+			uint32_t attrLength;
+
 			gaf = (struct genericFormat *)&ea[offset];
+			attrLength = le32_to_cpu(gaf->attrLength);
+
+			/* Detect undersized elements and buffer overflows */
+			if ((attrLength < sizeof(*gaf)) ||
+			    (attrLength > (iinfo->i_lenEAttr - offset)))
+				break;
+
 			if (le32_to_cpu(gaf->attrType) == type &&
 					gaf->attrSubtype == subtype)
 				return gaf;
 			else
-				offset += le32_to_cpu(gaf->attrLength);
+				offset += attrLength;
 		}
 	}
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 2f83c1204e20..b2d7c57d0688 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -108,16 +108,10 @@ struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_block *sb)
 		return NULL;
 	lvid = (struct logicalVolIntegrityDesc *)UDF_SB(sb)->s_lvid_bh->b_data;
 	partnum = le32_to_cpu(lvid->numOfPartitions);
-	if ((sb->s_blocksize - sizeof(struct logicalVolIntegrityDescImpUse) -
-	     offsetof(struct logicalVolIntegrityDesc, impUse)) /
-	     (2 * sizeof(uint32_t)) < partnum) {
-		udf_err(sb, "Logical volume integrity descriptor corrupted "
-			"(numOfPartitions = %u)!\n", partnum);
-		return NULL;
-	}
 	/* The offset is to skip freeSpaceTable and sizeTable arrays */
 	offset = partnum * 2 * sizeof(uint32_t);
-	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
+	return (struct logicalVolIntegrityDescImpUse *)
+					(((uint8_t *)(lvid + 1)) + offset);
 }
 
 /* UDF filesystem type */
@@ -349,10 +343,10 @@ static int udf_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",lastblock=%u", sbi->s_last_block);
 	if (sbi->s_anchor != 0)
 		seq_printf(seq, ",anchor=%u", sbi->s_anchor);
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-		seq_puts(seq, ",utf8");
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
+	if (sbi->s_nls_map)
 		seq_printf(seq, ",iocharset=%s", sbi->s_nls_map->charset);
+	else
+		seq_puts(seq, ",iocharset=utf8");
 
 	return 0;
 }
@@ -558,19 +552,24 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			/* Ignored (never implemented properly) */
 			break;
 		case Opt_utf8:
-			uopt->flags |= (1 << UDF_FLAG_UTF8);
+			if (!remount) {
+				unload_nls(uopt->nls_map);
+				uopt->nls_map = NULL;
+			}
 			break;
 		case Opt_iocharset:
 			if (!remount) {
-				if (uopt->nls_map)
-					unload_nls(uopt->nls_map);
-				/*
-				 * load_nls() failure is handled later in
-				 * udf_fill_super() after all options are
-				 * parsed.
-				 */
+				unload_nls(uopt->nls_map);
+				uopt->nls_map = NULL;
+			}
+			/* When nls_map is not loaded then UTF-8 is used */
+			if (!remount && strcmp(args[0].from, "utf8") != 0) {
 				uopt->nls_map = load_nls(args[0].from);
-				uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
+				if (!uopt->nls_map) {
+					pr_err("iocharset %s not found\n",
+						args[0].from);
+					return 0;
+				}
 			}
 			break;
 		case Opt_uforget:
@@ -1542,6 +1541,7 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
+	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1568,15 +1568,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 
 		lvid = (struct logicalVolIntegrityDesc *)final_bh->b_data;
 		if (lvid->nextIntegrityExt.extLength == 0)
-			return;
+			goto check;
 
 		loc = leea_to_cpu(lvid->nextIntegrityExt);
 	}
 
 	udf_warn(sb, "Too many LVID indirections (max %u), ignoring.\n",
 		UDF_MAX_LVID_NESTING);
+out_err:
 	brelse(sbi->s_lvid_bh);
 	sbi->s_lvid_bh = NULL;
+	return;
+check:
+	parts = le32_to_cpu(lvid->numOfPartitions);
+	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
+	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
+	    2 * parts * sizeof(u32) > sb->s_blocksize) {
+		udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
+			 "ignoring.\n", parts, impuselen);
+		goto out_err;
+	}
 }
 
 /*
@@ -2139,21 +2151,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	if (!udf_parse_options((char *)options, &uopt, false))
 		goto parse_options_failure;
 
-	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
-	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
-		udf_err(sb, "utf8 cannot be combined with iocharset\n");
-		goto parse_options_failure;
-	}
-	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
-		uopt.nls_map = load_nls_default();
-		if (!uopt.nls_map)
-			uopt.flags &= ~(1 << UDF_FLAG_NLS_MAP);
-		else
-			udf_debug("Using default NLS map\n");
-	}
-	if (!(uopt.flags & (1 << UDF_FLAG_NLS_MAP)))
-		uopt.flags |= (1 << UDF_FLAG_UTF8);
-
 	fileset.logicalBlockNum = 0xFFFFFFFF;
 	fileset.partitionReferenceNum = 0xFFFF;
 
@@ -2308,8 +2305,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 error_out:
 	iput(sbi->s_vat_inode);
 parse_options_failure:
-	if (uopt.nls_map)
-		unload_nls(uopt.nls_map);
+	unload_nls(uopt.nls_map);
 	if (lvid_open)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
@@ -2359,8 +2355,7 @@ static void udf_put_super(struct super_block *sb)
 	sbi = UDF_SB(sb);
 
 	iput(sbi->s_vat_inode);
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(sbi->s_nls_map);
+	unload_nls(sbi->s_nls_map);
 	if (!sb_rdonly(sb))
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 758efe557a19..4fa620543d30 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -20,8 +20,6 @@
 #define UDF_FLAG_UNDELETE		6
 #define UDF_FLAG_UNHIDE			7
 #define UDF_FLAG_VARCONV		8
-#define UDF_FLAG_NLS_MAP		9
-#define UDF_FLAG_UTF8			10
 #define UDF_FLAG_UID_FORGET     11    /* save -1 for uid to disk */
 #define UDF_FLAG_GID_FORGET     12
 #define UDF_FLAG_UID_SET	13
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 5fcfa96463eb..622569007b53 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -177,7 +177,7 @@ static int udf_name_from_CS0(struct super_block *sb,
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (UDF_SB(sb)->s_nls_map)
 		conv_f = UDF_SB(sb)->s_nls_map->uni2char;
 	else
 		conv_f = NULL;
@@ -285,7 +285,7 @@ static int udf_name_to_CS0(struct super_block *sb,
 	if (ocu_max_len <= 0)
 		return 0;
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (UDF_SB(sb)->s_nls_map)
 		conv_f = UDF_SB(sb)->s_nls_map->char2uni;
 	else
 		conv_f = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f69c75bd6d27..9bfb2f65534b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1531,6 +1531,22 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
 	return offset << SECTOR_SHIFT;
 }
 
+/*
+ * Two cases of handling DISCARD merge:
+ * If max_discard_segments > 1, the driver takes every bio
+ * as a range and send them to controller together. The ranges
+ * needn't to be contiguous.
+ * Otherwise, the bios/requests will be handled as same as
+ * others which should be contiguous.
+ */
+static inline bool blk_discard_mergable(struct request *req)
+{
+	if (req_op(req) == REQ_OP_DISCARD &&
+	    queue_max_discard_segments(req->q) > 1)
+		return true;
+	return false;
+}
+
 static inline int bdev_discard_alignment(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
index 757fc60658fa..d1e9823d99c8 100644
--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -53,6 +53,22 @@ struct em_perf_domain {
 #ifdef CONFIG_ENERGY_MODEL
 #define EM_MAX_POWER 0xFFFF
 
+/*
+ * Increase resolution of energy estimation calculations for 64-bit
+ * architectures. The extra resolution improves decision made by EAS for the
+ * task placement when two Performance Domains might provide similar energy
+ * estimation values (w/o better resolution the values could be equal).
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. 64-bit). The costs for increasing resolution when 32-bit
+ * are pretty high and the returns do not justify the increased costs.
+ */
+#ifdef CONFIG_64BIT
+#define em_scale_power(p) ((p) * 1000)
+#else
+#define em_scale_power(p) (p)
+#endif
+
 struct em_data_callback {
 	/**
 	 * active_power() - Provide power at the next performance state of
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bb5e7b0a4274..77295af72426 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -318,16 +318,12 @@ struct clock_event_device;
 
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
-extern void clock_was_set_delayed(void);
-
 extern unsigned int hrtimer_resolution;
 
 #else
 
 #define hrtimer_resolution	(unsigned int)LOW_RES_NSEC
 
-static inline void clock_was_set_delayed(void) { }
-
 #endif
 
 static inline ktime_t
@@ -351,7 +347,6 @@ hrtimer_expires_remaining_adjusted(const struct hrtimer *timer)
 						    timer->base->get_time());
 }
 
-extern void clock_was_set(void);
 #ifdef CONFIG_TIMERFD
 extern void timerfd_clock_was_set(void);
 #else
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index ded90b097e6e..3f02b818625e 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -14,29 +14,14 @@ typedef struct {
 } local_lock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define LL_DEP_MAP_INIT(lockname)			\
+# define LOCAL_LOCK_DEBUG_INIT(lockname)		\
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
-		.lock_type = LD_LOCK_PERCPU,			\
-	}
-#else
-# define LL_DEP_MAP_INIT(lockname)
-#endif
-
-#define INIT_LOCAL_LOCK(lockname)	{ LL_DEP_MAP_INIT(lockname) }
-
-#define __local_lock_init(lock)					\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));\
-	lockdep_init_map_type(&(lock)->dep_map, #lock, &__key, 0, \
-			      LD_WAIT_CONFIG, LD_WAIT_INV,	\
-			      LD_LOCK_PERCPU);			\
-} while (0)
+		.lock_type = LD_LOCK_PERCPU,		\
+	},						\
+	.owner = NULL,
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static inline void local_lock_acquire(local_lock_t *l)
 {
 	lock_map_acquire(&l->dep_map);
@@ -51,11 +36,30 @@ static inline void local_lock_release(local_lock_t *l)
 	lock_map_release(&l->dep_map);
 }
 
+static inline void local_lock_debug_init(local_lock_t *l)
+{
+	l->owner = NULL;
+}
 #else /* CONFIG_DEBUG_LOCK_ALLOC */
+# define LOCAL_LOCK_DEBUG_INIT(lockname)
 static inline void local_lock_acquire(local_lock_t *l) { }
 static inline void local_lock_release(local_lock_t *l) { }
+static inline void local_lock_debug_init(local_lock_t *l) { }
 #endif /* !CONFIG_DEBUG_LOCK_ALLOC */
 
+#define INIT_LOCAL_LOCK(lockname)	{ LOCAL_LOCK_DEBUG_INIT(lockname) }
+
+#define __local_lock_init(lock)					\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));\
+	lockdep_init_map_type(&(lock)->dep_map, #lock, &__key,  \
+			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
+			      LD_LOCK_PERCPU);			\
+	local_lock_debug_init(lock);				\
+} while (0)
+
 #define __local_lock(lock)					\
 	do {							\
 		preempt_disable();				\
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index eb86e80e4643..857529a5568d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -918,7 +918,8 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         scatter_fcs[0x1];
 	u8         enhanced_multi_pkt_send_wqe[0x1];
 	u8         tunnel_lso_const_out_ip_id[0x1];
-	u8         reserved_at_1c[0x2];
+	u8         tunnel_lro_gre[0x1];
+	u8         tunnel_lro_vxlan[0x1];
 	u8         tunnel_stateless_gre[0x1];
 	u8         tunnel_stateless_vxlan[0x1];
 
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index d55c746ac56e..e00ad1cfb1f1 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -69,7 +69,7 @@ enum max17042_register {
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
+	MAX17042_TOFF		= 0x2D,
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index e91d51ea028b..65185d1e07ea 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -523,6 +523,7 @@ void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
 char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
+const char *	   svc_proc_name(const struct svc_rqst *rqstp);
 int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 5117cb5b5656..81b9686a2079 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -25,7 +25,9 @@ struct itimerspec64 {
 #define TIME64_MIN			(-TIME64_MAX - 1)
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_MIN			(-KTIME_MAX - 1)
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#define KTIME_SEC_MIN			(KTIME_MIN / NSEC_PER_SEC)
 
 /*
  * Limits for settimeofday():
@@ -124,10 +126,13 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
-	/* Prevent multiplication overflow */
-	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+	/* Prevent multiplication overflow / underflow */
+	if (ts->tv_sec >= KTIME_SEC_MAX)
 		return KTIME_MAX;
 
+	if (ts->tv_sec <= KTIME_SEC_MIN)
+		return KTIME_MIN;
+
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e1a2610a0e06..f91317d2df9d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -643,8 +643,6 @@ struct dsa_switch_ops {
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
 				     struct switchdev_brport_flags flags,
 				     struct netlink_ext_ack *extack);
-	int	(*port_set_mrouter)(struct dsa_switch *ds, int port, bool mrouter,
-				    struct netlink_ext_ack *extack);
 
 	/*
 	 * VLAN support
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ec7823921bd2..b420f905f4f6 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -820,10 +820,9 @@ enum tc_htb_command {
 struct tc_htb_qopt_offload {
 	struct netlink_ext_ack *extack;
 	enum tc_htb_command command;
-	u16 classid;
 	u32 parent_classid;
+	u16 classid;
 	u16 qid;
-	u16 moved_qid;
 	u64 rate;
 	u64 ceil;
 };
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index abb8b24744fd..08e65dcbd1e3 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -295,14 +295,14 @@ TRACE_EVENT(io_uring_fail_link,
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, u64 user_data, long res, unsigned cflags),
+	TP_PROTO(void *ctx, u64 user_data, int res, unsigned cflags),
 
 	TP_ARGS(ctx, user_data, res, cflags),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
 		__field(  u64,		user_data	)
-		__field(  long,		res		)
+		__field(  int,		res		)
 		__field(  unsigned,	cflags		)
 	),
 
@@ -313,7 +313,7 @@ TRACE_EVENT(io_uring_complete,
 		__entry->cflags		= cflags;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
+	TP_printk("ring %p, user_data 0x%llx, result %d, cflags %x",
 			  __entry->ctx, (unsigned long long)__entry->user_data,
 			  __entry->res, __entry->cflags)
 );
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index d02e01a27b69..87569dbf2fe7 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1642,7 +1642,7 @@ TRACE_EVENT(svc_process,
 		__field(u32, vers)
 		__field(u32, proc)
 		__string(service, name)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt ?
 			 rqst->rq_xprt->xpt_remotebuf : "(null)")
 	),
@@ -1652,7 +1652,7 @@ TRACE_EVENT(svc_process,
 		__entry->vers = rqst->rq_vers;
 		__entry->proc = rqst->rq_proc;
 		__assign_str(service, name);
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt ?
 			     rqst->rq_xprt->xpt_remotebuf : "(null)");
 	),
@@ -1918,7 +1918,7 @@ TRACE_EVENT(svc_stats_latency,
 	TP_STRUCT__entry(
 		__field(u32, xid)
 		__field(unsigned long, execute)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt->xpt_remotebuf)
 	),
 
@@ -1926,7 +1926,7 @@ TRACE_EVENT(svc_stats_latency,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->execute = ktime_to_us(ktime_sub(ktime_get(),
 							 rqst->rq_stime));
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt->xpt_remotebuf);
 	),
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ec6d85a81744..353f06cf210e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3222,7 +3222,7 @@ union bpf_attr {
  * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
- *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY** *map*.
  *		It checks the selected socket is matching the incoming
  *		request in the socket buffer.
  *	Return
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6b58fd978b70..d810f9e0ed9d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11383,10 +11383,11 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
  * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
  * [0, off) and [off, end) to new locations, so the patched range stays zero
  */
-static int adjust_insn_aux_data(struct bpf_verifier_env *env,
-				struct bpf_prog *new_prog, u32 off, u32 cnt)
+static void adjust_insn_aux_data(struct bpf_verifier_env *env,
+				 struct bpf_insn_aux_data *new_data,
+				 struct bpf_prog *new_prog, u32 off, u32 cnt)
 {
-	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	struct bpf_insn_aux_data *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
 	u32 old_seen = old_data[off].seen;
 	u32 prog_len;
@@ -11399,12 +11400,9 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
 
 	if (cnt == 1)
-		return 0;
+		return;
 	prog_len = new_prog->len;
-	new_data = vzalloc(array_size(prog_len,
-				      sizeof(struct bpf_insn_aux_data)));
-	if (!new_data)
-		return -ENOMEM;
+
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
@@ -11415,7 +11413,6 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
-	return 0;
 }
 
 static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
@@ -11450,6 +11447,14 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 					    const struct bpf_insn *patch, u32 len)
 {
 	struct bpf_prog *new_prog;
+	struct bpf_insn_aux_data *new_data = NULL;
+
+	if (len > 1) {
+		new_data = vzalloc(array_size(env->prog->len + len - 1,
+					      sizeof(struct bpf_insn_aux_data)));
+		if (!new_data)
+			return NULL;
+	}
 
 	new_prog = bpf_patch_insn_single(env->prog, off, patch, len);
 	if (IS_ERR(new_prog)) {
@@ -11457,10 +11462,10 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 			verbose(env,
 				"insn %d cannot be patched due to 16-bit range\n",
 				env->insn_aux_data[off].orig_idx);
+		vfree(new_data);
 		return NULL;
 	}
-	if (adjust_insn_aux_data(env, new_prog, off, len))
-		return NULL;
+	adjust_insn_aux_data(env, new_data, new_prog, off, len);
 	adjust_subprog_starts(env, off, len);
 	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
@@ -11977,6 +11982,10 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		if (is_narrower_load && size < target_size) {
 			u8 shift = bpf_ctx_narrow_access_offset(
 				off, size, size_default) * 8;
+			if (shift && cnt + 1 >= ARRAY_SIZE(insn_buf)) {
+				verbose(env, "bpf verifier narrow ctx load misconfigured\n");
+				return -EINVAL;
+			}
 			if (ctx_field_size <= 4) {
 				if (shift)
 					insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..13b5be6df4da 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1114,7 +1114,7 @@ enum subparts_cmd {
  * cpus_allowed can be granted or an error code will be returned.
  *
  * For partcmd_disable, the cpuset is being transofrmed from a partition
- * root back to a non-partition root. any CPUs in cpus_allowed that are in
+ * root back to a non-partition root. Any CPUs in cpus_allowed that are in
  * parent's subparts_cpus will be taken away from that cpumask and put back
  * into parent's effective_cpus. 0 should always be returned.
  *
@@ -1148,6 +1148,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	struct cpuset *parent = parent_cs(cpuset);
 	int adding;	/* Moving cpus from effective_cpus to subparts_cpus */
 	int deleting;	/* Moving cpus from subparts_cpus to effective_cpus */
+	int new_prs;
 	bool part_error = false;	/* Partition error? */
 
 	percpu_rwsem_assert_held(&cpuset_rwsem);
@@ -1183,6 +1184,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	 * A cpumask update cannot make parent's effective_cpus become empty.
 	 */
 	adding = deleting = false;
+	new_prs = cpuset->partition_root_state;
 	if (cmd == partcmd_enable) {
 		cpumask_copy(tmp->addmask, cpuset->cpus_allowed);
 		adding = true;
@@ -1225,7 +1227,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		/*
 		 * partcmd_update w/o newmask:
 		 *
-		 * addmask = cpus_allowed & parent->effectiveb_cpus
+		 * addmask = cpus_allowed & parent->effective_cpus
 		 *
 		 * Note that parent's subparts_cpus may have been
 		 * pre-shrunk in case there is a change in the cpu list.
@@ -1247,11 +1249,11 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		switch (cpuset->partition_root_state) {
 		case PRS_ENABLED:
 			if (part_error)
-				cpuset->partition_root_state = PRS_ERROR;
+				new_prs = PRS_ERROR;
 			break;
 		case PRS_ERROR:
 			if (!part_error)
-				cpuset->partition_root_state = PRS_ENABLED;
+				new_prs = PRS_ENABLED;
 			break;
 		}
 		/*
@@ -1260,10 +1262,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		part_error = (prev_prs == PRS_ERROR);
 	}
 
-	if (!part_error && (cpuset->partition_root_state == PRS_ERROR))
+	if (!part_error && (new_prs == PRS_ERROR))
 		return 0;	/* Nothing need to be done */
 
-	if (cpuset->partition_root_state == PRS_ERROR) {
+	if (new_prs == PRS_ERROR) {
 		/*
 		 * Remove all its cpus from parent's subparts_cpus.
 		 */
@@ -1272,7 +1274,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 				       parent->subparts_cpus);
 	}
 
-	if (!adding && !deleting)
+	if (!adding && !deleting && (new_prs == cpuset->partition_root_state))
 		return 0;
 
 	/*
@@ -1299,6 +1301,9 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	}
 
 	parent->nr_subparts_cpus = cpumask_weight(parent->subparts_cpus);
+
+	if (cpuset->partition_root_state != new_prs)
+		cpuset->partition_root_state = new_prs;
 	spin_unlock_irq(&callback_lock);
 
 	return cmd == partcmd_update;
@@ -1321,6 +1326,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 	bool need_rebuild_sched_domains = false;
+	int new_prs;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -1360,17 +1366,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		 * update_tasks_cpumask() again for tasks in the parent
 		 * cpuset if the parent's subparts_cpus changes.
 		 */
-		if ((cp != cs) && cp->partition_root_state) {
+		new_prs = cp->partition_root_state;
+		if ((cp != cs) && new_prs) {
 			switch (parent->partition_root_state) {
 			case PRS_DISABLED:
 				/*
 				 * If parent is not a partition root or an
-				 * invalid partition root, clear the state
-				 * state and the CS_CPU_EXCLUSIVE flag.
+				 * invalid partition root, clear its state
+				 * and its CS_CPU_EXCLUSIVE flag.
 				 */
 				WARN_ON_ONCE(cp->partition_root_state
 					     != PRS_ERROR);
-				cp->partition_root_state = 0;
+				new_prs = PRS_DISABLED;
 
 				/*
 				 * clear_bit() is an atomic operation and
@@ -1391,11 +1398,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 				/*
 				 * When parent is invalid, it has to be too.
 				 */
-				cp->partition_root_state = PRS_ERROR;
-				if (cp->nr_subparts_cpus) {
-					cp->nr_subparts_cpus = 0;
-					cpumask_clear(cp->subparts_cpus);
-				}
+				new_prs = PRS_ERROR;
 				break;
 			}
 		}
@@ -1407,8 +1410,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		spin_lock_irq(&callback_lock);
 
 		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
-		if (cp->nr_subparts_cpus &&
-		   (cp->partition_root_state != PRS_ENABLED)) {
+		if (cp->nr_subparts_cpus && (new_prs != PRS_ENABLED)) {
 			cp->nr_subparts_cpus = 0;
 			cpumask_clear(cp->subparts_cpus);
 		} else if (cp->nr_subparts_cpus) {
@@ -1435,6 +1437,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 					= cpumask_weight(cp->subparts_cpus);
 			}
 		}
+
+		if (new_prs != cp->partition_root_state)
+			cp->partition_root_state = new_prs;
+
 		spin_unlock_irq(&callback_lock);
 
 		WARN_ON(!is_in_v2_mode() &&
@@ -1937,34 +1943,32 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 
 /*
  * update_prstate - update partititon_root_state
- * cs:	the cpuset to update
- * val: 0 - disabled, 1 - enabled
+ * cs: the cpuset to update
+ * new_prs: new partition root state
  *
  * Call with cpuset_mutex held.
  */
-static int update_prstate(struct cpuset *cs, int val)
+static int update_prstate(struct cpuset *cs, int new_prs)
 {
-	int err;
+	int err, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
-	struct tmpmasks tmp;
+	struct tmpmasks tmpmask;
 
-	if ((val != 0) && (val != 1))
-		return -EINVAL;
-	if (val == cs->partition_root_state)
+	if (old_prs == new_prs)
 		return 0;
 
 	/*
 	 * Cannot force a partial or invalid partition root to a full
 	 * partition root.
 	 */
-	if (val && cs->partition_root_state)
+	if (new_prs && (old_prs == PRS_ERROR))
 		return -EINVAL;
 
-	if (alloc_cpumasks(NULL, &tmp))
+	if (alloc_cpumasks(NULL, &tmpmask))
 		return -ENOMEM;
 
 	err = -EINVAL;
-	if (!cs->partition_root_state) {
+	if (!old_prs) {
 		/*
 		 * Turning on partition root requires setting the
 		 * CS_CPU_EXCLUSIVE bit implicitly as well and cpus_allowed
@@ -1978,31 +1982,27 @@ static int update_prstate(struct cpuset *cs, int val)
 			goto out;
 
 		err = update_parent_subparts_cpumask(cs, partcmd_enable,
-						     NULL, &tmp);
+						     NULL, &tmpmask);
 		if (err) {
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			goto out;
 		}
-		cs->partition_root_state = PRS_ENABLED;
 	} else {
 		/*
 		 * Turning off partition root will clear the
 		 * CS_CPU_EXCLUSIVE bit.
 		 */
-		if (cs->partition_root_state == PRS_ERROR) {
-			cs->partition_root_state = 0;
+		if (old_prs == PRS_ERROR) {
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			err = 0;
 			goto out;
 		}
 
 		err = update_parent_subparts_cpumask(cs, partcmd_disable,
-						     NULL, &tmp);
+						     NULL, &tmpmask);
 		if (err)
 			goto out;
 
-		cs->partition_root_state = 0;
-
 		/* Turning off CS_CPU_EXCLUSIVE will not return error */
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
@@ -2015,11 +2015,17 @@ static int update_prstate(struct cpuset *cs, int val)
 		update_tasks_cpumask(parent);
 
 	if (parent->child_ecpus_count)
-		update_sibling_cpumasks(parent, cs, &tmp);
+		update_sibling_cpumasks(parent, cs, &tmpmask);
 
 	rebuild_sched_domains_locked();
 out:
-	free_cpumasks(NULL, &tmp);
+	if (!err) {
+		spin_lock_irq(&callback_lock);
+		cs->partition_root_state = new_prs;
+		spin_unlock_irq(&callback_lock);
+	}
+
+	free_cpumasks(NULL, &tmpmask);
 	return err;
 }
 
@@ -3060,7 +3066,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		goto retry;
 	}
 
-	parent =  parent_cs(cs);
+	parent = parent_cs(cs);
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	nodes_and(new_mems, cs->mems_allowed, parent->effective_mems);
 
@@ -3082,8 +3088,10 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (is_partition_root(cs) && (cpumask_empty(&new_cpus) ||
 	   (parent->partition_root_state == PRS_ERROR))) {
 		if (cs->nr_subparts_cpus) {
+			spin_lock_irq(&callback_lock);
 			cs->nr_subparts_cpus = 0;
 			cpumask_clear(cs->subparts_cpus);
+			spin_unlock_irq(&callback_lock);
 			compute_effective_cpumask(&new_cpus, cs, parent);
 		}
 
@@ -3097,7 +3105,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		     cpumask_empty(&new_cpus)) {
 			update_parent_subparts_cpumask(cs, partcmd_disable,
 						       NULL, tmp);
+			spin_lock_irq(&callback_lock);
 			cs->partition_root_state = PRS_ERROR;
+			spin_unlock_irq(&callback_lock);
 		}
 		cpuset_force_rebuild();
 	}
@@ -3168,6 +3178,13 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	cpus_updated = !cpumask_equal(top_cpuset.effective_cpus, &new_cpus);
 	mems_updated = !nodes_equal(top_cpuset.effective_mems, new_mems);
 
+	/*
+	 * In the rare case that hotplug removes all the cpus in subparts_cpus,
+	 * we assumed that cpus are updated.
+	 */
+	if (!cpus_updated && top_cpuset.nr_subparts_cpus)
+		cpus_updated = true;
+
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		spin_lock_irq(&callback_lock);
diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
index f7e1d0eccdbc..246efc74e3f3 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -13,19 +13,32 @@
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 
-static ATOMIC_NOTIFIER_HEAD(cpu_pm_notifier_chain);
+/*
+ * atomic_notifiers use a spinlock_t, which can block under PREEMPT_RT.
+ * Notifications for cpu_pm will be issued by the idle task itself, which can
+ * never block, IOW it requires using a raw_spinlock_t.
+ */
+static struct {
+	struct raw_notifier_head chain;
+	raw_spinlock_t lock;
+} cpu_pm_notifier = {
+	.chain = RAW_NOTIFIER_INIT(cpu_pm_notifier.chain),
+	.lock  = __RAW_SPIN_LOCK_UNLOCKED(cpu_pm_notifier.lock),
+};
 
 static int cpu_pm_notify(enum cpu_pm_event event)
 {
 	int ret;
 
 	/*
-	 * atomic_notifier_call_chain has a RCU read critical section, which
-	 * could be disfunctional in cpu idle. Copy RCU_NONIDLE code to let
-	 * RCU know this.
+	 * This introduces a RCU read critical section, which could be
+	 * disfunctional in cpu idle. Copy RCU_NONIDLE code to let RCU know
+	 * this.
 	 */
 	rcu_irq_enter_irqson();
-	ret = atomic_notifier_call_chain(&cpu_pm_notifier_chain, event, NULL);
+	rcu_read_lock();
+	ret = raw_notifier_call_chain(&cpu_pm_notifier.chain, event, NULL);
+	rcu_read_unlock();
 	rcu_irq_exit_irqson();
 
 	return notifier_to_errno(ret);
@@ -33,10 +46,13 @@ static int cpu_pm_notify(enum cpu_pm_event event)
 
 static int cpu_pm_notify_robust(enum cpu_pm_event event_up, enum cpu_pm_event event_down)
 {
+	unsigned long flags;
 	int ret;
 
 	rcu_irq_enter_irqson();
-	ret = atomic_notifier_call_chain_robust(&cpu_pm_notifier_chain, event_up, event_down, NULL);
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_call_chain_robust(&cpu_pm_notifier.chain, event_up, event_down, NULL);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
 	rcu_irq_exit_irqson();
 
 	return notifier_to_errno(ret);
@@ -49,12 +65,17 @@ static int cpu_pm_notify_robust(enum cpu_pm_event event_up, enum cpu_pm_event ev
  * Add a driver to a list of drivers that are notified about
  * CPU and CPU cluster low power entry and exit.
  *
- * This function may sleep, and has the same return conditions as
- * raw_notifier_chain_register.
+ * This function has the same return conditions as raw_notifier_chain_register.
  */
 int cpu_pm_register_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&cpu_pm_notifier_chain, nb);
+	unsigned long flags;
+	int ret;
+
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_chain_register(&cpu_pm_notifier.chain, nb);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
 
@@ -64,12 +85,17 @@ EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
  *
  * Remove a driver from the CPU PM notifier list.
  *
- * This function may sleep, and has the same return conditions as
- * raw_notifier_chain_unregister.
+ * This function has the same return conditions as raw_notifier_chain_unregister.
  */
 int cpu_pm_unregister_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_unregister(&cpu_pm_notifier_chain, nb);
+	unsigned long flags;
+	int ret;
+
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_chain_unregister(&cpu_pm_notifier.chain, nb);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
 
diff --git a/kernel/irq/timings.c b/kernel/irq/timings.c
index 4d2a702d7aa9..c43e2ac2f8de 100644
--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -799,12 +799,14 @@ static int __init irq_timings_test_irqs(struct timings_intervals *ti)
 
 		__irq_timings_store(irq, irqs, ti->intervals[i]);
 		if (irqs->circ_timings[i & IRQ_TIMINGS_MASK] != index) {
+			ret = -EBADSLT;
 			pr_err("Failed to store in the circular buffer\n");
 			goto out;
 		}
 	}
 
 	if (irqs->count != ti->count) {
+		ret = -ERANGE;
 		pr_err("Count differs\n");
 		goto out;
 	}
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 013e1b08a1bf..a03d3d3ff886 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -928,7 +928,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct mutex_waiter waiter;
-	bool first = false;
 	struct ww_mutex *ww;
 	int ret;
 
@@ -1007,6 +1006,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	set_current_state(state);
 	for (;;) {
+		bool first;
+
 		/*
 		 * Once we hold wait_lock, we're serialized against
 		 * mutex_unlock() handing the lock off to us, do a trylock
@@ -1035,15 +1036,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		spin_unlock(&lock->wait_lock);
 		schedule_preempt_disabled();
 
-		/*
-		 * ww_mutex needs to always recheck its position since its waiter
-		 * list is not FIFO ordered.
-		 */
-		if (ww_ctx || !first) {
-			first = __mutex_waiter_is_first(lock, &waiter);
-			if (first)
-				__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
-		}
+		first = __mutex_waiter_is_first(lock, &waiter);
+		if (first)
+			__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
 
 		set_current_state(state);
 		/*
diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 0f4530b3a8cd..a332ccd829e2 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -170,7 +170,9 @@ static int em_create_perf_table(struct device *dev, struct em_perf_domain *pd,
 	/* Compute the cost of each performance state. */
 	fmax = (u64) table[nr_states - 1].frequency;
 	for (i = 0; i < nr_states; i++) {
-		table[i].cost = div64_u64(fmax * table[i].power,
+		unsigned long power_res = em_scale_power(table[i].power);
+
+		table[i].cost = div64_u64(fmax * power_res,
 					  table[i].frequency);
 	}
 
diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index 59b95cc5cbdf..c615fd153cb2 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -7,6 +7,8 @@
  * Author: Paul E. McKenney <paulmck@linux.ibm.com>
  */
 
+#include <linux/kvm_para.h>
+
 //////////////////////////////////////////////////////////////////////////////
 //
 // Controlling CPU stall warnings, including delay calculation.
@@ -267,8 +269,10 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 	struct task_struct *ts[8];
 
 	lockdep_assert_irqs_disabled();
-	if (!rcu_preempt_blocked_readers_cgp(rnp))
+	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
+		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		return 0;
+	}
 	pr_err("\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
 	       rnp->level, rnp->grplo, rnp->grphi);
 	t = list_entry(rnp->gp_tasks->prev,
@@ -280,8 +284,8 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 			break;
 	}
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
-	for (i--; i; i--) {
-		t = ts[i];
+	while (i) {
+		t = ts[--i];
 		if (!try_invoke_on_locked_down_task(t, check_slow_task, &rscr))
 			pr_cont(" P%d", t->pid);
 		else
@@ -695,6 +699,14 @@ static void check_cpu_stall(struct rcu_data *rdp)
 	    (READ_ONCE(rnp->qsmask) & rdp->grpmask) &&
 	    cmpxchg(&rcu_state.jiffies_stall, js, jn) == js) {
 
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like an RCU stall. Check to see if the host
+		 * stopped the vm.
+		 */
+		if (kvm_check_and_clear_guest_paused())
+			return;
+
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(gps);
 		if (READ_ONCE(rcu_cpu_stall_ftrace_dump))
@@ -704,6 +716,14 @@ static void check_cpu_stall(struct rcu_data *rdp)
 		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY) &&
 		   cmpxchg(&rcu_state.jiffies_stall, js, jn) == js) {
 
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like an RCU stall. Check to see if the host
+		 * stopped the vm.
+		 */
+		if (kvm_check_and_clear_guest_paused())
+			return;
+
 		/* They had a few time units to dump stack, so complain. */
 		print_other_cpu_stall(gs2, gps);
 		if (READ_ONCE(rcu_cpu_stall_ftrace_dump))
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 15b4d2fb6be3..1e9672d609f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1281,6 +1281,23 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 		uclamp_rq_dec_id(rq, p, clamp_id);
 }
 
+static inline void uclamp_rq_reinc_id(struct rq *rq, struct task_struct *p,
+				      enum uclamp_id clamp_id)
+{
+	if (!p->uclamp[clamp_id].active)
+		return;
+
+	uclamp_rq_dec_id(rq, p, clamp_id);
+	uclamp_rq_inc_id(rq, p, clamp_id);
+
+	/*
+	 * Make sure to clear the idle flag if we've transiently reached 0
+	 * active tasks on rq.
+	 */
+	if (clamp_id == UCLAMP_MAX && (rq->uclamp_flags & UCLAMP_FLAG_IDLE))
+		rq->uclamp_flags &= ~UCLAMP_FLAG_IDLE;
+}
+
 static inline void
 uclamp_update_active(struct task_struct *p)
 {
@@ -1304,12 +1321,8 @@ uclamp_update_active(struct task_struct *p)
 	 * affecting a valid clamp bucket, the next time it's enqueued,
 	 * it will already see the updated clamp bucket value.
 	 */
-	for_each_clamp_id(clamp_id) {
-		if (p->uclamp[clamp_id].active) {
-			uclamp_rq_dec_id(rq, p, clamp_id);
-			uclamp_rq_inc_id(rq, p, clamp_id);
-		}
-	}
+	for_each_clamp_id(clamp_id)
+		uclamp_rq_reinc_id(rq, p, clamp_id);
 
 	task_rq_unlock(rq, p, &rf);
 }
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2f9964b467e0..fa29a69e14c9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1733,6 +1733,7 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 	 */
 	raw_spin_lock(&rq->lock);
 	if (p->dl.dl_non_contending) {
+		update_rq_clock(rq);
 		sub_running_bw(&p->dl, &rq->dl);
 		p->dl.dl_non_contending = 0;
 		/*
@@ -2729,7 +2730,7 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
-	dl_se->flags = attr->sched_flags;
+	dl_se->flags = attr->sched_flags & SCHED_DL_FLAGS;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
 }
@@ -2742,7 +2743,8 @@ void __getparam_dl(struct task_struct *p, struct sched_attr *attr)
 	attr->sched_runtime = dl_se->dl_runtime;
 	attr->sched_deadline = dl_se->dl_deadline;
 	attr->sched_period = dl_se->dl_period;
-	attr->sched_flags = dl_se->flags;
+	attr->sched_flags &= ~SCHED_DL_FLAGS;
+	attr->sched_flags |= dl_se->flags;
 }
 
 /*
@@ -2839,7 +2841,7 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 	if (dl_se->dl_runtime != attr->sched_runtime ||
 	    dl_se->dl_deadline != attr->sched_deadline ||
 	    dl_se->dl_period != attr->sched_period ||
-	    dl_se->flags != attr->sched_flags)
+	    dl_se->flags != (attr->sched_flags & SCHED_DL_FLAGS))
 		return true;
 
 	return false;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c5aacbd492a1..f8c94bebd17d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -388,6 +388,13 @@ void update_sched_domain_debugfs(void)
 {
 	int cpu, i;
 
+	/*
+	 * This can unfortunately be invoked before sched_debug_init() creates
+	 * the debug directory. Don't touch sd_sysctl_cpus until then.
+	 */
+	if (!debugfs_sched)
+		return;
+
 	if (!cpumask_available(sd_sysctl_cpus)) {
 		if (!alloc_cpumask_var(&sd_sysctl_cpus, GFP_KERNEL))
 			return;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f60ef0b4ec33..3889fee98d11 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1529,7 +1529,7 @@ static inline bool is_core_idle(int cpu)
 		if (cpu == sibling)
 			continue;
 
-		if (!idle_cpu(cpu))
+		if (!idle_cpu(sibling))
 			return false;
 	}
 #endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f2bc99ca01e5..9aa157c20722 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -227,6 +227,8 @@ static inline void update_avg(u64 *avg, u64 sample)
  */
 #define SCHED_FLAG_SUGOV	0x10000000
 
+#define SCHED_DL_FLAGS (SCHED_FLAG_RECLAIM | SCHED_FLAG_DL_OVERRUN | SCHED_FLAG_SUGOV)
+
 static inline bool dl_entity_is_special(struct sched_dl_entity *dl_se)
 {
 #ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 55a0a243e871..41f778f3db05 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1372,6 +1372,8 @@ int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
 static struct cpumask		***sched_domains_numa_masks;
 int __read_mostly		node_reclaim_distance = RECLAIM_DISTANCE;
+
+static unsigned long __read_mostly *sched_numa_onlined_nodes;
 #endif
 
 /*
@@ -1719,6 +1721,16 @@ void sched_init_numa(void)
 			sched_domains_numa_masks[i][j] = mask;
 
 			for_each_node(k) {
+				/*
+				 * Distance information can be unreliable for
+				 * offline nodes, defer building the node
+				 * masks to its bringup.
+				 * This relies on all unique distance values
+				 * still being visible at init time.
+				 */
+				if (!node_online(j))
+					continue;
+
 				if (sched_debug() && (node_distance(j, k) != node_distance(k, j)))
 					sched_numa_warn("Node-distance not symmetric");
 
@@ -1772,6 +1784,53 @@ void sched_init_numa(void)
 	sched_max_numa_distance = sched_domains_numa_distance[nr_levels - 1];
 
 	init_numa_topology_type();
+
+	sched_numa_onlined_nodes = bitmap_alloc(nr_node_ids, GFP_KERNEL);
+	if (!sched_numa_onlined_nodes)
+		return;
+
+	bitmap_zero(sched_numa_onlined_nodes, nr_node_ids);
+	for_each_online_node(i)
+		bitmap_set(sched_numa_onlined_nodes, i, 1);
+}
+
+static void __sched_domains_numa_masks_set(unsigned int node)
+{
+	int i, j;
+
+	/*
+	 * NUMA masks are not built for offline nodes in sched_init_numa().
+	 * Thus, when a CPU of a never-onlined-before node gets plugged in,
+	 * adding that new CPU to the right NUMA masks is not sufficient: the
+	 * masks of that CPU's node must also be updated.
+	 */
+	if (test_bit(node, sched_numa_onlined_nodes))
+		return;
+
+	bitmap_set(sched_numa_onlined_nodes, node, 1);
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			if (!node_online(j) || node == j)
+				continue;
+
+			if (node_distance(j, node) > sched_domains_numa_distance[i])
+				continue;
+
+			/* Add remote nodes in our masks */
+			cpumask_or(sched_domains_numa_masks[i][node],
+				   sched_domains_numa_masks[i][node],
+				   sched_domains_numa_masks[0][j]);
+		}
+	}
+
+	/*
+	 * A new node has been brought up, potentially changing the topology
+	 * classification.
+	 *
+	 * Note that this is racy vs any use of sched_numa_topology_type :/
+	 */
+	init_numa_topology_type();
 }
 
 void sched_domains_numa_masks_set(unsigned int cpu)
@@ -1779,8 +1838,14 @@ void sched_domains_numa_masks_set(unsigned int cpu)
 	int node = cpu_to_node(cpu);
 	int i, j;
 
+	__sched_domains_numa_masks_set(node);
+
 	for (i = 0; i < sched_domains_numa_levels; i++) {
 		for (j = 0; j < nr_node_ids; j++) {
+			if (!node_online(j))
+				continue;
+
+			/* Set ourselves in the remote node's masks */
 			if (node_distance(j, node) <= sched_domains_numa_distance[i])
 				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
 		}
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 4a66725b1d4a..5af758473488 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -758,22 +758,6 @@ static void hrtimer_switch_to_hres(void)
 	retrigger_next_event(NULL);
 }
 
-static void clock_was_set_work(struct work_struct *work)
-{
-	clock_was_set();
-}
-
-static DECLARE_WORK(hrtimer_work, clock_was_set_work);
-
-/*
- * Called from timekeeping and resume code to reprogram the hrtimer
- * interrupt device on all cpus.
- */
-void clock_was_set_delayed(void)
-{
-	schedule_work(&hrtimer_work);
-}
-
 #else
 
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
@@ -891,6 +875,22 @@ void clock_was_set(void)
 	timerfd_clock_was_set();
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
+/*
+ * Called from timekeeping and resume code to reprogram the hrtimer
+ * interrupt device on all cpus and to notify timerfd.
+ */
+void clock_was_set_delayed(void)
+{
+	schedule_work(&hrtimer_work);
+}
+
 /*
  * During resume we might have to reprogram the high resolution timer
  * interrupt on all online CPUs.  However, all other CPUs will be
@@ -1030,12 +1030,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
  * remove hrtimer, called with base lock held
  */
 static inline int
-remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, bool restart)
+remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
+	       bool restart, bool keep_local)
 {
 	u8 state = timer->state;
 
 	if (state & HRTIMER_STATE_ENQUEUED) {
-		int reprogram;
+		bool reprogram;
 
 		/*
 		 * Remove the timer and force reprogramming when high
@@ -1048,8 +1049,16 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, bool rest
 		debug_deactivate(timer);
 		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 
+		/*
+		 * If the timer is not restarted then reprogramming is
+		 * required if the timer is local. If it is local and about
+		 * to be restarted, avoid programming it twice (on removal
+		 * and a moment later when it's requeued).
+		 */
 		if (!restart)
 			state = HRTIMER_STATE_INACTIVE;
+		else
+			reprogram &= !keep_local;
 
 		__remove_hrtimer(timer, base, state, reprogram);
 		return 1;
@@ -1103,9 +1112,31 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				    struct hrtimer_clock_base *base)
 {
 	struct hrtimer_clock_base *new_base;
+	bool force_local, first;
+
+	/*
+	 * If the timer is on the local cpu base and is the first expiring
+	 * timer then this might end up reprogramming the hardware twice
+	 * (on removal and on enqueue). To avoid that by prevent the
+	 * reprogram on removal, keep the timer local to the current CPU
+	 * and enforce reprogramming after it is queued no matter whether
+	 * it is the new first expiring timer again or not.
+	 */
+	force_local = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
+	force_local &= base->cpu_base->next_timer == timer;
 
-	/* Remove an active timer from the queue: */
-	remove_hrtimer(timer, base, true);
+	/*
+	 * Remove an active timer from the queue. In case it is not queued
+	 * on the current CPU, make sure that remove_hrtimer() updates the
+	 * remote data correctly.
+	 *
+	 * If it's on the current CPU and the first expiring timer, then
+	 * skip reprogramming, keep the timer local and enforce
+	 * reprogramming later if it was the first expiring timer.  This
+	 * avoids programming the underlying clock event twice (once at
+	 * removal and once after enqueue).
+	 */
+	remove_hrtimer(timer, base, true, force_local);
 
 	if (mode & HRTIMER_MODE_REL)
 		tim = ktime_add_safe(tim, base->get_time());
@@ -1115,9 +1146,24 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+	if (!force_local) {
+		new_base = switch_hrtimer_base(timer, base,
+					       mode & HRTIMER_MODE_PINNED);
+	} else {
+		new_base = base;
+	}
+
+	first = enqueue_hrtimer(timer, new_base, mode);
+	if (!force_local)
+		return first;
 
-	return enqueue_hrtimer(timer, new_base, mode);
+	/*
+	 * Timer was forced to stay on the current CPU to avoid
+	 * reprogramming on removal and enqueue. Force reprogram the
+	 * hardware by evaluating the new first expiring timer.
+	 */
+	hrtimer_force_reprogram(new_base->cpu_base, 1);
+	return 0;
 }
 
 /**
@@ -1183,7 +1229,7 @@ int hrtimer_try_to_cancel(struct hrtimer *timer)
 	base = lock_hrtimer_base(timer, &flags);
 
 	if (!hrtimer_callback_running(timer))
-		ret = remove_hrtimer(timer, base, false);
+		ret = remove_hrtimer(timer, base, false, false);
 
 	unlock_hrtimer_base(timer, &flags);
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index aa52fc85dbcb..a9f8d25220b1 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1346,8 +1346,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
-		if (!*newval)
-			return;
 		*newval += now;
 	}
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7a981c9e87a4..e61c1244e7d4 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -164,3 +164,6 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
 
 extern u64 get_next_timer_interrupt(unsigned long basej, u64 basem);
 void timer_clear_idle(void);
+
+void clock_was_set(void);
+void clock_was_set_delayed(void);
diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index 3c63710c20c6..e6c4b3180ab1 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -148,7 +148,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		return 0;	/* no need to do it */
 
 	if (a->d) {
-		p = kmalloc_array(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
+		p = kcalloc(nlimbs, sizeof(mpi_limb_t), GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
index 1c140af06d52..600b9563bfc5 100644
--- a/net/6lowpan/debugfs.c
+++ b/net/6lowpan/debugfs.c
@@ -170,7 +170,8 @@ static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
 	struct dentry *root;
 	char buf[32];
 
-	WARN_ON_ONCE(id > LOWPAN_IPHC_CTX_TABLE_SIZE);
+	if (WARN_ON_ONCE(id >= LOWPAN_IPHC_CTX_TABLE_SIZE))
+		return;
 
 	sprintf(buf, "%d", id);
 
diff --git a/net/bluetooth/cmtp/cmtp.h b/net/bluetooth/cmtp/cmtp.h
index c32638dddbf9..f6b9dc4e408f 100644
--- a/net/bluetooth/cmtp/cmtp.h
+++ b/net/bluetooth/cmtp/cmtp.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
-#define BTNAMSIZ 18
+#define BTNAMSIZ 21
 
 /* CMTP ioctl defines */
 #define CMTPCONNADD	_IOW('C', 200, int)
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ee59d1c7f1f6..bf1bb08b94aa 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1343,6 +1343,12 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	/* Restrict maximum inquiry length to 60 seconds */
+	if (ir.length > 60) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
@@ -1734,6 +1740,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 470eaabb021f..6a9826164fd7 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7725,7 +7725,7 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	 * advertising.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
 	if (cp->instance < 1 || cp->instance > hdev->le_num_of_adv_sets)
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 3bd41563f118..9769a7ceb689 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -85,7 +85,6 @@ static void sco_sock_timeout(struct timer_list *t)
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
 
-	sco_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -177,7 +176,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 	}
 
@@ -394,8 +392,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -447,7 +444,6 @@ static void sco_sock_close(struct sock *sk)
 	lock_sock(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_skb_put_cmsg(struct sk_buff *skb, struct msghdr *msg,
@@ -773,6 +769,11 @@ static void sco_conn_defer_accept(struct hci_conn *conn, u16 setting)
 			cp.max_latency = cpu_to_le16(0xffff);
 			cp.retrans_effort = 0xff;
 			break;
+		default:
+			/* use CVSD settings as fallback */
+			cp.max_latency = cpu_to_le16(0xffff);
+			cp.retrans_effort = 0xff;
+			break;
 		}
 
 		hci_send_cmd(hdev, HCI_OP_ACCEPT_SYNC_CONN_REQ,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 051432ea4f69..5d01bebffaca 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3283,10 +3283,12 @@ static void devlink_param_notify(struct devlink *devlink,
 				 struct devlink_param_item *param_item,
 				 enum devlink_command cmd);
 
-static void devlink_reload_netns_change(struct devlink *devlink,
-					struct net *dest_net)
+static void devlink_ns_change_notify(struct devlink *devlink,
+				     struct net *dest_net, struct net *curr_net,
+				     bool new)
 {
 	struct devlink_param_item *param_item;
+	enum devlink_command cmd;
 
 	/* Userspace needs to be notified about devlink objects
 	 * removed from original and entering new network namespace.
@@ -3294,17 +3296,18 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 	 * reload process so the notifications are generated separatelly.
 	 */
 
-	list_for_each_entry(param_item, &devlink->param_list, list)
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_DEL);
-	devlink_notify(devlink, DEVLINK_CMD_DEL);
+	if (!dest_net || net_eq(dest_net, curr_net))
+		return;
 
-	__devlink_net_set(devlink, dest_net);
+	if (new)
+		devlink_notify(devlink, DEVLINK_CMD_NEW);
 
-	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	cmd = new ? DEVLINK_CMD_PARAM_NEW : DEVLINK_CMD_PARAM_DEL;
 	list_for_each_entry(param_item, &devlink->param_list, list)
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_NEW);
+		devlink_param_notify(devlink, 0, param_item, cmd);
+
+	if (!new)
+		devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
 static bool devlink_reload_supported(const struct devlink_ops *ops)
@@ -3384,6 +3387,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 			  u32 *actions_performed, struct netlink_ext_ack *extack)
 {
 	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+	struct net *curr_net;
 	int err;
 
 	if (!devlink->reload_enabled)
@@ -3391,18 +3395,22 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
+
+	curr_net = devlink_net(devlink);
+	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
 	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
 	if (err)
 		return err;
 
-	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
-		devlink_reload_netns_change(devlink, dest_net);
+	if (dest_net && !net_eq(dest_net, curr_net))
+		__devlink_net_set(devlink, dest_net);
 
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
 		return err;
 
+	devlink_ns_change_notify(devlink, dest_net, curr_net, true);
 	WARN_ON(!(*actions_performed & BIT(action)));
 	/* Catch driver on updating the remote action within devlink reload */
 	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
@@ -3599,7 +3607,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 
 static void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
@@ -3608,7 +3616,7 @@ static void devlink_flash_update_begin_notify(struct devlink *devlink)
 
 static void devlink_flash_update_end_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 92282de54230..1bf602f30ce4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -211,8 +211,6 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 int dsa_port_bridge_flags(const struct dsa_port *dp,
 			  struct switchdev_brport_flags flags,
 			  struct netlink_ext_ack *extack);
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6379d66a6bb3..c3ffbd41331a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -186,10 +186,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	err = dsa_port_ageing_time(dp, br_get_ageing_time(br));
 	if (err && err != -EOPNOTSUPP)
 		return err;
@@ -235,12 +231,6 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 
-	/* Some drivers treat the notification for having a local multicast
-	 * router by allowing multicast to be flooded to the CPU, so we should
-	 * allow this in standalone mode too.
-	 */
-	dsa_port_mrouter(dp->cpu_dp, true, NULL);
-
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
 	 */
@@ -555,17 +545,6 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
 	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
 }
 
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->port_set_mrouter)
-		return -EOPNOTSUPP;
-
-	return ds->ops->port_set_mrouter(ds, dp->index, mrouter, extack);
-}
-
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool propagate_upstream)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4756b920108..5882159137ea 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -311,12 +311,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
-			return -EOPNOTSUPP;
-
-		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d8811e1fbd6c..f495fad73be9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -586,18 +586,25 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 	}
 }
 
-static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
+static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 {
-	struct fib_nh_exception *fnhe, *oldest;
+	struct fib_nh_exception __rcu **fnhe_p, **oldest_p;
+	struct fib_nh_exception *fnhe, *oldest = NULL;
 
-	oldest = rcu_dereference(hash->chain);
-	for (fnhe = rcu_dereference(oldest->fnhe_next); fnhe;
-	     fnhe = rcu_dereference(fnhe->fnhe_next)) {
-		if (time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp))
+	for (fnhe_p = &hash->chain; ; fnhe_p = &fnhe->fnhe_next) {
+		fnhe = rcu_dereference_protected(*fnhe_p,
+						 lockdep_is_held(&fnhe_lock));
+		if (!fnhe)
+			break;
+		if (!oldest ||
+		    time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp)) {
 			oldest = fnhe;
+			oldest_p = fnhe_p;
+		}
 	}
 	fnhe_flush_routes(oldest);
-	return oldest;
+	*oldest_p = oldest->fnhe_next;
+	kfree_rcu(oldest, rcu);
 }
 
 static u32 fnhe_hashfun(__be32 daddr)
@@ -676,16 +683,21 @@ static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
 		if (rt)
 			fill_route_from_fnhe(rt, fnhe);
 	} else {
-		if (depth > FNHE_RECLAIM_DEPTH)
-			fnhe = fnhe_oldest(hash);
-		else {
-			fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
-			if (!fnhe)
-				goto out_unlock;
-
-			fnhe->fnhe_next = hash->chain;
-			rcu_assign_pointer(hash->chain, fnhe);
+		/* Randomize max depth to avoid some side channels attacks. */
+		int max_depth = FNHE_RECLAIM_DEPTH +
+				prandom_u32_max(FNHE_RECLAIM_DEPTH);
+
+		while (depth > max_depth) {
+			fnhe_remove_oldest(hash);
+			depth--;
 		}
+
+		fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
+		if (!fnhe)
+			goto out_unlock;
+
+		fnhe->fnhe_next = hash->chain;
+
 		fnhe->fnhe_genid = genid;
 		fnhe->fnhe_daddr = daddr;
 		fnhe->fnhe_gw = gw;
@@ -693,6 +705,8 @@ static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
 		fnhe->fnhe_mtu_locked = lock;
 		fnhe->fnhe_expires = max(1UL, expires);
 
+		rcu_assign_pointer(hash->chain, fnhe);
+
 		/* Exception created; mark the cached routes for the nexthop
 		 * stale, so anyone caching it rechecks if this exception
 		 * applies to them.
@@ -3047,7 +3061,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
 		udph = skb_put_zero(skb, sizeof(struct udphdr));
 		udph->source = sport;
 		udph->dest = dport;
-		udph->len = sizeof(struct udphdr);
+		udph->len = htons(sizeof(struct udphdr));
 		udph->check = 0;
 		break;
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8bb5f7f51dae..7f3c7d57a39d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2440,6 +2440,7 @@ static void *tcp_get_idx(struct seq_file *seq, loff_t pos)
 static void *tcp_seek_last_pos(struct seq_file *seq)
 {
 	struct tcp_iter_state *st = seq->private;
+	int bucket = st->bucket;
 	int offset = st->offset;
 	int orig_num = st->num;
 	void *rc = NULL;
@@ -2450,7 +2451,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 			break;
 		st->state = TCP_SEQ_STATE_LISTENING;
 		rc = listening_get_next(seq, NULL);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = listening_get_next(seq, rc);
 		if (rc)
 			break;
@@ -2461,7 +2462,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 		if (st->bucket > tcp_hashinfo.ehash_mask)
 			break;
 		rc = established_get_first(seq);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = established_get_next(seq, rc);
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 67c74469503a..cd99de5b6882 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1657,6 +1657,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
 	struct fib6_nh *nh = res->nh;
+	int max_depth;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
@@ -1711,7 +1712,9 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	bucket->depth++;
 	net->ipv6.rt6_stats->fib_rt_cache++;
 
-	if (bucket->depth > FIB6_MAX_DEPTH)
+	/* Randomize max depth to avoid some side channels attacks. */
+	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
+	while (bucket->depth > max_depth)
 		rt6_exception_remove_oldest(bucket);
 
 out:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2651498d05e8..e61c320974ba 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3210,7 +3210,9 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
 		return true;
 
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(*amsdu_hdr)))
+	if (!ieee80211_amsdu_realloc_pad(local, skb,
+					 sizeof(*amsdu_hdr) +
+					 local->hw.extra_tx_headroom))
 		return false;
 
 	data = skb_push(skb, sizeof(*amsdu_hdr));
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 4f50a64315cf..50f40943c815 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -187,14 +187,14 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 	doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.local == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
 	}
 	doi_def->map.std->lvl.cipso = kcalloc(doi_def->map.std->lvl.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.cipso == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
@@ -263,7 +263,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.local = kcalloc(
 					      doi_def->map.std->cat.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.local == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
@@ -271,7 +271,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.cipso = kcalloc(
 					      doi_def->map.std->cat.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.cipso == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 52b7f6490d24..2e732ea2b82f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (!size || len != ALIGN(size, 4) + hdrlen)
+	if (!size || size & 3 || len != size + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
@@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
 		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		const struct qrtr_ctrl_pkt *pkt;
 
+		if (size < sizeof(*pkt))
+			goto err;
+
+		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
 
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index b79a7e27bb31..38a3a8394bbd 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1614,7 +1614,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8827987ba903..11bc6bf35f84 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -125,6 +125,7 @@ struct htb_class {
 		struct htb_class_leaf {
 			int		deficit[TC_HTB_MAXDEPTH];
 			struct Qdisc	*q;
+			struct netdev_queue *offload_queue;
 		} leaf;
 		struct htb_class_inner {
 			struct htb_prio clprio[TC_HTB_NUMPRIO];
@@ -1376,24 +1377,47 @@ htb_graft_helper(struct netdev_queue *dev_queue, struct Qdisc *new_q)
 	return old_q;
 }
 
-static void htb_offload_move_qdisc(struct Qdisc *sch, u16 qid_old, u16 qid_new)
+static struct netdev_queue *htb_offload_get_queue(struct htb_class *cl)
+{
+	struct netdev_queue *queue;
+
+	queue = cl->leaf.offload_queue;
+	if (!(cl->leaf.q->flags & TCQ_F_BUILTIN))
+		WARN_ON(cl->leaf.q->dev_queue != queue);
+
+	return queue;
+}
+
+static void htb_offload_move_qdisc(struct Qdisc *sch, struct htb_class *cl_old,
+				   struct htb_class *cl_new, bool destroying)
 {
 	struct netdev_queue *queue_old, *queue_new;
 	struct net_device *dev = qdisc_dev(sch);
-	struct Qdisc *qdisc;
 
-	queue_old = netdev_get_tx_queue(dev, qid_old);
-	queue_new = netdev_get_tx_queue(dev, qid_new);
+	queue_old = htb_offload_get_queue(cl_old);
+	queue_new = htb_offload_get_queue(cl_new);
 
-	if (dev->flags & IFF_UP)
-		dev_deactivate(dev);
-	qdisc = dev_graft_qdisc(queue_old, NULL);
-	qdisc->dev_queue = queue_new;
-	qdisc = dev_graft_qdisc(queue_new, qdisc);
-	if (dev->flags & IFF_UP)
-		dev_activate(dev);
+	if (!destroying) {
+		struct Qdisc *qdisc;
 
-	WARN_ON(!(qdisc->flags & TCQ_F_BUILTIN));
+		if (dev->flags & IFF_UP)
+			dev_deactivate(dev);
+		qdisc = dev_graft_qdisc(queue_old, NULL);
+		WARN_ON(qdisc != cl_old->leaf.q);
+	}
+
+	if (!(cl_old->leaf.q->flags & TCQ_F_BUILTIN))
+		cl_old->leaf.q->dev_queue = queue_new;
+	cl_old->leaf.offload_queue = queue_new;
+
+	if (!destroying) {
+		struct Qdisc *qdisc;
+
+		qdisc = dev_graft_qdisc(queue_new, cl_old->leaf.q);
+		if (dev->flags & IFF_UP)
+			dev_activate(dev);
+		WARN_ON(!(qdisc->flags & TCQ_F_BUILTIN));
+	}
 }
 
 static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
@@ -1407,10 +1431,8 @@ static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
 	if (cl->level)
 		return -EINVAL;
 
-	if (q->offload) {
-		dev_queue = new->dev_queue;
-		WARN_ON(dev_queue != cl->leaf.q->dev_queue);
-	}
+	if (q->offload)
+		dev_queue = htb_offload_get_queue(cl);
 
 	if (!new) {
 		new = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
@@ -1479,6 +1501,8 @@ static void htb_parent_to_leaf(struct Qdisc *sch, struct htb_class *cl,
 	parent->ctokens = parent->cbuffer;
 	parent->t_c = ktime_get_ns();
 	parent->cmode = HTB_CAN_SEND;
+	if (q->offload)
+		parent->leaf.offload_queue = cl->leaf.offload_queue;
 }
 
 static void htb_parent_to_leaf_offload(struct Qdisc *sch,
@@ -1499,6 +1523,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 				     struct netlink_ext_ack *extack)
 {
 	struct tc_htb_qopt_offload offload_opt;
+	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
 	struct Qdisc *old = NULL;
 	int err;
@@ -1507,16 +1532,15 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		return -EINVAL;
 
 	WARN_ON(!q);
-	if (!destroying) {
-		/* On destroy of HTB, two cases are possible:
-		 * 1. q is a normal qdisc, but q->dev_queue has noop qdisc.
-		 * 2. q is a noop qdisc (for nodes that were inner),
-		 *    q->dev_queue is noop_netdev_queue.
+	dev_queue = htb_offload_get_queue(cl);
+	old = htb_graft_helper(dev_queue, NULL);
+	if (destroying)
+		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
+		 * all queues.
 		 */
-		old = htb_graft_helper(q->dev_queue, NULL);
-		WARN_ON(!old);
+		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
+	else
 		WARN_ON(old != q);
-	}
 
 	if (cl->parent) {
 		cl->parent->bstats_bias.bytes += q->bstats.bytes;
@@ -1535,18 +1559,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	if (!err || destroying)
 		qdisc_put(old);
 	else
-		htb_graft_helper(q->dev_queue, old);
+		htb_graft_helper(dev_queue, old);
 
 	if (last_child)
 		return err;
 
-	if (!err && offload_opt.moved_qid != 0) {
-		if (destroying)
-			q->dev_queue = netdev_get_tx_queue(qdisc_dev(sch),
-							   offload_opt.qid);
-		else
-			htb_offload_move_qdisc(sch, offload_opt.moved_qid,
-					       offload_opt.qid);
+	if (!err && offload_opt.classid != TC_H_MIN(cl->common.classid)) {
+		u32 classid = TC_H_MAJ(sch->handle) |
+			      TC_H_MIN(offload_opt.classid);
+		struct htb_class *moved_cl = htb_find(classid, sch);
+
+		htb_offload_move_qdisc(sch, moved_cl, cl, destroying);
 	}
 
 	return err;
@@ -1669,9 +1692,11 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 	}
 
 	if (last_child) {
-		struct netdev_queue *dev_queue;
+		struct netdev_queue *dev_queue = sch->dev_queue;
+
+		if (q->offload)
+			dev_queue = htb_offload_get_queue(cl);
 
-		dev_queue = q->offload ? cl->leaf.q->dev_queue : sch->dev_queue;
 		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  cl->parent->common.classid,
 					  NULL);
@@ -1843,7 +1868,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
 		} else { /* First child. */
-			dev_queue = parent->leaf.q->dev_queue;
+			dev_queue = htb_offload_get_queue(parent);
 			old_q = htb_graft_helper(dev_queue, NULL);
 			WARN_ON(old_q != parent->leaf.q);
 			offload_opt = (struct tc_htb_qopt_offload) {
@@ -1900,6 +1925,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 
 		/* leaf (we) needs elementary qdisc */
 		cl->leaf.q = new_q ? new_q : &noop_qdisc;
+		if (q->offload)
+			cl->leaf.offload_queue = dev_queue;
 
 		cl->parent = parent;
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 0de918cb3d90..a47e290b0668 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1629,6 +1629,21 @@ u32 svc_max_payload(const struct svc_rqst *rqstp)
 }
 EXPORT_SYMBOL_GPL(svc_max_payload);
 
+/**
+ * svc_proc_name - Return RPC procedure name in string form
+ * @rqstp: svc_rqst to operate on
+ *
+ * Return value:
+ *   Pointer to a NUL-terminated string
+ */
+const char *svc_proc_name(const struct svc_rqst *rqstp)
+{
+	if (rqstp && rqstp->rq_procinfo)
+		return rqstp->rq_procinfo->pc_name;
+	return "unknown";
+}
+
+
 /**
  * svc_encode_result_payload - mark a range of bytes as a result payload
  * @rqstp: svc_rqst to operate on
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 576411612523..c7d7d3586730 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -831,7 +831,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index ddce876635aa..507c1143eb96 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -13,13 +13,15 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -62,8 +64,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 4a65fe2fcee9..160143ebcdd0 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -17,14 +17,16 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -52,8 +54,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 
     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"
 
     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 12e9250c1bec..9e72edb8d31a 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -6,7 +6,6 @@ config IMA
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
-	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML
diff --git a/security/integrity/ima/ima_mok.c b/security/integrity/ima/ima_mok.c
index 1e5c01916173..95cc31525c57 100644
--- a/security/integrity/ima/ima_mok.c
+++ b/security/integrity/ima/ima_mok.c
@@ -21,7 +21,7 @@ struct key *ima_blacklist_keyring;
 /*
  * Allocate the IMA blacklist keyring
  */
-__init int ima_mok_init(void)
+static __init int ima_mok_init(void)
 {
 	struct key_restriction *restriction;
 
diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index cd964e023d96..b9d5d7a0975b 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -117,6 +117,13 @@ static struct snd_soc_dai_driver rt5682_dai[] = {
 	},
 };
 
+static void rt5682_i2c_disable_regulators(void *data)
+{
+	struct rt5682_priv *rt5682 = data;
+
+	regulator_bulk_disable(ARRAY_SIZE(rt5682->supplies), rt5682->supplies);
+}
+
 static int rt5682_i2c_probe(struct i2c_client *i2c,
 		const struct i2c_device_id *id)
 {
@@ -157,6 +164,11 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	ret = devm_add_action_or_reset(&i2c->dev, rt5682_i2c_disable_regulators,
+				       rt5682);
+	if (ret)
+		return ret;
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(rt5682->supplies),
 				    rt5682->supplies);
 	if (ret) {
@@ -280,6 +292,13 @@ static void rt5682_i2c_shutdown(struct i2c_client *client)
 	rt5682_reset(rt5682);
 }
 
+static int rt5682_i2c_remove(struct i2c_client *client)
+{
+	rt5682_i2c_shutdown(client);
+
+	return 0;
+}
+
 static const struct of_device_id rt5682_of_match[] = {
 	{.compatible = "realtek,rt5682i"},
 	{},
@@ -306,6 +325,7 @@ static struct i2c_driver rt5682_i2c_driver = {
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe = rt5682_i2c_probe,
+	.remove = rt5682_i2c_remove,
 	.shutdown = rt5682_i2c_shutdown,
 	.id_table = rt5682_i2c_id,
 };
diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 86c92e03ea5d..d885ced34f60 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -4076,6 +4076,16 @@ static int wcd9335_setup_irqs(struct wcd9335_codec *wcd)
 	return ret;
 }
 
+static void wcd9335_teardown_irqs(struct wcd9335_codec *wcd)
+{
+	int i;
+
+	/* disable interrupts on all slave ports */
+	for (i = 0; i < WCD9335_SLIM_NUM_PORT_REG; i++)
+		regmap_write(wcd->if_regmap, WCD9335_SLIM_PGD_PORT_INT_EN0 + i,
+			     0x00);
+}
+
 static void wcd9335_cdc_sido_ccl_enable(struct wcd9335_codec *wcd,
 					bool ccl_flag)
 {
@@ -4844,6 +4854,7 @@ static void wcd9335_codec_init(struct snd_soc_component *component)
 static int wcd9335_codec_probe(struct snd_soc_component *component)
 {
 	struct wcd9335_codec *wcd = dev_get_drvdata(component->dev);
+	int ret;
 	int i;
 
 	snd_soc_component_init_regmap(component, wcd->regmap);
@@ -4861,7 +4872,15 @@ static int wcd9335_codec_probe(struct snd_soc_component *component)
 	for (i = 0; i < NUM_CODEC_DAIS; i++)
 		INIT_LIST_HEAD(&wcd->dai[i].slim_ch_list);
 
-	return wcd9335_setup_irqs(wcd);
+	ret = wcd9335_setup_irqs(wcd);
+	if (ret)
+		goto free_clsh_ctrl;
+
+	return 0;
+
+free_clsh_ctrl:
+	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
+	return ret;
 }
 
 static void wcd9335_codec_remove(struct snd_soc_component *comp)
@@ -4869,7 +4888,7 @@ static void wcd9335_codec_remove(struct snd_soc_component *comp)
 	struct wcd9335_codec *wcd = dev_get_drvdata(comp->dev);
 
 	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
-	free_irq(regmap_irq_get_virq(wcd->irq_data, WCD9335_IRQ_SLIMBUS), wcd);
+	wcd9335_teardown_irqs(wcd);
 }
 
 static int wcd9335_codec_set_sysclk(struct snd_soc_component *comp,
diff --git a/sound/soc/fsl/fsl_rpmsg.c b/sound/soc/fsl/fsl_rpmsg.c
index ea5c973e2e84..d60f4dac6c1b 100644
--- a/sound/soc/fsl/fsl_rpmsg.c
+++ b/sound/soc/fsl/fsl_rpmsg.c
@@ -165,25 +165,25 @@ static int fsl_rpmsg_probe(struct platform_device *pdev)
 	}
 
 	/* Get the optional clocks */
-	rpmsg->ipg = devm_clk_get(&pdev->dev, "ipg");
+	rpmsg->ipg = devm_clk_get_optional(&pdev->dev, "ipg");
 	if (IS_ERR(rpmsg->ipg))
-		rpmsg->ipg = NULL;
+		return PTR_ERR(rpmsg->ipg);
 
-	rpmsg->mclk = devm_clk_get(&pdev->dev, "mclk");
+	rpmsg->mclk = devm_clk_get_optional(&pdev->dev, "mclk");
 	if (IS_ERR(rpmsg->mclk))
-		rpmsg->mclk = NULL;
+		return PTR_ERR(rpmsg->mclk);
 
-	rpmsg->dma = devm_clk_get(&pdev->dev, "dma");
+	rpmsg->dma = devm_clk_get_optional(&pdev->dev, "dma");
 	if (IS_ERR(rpmsg->dma))
-		rpmsg->dma = NULL;
+		return PTR_ERR(rpmsg->dma);
 
-	rpmsg->pll8k = devm_clk_get(&pdev->dev, "pll8k");
+	rpmsg->pll8k = devm_clk_get_optional(&pdev->dev, "pll8k");
 	if (IS_ERR(rpmsg->pll8k))
-		rpmsg->pll8k = NULL;
+		return PTR_ERR(rpmsg->pll8k);
 
-	rpmsg->pll11k = devm_clk_get(&pdev->dev, "pll11k");
+	rpmsg->pll11k = devm_clk_get_optional(&pdev->dev, "pll11k");
 	if (IS_ERR(rpmsg->pll11k))
-		rpmsg->pll11k = NULL;
+		return PTR_ERR(rpmsg->pll11k);
 
 	platform_set_drvdata(pdev, rpmsg);
 	pm_runtime_enable(&pdev->dev);
diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
index 4b7b4a044f81..255f8df09d84 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98927.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
@@ -199,7 +199,7 @@ static int kabylake_ssp0_hw_params(struct snd_pcm_substream *substream,
 		}
 		if (!strcmp(codec_dai->component->name, MAX98373_DEV0_NAME)) {
 			ret = snd_soc_dai_set_tdm_slot(codec_dai,
-							0x03, 3, 8, 24);
+							0x30, 3, 8, 16);
 			if (ret < 0) {
 				dev_err(runtime->dev,
 						"DEV0 TDM slot err:%d\n", ret);
@@ -208,10 +208,10 @@ static int kabylake_ssp0_hw_params(struct snd_pcm_substream *substream,
 		}
 		if (!strcmp(codec_dai->component->name, MAX98373_DEV1_NAME)) {
 			ret = snd_soc_dai_set_tdm_slot(codec_dai,
-							0x0C, 3, 8, 24);
+							0xC0, 3, 8, 16);
 			if (ret < 0) {
 				dev_err(runtime->dev,
-						"DEV0 TDM slot err:%d\n", ret);
+						"DEV1 TDM slot err:%d\n", ret);
 				return ret;
 			}
 		}
@@ -311,24 +311,6 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	 * The above 2 loops are mutually exclusive based on the stream direction,
 	 * thus rtd_dpcm variable will never be overwritten
 	 */
-	/*
-	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE,
-	 * where as kblda7219m98927 & kblmax98927 supports S16_LE by default.
-	 * Skipping the port wise FE and BE configuration for kblda7219m98373 &
-	 * kblmax98373 as the topology (FE & BE) supports S24_LE only.
-	 */
-
-	if (!strcmp(rtd->card->name, "kblda7219m98373") ||
-		!strcmp(rtd->card->name, "kblmax98373")) {
-		/* The ADSP will convert the FE rate to 48k, stereo */
-		rate->min = rate->max = 48000;
-		chan->min = chan->max = DUAL_CHANNEL;
-
-		/* set SSP to 24 bit */
-		snd_mask_none(fmt);
-		snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S24_LE);
-		return 0;
-	}
 
 	/*
 	 * The ADSP will convert the FE rate to 48k, stereo, 24 bit
@@ -479,31 +461,20 @@ static struct snd_pcm_hw_constraint_list constraints_channels_quad = {
 static int kbl_fe_startup(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_rt = asoc_substream_to_rtd(substream);
 
 	/*
 	 * On this platform for PCM device we support,
 	 * 48Khz
 	 * stereo
+	 * 16 bit audio
 	 */
 
 	runtime->hw.channels_max = DUAL_CHANNEL;
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 					   &constraints_channels);
-	/*
-	 * Setup S24_LE (32 bit container and 24 bit valid data) for
-	 * kblda7219m98373 & kblmax98373. For kblda7219m98927 &
-	 * kblmax98927 keeping it as 16/16 due to topology FW dependency.
-	 */
-	if (!strcmp(soc_rt->card->name, "kblda7219m98373") ||
-		!strcmp(soc_rt->card->name, "kblmax98373")) {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S24_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
-
-	} else {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
-	}
+
+	runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
+	snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
 
 	snd_pcm_hw_constraint_list(runtime, 0,
 				SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
@@ -536,23 +507,11 @@ static int kabylake_dmic_fixup(struct snd_soc_pcm_runtime *rtd,
 static int kabylake_dmic_startup(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_rt = asoc_substream_to_rtd(substream);
 
 	runtime->hw.channels_min = runtime->hw.channels_max = QUAD_CHANNEL;
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 			&constraints_channels_quad);
 
-	/*
-	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE.
-	 * The DMIC also configured for S24_LE. Forcing the DMIC format to
-	 * S24_LE due to the topology FW dependency.
-	 */
-	if (!strcmp(soc_rt->card->name, "kblda7219m98373") ||
-		!strcmp(soc_rt->card->name, "kblmax98373")) {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S24_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
-	}
-
 	return snd_pcm_hw_constraint_list(substream->runtime, 0,
 			SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
 }
diff --git a/sound/soc/intel/common/soc-acpi-intel-cml-match.c b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
index 7f6ef8229969..4d7a181fb8e6 100644
--- a/sound/soc/intel/common/soc-acpi-intel-cml-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
@@ -75,7 +75,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_cml_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "cml_da7219_max98357a",
+		.drv_name = "cml_da7219_mx98357a",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &max98390_spk_codecs,
 		.sof_fw_filename = "sof-cml.ri",
diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
index ba5ff468c265..741bf2f9e081 100644
--- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
@@ -87,7 +87,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_max98357a",
+		.drv_name = "kbl_da7219_mx98357a",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98357_codecs,
diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index c0fdab39e7c2..09037d555ec4 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -113,7 +113,7 @@ static int is_skl_dsp_widget_type(struct snd_soc_dapm_widget *w,
 
 static void skl_dump_mconfig(struct skl_dev *skl, struct skl_module_cfg *mcfg)
 {
-	struct skl_module_iface *iface = &mcfg->module->formats[0];
+	struct skl_module_iface *iface = &mcfg->module->formats[mcfg->fmt_idx];
 
 	dev_dbg(skl->dev, "Dumping config\n");
 	dev_dbg(skl->dev, "Input Format:\n");
@@ -195,8 +195,8 @@ static void skl_tplg_update_params_fixup(struct skl_module_cfg *m_cfg,
 	struct skl_module_fmt *in_fmt, *out_fmt;
 
 	/* Fixups will be applied to pin 0 only */
-	in_fmt = &m_cfg->module->formats[0].inputs[0].fmt;
-	out_fmt = &m_cfg->module->formats[0].outputs[0].fmt;
+	in_fmt = &m_cfg->module->formats[m_cfg->fmt_idx].inputs[0].fmt;
+	out_fmt = &m_cfg->module->formats[m_cfg->fmt_idx].outputs[0].fmt;
 
 	if (params->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		if (is_fe) {
@@ -239,9 +239,9 @@ static void skl_tplg_update_buffer_size(struct skl_dev *skl,
 	/* Since fixups is applied to pin 0 only, ibs, obs needs
 	 * change for pin 0 only
 	 */
-	res = &mcfg->module->resources[0];
-	in_fmt = &mcfg->module->formats[0].inputs[0].fmt;
-	out_fmt = &mcfg->module->formats[0].outputs[0].fmt;
+	res = &mcfg->module->resources[mcfg->res_idx];
+	in_fmt = &mcfg->module->formats[mcfg->fmt_idx].inputs[0].fmt;
+	out_fmt = &mcfg->module->formats[mcfg->fmt_idx].outputs[0].fmt;
 
 	if (mcfg->m_type == SKL_MODULE_TYPE_SRCINT)
 		multiplier = 5;
@@ -1463,12 +1463,6 @@ static int skl_tplg_tlv_control_set(struct snd_kcontrol *kcontrol,
 	struct skl_dev *skl = get_skl_ctx(w->dapm->dev);
 
 	if (ac->params) {
-		/*
-		 * Widget data is expected to be stripped of T and L
-		 */
-		size -= 2 * sizeof(unsigned int);
-		data += 2;
-
 		if (size > ac->max)
 			return -EINVAL;
 		ac->size = size;
@@ -1637,11 +1631,12 @@ int skl_tplg_update_pipe_params(struct device *dev,
 			struct skl_module_cfg *mconfig,
 			struct skl_pipe_params *params)
 {
-	struct skl_module_res *res = &mconfig->module->resources[0];
+	struct skl_module_res *res;
 	struct skl_dev *skl = get_skl_ctx(dev);
 	struct skl_module_fmt *format = NULL;
 	u8 cfg_idx = mconfig->pipe->cur_config_idx;
 
+	res = &mconfig->module->resources[mconfig->res_idx];
 	skl_tplg_fill_dma_id(mconfig, params);
 	mconfig->fmt_idx = mconfig->mod_cfg[cfg_idx].fmt_idx;
 	mconfig->res_idx = mconfig->mod_cfg[cfg_idx].res_idx;
@@ -1650,9 +1645,9 @@ int skl_tplg_update_pipe_params(struct device *dev,
 		return 0;
 
 	if (params->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		format = &mconfig->module->formats[0].inputs[0].fmt;
+		format = &mconfig->module->formats[mconfig->fmt_idx].inputs[0].fmt;
 	else
-		format = &mconfig->module->formats[0].outputs[0].fmt;
+		format = &mconfig->module->formats[mconfig->fmt_idx].outputs[0].fmt;
 
 	/* set the hw_params */
 	format->s_freq = params->s_freq;
diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
index c4a598cbbdaa..14e77df06b01 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -1119,25 +1119,26 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->regmap = syscon_node_to_regmap(dev->parent->of_node);
 	if (IS_ERR(afe->regmap)) {
 		dev_err(dev, "could not get regmap from parent\n");
-		return PTR_ERR(afe->regmap);
+		ret = PTR_ERR(afe->regmap);
+		goto err_pm_disable;
 	}
 	ret = regmap_attach_dev(dev, afe->regmap, &mt8183_afe_regmap_config);
 	if (ret) {
 		dev_warn(dev, "regmap_attach_dev fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	rstc = devm_reset_control_get(dev, "audiosys");
 	if (IS_ERR(rstc)) {
 		ret = PTR_ERR(rstc);
 		dev_err(dev, "could not get audiosys reset:%d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = reset_control_reset(rstc);
 	if (ret) {
 		dev_err(dev, "failed to trigger audio reset:%d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* enable clock for regcache get default value from hw */
@@ -1147,7 +1148,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	ret = regmap_reinit_cache(afe->regmap, &mt8183_afe_regmap_config);
 	if (ret) {
 		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	pm_runtime_put_sync(&pdev->dev);
@@ -1160,8 +1161,10 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->memif_size = MT8183_MEMIF_NUM;
 	afe->memif = devm_kcalloc(dev, afe->memif_size, sizeof(*afe->memif),
 				  GFP_KERNEL);
-	if (!afe->memif)
-		return -ENOMEM;
+	if (!afe->memif) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->memif_size; i++) {
 		afe->memif[i].data = &memif_data[i];
@@ -1178,22 +1181,26 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->irqs_size = MT8183_IRQ_NUM;
 	afe->irqs = devm_kcalloc(dev, afe->irqs_size, sizeof(*afe->irqs),
 				 GFP_KERNEL);
-	if (!afe->irqs)
-		return -ENOMEM;
+	if (!afe->irqs) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->irqs_size; i++)
 		afe->irqs[i].irq_data = &irq_data[i];
 
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id < 0)
-		return irq_id;
+	if (irq_id < 0) {
+		ret = irq_id;
+		goto err_pm_disable;
+	}
 
 	ret = devm_request_irq(dev, irq_id, mt8183_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
 	if (ret) {
 		dev_err(dev, "could not request_irq for asys-isr\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* init sub_dais */
@@ -1204,7 +1211,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_warn(afe->dev, "dai register i %d fail, ret %d\n",
 				 i, ret);
-			return ret;
+			goto err_pm_disable;
 		}
 	}
 
@@ -1213,7 +1220,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_warn(afe->dev, "mtk_afe_combine_sub_dai fail, ret %d\n",
 			 ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	afe->mtk_afe_hardware = &mt8183_afe_hardware;
@@ -1229,7 +1236,7 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 					      NULL, 0);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = devm_snd_soc_register_component(afe->dev,
@@ -1238,10 +1245,14 @@ static int mt8183_afe_pcm_dev_probe(struct platform_device *pdev)
 					      afe->num_dai_drivers);
 	if (ret) {
 		dev_warn(dev, "err_dai_component\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return ret;
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static int mt8183_afe_pcm_dev_remove(struct platform_device *pdev)
diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index 7a1724f5ff4c..31c280339c50 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2229,12 +2229,13 @@ static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->regmap = syscon_node_to_regmap(dev->parent->of_node);
 	if (IS_ERR(afe->regmap)) {
 		dev_err(dev, "could not get regmap from parent\n");
-		return PTR_ERR(afe->regmap);
+		ret = PTR_ERR(afe->regmap);
+		goto err_pm_disable;
 	}
 	ret = regmap_attach_dev(dev, afe->regmap, &mt8192_afe_regmap_config);
 	if (ret) {
 		dev_warn(dev, "regmap_attach_dev fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* enable clock for regcache get default value from hw */
@@ -2244,7 +2245,7 @@ static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 	ret = regmap_reinit_cache(afe->regmap, &mt8192_afe_regmap_config);
 	if (ret) {
 		dev_err(dev, "regmap_reinit_cache fail, ret %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	pm_runtime_put_sync(&pdev->dev);
@@ -2257,8 +2258,10 @@ static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->memif_size = MT8192_MEMIF_NUM;
 	afe->memif = devm_kcalloc(dev, afe->memif_size, sizeof(*afe->memif),
 				  GFP_KERNEL);
-	if (!afe->memif)
-		return -ENOMEM;
+	if (!afe->memif) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->memif_size; i++) {
 		afe->memif[i].data = &memif_data[i];
@@ -2272,22 +2275,26 @@ static int mt8192_afe_pcm_dev_probe(struct platform_device *pdev)
 	afe->irqs_size = MT8192_IRQ_NUM;
 	afe->irqs = devm_kcalloc(dev, afe->irqs_size, sizeof(*afe->irqs),
 				 GFP_KERNEL);
-	if (!afe->irqs)
-		return -ENOMEM;
+	if (!afe->irqs) {
+		ret = -ENOMEM;
+		goto err_pm_disable;
+	}
 
 	for (i = 0; i < afe->irqs_size; i++)
 		afe->irqs[i].irq_data = &irq_data[i];
 
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id < 0)
-		return irq_id;
+	if (irq_id < 0) {
+		ret = irq_id;
+		goto err_pm_disable;
+	}
 
 	ret = devm_request_irq(dev, irq_id, mt8192_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
 	if (ret) {
 		dev_err(dev, "could not request_irq for Afe_ISR_Handle\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* init sub_dais */
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index da4846c9856a..a51bf4c69879 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -778,6 +778,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		kernel_syms_destroy(&dd);
 	}
 
+	btf__free(btf);
+
 	return 0;
 }
 
@@ -1897,8 +1899,8 @@ static char *profile_target_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -1922,6 +1924,7 @@ static char *profile_target_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ec6d85a81744..353f06cf210e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3222,7 +3222,7 @@ union bpf_attr {
  * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
- *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY** *map*.
  *		It checks the selected socket is matching the incoming
  *		request in the socket buffer.
  *	Return
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index e43e1896cb4b..0d9d8ed6512b 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -4,8 +4,9 @@
 RM ?= rm
 srctree = $(abs_srctree)
 
+VERSION_SCRIPT := libbpf.map
 LIBBPF_VERSION := $(shell \
-	grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
+	grep -oE '^LIBBPF_([0-9.]+)' $(VERSION_SCRIPT) | \
 	sort -rV | head -n1 | cut -d'_' -f2)
 LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
 
@@ -110,7 +111,6 @@ SHARED_OBJDIR	:= $(OUTPUT)sharedobjs/
 STATIC_OBJDIR	:= $(OUTPUT)staticobjs/
 BPF_IN_SHARED	:= $(SHARED_OBJDIR)libbpf-in.o
 BPF_IN_STATIC	:= $(STATIC_OBJDIR)libbpf-in.o
-VERSION_SCRIPT	:= libbpf.map
 BPF_HELPER_DEFS	:= $(OUTPUT)bpf_helper_defs.h
 
 LIB_TARGET	:= $(addprefix $(OUTPUT),$(LIB_TARGET))
@@ -163,10 +163,10 @@ $(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
-$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
+$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED) $(VERSION_SCRIPT)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) \
 		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -lz -o $@
+		-Wl,--version-script=$(VERSION_SCRIPT) $< -lelf -lz -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -181,7 +181,7 @@ $(OUTPUT)libbpf.pc:
 
 check: check_abi
 
-check_abi: $(OUTPUT)libbpf.so
+check_abi: $(OUTPUT)libbpf.so $(VERSION_SCRIPT)
 	@if [ "$(GLOBAL_SYM_COUNT)" != "$(VERSIONED_SYM_COUNT)" ]; then	 \
 		echo "Warning: Num of global symbols in $(BPF_IN_SHARED)"	 \
 		     "($(GLOBAL_SYM_COUNT)) does NOT match with num of"	 \
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c41d9b2b59ac..f6ebda75b030 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4409,6 +4409,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 {
 	struct bpf_create_map_attr create_attr;
 	struct bpf_map_def *def = &map->def;
+	int err = 0;
 
 	memset(&create_attr, 0, sizeof(create_attr));
 
@@ -4451,8 +4452,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 
 	if (bpf_map_type__is_map_in_map(def->type)) {
 		if (map->inner_map) {
-			int err;
-
 			err = bpf_object__create_map(obj, map->inner_map);
 			if (err) {
 				pr_warn("map '%s': failed to create inner map: %d\n",
@@ -4469,8 +4468,8 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
 		char *cp, errmsg[STRERR_BUFSIZE];
-		int err = -errno;
 
+		err = -errno;
 		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 		pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
 			map->name, cp, err);
@@ -4482,15 +4481,14 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 		map->fd = bpf_create_map_xattr(&create_attr);
 	}
 
-	if (map->fd < 0)
-		return -errno;
+	err = map->fd < 0 ? -errno : 0;
 
 	if (bpf_map_type__is_map_in_map(def->type) && map->inner_map) {
 		bpf_map__destroy(map->inner_map);
 		zfree(&map->inner_map);
 	}
 
-	return 0;
+	return err;
 }
 
 static int init_map_slots(struct bpf_map *map)
@@ -7365,8 +7363,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
 		obj->kconfig = strdup(kconfig);
-		if (!obj->kconfig)
-			return ERR_PTR(-ENOMEM);
+		if (!obj->kconfig) {
+			err = -ENOMEM;
+			goto out;
+		}
 	}
 
 	err = bpf_object__elf_init(obj);
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index cdecda1ddd36..17a9844e4fbf 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -296,7 +296,7 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 
 out:
 	free(info_linear);
-	free(btf);
+	btf__free(btf);
 	return err ? -1 : 0;
 }
 
@@ -486,7 +486,7 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	perf_env__fetch_btf(env, btf_id, btf);
 
 out:
-	free(btf);
+	btf__free(btf);
 	close(fd);
 }
 
diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index 5ed674a2f55e..a14f0098b343 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -74,8 +74,8 @@ static char *bpf_target_prog_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -99,6 +99,7 @@ static char *bpf_target_prog_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 0457ae32b270..5b7dd3227b78 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4384,6 +4384,7 @@ static void do_test_file(unsigned int test_num)
 	fprintf(stderr, "OK");
 
 done:
+	btf__free(btf);
 	free(func_info);
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
index 54380c5e1069..aa96b604b2b3 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -122,7 +122,7 @@ static int dump_tcp_sock(struct seq_file *seq, struct tcp_sock *tp,
 	}
 
 	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
-		       seq_num, src, srcp, destp, destp);
+		       seq_num, src, srcp, dest, destp);
 	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
 		       state,
 		       tp->write_seq - tp->snd_una, rx_queue,
diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/tools/testing/selftests/bpf/progs/test_core_autosize.c
index 44f5aa2e8956..9a7829c5e4a7 100644
--- a/tools/testing/selftests/bpf/progs/test_core_autosize.c
+++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
@@ -125,6 +125,16 @@ int handle_downsize(void *ctx)
 	return 0;
 }
 
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_core_read_int bpf_core_read
+#else
+#define bpf_core_read_int(dst, sz, src) ({ \
+	/* Prevent "subtraction from stack pointer prohibited" */ \
+	volatile long __off = sizeof(*dst) - (sz); \
+	bpf_core_read((char *)(dst) + __off, sz, src); \
+})
+#endif
+
 SEC("raw_tp/sys_enter")
 int handle_probed(void *ctx)
 {
@@ -132,23 +142,23 @@ int handle_probed(void *ctx)
 	__u64 tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
 	ptr_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val1), &in->val1);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val1), &in->val1);
 	val1_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val2), &in->val2);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val2), &in->val2);
 	val2_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val3), &in->val3);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val3), &in->val3);
 	val3_probed = tmp;
 
 	tmp = 0;
-	bpf_core_read(&tmp, bpf_core_field_size(in->val4), &in->val4);
+	bpf_core_read_int(&tmp, bpf_core_field_size(in->val4), &in->val4);
 	val4_probed = tmp;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 51adc42b2b40..aa38dc4a5e85 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -747,8 +747,8 @@ static void test_sockmap(unsigned int tasks, void *data)
 	udp = socket(AF_INET, SOCK_DGRAM, 0);
 	i = 0;
 	err = bpf_map_update_elem(fd, &i, &udp, BPF_ANY);
-	if (!err) {
-		printf("Failed socket SOCK_DGRAM allowed '%i:%i'\n",
+	if (err) {
+		printf("Failed socket update SOCK_DGRAM '%i:%i'\n",
 		       i, udp);
 		goto out_sockmap;
 	}
