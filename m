Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533C44B882B
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiBPMwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:52:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiBPMvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:51:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0E211C00;
        Wed, 16 Feb 2022 04:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E105BB81DB2;
        Wed, 16 Feb 2022 12:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5902C340EC;
        Wed, 16 Feb 2022 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645015880;
        bh=/fjXPg80nHOlYenvFaQoY7FHetCcCsovggGHIBbESj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipfJ5l3zSod0UV9dGwhLbyS8ruS4CVmGdwzumSflPNqm5s+34HuIjKSSRI+jKopRy
         CBw94deWR0P1Uu0cRbro1xJMxorS29wvxdKO8k301ED17lEgKRMSk69kqMr+NMwazy
         Nk/6PlrcIyYCx8vFe8KYQ3VzQ4AD8+qydtec+z9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.24
Date:   Wed, 16 Feb 2022 13:50:59 +0100
Message-Id: <1645015859194120@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1645015859182150@kroah.com>
References: <1645015859182150@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index e77635c5422c..fa8b31660cad 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -119,6 +119,9 @@ Boards (incomplete list of examples):
 - OMAP3 BeagleBoard : Low cost community board
   compatible = "ti,omap3-beagle", "ti,omap3430", "ti,omap3"
 
+- OMAP3 BeagleBoard A to B4 : Early BeagleBoard revisions A to B4 with a timer quirk
+  compatible = "ti,omap3-beagle-ab4", "ti,omap3-beagle", "ti,omap3430", "ti,omap3"
+
 - OMAP3 Tobi with Overo : Commercial expansion board with daughter board
   compatible = "gumstix,omap3-overo-tobi", "gumstix,omap3-overo", "ti,omap3430", "ti,omap3"
 
diff --git a/Makefile b/Makefile
index 74eafb2e60ab..c726a33e922f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 23
+SUBLEVEL = 24
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7e0934180724..27ca1ca6e827 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -779,6 +779,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += \
 	logicpd-som-lv-37xx-devkit.dtb \
 	omap3430-sdp.dtb \
 	omap3-beagle.dtb \
+	omap3-beagle-ab4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-beagle-xm-ab.dtb \
 	omap3-cm-t3517.dtb \
diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index 8cbaf1c81174..3b609d987d88 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -79,7 +79,6 @@ hog_pins_a: hog@0 {
 						MX23_PAD_LCD_RESET__GPIO_1_18
 						MX23_PAD_PWM3__GPIO_1_29
 						MX23_PAD_PWM4__GPIO_1_30
-						MX23_PAD_SSP1_DETECT__SSP1_DETECT
 					>;
 					fsl,drive-strength = <MXS_DRIVE_4mA>;
 					fsl,voltage = <MXS_VOLTAGE_HIGH>;
diff --git a/arch/arm/boot/dts/imx6qdl-udoo.dtsi b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
index d07d8f83456d..ccfa8e320be6 100644
--- a/arch/arm/boot/dts/imx6qdl-udoo.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
@@ -5,6 +5,8 @@
  * Author: Fabio Estevam <fabio.estevam@freescale.com>
  */
 
+#include <dt-bindings/gpio/gpio.h>
+
 / {
 	aliases {
 		backlight = &backlight;
@@ -226,6 +228,7 @@ MX6QDL_PAD_SD3_DAT0__SD3_DATA0		0x17059
 				MX6QDL_PAD_SD3_DAT1__SD3_DATA1		0x17059
 				MX6QDL_PAD_SD3_DAT2__SD3_DATA2		0x17059
 				MX6QDL_PAD_SD3_DAT3__SD3_DATA3		0x17059
+				MX6QDL_PAD_SD3_DAT5__GPIO7_IO00		0x1b0b0
 			>;
 		};
 
@@ -304,7 +307,7 @@ &usbotg {
 &usdhc3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usdhc3>;
-	non-removable;
+	cd-gpios = <&gpio7 0 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/imx7ulp.dtsi b/arch/arm/boot/dts/imx7ulp.dtsi
index b7ea37ad4e55..bcec98b96411 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -259,7 +259,7 @@ wdog1: watchdog@403d0000 {
 			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&pcc2 IMX7ULP_CLK_WDG1>;
 			assigned-clocks = <&pcc2 IMX7ULP_CLK_WDG1>;
-			assigned-clocks-parents = <&scg1 IMX7ULP_CLK_FIRC_BUS_CLK>;
+			assigned-clock-parents = <&scg1 IMX7ULP_CLK_FIRC_BUS_CLK>;
 			timeout-sec = <40>;
 		};
 
diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index 3be7cba603d5..26eaba3fa96f 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -59,7 +59,7 @@ hwrng: rng@8100 {
 			};
 
 			uart_A: serial@84c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84c0 0x18>;
 				interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>;
 				fifo-size = <128>;
@@ -67,7 +67,7 @@ uart_A: serial@84c0 {
 			};
 
 			uart_B: serial@84dc {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84dc 0x18>;
 				interrupts = <GIC_SPI 75 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -105,7 +105,7 @@ saradc: adc@8680 {
 			};
 
 			uart_C: serial@8700 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x8700 0x18>;
 				interrupts = <GIC_SPI 93 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -228,7 +228,7 @@ ir_receiver: ir-receiver@480 {
 			};
 
 			uart_AO: serial@4c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart";
 				reg = <0x4c0 0x18>;
 				interrupts = <GIC_SPI 90 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index f80ddc98d3a2..9997a5d0333a 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -736,27 +736,27 @@ &timer_abcde {
 };
 
 &uart_AO {
-	compatible = "amlogic,meson8-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_CLK81>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8-uart", "amlogic,meson-ao-uart";
+	clocks = <&xtal>, <&clkc CLKID_CLK81>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_A {
-	compatible = "amlogic,meson8-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART0>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_B {
-	compatible = "amlogic,meson8-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART1>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_C {
-	compatible = "amlogic,meson8-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART2>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &usb0 {
diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
index b49b7cbaed4e..94f1c03decce 100644
--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -724,27 +724,27 @@ &timer_abcde {
 };
 
 &uart_AO {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_CLK81>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart", "amlogic,meson-ao-uart";
+	clocks = <&xtal>, <&clkc CLKID_CLK81>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_A {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART0>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_B {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART1>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_C {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART2>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &usb0 {
diff --git a/arch/arm/boot/dts/omap3-beagle-ab4.dts b/arch/arm/boot/dts/omap3-beagle-ab4.dts
new file mode 100644
index 000000000000..990ff2d84686
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-beagle-ab4.dts
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/dts-v1/;
+
+#include "omap3-beagle.dts"
+
+/ {
+	model = "TI OMAP3 BeagleBoard A to B4";
+	compatible = "ti,omap3-beagle-ab4", "ti,omap3-beagle", "ti,omap3430", "ti,omap3";
+};
+
+/*
+ * Workaround for capacitor C70 issue, see "Boards revision A and < B5"
+ * section at https://elinux.org/BeagleBoard_Community
+ */
+
+/* Unusable as clocksource because of unreliable oscillator */
+&counter32k {
+	status = "disabled";
+};
+
+/* Unusable as clockevent because of unreliable oscillator, allow to idle */
+&timer1_target {
+	/delete-property/ti,no-reset-on-init;
+	/delete-property/ti,no-idle;
+	timer@0 {
+		/delete-property/ti,timer-alwon;
+	};
+};
+
+/* Preferred always-on timer for clocksource */
+&timer12_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		/* Always clocked by secure_32k_fck */
+	};
+};
+
+/* Preferred timer for clockevent */
+&timer2_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		assigned-clocks = <&gpt2_fck>;
+		assigned-clock-parents = <&sys_ck>;
+	};
+};
diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index f9f34b8458e9..0548b391334f 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -304,39 +304,6 @@ &usbhsehci {
 	phys = <0 &hsusb2_phy>;
 };
 
-/* Unusable as clocksource because of unreliable oscillator */
-&counter32k {
-	status = "disabled";
-};
-
-/* Unusable as clockevent because if unreliable oscillator, allow to idle */
-&timer1_target {
-	/delete-property/ti,no-reset-on-init;
-	/delete-property/ti,no-idle;
-	timer@0 {
-		/delete-property/ti,timer-alwon;
-	};
-};
-
-/* Preferred always-on timer for clocksource */
-&timer12_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		/* Always clocked by secure_32k_fck */
-	};
-};
-
-/* Preferred timer for clockevent */
-&timer2_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		assigned-clocks = <&gpt2_fck>;
-		assigned-clock-parents = <&sys_ck>;
-	};
-};
-
 &twl_gpio {
 	ti,use-leds;
 	/* pullups: BIT(1) */
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index 86e83639fadc..7fab746e0570 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -181,10 +181,6 @@ mmc@80126000 {
 			cap-sd-highspeed;
 			cap-mmc-highspeed;
 			/* All direction control is used */
-			st,sig-dir-cmd;
-			st,sig-dir-dat0;
-			st,sig-dir-dat2;
-			st,sig-dir-dat31;
 			st,sig-pin-fbclk;
 			full-pwr-cycle;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index 43ddec677c0b..594edf9bbea4 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -2,6 +2,7 @@
 menuconfig ARCH_INTEL_SOCFPGA
 	bool "Altera SOCFPGA family"
 	depends on ARCH_MULTI_V7
+	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
@@ -18,6 +19,7 @@ menuconfig ARCH_INTEL_SOCFPGA
 	select PL310_ERRATA_727915
 	select PL310_ERRATA_753970 if PL310
 	select PL310_ERRATA_769419
+	select RESET_CONTROLLER
 
 if ARCH_INTEL_SOCFPGA
 config SOCFPGA_SUSPEND
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index a84ed3578425..d33e54b5e196 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -17,7 +17,7 @@ aliases {
 		rtc1 = &vrtc;
 	};
 
-	dioo2133: audio-amplifier-0 {
+	dio2133: audio-amplifier-0 {
 		compatible = "simple-audio-amplifier";
 		enable-gpios = <&gpio_ao GPIOAO_2 GPIO_ACTIVE_HIGH>;
 		VCC-supply = <&vcc_5v>;
@@ -217,7 +217,7 @@ sound {
 		audio-widgets = "Line", "Lineout";
 		audio-aux-devs = <&tdmout_b>, <&tdmout_c>, <&tdmin_a>,
 				 <&tdmin_b>, <&tdmin_c>, <&tdmin_lb>,
-				 <&dioo2133>;
+				 <&dio2133>;
 		audio-routing = "TDMOUT_B IN 0", "FRDDR_A OUT 1",
 				"TDMOUT_B IN 1", "FRDDR_B OUT 1",
 				"TDMOUT_B IN 2", "FRDDR_C OUT 1",
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index 212c6aa5a3b8..5751c48620ed 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -123,7 +123,7 @@ vddio_c: regulator-vddio_c {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 
-		enable-gpio = <&gpio GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-always-on;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index 5779e70caccd..76ad052fbf0c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -48,7 +48,7 @@ tf_io: gpio-regulator-tf_io {
 		regulator-max-microvolt = <3300000>;
 		vin-supply = <&vcc_5v>;
 
-		enable-gpio = <&gpio GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_OPEN_DRAIN>;
 		enable-active-high;
 		regulator-always-on;
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 2bc57d8f29c7..fd38092bb247 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -526,7 +526,7 @@ lcdif: lcd-controller@30320000 {
 				assigned-clock-rates = <0>, <0>, <0>, <594000000>;
 				status = "disabled";
 
-				port@0 {
+				port {
 					lcdif_mipi_dsi: endpoint {
 						remote-endpoint = <&mipi_dsi_lcdif_in>;
 					};
@@ -1123,8 +1123,8 @@ ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+					port@1 {
+						reg = <1>;
 
 						csi1_mipi_ep: endpoint {
 							remote-endpoint = <&csi1_ep>;
@@ -1175,8 +1175,8 @@ ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					port@0 {
-						reg = <0>;
+					port@1 {
+						reg = <1>;
 
 						csi2_mipi_ep: endpoint {
 							remote-endpoint = <&csi2_ep>;
diff --git a/arch/mips/cavium-octeon/octeon-memcpy.S b/arch/mips/cavium-octeon/octeon-memcpy.S
index 0a515cde1c18..25860fba6218 100644
--- a/arch/mips/cavium-octeon/octeon-memcpy.S
+++ b/arch/mips/cavium-octeon/octeon-memcpy.S
@@ -74,7 +74,7 @@
 #define EXC(inst_reg,addr,handler)		\
 9:	inst_reg, addr;				\
 	.section __ex_table,"a";		\
-	PTR	9b, handler;			\
+	PTR_WD	9b, handler;			\
 	.previous
 
 /*
diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
index 2f8ce94ebaaf..cc69f1deb1ca 100644
--- a/arch/mips/include/asm/asm.h
+++ b/arch/mips/include/asm/asm.h
@@ -276,7 +276,7 @@ symbol		=	value
 
 #define PTR_SCALESHIFT	2
 
-#define PTR		.word
+#define PTR_WD		.word
 #define PTRSIZE		4
 #define PTRLOG		2
 #endif
@@ -301,7 +301,7 @@ symbol		=	value
 
 #define PTR_SCALESHIFT	3
 
-#define PTR		.dword
+#define PTR_WD		.dword
 #define PTRSIZE		8
 #define PTRLOG		3
 #endif
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index b463f2aa5a61..db497a8167da 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -32,7 +32,7 @@ do {							\
 		".previous\n"				\
 							\
 		".section\t__ex_table,\"a\"\n\t"	\
-		STR(PTR) "\t1b, 3b\n\t"			\
+		STR(PTR_WD) "\t1b, 3b\n\t"		\
 		".previous\n"				\
 							\
 		: [tmp_dst] "=&r" (dst), [tmp_err] "=r" (error)\
@@ -54,7 +54,7 @@ do {						\
 		".previous\n"			\
 						\
 		".section\t__ex_table,\"a\"\n\t"\
-		STR(PTR) "\t1b, 3b\n\t"		\
+		STR(PTR_WD) "\t1b, 3b\n\t"	\
 		".previous\n"			\
 						\
 		: [tmp_err] "=r" (error)	\
diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index af3788589ee6..431a1c9d53fc 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -119,7 +119,7 @@ static inline void flush_scache_line(unsigned long addr)
 	"	j	2b			\n"		\
 	"	.previous			\n"		\
 	"	.section __ex_table,\"a\"	\n"		\
-	"	"STR(PTR)" 1b, 3b		\n"		\
+	"	"STR(PTR_WD)" 1b, 3b		\n"		\
 	"	.previous"					\
 	: "+r" (__err)						\
 	: "i" (op), "r" (addr), "i" (-EFAULT));			\
@@ -142,7 +142,7 @@ static inline void flush_scache_line(unsigned long addr)
 	"	j	2b			\n"		\
 	"	.previous			\n"		\
 	"	.section __ex_table,\"a\"	\n"		\
-	"	"STR(PTR)" 1b, 3b		\n"		\
+	"	"STR(PTR_WD)" 1b, 3b		\n"		\
 	"	.previous"					\
 	: "+r" (__err)						\
 	: "i" (op), "r" (addr), "i" (-EFAULT));			\
diff --git a/arch/mips/include/asm/unaligned-emul.h b/arch/mips/include/asm/unaligned-emul.h
index 2022b18944b9..9af0f4d3d288 100644
--- a/arch/mips/include/asm/unaligned-emul.h
+++ b/arch/mips/include/asm/unaligned-emul.h
@@ -20,8 +20,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -41,8 +41,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -74,10 +74,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -102,8 +102,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -125,8 +125,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -145,8 +145,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -178,10 +178,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -223,14 +223,14 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
-		STR(PTR)"\t5b, 11b\n\t"		    \
-		STR(PTR)"\t6b, 11b\n\t"		    \
-		STR(PTR)"\t7b, 11b\n\t"		    \
-		STR(PTR)"\t8b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
+		STR(PTR_WD)"\t5b, 11b\n\t"	    \
+		STR(PTR_WD)"\t6b, 11b\n\t"	    \
+		STR(PTR_WD)"\t7b, 11b\n\t"	    \
+		STR(PTR_WD)"\t8b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -255,8 +255,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"              \
-		STR(PTR)"\t2b, 4b\n\t"              \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                        \
 		: "r" (value), "r" (addr), "i" (-EFAULT));\
@@ -276,8 +276,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                                \
 		: "r" (value), "r" (addr), "i" (-EFAULT));  \
@@ -296,8 +296,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                                \
 		: "r" (value), "r" (addr), "i" (-EFAULT));  \
@@ -325,10 +325,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (res)				    \
 		: "r" (value), "r" (addr), "i" (-EFAULT)    \
@@ -365,14 +365,14 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
-		STR(PTR)"\t5b, 11b\n\t"		    \
-		STR(PTR)"\t6b, 11b\n\t"		    \
-		STR(PTR)"\t7b, 11b\n\t"		    \
-		STR(PTR)"\t8b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
+		STR(PTR_WD)"\t5b, 11b\n\t"	    \
+		STR(PTR_WD)"\t6b, 11b\n\t"	    \
+		STR(PTR_WD)"\t7b, 11b\n\t"	    \
+		STR(PTR_WD)"\t8b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (res)				    \
 		: "r" (value), "r" (addr), "i" (-EFAULT)    \
@@ -398,8 +398,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -419,8 +419,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -452,10 +452,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -481,8 +481,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -504,8 +504,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -524,8 +524,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=&r" (value), "=r" (res)         \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -557,10 +557,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -602,14 +602,14 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
-		STR(PTR)"\t5b, 11b\n\t"		    \
-		STR(PTR)"\t6b, 11b\n\t"		    \
-		STR(PTR)"\t7b, 11b\n\t"		    \
-		STR(PTR)"\t8b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
+		STR(PTR_WD)"\t5b, 11b\n\t"	    \
+		STR(PTR_WD)"\t6b, 11b\n\t"	    \
+		STR(PTR_WD)"\t7b, 11b\n\t"	    \
+		STR(PTR_WD)"\t8b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (value), "=r" (res)	    \
 		: "r" (addr), "i" (-EFAULT));       \
@@ -632,8 +632,8 @@ do {                                                 \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                        \
 		: "r" (value), "r" (addr), "i" (-EFAULT));\
@@ -653,8 +653,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                                \
 		: "r" (value), "r" (addr), "i" (-EFAULT));  \
@@ -673,8 +673,8 @@ do {                                                \
 		"j\t3b\n\t"                         \
 		".previous\n\t"                     \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 4b\n\t"               \
-		STR(PTR)"\t2b, 4b\n\t"               \
+		STR(PTR_WD)"\t1b, 4b\n\t"           \
+		STR(PTR_WD)"\t2b, 4b\n\t"           \
 		".previous"                         \
 		: "=r" (res)                                \
 		: "r" (value), "r" (addr), "i" (-EFAULT));  \
@@ -703,10 +703,10 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (res)				    \
 		: "r" (value), "r" (addr), "i" (-EFAULT)    \
@@ -743,14 +743,14 @@ do {                                                \
 		"j\t10b\n\t"			    \
 		".previous\n\t"			    \
 		".section\t__ex_table,\"a\"\n\t"    \
-		STR(PTR)"\t1b, 11b\n\t"		    \
-		STR(PTR)"\t2b, 11b\n\t"		    \
-		STR(PTR)"\t3b, 11b\n\t"		    \
-		STR(PTR)"\t4b, 11b\n\t"		    \
-		STR(PTR)"\t5b, 11b\n\t"		    \
-		STR(PTR)"\t6b, 11b\n\t"		    \
-		STR(PTR)"\t7b, 11b\n\t"		    \
-		STR(PTR)"\t8b, 11b\n\t"		    \
+		STR(PTR_WD)"\t1b, 11b\n\t"	    \
+		STR(PTR_WD)"\t2b, 11b\n\t"	    \
+		STR(PTR_WD)"\t3b, 11b\n\t"	    \
+		STR(PTR_WD)"\t4b, 11b\n\t"	    \
+		STR(PTR_WD)"\t5b, 11b\n\t"	    \
+		STR(PTR_WD)"\t6b, 11b\n\t"	    \
+		STR(PTR_WD)"\t7b, 11b\n\t"	    \
+		STR(PTR_WD)"\t8b, 11b\n\t"	    \
 		".previous"			    \
 		: "=&r" (res)				    \
 		: "r" (value), "r" (addr), "i" (-EFAULT)    \
diff --git a/arch/mips/kernel/mips-r2-to-r6-emul.c b/arch/mips/kernel/mips-r2-to-r6-emul.c
index a39ec755e4c2..750fe569862b 100644
--- a/arch/mips/kernel/mips-r2-to-r6-emul.c
+++ b/arch/mips/kernel/mips-r2-to-r6-emul.c
@@ -1258,10 +1258,10 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	10b\n"
 			"	.previous\n"
 			"	.section	__ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1333,10 +1333,10 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	10b\n"
 			"       .previous\n"
 			"	.section	__ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1404,10 +1404,10 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	9b\n"
 			"	.previous\n"
 			"	.section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1474,10 +1474,10 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	9b\n"
 			"	.previous\n"
 			"	.section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1589,14 +1589,14 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	9b\n"
 			"	.previous\n"
 			"	.section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
-			STR(PTR) " 5b,8b\n"
-			STR(PTR) " 6b,8b\n"
-			STR(PTR) " 7b,8b\n"
-			STR(PTR) " 0b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
+			STR(PTR_WD) " 5b,8b\n"
+			STR(PTR_WD) " 6b,8b\n"
+			STR(PTR_WD) " 7b,8b\n"
+			STR(PTR_WD) " 0b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1708,14 +1708,14 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j      9b\n"
 			"	.previous\n"
 			"	.section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
-			STR(PTR) " 5b,8b\n"
-			STR(PTR) " 6b,8b\n"
-			STR(PTR) " 7b,8b\n"
-			STR(PTR) " 0b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
+			STR(PTR_WD) " 5b,8b\n"
+			STR(PTR_WD) " 6b,8b\n"
+			STR(PTR_WD) " 7b,8b\n"
+			STR(PTR_WD) " 0b,8b\n"
 			"	.previous\n"
 			"	.set    pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1827,14 +1827,14 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"	j	9b\n"
 			"	.previous\n"
 			"	.section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
-			STR(PTR) " 5b,8b\n"
-			STR(PTR) " 6b,8b\n"
-			STR(PTR) " 7b,8b\n"
-			STR(PTR) " 0b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
+			STR(PTR_WD) " 5b,8b\n"
+			STR(PTR_WD) " 6b,8b\n"
+			STR(PTR_WD) " 7b,8b\n"
+			STR(PTR_WD) " 0b,8b\n"
 			"	.previous\n"
 			"	.set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -1945,14 +1945,14 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"       j	9b\n"
 			"       .previous\n"
 			"       .section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,8b\n"
-			STR(PTR) " 2b,8b\n"
-			STR(PTR) " 3b,8b\n"
-			STR(PTR) " 4b,8b\n"
-			STR(PTR) " 5b,8b\n"
-			STR(PTR) " 6b,8b\n"
-			STR(PTR) " 7b,8b\n"
-			STR(PTR) " 0b,8b\n"
+			STR(PTR_WD) " 1b,8b\n"
+			STR(PTR_WD) " 2b,8b\n"
+			STR(PTR_WD) " 3b,8b\n"
+			STR(PTR_WD) " 4b,8b\n"
+			STR(PTR_WD) " 5b,8b\n"
+			STR(PTR_WD) " 6b,8b\n"
+			STR(PTR_WD) " 7b,8b\n"
+			STR(PTR_WD) " 0b,8b\n"
 			"       .previous\n"
 			"       .set	pop\n"
 			: "+&r"(rt), "=&r"(rs),
@@ -2007,7 +2007,7 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"j	2b\n"
 			".previous\n"
 			".section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,3b\n"
+			STR(PTR_WD) " 1b,3b\n"
 			".previous\n"
 			: "=&r"(res), "+&r"(err)
 			: "r"(vaddr), "i"(SIGSEGV)
@@ -2065,7 +2065,7 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"j	2b\n"
 			".previous\n"
 			".section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,3b\n"
+			STR(PTR_WD) " 1b,3b\n"
 			".previous\n"
 			: "+&r"(res), "+&r"(err)
 			: "r"(vaddr), "i"(SIGSEGV));
@@ -2126,7 +2126,7 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"j	2b\n"
 			".previous\n"
 			".section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,3b\n"
+			STR(PTR_WD) " 1b,3b\n"
 			".previous\n"
 			: "=&r"(res), "+&r"(err)
 			: "r"(vaddr), "i"(SIGSEGV)
@@ -2189,7 +2189,7 @@ int mipsr2_decoder(struct pt_regs *regs, u32 inst, unsigned long *fcr31)
 			"j	2b\n"
 			".previous\n"
 			".section        __ex_table,\"a\"\n"
-			STR(PTR) " 1b,3b\n"
+			STR(PTR_WD) " 1b,3b\n"
 			".previous\n"
 			: "+&r"(res), "+&r"(err)
 			: "r"(vaddr), "i"(SIGSEGV));
diff --git a/arch/mips/kernel/r2300_fpu.S b/arch/mips/kernel/r2300_fpu.S
index cbf6db98cfb3..2748c55820c2 100644
--- a/arch/mips/kernel/r2300_fpu.S
+++ b/arch/mips/kernel/r2300_fpu.S
@@ -23,14 +23,14 @@
 #define EX(a,b)							\
 9:	a,##b;							\
 	.section __ex_table,"a";				\
-	PTR	9b,fault;					\
+	PTR_WD	9b,fault;					\
 	.previous
 
 #define EX2(a,b)						\
 9:	a,##b;							\
 	.section __ex_table,"a";				\
-	PTR	9b,fault;					\
-	PTR	9b+4,fault;					\
+	PTR_WD	9b,fault;					\
+	PTR_WD	9b+4,fault;					\
 	.previous
 
 	.set	mips1
diff --git a/arch/mips/kernel/r4k_fpu.S b/arch/mips/kernel/r4k_fpu.S
index b91e91106475..2e687c60bc4f 100644
--- a/arch/mips/kernel/r4k_fpu.S
+++ b/arch/mips/kernel/r4k_fpu.S
@@ -31,7 +31,7 @@
 .ex\@:	\insn	\reg, \src
 	.set	pop
 	.section __ex_table,"a"
-	PTR	.ex\@, fault
+	PTR_WD	.ex\@, fault
 	.previous
 	.endm
 
diff --git a/arch/mips/kernel/relocate_kernel.S b/arch/mips/kernel/relocate_kernel.S
index f3c908abdbb8..cfde14b48fd8 100644
--- a/arch/mips/kernel/relocate_kernel.S
+++ b/arch/mips/kernel/relocate_kernel.S
@@ -147,10 +147,10 @@ LEAF(kexec_smp_wait)
 
 kexec_args:
 	EXPORT(kexec_args)
-arg0:	PTR		0x0
-arg1:	PTR		0x0
-arg2:	PTR		0x0
-arg3:	PTR		0x0
+arg0:	PTR_WD		0x0
+arg1:	PTR_WD		0x0
+arg2:	PTR_WD		0x0
+arg3:	PTR_WD		0x0
 	.size	kexec_args,PTRSIZE*4
 
 #ifdef CONFIG_SMP
@@ -161,10 +161,10 @@ arg3:	PTR		0x0
  */
 secondary_kexec_args:
 	EXPORT(secondary_kexec_args)
-s_arg0: PTR		0x0
-s_arg1: PTR		0x0
-s_arg2: PTR		0x0
-s_arg3: PTR		0x0
+s_arg0: PTR_WD		0x0
+s_arg1: PTR_WD		0x0
+s_arg2: PTR_WD		0x0
+s_arg3: PTR_WD		0x0
 	.size	secondary_kexec_args,PTRSIZE*4
 kexec_flag:
 	LONG		0x1
@@ -173,17 +173,17 @@ kexec_flag:
 
 kexec_start_address:
 	EXPORT(kexec_start_address)
-	PTR		0x0
+	PTR_WD		0x0
 	.size		kexec_start_address, PTRSIZE
 
 kexec_indirection_page:
 	EXPORT(kexec_indirection_page)
-	PTR		0
+	PTR_WD		0
 	.size		kexec_indirection_page, PTRSIZE
 
 relocate_new_kernel_end:
 
 relocate_new_kernel_size:
 	EXPORT(relocate_new_kernel_size)
-	PTR		relocate_new_kernel_end - relocate_new_kernel
+	PTR_WD		relocate_new_kernel_end - relocate_new_kernel
 	.size		relocate_new_kernel_size, PTRSIZE
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index b1b2e106f711..9bfce5f75f60 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -72,10 +72,10 @@ loads_done:
 	.set	pop
 
 	.section __ex_table,"a"
-	PTR	load_a4, bad_stack_a4
-	PTR	load_a5, bad_stack_a5
-	PTR	load_a6, bad_stack_a6
-	PTR	load_a7, bad_stack_a7
+	PTR_WD	load_a4, bad_stack_a4
+	PTR_WD	load_a5, bad_stack_a5
+	PTR_WD	load_a6, bad_stack_a6
+	PTR_WD	load_a7, bad_stack_a7
 	.previous
 
 	lw	t0, TI_FLAGS($28)	# syscall tracing enabled?
@@ -216,7 +216,7 @@ einval: li	v0, -ENOSYS
 #endif /* CONFIG_MIPS_MT_FPAFF */
 
 #define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, native)
-#define __SYSCALL(nr, entry) 	PTR entry
+#define __SYSCALL(nr, entry) 	PTR_WD entry
 	.align	2
 	.type	sys_call_table, @object
 EXPORT(sys_call_table)
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index f650c55a17dc..97456b2ca7dc 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -101,7 +101,7 @@ not_n32_scall:
 
 	END(handle_sysn32)
 
-#define __SYSCALL(nr, entry)	PTR entry
+#define __SYSCALL(nr, entry)	PTR_WD entry
 	.type	sysn32_call_table, @object
 EXPORT(sysn32_call_table)
 #include <asm/syscall_table_n32.h>
diff --git a/arch/mips/kernel/scall64-n64.S b/arch/mips/kernel/scall64-n64.S
index 5d7bfc65e4d0..5f6ed4b4c399 100644
--- a/arch/mips/kernel/scall64-n64.S
+++ b/arch/mips/kernel/scall64-n64.S
@@ -109,7 +109,7 @@ illegal_syscall:
 	j	n64_syscall_exit
 	END(handle_sys64)
 
-#define __SYSCALL(nr, entry)	PTR entry
+#define __SYSCALL(nr, entry)	PTR_WD entry
 	.align	3
 	.type	sys_call_table, @object
 EXPORT(sys_call_table)
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index cedc8bd88804..d3c2616cba22 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -73,10 +73,10 @@ load_a7: lw	a7, 28(t0)		# argument #8 from usp
 loads_done:
 
 	.section __ex_table,"a"
-	PTR	load_a4, bad_stack_a4
-	PTR	load_a5, bad_stack_a5
-	PTR	load_a6, bad_stack_a6
-	PTR	load_a7, bad_stack_a7
+	PTR_WD	load_a4, bad_stack_a4
+	PTR_WD	load_a5, bad_stack_a5
+	PTR_WD	load_a6, bad_stack_a6
+	PTR_WD	load_a7, bad_stack_a7
 	.previous
 
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
@@ -214,7 +214,7 @@ einval: li	v0, -ENOSYS
 	END(sys32_syscall)
 
 #define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, compat)
-#define __SYSCALL(nr, entry)	PTR entry
+#define __SYSCALL(nr, entry)	PTR_WD entry
 	.align	3
 	.type	sys32_call_table,@object
 EXPORT(sys32_call_table)
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 5512cd586e6e..ae93a607ddf7 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -122,8 +122,8 @@ static inline int mips_atomic_set(unsigned long addr, unsigned long new)
 		"	j	3b					\n"
 		"	.previous					\n"
 		"	.section __ex_table,\"a\"			\n"
-		"	"STR(PTR)"	1b, 4b				\n"
-		"	"STR(PTR)"	2b, 4b				\n"
+		"	"STR(PTR_WD)"	1b, 4b				\n"
+		"	"STR(PTR_WD)"	2b, 4b				\n"
 		"	.previous					\n"
 		"	.set	pop					\n"
 		: [old] "=&r" (old),
@@ -152,8 +152,8 @@ static inline int mips_atomic_set(unsigned long addr, unsigned long new)
 		"	j	3b					\n"
 		"	.previous					\n"
 		"	.section __ex_table,\"a\"			\n"
-		"	"STR(PTR)"	1b, 5b				\n"
-		"	"STR(PTR)"	2b, 5b				\n"
+		"	"STR(PTR_WD)"	1b, 5b				\n"
+		"	"STR(PTR_WD)"	2b, 5b				\n"
 		"	.previous					\n"
 		"	.set	pop					\n"
 		: [old] "=&r" (old),
diff --git a/arch/mips/lib/csum_partial.S b/arch/mips/lib/csum_partial.S
index a46db0807195..7767137c3e49 100644
--- a/arch/mips/lib/csum_partial.S
+++ b/arch/mips/lib/csum_partial.S
@@ -347,7 +347,7 @@ EXPORT_SYMBOL(csum_partial)
 	.if \mode == LEGACY_MODE;		\
 9:		insn reg, addr;			\
 		.section __ex_table,"a";	\
-		PTR	9b, .L_exc;		\
+		PTR_WD	9b, .L_exc;		\
 		.previous;			\
 	/* This is enabled in EVA mode */	\
 	.else;					\
@@ -356,7 +356,7 @@ EXPORT_SYMBOL(csum_partial)
 		    ((\to == USEROP) && (type == ST_INSN));	\
 9:			__BUILD_EVA_INSN(insn##e, reg, addr);	\
 			.section __ex_table,"a";		\
-			PTR	9b, .L_exc;			\
+			PTR_WD	9b, .L_exc;			\
 			.previous;				\
 		.else;						\
 			/* EVA without exception */		\
diff --git a/arch/mips/lib/memcpy.S b/arch/mips/lib/memcpy.S
index 277c32296636..18a43f2e29c8 100644
--- a/arch/mips/lib/memcpy.S
+++ b/arch/mips/lib/memcpy.S
@@ -116,7 +116,7 @@
 	.if \mode == LEGACY_MODE;				\
 9:		insn reg, addr;					\
 		.section __ex_table,"a";			\
-		PTR	9b, handler;				\
+		PTR_WD	9b, handler;				\
 		.previous;					\
 	/* This is assembled in EVA mode */			\
 	.else;							\
@@ -125,7 +125,7 @@
 		    ((\to == USEROP) && (type == ST_INSN));	\
 9:			__BUILD_EVA_INSN(insn##e, reg, addr);	\
 			.section __ex_table,"a";		\
-			PTR	9b, handler;			\
+			PTR_WD	9b, handler;			\
 			.previous;				\
 		.else;						\
 			/*					\
diff --git a/arch/mips/lib/memset.S b/arch/mips/lib/memset.S
index b0baa3c79fad..0b342bae9a98 100644
--- a/arch/mips/lib/memset.S
+++ b/arch/mips/lib/memset.S
@@ -52,7 +52,7 @@
 9:		___BUILD_EVA_INSN(insn, reg, addr);	\
 	.endif;						\
 	.section __ex_table,"a";			\
-	PTR	9b, handler;				\
+	PTR_WD	9b, handler;				\
 	.previous
 
 	.macro	f_fill64 dst, offset, val, fixup, mode
diff --git a/arch/mips/lib/strncpy_user.S b/arch/mips/lib/strncpy_user.S
index 556acf684d7b..13aaa9927ad1 100644
--- a/arch/mips/lib/strncpy_user.S
+++ b/arch/mips/lib/strncpy_user.S
@@ -15,7 +15,7 @@
 #define EX(insn,reg,addr,handler)			\
 9:	insn	reg, addr;				\
 	.section __ex_table,"a";			\
-	PTR	9b, handler;				\
+	PTR_WD	9b, handler;				\
 	.previous
 
 /*
@@ -59,7 +59,7 @@ LEAF(__strncpy_from_user_asm)
 	jr		ra
 
 	.section	__ex_table,"a"
-	PTR		1b, .Lfault
+	PTR_WD		1b, .Lfault
 	.previous
 
 	EXPORT_SYMBOL(__strncpy_from_user_asm)
diff --git a/arch/mips/lib/strnlen_user.S b/arch/mips/lib/strnlen_user.S
index 92b63f20ec05..6de31b616f9c 100644
--- a/arch/mips/lib/strnlen_user.S
+++ b/arch/mips/lib/strnlen_user.S
@@ -14,7 +14,7 @@
 #define EX(insn,reg,addr,handler)			\
 9:	insn	reg, addr;				\
 	.section __ex_table,"a";			\
-	PTR	9b, handler;				\
+	PTR_WD	9b, handler;				\
 	.previous
 
 /*
diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 609c80f67194..f8b94f78403f 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -178,6 +178,7 @@ static inline bool pte_user(pte_t pte)
 #ifndef __ASSEMBLY__
 
 int map_kernel_page(unsigned long va, phys_addr_t pa, pgprot_t prot);
+void unmap_kernel_page(unsigned long va);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 5d34a8646f08..6866d860d4f3 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1082,6 +1082,8 @@ static inline int map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t p
 	return hash__map_kernel_page(ea, pa, prot);
 }
 
+void unmap_kernel_page(unsigned long va);
+
 static inline int __meminit vmemmap_create_mapping(unsigned long start,
 						   unsigned long page_size,
 						   unsigned long phys)
diff --git a/arch/powerpc/include/asm/fixmap.h b/arch/powerpc/include/asm/fixmap.h
index 947b5b9c4424..a832aeafe560 100644
--- a/arch/powerpc/include/asm/fixmap.h
+++ b/arch/powerpc/include/asm/fixmap.h
@@ -111,8 +111,10 @@ static inline void __set_fixmap(enum fixed_addresses idx,
 		BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
 	else if (WARN_ON(idx >= __end_of_fixed_addresses))
 		return;
-
-	map_kernel_page(__fix_to_virt(idx), phys, flags);
+	if (pgprot_val(flags))
+		map_kernel_page(__fix_to_virt(idx), phys, flags);
+	else
+		unmap_kernel_page(__fix_to_virt(idx));
 }
 
 #define __early_set_fixmap	__set_fixmap
diff --git a/arch/powerpc/include/asm/nohash/32/pgtable.h b/arch/powerpc/include/asm/nohash/32/pgtable.h
index d6ba821a56ce..63ea4693ccea 100644
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -64,6 +64,7 @@ extern int icache_44x_need_flush;
 #ifndef __ASSEMBLY__
 
 int map_kernel_page(unsigned long va, phys_addr_t pa, pgprot_t prot);
+void unmap_kernel_page(unsigned long va);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/include/asm/nohash/64/pgtable.h b/arch/powerpc/include/asm/nohash/64/pgtable.h
index 9d2905a47410..2225991c69b5 100644
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -308,6 +308,7 @@ static inline void __ptep_set_access_flags(struct vm_area_struct *vma,
 #define __swp_entry_to_pte(x)		__pte((x).val)
 
 int map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot);
+void unmap_kernel_page(unsigned long va);
 extern int __meminit vmemmap_create_mapping(unsigned long start,
 					    unsigned long page_size,
 					    unsigned long phys);
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index cd16b407f47e..9a93c1a5aa1d 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -203,6 +203,15 @@ void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 	__set_pte_at(mm, addr, ptep, pte, 0);
 }
 
+void unmap_kernel_page(unsigned long va)
+{
+	pmd_t *pmdp = pmd_off_k(va);
+	pte_t *ptep = pte_offset_kernel(pmdp, va);
+
+	pte_clear(&init_mm, va, ptep);
+	flush_tlb_kernel_range(va, va + PAGE_SIZE);
+}
+
 /*
  * This is called when relaxing access to a PTE. It's also called in the page
  * fault path when we don't hit any of the major fault cases, ie, a minor
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 41f3a75fe2ec..e03f45f7711a 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -52,6 +52,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+
+# Newer binutils versions default to ISA spec version 20191213 which moves some
+# instructions from the I extension to the Zicsr and Zifencei extensions.
+toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
+riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index df84e0c13db1..66ddfba1cfbe 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -12,6 +12,7 @@
 #include <linux/sched/hotplug.h>
 #include <asm/irq.h>
 #include <asm/cpu_ops.h>
+#include <asm/numa.h>
 #include <asm/sbi.h>
 
 void cpu_stop(void);
@@ -46,6 +47,7 @@ int __cpu_disable(void)
 		return ret;
 
 	remove_cpu_topology(cpu);
+	numa_remove_cpu(cpu);
 	set_cpu_online(cpu, false);
 	irq_migrate_all_off_this_cpu();
 
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 315db3d0229b..c2601150b91c 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -22,15 +22,16 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
 	unsigned long fp, sp, pc;
+	int level = 0;
 
 	if (regs) {
 		fp = frame_pointer(regs);
 		sp = user_stack_pointer(regs);
 		pc = instruction_pointer(regs);
 	} else if (task == NULL || task == current) {
-		fp = (unsigned long)__builtin_frame_address(1);
-		sp = (unsigned long)__builtin_frame_address(0);
-		pc = (unsigned long)__builtin_return_address(0);
+		fp = (unsigned long)__builtin_frame_address(0);
+		sp = sp_in_global;
+		pc = (unsigned long)walk_stackframe;
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -42,7 +43,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		unsigned long low, high;
 		struct stackframe *frame;
 
-		if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
+		if (unlikely(!__kernel_text_address(pc) || (level++ >= 1 && !fn(arg, pc))))
 			break;
 
 		/* Validate frame pointer */
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 9e6d6eaeb4cb..f455dd93f921 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1734,6 +1734,9 @@ static bool is_arch_lbr_xsave_available(void)
 	 * Check the LBR state with the corresponding software structure.
 	 * Disable LBR XSAVES support if the size doesn't match.
 	 */
+	if (xfeature_size(XFEATURE_LBR) == 0)
+		return false;
+
 	if (WARN_ON(xfeature_size(XFEATURE_LBR) != get_lbr_state_size()))
 		return false;
 
diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 85feafacc445..77e3a47af5ad 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -536,11 +536,14 @@ static struct perf_msr intel_rapl_spr_msrs[] = {
  * - perf_msr_probe(PERF_RAPL_MAX)
  * - want to use same event codes across both architectures
  */
-static struct perf_msr amd_rapl_msrs[PERF_RAPL_MAX] = {
-	[PERF_RAPL_PKG]  = { MSR_AMD_PKG_ENERGY_STATUS,  &rapl_events_pkg_group,   test_msr },
+static struct perf_msr amd_rapl_msrs[] = {
+	[PERF_RAPL_PP0]  = { 0, &rapl_events_cores_group, 0, false, 0 },
+	[PERF_RAPL_PKG]  = { MSR_AMD_PKG_ENERGY_STATUS,  &rapl_events_pkg_group,   test_msr, false, RAPL_MSR_MASK },
+	[PERF_RAPL_RAM]  = { 0, &rapl_events_ram_group,   0, false, 0 },
+	[PERF_RAPL_PP1]  = { 0, &rapl_events_gpu_group,   0, false, 0 },
+	[PERF_RAPL_PSYS] = { 0, &rapl_events_psys_group,  0, false, 0 },
 };
 
-
 static int rapl_cpu_offline(unsigned int cpu)
 {
 	struct rapl_pmu *pmu = cpu_to_rapl_pmu(cpu);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..48afe96ae0f0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -410,6 +410,8 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
+		/* Invoke scheduler to prevent soft lockups. */
+		cond_resched();
 	}
 
 	xa_destroy(&encl->page_array);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f666fd79d8ad..5f1d4a5aa871 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -421,12 +421,13 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
-		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
-		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
-		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/
-	);
+		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
+		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
+		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
+		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
+		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
+		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
+		F(AVX512VL));
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 980abc437cda..f05aa7290267 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4473,7 +4473,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+		/*
+		 * If the fault occurred in userspace, arbitrarily inject #GP
+		 * to avoid killing the guest and to hopefully avoid confusing
+		 * the guest kernel too much, e.g. injecting #PF would not be
+		 * coherent with respect to the guest's page tables.  Request
+		 * triple fault if the fault occurred in the kernel as there's
+		 * no fault that KVM can inject without confusing the guest.
+		 * In practice, the triple fault is moot as no sane SEV kernel
+		 * will execute from user memory while also running with SMAP=1.
+		 */
+		if (is_user)
+			kvm_inject_gp(vcpu, 0);
+		else
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
 	return false;
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ba6f99f584ac..a7ed30d5647a 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -362,6 +362,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
 		break;
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 		break;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 152ab0aa82cf..b43976e4b963 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -59,7 +59,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
+	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2ab0e997e39f..44da933a756b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4791,8 +4791,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		dr6 = vmx_get_exit_qual(vcpu);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+			/*
+			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
+			 * instruction.  ICEBP generates a trap-like #DB, but
+			 * despite its interception control being tied to #DB,
+			 * is an instruction intercept, i.e. the VM-Exit occurs
+			 * on the ICEBP itself.  Note, skipping ICEBP also
+			 * clears STI and MOVSS blocking.
+			 *
+			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
+			 * if single-step is enabled in RFLAGS and STI or MOVSS
+			 * blocking is active, as the CPU doesn't set the bit
+			 * on VM-Exit due to #DB interception.  VM-Entry has a
+			 * consistency check that a single-step #DB is pending
+			 * in this scenario as the previous instruction cannot
+			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
+			 * don't modify RFLAGS), therefore the one instruction
+			 * delay when activating single-step breakpoints must
+			 * have already expired.  Note, the CPU sets/clears BS
+			 * as appropriate for all other VM-Exits types.
+			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
+			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
+				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
diff --git a/drivers/accessibility/speakup/speakup_dectlk.c b/drivers/accessibility/speakup/speakup_dectlk.c
index 580ec796816b..78ca4987e619 100644
--- a/drivers/accessibility/speakup/speakup_dectlk.c
+++ b/drivers/accessibility/speakup/speakup_dectlk.c
@@ -44,6 +44,7 @@ static struct var_t vars[] = {
 	{ CAPS_START, .u.s = {"[:dv ap 160] " } },
 	{ CAPS_STOP, .u.s = {"[:dv ap 100 ] " } },
 	{ RATE, .u.n = {"[:ra %d] ", 180, 75, 650, 0, 0, NULL } },
+	{ PITCH, .u.n = {"[:dv ap %d] ", 122, 50, 350, 0, 0, NULL } },
 	{ INFLECTION, .u.n = {"[:dv pr %d] ", 100, 0, 10000, 0, 0, NULL } },
 	{ VOL, .u.n = {"[:dv g5 %d] ", 86, 60, 86, 0, 0, NULL } },
 	{ PUNCT, .u.n = {"[:pu %c] ", 0, 0, 2, 0, 0, "nsa" } },
diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 3b23fb775ac4..f2f8f05662de 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1361,9 +1361,17 @@ static void __init arm_smmu_v3_pmcg_init_resources(struct resource *res,
 	res[0].start = pmcg->page0_base_address;
 	res[0].end = pmcg->page0_base_address + SZ_4K - 1;
 	res[0].flags = IORESOURCE_MEM;
-	res[1].start = pmcg->page1_base_address;
-	res[1].end = pmcg->page1_base_address + SZ_4K - 1;
-	res[1].flags = IORESOURCE_MEM;
+	/*
+	 * The initial version in DEN0049C lacked a way to describe register
+	 * page 1, which makes it broken for most PMCG implementations; in
+	 * that case, just let the driver fail gracefully if it expects to
+	 * find a second memory resource.
+	 */
+	if (node->revision > 0) {
+		res[1].start = pmcg->page1_base_address;
+		res[1].end = pmcg->page1_base_address + SZ_4K - 1;
+		res[1].flags = IORESOURCE_MEM;
+	}
 
 	if (pmcg->overflow_gsiv)
 		acpi_iort_register_irq(pmcg->overflow_gsiv, "overflow",
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9b859ff976e8..98d178227544 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2051,6 +2051,16 @@ bool acpi_ec_dispatch_gpe(void)
 	if (acpi_any_gpe_status_set(first_ec->gpe))
 		return true;
 
+	/*
+	 * Cancel the SCI wakeup and process all pending events in case there
+	 * are any wakeup ones in there.
+	 *
+	 * Note that if any non-EC GPEs are active at this point, the SCI will
+	 * retrigger after the rearming in acpi_s2idle_wake(), so no events
+	 * should be missed by canceling the wakeup here.
+	 */
+	pm_system_cancel_wakeup();
+
 	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 3023224515ab..245a0fa979cb 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -739,21 +739,15 @@ bool acpi_s2idle_wake(void)
 			return true;
 		}
 
-		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
+		/*
+		 * Check non-EC GPE wakeups and if there are none, cancel the
+		 * SCI-related wakeup and dispatch the EC GPE.
+		 */
 		if (acpi_ec_dispatch_gpe()) {
 			pm_pr_dbg("ACPI non-EC GPE wakeup\n");
 			return true;
 		}
 
-		/*
-		 * Cancel the SCI wakeup and process all pending events in case
-		 * there are any wakeup ones in there.
-		 *
-		 * Note that if any non-EC GPEs are active at this point, the
-		 * SCI will retrigger after the rearming below, so no events
-		 * should be missed by canceling the wakeup here.
-		 */
-		pm_system_cancel_wakeup();
 		acpi_os_wait_events_complete();
 
 		/*
@@ -767,6 +761,7 @@ bool acpi_s2idle_wake(void)
 			return true;
 		}
 
+		pm_wakeup_clear(acpi_sci_irq);
 		rearm_wake_irq(acpi_sci_irq);
 	}
 
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 99bda0da23a8..8666590201c9 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -34,7 +34,8 @@ suspend_state_t pm_suspend_target_state;
 bool events_check_enabled __read_mostly;
 
 /* First wakeup IRQ seen by the kernel in the last cycle. */
-unsigned int pm_wakeup_irq __read_mostly;
+static unsigned int wakeup_irq[2] __read_mostly;
+static DEFINE_RAW_SPINLOCK(wakeup_irq_lock);
 
 /* If greater than 0 and the system is suspending, terminate the suspend. */
 static atomic_t pm_abort_suspend __read_mostly;
@@ -942,19 +943,45 @@ void pm_system_cancel_wakeup(void)
 	atomic_dec_if_positive(&pm_abort_suspend);
 }
 
-void pm_wakeup_clear(bool reset)
+void pm_wakeup_clear(unsigned int irq_number)
 {
-	pm_wakeup_irq = 0;
-	if (reset)
+	raw_spin_lock_irq(&wakeup_irq_lock);
+
+	if (irq_number && wakeup_irq[0] == irq_number)
+		wakeup_irq[0] = wakeup_irq[1];
+	else
+		wakeup_irq[0] = 0;
+
+	wakeup_irq[1] = 0;
+
+	raw_spin_unlock_irq(&wakeup_irq_lock);
+
+	if (!irq_number)
 		atomic_set(&pm_abort_suspend, 0);
 }
 
 void pm_system_irq_wakeup(unsigned int irq_number)
 {
-	if (pm_wakeup_irq == 0) {
-		pm_wakeup_irq = irq_number;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&wakeup_irq_lock, flags);
+
+	if (wakeup_irq[0] == 0)
+		wakeup_irq[0] = irq_number;
+	else if (wakeup_irq[1] == 0)
+		wakeup_irq[1] = irq_number;
+	else
+		irq_number = 0;
+
+	raw_spin_unlock_irqrestore(&wakeup_irq_lock, flags);
+
+	if (irq_number)
 		pm_system_wakeup();
-	}
+}
+
+unsigned int pm_wakeup_irq(void)
+{
+	return wakeup_irq[0];
 }
 
 /**
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index b8b2811c7c0a..d340d6864e13 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -366,6 +366,7 @@ static const struct mhi_pci_dev_info mhi_foxconn_sdx55_info = {
 	.config = &modem_foxconn_sdx55_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 	.sideband_wake = false,
 };
 
@@ -401,6 +402,7 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.config = &modem_mv31_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 };
 
 static const struct pci_device_id mhi_pci_id_table[] = {
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index b6f97960d8ee..5c40ca1d4740 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -241,7 +241,7 @@ static void __init dmtimer_systimer_assign_alwon(void)
 	bool quirk_unreliable_oscillator = false;
 
 	/* Quirk unreliable 32 KiHz oscillator with incomplete dts */
-	if (of_machine_is_compatible("ti,omap3-beagle") ||
+	if (of_machine_is_compatible("ti,omap3-beagle-ab4") ||
 	    of_machine_is_compatible("timll,omap3-devkit8000")) {
 		quirk_unreliable_oscillator = true;
 		counter_32k = -ENODEV;
diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index 34e35b64dcdc..23047dc84ef1 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -273,7 +273,8 @@ static int gpio_fwd_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	return gpiod_get_value(fwd->descs[offset]);
+	return chip->can_sleep ? gpiod_get_value_cansleep(fwd->descs[offset])
+			       : gpiod_get_value(fwd->descs[offset]);
 }
 
 static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -292,7 +293,10 @@ static int gpio_fwd_get_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
 	for_each_set_bit(i, mask, fwd->chip.ngpio)
 		descs[j++] = fwd->descs[i];
 
-	error = gpiod_get_array_value(j, descs, NULL, values);
+	if (fwd->chip.can_sleep)
+		error = gpiod_get_array_value_cansleep(j, descs, NULL, values);
+	else
+		error = gpiod_get_array_value(j, descs, NULL, values);
 	if (error)
 		return error;
 
@@ -327,7 +331,10 @@ static void gpio_fwd_set(struct gpio_chip *chip, unsigned int offset, int value)
 {
 	struct gpiochip_fwd *fwd = gpiochip_get_data(chip);
 
-	gpiod_set_value(fwd->descs[offset], value);
+	if (chip->can_sleep)
+		gpiod_set_value_cansleep(fwd->descs[offset], value);
+	else
+		gpiod_set_value(fwd->descs[offset], value);
 }
 
 static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
@@ -346,7 +353,10 @@ static void gpio_fwd_set_multiple(struct gpiochip_fwd *fwd, unsigned long *mask,
 		descs[j++] = fwd->descs[i];
 	}
 
-	gpiod_set_array_value(j, descs, NULL, values);
+	if (fwd->chip.can_sleep)
+		gpiod_set_array_value_cansleep(j, descs, NULL, values);
+	else
+		gpiod_set_array_value(j, descs, NULL, values);
 }
 
 static void gpio_fwd_set_multiple_locked(struct gpio_chip *chip,
diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 403f9e833d6a..7d82388b4ab7 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -223,7 +223,7 @@ static int sifive_gpio_probe(struct platform_device *pdev)
 			 NULL,
 			 chip->base + SIFIVE_GPIO_OUTPUT_EN,
 			 chip->base + SIFIVE_GPIO_INPUT_EN,
-			 0);
+			 BGPIOF_READ_OUTPUT_REG_SET);
 	if (ret) {
 		dev_err(dev, "unable to init generic GPIO\n");
 		return ret;
diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index c7b5446d01fd..ffa0256cad5a 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -330,7 +330,7 @@ static int linehandle_create(struct gpio_device *gdev, void __user *ip)
 			goto out_free_lh;
 		}
 
-		ret = gpiod_request(desc, lh->label);
+		ret = gpiod_request_user(desc, lh->label);
 		if (ret)
 			goto out_free_lh;
 		lh->descs[i] = desc;
@@ -1378,7 +1378,7 @@ static int linereq_create(struct gpio_device *gdev, void __user *ip)
 			goto out_free_linereq;
 		}
 
-		ret = gpiod_request(desc, lr->label);
+		ret = gpiod_request_user(desc, lr->label);
 		if (ret)
 			goto out_free_linereq;
 
@@ -1764,7 +1764,7 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 		}
 	}
 
-	ret = gpiod_request(desc, le->label);
+	ret = gpiod_request_user(desc, le->label);
 	if (ret)
 		goto out_free_le;
 	le->desc = desc;
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 4098bc7f88b7..44c1ad51b3fe 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -475,12 +475,9 @@ static ssize_t export_store(struct class *class,
 	 * they may be undone on its behalf too.
 	 */
 
-	status = gpiod_request(desc, "sysfs");
-	if (status) {
-		if (status == -EPROBE_DEFER)
-			status = -ENODEV;
+	status = gpiod_request_user(desc, "sysfs");
+	if (status)
 		goto done;
-	}
 
 	status = gpiod_set_transitory(desc, false);
 	if (!status) {
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 30bc3f80f83e..c31f4626915d 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -135,6 +135,18 @@ struct gpio_desc {
 
 int gpiod_request(struct gpio_desc *desc, const char *label);
 void gpiod_free(struct gpio_desc *desc);
+
+static inline int gpiod_request_user(struct gpio_desc *desc, const char *label)
+{
+	int ret;
+
+	ret = gpiod_request(desc, label);
+	if (ret == -EPROBE_DEFER)
+		ret = -ENODEV;
+
+	return ret;
+}
+
 int gpiod_configure_flags(struct gpio_desc *desc, const char *con_id,
 		unsigned long lflags, enum gpiod_flags dflags);
 int gpio_set_debounce_timeout(struct gpio_desc *desc, unsigned int debounce);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index b01a21d8336c..ede11eb120d4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1067,7 +1067,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 9e2f18a0c948..26ebe00a55f6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -863,7 +863,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_clock_gate = true,
 	.disable_pplib_clock_request = true,
 	.disable_pplib_wm_range = true,
-	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+	.pipe_split_policy = MPC_SPLIT_AVOID,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 32a0fd5e84b7..640db5020ccc 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -3445,8 +3445,7 @@ static umode_t hwmon_attributes_visible(struct kobject *kobj,
 	     attr == &sensor_dev_attr_power2_cap_min.dev_attr.attr ||
 		 attr == &sensor_dev_attr_power2_cap.dev_attr.attr ||
 		 attr == &sensor_dev_attr_power2_cap_default.dev_attr.attr ||
-		 attr == &sensor_dev_attr_power2_label.dev_attr.attr ||
-		 attr == &sensor_dev_attr_power1_label.dev_attr.attr))
+		 attr == &sensor_dev_attr_power2_label.dev_attr.attr))
 		return 0;
 
 	return effective_mode;
diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index a7389a0facfb..af07eeb47ca0 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/irq.h>
 #include <linux/math64.h>
@@ -196,12 +197,9 @@ static u32 ps2bc(struct nwl_dsi *dsi, unsigned long long ps)
 /*
  * ui2bc - UI time periods to byte clock cycles
  */
-static u32 ui2bc(struct nwl_dsi *dsi, unsigned long long ui)
+static u32 ui2bc(unsigned int ui)
 {
-	u32 bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
-
-	return DIV64_U64_ROUND_UP(ui * dsi->lanes,
-				  dsi->mode.clock * 1000 * bpp);
+	return DIV_ROUND_UP(ui, BITS_PER_BYTE);
 }
 
 /*
@@ -232,12 +230,12 @@ static int nwl_dsi_config_host(struct nwl_dsi *dsi)
 	}
 
 	/* values in byte clock cycles */
-	cycles = ui2bc(dsi, cfg->clk_pre);
+	cycles = ui2bc(cfg->clk_pre);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_t_pre: 0x%x\n", cycles);
 	nwl_dsi_write(dsi, NWL_DSI_CFG_T_PRE, cycles);
 	cycles = ps2bc(dsi, cfg->lpx + cfg->clk_prepare + cfg->clk_zero);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_tx_gap (pre): 0x%x\n", cycles);
-	cycles += ui2bc(dsi, cfg->clk_pre);
+	cycles += ui2bc(cfg->clk_pre);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_t_post: 0x%x\n", cycles);
 	nwl_dsi_write(dsi, NWL_DSI_CFG_T_POST, cycles);
 	cycles = ps2bc(dsi, cfg->hs_exit);
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 9d1bd8f491ad..448c2f2d803a 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -115,6 +115,12 @@ static const struct drm_dmi_panel_orientation_data lcd1280x1920_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1600x2560_leftside_up = {
+	.width = 1600,
+	.height = 2560,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct dmi_system_id orientation_data[] = {
 	{	/* Acer One 10 (S1003) */
 		.matches = {
@@ -261,6 +267,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Default string"),
 		},
 		.driver_data = (void *)&onegx1_pro,
+	}, {	/* OneXPlayer */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ONE-NETBOOK TECHNOLOGY CO., LTD."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ONE XPLAYER"),
+		},
+		.driver_data = (void *)&lcd1600x2560_leftside_up,
 	}, {	/* Samsung GalaxyBook 10.6 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 7f0964645d0c..aea4cc2b3486 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4708,6 +4708,10 @@ static const struct dbuf_slice_conf_entry dg2_allowed_dbufs[] = {
 };
 
 static const struct dbuf_slice_conf_entry adlp_allowed_dbufs[] = {
+	/*
+	 * Keep the join_mbus cases first so check_mbus_joined()
+	 * will prefer them over the !join_mbus cases.
+	 */
 	{
 		.active_pipes = BIT(PIPE_A),
 		.dbuf_mask = {
@@ -4722,6 +4726,20 @@ static const struct dbuf_slice_conf_entry adlp_allowed_dbufs[] = {
 		},
 		.join_mbus = true,
 	},
+	{
+		.active_pipes = BIT(PIPE_A),
+		.dbuf_mask = {
+			[PIPE_A] = BIT(DBUF_S1) | BIT(DBUF_S2),
+		},
+		.join_mbus = false,
+	},
+	{
+		.active_pipes = BIT(PIPE_B),
+		.dbuf_mask = {
+			[PIPE_B] = BIT(DBUF_S3) | BIT(DBUF_S4),
+		},
+		.join_mbus = false,
+	},
 	{
 		.active_pipes = BIT(PIPE_A) | BIT(PIPE_B),
 		.dbuf_mask = {
@@ -4838,13 +4856,14 @@ static bool adlp_check_mbus_joined(u8 active_pipes)
 	return check_mbus_joined(active_pipes, adlp_allowed_dbufs);
 }
 
-static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes,
+static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
 			      const struct dbuf_slice_conf_entry *dbuf_slices)
 {
 	int i;
 
 	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
-		if (dbuf_slices[i].active_pipes == active_pipes)
+		if (dbuf_slices[i].active_pipes == active_pipes &&
+		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];
 	}
 	return 0;
@@ -4855,7 +4874,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes,
  * returns correspondent DBuf slice mask as stated in BSpec for particular
  * platform.
  */
-static u8 icl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes)
+static u8 icl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
 	/*
 	 * FIXME: For ICL this is still a bit unclear as prev BSpec revision
@@ -4869,37 +4888,41 @@ static u8 icl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes)
 	 * still here - we will need it once those additional constraints
 	 * pop up.
 	 */
-	return compute_dbuf_slices(pipe, active_pipes, icl_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   icl_allowed_dbufs);
 }
 
-static u8 tgl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes)
+static u8 tgl_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, tgl_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   tgl_allowed_dbufs);
 }
 
-static u32 adlp_compute_dbuf_slices(enum pipe pipe, u32 active_pipes)
+static u8 adlp_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, adlp_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   adlp_allowed_dbufs);
 }
 
-static u32 dg2_compute_dbuf_slices(enum pipe pipe, u32 active_pipes)
+static u8 dg2_compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus)
 {
-	return compute_dbuf_slices(pipe, active_pipes, dg2_allowed_dbufs);
+	return compute_dbuf_slices(pipe, active_pipes, join_mbus,
+				   dg2_allowed_dbufs);
 }
 
-static u8 skl_compute_dbuf_slices(struct intel_crtc *crtc, u8 active_pipes)
+static u8 skl_compute_dbuf_slices(struct intel_crtc *crtc, u8 active_pipes, bool join_mbus)
 {
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	enum pipe pipe = crtc->pipe;
 
 	if (IS_DG2(dev_priv))
-		return dg2_compute_dbuf_slices(pipe, active_pipes);
+		return dg2_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (IS_ALDERLAKE_P(dev_priv))
-		return adlp_compute_dbuf_slices(pipe, active_pipes);
+		return adlp_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (DISPLAY_VER(dev_priv) == 12)
-		return tgl_compute_dbuf_slices(pipe, active_pipes);
+		return tgl_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	else if (DISPLAY_VER(dev_priv) == 11)
-		return icl_compute_dbuf_slices(pipe, active_pipes);
+		return icl_compute_dbuf_slices(pipe, active_pipes, join_mbus);
 	/*
 	 * For anything else just return one slice yet.
 	 * Should be extended for other platforms.
@@ -6110,11 +6133,16 @@ skl_compute_ddb(struct intel_atomic_state *state)
 			return ret;
 	}
 
+	if (IS_ALDERLAKE_P(dev_priv))
+		new_dbuf_state->joined_mbus =
+			adlp_check_mbus_joined(new_dbuf_state->active_pipes);
+
 	for_each_intel_crtc(&dev_priv->drm, crtc) {
 		enum pipe pipe = crtc->pipe;
 
 		new_dbuf_state->slices[pipe] =
-			skl_compute_dbuf_slices(crtc, new_dbuf_state->active_pipes);
+			skl_compute_dbuf_slices(crtc, new_dbuf_state->active_pipes,
+						new_dbuf_state->joined_mbus);
 
 		if (old_dbuf_state->slices[pipe] == new_dbuf_state->slices[pipe])
 			continue;
@@ -6126,9 +6154,6 @@ skl_compute_ddb(struct intel_atomic_state *state)
 
 	new_dbuf_state->enabled_slices = intel_dbuf_enabled_slices(new_dbuf_state);
 
-	if (IS_ALDERLAKE_P(dev_priv))
-		new_dbuf_state->joined_mbus = adlp_check_mbus_joined(new_dbuf_state->active_pipes);
-
 	if (old_dbuf_state->enabled_slices != new_dbuf_state->enabled_slices ||
 	    old_dbuf_state->joined_mbus != new_dbuf_state->joined_mbus) {
 		ret = intel_atomic_serialize_global_state(&new_dbuf_state->base);
@@ -6609,6 +6634,7 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
 		enum pipe pipe = crtc->pipe;
 		unsigned int mbus_offset;
 		enum plane_id plane_id;
+		u8 slices;
 
 		skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
 		crtc_state->wm.skl.raw = crtc_state->wm.skl.optimal;
@@ -6628,19 +6654,22 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
 			skl_ddb_entry_union(&dbuf_state->ddb[pipe], ddb_uv);
 		}
 
-		dbuf_state->slices[pipe] =
-			skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes);
-
 		dbuf_state->weight[pipe] = intel_crtc_ddb_weight(crtc_state);
 
 		/*
 		 * Used for checking overlaps, so we need absolute
 		 * offsets instead of MBUS relative offsets.
 		 */
-		mbus_offset = mbus_ddb_offset(dev_priv, dbuf_state->slices[pipe]);
+		slices = skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
+						 dbuf_state->joined_mbus);
+		mbus_offset = mbus_ddb_offset(dev_priv, slices);
 		crtc_state->wm.skl.ddb.start = mbus_offset + dbuf_state->ddb[pipe].start;
 		crtc_state->wm.skl.ddb.end = mbus_offset + dbuf_state->ddb[pipe].end;
 
+		/* The slices actually used by the planes on the pipe */
+		dbuf_state->slices[pipe] =
+			skl_ddb_dbuf_slice_mask(dev_priv, &crtc_state->wm.skl.ddb);
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "[CRTC:%d:%s] dbuf slices 0x%x, ddb (%d - %d), active pipes 0x%x, mbus joined: %s\n",
 			    crtc->base.base.id, crtc->base.name,
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 9b6c4e6c38a1..b7b654f2dfd9 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -721,6 +721,7 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc,
 		err = panel_dpi_probe(dev, panel);
 		if (err)
 			goto free_ddc;
+		desc = panel->desc;
 	} else {
 		if (!of_get_display_timing(dev->of_node, "panel-timing", &dt))
 			panel_simple_parse_panel_timing_node(dev, panel, &dt);
diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index ca7cc82125cb..8c873fcd0e99 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -902,6 +902,7 @@ static const struct vop_win_phy rk3399_win01_data = {
 	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
 	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
 	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
+	.x_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 21),
 	.y_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 22),
 	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
@@ -912,6 +913,7 @@ static const struct vop_win_phy rk3399_win01_data = {
 	.uv_vir = VOP_REG(RK3288_WIN0_VIR, 0x3fff, 16),
 	.src_alpha_ctl = VOP_REG(RK3288_WIN0_SRC_ALPHA_CTRL, 0xff, 0),
 	.dst_alpha_ctl = VOP_REG(RK3288_WIN0_DST_ALPHA_CTRL, 0xff, 0),
+	.channel = VOP_REG(RK3288_WIN0_CTRL2, 0xff, 0),
 };
 
 /*
@@ -922,11 +924,11 @@ static const struct vop_win_phy rk3399_win01_data = {
 static const struct vop_win_data rk3399_vop_win_data[] = {
 	{ .base = 0x00, .phy = &rk3399_win01_data,
 	  .type = DRM_PLANE_TYPE_PRIMARY },
-	{ .base = 0x40, .phy = &rk3288_win01_data,
+	{ .base = 0x40, .phy = &rk3368_win01_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x00, .phy = &rk3288_win23_data,
+	{ .base = 0x00, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x50, .phy = &rk3288_win23_data,
+	{ .base = 0x50, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_CURSOR },
 };
 
diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index a185027911ce..d09c1ea60c04 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1262,7 +1262,6 @@ static int vc4_dsi_host_attach(struct mipi_dsi_host *host,
 			       struct mipi_dsi_device *device)
 {
 	struct vc4_dsi *dsi = host_to_dsi(host);
-	int ret;
 
 	dsi->lanes = device->lanes;
 	dsi->channel = device->channel;
@@ -1297,18 +1296,15 @@ static int vc4_dsi_host_attach(struct mipi_dsi_host *host,
 		return 0;
 	}
 
-	ret = component_add(&dsi->pdev->dev, &vc4_dsi_ops);
-	if (ret) {
-		mipi_dsi_host_unregister(&dsi->dsi_host);
-		return ret;
-	}
-
-	return 0;
+	return component_add(&dsi->pdev->dev, &vc4_dsi_ops);
 }
 
 static int vc4_dsi_host_detach(struct mipi_dsi_host *host,
 			       struct mipi_dsi_device *device)
 {
+	struct vc4_dsi *dsi = host_to_dsi(host);
+
+	component_del(&dsi->pdev->dev, &vc4_dsi_ops);
 	return 0;
 }
 
@@ -1706,9 +1702,7 @@ static int vc4_dsi_dev_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 
-	component_del(&pdev->dev, &vc4_dsi_ops);
 	mipi_dsi_host_unregister(&dsi->dsi_host);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index e880bdd8dcfd..9170d948b448 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1090,6 +1090,7 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 	unsigned long long tmds_rate;
 
 	if (vc4_hdmi->variant->unsupported_odd_h_timings &&
+	    !(mode->flags & DRM_MODE_FLAG_DBLCLK) &&
 	    ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
 	     (mode->hsync_end % 2) || (mode->htotal % 2)))
 		return -EINVAL;
@@ -1137,6 +1138,7 @@ vc4_hdmi_encoder_mode_valid(struct drm_encoder *encoder,
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
 
 	if (vc4_hdmi->variant->unsupported_odd_h_timings &&
+	    !(mode->flags & DRM_MODE_FLAG_DBLCLK) &&
 	    ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
 	     (mode->hsync_end % 2) || (mode->htotal % 2)))
 		return MODE_H_ILLEGAL;
diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 47fce97996de..9cb1c3588038 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -326,7 +326,7 @@ static int i8k_enable_fan_auto_mode(const struct dell_smm_data *data, bool enabl
 }
 
 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high, ...).
  */
 static int i8k_set_fan(const struct dell_smm_data *data, int fan, int speed)
 {
@@ -338,7 +338,7 @@ static int i8k_set_fan(const struct dell_smm_data *data, int fan, int speed)
 	speed = (speed < 0) ? 0 : ((speed > data->i8k_fan_max) ? data->i8k_fan_max : speed);
 	regs.ebx = (fan & 0xff) | (speed << 8);
 
-	return i8k_smm(&regs) ? : i8k_get_fan_status(data, fan);
+	return i8k_smm(&regs);
 }
 
 static int __init i8k_get_temp_type(int sensor)
@@ -452,7 +452,7 @@ static int
 i8k_ioctl_unlocked(struct file *fp, struct dell_smm_data *data, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
-	int speed;
+	int speed, err;
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;
 
@@ -513,7 +513,11 @@ i8k_ioctl_unlocked(struct file *fp, struct dell_smm_data *data, unsigned int cmd
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_set_fan(data, val, speed);
+		err = i8k_set_fan(data, val, speed);
+		if (err < 0)
+			return err;
+
+		val = i8k_get_fan_status(data, val);
 		break;
 
 	default:
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 2f98ba70e3d7..c81dbd2f0972 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1446,9 +1446,17 @@ static long iio_device_buffer_getfd(struct iio_dev *indio_dev, unsigned long arg
 	}
 
 	if (copy_to_user(ival, &fd, sizeof(fd))) {
-		put_unused_fd(fd);
-		ret = -EFAULT;
-		goto error_free_ib;
+		/*
+		 * "Leak" the fd, as there's not much we can do about this
+		 * anyway. 'fd' might have been closed already, as
+		 * anon_inode_getfd() called fd_install() on it, which made
+		 * it reachable by userland.
+		 *
+		 * Instead of allowing a malicious user to play tricks with
+		 * us, rely on the process exit path to do any necessary
+		 * cleanup, as in releasing the file, if still needed.
+		 */
+		return -EFAULT;
 	}
 
 	return 0;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f62fb6a58f10..7f409e9eea4b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -206,9 +206,14 @@ static struct dev_iommu *dev_iommu_get(struct device *dev)
 
 static void dev_iommu_free(struct device *dev)
 {
-	iommu_fwspec_free(dev);
-	kfree(dev->iommu);
+	struct dev_iommu *param = dev->iommu;
+
 	dev->iommu = NULL;
+	if (param->fwspec) {
+		fwnode_handle_put(param->fwspec->iommu_fwnode);
+		kfree(param->fwspec);
+	}
+	kfree(param);
 }
 
 static int __iommu_probe_device(struct device *dev, struct list_head *group_list)
diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 568614edd88f..50a56820c99b 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -76,16 +76,20 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct irq_domain *domain;
-	unsigned int pending;
+	unsigned long pending;
+	unsigned int soc_int;
 
 	chained_irq_enter(chip, desc);
 	pending = readl(REG(RTL_ICTL_GIMR)) & readl(REG(RTL_ICTL_GISR));
+
 	if (unlikely(!pending)) {
 		spurious_interrupt();
 		goto out;
 	}
+
 	domain = irq_desc_get_handler_data(desc);
-	generic_handle_domain_irq(domain, __ffs(pending));
+	for_each_set_bit(soc_int, &pending, 32)
+		generic_handle_domain_irq(domain, soc_int);
 
 out:
 	chained_irq_exit(chip, desc);
diff --git a/drivers/misc/eeprom/ee1004.c b/drivers/misc/eeprom/ee1004.c
index bb9c4512c968..9fbfe784d710 100644
--- a/drivers/misc/eeprom/ee1004.c
+++ b/drivers/misc/eeprom/ee1004.c
@@ -114,6 +114,9 @@ static ssize_t ee1004_eeprom_read(struct i2c_client *client, char *buf,
 	if (offset + count > EE1004_PAGE_SIZE)
 		count = EE1004_PAGE_SIZE - offset;
 
+	if (count > I2C_SMBUS_BLOCK_MAX)
+		count = I2C_SMBUS_BLOCK_MAX;
+
 	return i2c_smbus_read_i2c_block_data_or_emulated(client, offset, count, buf);
 }
 
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index f3002653bd01..86d8fb8c0148 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1286,7 +1286,14 @@ static int fastrpc_dmabuf_alloc(struct fastrpc_user *fl, char __user *argp)
 	}
 
 	if (copy_to_user(argp, &bp, sizeof(bp))) {
-		dma_buf_put(buf->dmabuf);
+		/*
+		 * The usercopy failed, but we can't do much about it, as
+		 * dma_buf_fd() already called fd_install() and made the
+		 * file descriptor accessible for the current process. It
+		 * might already be closed and dmabuf no longer valid when
+		 * we reach this point. Therefore "leak" the fd and rely on
+		 * the process exit path to do any required cleanup.
+		 */
 		return -EFAULT;
 	}
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 4646b7a03db6..44e134fa04af 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -66,7 +66,7 @@ static const unsigned int sd_au_size[] = {
 		__res & __mask;						\
 	})
 
-#define SD_POWEROFF_NOTIFY_TIMEOUT_MS 2000
+#define SD_POWEROFF_NOTIFY_TIMEOUT_MS 1000
 #define SD_WRITE_EXTR_SINGLE_TIMEOUT_MS 1000
 
 struct sd_busy_data {
@@ -1663,6 +1663,12 @@ static int sd_poweroff_notify(struct mmc_card *card)
 		goto out;
 	}
 
+	/* Find out when the command is completed. */
+	err = mmc_poll_for_busy(card, SD_WRITE_EXTR_SINGLE_TIMEOUT_MS, false,
+				MMC_BUSY_EXTR_SINGLE);
+	if (err)
+		goto out;
+
 	cb_data.card = card;
 	cb_data.reg_buf = reg_buf;
 	err = __mmc_poll_for_busy(card, SD_POWEROFF_NOTIFY_TIMEOUT_MS,
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index a593b1fbd69e..0f3658b36513 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -524,12 +524,16 @@ static void esdhc_of_adma_workaround(struct sdhci_host *host, u32 intmask)
 
 static int esdhc_of_enable_dma(struct sdhci_host *host)
 {
+	int ret;
 	u32 value;
 	struct device *dev = mmc_dev(host->mmc);
 
 	if (of_device_is_compatible(dev->of_node, "fsl,ls1043a-esdhc") ||
-	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc"))
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc")) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+		if (ret)
+			return ret;
+	}
 
 	value = sdhci_readl(host, ESDHC_DMA_SYSCTL);
 
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6006c2e8fa2b..9fd1d6cba3cd 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1021,8 +1021,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1779,6 +1779,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			*update_slave_arr = true;
 		}
 	}
 
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 7578a5c38df5..2e314e3021d8 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -584,7 +584,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
-	priv->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
+	priv->slave_mii_bus = mdiobus_alloc();
 	if (!priv->slave_mii_bus) {
 		of_node_put(dn);
 		return -ENOMEM;
@@ -644,8 +644,10 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-	if (err && dn)
+	if (err && dn) {
+		mdiobus_free(priv->slave_mii_bus);
 		of_node_put(dn);
+	}
 
 	return err;
 }
@@ -653,6 +655,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 static void bcm_sf2_mdio_unregister(struct bcm_sf2_priv *priv)
 {
 	mdiobus_unregister(priv->slave_mii_bus);
+	mdiobus_free(priv->slave_mii_bus);
 	of_node_put(priv->master_mii_dn);
 }
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173f..503adf03d2fc 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -497,8 +497,9 @@ static int gswip_mdio_rd(struct mii_bus *bus, int addr, int reg)
 static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 {
 	struct dsa_switch *ds = priv->ds;
+	int err;
 
-	ds->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
+	ds->slave_mii_bus = mdiobus_alloc();
 	if (!ds->slave_mii_bus)
 		return -ENOMEM;
 
@@ -511,7 +512,11 @@ static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 	ds->slave_mii_bus->parent = priv->dev;
 	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
 
-	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	err = of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	if (err)
+		mdiobus_free(ds->slave_mii_bus);
+
+	return err;
 }
 
 static int gswip_pce_table_entry_read(struct gswip_priv *priv,
@@ -2170,8 +2175,10 @@ static int gswip_probe(struct platform_device *pdev)
 	gswip_mdio_mask(priv, GSWIP_MDIO_GLOB_ENABLE, 0, GSWIP_MDIO_GLOB);
 	dsa_unregister_switch(priv->ds);
 mdio_bus:
-	if (mdio_np)
+	if (mdio_np) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
+	}
 put_mdio_node:
 	of_node_put(mdio_np);
 	for (i = 0; i < priv->num_gphy_fw; i++)
@@ -2194,6 +2201,7 @@ static int gswip_remove(struct platform_device *pdev)
 
 	if (priv->ds->slave_mii_bus) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
 		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
 	}
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9890672a206d..fb59efc7f926 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2066,7 +2066,7 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	if (priv->irq)
 		mt7530_setup_mdio_irq(priv);
 
-	ret = mdiobus_register(bus);
+	ret = devm_mdiobus_register(dev, bus);
 	if (ret) {
 		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
 		if (priv->irq)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 43d126628610..056e3b65cd27 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3416,7 +3416,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 			return err;
 	}
 
-	bus = devm_mdiobus_alloc_size(chip->dev, sizeof(*mdio_bus));
+	bus = mdiobus_alloc_size(sizeof(*mdio_bus));
 	if (!bus)
 		return -ENOMEM;
 
@@ -3441,14 +3441,14 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	err = of_mdiobus_register(bus, np);
 	if (err) {
 		dev_err(chip->dev, "Cannot register MDIO bus (%d)\n", err);
 		mv88e6xxx_g2_irq_mdio_free(chip, bus);
-		return err;
+		goto out;
 	}
 
 	if (external)
@@ -3457,21 +3457,26 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 		list_add(&mdio_bus->list, &chip->mdios);
 
 	return 0;
+
+out:
+	mdiobus_free(bus);
+	return err;
 }
 
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 
 {
-	struct mv88e6xxx_mdio_bus *mdio_bus;
+	struct mv88e6xxx_mdio_bus *mdio_bus, *p;
 	struct mii_bus *bus;
 
-	list_for_each_entry(mdio_bus, &chip->mdios, list) {
+	list_for_each_entry_safe(mdio_bus, p, &chip->mdios, list) {
 		bus = mdio_bus->bus;
 
 		if (!mdio_bus->external)
 			mv88e6xxx_g2_irq_mdio_free(chip, bus);
 
 		mdiobus_unregister(bus);
+		mdiobus_free(bus);
 	}
 }
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 11b42fd812e4..e53ad283e259 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1066,7 +1066,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return PTR_ERR(hw);
 	}
 
-	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
 	if (!bus)
 		return -ENOMEM;
 
@@ -1086,6 +1086,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	rc = mdiobus_register(bus);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
+		mdiobus_free(bus);
 		return rc;
 	}
 
@@ -1135,6 +1136,7 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 		lynx_pcs_destroy(pcs);
 	}
 	mdiobus_unregister(felix->imdio);
+	mdiobus_free(felix->imdio);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index a6bfb6abc51a..5d476f452396 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -378,7 +378,7 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 	if (!mnp)
 		return -ENODEV;
 
-	ret = of_mdiobus_register(mbus, mnp);
+	ret = devm_of_mdiobus_register(dev, mbus, mnp);
 	of_node_put(mnp);
 	if (ret)
 		return ret;
@@ -1093,7 +1093,6 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
 	}
 
 	irq_domain_remove(priv->irqdomain);
-	mdiobus_unregister(priv->mbus);
 	dsa_unregister_switch(&priv->ds);
 
 	reset_control_assert(priv->sw_reset);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 90cb55eb5466..014513ce00a1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -418,6 +418,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdata->pcidev);
 
+	/* Disable all interrupts in the hardware */
+	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
+
 	xgbe_free_pdata(pdata);
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 1108e1730841..110075336a75 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4511,12 +4511,12 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
+
+	unregister_netdev(net_dev);
 	rtnl_lock();
 	dpaa2_eth_disconnect_mac(priv);
 	rtnl_unlock();
 
-	unregister_netdev(net_dev);
-
 	dpaa2_eth_dl_port_del(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
 	dpaa2_eth_dl_unregister(priv);
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fba8f021c397..d119812755b7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -398,6 +398,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
+	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -692,7 +693,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
-		ice_plug_aux_dev(pf);
+		set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index df5ad4de1f00..f4463e962d52 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3272,7 +3272,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
 		struct ice_link_default_override_tlv tlv;
 
-		if (ice_get_link_default_override(&tlv, pi))
+		status = ice_get_link_default_override(&tlv, pi);
+		if (status)
 			goto out;
 
 		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index e375ac849aec..4f954db01b92 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -204,17 +204,39 @@ ice_lag_unlink(struct ice_lag *lag,
 		lag->upper_netdev = NULL;
 	}
 
-	if (lag->peer_netdev) {
-		dev_put(lag->peer_netdev);
-		lag->peer_netdev = NULL;
-	}
-
+	lag->peer_netdev = NULL;
 	ice_set_sriov_cap(pf);
 	ice_set_rdma_cap(pf);
 	lag->bonded = false;
 	lag->role = ICE_LAG_NONE;
 }
 
+/**
+ * ice_lag_unregister - handle netdev unregister events
+ * @lag: LAG info struct
+ * @netdev: netdev reporting the event
+ */
+static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
+{
+	struct ice_pf *pf = lag->pf;
+
+	/* check to see if this event is for this netdev
+	 * check that we are in an aggregate
+	 */
+	if (netdev != lag->netdev || !lag->bonded)
+		return;
+
+	if (lag->upper_netdev) {
+		dev_put(lag->upper_netdev);
+		lag->upper_netdev = NULL;
+		ice_set_sriov_cap(pf);
+		ice_set_rdma_cap(pf);
+	}
+	/* perform some cleanup in case we come back */
+	lag->bonded = false;
+	lag->role = ICE_LAG_NONE;
+}
+
 /**
  * ice_lag_changeupper_event - handle LAG changeupper event
  * @lag: LAG info struct
@@ -307,7 +329,7 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 		ice_lag_info_event(lag, ptr);
 		break;
 	case NETDEV_UNREGISTER:
-		ice_lag_unlink(lag, ptr);
+		ice_lag_unregister(lag, netdev);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 80736e0ec0dc..3f635fdbfaff 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -528,6 +528,7 @@ struct ice_tx_ctx_desc {
 			(0x3FFFFULL << ICE_TXD_CTX_QW1_TSO_LEN_S)
 
 #define ICE_TXD_CTX_QW1_MSS_S	50
+#define ICE_TXD_CTX_MIN_MSS	64
 
 enum ice_tx_ctx_desc_cmd_bits {
 	ICE_TX_CTX_DESC_TSO		= 0x01,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 819c32a721e8..ab2dea0d2c1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2141,6 +2141,9 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
+
 	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
@@ -7206,6 +7209,7 @@ ice_features_check(struct sk_buff *skb,
 		   struct net_device __always_unused *netdev,
 		   netdev_features_t features)
 {
+	bool gso = skb_is_gso(skb);
 	size_t len;
 
 	/* No point in doing any of this if neither checksum nor GSO are
@@ -7218,24 +7222,32 @@ ice_features_check(struct sk_buff *skb,
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
-	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
+	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
 		features &= ~NETIF_F_GSO_MASK;
 
-	len = skb_network_header(skb) - skb->data;
+	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
-	len = skb_transport_header(skb) - skb_network_header(skb);
+	len = skb_network_header_len(skb);
 	if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
 	if (skb->encapsulation) {
-		len = skb_inner_network_header(skb) - skb_transport_header(skb);
-		if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
-			goto out_rm_features;
+		/* this must work for VXLAN frames AND IPIP/SIT frames, and in
+		 * the case of IPIP frames, the transport header pointer is
+		 * after the inner header! So check to make sure that this
+		 * is a GRE or UDP_TUNNEL frame before doing that math.
+		 */
+		if (gso && (skb_shinfo(skb)->gso_type &
+			    (SKB_GSO_GRE | SKB_GSO_UDP_TUNNEL))) {
+			len = skb_inner_network_header(skb) -
+			      skb_transport_header(skb);
+			if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
+				goto out_rm_features;
+		}
 
-		len = skb_inner_transport_header(skb) -
-		      skb_inner_network_header(skb);
+		len = skb_inner_network_header_len(skb);
 		if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 			goto out_rm_features;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index c714e1ecd308..7ef2e1241a76 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1984,14 +1984,15 @@ static void ixgbevf_set_rx_buffer_len(struct ixgbevf_adapter *adapter,
 	if (adapter->flags & IXGBEVF_FLAGS_LEGACY_RX)
 		return;
 
-	set_ring_build_skb_enabled(rx_ring);
+	if (PAGE_SIZE < 8192)
+		if (max_frame > IXGBEVF_MAX_FRAME_BUILD_SKB)
+			set_ring_uses_large_buffer(rx_ring);
 
-	if (PAGE_SIZE < 8192) {
-		if (max_frame <= IXGBEVF_MAX_FRAME_BUILD_SKB)
-			return;
+	/* 82599 can't rely on RXDCTL.RLPML to restrict the size of the frame */
+	if (adapter->hw.mac.type == ixgbe_mac_82599_vf && !ring_uses_large_buffer(rx_ring))
+		return;
 
-		set_ring_uses_large_buffer(rx_ring);
-	}
+	set_ring_build_skb_enabled(rx_ring);
 }
 
 /**
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 59783fc46a7b..10b866e9f726 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1103,7 +1103,7 @@ void sparx5_get_stats64(struct net_device *ndev,
 	stats->tx_carrier_errors = portstats[spx5_stats_tx_csense_cnt];
 	stats->tx_window_errors = portstats[spx5_stats_tx_late_coll_cnt];
 	stats->rx_dropped = portstats[spx5_stats_ana_ac_port_stat_lsb_cnt];
-	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++stats)
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx)
 		stats->rx_dropped += portstats[spx5_stats_green_p0_rx_port_drop
 					       + idx];
 	stats->tx_dropped = portstats[spx5_stats_tx_local_drop];
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index be2dd69bfee8..6aad0953e8fe 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1215,12 +1215,11 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
+/* Caller must hold &ocelot->stats_lock */
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
 
-	mutex_lock(&ocelot->stats_lock);
-
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		/* Configure the port to read the stats from */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
@@ -1239,8 +1238,6 @@ static void ocelot_update_stats(struct ocelot *ocelot)
 					      ~(u64)U32_MAX) + val;
 		}
 	}
-
-	mutex_unlock(&ocelot->stats_lock);
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1249,7 +1246,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
 
+	mutex_lock(&ocelot->stats_lock);
 	ocelot_update_stats(ocelot);
+	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
@@ -1259,12 +1258,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i;
 
+	mutex_lock(&ocelot->stats_lock);
+
 	/* check and update now */
 	ocelot_update_stats(ocelot);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index ab70179728f6..6521675be85c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -1011,6 +1011,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_tun_offloaded_mac *entry;
 	struct nfp_repr *repr;
+	u16 nfp_mac_idx;
 	int ida_idx;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, mac);
@@ -1029,8 +1030,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		entry->bridge_count--;
 
 		if (!entry->bridge_count && entry->ref_count) {
-			u16 nfp_mac_idx;
-
 			nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
 			if (__nfp_tunnel_offload_mac(app, mac, nfp_mac_idx,
 						     false)) {
@@ -1046,7 +1045,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 
 	/* If MAC is now used by 1 repr set the offloaded MAC index to port. */
 	if (entry->ref_count == 1 && list_is_singular(&entry->repr_list)) {
-		u16 nfp_mac_idx;
 		int port, err;
 
 		repr_priv = list_first_entry(&entry->repr_list,
@@ -1074,8 +1072,14 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->tun.offloaded_macs,
 					    &entry->ht_node,
 					    offloaded_macs_params));
+
+	if (nfp_flower_is_supported_bridge(netdev))
+		nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
+	else
+		nfp_mac_idx = entry->index;
+
 	/* If MAC has global ID then extract and free the ida entry. */
-	if (nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4422baeed3d8..13fbb68158c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -756,7 +756,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 161e65333ed9..e6af26b2dcb8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -400,7 +400,7 @@ static void stmmac_lpi_entry_timer_config(struct stmmac_priv *priv, bool en)
  * Description: this function is to verify and enter in LPI mode in case of
  * EEE.
  */
-static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
+static int stmmac_enable_eee_mode(struct stmmac_priv *priv)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 queue;
@@ -410,13 +410,14 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 
 		if (tx_q->dirty_tx != tx_q->cur_tx)
-			return; /* still unfinished work */
+			return -EBUSY; /* still unfinished work */
 	}
 
 	/* Check and enter in LPI mode */
 	if (!priv->tx_path_in_lpi_mode)
 		stmmac_set_eee_mode(priv, priv->hw,
 				priv->plat->en_tx_lpi_clockgating);
+	return 0;
 }
 
 /**
@@ -448,8 +449,8 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 {
 	struct stmmac_priv *priv = from_timer(priv, t, eee_ctrl_timer);
 
-	stmmac_enable_eee_mode(priv);
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+	if (stmmac_enable_eee_mode(priv))
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
 /**
@@ -2637,8 +2638,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if (priv->eee_enabled && !priv->tx_path_in_lpi_mode &&
 	    priv->eee_sw_timer_en) {
-		stmmac_enable_eee_mode(priv);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+		if (stmmac_enable_eee_mode(priv))
+			mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
 
 	/* We still have pending packets, let's call for a new scheduling */
diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 966c3b4ad59d..e2273588c75b 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -148,6 +148,7 @@ static const struct of_device_id aspeed_mdio_of_match[] = {
 	{ .compatible = "aspeed,ast2600-mdio", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, aspeed_mdio_of_match);
 
 static struct platform_driver aspeed_mdio_driver = {
 	.driver = {
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index c10cc2cd53b6..cfda625dbea5 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -553,9 +553,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
 	else
 		mscr = 0;
 
-	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
-				MII_88E1121_PHY_MSCR_REG,
-				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
+	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
+					MII_88E1121_PHY_MSCR_REG,
+					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
 }
 
 static int m88e1121_config_aneg(struct phy_device *phydev)
@@ -569,11 +569,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 			return err;
 	}
 
+	changed = err;
+
 	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	changed = err;
+	changed |= err;
 
 	err = genphy_config_aneg(phydev);
 	if (err < 0)
@@ -1213,16 +1215,15 @@ static int m88e1118_config_aneg(struct phy_device *phydev)
 {
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1118_config_init(struct phy_device *phydev)
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index f25448a08870..d5ce642200e8 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1467,58 +1467,68 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	u16 hdr_off;
 	u32 *pkt_hdr;
 
-	/* This check is no longer done by usbnet */
-	if (skb->len < dev->net->hard_header_len)
+	/* At the end of the SKB, there's a header telling us how many packets
+	 * are bundled into this buffer and where we can find an array of
+	 * per-packet metadata (which contains elements encoded into u16).
+	 */
+	if (skb->len < 4)
 		return 0;
-
 	skb_trim(skb, skb->len - 4);
 	rx_hdr = get_unaligned_le32(skb_tail_pointer(skb));
-
 	pkt_cnt = (u16)rx_hdr;
 	hdr_off = (u16)(rx_hdr >> 16);
+
+	if (pkt_cnt == 0)
+		return 0;
+
+	/* Make sure that the bounds of the metadata array are inside the SKB
+	 * (and in front of the counter at the end).
+	 */
+	if (pkt_cnt * 2 + hdr_off > skb->len)
+		return 0;
 	pkt_hdr = (u32 *)(skb->data + hdr_off);
 
-	while (pkt_cnt--) {
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, hdr_off);
+
+	for (; ; pkt_cnt--, pkt_hdr++) {
 		u16 pkt_len;
 
 		le32_to_cpus(pkt_hdr);
 		pkt_len = (*pkt_hdr >> 16) & 0x1fff;
 
-		/* Check CRC or runt packet */
-		if ((*pkt_hdr & AX_RXHDR_CRC_ERR) ||
-		    (*pkt_hdr & AX_RXHDR_DROP_ERR)) {
-			skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-			pkt_hdr++;
-			continue;
-		}
-
-		if (pkt_cnt == 0) {
-			skb->len = pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(skb, 2);
-			skb_set_tail_pointer(skb, skb->len);
-			skb->truesize = pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(skb, pkt_hdr);
-			return 1;
-		}
+		if (pkt_len > skb->len)
+			return 0;
 
-		ax_skb = skb_clone(skb, GFP_ATOMIC);
-		if (ax_skb) {
+		/* Check CRC or runt packet */
+		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) == 0) &&
+		    pkt_len >= 2 + ETH_HLEN) {
+			bool last = (pkt_cnt == 0);
+
+			if (last) {
+				ax_skb = skb;
+			} else {
+				ax_skb = skb_clone(skb, GFP_ATOMIC);
+				if (!ax_skb)
+					return 0;
+			}
 			ax_skb->len = pkt_len;
 			/* Skip IP alignment pseudo header */
 			skb_pull(ax_skb, 2);
 			skb_set_tail_pointer(ax_skb, ax_skb->len);
 			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(ax_skb, pkt_hdr);
+
+			if (last)
+				return 1;
+
 			usbnet_skb_return(dev, ax_skb);
-		} else {
-			return 0;
 		}
 
-		skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-		pkt_hdr++;
+		/* Trim this packet away from the SKB */
+		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+			return 0;
 	}
-	return 1;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ecbc09cbe259..f478fe7e2b82 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -272,9 +272,10 @@ static void __veth_xdp_flush(struct veth_rq *rq)
 {
 	/* Write ptr_ring before reading rx_notify_masked */
 	smp_mb();
-	if (!rq->rx_notify_masked) {
-		rq->rx_notify_masked = true;
-		napi_schedule(&rq->xdp_napi);
+	if (!READ_ONCE(rq->rx_notify_masked) &&
+	    napi_schedule_prep(&rq->xdp_napi)) {
+		WRITE_ONCE(rq->rx_notify_masked, true);
+		__napi_schedule(&rq->xdp_napi);
 	}
 }
 
@@ -919,8 +920,10 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
 		if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
-			rq->rx_notify_masked = true;
-			napi_schedule(&rq->xdp_napi);
+			if (napi_schedule_prep(&rq->xdp_napi)) {
+				WRITE_ONCE(rq->rx_notify_masked, true);
+				__napi_schedule(&rq->xdp_napi);
+			}
 		}
 	}
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 149ecf73df38..b925a5f4afc3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3300,7 +3300,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x0a54),	/* Intel P4500/P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DEALLOCATE_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x0a55),	/* Dell Express Flash P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4ae562d30d2b..efa9037da53c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -920,7 +920,15 @@ static inline void nvme_tcp_done_send_req(struct nvme_tcp_queue *queue)
 
 static void nvme_tcp_fail_request(struct nvme_tcp_request *req)
 {
-	nvme_tcp_end_request(blk_mq_rq_from_pdu(req), NVME_SC_HOST_PATH_ERROR);
+	if (nvme_tcp_async_req(req)) {
+		union nvme_result res = {};
+
+		nvme_complete_async_event(&req->queue->ctrl->ctrl,
+				cpu_to_le16(NVME_SC_HOST_PATH_ERROR), &res);
+	} else {
+		nvme_tcp_end_request(blk_mq_rq_from_pdu(req),
+				NVME_SC_HOST_PATH_ERROR);
+	}
 }
 
 static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
diff --git a/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c b/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
index cd2332bf0e31..fdbd64c03e12 100644
--- a/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
+++ b/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -250,7 +251,7 @@ static int phy_meson_axg_mipi_dphy_power_on(struct phy *phy)
 		     (DIV_ROUND_UP(priv->config.clk_zero, temp) << 16) |
 		     (DIV_ROUND_UP(priv->config.clk_prepare, temp) << 24));
 	regmap_write(priv->regmap, MIPI_DSI_CLK_TIM1,
-		     DIV_ROUND_UP(priv->config.clk_pre, temp));
+		     DIV_ROUND_UP(priv->config.clk_pre, BITS_PER_BYTE));
 
 	regmap_write(priv->regmap, MIPI_DSI_HS_TIM,
 		     DIV_ROUND_UP(priv->config.hs_exit, temp) |
diff --git a/drivers/phy/broadcom/Kconfig b/drivers/phy/broadcom/Kconfig
index fd92b73b7109..1dcfa3bd1442 100644
--- a/drivers/phy/broadcom/Kconfig
+++ b/drivers/phy/broadcom/Kconfig
@@ -95,8 +95,7 @@ config PHY_BRCM_USB
 	depends on OF
 	select GENERIC_PHY
 	select SOC_BRCMSTB if ARCH_BRCMSTB
-	default ARCH_BCM4908
-	default ARCH_BRCMSTB
+	default ARCH_BCM4908 || ARCH_BRCMSTB
 	help
 	  Enable this to support the Broadcom STB USB PHY.
 	  This driver is required by the USB XHCI, EHCI and OHCI
diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
index 288c9c67aa74..ccb4045685cd 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -36,7 +36,7 @@ int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
 
 	cfg->clk_miss = 0;
 	cfg->clk_post = 60000 + 52 * ui;
-	cfg->clk_pre = 8000;
+	cfg->clk_pre = 8;
 	cfg->clk_prepare = 38000;
 	cfg->clk_settle = 95000;
 	cfg->clk_term_en = 0;
@@ -97,7 +97,7 @@ int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
 	if (cfg->clk_post < (60000 + 52 * ui))
 		return -EINVAL;
 
-	if (cfg->clk_pre < 8000)
+	if (cfg->clk_pre < 8)
 		return -EINVAL;
 
 	if (cfg->clk_prepare < 38000 || cfg->clk_prepare > 95000)
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
index 347dc79a18c1..630e01b5c19b 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
@@ -5,6 +5,7 @@
  * Author: Wyon Bi <bivvy.bi@rock-chips.com>
  */
 
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/iopoll.h>
@@ -364,7 +365,7 @@ static void inno_dsidphy_mipi_mode_enable(struct inno_dsidphy *inno)
 	 * The value of counter for HS Tclk-pre
 	 * Tclk-pre = Tpin_txbyteclkhs * value
 	 */
-	clk_pre = DIV_ROUND_UP(cfg->clk_pre, t_txbyteclkhs);
+	clk_pre = DIV_ROUND_UP(cfg->clk_pre, BITS_PER_BYTE);
 
 	/*
 	 * The value of counter for HS Tlpx Time
diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 937a14fa7448..da05642d3bd4 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -225,7 +225,7 @@ static int stm32_usbphyc_pll_enable(struct stm32_usbphyc *usbphyc)
 
 		ret = __stm32_usbphyc_pll_disable(usbphyc);
 		if (ret)
-			return ret;
+			goto dec_n_pll_cons;
 	}
 
 	ret = stm32_usbphyc_regulators_enable(usbphyc);
diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 126f5b8735cc..8963fbf7aa73 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -233,6 +233,7 @@ static const struct clk_div_table clk_div_table[] = {
 	{ .val = 1, .div = 2, },
 	{ .val = 2, .div = 4, },
 	{ .val = 3, .div = 8, },
+	{ /* sentinel */ },
 };
 
 static const struct wiz_clk_div_sel clk_div_sel[] = {
diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index f478d8a17115..9be9535ad7ab 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -134,7 +134,8 @@
 #define PROT_BUS_WIDTH_10		0x0
 #define PROT_BUS_WIDTH_20		0x1
 #define PROT_BUS_WIDTH_40		0x2
-#define PROT_BUS_WIDTH_SHIFT		2
+#define PROT_BUS_WIDTH_SHIFT(n)		((n) * 2)
+#define PROT_BUS_WIDTH_MASK(n)		GENMASK((n) * 2 + 1, (n) * 2)
 
 /* Number of GT lanes */
 #define NUM_LANES			4
@@ -445,12 +446,12 @@ static void xpsgtr_phy_init_sata(struct xpsgtr_phy *gtr_phy)
 static void xpsgtr_phy_init_sgmii(struct xpsgtr_phy *gtr_phy)
 {
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
+	u32 mask = PROT_BUS_WIDTH_MASK(gtr_phy->lane);
+	u32 val = PROT_BUS_WIDTH_10 << PROT_BUS_WIDTH_SHIFT(gtr_phy->lane);
 
 	/* Set SGMII protocol TX and RX bus width to 10 bits. */
-	xpsgtr_write(gtr_dev, TX_PROT_BUS_WIDTH,
-		     PROT_BUS_WIDTH_10 << (gtr_phy->lane * PROT_BUS_WIDTH_SHIFT));
-	xpsgtr_write(gtr_dev, RX_PROT_BUS_WIDTH,
-		     PROT_BUS_WIDTH_10 << (gtr_phy->lane * PROT_BUS_WIDTH_SHIFT));
+	xpsgtr_clr_set(gtr_dev, TX_PROT_BUS_WIDTH, mask, val);
+	xpsgtr_clr_set(gtr_dev, RX_PROT_BUS_WIDTH, mask, val);
 
 	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
 }
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 8d14569823d7..61cde02b23fe 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1194,7 +1194,7 @@ static int io_subchannel_chp_event(struct subchannel *sch,
 			else
 				path_event[chpid] = PE_NONE;
 		}
-		if (cdev)
+		if (cdev && cdev->drv && cdev->drv->path_event)
 			cdev->drv->path_event(cdev, path_event);
 		break;
 	}
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 19fd9d263f47..f66ba64080a3 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1163,6 +1163,16 @@ struct lpfc_hba {
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_enable_fc4_type;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+#if (IS_ENABLED(CONFIG_NVME_FC))
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#else
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#endif
 	uint32_t cfg_aer_support;
 	uint32_t cfg_sriov_nr_virtfn;
 	uint32_t cfg_request_firmware_upgrade;
@@ -1184,9 +1194,6 @@ struct lpfc_hba {
 	uint32_t cfg_ras_fwlog_func;
 	uint32_t cfg_enable_bbcr;	/* Enable BB Credit Recovery */
 	uint32_t cfg_enable_dpp;	/* Enable Direct Packet Push */
-#define LPFC_ENABLE_FCP  1
-#define LPFC_ENABLE_NVME 2
-#define LPFC_ENABLE_BOTH 3
 	uint32_t cfg_enable_pbde;
 	uint32_t cfg_enable_mi;
 	struct nvmet_fc_target_port *targetport;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f20c4fe1fb8b..632b9cdabd14 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3978,8 +3978,8 @@ LPFC_ATTR_R(nvmet_mrq_post,
  *                    3 - register both FCP and NVME
  * Supported values are [1,3]. Default value is 3
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
-	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_DEF_ENBL_FC4_TYPE,
+	    LPFC_ENABLE_FCP, LPFC_MAX_ENBL_FC4_TYPE,
 	    "Enable FC4 Protocol support - FCP / NVME");
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2bbd1be6cc5d..3eebcae52784 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2055,7 +2055,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		}
 		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"3143 Port Down: Firmware Update "
 					"Detected\n");
 			en_rn_msg = false;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e5009f21d97e..2978c61dc586 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13366,6 +13366,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 	uint32_t uerr_sta_hi, uerr_sta_lo;
 	uint32_t if_type, portsmphr;
 	struct lpfc_register portstat_reg;
+	u32 logmask;
 
 	/*
 	 * For now, use the SLI4 device internal unrecoverable error
@@ -13416,7 +13417,12 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
 			phba->work_status[1] =
 				readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			logmask = LOG_TRACE_EVENT;
+			if (phba->work_status[0] ==
+				SLIPORT_ERR1_REG_ERR_CODE_2 &&
+			    phba->work_status[1] == SLIPORT_ERR2_REG_FW_RESTART)
+				logmask = LOG_SLI;
+			lpfc_printf_log(phba, KERN_ERR, logmask,
 					"2885 Port Status Event: "
 					"port status reg 0x%x, "
 					"port smphr reg 0x%x, "
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..a4d244ee4548 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2265,7 +2265,8 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	myrs_unmap(cs);
 
 	if (cs->mmio_base) {
-		cs->disable_intr(cs);
+		if (cs->disable_intr)
+			cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
 		cs->mmio_base = NULL;
 	}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index ed02e1aaf868..ed13e0e044b7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4154,10 +4154,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	u32 ret = MPI_IO_STATUS_FAIL;
 	u32 regval;
 
+	/*
+	 * Fatal errors are programmed to be signalled in irq vector
+	 * pm8001_ha->max_q_num - 1 through pm8001_ha->main_cfg_tbl.pm80xx_tbl.
+	 * fatal_err_interrupt
+	 */
 	if (vec == (pm8001_ha->max_q_num - 1)) {
+		u32 mipsall_ready;
+
+		if (pm8001_ha->chip_id == chip_8008 ||
+		    pm8001_ha->chip_id == chip_8009)
+			mipsall_ready = SCRATCH_PAD_MIPSALL_READY_8PORT;
+		else
+			mipsall_ready = SCRATCH_PAD_MIPSALL_READY_16PORT;
+
 		regval = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-		if ((regval & SCRATCH_PAD_MIPSALL_READY) !=
-					SCRATCH_PAD_MIPSALL_READY) {
+		if ((regval & mipsall_ready) != mipsall_ready) {
 			pm8001_ha->controller_fatal_error = true;
 			pm8001_dbg(pm8001_ha, FAIL,
 				   "Firmware Fatal error! Regval:0x%x\n",
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index c7e5d93bea92..c41ed039c92a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1405,8 +1405,12 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define SCRATCH_PAD_BOOT_LOAD_SUCCESS	0x0
 #define SCRATCH_PAD_IOP0_READY		0xC00
 #define SCRATCH_PAD_IOP1_READY		0x3000
-#define SCRATCH_PAD_MIPSALL_READY	(SCRATCH_PAD_IOP1_READY | \
+#define SCRATCH_PAD_MIPSALL_READY_16PORT	(SCRATCH_PAD_IOP1_READY | \
 					SCRATCH_PAD_IOP0_READY | \
+					SCRATCH_PAD_ILA_READY | \
+					SCRATCH_PAD_RAAE_READY)
+#define SCRATCH_PAD_MIPSALL_READY_8PORT	(SCRATCH_PAD_IOP0_READY | \
+					SCRATCH_PAD_ILA_READY | \
 					SCRATCH_PAD_RAAE_READY)
 
 /* boot loader state */
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 3404782988d5..bb5761ed3f51 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2257,6 +2257,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	    io_req->tm_flags == FCP_TMF_TGT_RESET) {
 		clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 		io_req->sc_cmd = NULL;
+		kref_put(&io_req->refcount, qedf_release_cmd);
 		complete(&io_req->tm_done);
 	}
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 94ee08fab46a..544401f76c07 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -911,7 +911,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qed_link_output if_link;
 
 	if (lport->vport) {
-		QEDF_ERR(NULL, "Cannot issue host reset on NPIV port.\n");
+		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
@@ -1862,6 +1862,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->cmd_mgr = base_qedf->cmd_mgr;
 	init_completion(&vport_qedf->flogi_compl);
 	INIT_LIST_HEAD(&vport_qedf->fcports);
+	INIT_DELAYED_WORK(&vport_qedf->stag_work, qedf_stag_change_work);
 
 	rc = qedf_vport_libfc_config(vport, vn_port);
 	if (rc) {
@@ -3978,7 +3979,9 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
-	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
+	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
+			dev_name(&qedf->pdev->dev), __func__, __LINE__,
+			qedf->dbg_ctx.host_no);
 	qedf_ctx_soft_reset(qedf->lport);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8b16bbbcb806..87975d1a21c8 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,11 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
+		if (!clki->name) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -127,6 +132,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		return -ENOMEM;
 
 	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!vreg->name)
+		return -ENOMEM;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ae7bdd870319..f489954e4632 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8473,7 +8473,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
  * @pwr_mode: device power mode to set
  *
  * Returns 0 if requested power mode is set successfully
- * Returns non-zero if failed to set the requested power mode
+ * Returns < 0 if failed to set the requested power mode
  */
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
@@ -8527,8 +8527,11 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (ret > 0 && scsi_sense_valid(&sshdr))
-			scsi_print_sense_hdr(sdp, NULL, &sshdr);
+		if (ret > 0) {
+			if (scsi_sense_valid(&sshdr))
+				scsi_print_sense_hdr(sdp, NULL, &sshdr);
+			ret = -EIO;
+		}
 	}
 
 	if (!ret)
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index de95be5d11d4..3ed60068c4ea 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -142,7 +142,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
-				CRYPTO_ENGINE_FATAL_ERROR)
+				CRYPTO_ENGINE_FATAL_ERROR |\
+				UIC_LINK_LOST)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
index 76f8c090a837..06afaa9d505b 100644
--- a/drivers/staging/fbtft/fbtft.h
+++ b/drivers/staging/fbtft/fbtft.h
@@ -332,7 +332,10 @@ static int __init fbtft_driver_module_init(void)                           \
 	ret = spi_register_driver(&fbtft_driver_spi_driver);               \
 	if (ret < 0)                                                       \
 		return ret;                                                \
-	return platform_driver_register(&fbtft_driver_platform_driver);    \
+	ret = platform_driver_register(&fbtft_driver_platform_driver);     \
+	if (ret < 0)                                                       \
+		spi_unregister_driver(&fbtft_driver_spi_driver);           \
+	return ret;                                                        \
 }                                                                          \
 									   \
 static void __exit fbtft_driver_module_exit(void)                          \
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 8075f60fd02c..2d5cf1714ae0 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -443,6 +443,9 @@ static bool iscsit_tpg_check_network_portal(
 				break;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
+
+		if (match)
+			break;
 	}
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
diff --git a/drivers/thermal/intel/int340x_thermal/Kconfig b/drivers/thermal/intel/int340x_thermal/Kconfig
index 45c31f3d6054..5d046de96a5d 100644
--- a/drivers/thermal/intel/int340x_thermal/Kconfig
+++ b/drivers/thermal/intel/int340x_thermal/Kconfig
@@ -5,12 +5,12 @@
 
 config INT340X_THERMAL
 	tristate "ACPI INT340X thermal drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86_64 && ACPI && PCI
 	select THERMAL_GOV_USER_SPACE
 	select ACPI_THERMAL_REL
 	select ACPI_FAN
 	select INTEL_SOC_DTS_IOSF_CORE
-	select PROC_THERMAL_MMIO_RAPL if X86_64 && POWERCAP
+	select PROC_THERMAL_MMIO_RAPL if POWERCAP
 	help
 	  Newer laptops and tablets that use ACPI may have thermal sensors and
 	  other devices with thermal control capabilities outside the core
diff --git a/drivers/thermal/intel/int340x_thermal/int3401_thermal.c b/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
index acebc8ba94e2..217786fba185 100644
--- a/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
@@ -44,15 +44,21 @@ static int int3401_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int int3401_thermal_suspend(struct device *dev)
+{
+	return proc_thermal_suspend(dev);
+}
 static int int3401_thermal_resume(struct device *dev)
 {
 	return proc_thermal_resume(dev);
 }
 #else
+#define int3401_thermal_suspend NULL
 #define int3401_thermal_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(int3401_proc_thermal_pm, NULL, int3401_thermal_resume);
+static SIMPLE_DEV_PM_OPS(int3401_proc_thermal_pm, int3401_thermal_suspend,
+			 int3401_thermal_resume);
 
 static struct platform_driver int3401_driver = {
 	.probe = int3401_add,
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index fb64acfd5e07..a8d98f1bd6c6 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -68,8 +68,7 @@ static const struct attribute_group power_limit_attribute_group = {
 	.name = "power_limits"
 };
 
-static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static int tcc_get_offset(void)
 {
 	u64 val;
 	int err;
@@ -78,8 +77,20 @@ static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
 	if (err)
 		return err;
 
-	val = (val >> 24) & 0x3f;
-	return sprintf(buf, "%d\n", (int)val);
+	return (val >> 24) & 0x3f;
+}
+
+static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	int tcc;
+
+	tcc = tcc_get_offset();
+	if (tcc < 0)
+		return tcc;
+
+	return sprintf(buf, "%d\n", tcc);
 }
 
 static int tcc_offset_update(unsigned int tcc)
@@ -107,8 +118,6 @@ static int tcc_offset_update(unsigned int tcc)
 	return 0;
 }
 
-static int tcc_offset_save = -1;
-
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
@@ -131,8 +140,6 @@ static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 	if (err)
 		return err;
 
-	tcc_offset_save = tcc;
-
 	return count;
 }
 
@@ -345,6 +352,18 @@ void proc_thermal_remove(struct proc_thermal_device *proc_priv)
 }
 EXPORT_SYMBOL_GPL(proc_thermal_remove);
 
+static int tcc_offset_save = -1;
+
+int proc_thermal_suspend(struct device *dev)
+{
+	tcc_offset_save = tcc_get_offset();
+	if (tcc_offset_save < 0)
+		dev_warn(dev, "failed to save offset (%d)\n", tcc_offset_save);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(proc_thermal_suspend);
+
 int proc_thermal_resume(struct device *dev)
 {
 	struct proc_thermal_device *proc_dev;
@@ -352,6 +371,7 @@ int proc_thermal_resume(struct device *dev)
 	proc_dev = dev_get_drvdata(dev);
 	proc_thermal_read_ppcc(proc_dev);
 
+	/* Do not update if saving failed */
 	if (tcc_offset_save >= 0)
 		tcc_offset_update(tcc_offset_save);
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
index 5a1cfe4864f1..9b2a64ef55d0 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -80,9 +80,11 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv);
 void proc_thermal_mbox_remove(struct pci_dev *pdev);
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp);
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp);
+int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
+int proc_thermal_suspend(struct device *dev);
 int proc_thermal_resume(struct device *dev);
 int proc_thermal_mmio_add(struct pci_dev *pdev,
 			  struct proc_thermal_device *proc_priv,
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index 11dd2e825f4f..b4bcd3fe9eb2 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -314,6 +314,20 @@ static void proc_thermal_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int proc_thermal_pci_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct proc_thermal_device *proc_priv;
+	struct proc_thermal_pci *pci_info;
+
+	proc_priv = pci_get_drvdata(pdev);
+	pci_info = proc_priv->priv_data;
+
+	if (!pci_info->no_legacy)
+		return proc_thermal_suspend(dev);
+
+	return 0;
+}
 static int proc_thermal_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -335,10 +349,12 @@ static int proc_thermal_pci_resume(struct device *dev)
 	return 0;
 }
 #else
+#define proc_thermal_pci_suspend NULL
 #define proc_thermal_pci_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, NULL, proc_thermal_pci_resume);
+static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, proc_thermal_pci_suspend,
+			 proc_thermal_pci_resume);
 
 static const struct pci_device_id proc_thermal_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, ADL_THERMAL, PROC_THERMAL_FEATURE_RAPL | PROC_THERMAL_FEATURE_FIVR | PROC_THERMAL_FEATURE_DVFS | PROC_THERMAL_FEATURE_MBOX) },
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
index f5fc1791b11e..4571a1a53b84 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
@@ -107,15 +107,21 @@ static void proc_thermal_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int proc_thermal_pci_suspend(struct device *dev)
+{
+	return proc_thermal_suspend(dev);
+}
 static int proc_thermal_pci_resume(struct device *dev)
 {
 	return proc_thermal_resume(dev);
 }
 #else
+#define proc_thermal_pci_suspend NULL
 #define proc_thermal_pci_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, NULL, proc_thermal_pci_resume);
+static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, proc_thermal_pci_suspend,
+			 proc_thermal_pci_resume);
 
 static const struct pci_device_id proc_thermal_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, BDW_THERMAL, 0) },
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
index 66cd0190bc03..0b89a4340ff4 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
@@ -24,19 +24,15 @@
 
 static DEFINE_MUTEX(mbox_lock);
 
-static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+static int wait_for_mbox_ready(struct proc_thermal_device *proc_priv)
 {
-	struct proc_thermal_device *proc_priv;
 	u32 retries, data;
 	int ret;
 
-	mutex_lock(&mbox_lock);
-	proc_priv = pci_get_drvdata(pdev);
-
 	/* Poll for rb bit == 0 */
 	retries = MBOX_RETRY_COUNT;
 	do {
-		data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
+		data = readl(proc_priv->mmio_base + MBOX_OFFSET_INTERFACE);
 		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
 			ret = -EBUSY;
 			continue;
@@ -45,49 +41,78 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cm
 		break;
 	} while (--retries);
 
+	return ret;
+}
+
+static int send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
+{
+	struct proc_thermal_device *proc_priv;
+	u32 reg_data;
+	int ret;
+
+	proc_priv = pci_get_drvdata(pdev);
+
+	mutex_lock(&mbox_lock);
+
+	ret = wait_for_mbox_ready(proc_priv);
 	if (ret)
 		goto unlock_mbox;
 
-	if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_WRITE)
-		writel(cmd_data, (void __iomem *) ((proc_priv->mmio_base + MBOX_OFFSET_DATA)));
-
+	writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
 	/* Write command register */
-	data = BIT_ULL(MBOX_BUSY_BIT) | cmd_id;
-	writel(data, (void __iomem *) ((proc_priv->mmio_base + MBOX_OFFSET_INTERFACE)));
+	reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
+	writel(reg_data, (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
 
-	/* Poll for rb bit == 0 */
-	retries = MBOX_RETRY_COUNT;
-	do {
-		data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
-		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
-			ret = -EBUSY;
-			continue;
-		}
+	ret = wait_for_mbox_ready(proc_priv);
 
-		if (data) {
-			ret = -ENXIO;
-			goto unlock_mbox;
-		}
+unlock_mbox:
+	mutex_unlock(&mbox_lock);
+	return ret;
+}
 
-		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ) {
-			data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
-			*cmd_resp = data & 0xff;
-		}
+static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
+{
+	struct proc_thermal_device *proc_priv;
+	u32 reg_data;
+	int ret;
 
-		ret = 0;
-		break;
-	} while (--retries);
+	proc_priv = pci_get_drvdata(pdev);
+
+	mutex_lock(&mbox_lock);
+
+	ret = wait_for_mbox_ready(proc_priv);
+	if (ret)
+		goto unlock_mbox;
+
+	/* Write command register */
+	reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
+	writel(reg_data, (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
+
+	ret = wait_for_mbox_ready(proc_priv);
+	if (ret)
+		goto unlock_mbox;
+
+	if (id == MBOX_CMD_WORKLOAD_TYPE_READ)
+		*resp = readl(proc_priv->mmio_base + MBOX_OFFSET_DATA);
+	else
+		*resp = readq(proc_priv->mmio_base + MBOX_OFFSET_DATA);
 
 unlock_mbox:
 	mutex_unlock(&mbox_lock);
 	return ret;
 }
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
 {
-	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
+	return send_mbox_read_cmd(pdev, id, resp);
 }
-EXPORT_SYMBOL_GPL(processor_thermal_send_mbox_cmd);
+EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_read_cmd, INT340X_THERMAL);
+
+int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
+{
+	return send_mbox_write_cmd(pdev, id, data);
+}
+EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_write_cmd, INT340X_THERMAL);
 
 /* List of workload types */
 static const char * const workload_types[] = {
@@ -100,7 +125,6 @@ static const char * const workload_types[] = {
 	NULL
 };
 
-
 static ssize_t workload_available_types_show(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
@@ -142,7 +166,7 @@ static ssize_t workload_type_store(struct device *dev,
 
 	data |= ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data, NULL);
+	ret = send_mbox_write_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data);
 	if (ret)
 		return false;
 
@@ -154,10 +178,10 @@ static ssize_t workload_type_show(struct device *dev,
 				   char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, &cmd_resp);
 	if (ret)
 		return false;
 
@@ -182,17 +206,15 @@ static const struct attribute_group workload_req_attribute_group = {
 	.name = "workload_request"
 };
 
-
-
 static bool workload_req_created;
 
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
 {
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	/* Check if there is a mailbox support, if fails return success */
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, &cmd_resp);
 	if (ret)
 		return 0;
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 3b3e81f99a34..8c42e7662033 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -9,6 +9,8 @@
 #include <linux/pci.h>
 #include "processor_thermal_device.h"
 
+MODULE_IMPORT_NS(INT340X_THERMAL);
+
 struct mmio_reg {
 	int read_only;
 	u32 offset;
@@ -194,8 +196,7 @@ static ssize_t rfi_restriction_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	u16 cmd_id = 0x0008;
-	u32 cmd_resp;
+	u16 id = 0x0008;
 	u32 input;
 	int ret;
 
@@ -203,7 +204,7 @@ static ssize_t rfi_restriction_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, input, &cmd_resp);
+	ret = processor_thermal_send_mbox_write_cmd(to_pci_dev(dev), id, input);
 	if (ret)
 		return ret;
 
@@ -214,30 +215,30 @@ static ssize_t rfi_restriction_show(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
-	u16 cmd_id = 0x0007;
-	u32 cmd_resp;
+	u16 id = 0x0007;
+	u64 resp;
 	int ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, &resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", resp);
 }
 
 static ssize_t ddr_data_rate_show(struct device *dev,
 				  struct device_attribute *attr,
 				  char *buf)
 {
-	u16 cmd_id = 0x0107;
-	u32 cmd_resp;
+	u16 id = 0x0107;
+	u64 resp;
 	int ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, &resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", resp);
 }
 
 static DEVICE_ATTR_RW(rfi_restriction);
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0ec93f1a61f5..451e02cd0637 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1369,7 +1369,7 @@ static void n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 			put_tty_queue(c, ldata);
 			smp_store_release(&ldata->canon_head, ldata->read_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-			wake_up_interruptible_poll(&tty->read_wait, EPOLLIN);
+			wake_up_interruptible_poll(&tty->read_wait, EPOLLIN | EPOLLRDNORM);
 			return;
 		}
 	}
@@ -1589,7 +1589,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	if (read_cnt(ldata)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-		wake_up_interruptible_poll(&tty->read_wait, EPOLLIN);
+		wake_up_interruptible_poll(&tty->read_wait, EPOLLIN | EPOLLRDNORM);
 	}
 }
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 3639bb6dc372..58013698635f 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -599,8 +599,8 @@ static int vt_setactivate(struct vt_setactivate __user *sa)
 	if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 		return -ENXIO;
 
-	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES + 1);
 	vsa.console--;
+	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES);
 	console_lock();
 	ret = vc_allocate(vsa.console);
 	if (ret) {
@@ -845,6 +845,7 @@ int vt_ioctl(struct tty_struct *tty,
 			return -ENXIO;
 
 		arg--;
+		arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 		console_lock();
 		ret = vc_allocate(arg);
 		console_unlock();
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 8f8405b0d608..5509d3847af4 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -130,6 +130,7 @@ static const struct attribute_group *ulpi_dev_attr_groups[] = {
 
 static void ulpi_dev_release(struct device *dev)
 {
+	of_node_put(dev->of_node);
 	kfree(to_ulpi_dev(dev));
 }
 
@@ -247,12 +248,16 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 		return ret;
 
 	ret = ulpi_read_id(ulpi);
-	if (ret)
+	if (ret) {
+		of_node_put(ulpi->dev.of_node);
 		return ret;
+	}
 
 	ret = device_register(&ulpi->dev);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ret;
+	}
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
 		ulpi->id.vendor, ulpi->id.product);
@@ -299,7 +304,6 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	of_node_put(ulpi->dev.of_node);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index ea0d2d6139a6..0909b088a284 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -5096,7 +5096,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4c16805a2b31..146cebde33b8 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1271,6 +1271,19 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
 	if (usb_endpoint_xfer_bulk(dep->endpoint.desc) && dep->stream_capable)
 		trb->ctrl |= DWC3_TRB_CTRL_SID_SOFN(stream_id);
 
+	/*
+	 * As per data book 4.2.3.2TRB Control Bit Rules section
+	 *
+	 * The controller autonomously checks the HWO field of a TRB to determine if the
+	 * entire TRB is valid. Therefore, software must ensure that the rest of the TRB
+	 * is valid before setting the HWO field to '1'. In most systems, this means that
+	 * software must update the fourth DWORD of a TRB last.
+	 *
+	 * However there is a possibility of CPU re-ordering here which can cause
+	 * controller to observe the HWO bit set prematurely.
+	 * Add a write memory barrier to prevent CPU re-ordering.
+	 */
+	wmb();
 	trb->ctrl |= DWC3_TRB_CTRL_HWO;
 
 	dwc3_ep_inc_enq(dep);
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 3789c329183c..553382ce3837 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1975,6 +1975,9 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				if (w_index != 0x5 || (w_value >> 8))
 					break;
 				interface = w_value & 0xFF;
+				if (interface >= MAX_CONFIG_INTERFACES ||
+				    !os_desc_cfg->interface[interface])
+					break;
 				buf[6] = w_index;
 				count = count_ext_prop(os_desc_cfg,
 					interface);
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 782d67c2c6e0..02f70c5c65fc 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1711,16 +1711,24 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
 			ffs->state = FFS_DEACTIVATED;
-			if (ffs->epfiles) {
-				ffs_epfiles_destroy(ffs->epfiles,
-						   ffs->eps_count);
-				ffs->epfiles = NULL;
-			}
+			spin_lock_irqsave(&ffs->eps_lock, flags);
+			epfiles = ffs->epfiles;
+			ffs->epfiles = NULL;
+			spin_unlock_irqrestore(&ffs->eps_lock,
+							flags);
+
+			if (epfiles)
+				ffs_epfiles_destroy(epfiles,
+						 ffs->eps_count);
+
 			if (ffs->setup_state == FFS_SETUP_PENDING)
 				__ffs_ep0_stall(ffs);
 		} else {
@@ -1767,14 +1775,27 @@ static struct ffs_data *ffs_data_new(const char *dev_name)
 
 static void ffs_data_clear(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	ffs_closed(ffs);
 
 	BUG_ON(ffs->gadget);
 
-	if (ffs->epfiles) {
-		ffs_epfiles_destroy(ffs->epfiles, ffs->eps_count);
+	spin_lock_irqsave(&ffs->eps_lock, flags);
+	epfiles = ffs->epfiles;
+	ffs->epfiles = NULL;
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
+
+	/*
+	 * potential race possible between ffs_func_eps_disable
+	 * & ffs_epfile_release therefore maintaining a local
+	 * copy of epfile will save us from use-after-free.
+	 */
+	if (epfiles) {
+		ffs_epfiles_destroy(epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -1922,12 +1943,15 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = func->ffs->epfiles;
-	unsigned count            = func->ffs->eps_count;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	count = func->ffs->eps_count;
+	epfile = func->ffs->epfiles;
+	ep = func->eps;
 	while (count--) {
 		/* pending requests get nuked */
 		if (ep->ep)
@@ -1945,14 +1969,18 @@ static void ffs_func_eps_disable(struct ffs_function *func)
 
 static int ffs_func_eps_enable(struct ffs_function *func)
 {
-	struct ffs_data *ffs      = func->ffs;
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = ffs->epfiles;
-	unsigned count            = ffs->eps_count;
+	struct ffs_data *ffs;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	ffs = func->ffs;
+	ep = func->eps;
+	epfile = ffs->epfiles;
+	count = ffs->eps_count;
 	while(count--) {
 		ep->ep->driver_data = ep;
 
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index ef55b8bb5870..5226a47b68fd 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -202,7 +202,7 @@ static struct uac2_input_terminal_descriptor io_in_it_desc = {
 
 	.bDescriptorSubtype = UAC_INPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_INPUT_TERMINAL_MICROPHONE),
 	.bAssocTerminal = 0,
 	/* .bCSourceID = DYNAMIC */
 	.iChannelNames = 0,
@@ -230,7 +230,7 @@ static struct uac2_output_terminal_descriptor io_out_ot_desc = {
 
 	.bDescriptorSubtype = UAC_OUTPUT_TERMINAL,
 	/* .bTerminalID = DYNAMIC */
-	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_UNDEFINED),
+	.wTerminalType = cpu_to_le16(UAC_OUTPUT_TERMINAL_SPEAKER),
 	.bAssocTerminal = 0,
 	/* .bSourceID = DYNAMIC */
 	/* .bCSourceID = DYNAMIC */
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 64de9f1b874c..d9ed651f06ac 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -637,14 +637,17 @@ static int rndis_set_response(struct rndis_params *params,
 	rndis_set_cmplt_type *resp;
 	rndis_resp_t *r;
 
+	BufLength = le32_to_cpu(buf->InformationBufferLength);
+	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
+	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
+		    return -EINVAL;
+
 	r = rndis_add_response(params, sizeof(rndis_set_cmplt_type));
 	if (!r)
 		return -ENOMEM;
 	resp = (rndis_set_cmplt_type *)r->buf;
 
-	BufLength = le32_to_cpu(buf->InformationBufferLength);
-	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
-
 #ifdef	VERBOSE_DEBUG
 	pr_debug("%s: Length: %d\n", __func__, BufLength);
 	pr_debug("%s: Offset: %d\n", __func__, BufOffset);
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index c5a2c734234a..d86c3a36441e 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -1004,7 +1004,7 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	if ((in && !ep->ep->caps.dir_in) || (!in && ep->ep->caps.dir_in)) {
+	if (in != usb_endpoint_dir_in(ep->ep->desc)) {
 		dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
 		ret = -EINVAL;
 		goto out_unlock;
diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 57d417a7c3e0..601829a6b4ba 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2378,6 +2378,8 @@ static void handle_ext_role_switch_states(struct device *dev,
 	switch (role) {
 	case USB_ROLE_NONE:
 		usb3->connection_state = USB_ROLE_NONE;
+		if (cur_role == USB_ROLE_HOST)
+			device_release_driver(host);
 		if (usb3->driver)
 			usb3_disconnect(usb3);
 		usb3_vbus_out(usb3, false);
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2db917eab799..4b65e6904499 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -85,6 +85,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x2184, 0x0057) },
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x9986, 0x7523) },
 	{ },
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 22e62c01c0aa..08554e154842 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -51,6 +51,7 @@ static void cp210x_enable_event_mode(struct usb_serial_port *port);
 static void cp210x_disable_event_mode(struct usb_serial_port *port);
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x0404, 0x034C) },	/* NCR Retail IO Box */
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
@@ -68,6 +69,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
 	{ USB_DEVICE(0x0FCF, 0x1006) }, /* Dynastream ANT development board */
 	{ USB_DEVICE(0x0FDE, 0xCA05) }, /* OWL Wireless Electricity Monitor CM-160 */
+	{ USB_DEVICE(0x106F, 0x0003) },	/* CPI / Money Controls Bulk Coin Recycler */
 	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
 	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
 	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 99d19828dae6..7e852561d55c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -969,6 +969,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_023_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_034_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_101_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_159_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_3_PID) },
@@ -977,12 +978,14 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_6_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_7_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_8_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_235_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_257_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_4_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_313_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_320_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_324_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 755858ca20ba..d1a9564697a4 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1506,6 +1506,9 @@
 #define BRAINBOXES_VX_023_PID		0x1003 /* VX-023 ExpressCard 1 Port RS422/485 */
 #define BRAINBOXES_VX_034_PID		0x1004 /* VX-034 ExpressCard 2 Port RS422/485 */
 #define BRAINBOXES_US_101_PID		0x1011 /* US-101 1xRS232 */
+#define BRAINBOXES_US_159_PID		0x1021 /* US-159 1xRS232 */
+#define BRAINBOXES_US_235_PID		0x1017 /* US-235 1xRS232 */
+#define BRAINBOXES_US_320_PID		0x1019 /* US-320 1xRS422/485 */
 #define BRAINBOXES_US_324_PID		0x1013 /* US-324 1xRS422/485 1Mbaud */
 #define BRAINBOXES_US_606_1_PID		0x2001 /* US-606 6 Port RS232 Serial Port 1 and 2 */
 #define BRAINBOXES_US_606_2_PID		0x2002 /* US-606 6 Port RS232 Serial Port 3 and 4 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 42420bfc983c..962e9943fc20 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1649,6 +1649,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x1476, 0xff) },	/* GosunCn ZTE WeLink ME3630 (ECM/NCM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1481, 0xff, 0x00, 0x00) }, /* ZTE MF871A */
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1485, 0xff, 0xff, 0xff),  /* ZTE MF286D */
+	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index f7b7d35953e8..a53c1f6906f0 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1025,7 +1025,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	struct vc_data *svc = *default_mode;
 	struct fbcon_display *t, *p = &fb_display[vc->vc_num];
 	int logo = 1, new_rows, new_cols, rows, cols;
-	int cap, ret;
+	int ret;
 
 	if (WARN_ON(info_idx == -1))
 	    return;
@@ -1034,7 +1034,6 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con2fb_map[vc->vc_num] = info_idx;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
-	cap = info->flags;
 
 	if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
 		logo_shown = FBCON_LOGO_DONTSHOW;
@@ -1137,8 +1136,8 @@ static void fbcon_init(struct vc_data *vc, int init)
 	ops->graphics = 0;
 
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
-	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
-	    !(cap & FBINFO_HWACCEL_DISABLED))
+	if ((info->flags & FBINFO_HWACCEL_COPYAREA) &&
+	    !(info->flags & FBINFO_HWACCEL_DISABLED))
 		p->scrollmode = SCROLL_MOVE;
 	else /* default to something safe */
 		p->scrollmode = SCROLL_REDRAW;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c559827cb6f9..f6d3b3e13d72 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -711,10 +711,11 @@ static int gfs2_release(struct inode *inode, struct file *file)
 	kfree(file->private_data);
 	file->private_data = NULL;
 
-	if (gfs2_rs_active(&ip->i_res))
-		gfs2_rs_delete(ip, &inode->i_writecount);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
+		if (gfs2_rs_active(&ip->i_res))
+			gfs2_rs_delete(ip, &inode->i_writecount);
 		gfs2_qa_put(ip);
+	}
 	return 0;
 }
 
diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index 6a2033131c06..ccd4f245cae2 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -170,7 +170,7 @@ struct cb_devicenotifyitem {
 };
 
 struct cb_devicenotifyargs {
-	int				 ndevs;
+	uint32_t			 ndevs;
 	struct cb_devicenotifyitem	 *devs;
 };
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index ed9d580826f5..f2bc5b5b764b 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -358,7 +358,7 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
-	int i;
+	uint32_t i;
 	__be32 res = 0;
 	struct nfs_client *clp = cps->clp;
 	struct nfs_server *server = NULL;
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 4c48d85f6517..ce3d1d5b1291 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -258,11 +258,9 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 				void *argp)
 {
 	struct cb_devicenotifyargs *args = argp;
+	uint32_t tmp, n, i;
 	__be32 *p;
 	__be32 status = 0;
-	u32 tmp;
-	int n, i;
-	args->ndevs = 0;
 
 	/* Num of device notifications */
 	p = xdr_inline_decode(xdr, sizeof(uint32_t));
@@ -271,7 +269,7 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 		goto out;
 	}
 	n = ntohl(*p++);
-	if (n <= 0)
+	if (n == 0)
 		goto out;
 	if (n > ULONG_MAX / sizeof(*args->devs)) {
 		status = htonl(NFS4ERR_BADXDR);
@@ -330,19 +328,21 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 			dev->cbd_immediate = 0;
 		}
 
-		args->ndevs++;
-
 		dprintk("%s: type %d layout 0x%x immediate %d\n",
 			__func__, dev->cbd_notify_type, dev->cbd_layout_type,
 			dev->cbd_immediate);
 	}
+	args->ndevs = n;
+	dprintk("%s: ndevs %d\n", __func__, args->ndevs);
+	return 0;
+err:
+	kfree(args->devs);
 out:
+	args->devs = NULL;
+	args->ndevs = 0;
 	dprintk("%s: status %d ndevs %d\n",
 		__func__, ntohl(status), args->ndevs);
 	return status;
-err:
-	kfree(args->devs);
-	goto out;
 }
 
 static __be32 decode_sessionid(struct xdr_stream *xdr,
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 23e165d5ec9c..090b16890e3d 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -177,6 +177,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 	INIT_LIST_HEAD(&clp->cl_superblocks);
 	clp->cl_rpcclient = ERR_PTR(-EINVAL);
 
+	clp->cl_flags = cl_init->init_flags;
 	clp->cl_proto = cl_init->proto;
 	clp->cl_nconnect = cl_init->nconnect;
 	clp->cl_max_connect = cl_init->max_connect ? cl_init->max_connect : 1;
@@ -427,7 +428,6 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 			list_add_tail(&new->cl_share_link,
 					&nn->nfs_client_list);
 			spin_unlock(&nn->nfs_client_lock);
-			new->cl_flags = cl_init->init_flags;
 			return rpc_ops->init_client(new, cl_init);
 		}
 
@@ -860,6 +860,13 @@ int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs
 			server->namelen = pathinfo.max_namelen;
 	}
 
+	if (clp->rpc_ops->discover_trunking != NULL &&
+			(server->caps & NFS_CAP_FS_LOCATIONS)) {
+		error = clp->rpc_ops->discover_trunking(server, mntfh);
+		if (error < 0)
+			return error;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nfs_probe_fsinfo);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ed79c1bd84a2..f6381c675cbe 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -870,7 +870,8 @@ static int nfs_readdir_xdr_to_array(struct nfs_readdir_descriptor *desc,
 
 		status = nfs_readdir_page_filler(desc, entry, pages, pglen,
 						 arrays, narrays);
-	} while (!status && nfs_readdir_page_needs_filling(page));
+	} while (!status && nfs_readdir_page_needs_filling(page) &&
+		page_mapping(page));
 
 	nfs_readdir_free_pages(pages, array_size);
 out_release_label:
@@ -1048,6 +1049,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 		goto out;
 
 	desc->page_index = 0;
+	desc->cache_entry_index = 0;
 	desc->last_cookie = desc->dir_cookie;
 	desc->duped = 0;
 
@@ -2697,7 +2699,7 @@ static struct nfs_access_entry *nfs_access_search_rbtree(struct inode *inode, co
 	return NULL;
 }
 
-static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res, bool may_block)
+static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, u32 *mask, bool may_block)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_access_entry *cache;
@@ -2727,8 +2729,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 		spin_lock(&inode->i_lock);
 		retry = false;
 	}
-	res->cred = cache->cred;
-	res->mask = cache->mask;
+	*mask = cache->mask;
 	list_move_tail(&cache->lru, &nfsi->access_cache_entry_lru);
 	err = 0;
 out:
@@ -2740,7 +2741,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 	return -ENOENT;
 }
 
-static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res)
+static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, u32 *mask)
 {
 	/* Only check the most recently returned cache entry,
 	 * but do it without locking.
@@ -2762,22 +2763,21 @@ static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cre
 		goto out;
 	if (nfs_check_cache_invalid(inode, NFS_INO_INVALID_ACCESS))
 		goto out;
-	res->cred = cache->cred;
-	res->mask = cache->mask;
+	*mask = cache->mask;
 	err = 0;
 out:
 	rcu_read_unlock();
 	return err;
 }
 
-int nfs_access_get_cached(struct inode *inode, const struct cred *cred, struct
-nfs_access_entry *res, bool may_block)
+int nfs_access_get_cached(struct inode *inode, const struct cred *cred,
+			  u32 *mask, bool may_block)
 {
 	int status;
 
-	status = nfs_access_get_cached_rcu(inode, cred, res);
+	status = nfs_access_get_cached_rcu(inode, cred, mask);
 	if (status != 0)
-		status = nfs_access_get_cached_locked(inode, cred, res,
+		status = nfs_access_get_cached_locked(inode, cred, mask,
 		    may_block);
 
 	return status;
@@ -2898,7 +2898,7 @@ static int nfs_do_access(struct inode *inode, const struct cred *cred, int mask)
 
 	trace_nfs_access_enter(inode);
 
-	status = nfs_access_get_cached(inode, cred, &cache, may_block);
+	status = nfs_access_get_cached(inode, cred, &cache.mask, may_block);
 	if (status == 0)
 		goto out_cached;
 
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index ba78df4b13d9..f8672a34fd63 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -261,8 +261,8 @@ struct nfs4_state_maintenance_ops {
 };
 
 struct nfs4_mig_recovery_ops {
-	int (*get_locations)(struct inode *, struct nfs4_fs_locations *,
-		struct page *, const struct cred *);
+	int (*get_locations)(struct nfs_server *, struct nfs_fh *,
+		struct nfs4_fs_locations *, struct page *, const struct cred *);
 	int (*fsid_present)(struct inode *, const struct cred *);
 };
 
@@ -281,7 +281,8 @@ struct rpc_clnt *nfs4_negotiate_security(struct rpc_clnt *, struct inode *,
 int nfs4_submount(struct fs_context *, struct nfs_server *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
-
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net, int port);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_async_handle_error(struct rpc_task *task,
@@ -303,8 +304,9 @@ extern int nfs4_do_close(struct nfs4_state *state, gfp_t gfp_mask, int wait);
 extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle);
 extern int nfs4_proc_fs_locations(struct rpc_clnt *, struct inode *, const struct qstr *,
 				  struct nfs4_fs_locations *, struct page *);
-extern int nfs4_proc_get_locations(struct inode *, struct nfs4_fs_locations *,
-		struct page *page, const struct cred *);
+extern int nfs4_proc_get_locations(struct nfs_server *, struct nfs_fh *,
+				   struct nfs4_fs_locations *,
+				   struct page *page, const struct cred *);
 extern int nfs4_proc_fsid_present(struct inode *, const struct cred *);
 extern struct rpc_clnt *nfs4_proc_lookup_mountpoint(struct inode *,
 						    struct dentry *,
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index af57332503be..ed06b68b2b4e 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1368,8 +1368,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	}
 	nfs_put_client(clp);
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	return nfs_probe_destination(server);
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 873342308dc0..3680c8da510c 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -164,16 +164,21 @@ static int nfs4_validate_fspath(struct dentry *dentry,
 	return 0;
 }
 
-static size_t nfs_parse_server_name(char *string, size_t len,
-		struct sockaddr *sa, size_t salen, struct net *net)
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net, int port)
 {
 	ssize_t ret;
 
 	ret = rpc_pton(net, string, len, sa, salen);
 	if (ret == 0) {
-		ret = nfs_dns_resolve_name(net, string, len, sa, salen);
-		if (ret < 0)
-			ret = 0;
+		ret = rpc_uaddr2sockaddr(net, string, len, sa, salen);
+		if (ret == 0) {
+			ret = nfs_dns_resolve_name(net, string, len, sa, salen);
+			if (ret < 0)
+				ret = 0;
+		}
+	} else if (port) {
+		rpc_set_port(sa, port);
 	}
 	return ret;
 }
@@ -328,7 +333,7 @@ static int try_location(struct fs_context *fc,
 			nfs_parse_server_name(buf->data, buf->len,
 					      &ctx->nfs_server.address,
 					      sizeof(ctx->nfs_server._address),
-					      fc->net_ns);
+					      fc->net_ns, 0);
 		if (ctx->nfs_server.addrlen == 0)
 			continue;
 
@@ -496,7 +501,7 @@ static int nfs4_try_replacing_one_location(struct nfs_server *server,
 			continue;
 
 		salen = nfs_parse_server_name(buf->data, buf->len,
-						sap, addr_bufsize, net);
+						sap, addr_bufsize, net, 0);
 		if (salen == 0)
 			continue;
 		rpc_set_port(sap, NFS_PORT);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1f38f8cd8c3c..389fa72d4ca9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3894,6 +3894,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		if (res.attr_bitmask[2] & FATTR4_WORD2_SECURITY_LABEL)
 			server->caps |= NFS_CAP_SECURITY_LABEL;
 #endif
+		if (res.attr_bitmask[0] & FATTR4_WORD0_FS_LOCATIONS)
+			server->caps |= NFS_CAP_FS_LOCATIONS;
 		if (!(res.attr_bitmask[0] & FATTR4_WORD0_FILEID))
 			server->fattr_valid &= ~NFS_ATTR_FATTR_FILEID;
 		if (!(res.attr_bitmask[1] & FATTR4_WORD1_MODE))
@@ -3950,6 +3952,60 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	return err;
 }
 
+static int _nfs4_discover_trunking(struct nfs_server *server,
+				   struct nfs_fh *fhandle)
+{
+	struct nfs4_fs_locations *locations = NULL;
+	struct page *page;
+	const struct cred *cred;
+	struct nfs_client *clp = server->nfs_client;
+	const struct nfs4_state_maintenance_ops *ops =
+		clp->cl_mvops->state_renewal_ops;
+	int status = -ENOMEM;
+
+	cred = ops->get_state_renewal_cred(clp);
+	if (cred == NULL) {
+		cred = nfs4_get_clid_cred(clp);
+		if (cred == NULL)
+			return -ENOKEY;
+	}
+
+	page = alloc_page(GFP_KERNEL);
+	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
+	if (page == NULL || locations == NULL)
+		goto out;
+
+	status = nfs4_proc_get_locations(server, fhandle, locations, page,
+					 cred);
+	if (status)
+		goto out;
+out:
+	if (page)
+		__free_page(page);
+	kfree(locations);
+	return status;
+}
+
+static int nfs4_discover_trunking(struct nfs_server *server,
+				  struct nfs_fh *fhandle)
+{
+	struct nfs4_exception exception = {
+		.interruptible = true,
+	};
+	struct nfs_client *clp = server->nfs_client;
+	int err = 0;
+
+	if (!nfs4_has_session(clp))
+		goto out;
+	do {
+		err = nfs4_handle_exception(server,
+				_nfs4_discover_trunking(server, fhandle),
+				&exception);
+	} while (exception.retry);
+out:
+	return err;
+}
+
 static int _nfs4_lookup_root(struct nfs_server *server, struct nfs_fh *fhandle,
 		struct nfs_fsinfo *info)
 {
@@ -7677,7 +7733,7 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 				    const char *key, const void *buf,
 				    size_t buflen, int flags)
 {
-	struct nfs_access_entry cache;
+	u32 mask;
 	int ret;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
@@ -7692,8 +7748,8 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 	 * do a cached access check for the XA* flags to possibly avoid
 	 * doing an RPC and getting EACCES back.
 	 */
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XAWRITE))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XAWRITE))
 			return -EACCES;
 	}
 
@@ -7714,14 +7770,14 @@ static int nfs4_xattr_get_nfs4_user(const struct xattr_handler *handler,
 				    struct dentry *unused, struct inode *inode,
 				    const char *key, void *buf, size_t buflen)
 {
-	struct nfs_access_entry cache;
+	u32 mask;
 	ssize_t ret;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
 		return -EOPNOTSUPP;
 
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XAREAD))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XAREAD))
 			return -EACCES;
 	}
 
@@ -7746,13 +7802,13 @@ nfs4_listxattr_nfs4_user(struct inode *inode, char *list, size_t list_len)
 	ssize_t ret, size;
 	char *buf;
 	size_t buflen;
-	struct nfs_access_entry cache;
+	u32 mask;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
 		return 0;
 
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XALIST))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XALIST))
 			return 0;
 	}
 
@@ -7884,18 +7940,18 @@ int nfs4_proc_fs_locations(struct rpc_clnt *client, struct inode *dir,
  * appended to this compound to identify the client ID which is
  * performing recovery.
  */
-static int _nfs40_proc_get_locations(struct inode *inode,
+static int _nfs40_proc_get_locations(struct nfs_server *server,
+				     struct nfs_fh *fhandle,
 				     struct nfs4_fs_locations *locations,
 				     struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct rpc_clnt *clnt = server->client;
 	u32 bitmask[2] = {
 		[0] = FATTR4_WORD0_FSID | FATTR4_WORD0_FS_LOCATIONS,
 	};
 	struct nfs4_fs_locations_arg args = {
 		.clientid	= server->nfs_client->cl_clientid,
-		.fh		= NFS_FH(inode),
+		.fh		= fhandle,
 		.page		= page,
 		.bitmask	= bitmask,
 		.migration	= 1,		/* skip LOOKUP */
@@ -7941,17 +7997,17 @@ static int _nfs40_proc_get_locations(struct inode *inode,
  * When the client supports GETATTR(fs_locations_info), it can
  * be plumbed in here.
  */
-static int _nfs41_proc_get_locations(struct inode *inode,
+static int _nfs41_proc_get_locations(struct nfs_server *server,
+				     struct nfs_fh *fhandle,
 				     struct nfs4_fs_locations *locations,
 				     struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct rpc_clnt *clnt = server->client;
 	u32 bitmask[2] = {
 		[0] = FATTR4_WORD0_FSID | FATTR4_WORD0_FS_LOCATIONS,
 	};
 	struct nfs4_fs_locations_arg args = {
-		.fh		= NFS_FH(inode),
+		.fh		= fhandle,
 		.page		= page,
 		.bitmask	= bitmask,
 		.migration	= 1,		/* skip LOOKUP */
@@ -8000,11 +8056,11 @@ static int _nfs41_proc_get_locations(struct inode *inode,
  * -NFS4ERR_LEASE_MOVED is returned if the server still has leases
  * from this client that require migration recovery.
  */
-int nfs4_proc_get_locations(struct inode *inode,
+int nfs4_proc_get_locations(struct nfs_server *server,
+			    struct nfs_fh *fhandle,
 			    struct nfs4_fs_locations *locations,
 			    struct page *page, const struct cred *cred)
 {
-	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs_client *clp = server->nfs_client;
 	const struct nfs4_mig_recovery_ops *ops =
 					clp->cl_mvops->mig_recovery_ops;
@@ -8017,10 +8073,11 @@ int nfs4_proc_get_locations(struct inode *inode,
 		(unsigned long long)server->fsid.major,
 		(unsigned long long)server->fsid.minor,
 		clp->cl_hostname);
-	nfs_display_fhandle(NFS_FH(inode), __func__);
+	nfs_display_fhandle(fhandle, __func__);
 
 	do {
-		status = ops->get_locations(inode, locations, page, cred);
+		status = ops->get_locations(server, fhandle, locations, page,
+					    cred);
 		if (status != -NFS4ERR_DELAY)
 			break;
 		nfs4_handle_exception(server, status, &exception);
@@ -10514,6 +10571,7 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.free_client	= nfs4_free_client,
 	.create_server	= nfs4_create_server,
 	.clone_server	= nfs_clone_server,
+	.discover_trunking = nfs4_discover_trunking,
 };
 
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index f22818a80c2c..51f5cb41e87a 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2097,7 +2097,8 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	}
 
 	inode = d_inode(server->super->s_root);
-	result = nfs4_proc_get_locations(inode, locations, page, cred);
+	result = nfs4_proc_get_locations(server, NFS_FH(inode), locations,
+					 page, cred);
 	if (result) {
 		dprintk("<-- %s: failed to retrieve fs_locations: %d\n",
 			__func__, result);
@@ -2105,6 +2106,9 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index a8cff19c6f00..2a1bf0a72d5b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3693,8 +3693,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 	if (unlikely(!p))
 		goto out_eio;
 	n = be32_to_cpup(p);
-	if (n <= 0)
-		goto out_eio;
 	for (res->nlocations = 0; res->nlocations < n; res->nlocations++) {
 		u32 m;
 		struct nfs4_fs_location *loc;
@@ -4197,10 +4195,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
+		if (label && label->label)
+			dprintk("%s: label=%.*s, len=%d, PI=%d, LFS=%d\n",
+				__func__, label->len, (char *)label->label,
+				label->len, label->pi, label->lfs);
 	}
-	if (label && label->label)
-		dprintk("%s: label=%s, len=%d, PI=%d, LFS=%d\n", __func__,
-			(char *)label->label, label->len, label->pi, label->lfs);
 	return status;
 }
 
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index a0ccba636bf9..9918d6ad23ec 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -150,13 +150,17 @@ nfsd3_proc_read(struct svc_rqst *rqstp)
 	unsigned int len;
 	int v;
 
-	argp->count = min_t(u32, argp->count, max_blocksize);
-
 	dprintk("nfsd: READ(3) %s %lu bytes at %Lu\n",
 				SVCFH_fmt(&argp->fh),
 				(unsigned long) argp->count,
 				(unsigned long long) argp->offset);
 
+	argp->count = min_t(u32, argp->count, max_blocksize);
+	if (argp->offset > (u64)OFFSET_MAX)
+		argp->offset = (u64)OFFSET_MAX;
+	if (argp->offset + argp->count > (u64)OFFSET_MAX)
+		argp->count = (u64)OFFSET_MAX - argp->offset;
+
 	v = 0;
 	len = argp->count;
 	resp->pages = rqstp->rq_next_page;
@@ -199,6 +203,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset,
 				argp->stable? " stable" : "");
 
+	resp->status = nfserr_fbig;
+	if (argp->offset > (u64)OFFSET_MAX ||
+	    argp->offset + argp->len > (u64)OFFSET_MAX)
+		return rpc_success;
+
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nvecs = svc_fill_write_vector(rqstp, rqstp->rq_arg.pages,
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 0a5ebc52e6a9..7a900131d20c 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -254,7 +254,7 @@ svcxdr_decode_sattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		if (xdr_stream_decode_u64(xdr, &newsize) < 0)
 			return false;
 		iap->ia_valid |= ATTR_SIZE;
-		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
+		iap->ia_size = newsize;
 	}
 	if (xdr_stream_decode_u32(xdr, &set_it) < 0)
 		return false;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 486c5dba4b65..4b9a3b90a41f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -782,12 +782,16 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status;
 
 	read->rd_nf = NULL;
-	if (read->rd_offset >= OFFSET_MAX)
-		return nfserr_inval;
 
 	trace_nfsd_read_start(rqstp, &cstate->current_fh,
 			      read->rd_offset, read->rd_length);
 
+	read->rd_length = min_t(u32, read->rd_length, svc_max_payload(rqstp));
+	if (read->rd_offset > (u64)OFFSET_MAX)
+		read->rd_offset = (u64)OFFSET_MAX;
+	if (read->rd_offset + read->rd_length > (u64)OFFSET_MAX)
+		read->rd_length = (u64)OFFSET_MAX - read->rd_offset;
+
 	/*
 	 * If we do a zero copy read, then a client will see read data
 	 * that reflects the state of the file *after* performing the
@@ -1018,8 +1022,9 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	unsigned long cnt;
 	int nvecs;
 
-	if (write->wr_offset >= OFFSET_MAX)
-		return nfserr_inval;
+	if (write->wr_offset > (u64)OFFSET_MAX ||
+	    write->wr_offset + write->wr_buflen > (u64)OFFSET_MAX)
+		return nfserr_fbig;
 
 	cnt = write->wr_buflen;
 	trace_nfsd_write_start(rqstp, &cstate->current_fh,
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 266d5152c321..f6d385e0efec 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3997,10 +3997,8 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	}
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 
 	if (file->f_op->splice_read &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags))
@@ -4837,10 +4835,8 @@ nfsd4_encode_read_plus(struct nfsd4_compoundres *resp, __be32 nfserr,
 		return nfserr_resource;
 	xdr_commit_encode(xdr);
 
-	maxcount = svc_max_payload(resp->rqstp);
-	maxcount = min_t(unsigned long, maxcount,
+	maxcount = min_t(unsigned long, read->rd_length,
 			 (xdr->buf->buflen - xdr->buf->len));
-	maxcount = min_t(unsigned long, maxcount, read->rd_length);
 	count    = maxcount;
 
 	eof = read->rd_offset >= i_size_read(file_inode(file));
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 538520957a81..b302836c7fdf 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -319,14 +319,14 @@ TRACE_EVENT(nfsd_export_update,
 DECLARE_EVENT_CLASS(nfsd_io_class,
 	TP_PROTO(struct svc_rqst *rqstp,
 		 struct svc_fh	*fhp,
-		 loff_t		offset,
-		 unsigned long	len),
+		 u64		offset,
+		 u32		len),
 	TP_ARGS(rqstp, fhp, offset, len),
 	TP_STRUCT__entry(
 		__field(u32, xid)
 		__field(u32, fh_hash)
-		__field(loff_t, offset)
-		__field(unsigned long, len)
+		__field(u64, offset)
+		__field(u32, len)
 	),
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
@@ -334,7 +334,7 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 		__entry->offset = offset;
 		__entry->len = len;
 	),
-	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%lld len=%lu",
+	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%llu len=%u",
 		  __entry->xid, __entry->fh_hash,
 		  __entry->offset, __entry->len)
 )
@@ -343,8 +343,8 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 DEFINE_EVENT(nfsd_io_class, nfsd_##name,	\
 	TP_PROTO(struct svc_rqst *rqstp,	\
 		 struct svc_fh	*fhp,		\
-		 loff_t		offset,		\
-		 unsigned long	len),		\
+		 u64		offset,		\
+		 u32		len),		\
 	TP_ARGS(rqstp, fhp, offset, len))
 
 DEFINE_NFSD_IO_EVENT(read_start);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 738d564ca4ce..78df03843412 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -433,6 +433,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			.ia_size	= iap->ia_size,
 		};
 
+		host_err = -EFBIG;
+		if (iap->ia_size < 0)
+			goto out_unlock;
+
 		host_err = notify_change(&init_user_ns, dentry, &size_attr, NULL);
 		if (host_err)
 			goto out_unlock;
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3096c9a0ee01..d9b8df5ef212 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -223,7 +223,7 @@ struct obj_cgroup {
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
 	union {
-		struct list_head list;
+		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
 };
@@ -320,7 +320,8 @@ struct mem_cgroup {
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
-	struct list_head objcg_list; /* list of inherited objcgs */
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
 #endif
 
 	MEMCG_PADDING(_pad2_);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 4d95cc999d12..4a733f140939 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -517,8 +517,8 @@ extern int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fh,
 			struct nfs_fattr *fattr, struct nfs4_label *label);
 extern int nfs_may_open(struct inode *inode, const struct cred *cred, int openflags);
 extern void nfs_access_zap_cache(struct inode *inode);
-extern int nfs_access_get_cached(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res,
-				 bool may_block);
+extern int nfs_access_get_cached(struct inode *inode, const struct cred *cred,
+				 u32 *mask, bool may_block);
 
 /*
  * linux/fs/nfs/symlink.c
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 2a9acbfe00f0..9a6e70ccde56 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -287,5 +287,5 @@ struct nfs_server {
 #define NFS_CAP_COPY_NOTIFY	(1U << 27)
 #define NFS_CAP_XATTR		(1U << 28)
 #define NFS_CAP_READ_PLUS	(1U << 29)
-
+#define NFS_CAP_FS_LOCATIONS	(1U << 30)
 #endif
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index e9698b6278a5..ecd74cc34797 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1805,6 +1805,7 @@ struct nfs_rpc_ops {
 	struct nfs_server *(*create_server)(struct fs_context *);
 	struct nfs_server *(*clone_server)(struct nfs_server *, struct nfs_fh *,
 					   struct nfs_fattr *, rpc_authflavor_t);
+	int	(*discover_trunking)(struct nfs_server *, struct nfs_fh *);
 };
 
 /*
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 8af13ba60c7e..4bcd65679cee 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -430,15 +430,7 @@ struct platform_hibernation_ops {
 
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
-extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
-static inline void __init register_nosave_region(unsigned long b, unsigned long e)
-{
-	__register_nosave_region(b, e, 0);
-}
-static inline void __init register_nosave_region_late(unsigned long b, unsigned long e)
-{
-	__register_nosave_region(b, e, 1);
-}
+extern void register_nosave_region(unsigned long b, unsigned long e);
 extern int swsusp_page_is_forbidden(struct page *);
 extern void swsusp_set_page_free(struct page *);
 extern void swsusp_unset_page_free(struct page *);
@@ -457,7 +449,6 @@ int pfn_is_nosave(unsigned long pfn);
 int hibernate_quiet_exec(int (*func)(void *data), void *data);
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
@@ -505,14 +496,14 @@ extern void ksys_sync_helper(void);
 
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
-extern unsigned int pm_wakeup_irq;
 extern suspend_state_t pm_suspend_target_state;
 
 extern bool pm_wakeup_pending(void);
 extern void pm_system_wakeup(void);
 extern void pm_system_cancel_wakeup(void);
-extern void pm_wakeup_clear(bool reset);
+extern void pm_wakeup_clear(unsigned int irq_number);
 extern void pm_system_irq_wakeup(unsigned int irq_number);
+extern unsigned int pm_wakeup_irq(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 14efa0ded75d..adab27ba1ecb 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -123,8 +123,20 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
 	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
 	       sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+	/* Unclone the dst cache if there is one */
+	if (new_md->u.tun_info.dst_cache.cache) {
+		int ret;
+
+		ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+		if (ret) {
+			metadata_dst_free(new_md);
+			return ERR_PTR(ret);
+		}
+	}
+#endif
+
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 4b3395082d15..26071021e986 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -106,7 +106,7 @@ enum ip_conntrack_status {
 	IPS_NAT_CLASH = IPS_UNTRACKED,
 #endif
 
-	/* Conntrack got a helper explicitly attached via CT target. */
+	/* Conntrack got a helper explicitly attached (ruleset, ctnetlink). */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 69c70767b5df..b81652fc2cdd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -839,7 +839,7 @@ static DEFINE_PER_CPU(struct list_head, cgrp_cpuctx_list);
  */
 static void perf_cgroup_switch(struct task_struct *task, int mode)
 {
-	struct perf_cpu_context *cpuctx;
+	struct perf_cpu_context *cpuctx, *tmp;
 	struct list_head *list;
 	unsigned long flags;
 
@@ -850,7 +850,7 @@ static void perf_cgroup_switch(struct task_struct *task, int mode)
 	local_irq_save(flags);
 
 	list = this_cpu_ptr(&cgrp_cpuctx_list);
-	list_for_each_entry(cpuctx, list, cgrp_cpuctx_entry) {
+	list_for_each_entry_safe(cpuctx, tmp, list, cgrp_cpuctx_entry) {
 		WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
 
 		perf_ctx_lock(cpuctx, cpuctx->task_ctx);
@@ -6004,6 +6004,8 @@ static void ring_buffer_attach(struct perf_event *event,
 	struct perf_buffer *old_rb = NULL;
 	unsigned long flags;
 
+	WARN_ON_ONCE(event->parent);
+
 	if (event->rb) {
 		/*
 		 * Should be impossible, we set this when removing
@@ -6061,6 +6063,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6074,6 +6079,9 @@ struct perf_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6772,7 +6780,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	if (WARN_ON_ONCE(READ_ONCE(sampler->oncpu) != smp_processor_id()))
 		goto out;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		goto out;
 
@@ -6838,7 +6846,7 @@ static void perf_aux_sample_output(struct perf_event *event,
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
 		return;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		return;
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 44169f3081fd..7e646079fbeb 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -504,7 +504,10 @@ static ssize_t pm_wakeup_irq_show(struct kobject *kobj,
 					struct kobj_attribute *attr,
 					char *buf)
 {
-	return pm_wakeup_irq ? sprintf(buf, "%u\n", pm_wakeup_irq) : -ENODATA;
+	if (!pm_wakeup_irq())
+		return -ENODATA;
+
+	return sprintf(buf, "%u\n", pm_wakeup_irq());
 }
 
 power_attr_ro(pm_wakeup_irq);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 37401c99b7d7..ee78a39463e6 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -134,7 +134,7 @@ int freeze_processes(void)
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
-	pm_wakeup_clear(true);
+	pm_wakeup_clear(0);
 	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
 	error = try_to_freeze_tasks(true);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index f7a986078213..330d49937692 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -978,8 +978,7 @@ static void memory_bm_recycle(struct memory_bitmap *bm)
  * Register a range of page frames the contents of which should not be saved
  * during hibernation (to be used in the early initialization code).
  */
-void __init __register_nosave_region(unsigned long start_pfn,
-				     unsigned long end_pfn, int use_kmalloc)
+void __init register_nosave_region(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct nosave_region *region;
 
@@ -995,18 +994,12 @@ void __init __register_nosave_region(unsigned long start_pfn,
 			goto Report;
 		}
 	}
-	if (use_kmalloc) {
-		/* During init, this shouldn't fail */
-		region = kmalloc(sizeof(struct nosave_region), GFP_KERNEL);
-		BUG_ON(!region);
-	} else {
-		/* This allocation cannot fail */
-		region = memblock_alloc(sizeof(struct nosave_region),
-					SMP_CACHE_BYTES);
-		if (!region)
-			panic("%s: Failed to allocate %zu bytes\n", __func__,
-			      sizeof(struct nosave_region));
-	}
+	/* This allocation cannot fail */
+	region = memblock_alloc(sizeof(struct nosave_region),
+				SMP_CACHE_BYTES);
+	if (!region)
+		panic("%s: Failed to allocate %zu bytes\n", __func__,
+		      sizeof(struct nosave_region));
 	region->start_pfn = start_pfn;
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index eb75f394a059..13d905dd3267 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -138,8 +138,6 @@ static void s2idle_loop(void)
 			break;
 		}
 
-		pm_wakeup_clear(false);
-
 		s2idle_enter();
 	}
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d12ec7be301..c2dec6ce9809 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8199,9 +8199,7 @@ int __cond_resched_lock(spinlock_t *lock)
 
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		spin_lock(lock);
@@ -8219,9 +8217,7 @@ int __cond_resched_rwlock_read(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		read_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		read_lock(lock);
@@ -8239,9 +8235,7 @@ int __cond_resched_rwlock_write(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		write_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		write_lock(lock);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4d8f44a17727..db10e73d06e0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -29,6 +29,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -1010,6 +1013,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -1261,6 +1265,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action != SECCOMP_RET_KILL_THREAD ||
@@ -1309,6 +1314,11 @@ int __secure_computing(const struct seccomp_data *sd)
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
+	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
+	case SECCOMP_MODE_DEAD:
+		WARN_ON_ONCE(1);
+		do_exit(SIGKILL);
+		return -1;
 	default:
 		BUG();
 	}
diff --git a/kernel/signal.c b/kernel/signal.c
index 5892c91696f8..aea93d6a5520 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1339,9 +1339,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
 	}
 	/*
 	 * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
-	 * debugging to leave init killable.
+	 * debugging to leave init killable. But HANDLER_EXIT is always fatal.
 	 */
-	if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
+	if (action->sa.sa_handler == SIG_DFL &&
+	    (!t->ptrace || (handler == HANDLER_EXIT)))
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = send_signal(sig, info, t, PIDTYPE_PID);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 83efce3a87ca..918f969dffcf 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2220,6 +2220,8 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup_const(operand1->type, GFP_KERNEL);
@@ -2359,6 +2361,7 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 
 	/* The operand sizes should be the same, so just pick one */
 	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 96cd7eae800b..32ba963ebf2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -254,7 +254,7 @@ struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-extern spinlock_t css_set_lock;
+static DEFINE_SPINLOCK(objcg_lock);
 
 bool mem_cgroup_kmem_disabled(void)
 {
@@ -298,9 +298,9 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 
-	spin_lock_irqsave(&css_set_lock, flags);
+	spin_lock_irqsave(&objcg_lock, flags);
 	list_del(&objcg->list);
-	spin_unlock_irqrestore(&css_set_lock, flags);
+	spin_unlock_irqrestore(&objcg_lock, flags);
 
 	percpu_ref_exit(ref);
 	kfree_rcu(objcg, rcu);
@@ -332,7 +332,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
-	spin_lock_irq(&css_set_lock);
+	spin_lock_irq(&objcg_lock);
 
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
@@ -342,7 +342,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
-	spin_unlock_irq(&css_set_lock);
+	spin_unlock_irq(&objcg_lock);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 02cbcb2ecf0d..d2a430b6a13b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/hrtimer.h>
 #include <linux/wait.h>
 #include <linux/uio.h>
@@ -145,6 +146,7 @@ struct isotp_sock {
 	struct tpcon rx, tx;
 	struct list_head notifier;
 	wait_queue_head_t wait;
+	spinlock_t rx_lock; /* protect single thread state machine */
 };
 
 static LIST_HEAD(isotp_notifier_list);
@@ -615,11 +617,17 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 
 	n_pci_type = cf->data[ae] & 0xF0;
 
+	/* Make sure the state changes and data structures stay consistent at
+	 * CAN frame reception time. This locking is not needed in real world
+	 * use cases but the inconsistency can be triggered with syzkaller.
+	 */
+	spin_lock(&so->rx_lock);
+
 	if (so->opt.flags & CAN_ISOTP_HALF_DUPLEX) {
 		/* check rx/tx path half duplex expectations */
 		if ((so->tx.state != ISOTP_IDLE && n_pci_type != N_PCI_FC) ||
 		    (so->rx.state != ISOTP_IDLE && n_pci_type == N_PCI_FC))
-			return;
+			goto out_unlock;
 	}
 
 	switch (n_pci_type) {
@@ -668,6 +676,9 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 		isotp_rcv_cf(sk, cf, ae, skb);
 		break;
 	}
+
+out_unlock:
+	spin_unlock(&so->rx_lock);
 }
 
 static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_sock *so,
@@ -876,7 +887,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
@@ -886,24 +897,24 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
 	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		goto err_out;
+		goto err_out_drop;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
 	if (!dev) {
 		err = -ENXIO;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	can_skb_reserve(skb);
@@ -965,7 +976,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
@@ -978,6 +989,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	return size;
 
+err_out_drop:
+	/* drop this PDU and unlock a potential wait queue */
+	old_state = ISOTP_IDLE;
 err_out:
 	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)
@@ -1444,6 +1458,7 @@ static int isotp_init(struct sock *sk)
 	so->txtimer.function = isotp_tx_timer_handler;
 
 	init_waitqueue_head(&so->wait);
+	spin_lock_init(&so->rx_lock);
 
 	spin_lock(&isotp_notifier_lock);
 	list_add_tail(&so->notifier, &isotp_notifier_list);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260..aea29d97f8df 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -261,7 +261,9 @@ static int __net_init ipmr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ipmr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb8825..6a4065d81aa9 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -248,7 +248,9 @@ static int __net_init ip6mr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ip6mr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2137b7460dea..320f89b5c59d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -878,6 +878,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct mptcp_sock *msk;
 	struct socket *ssock;
@@ -902,8 +903,11 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	}
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
-	err = kernel_bind(ssock, (struct sockaddr *)&addr,
-			  sizeof(struct sockaddr_in));
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (entry->addr.family == AF_INET6)
+		addrlen = sizeof(struct sockaddr_in6);
+#endif
+	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
 		goto out;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81d03acf68d4..1c02be04aaf5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2310,7 +2310,8 @@ ctnetlink_create_conntrack(struct net *net,
 			if (helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
-			/* not in hash table yet so not strictly necessary */
+			/* disable helper auto-assignment for this entry */
+			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
 	} else {
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 4bbfd2622327..8e629c356e69 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1204,7 +1204,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f056ff931444..5da1d7e8468a 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2903,7 +2903,7 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	unsigned long connect_timeout;
 	unsigned long reconnect_timeout;
 	unsigned char resvport, reuseport;
-	int ret = 0;
+	int ret = 0, ident;
 
 	rcu_read_lock();
 	xps = xprt_switch_get(rcu_dereference(clnt->cl_xpi.xpi_xpswitch));
@@ -2917,8 +2917,11 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	reuseport = xprt->reuseport;
 	connect_timeout = xprt->connect_timeout;
 	reconnect_timeout = xprt->max_reconnect_timeout;
+	ident = xprt->xprt_class->ident;
 	rcu_read_unlock();
 
+	if (!xprtargs->ident)
+		xprtargs->ident = ident;
 	xprt = xprt_create_transport(xprtargs);
 	if (IS_ERR(xprt)) {
 		ret = PTR_ERR(xprt);
diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 9a6f17e18f73..326a31422a3c 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -291,8 +291,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		online = 1;
 	else if (!strncmp(buf, "remove", 6))
 		remove = 1;
-	else
-		return -EINVAL;
+	else {
+		count = -EINVAL;
+		goto out_put;
+	}
 
 	if (wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_KILLABLE)) {
 		count = -EINTR;
@@ -303,25 +305,28 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		goto release_tasks;
 	}
 	if (offline) {
-		set_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive--;
-		spin_unlock(&xps->xps_lock);
+		if (!test_and_set_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive--;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (online) {
-		clear_bit(XPRT_OFFLINE, &xprt->state);
-		spin_lock(&xps->xps_lock);
-		xps->xps_nactive++;
-		spin_unlock(&xps->xps_lock);
+		if (test_and_clear_bit(XPRT_OFFLINE, &xprt->state)) {
+			spin_lock(&xps->xps_lock);
+			xps->xps_nactive++;
+			spin_unlock(&xps->xps_lock);
+		}
 	} else if (remove) {
 		if (test_bit(XPRT_OFFLINE, &xprt->state)) {
-			set_bit(XPRT_REMOVE, &xprt->state);
-			xprt_force_disconnect(xprt);
-			if (test_bit(XPRT_CONNECTED, &xprt->state)) {
-				if (!xprt->sending.qlen &&
-				    !xprt->pending.qlen &&
-				    !xprt->backlog.qlen &&
-				    !atomic_long_read(&xprt->queuelen))
-					rpc_xprt_switch_remove_xprt(xps, xprt);
+			if (!test_and_set_bit(XPRT_REMOVE, &xprt->state)) {
+				xprt_force_disconnect(xprt);
+				if (test_bit(XPRT_CONNECTED, &xprt->state)) {
+					if (!xprt->sending.qlen &&
+					    !xprt->pending.qlen &&
+					    !xprt->backlog.qlen &&
+					    !atomic_long_read(&xprt->queuelen))
+						rpc_xprt_switch_remove_xprt(xps, xprt);
+				}
 			}
 		} else {
 			count = -EINVAL;
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index bda902caa814..8267b751a526 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -313,7 +313,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 		pr_warn_ratelimited("Failed to remove binding %u,%u from %u\n",
 				    ua.sr.type, ua.sr.lower, node);
 	} else {
-		pr_warn("Unrecognized name table message received\n");
+		pr_warn_ratelimited("Unknown name table message received\n");
 	}
 	return false;
 }
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d53825503874..8be892887d71 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -51,6 +51,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
+KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 endif
 
 endif
diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 23240d793b07..895f4b9ce8c6 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -109,22 +109,25 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	pk = asymmetric_key_public_key(key);
 	pks.pkey_algo = pk->pkey_algo;
-	if (!strcmp(pk->pkey_algo, "rsa"))
+	if (!strcmp(pk->pkey_algo, "rsa")) {
 		pks.encoding = "pkcs1";
-	else if (!strncmp(pk->pkey_algo, "ecdsa-", 6))
+	} else if (!strncmp(pk->pkey_algo, "ecdsa-", 6)) {
 		/* edcsa-nist-p192 etc. */
 		pks.encoding = "x962";
-	else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
-		   !strcmp(pk->pkey_algo, "sm2"))
+	} else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
+		   !strcmp(pk->pkey_algo, "sm2")) {
 		pks.encoding = "raw";
-	else
-		return -ENOPKG;
+	} else {
+		ret = -ENOPKG;
+		goto out;
+	}
 
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
 	pks.s_size = siglen;
 	ret = verify_signature(key, &pks);
+out:
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 3d8e9d5db5aa..3ad8f7734208 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -496,12 +496,12 @@ int __init ima_fs_init(void)
 
 	return 0;
 out:
+	securityfs_remove(ima_policy);
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_symlink);
 	securityfs_remove(ima_dir);
-	securityfs_remove(ima_policy);
 	return -1;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 12e8adcd80a2..fa5a93dbe5d2 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1852,6 +1852,14 @@ int ima_policy_show(struct seq_file *m, void *v)
 
 	rcu_read_lock();
 
+	/* Do not print rules with inactive LSM labels */
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		if (entry->lsm[i].args_p && !entry->lsm[i].rule) {
+			rcu_read_unlock();
+			return 0;
+		}
+	}
+
 	if (entry->action & MEASURE)
 		seq_puts(m, pt(Opt_measure));
 	if (entry->action & DONT_MEASURE)
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 694560396be0..db1ad6d7a57f 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -29,6 +29,7 @@ static struct ima_template_desc builtin_templates[] = {
 
 static LIST_HEAD(defined_templates);
 static DEFINE_SPINLOCK(template_list);
+static int template_setup_done;
 
 static const struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
@@ -101,10 +102,11 @@ static int __init ima_template_setup(char *str)
 	struct ima_template_desc *template_desc;
 	int template_len = strlen(str);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
-	ima_init_template_list();
+	if (!ima_template)
+		ima_init_template_list();
 
 	/*
 	 * Verify that a template with the supplied name exists.
@@ -128,6 +130,7 @@ static int __init ima_template_setup(char *str)
 	}
 
 	ima_template = template_desc;
+	template_setup_done = 1;
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -136,7 +139,7 @@ static int __init ima_template_fmt_setup(char *str)
 {
 	int num_templates = ARRAY_SIZE(builtin_templates);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
 	if (template_desc_init_fields(str, NULL, NULL) < 0) {
@@ -147,6 +150,7 @@ static int __init ima_template_fmt_setup(char *str)
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_setup_done = 1;
 
 	return 1;
 }
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 29220056207f..0ec5e4c22cb2 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -45,6 +45,8 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 		return;
 
 	ab = audit_log_start(audit_context(), GFP_KERNEL, audit_msgno);
+	if (!ab)
+		return;
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_uid()),
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index e996989cd580..5b874e7ba36f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -456,8 +456,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-					 link)
+		hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+					  link, srcu_read_lock_held(&kvm->irq_srcu))
 			if (kian->gsi == gsi) {
 				srcu_read_unlock(&kvm->irq_srcu, idx);
 				return true;
@@ -473,8 +473,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
 	struct kvm_irq_ack_notifier *kian;
 
-	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
-				 link)
+	hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
+				  link, srcu_read_lock_held(&kvm->irq_srcu))
 		if (kian->gsi == gsi)
 			kian->irq_acked(kian);
 }
