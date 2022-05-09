Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C67A51F5E1
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 09:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiEIHmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 03:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiEIHmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 03:42:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554AA18E1C0;
        Mon,  9 May 2022 00:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E2B0612B2;
        Mon,  9 May 2022 07:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B29C385AB;
        Mon,  9 May 2022 07:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652081895;
        bh=XMGtRnbh2FLuiwfnqIzBKU+oPfUoqFFLv1mrbARnKzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xth1I9RBDXaJLewqjs87yd9YcIzH317Z2TAgTlNQ3E0Wxkkvx1dZ4ifRjBeGd5KbC
         6GQf8pS6H8LAVrC2VtYpuSMaq68xPwMPocycYG2Y3AbXfpP2zLQqwbmnlw+tUA9Qo+
         O82CJYXeA5r0kcqtWk7x69cScDd1TuKW1YJmMQAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.38
Date:   Mon,  9 May 2022 09:37:58 +0200
Message-Id: <165208187820262@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1652081878161118@kroah.com>
References: <1652081878161118@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 50b1688a4ca2..73b884c9baa4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 37
+SUBLEVEL = 38
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/am3517-evm.dts b/arch/arm/boot/dts/am3517-evm.dts
index 0d2fac98ce7d..c8b80f156ec9 100644
--- a/arch/arm/boot/dts/am3517-evm.dts
+++ b/arch/arm/boot/dts/am3517-evm.dts
@@ -161,6 +161,8 @@ pwm11: dmtimer-pwm@11 {
 
 	/* HS USB Host PHY on PORT 1 */
 	hsusb1_phy: hsusb1_phy {
+		pinctrl-names = "default";
+		pinctrl-0 = <&hsusb1_rst_pins>;
 		compatible = "usb-nop-xceiv";
 		reset-gpios = <&gpio2 25 GPIO_ACTIVE_LOW>; /* gpio_57 */
 		#phy-cells = <0>;
@@ -168,7 +170,9 @@ hsusb1_phy: hsusb1_phy {
 };
 
 &davinci_emac {
-	     status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_pins>;
+	status = "okay";
 };
 
 &davinci_mdio {
@@ -193,6 +197,8 @@ dpi_out: endpoint {
 };
 
 &i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
 	clock-frequency = <400000>;
 	/* User DIP swithes [1:8] / User LEDS [1:2] */
 	tca6416: gpio@21 {
@@ -205,6 +211,8 @@ tca6416: gpio@21 {
 };
 
 &i2c3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c3_pins>;
 	clock-frequency = <400000>;
 };
 
@@ -223,6 +231,8 @@ &mmc3 {
 };
 
 &usbhshost {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb1_pins>;
 	port1-mode = "ehci-phy";
 };
 
@@ -231,8 +241,35 @@ &usbhsehci {
 };
 
 &omap3_pmx_core {
-	pinctrl-names = "default";
-	pinctrl-0 = <&hsusb1_rst_pins>;
+
+	ethernet_pins: pinmux_ethernet_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21fe, PIN_INPUT | MUX_MODE0) /* rmii_mdio_data */
+			OMAP3_CORE1_IOPAD(0x2200, MUX_MODE0) /* rmii_mdio_clk */
+			OMAP3_CORE1_IOPAD(0x2202, PIN_INPUT_PULLDOWN | MUX_MODE0) /* rmii_rxd0 */
+			OMAP3_CORE1_IOPAD(0x2204, PIN_INPUT_PULLDOWN | MUX_MODE0) /* rmii_rxd1 */
+			OMAP3_CORE1_IOPAD(0x2206, PIN_INPUT_PULLDOWN | MUX_MODE0) /* rmii_crs_dv */
+			OMAP3_CORE1_IOPAD(0x2208, PIN_OUTPUT_PULLDOWN | MUX_MODE0) /* rmii_rxer */
+			OMAP3_CORE1_IOPAD(0x220a, PIN_OUTPUT_PULLDOWN | MUX_MODE0) /* rmii_txd0 */
+			OMAP3_CORE1_IOPAD(0x220c, PIN_OUTPUT_PULLDOWN | MUX_MODE0) /* rmii_txd1 */
+			OMAP3_CORE1_IOPAD(0x220e, PIN_OUTPUT_PULLDOWN |MUX_MODE0) /* rmii_txen */
+			OMAP3_CORE1_IOPAD(0x2210, PIN_INPUT_PULLDOWN | MUX_MODE0) /* rmii_50mhz_clk */
+		>;
+	};
+
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21be, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c2_scl */
+			OMAP3_CORE1_IOPAD(0x21c0, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c2_sda */
+		>;
+	};
+
+	i2c3_pins: pinmux_i2c3_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21c2, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c3_scl */
+			OMAP3_CORE1_IOPAD(0x21c4, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c3_sda */
+		>;
+	};
 
 	leds_pins: pinmux_leds_pins {
 		pinctrl-single,pins = <
@@ -300,8 +337,6 @@ OMAP3_CORE1_IOPAD(0x20ba, PIN_OUTPUT | MUX_MODE4)	/* gpmc_ncs6.gpio_57 */
 };
 
 &omap3_pmx_core2 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&hsusb1_pins>;
 
 	hsusb1_pins: pinmux_hsusb1_pins {
 		pinctrl-single,pins = <
diff --git a/arch/arm/boot/dts/am3517-som.dtsi b/arch/arm/boot/dts/am3517-som.dtsi
index 8b669e2eafec..f7b680f6c48a 100644
--- a/arch/arm/boot/dts/am3517-som.dtsi
+++ b/arch/arm/boot/dts/am3517-som.dtsi
@@ -69,6 +69,8 @@ nand@0,0 {
 };
 
 &i2c1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <400000>;
 
 	s35390a: s35390a@30 {
@@ -179,6 +181,13 @@ bluetooth {
 
 &omap3_pmx_core {
 
+	i2c1_pins: pinmux_i2c1_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21ba, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c1_scl */
+			OMAP3_CORE1_IOPAD(0x21bc, PIN_INPUT_PULLUP | MUX_MODE0)  /* i2c1_sda */
+		>;
+	};
+
 	wl12xx_buffer_pins: pinmux_wl12xx_buffer_pins {
 		pinctrl-single,pins = <
 			OMAP3_CORE1_IOPAD(0x2156, PIN_OUTPUT | MUX_MODE4)  /* mmc1_dat7.gpio_129 */
diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index d72c042f2850..a49c2966b41e 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -57,8 +57,8 @@ slot@0 {
 			};
 
 			spi0: spi@f0004000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi0_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
 				status = "okay";
 			};
@@ -171,8 +171,8 @@ slot@0 {
 			};
 
 			spi1: spi@f8008000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi1_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioC 25 0>;
 				status = "okay";
 			};
diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index d241c24f0d83..e519d2747936 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -81,8 +81,8 @@ usart4: serial@fc010000 {
 			};
 
 			spi1: spi@fc018000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi0_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioB 21 0>;
 				status = "okay";
 			};
@@ -140,7 +140,7 @@ pinctrl_macb0_phy_irq: macb0_phy_irq_0 {
 						atmel,pins =
 							<AT91_PIOE 1 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
 					};
-					pinctrl_spi0_cs: spi0_cs_default {
+					pinctrl_spi1_cs: spi1_cs_default {
 						atmel,pins =
 							<AT91_PIOB 21 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
 					};
diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index f3d6aaa3a78d..bac0e49cc577 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -403,7 +403,7 @@ pinctrl_flx0_default: flx0_default {
 	pinctrl_flx3_default: flx3_default {
 		pinmux = <PIN_PD16__FLEXCOM3_IO0>,
 			 <PIN_PD17__FLEXCOM3_IO1>;
-		bias-disable;
+		bias-pull-up;
 	};
 
 	pinctrl_flx4_default: flx4_default {
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 87bb39060e8b..ca03685f0f08 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -219,6 +219,12 @@ i2c-gpio-0 {
 		wm8731: wm8731@1b {
 			compatible = "wm8731";
 			reg = <0x1b>;
+
+			/* PCK0 at 12MHz */
+			clocks = <&pmc PMC_TYPE_SYSTEM 8>;
+			clock-names = "mclk";
+			assigned-clocks = <&pmc PMC_TYPE_SYSTEM 8>;
+			assigned-clock-rates = <12000000>;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 0a11bacffc1f..5733e3a4ea8e 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -4188,11 +4188,11 @@ target-module@1d0010 {			/* 0x489d0000, ap 27 30.0 */
 			reg = <0x1d0010 0x4>;
 			reg-names = "sysc";
 			ti,sysc-midle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>;
+					<SYSC_IDLE_NO>;
 			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
 					<SYSC_IDLE_NO>,
 					<SYSC_IDLE_SMART>;
+			power-domains = <&prm_vpe>;
 			clocks = <&vpe_clkctrl DRA7_VPE_VPE_CLKCTRL 0>;
 			clock-names = "fck";
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6qdl-apalis.dtsi b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
index 30fa349f9d05..a696873dc1ab 100644
--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -286,6 +286,8 @@ vgen6_reg: vgen6 {
 	codec: sgtl5000@a {
 		compatible = "fsl,sgtl5000";
 		reg = <0x0a>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_sgtl5000>;
 		clocks = <&clks IMX6QDL_CLK_CKO>;
 		VDDA-supply = <&reg_module_3v3_audio>;
 		VDDIO-supply = <&reg_module_3v3>;
@@ -516,8 +518,6 @@ MX6QDL_PAD_DISP0_DAT20__AUD4_TXC	0x130b0
 			MX6QDL_PAD_DISP0_DAT21__AUD4_TXD	0x130b0
 			MX6QDL_PAD_DISP0_DAT22__AUD4_TXFS	0x130b0
 			MX6QDL_PAD_DISP0_DAT23__AUD4_RXD	0x130b0
-			/* SGTL5000 sys_mclk */
-			MX6QDL_PAD_GPIO_5__CCM_CLKO1		0x130b0
 		>;
 	};
 
@@ -810,6 +810,12 @@ MX6QDL_PAD_NANDF_CS1__GPIO6_IO14 0x000b0
 		>;
 	};
 
+	pinctrl_sgtl5000: sgtl5000grp {
+		fsl,pins = <
+			MX6QDL_PAD_GPIO_5__CCM_CLKO1	0x130b0
+		>;
+	};
+
 	pinctrl_spdif: spdifgrp {
 		fsl,pins = <
 			MX6QDL_PAD_GPIO_16__SPDIF_IN  0x1b0b0
diff --git a/arch/arm/boot/dts/imx6ull-colibri.dtsi b/arch/arm/boot/dts/imx6ull-colibri.dtsi
index 0cdbf7b6e728..b6fc879e9dbe 100644
--- a/arch/arm/boot/dts/imx6ull-colibri.dtsi
+++ b/arch/arm/boot/dts/imx6ull-colibri.dtsi
@@ -37,7 +37,7 @@ reg_module_3v3_avdd: regulator-module-3v3-avdd {
 
 	reg_sd1_vmmc: regulator-sd1-vmmc {
 		compatible = "regulator-gpio";
-		gpio = <&gpio5 9 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_snvs_reg_sd>;
 		regulator-always-on;
diff --git a/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts b/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
index 2a0a98fe67f0..3240c67e0c39 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
+++ b/arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts
@@ -11,3 +11,18 @@ / {
 	model = "LogicPD Zoom OMAP35xx SOM-LV Development Kit";
 	compatible = "logicpd,dm3730-som-lv-devkit", "ti,omap3430", "ti,omap3";
 };
+
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb2_2_pins>;
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3430_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
+			OMAP3430_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
+			OMAP3430_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
+			OMAP3430_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
+			OMAP3430_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
+			OMAP3430_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
diff --git a/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts b/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
index a604d92221a4..c757f0d7781c 100644
--- a/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
+++ b/arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts
@@ -11,3 +11,18 @@ / {
 	model = "LogicPD Zoom DM3730 SOM-LV Development Kit";
 	compatible = "logicpd,dm3730-som-lv-devkit", "ti,omap3630", "ti,omap3";
 };
+
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb2_2_pins>;
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
+			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
+			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
+			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
+			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
+			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
diff --git a/arch/arm/boot/dts/logicpd-som-lv.dtsi b/arch/arm/boot/dts/logicpd-som-lv.dtsi
index b56524cc7fe2..55b619c99e24 100644
--- a/arch/arm/boot/dts/logicpd-som-lv.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv.dtsi
@@ -265,21 +265,6 @@ OMAP3_WKUP_IOPAD(0x2a0c, PIN_OUTPUT | MUX_MODE4)	/* sys_boot1.gpio_3 */
 	};
 };
 
-&omap3_pmx_core2 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&hsusb2_2_pins>;
-	hsusb2_2_pins: pinmux_hsusb2_2_pins {
-		pinctrl-single,pins = <
-			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
-			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
-			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
-			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
-			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
-			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
-		>;
-	};
-};
-
 &uart2 {
 	interrupts-extended = <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 23ab27fe4ee5..3923b38e798d 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -31,6 +31,8 @@ chosen {
 	aliases {
 		display0 = &lcd;
 		display1 = &tv0;
+		/delete-property/ mmc2;
+		/delete-property/ mmc3;
 	};
 
 	ldo_3v3: fixedregulator {
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 5a48abac6af4..4b554cc8fa58 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -18,7 +18,6 @@ menuconfig ARCH_EXYNOS
 	select EXYNOS_PMU
 	select EXYNOS_SROM
 	select EXYNOS_PM_DOMAINS if PM_GENERIC_DOMAINS
-	select GPIOLIB
 	select HAVE_ARM_ARCH_TIMER if ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select HAVE_S3C2410_I2C if I2C
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 5c3845730dbf..0b80f8bcd304 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -314,10 +314,12 @@ void __init omap_gic_of_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-gic");
 	gic_dist_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!gic_dist_base_addr);
 
 	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-twd-timer");
 	twd_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!twd_base);
 
 skip_errata_init:
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi
index d61f43052a34..8e9ad1e51d66 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi
@@ -11,26 +11,6 @@ cpu_opp_table_0: opp-table-0 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <667000000>;
-			opp-microvolt = <731000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <761000>;
@@ -71,26 +51,6 @@ cpub_opp_table_1: opp-table-1 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <667000000>;
-			opp-microvolt = <731000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <731000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi
index 1e5d0ee5d541..44c23c984034 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi
@@ -11,26 +11,6 @@ cpu_opp_table_0: opp-table-0 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <667000000>;
-			opp-microvolt = <731000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <731000>;
@@ -76,26 +56,6 @@ cpub_opp_table_1: opp-table-1 {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <751000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <751000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <751000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <667000000>;
-			opp-microvolt = <751000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <771000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index 5751c48620ed..cadba194b149 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -437,6 +437,7 @@ &gpio {
 		"",
 		"eMMC_RST#", /* BOOT_12 */
 		"eMMC_DS", /* BOOT_13 */
+		"", "",
 		/* GPIOC */
 		"SD_D0_B", /* GPIOC_0 */
 		"SD_D1_B", /* GPIOC_1 */
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
index 3d8b1f4f2001..78bdbd2ccc9d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -95,26 +95,6 @@ cpu_opp_table: opp-table {
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <730000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <730000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <730000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <666666666>;
-			opp-microvolt = <750000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <770000>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
index 8e4a0ce99790..7ea909a4c1d5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -103,12 +103,14 @@ &uart3 {
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	status = "okay";
 };
 
@@ -166,7 +168,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
index b7c91bdc21dd..806ee21651d1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -139,12 +139,14 @@ &uart4 {
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	vbus-supply = <&reg_usb_otg2_vbus>;
 	status = "okay";
 };
@@ -231,7 +233,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
index d2ffd62a3bd4..942fed2eed64 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -166,12 +166,14 @@ &uart4 {
 
 &usbotg1 {
 	dr_mode = "otg";
+	over-current-active-low;
 	vbus-supply = <&reg_usb_otg1_vbus>;
 	status = "okay";
 };
 
 &usbotg2 {
 	dr_mode = "host";
+	disable-over-current;
 	vbus-supply = <&reg_usb_otg2_vbus>;
 	status = "okay";
 };
@@ -280,7 +282,7 @@ pinctrl_spi2: spi2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts b/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
index 7dfee715a2c4..d8ce217c6016 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
@@ -59,6 +59,10 @@ pmic@4b {
 		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		rohm,reset-snvs-powered;
 
+		#clock-cells = <0>;
+		clocks = <&osc_32k 0>;
+		clock-output-names = "clk-32k-out";
+
 		regulators {
 			buck1_reg: BUCK1 {
 				regulator-name = "buck1";
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index da6c942fb7f9..6d6cbd4c83b8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -263,7 +263,7 @@ spba2: spba-bus@30000000 {
 				ranges;
 
 				sai2: sai@30020000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30020000 0x10000>;
 					interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI2_IPG>,
@@ -277,7 +277,7 @@ sai2: sai@30020000 {
 				};
 
 				sai3: sai@30030000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30030000 0x10000>;
 					interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI3_IPG>,
@@ -291,7 +291,7 @@ sai3: sai@30030000 {
 				};
 
 				sai5: sai@30050000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30050000 0x10000>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI5_IPG>,
@@ -307,7 +307,7 @@ sai5: sai@30050000 {
 				};
 
 				sai6: sai@30060000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x30060000  0x10000>;
 					interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI6_IPG>,
@@ -364,7 +364,7 @@ spdif1: spdif@30090000 {
 				};
 
 				sai7: sai@300b0000 {
-					compatible = "fsl,imx8mm-sai", "fsl,imx8mq-sai";
+					compatible = "fsl,imx8mn-sai", "fsl,imx8mq-sai";
 					reg = <0x300b0000 0x10000>;
 					interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clk IMX8MN_CLK_SAI7_IPG>,
diff --git a/arch/arm64/boot/dts/freescale/imx8qm.dtsi b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
index aebbe2b84aa1..a143f38bc78b 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
@@ -155,7 +155,7 @@ pd: imx8qx-pd {
 		};
 
 		clk: clock-controller {
-			compatible = "fsl,imx8qxp-clk", "fsl,scu-clk";
+			compatible = "fsl,imx8qm-clk", "fsl,scu-clk";
 			#clock-cells = <2>;
 		};
 
diff --git a/arch/powerpc/kernel/reloc_64.S b/arch/powerpc/kernel/reloc_64.S
index 02d4719bf43a..232e4549defe 100644
--- a/arch/powerpc/kernel/reloc_64.S
+++ b/arch/powerpc/kernel/reloc_64.S
@@ -8,8 +8,10 @@
 #include <asm/ppc_asm.h>
 
 RELA = 7
-RELACOUNT = 0x6ffffff9
+RELASZ = 8
+RELAENT = 9
 R_PPC64_RELATIVE = 22
+R_PPC64_UADDR64 = 43
 
 /*
  * r3 = desired final address of kernel
@@ -25,29 +27,38 @@ _GLOBAL(relocate)
 	add	r9,r9,r12	/* r9 has runtime addr of .rela.dyn section */
 	ld	r10,(p_st - 0b)(r12)
 	add	r10,r10,r12	/* r10 has runtime addr of _stext */
+	ld	r13,(p_sym - 0b)(r12)
+	add	r13,r13,r12	/* r13 has runtime addr of .dynsym */
 
 	/*
-	 * Scan the dynamic section for the RELA and RELACOUNT entries.
+	 * Scan the dynamic section for the RELA, RELASZ and RELAENT entries.
 	 */
 	li	r7,0
 	li	r8,0
-1:	ld	r6,0(r11)	/* get tag */
+.Ltags:
+	ld	r6,0(r11)	/* get tag */
 	cmpdi	r6,0
-	beq	4f		/* end of list */
+	beq	.Lend_of_list		/* end of list */
 	cmpdi	r6,RELA
 	bne	2f
 	ld	r7,8(r11)	/* get RELA pointer in r7 */
-	b	3f
-2:	addis	r6,r6,(-RELACOUNT)@ha
-	cmpdi	r6,RELACOUNT@l
+	b	4f
+2:	cmpdi	r6,RELASZ
 	bne	3f
-	ld	r8,8(r11)	/* get RELACOUNT value in r8 */
-3:	addi	r11,r11,16
-	b	1b
-4:	cmpdi	r7,0		/* check we have both RELA and RELACOUNT */
+	ld	r8,8(r11)	/* get RELASZ value in r8 */
+	b	4f
+3:	cmpdi	r6,RELAENT
+	bne	4f
+	ld	r12,8(r11)	/* get RELAENT value in r12 */
+4:	addi	r11,r11,16
+	b	.Ltags
+.Lend_of_list:
+	cmpdi	r7,0		/* check we have RELA, RELASZ, RELAENT */
 	cmpdi	cr1,r8,0
-	beq	6f
-	beq	cr1,6f
+	beq	.Lout
+	beq	cr1,.Lout
+	cmpdi	r12,0
+	beq	.Lout
 
 	/*
 	 * Work out linktime address of _stext and hence the
@@ -62,23 +73,39 @@ _GLOBAL(relocate)
 
 	/*
 	 * Run through the list of relocations and process the
-	 * R_PPC64_RELATIVE ones.
+	 * R_PPC64_RELATIVE and R_PPC64_UADDR64 ones.
 	 */
+	divd	r8,r8,r12	/* RELASZ / RELAENT */
 	mtctr	r8
-5:	ld	r0,8(9)		/* ELF64_R_TYPE(reloc->r_info) */
+.Lrels:	ld	r0,8(r9)		/* ELF64_R_TYPE(reloc->r_info) */
 	cmpdi	r0,R_PPC64_RELATIVE
-	bne	6f
+	bne	.Luaddr64
 	ld	r6,0(r9)	/* reloc->r_offset */
 	ld	r0,16(r9)	/* reloc->r_addend */
+	b	.Lstore
+.Luaddr64:
+	srdi	r14,r0,32	/* ELF64_R_SYM(reloc->r_info) */
+	clrldi	r0,r0,32
+	cmpdi	r0,R_PPC64_UADDR64
+	bne	.Lnext
+	ld	r6,0(r9)
+	ld	r0,16(r9)
+	mulli	r14,r14,24	/* 24 == sizeof(elf64_sym) */
+	add	r14,r14,r13	/* elf64_sym[ELF64_R_SYM] */
+	ld	r14,8(r14)
+	add	r0,r0,r14
+.Lstore:
 	add	r0,r0,r3
 	stdx	r0,r7,r6
-	addi	r9,r9,24
-	bdnz	5b
-
-6:	blr
+.Lnext:
+	add	r9,r9,r12
+	bdnz	.Lrels
+.Lout:
+	blr
 
 .balign 8
 p_dyn:	.8byte	__dynamic_start - 0b
 p_rela:	.8byte	__rela_dyn_start - 0b
+p_sym:		.8byte __dynamic_symtab - 0b
 p_st:	.8byte	_stext - 0b
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 40bdefe9caa7..1a63e37f336a 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -275,9 +275,7 @@ SECTIONS
 	. = ALIGN(8);
 	.dynsym : AT(ADDR(.dynsym) - LOAD_OFFSET)
 	{
-#ifdef CONFIG_PPC32
 		__dynamic_symtab = .;
-#endif
 		*(.dynsym)
 	}
 	.dynstr : AT(ADDR(.dynstr) - LOAD_OFFSET) { *(.dynstr) }
diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 2f46e31c7612..4f53d0b97539 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -3,11 +3,11 @@
 obj-y				+= callchain.o callchain_$(BITS).o perf_regs.o
 obj-$(CONFIG_COMPAT)		+= callchain_32.o
 
-obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
 				   isa207-common.o power8-pmu.o power9-pmu.o \
-				   generic-compat-pmu.o power10-pmu.o
+				   generic-compat-pmu.o power10-pmu.o bhrb.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
 
 obj-$(CONFIG_PPC_POWERNV)	+= imc-pmu.o
diff --git a/arch/powerpc/tools/relocs_check.sh b/arch/powerpc/tools/relocs_check.sh
index 014e00e74d2b..63792af00417 100755
--- a/arch/powerpc/tools/relocs_check.sh
+++ b/arch/powerpc/tools/relocs_check.sh
@@ -39,6 +39,7 @@ $objdump -R "$vmlinux" |
 	#	R_PPC_NONE
 	grep -F -w -v 'R_PPC64_RELATIVE
 R_PPC64_NONE
+R_PPC64_UADDR64
 R_PPC_ADDR16_LO
 R_PPC_ADDR16_HI
 R_PPC_ADDR16_HA
@@ -54,9 +55,3 @@ fi
 num_bad=$(echo "$bad_relocs" | wc -l)
 echo "WARNING: $num_bad bad relocations"
 echo "$bad_relocs"
-
-# If we see this type of relocation it's an idication that
-# we /may/ be using an old version of binutils.
-if echo "$bad_relocs" | grep -q -F -w R_PPC64_UADDR64; then
-	echo "WARNING: You need at least binutils >= 2.19 to build a CONFIG_RELOCATABLE kernel"
-fi
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 0b552873a577..765004b60513 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
 	struct patch_insn *patch = data;
 	int ret = 0;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		ret =
 		    patch_text_nosync(patch->addr, &patch->insn,
 					    GET_INSN_LENGTH(patch->insn));
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index ab45a220fac4..fcbfe94903bb 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -132,10 +132,12 @@ extern void load_ucode_ap(void);
 void reload_early_microcode(void);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
+void microcode_bsp_resume(void);
 #else
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
 static inline void reload_early_microcode(void)			{ }
+static inline void microcode_bsp_resume(void)			{ }
 static inline bool
 get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
 #endif
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index efb69be41ab1..150ebfb8c12e 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -775,9 +775,9 @@ static struct subsys_interface mc_cpu_interface = {
 };
 
 /**
- * mc_bp_resume - Update boot CPU microcode during resume.
+ * microcode_bsp_resume - Update boot CPU microcode during resume.
  */
-static void mc_bp_resume(void)
+void microcode_bsp_resume(void)
 {
 	int cpu = smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -789,7 +789,7 @@ static void mc_bp_resume(void)
 }
 
 static struct syscore_ops mc_syscore_ops = {
-	.resume			= mc_bp_resume,
+	.resume			= microcode_bsp_resume,
 };
 
 static int mc_cpu_starting(unsigned int cpu)
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 508c81e97ab1..f1c0befb62df 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -121,7 +121,7 @@ void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 
 	/* cache copy and flush to align dest */
 	if (!IS_ALIGNED(dest, 8)) {
-		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+		size_t len = min_t(size_t, size, ALIGN(dest, 8) - dest);
 
 		memcpy((void *) dest, (void *) source, len);
 		clean_cache_range((void *) dest, len);
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 5debe4ac6f81..f153e9ab8c96 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -472,7 +472,6 @@ static __init void xen_setup_pci_msi(void)
 			xen_msi_ops.setup_msi_irqs = xen_setup_msi_irqs;
 		}
 		xen_msi_ops.teardown_msi_irqs = xen_pv_teardown_msi_irqs;
-		pci_msi_ignore_mask = 1;
 	} else if (xen_hvm_domain()) {
 		xen_msi_ops.setup_msi_irqs = xen_hvm_setup_msi_irqs;
 		xen_msi_ops.teardown_msi_irqs = xen_teardown_msi_irqs;
@@ -486,6 +485,11 @@ static __init void xen_setup_pci_msi(void)
 	 * in allocating the native domain and never use it.
 	 */
 	x86_init.irqs.create_pci_msi_domain = xen_create_pci_msi_domain;
+	/*
+	 * With XEN PIRQ/Eventchannels in use PCI/MSI[-X] masking is solely
+	 * controlled by the hypervisor.
+	 */
+	pci_msi_ignore_mask = 1;
 }
 
 #else /* CONFIG_PCI_MSI */
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 736008f2fccc..732cb075d707 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,6 +25,7 @@
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
+#include <asm/microcode.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -262,11 +263,18 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
 	perf_restore_debug_store();
-	msr_restore_context(ctxt);
 
 	c = &cpu_data(smp_processor_id());
 	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
 		init_ia32_feat_ctl(c);
+
+	microcode_bsp_resume();
+
+	/*
+	 * This needs to happen after the microcode has been updated upon resume
+	 * because some of the MSRs are "emulated" in microcode.
+	 */
+	msr_restore_context(ctxt);
 }
 
 /* Needed by apm.c */
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 81d7c7e8f7e9..10b79d3c74e0 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -36,24 +36,19 @@ static void rs_poll(struct timer_list *);
 static struct tty_driver *serial_driver;
 static struct tty_port serial_port;
 static DEFINE_TIMER(serial_timer, rs_poll);
-static DEFINE_SPINLOCK(timer_lock);
 
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
-	spin_lock_bh(&timer_lock);
 	if (tty->count == 1)
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
-	spin_unlock_bh(&timer_lock);
 
 	return 0;
 }
 
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
-	spin_lock_bh(&timer_lock);
 	if (tty->count == 1)
 		del_timer_sync(&serial_timer);
-	spin_unlock_bh(&timer_lock);
 }
 
 
@@ -73,8 +68,6 @@ static void rs_poll(struct timer_list *unused)
 	int rd = 1;
 	unsigned char c;
 
-	spin_lock(&timer_lock);
-
 	while (simc_poll(0)) {
 		rd = simc_read(0, &c, 1);
 		if (rd <= 0)
@@ -87,7 +80,6 @@ static void rs_poll(struct timer_list *unused)
 		tty_flip_buffer_push(port);
 	if (rd)
 		mod_timer(&serial_timer, jiffies + SERIAL_TIMER_VALUE);
-	spin_unlock(&timer_lock);
 }
 
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index eb7b0d6bd11f..10851493940c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2322,7 +2322,17 @@ static void ioc_timer_fn(struct timer_list *timer)
 				iocg->hweight_donating = hwa;
 				iocg->hweight_after_donation = new_hwi;
 				list_add(&iocg->surplus_list, &surpluses);
-			} else {
+			} else if (!iocg->abs_vdebt) {
+				/*
+				 * @iocg doesn't have enough to donate. Reset
+				 * its inuse to active.
+				 *
+				 * Don't reset debtors as their inuse's are
+				 * owned by debt handling. This shouldn't affect
+				 * donation calculuation in any meaningful way
+				 * as @iocg doesn't have a meaningful amount of
+				 * share anyway.
+				 */
 				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
 						iocg->inuse, iocg->active,
 						iocg->hweight_inuse, new_hwi);
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 1fd6a4a34c15..aedcb92491f2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -95,11 +95,6 @@ static const struct dmi_system_id processor_power_dmi_table[] = {
 	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
 	 (void *)1},
-	/* T40 can not handle C3 idle state */
-	{ set_max_cstate, "IBM ThinkPad T40", {
-	  DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "23737CU")},
-	 (void *)2},
 	{},
 };
 
@@ -797,7 +792,8 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
 		    cx->type == ACPI_STATE_C3) {
 			state->enter_dead = acpi_idle_play_dead;
-			drv->safe_state_index = count;
+			if (cx->type != ACPI_STATE_C3)
+				drv->safe_state_index = count;
 		}
 		/*
 		 * Halt-induced C1 is not good for ->enter_s2idle, because it
diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 43407665918f..ef4fc89f085d 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -609,7 +609,7 @@ void update_siblings_masks(unsigned int cpuid)
 	for_each_online_cpu(cpu) {
 		cpu_topo = &cpu_topology[cpu];
 
-		if (cpuid_topo->llc_id == cpu_topo->llc_id) {
+		if (cpu_topo->llc_id != -1 && cpuid_topo->llc_id == cpu_topo->llc_id) {
 			cpumask_set_cpu(cpu, &cpuid_topo->llc_sibling);
 			cpumask_set_cpu(cpuid, &cpu_topo->llc_sibling);
 		}
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index d243526b23d8..0982642a7907 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -1020,6 +1020,7 @@ static int __maybe_unused mhi_pci_freeze(struct device *dev)
 	 * the intermediate restore kernel reinitializes MHI device with new
 	 * context.
 	 */
+	flush_work(&mhi_pdev->recovery_work);
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
 		mhi_power_down(mhi_cntrl, true);
 		mhi_unprepare_after_power_down(mhi_cntrl);
@@ -1045,6 +1046,7 @@ static const struct dev_pm_ops mhi_pci_pm_ops = {
 	.resume = mhi_pci_resume,
 	.freeze = mhi_pci_freeze,
 	.thaw = mhi_pci_restore,
+	.poweroff = mhi_pci_freeze,
 	.restore = mhi_pci_restore,
 #endif
 };
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 4566e730ef2b..60b082fe2ed0 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -227,6 +227,8 @@ static struct sunxi_rsb_device *sunxi_rsb_device_create(struct sunxi_rsb *rsb,
 
 	dev_dbg(&rdev->dev, "device %s registered\n", dev_name(&rdev->dev));
 
+	return rdev;
+
 err_device_add:
 	put_device(&rdev->dev);
 
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index ebf22929ff32..00d46f3ae22f 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3162,13 +3162,27 @@ static int sysc_check_disabled_devices(struct sysc *ddata)
  */
 static int sysc_check_active_timer(struct sysc *ddata)
 {
+	int error;
+
 	if (ddata->cap->type != TI_SYSC_OMAP2_TIMER &&
 	    ddata->cap->type != TI_SYSC_OMAP4_TIMER)
 		return 0;
 
+	/*
+	 * Quirk for omap3 beagleboard revision A to B4 to use gpt12.
+	 * Revision C and later are fixed with commit 23885389dbbb ("ARM:
+	 * dts: Fix timer regression for beagleboard revision c"). This all
+	 * can be dropped if we stop supporting old beagleboard revisions
+	 * A to B4 at some point.
+	 */
+	if (sysc_soc->soc == SOC_3430)
+		error = -ENXIO;
+	else
+		error = -EBUSY;
+
 	if ((ddata->cfg.quirks & SYSC_QUIRK_NO_RESET_ON_INIT) &&
 	    (ddata->cfg.quirks & SYSC_QUIRK_NO_IDLE))
-		return -ENXIO;
+		return error;
 
 	return 0;
 }
diff --git a/drivers/clk/sunxi/clk-sun9i-mmc.c b/drivers/clk/sunxi/clk-sun9i-mmc.c
index 542b31d6e96d..636bcf2439ef 100644
--- a/drivers/clk/sunxi/clk-sun9i-mmc.c
+++ b/drivers/clk/sunxi/clk-sun9i-mmc.c
@@ -109,6 +109,8 @@ static int sun9i_a80_mmc_config_clk_probe(struct platform_device *pdev)
 	spin_lock_init(&data->lock);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
 	/* one clock/reset pair per word */
 	count = DIV_ROUND_UP((resource_size(r)), SUN9I_MMC_WIDTH);
 	data->membase = devm_ioremap_resource(&pdev->dev, r);
diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 35d93361fda1..bb2f59fd0de4 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -24,12 +24,16 @@
 #define CLK_HW_DIV			2
 #define LUT_TURBO_IND			1
 
+#define GT_IRQ_STATUS			BIT(2)
+
 #define HZ_PER_KHZ			1000
 
 struct qcom_cpufreq_soc_data {
 	u32 reg_enable;
+	u32 reg_domain_state;
 	u32 reg_freq_lut;
 	u32 reg_volt_lut;
+	u32 reg_intr_clr;
 	u32 reg_current_vote;
 	u32 reg_perf_state;
 	u8 lut_row_size;
@@ -266,28 +270,31 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 	}
 }
 
-static unsigned int qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
+static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 {
-	unsigned int val = readl_relaxed(data->base + data->soc_data->reg_current_vote);
+	unsigned int lval;
+
+	if (data->soc_data->reg_current_vote)
+		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
+	else
+		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
 
-	return (val & 0x3FF) * 19200;
+	return lval * xo_rate;
 }
 
 static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 {
 	unsigned long max_capacity, capacity, freq_hz, throttled_freq;
 	struct cpufreq_policy *policy = data->policy;
-	int cpu = cpumask_first(policy->cpus);
+	int cpu = cpumask_first(policy->related_cpus);
 	struct device *dev = get_cpu_device(cpu);
 	struct dev_pm_opp *opp;
-	unsigned int freq;
 
 	/*
 	 * Get the h/w throttled frequency, normalize it using the
 	 * registered opp table and use it to calculate thermal pressure.
 	 */
-	freq = qcom_lmh_get_throttle_freq(data);
-	freq_hz = freq * HZ_PER_KHZ;
+	freq_hz = qcom_lmh_get_throttle_freq(data);
 
 	opp = dev_pm_opp_find_freq_floor(dev, &freq_hz);
 	if (IS_ERR(opp) && PTR_ERR(opp) == -ERANGE)
@@ -345,6 +352,10 @@ static irqreturn_t qcom_lmh_dcvs_handle_irq(int irq, void *data)
 	disable_irq_nosync(c_data->throttle_irq);
 	schedule_delayed_work(&c_data->throttle_work, 0);
 
+	if (c_data->soc_data->reg_intr_clr)
+		writel_relaxed(GT_IRQ_STATUS,
+			       c_data->base + c_data->soc_data->reg_intr_clr);
+
 	return IRQ_HANDLED;
 }
 
@@ -359,8 +370,10 @@ static const struct qcom_cpufreq_soc_data qcom_soc_data = {
 
 static const struct qcom_cpufreq_soc_data epss_soc_data = {
 	.reg_enable = 0x0,
+	.reg_domain_state = 0x20,
 	.reg_freq_lut = 0x100,
 	.reg_volt_lut = 0x200,
+	.reg_intr_clr = 0x308,
 	.reg_perf_state = 0x320,
 	.lut_row_size = 4,
 };
diff --git a/drivers/cpufreq/sun50i-cpufreq-nvmem.c b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
index 2deed8d8773f..75e1bf3a08f7 100644
--- a/drivers/cpufreq/sun50i-cpufreq-nvmem.c
+++ b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
@@ -98,8 +98,10 @@ static int sun50i_cpufreq_nvmem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = sun50i_cpufreq_get_efuse(&speed);
-	if (ret)
+	if (ret) {
+		kfree(opp_tables);
 		return ret;
+	}
 
 	snprintf(name, MAX_NAME_LEN, "speed%d", speed);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4f2e0cc8a51a..442857f3bde7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -138,19 +138,33 @@ void program_sh_mem_settings(struct device_queue_manager *dqm,
 }
 
 static void increment_queue_count(struct device_queue_manager *dqm,
-			enum kfd_queue_type type)
+				  struct qcm_process_device *qpd,
+				  struct queue *q)
 {
 	dqm->active_queue_count++;
-	if (type == KFD_QUEUE_TYPE_COMPUTE || type == KFD_QUEUE_TYPE_DIQ)
+	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE ||
+	    q->properties.type == KFD_QUEUE_TYPE_DIQ)
 		dqm->active_cp_queue_count++;
+
+	if (q->properties.is_gws) {
+		dqm->gws_queue_count++;
+		qpd->mapped_gws_queue = true;
+	}
 }
 
 static void decrement_queue_count(struct device_queue_manager *dqm,
-			enum kfd_queue_type type)
+				  struct qcm_process_device *qpd,
+				  struct queue *q)
 {
 	dqm->active_queue_count--;
-	if (type == KFD_QUEUE_TYPE_COMPUTE || type == KFD_QUEUE_TYPE_DIQ)
+	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE ||
+	    q->properties.type == KFD_QUEUE_TYPE_DIQ)
 		dqm->active_cp_queue_count--;
+
+	if (q->properties.is_gws) {
+		dqm->gws_queue_count--;
+		qpd->mapped_gws_queue = false;
+	}
 }
 
 static int allocate_doorbell(struct qcm_process_device *qpd, struct queue *q)
@@ -390,7 +404,7 @@ static int create_queue_nocpsch(struct device_queue_manager *dqm,
 	list_add(&q->list, &qpd->queues_list);
 	qpd->queue_count++;
 	if (q->properties.is_active)
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, qpd, q);
 
 	/*
 	 * Unconditionally increment this counter, regardless of the queue's
@@ -515,13 +529,8 @@ static int destroy_queue_nocpsch_locked(struct device_queue_manager *dqm,
 		deallocate_vmid(dqm, qpd, q);
 	}
 	qpd->queue_count--;
-	if (q->properties.is_active) {
-		decrement_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
-	}
+	if (q->properties.is_active)
+		decrement_queue_count(dqm, qpd, q);
 
 	return retval;
 }
@@ -613,12 +622,11 @@ static int update_queue(struct device_queue_manager *dqm, struct queue *q)
 	 * dqm->active_queue_count to determine whether a new runlist must be
 	 * uploaded.
 	 */
-	if (q->properties.is_active && !prev_active)
-		increment_queue_count(dqm, q->properties.type);
-	else if (!q->properties.is_active && prev_active)
-		decrement_queue_count(dqm, q->properties.type);
-
-	if (q->gws && !q->properties.is_gws) {
+	if (q->properties.is_active && !prev_active) {
+		increment_queue_count(dqm, &pdd->qpd, q);
+	} else if (!q->properties.is_active && prev_active) {
+		decrement_queue_count(dqm, &pdd->qpd, q);
+	} else if (q->gws && !q->properties.is_gws) {
 		if (q->properties.is_active) {
 			dqm->gws_queue_count++;
 			pdd->qpd.mapped_gws_queue = true;
@@ -680,11 +688,7 @@ static int evict_process_queues_nocpsch(struct device_queue_manager *dqm,
 		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 				q->properties.type)];
 		q->properties.is_active = false;
-		decrement_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
+		decrement_queue_count(dqm, qpd, q);
 
 		if (WARN_ONCE(!dqm->sched_running, "Evict when stopped\n"))
 			continue;
@@ -730,7 +734,7 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 			continue;
 
 		q->properties.is_active = false;
-		decrement_queue_count(dqm, q->properties.type);
+		decrement_queue_count(dqm, qpd, q);
 	}
 	pdd->last_evict_timestamp = get_jiffies_64();
 	retval = execute_queues_cpsch(dqm,
@@ -801,11 +805,7 @@ static int restore_process_queues_nocpsch(struct device_queue_manager *dqm,
 		mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 				q->properties.type)];
 		q->properties.is_active = true;
-		increment_queue_count(dqm, q->properties.type);
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count++;
-			qpd->mapped_gws_queue = true;
-		}
+		increment_queue_count(dqm, qpd, q);
 
 		if (WARN_ONCE(!dqm->sched_running, "Restore when stopped\n"))
 			continue;
@@ -863,7 +863,7 @@ static int restore_process_queues_cpsch(struct device_queue_manager *dqm,
 			continue;
 
 		q->properties.is_active = true;
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, &pdd->qpd, q);
 	}
 	retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
@@ -1265,7 +1265,7 @@ static int create_kernel_queue_cpsch(struct device_queue_manager *dqm,
 			dqm->total_queue_count);
 
 	list_add(&kq->list, &qpd->priv_queue_list);
-	increment_queue_count(dqm, kq->queue->properties.type);
+	increment_queue_count(dqm, qpd, kq->queue);
 	qpd->is_debug = true;
 	execute_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 	dqm_unlock(dqm);
@@ -1279,7 +1279,7 @@ static void destroy_kernel_queue_cpsch(struct device_queue_manager *dqm,
 {
 	dqm_lock(dqm);
 	list_del(&kq->list);
-	decrement_queue_count(dqm, kq->queue->properties.type);
+	decrement_queue_count(dqm, qpd, kq->queue);
 	qpd->is_debug = false;
 	execute_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES, 0);
 	/*
@@ -1346,7 +1346,7 @@ static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
 	qpd->queue_count++;
 
 	if (q->properties.is_active) {
-		increment_queue_count(dqm, q->properties.type);
+		increment_queue_count(dqm, qpd, q);
 
 		execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
@@ -1548,15 +1548,11 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	list_del(&q->list);
 	qpd->queue_count--;
 	if (q->properties.is_active) {
-		decrement_queue_count(dqm, q->properties.type);
+		decrement_queue_count(dqm, qpd, q);
 		retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 		if (retval == -ETIME)
 			qpd->reset_wavefronts = true;
-		if (q->properties.is_gws) {
-			dqm->gws_queue_count--;
-			qpd->mapped_gws_queue = false;
-		}
 	}
 
 	/*
@@ -1747,7 +1743,7 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 	/* Clean all kernel queues */
 	list_for_each_entry_safe(kq, kq_next, &qpd->priv_queue_list, list) {
 		list_del(&kq->list);
-		decrement_queue_count(dqm, kq->queue->properties.type);
+		decrement_queue_count(dqm, qpd, kq->queue);
 		qpd->is_debug = false;
 		dqm->total_queue_count--;
 		filter = KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES;
@@ -1760,13 +1756,8 @@ static int process_termination_cpsch(struct device_queue_manager *dqm,
 		else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
 			deallocate_sdma_queue(dqm, q);
 
-		if (q->properties.is_active) {
-			decrement_queue_count(dqm, q->properties.type);
-			if (q->properties.is_gws) {
-				dqm->gws_queue_count--;
-				qpd->mapped_gws_queue = false;
-			}
-		}
+		if (q->properties.is_active)
+			decrement_queue_count(dqm, qpd, q);
 
 		dqm->total_queue_count--;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index fbbdf9976183..5b8274b8c384 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1428,6 +1428,7 @@ static struct clock_source *dcn21_clock_source_create(
 		return &clk_src->base;
 	}
 
+	kfree(clk_src);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index c82f8febe730..e7b90863aa43 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -96,6 +96,14 @@
 
 #define INTEL_EDP_BRIGHTNESS_OPTIMIZATION_1                            0x359
 
+enum intel_dp_aux_backlight_modparam {
+	INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
+	INTEL_DP_AUX_BACKLIGHT_OFF = 0,
+	INTEL_DP_AUX_BACKLIGHT_ON = 1,
+	INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
+	INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
+};
+
 /* Intel EDP backlight callbacks */
 static bool
 intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
@@ -125,6 +133,24 @@ intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
 		return false;
 	}
 
+	/*
+	 * If we don't have HDR static metadata there is no way to
+	 * runtime detect used range for nits based control. For now
+	 * do not use Intel proprietary eDP backlight control if we
+	 * don't have this data in panel EDID. In case we find panel
+	 * which supports only nits based control, but doesn't provide
+	 * HDR static metadata we need to start maintaining table of
+	 * ranges for such panels.
+	 */
+	if (i915->params.enable_dpcd_backlight != INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL &&
+	    !(connector->base.hdr_sink_metadata.hdmi_type1.metadata_type &
+	      BIT(HDMI_STATIC_METADATA_TYPE1))) {
+		drm_info(&i915->drm,
+			 "Panel is missing HDR static metadata. Possible support for Intel HDR backlight interface is not used. If your backlight controls don't work try booting with i915.enable_dpcd_backlight=%d. needs this, please file a _new_ bug report on drm/i915, see " FDO_BUG_URL " for details.\n",
+			 INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL);
+		return false;
+	}
+
 	panel->backlight.edp.intel.sdr_uses_aux =
 		tcon_cap[2] & INTEL_EDP_SDR_TCON_BRIGHTNESS_AUX_CAP;
 
@@ -373,14 +399,6 @@ static const struct intel_panel_bl_funcs intel_dp_vesa_bl_funcs = {
 	.get = intel_dp_aux_vesa_get_backlight,
 };
 
-enum intel_dp_aux_backlight_modparam {
-	INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
-	INTEL_DP_AUX_BACKLIGHT_OFF = 0,
-	INTEL_DP_AUX_BACKLIGHT_ON = 1,
-	INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
-	INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
-};
-
 int intel_dp_aux_init_backlight_funcs(struct intel_connector *connector)
 {
 	struct drm_device *dev = connector->base.dev;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index c65473fc9093..bb64e7baa1cc 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7458,7 +7458,7 @@ enum {
 #define _SEL_FETCH_PLANE_BASE_6_A		0x70940
 #define _SEL_FETCH_PLANE_BASE_7_A		0x70960
 #define _SEL_FETCH_PLANE_BASE_CUR_A		0x70880
-#define _SEL_FETCH_PLANE_BASE_1_B		0x70990
+#define _SEL_FETCH_PLANE_BASE_1_B		0x71890
 
 #define _SEL_FETCH_PLANE_BASE_A(plane) _PICK(plane, \
 					     _SEL_FETCH_PLANE_BASE_1_A, \
diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.c b/drivers/gpu/drm/sun4i/sun4i_frontend.c
index edb60ae0a9b7..faecc2935039 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.c
@@ -222,13 +222,11 @@ void sun4i_frontend_update_buffer(struct sun4i_frontend *frontend,
 
 	/* Set the physical address of the buffer in memory */
 	paddr = drm_fb_cma_get_gem_addr(fb, state, 0);
-	paddr -= PHYS_OFFSET;
 	DRM_DEBUG_DRIVER("Setting buffer #0 address to %pad\n", &paddr);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR0_REG, paddr);
 
 	if (fb->format->num_planes > 1) {
 		paddr = drm_fb_cma_get_gem_addr(fb, state, swap ? 2 : 1);
-		paddr -= PHYS_OFFSET;
 		DRM_DEBUG_DRIVER("Setting buffer #1 address to %pad\n", &paddr);
 		regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR1_REG,
 			     paddr);
@@ -236,7 +234,6 @@ void sun4i_frontend_update_buffer(struct sun4i_frontend *frontend,
 
 	if (fb->format->num_planes > 2) {
 		paddr = drm_fb_cma_get_gem_addr(fb, state, swap ? 1 : 2);
-		paddr -= PHYS_OFFSET;
 		DRM_DEBUG_DRIVER("Setting buffer #2 address to %pad\n", &paddr);
 		regmap_write(frontend->regs, SUN4I_FRONTEND_BUF_ADDR2_REG,
 			     paddr);
diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
index e50718422411..cafb8c779015 100644
--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -178,7 +178,7 @@ static int ad5446_read_raw(struct iio_dev *indio_dev,
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
-		*val = st->cached_val;
+		*val = st->cached_val >> chan->scan_type.shift;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		*val = st->vref_mv;
diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index 0405e92b9e8c..987264410278 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -523,7 +523,7 @@ static int ad5592r_alloc_channels(struct iio_dev *iio_dev)
 		if (!ret)
 			st->channel_modes[reg] = tmp;
 
-		fwnode_property_read_u32(child, "adi,off-state", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,off-state", &tmp);
 		if (!ret)
 			st->channel_offstate[reg] = tmp;
 	}
diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 824b5124a5f5..01336105792e 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -730,7 +730,7 @@ static int bmi160_chip_init(struct bmi160_data *data, bool use_spi)
 
 	ret = regmap_write(data->regmap, BMI160_REG_CMD, BMI160_CMD_SOFTRESET);
 	if (ret)
-		return ret;
+		goto disable_regulator;
 
 	usleep_range(BMI160_SOFTRESET_USLEEP, BMI160_SOFTRESET_USLEEP + 1);
 
@@ -741,29 +741,37 @@ static int bmi160_chip_init(struct bmi160_data *data, bool use_spi)
 	if (use_spi) {
 		ret = regmap_read(data->regmap, BMI160_REG_DUMMY, &val);
 		if (ret)
-			return ret;
+			goto disable_regulator;
 	}
 
 	ret = regmap_read(data->regmap, BMI160_REG_CHIP_ID, &val);
 	if (ret) {
 		dev_err(dev, "Error reading chip id\n");
-		return ret;
+		goto disable_regulator;
 	}
 	if (val != BMI160_CHIP_ID_VAL) {
 		dev_err(dev, "Wrong chip id, got %x expected %x\n",
 			val, BMI160_CHIP_ID_VAL);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto disable_regulator;
 	}
 
 	ret = bmi160_set_mode(data, BMI160_ACCEL, true);
 	if (ret)
-		return ret;
+		goto disable_regulator;
 
 	ret = bmi160_set_mode(data, BMI160_GYRO, true);
 	if (ret)
-		return ret;
+		goto disable_accel;
 
 	return 0;
+
+disable_accel:
+	bmi160_set_mode(data, BMI160_ACCEL, false);
+
+disable_regulator:
+	regulator_bulk_disable(ARRAY_SIZE(data->supplies), data->supplies);
+	return ret;
 }
 
 static int bmi160_data_rdy_trigger_set_state(struct iio_trigger *trig,
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
index 85b1934cec60..53891010a91d 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
@@ -18,12 +18,15 @@ static int inv_icm42600_i2c_bus_setup(struct inv_icm42600_state *st)
 	unsigned int mask, val;
 	int ret;
 
-	/* setup interface registers */
-	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
-				 INV_ICM42600_INTF_CONFIG6_MASK,
-				 INV_ICM42600_INTF_CONFIG6_I3C_EN);
-	if (ret)
-		return ret;
+	/*
+	 * setup interface registers
+	 * This register write to REG_INTF_CONFIG6 enables a spike filter that
+	 * is impacting the line and can prevent the I2C ACK to be seen by the
+	 * controller. So we don't test the return value.
+	 */
+	regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
+			   INV_ICM42600_INTF_CONFIG6_MASK,
+			   INV_ICM42600_INTF_CONFIG6_I3C_EN);
 
 	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG4,
 				 INV_ICM42600_INTF_CONFIG4_I3C_BUS_ONLY, 0);
diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 42b8a2680e3a..1509fd0cbb50 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -389,6 +389,7 @@ static int ak8975_power_on(const struct ak8975_data *data)
 	if (ret) {
 		dev_warn(&data->client->dev,
 			 "Failed to enable specified Vid supply\n");
+		regulator_disable(data->vdd);
 		return ret;
 	}
 
diff --git a/drivers/interconnect/qcom/sdx55.c b/drivers/interconnect/qcom/sdx55.c
index 03d604f84cc5..e3ac25a997b7 100644
--- a/drivers/interconnect/qcom/sdx55.c
+++ b/drivers/interconnect/qcom/sdx55.c
@@ -18,7 +18,6 @@
 #include "icc-rpmh.h"
 #include "sdx55.h"
 
-DEFINE_QNODE(ipa_core_master, SDX55_MASTER_IPA_CORE, 1, 8, SDX55_SLAVE_IPA_CORE);
 DEFINE_QNODE(llcc_mc, SDX55_MASTER_LLCC, 4, 4, SDX55_SLAVE_EBI_CH0);
 DEFINE_QNODE(acm_tcu, SDX55_MASTER_TCU_0, 1, 8, SDX55_SLAVE_LLCC, SDX55_SLAVE_MEM_NOC_SNOC, SDX55_SLAVE_MEM_NOC_PCIE_SNOC);
 DEFINE_QNODE(qnm_snoc_gc, SDX55_MASTER_SNOC_GC_MEM_NOC, 1, 8, SDX55_SLAVE_LLCC);
@@ -40,7 +39,6 @@ DEFINE_QNODE(xm_pcie, SDX55_MASTER_PCIE, 1, 8, SDX55_SLAVE_ANOC_SNOC);
 DEFINE_QNODE(xm_qdss_etr, SDX55_MASTER_QDSS_ETR, 1, 8, SDX55_SLAVE_SNOC_CFG, SDX55_SLAVE_EMAC_CFG, SDX55_SLAVE_USB3, SDX55_SLAVE_AOSS, SDX55_SLAVE_SPMI_FETCHER, SDX55_SLAVE_QDSS_CFG, SDX55_SLAVE_PDM, SDX55_SLAVE_SNOC_MEM_NOC_GC, SDX55_SLAVE_TCSR, SDX55_SLAVE_CNOC_DDRSS, SDX55_SLAVE_SPMI_VGI_COEX, SDX55_SLAVE_QPIC, SDX55_SLAVE_OCIMEM, SDX55_SLAVE_IPA_CFG, SDX55_SLAVE_USB3_PHY_CFG, SDX55_SLAVE_AOP, SDX55_SLAVE_BLSP_1, SDX55_SLAVE_SDCC_1, SDX55_SLAVE_CNOC_MSS, SDX55_SLAVE_PCIE_PARF, SDX55_SLAVE_ECC_CFG, SDX55_SLAVE_AUDIO, SDX55_SLAVE_AOSS, SDX55_SLAVE_PRNG, SDX55_SLAVE_CRYPTO_0_CFG, SDX55_SLAVE_TCU, SDX55_SLAVE_CLK_CTL, SDX55_SLAVE_IMEM_CFG);
 DEFINE_QNODE(xm_sdc1, SDX55_MASTER_SDCC_1, 1, 8, SDX55_SLAVE_AOSS, SDX55_SLAVE_IPA_CFG, SDX55_SLAVE_ANOC_SNOC, SDX55_SLAVE_AOP, SDX55_SLAVE_AUDIO);
 DEFINE_QNODE(xm_usb3, SDX55_MASTER_USB3, 1, 8, SDX55_SLAVE_ANOC_SNOC);
-DEFINE_QNODE(ipa_core_slave, SDX55_SLAVE_IPA_CORE, 1, 8);
 DEFINE_QNODE(ebi, SDX55_SLAVE_EBI_CH0, 1, 4);
 DEFINE_QNODE(qns_llcc, SDX55_SLAVE_LLCC, 1, 16, SDX55_SLAVE_EBI_CH0);
 DEFINE_QNODE(qns_memnoc_snoc, SDX55_SLAVE_MEM_NOC_SNOC, 1, 8, SDX55_MASTER_MEM_NOC_SNOC);
@@ -82,7 +80,6 @@ DEFINE_QNODE(xs_sys_tcu_cfg, SDX55_SLAVE_TCU, 1, 8);
 DEFINE_QBCM(bcm_mc0, "MC0", true, &ebi);
 DEFINE_QBCM(bcm_sh0, "SH0", true, &qns_llcc);
 DEFINE_QBCM(bcm_ce0, "CE0", false, &qxm_crypto);
-DEFINE_QBCM(bcm_ip0, "IP0", false, &ipa_core_slave);
 DEFINE_QBCM(bcm_pn0, "PN0", false, &qhm_snoc_cfg);
 DEFINE_QBCM(bcm_sh3, "SH3", false, &xm_apps_rdwr);
 DEFINE_QBCM(bcm_sh4, "SH4", false, &qns_memnoc_snoc, &qns_sys_pcie);
@@ -219,22 +216,6 @@ static const struct qcom_icc_desc sdx55_system_noc = {
 	.num_bcms = ARRAY_SIZE(system_noc_bcms),
 };
 
-static struct qcom_icc_bcm *ipa_virt_bcms[] = {
-	&bcm_ip0,
-};
-
-static struct qcom_icc_node *ipa_virt_nodes[] = {
-	[MASTER_IPA_CORE] = &ipa_core_master,
-	[SLAVE_IPA_CORE] = &ipa_core_slave,
-};
-
-static const struct qcom_icc_desc sdx55_ipa_virt = {
-	.nodes = ipa_virt_nodes,
-	.num_nodes = ARRAY_SIZE(ipa_virt_nodes),
-	.bcms = ipa_virt_bcms,
-	.num_bcms = ARRAY_SIZE(ipa_virt_bcms),
-};
-
 static const struct of_device_id qnoc_of_match[] = {
 	{ .compatible = "qcom,sdx55-mc-virt",
 	  .data = &sdx55_mc_virt},
@@ -242,8 +223,6 @@ static const struct of_device_id qnoc_of_match[] = {
 	  .data = &sdx55_mem_noc},
 	{ .compatible = "qcom,sdx55-system-noc",
 	  .data = &sdx55_system_noc},
-	{ .compatible = "qcom,sdx55-ipa-virt",
-	  .data = &sdx55_ipa_virt},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, qnoc_of_match);
diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 2a4c1f94bfa0..3a416705f61c 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -162,25 +162,39 @@ static const struct regmap_access_table rpcif_volatile_table = {
 
 
 /*
- * Custom accessor functions to ensure SMRDR0 and SMWDR0 are always accessed
- * with proper width. Requires SMENR_SPIDE to be correctly set before!
+ * Custom accessor functions to ensure SM[RW]DR[01] are always accessed with
+ * proper width.  Requires rpcif.xfer_size to be correctly set before!
  */
 static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
 	struct rpcif *rpc = context;
 
-	if (reg == RPCIF_SMRDR0 || reg == RPCIF_SMWDR0) {
-		u32 spide = readl(rpc->base + RPCIF_SMENR) & RPCIF_SMENR_SPIDE(0xF);
-
-		if (spide == 0x8) {
+	switch (reg) {
+	case RPCIF_SMRDR0:
+	case RPCIF_SMWDR0:
+		switch (rpc->xfer_size) {
+		case 1:
 			*val = readb(rpc->base + reg);
 			return 0;
-		} else if (spide == 0xC) {
+
+		case 2:
 			*val = readw(rpc->base + reg);
 			return 0;
-		} else if (spide != 0xF) {
+
+		case 4:
+		case 8:
+			*val = readl(rpc->base + reg);
+			return 0;
+
+		default:
 			return -EILSEQ;
 		}
+
+	case RPCIF_SMRDR1:
+	case RPCIF_SMWDR1:
+		if (rpc->xfer_size != 8)
+			return -EILSEQ;
+		break;
 	}
 
 	*val = readl(rpc->base + reg);
@@ -192,18 +206,34 @@ static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
 {
 	struct rpcif *rpc = context;
 
-	if (reg == RPCIF_SMRDR0 || reg == RPCIF_SMWDR0) {
-		u32 spide = readl(rpc->base + RPCIF_SMENR) & RPCIF_SMENR_SPIDE(0xF);
-
-		if (spide == 0x8) {
+	switch (reg) {
+	case RPCIF_SMWDR0:
+		switch (rpc->xfer_size) {
+		case 1:
 			writeb(val, rpc->base + reg);
 			return 0;
-		} else if (spide == 0xC) {
+
+		case 2:
 			writew(val, rpc->base + reg);
 			return 0;
-		} else if (spide != 0xF) {
+
+		case 4:
+		case 8:
+			writel(val, rpc->base + reg);
+			return 0;
+
+		default:
 			return -EILSEQ;
 		}
+
+	case RPCIF_SMWDR1:
+		if (rpc->xfer_size != 8)
+			return -EILSEQ;
+		break;
+
+	case RPCIF_SMRDR0:
+	case RPCIF_SMRDR1:
+		return -EPERM;
 	}
 
 	writel(val, rpc->base + reg);
@@ -442,6 +472,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 
 			smenr |= RPCIF_SMENR_SPIDE(rpcif_bits_set(rpc, nbytes));
 			regmap_write(rpc->regmap, RPCIF_SMENR, smenr);
+			rpc->xfer_size = nbytes;
 
 			memcpy(data, rpc->buffer + pos, nbytes);
 			if (nbytes == 8) {
@@ -506,6 +537,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 			regmap_write(rpc->regmap, RPCIF_SMENR, smenr);
 			regmap_write(rpc->regmap, RPCIF_SMCR,
 				     rpc->smcr | RPCIF_SMCR_SPIE);
+			rpc->xfer_size = nbytes;
 			ret = wait_msg_xfer_end(rpc);
 			if (ret)
 				goto err_out;
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 9193b812bc07..403243859dce 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -30,6 +30,8 @@
  */
 
 #define	FM25_SN_LEN	8		/* serial number length */
+#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
+
 struct at25_data {
 	struct spi_device	*spi;
 	struct mutex		lock;
@@ -38,6 +40,7 @@ struct at25_data {
 	struct nvmem_config	nvmem_config;
 	struct nvmem_device	*nvmem;
 	u8 sernum[FM25_SN_LEN];
+	u8 command[EE_MAXADDRLEN + 1];
 };
 
 #define	AT25_WREN	0x06		/* latch the write enable */
@@ -60,8 +63,6 @@ struct at25_data {
 
 #define	FM25_ID_LEN	9		/* ID length */
 
-#define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
-
 /* Specs often allow 5 msec for a page write, sometimes 20 msec;
  * it's important to recover from write timeouts.
  */
@@ -76,7 +77,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 {
 	struct at25_data *at25 = priv;
 	char *buf = val;
-	u8			command[EE_MAXADDRLEN + 1];
 	u8			*cp;
 	ssize_t			status;
 	struct spi_transfer	t[2];
@@ -90,12 +90,15 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	if (unlikely(!count))
 		return -EINVAL;
 
-	cp = command;
+	cp = at25->command;
 
 	instr = AT25_READ;
 	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
 		if (offset >= (1U << (at25->addrlen * 8)))
 			instr |= AT25_INSTR_BIT3;
+
+	mutex_lock(&at25->lock);
+
 	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
@@ -114,7 +117,7 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = command;
+	t[0].tx_buf = at25->command;
 	t[0].len = at25->addrlen + 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -122,8 +125,6 @@ static int at25_ee_read(void *priv, unsigned int offset,
 	t[1].len = count;
 	spi_message_add_tail(&t[1], &m);
 
-	mutex_lock(&at25->lock);
-
 	/* Read it all at once.
 	 *
 	 * REVISIT that's potentially a problem with large chips, if
@@ -151,7 +152,7 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = &command;
+	t[0].tx_buf = at25->command;
 	t[0].len = 1;
 	spi_message_add_tail(&t[0], &m);
 
@@ -161,6 +162,8 @@ static int fm25_aux_read(struct at25_data *at25, u8 *buf, uint8_t command,
 
 	mutex_lock(&at25->lock);
 
+	at25->command[0] = command;
+
 	status = spi_sync(at25->spi, &m);
 	dev_dbg(&at25->spi->dev, "read %d aux bytes --> %d\n", len, status);
 
diff --git a/drivers/mtd/nand/raw/mtk_ecc.c b/drivers/mtd/nand/raw/mtk_ecc.c
index c437d97debb8..ec9d1fb07006 100644
--- a/drivers/mtd/nand/raw/mtk_ecc.c
+++ b/drivers/mtd/nand/raw/mtk_ecc.c
@@ -43,6 +43,7 @@
 
 struct mtk_ecc_caps {
 	u32 err_mask;
+	u32 err_shift;
 	const u8 *ecc_strength;
 	const u32 *ecc_regs;
 	u8 num_ecc_strength;
@@ -76,7 +77,7 @@ static const u8 ecc_strength_mt2712[] = {
 };
 
 static const u8 ecc_strength_mt7622[] = {
-	4, 6, 8, 10, 12, 14, 16
+	4, 6, 8, 10, 12
 };
 
 enum mtk_ecc_regs {
@@ -221,7 +222,7 @@ void mtk_ecc_get_stats(struct mtk_ecc *ecc, struct mtk_ecc_stats *stats,
 	for (i = 0; i < sectors; i++) {
 		offset = (i >> 2) << 2;
 		err = readl(ecc->regs + ECC_DECENUM0 + offset);
-		err = err >> ((i % 4) * 8);
+		err = err >> ((i % 4) * ecc->caps->err_shift);
 		err &= ecc->caps->err_mask;
 		if (err == ecc->caps->err_mask) {
 			/* uncorrectable errors */
@@ -449,6 +450,7 @@ EXPORT_SYMBOL(mtk_ecc_get_parity_bits);
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt2701 = {
 	.err_mask = 0x3f,
+	.err_shift = 8,
 	.ecc_strength = ecc_strength_mt2701,
 	.ecc_regs = mt2701_ecc_regs,
 	.num_ecc_strength = 20,
@@ -459,6 +461,7 @@ static const struct mtk_ecc_caps mtk_ecc_caps_mt2701 = {
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt2712 = {
 	.err_mask = 0x7f,
+	.err_shift = 8,
 	.ecc_strength = ecc_strength_mt2712,
 	.ecc_regs = mt2712_ecc_regs,
 	.num_ecc_strength = 23,
@@ -468,10 +471,11 @@ static const struct mtk_ecc_caps mtk_ecc_caps_mt2712 = {
 };
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt7622 = {
-	.err_mask = 0x3f,
+	.err_mask = 0x1f,
+	.err_shift = 5,
 	.ecc_strength = ecc_strength_mt7622,
 	.ecc_regs = mt7622_ecc_regs,
-	.num_ecc_strength = 7,
+	.num_ecc_strength = 5,
 	.ecc_mode_shift = 4,
 	.parity_bits = 13,
 	.pg_irq_sel = 0,
diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 0f41a9a42157..e972bee60e7c 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2641,10 +2641,23 @@ static int qcom_nand_attach_chip(struct nand_chip *chip)
 	ecc->engine_type = NAND_ECC_ENGINE_TYPE_ON_HOST;
 
 	mtd_set_ooblayout(mtd, &qcom_nand_ooblayout_ops);
+	/* Free the initially allocated BAM transaction for reading the ONFI params */
+	if (nandc->props->is_bam)
+		free_bam_transaction(nandc);
 
 	nandc->max_cwperpage = max_t(unsigned int, nandc->max_cwperpage,
 				     cwperpage);
 
+	/* Now allocate the BAM transaction based on updated max_cwperpage */
+	if (nandc->props->is_bam) {
+		nandc->bam_txn = alloc_bam_transaction(nandc);
+		if (!nandc->bam_txn) {
+			dev_err(nandc->dev,
+				"failed to allocate bam transaction\n");
+			return -ENOMEM;
+		}
+	}
+
 	/*
 	 * DATA_UD_BYTES varies based on whether the read/write command protects
 	 * spare data with ECC too. We protect spare data by default, so we set
@@ -2945,17 +2958,6 @@ static int qcom_nand_host_init_and_register(struct qcom_nand_controller *nandc,
 	if (ret)
 		return ret;
 
-	if (nandc->props->is_bam) {
-		free_bam_transaction(nandc);
-		nandc->bam_txn = alloc_bam_transaction(nandc);
-		if (!nandc->bam_txn) {
-			dev_err(nandc->dev,
-				"failed to allocate bam transaction\n");
-			nand_cleanup(chip);
-			return -ENOMEM;
-		}
-	}
-
 	ret = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (ret)
 		nand_cleanup(chip);
diff --git a/drivers/mtd/nand/raw/sh_flctl.c b/drivers/mtd/nand/raw/sh_flctl.c
index 13df4bdf792a..8f89e2d3d817 100644
--- a/drivers/mtd/nand/raw/sh_flctl.c
+++ b/drivers/mtd/nand/raw/sh_flctl.c
@@ -384,7 +384,8 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 	dma_addr_t dma_addr;
 	dma_cookie_t cookie;
 	uint32_t reg;
-	int ret;
+	int ret = 0;
+	unsigned long time_left;
 
 	if (dir == DMA_FROM_DEVICE) {
 		chan = flctl->chan_fifo0_rx;
@@ -425,13 +426,14 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 		goto out;
 	}
 
-	ret =
+	time_left =
 	wait_for_completion_timeout(&flctl->dma_complete,
 				msecs_to_jiffies(3000));
 
-	if (ret <= 0) {
+	if (time_left == 0) {
 		dmaengine_terminate_all(chan);
 		dev_err(&flctl->pdev->dev, "wait_for_completion_timeout\n");
+		ret = -ETIMEDOUT;
 	}
 
 out:
@@ -441,7 +443,7 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl *flctl, unsigned long *buf,
 
 	dma_unmap_single(chan->device->dev, dma_addr, len, dir);
 
-	/* ret > 0 is success */
+	/* ret == 0 is success */
 	return ret;
 }
 
@@ -465,7 +467,7 @@ static void read_fiforeg(struct sh_flctl *flctl, int rlen, int offset)
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_rx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_FROM_DEVICE) > 0)
+		!flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_FROM_DEVICE))
 			goto convert;	/* DMA success */
 
 	/* do polling transfer */
@@ -524,7 +526,7 @@ static void write_ec_fiforeg(struct sh_flctl *flctl, int rlen,
 
 	/* initiate DMA transfer */
 	if (flctl->chan_fifo0_tx && rlen >= 32 &&
-		flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_TO_DEVICE) > 0)
+		!flctl_dma_fifo0_transfer(flctl, buf, rlen, DMA_TO_DEVICE))
 			return;	/* DMA success */
 
 	/* do polling transfer */
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 46c3301a5e07..2e75b7e8f70b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3817,14 +3817,19 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const v
 	return true;
 }
 
-static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
+static u32 bond_ip_hash(u32 hash, struct flow_keys *flow, int xmit_policy)
 {
 	hash ^= (__force u32)flow_get_u32_dst(flow) ^
 		(__force u32)flow_get_u32_src(flow);
 	hash ^= (hash >> 16);
 	hash ^= (hash >> 8);
+
 	/* discard lowest hash bit to deal with the common even ports pattern */
-	return hash >> 1;
+	if (xmit_policy == BOND_XMIT_POLICY_LAYER34 ||
+		xmit_policy == BOND_XMIT_POLICY_ENCAP34)
+		return hash >> 1;
+
+	return hash;
 }
 
 /* Generate hash based on xmit policy. If @skb is given it is used to linearize
@@ -3854,7 +3859,7 @@ static u32 __bond_xmit_hash(struct bonding *bond, struct sk_buff *skb, const voi
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
 
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, bond->params.xmit_policy);
 }
 
 /**
@@ -5012,7 +5017,7 @@ static u32 bond_sk_hash_l34(struct sock *sk)
 	/* L4 */
 	memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	/* L3 */
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, BOND_XMIT_POLICY_LAYER34);
 }
 
 static struct net_device *__bond_sk_get_lower_dev(struct bonding *bond,
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 9e006a25b636..8a8f392813d8 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1663,9 +1663,6 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
-
-		/* Configure the RMII clock as output: */
-		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv88e6xxx/port_hidden.c
index b49d05f0e117..7a9f9ff6dedf 100644
--- a/drivers/net/dsa/mv88e6xxx/port_hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
@@ -40,8 +40,9 @@ int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip)
 {
 	int bit = __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
 
-	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
-				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
+	return mv88e6xxx_port_wait_bit(chip,
+				       MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				       MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
 int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index bdd4e420f869..553f3de93957 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14158,10 +14158,6 @@ static int bnx2x_eeh_nic_unload(struct bnx2x *bp)
 
 	/* Stop Tx */
 	bnx2x_tx_disable(bp);
-	/* Delete all NAPI objects */
-	bnx2x_del_all_napi(bp);
-	if (CNIC_LOADED(bp))
-		bnx2x_del_all_napi_cnic(bp);
 	netdev_reset_tc(bp->dev);
 
 	del_timer_sync(&bp->timer);
@@ -14266,6 +14262,11 @@ static pci_ers_result_t bnx2x_io_slot_reset(struct pci_dev *pdev)
 		bnx2x_drain_tx_queues(bp);
 		bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
 		bnx2x_netif_stop(bp, 1);
+		bnx2x_del_all_napi(bp);
+
+		if (CNIC_LOADED(bp))
+			bnx2x_del_all_napi_cnic(bp);
+
 		bnx2x_free_irq(bp);
 
 		/* Report UNLOAD_DONE to MCP */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b4f99dd284e5..8bcc39b1575c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1991,6 +1991,11 @@ static struct sk_buff *bcmgenet_add_tsb(struct net_device *dev,
 	return skb;
 }
 
+static void bcmgenet_hide_tsb(struct sk_buff *skb)
+{
+	__skb_pull(skb, sizeof(struct status_64));
+}
+
 static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -2097,6 +2102,8 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	GENET_CB(skb)->last_cb = tx_cb_ptr;
+
+	bcmgenet_hide_tsb(skb);
 	skb_tx_timestamp(skb);
 
 	/* Decrement total BD count and advance our write pointer */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a3e87e10ee6b..67eb9b671244 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3726,7 +3726,7 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 					 ARRAY_SIZE(out_val));
 	if (ret) {
 		dev_dbg(&fep->pdev->dev, "no stop mode property\n");
-		return ret;
+		goto out;
 	}
 
 	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 16cbd146ad06..818a028703c6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5092,6 +5092,13 @@ static void hns3_state_init(struct hnae3_handle *handle)
 		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
 }
 
+static void hns3_state_uninit(struct hnae3_handle *handle)
+{
+	struct hns3_nic_priv *priv  = handle->priv;
+
+	clear_bit(HNS3_NIC_STATE_INITED, &priv->state);
+}
+
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
@@ -5209,7 +5216,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	return ret;
 
 out_reg_netdev_fail:
+	hns3_state_uninit(handle);
 	hns3_dbg_uninit(handle);
+	hns3_client_stop(handle);
 out_client_start:
 	hns3_free_rx_cpu_rmap(netdev);
 	hns3_nic_uninit_irq(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 65d78ee4d65a..4a5b11b6fed3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -93,6 +93,13 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	enum hclge_cmd_status status;
 	struct hclge_desc desc;
 
+	if (msg_len > HCLGE_MBX_MAX_MSG_SIZE) {
+		dev_err(&hdev->pdev->dev,
+			"msg data length(=%u) exceeds maximum(=%u)\n",
+			msg_len, HCLGE_MBX_MAX_MSG_SIZE);
+		return -EMSGSIZE;
+	}
+
 	resp_pf_to_vf = (struct hclge_mbx_pf_to_vf_cmd *)desc.data;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_PF_TO_VF, false);
@@ -175,7 +182,7 @@ static int hclge_get_ring_chain_from_mbx(
 	ring_num = req->msg.ring_num;
 
 	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
-		return -ENOMEM;
+		return -EINVAL;
 
 	for (i = 0; i < ring_num; i++) {
 		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
@@ -586,9 +593,9 @@ static int hclge_set_vf_mtu(struct hclge_vport *vport,
 	return hclge_set_vport_mtu(vport, mtu);
 }
 
-static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
-				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				     struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
+				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
@@ -598,17 +605,18 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	if (queue_id >= handle->kinfo.num_tqps) {
 		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
 			queue_id, mbx_req->mbx_src_vfid);
-		return;
+		return -EINVAL;
 	}
 
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
 	resp_msg->len = sizeof(qid_in_pf);
+	return 0;
 }
 
-static void hclge_get_rss_key(struct hclge_vport *vport,
-			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-			      struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_rss_key(struct hclge_vport *vport,
+			     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+			     struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_RSS_MBX_RESP_LEN	8
 	struct hclge_dev *hdev = vport->back;
@@ -624,13 +632,14 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 		dev_warn(&hdev->pdev->dev,
 			 "failed to get the rss hash key, the index(%u) invalid !\n",
 			 index);
-		return;
+		return -EINVAL;
 	}
 
 	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
 	resp_msg->len = HCLGE_RSS_MBX_RESP_LEN;
+	return 0;
 }
 
 static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
@@ -805,10 +814,10 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"VF fail(%d) to set mtu\n", ret);
 			break;
 		case HCLGE_MBX_GET_QID_IN_PF:
-			hclge_get_queue_id_in_pf(vport, req, &resp_msg);
+			ret = hclge_get_queue_id_in_pf(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_RSS_KEY:
-			hclge_get_rss_key(vport, req, &resp_msg);
+			ret = hclge_get_rss_key(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_MODE:
 			hclge_get_link_mode(vport, req);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c809e8fe648f..b262aa84b6a2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2961,13 +2961,8 @@ static void ibmvnic_get_ringparam(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
-		ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
-	} else {
-		ring->rx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-		ring->tx_max_pending = IBMVNIC_MAX_QUEUE_SZ;
-	}
+	ring->rx_max_pending = adapter->max_rx_add_entries_per_subcrq;
+	ring->tx_max_pending = adapter->max_tx_entries_per_subcrq;
 	ring->rx_mini_max_pending = 0;
 	ring->rx_jumbo_max_pending = 0;
 	ring->rx_pending = adapter->req_rx_add_entries_per_subcrq;
@@ -2980,23 +2975,21 @@ static int ibmvnic_set_ringparam(struct net_device *netdev,
 				 struct ethtool_ringparam *ring)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
+	if (ring->rx_pending > adapter->max_rx_add_entries_per_subcrq  ||
+	    ring->tx_pending > adapter->max_tx_entries_per_subcrq) {
+		netdev_err(netdev, "Invalid request.\n");
+		netdev_err(netdev, "Max tx buffers = %llu\n",
+			   adapter->max_rx_add_entries_per_subcrq);
+		netdev_err(netdev, "Max rx buffers = %llu\n",
+			   adapter->max_tx_entries_per_subcrq);
+		return -EINVAL;
+	}
+
 	adapter->desired.rx_entries = ring->rx_pending;
 	adapter->desired.tx_entries = ring->tx_pending;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_add_entries_per_subcrq != ring->rx_pending ||
-	     adapter->req_tx_entries_per_subcrq != ring->tx_pending))
-		netdev_info(netdev,
-			    "Could not match full ringsize request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    ring->rx_pending, ring->tx_pending,
-			    adapter->req_rx_add_entries_per_subcrq,
-			    adapter->req_tx_entries_per_subcrq);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_channels(struct net_device *netdev,
@@ -3004,14 +2997,8 @@ static void ibmvnic_get_channels(struct net_device *netdev,
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->priv_flags & IBMVNIC_USE_SERVER_MAXES) {
-		channels->max_rx = adapter->max_rx_queues;
-		channels->max_tx = adapter->max_tx_queues;
-	} else {
-		channels->max_rx = IBMVNIC_MAX_QUEUES;
-		channels->max_tx = IBMVNIC_MAX_QUEUES;
-	}
-
+	channels->max_rx = adapter->max_rx_queues;
+	channels->max_tx = adapter->max_tx_queues;
 	channels->max_other = 0;
 	channels->max_combined = 0;
 	channels->rx_count = adapter->req_rx_queues;
@@ -3024,22 +3011,11 @@ static int ibmvnic_set_channels(struct net_device *netdev,
 				struct ethtool_channels *channels)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
-	ret = 0;
 	adapter->desired.rx_queues = channels->rx_count;
 	adapter->desired.tx_queues = channels->tx_count;
 
-	ret = wait_for_reset(adapter);
-
-	if (!ret &&
-	    (adapter->req_rx_queues != channels->rx_count ||
-	     adapter->req_tx_queues != channels->tx_count))
-		netdev_info(netdev,
-			    "Could not match full channels request. Requested: RX %d, TX %d; Allowed: RX %llu, TX %llu\n",
-			    channels->rx_count, channels->tx_count,
-			    adapter->req_rx_queues, adapter->req_tx_queues);
-	return ret;
+	return wait_for_reset(adapter);
 }
 
 static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
@@ -3047,43 +3023,32 @@ static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 	int i;
 
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_stats);
-				i++, data += ETH_GSTRING_LEN)
-			memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
+	if (stringset != ETH_SS_STATS)
+		return;
 
-		for (i = 0; i < adapter->req_tx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < ARRAY_SIZE(ibmvnic_stats); i++, data += ETH_GSTRING_LEN)
+		memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
 
-			snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_tx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN,
-				 "tx%d_dropped_packets", i);
-			data += ETH_GSTRING_LEN;
-		}
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-		for (i = 0; i < adapter->req_rx_queues; i++) {
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
-			data += ETH_GSTRING_LEN;
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_dropped_packets", i);
+		data += ETH_GSTRING_LEN;
+	}
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
-			data += ETH_GSTRING_LEN;
+	for (i = 0; i < adapter->req_rx_queues; i++) {
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_packets", i);
+		data += ETH_GSTRING_LEN;
 
-			snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
-			data += ETH_GSTRING_LEN;
-		}
-		break;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_bytes", i);
+		data += ETH_GSTRING_LEN;
 
-	case ETH_SS_PRIV_FLAGS:
-		for (i = 0; i < ARRAY_SIZE(ibmvnic_priv_flags); i++)
-			strcpy(data + i * ETH_GSTRING_LEN,
-			       ibmvnic_priv_flags[i]);
-		break;
-	default:
-		return;
+		snprintf(data, ETH_GSTRING_LEN, "rx%d_interrupts", i);
+		data += ETH_GSTRING_LEN;
 	}
 }
 
@@ -3096,8 +3061,6 @@ static int ibmvnic_get_sset_count(struct net_device *dev, int sset)
 		return ARRAY_SIZE(ibmvnic_stats) +
 		       adapter->req_tx_queues * NUM_TX_STATS +
 		       adapter->req_rx_queues * NUM_RX_STATS;
-	case ETH_SS_PRIV_FLAGS:
-		return ARRAY_SIZE(ibmvnic_priv_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3150,26 +3113,6 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-static u32 ibmvnic_get_priv_flags(struct net_device *netdev)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-
-	return adapter->priv_flags;
-}
-
-static int ibmvnic_set_priv_flags(struct net_device *netdev, u32 flags)
-{
-	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	bool which_maxes = !!(flags & IBMVNIC_USE_SERVER_MAXES);
-
-	if (which_maxes)
-		adapter->priv_flags |= IBMVNIC_USE_SERVER_MAXES;
-	else
-		adapter->priv_flags &= ~IBMVNIC_USE_SERVER_MAXES;
-
-	return 0;
-}
-
 static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_drvinfo		= ibmvnic_get_drvinfo,
 	.get_msglevel		= ibmvnic_get_msglevel,
@@ -3183,8 +3126,6 @@ static const struct ethtool_ops ibmvnic_ethtool_ops = {
 	.get_sset_count         = ibmvnic_get_sset_count,
 	.get_ethtool_stats	= ibmvnic_get_ethtool_stats,
 	.get_link_ksettings	= ibmvnic_get_link_ksettings,
-	.get_priv_flags		= ibmvnic_get_priv_flags,
-	.set_priv_flags		= ibmvnic_set_priv_flags,
 };
 
 /* Routines for managing CRQs/sCRQs  */
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index ef395fd3b1e6..1a9ed9202654 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -43,11 +43,6 @@
 
 #define IBMVNIC_RESET_DELAY 100
 
-static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
-#define IBMVNIC_USE_SERVER_MAXES 0x1
-	"use-server-maxes"
-};
-
 struct ibmvnic_login_buffer {
 	__be32 len;
 	__be32 version;
@@ -885,7 +880,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_control_ip_offload_buffer ip_offload_ctrl;
 	dma_addr_t ip_offload_ctrl_tok;
 	u32 msg_enable;
-	u32 priv_flags;
 
 	/* Vital Product Data (VPD) */
 	struct ibmvnic_vpd *vpd;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index e596e1a9fc75..69d11ff7677d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -903,7 +903,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	/* Tx IPsec offload doesn't seem to work on this
 	 * device, so block these requests for now.
 	 */
-	if (!(sam->flags & XFRM_OFFLOAD_INBOUND)) {
+	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
+	if (sam->flags != XFRM_OFFLOAD_INBOUND) {
 		err = -EOPNOTSUPP;
 		goto err_out;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index ac9e6c7a33b5..6b447d8f0bd8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -65,8 +65,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	writew(SGMII_ADAPTER_DISABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (sgmii_adapter_base)
+		writew(SGMII_ADAPTER_DISABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -88,10 +89,11 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	if (phy_dev)
+	if (phy_dev && sgmii_adapter_base) {
+		writew(SGMII_ADAPTER_ENABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
+	}
 }
 
 static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *dev)
diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 7661dbb31162..50e4bea46d67 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1353,7 +1353,9 @@ static int rr_close(struct net_device *dev)
 
 	rrpriv->fw_running = 0;
 
+	spin_unlock_irqrestore(&rrpriv->lock, flags);
 	del_timer_sync(&rrpriv->timer);
+	spin_lock_irqsave(&rrpriv->lock, flags);
 
 	writel(0, &regs->TxPi);
 	writel(0, &regs->IpRxPi);
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bd310e8d5e43..df33637c5269 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -789,7 +789,7 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 
 	cssr1 = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_CSSR1);
 	if (cssr1 < 0)
-		return val;
+		return cssr1;
 
 	/* If the link settings are not resolved, mark the link down */
 	if (!(cssr1 & MV_PCS_CSSR1_RESOLVED)) {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4ad25a8b0870..73aba760e10c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -965,6 +965,24 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			 * xdp.data_meta were adjusted
 			 */
 			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
+
+			/* recalculate headroom if xdp.data or xdp_data_meta
+			 * were adjusted, note that offset should always point
+			 * to the start of the reserved bytes for virtio_net
+			 * header which are followed by xdp.data, that means
+			 * that offset is equal to the headroom (when buf is
+			 * starting at the beginning of the page, otherwise
+			 * there is a base offset inside the page) but it's used
+			 * with a different starting point (buf start) than
+			 * xdp.data (buf start + vnet hdr size). If xdp.data or
+			 * data_meta were adjusted by the xdp prog then the
+			 * headroom size has changed and so has the offset, we
+			 * can use data_hard_start, which points at buf start +
+			 * vnet hdr size, to calculate the new headroom and use
+			 * it later to compute buf start in page_to_skb()
+			 */
+			headroom = xdp.data - xdp.data_hard_start - metasize;
+
 			/* We can only create skb based on xdp_page. */
 			if (unlikely(xdp_page != page)) {
 				rcu_read_unlock();
@@ -972,7 +990,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				head_skb = page_to_skb(vi, rq, xdp_page, offset,
 						       len, PAGE_SIZE, false,
 						       metasize,
-						       VIRTIO_XDP_HEADROOM);
+						       headroom);
 				return head_skb;
 			}
 			break;
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a46067c38bf5..5eaef79c06e1 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
 #include <linux/suspend.h>
+#include <net/dst_metadata.h>
 #include <net/icmp.h>
 #include <net/rtnetlink.h>
 #include <net/ip_tunnels.h>
@@ -152,7 +153,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_peer;
 	}
 
-	mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
 	__skb_queue_head_init(&packets);
 	if (!skb_is_gso(skb)) {
diff --git a/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c b/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
index 5b471ab80fe2..54d65a6f0fcc 100644
--- a/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
+++ b/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
@@ -414,19 +414,19 @@ static int phy_g12a_usb3_pcie_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(priv->clk_ref);
 	if (ret)
-		goto err_disable_clk_ref;
+		return ret;
 
 	priv->reset = devm_reset_control_array_get_exclusive(dev);
-	if (IS_ERR(priv->reset))
-		return PTR_ERR(priv->reset);
+	if (IS_ERR(priv->reset)) {
+		ret = PTR_ERR(priv->reset);
+		goto err_disable_clk_ref;
+	}
 
 	priv->phy = devm_phy_create(dev, np, &phy_g12a_usb3_pcie_ops);
 	if (IS_ERR(priv->phy)) {
 		ret = PTR_ERR(priv->phy);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "failed to create PHY\n");
-
-		return ret;
+		dev_err_probe(dev, ret, "failed to create PHY\n");
+		goto err_disable_clk_ref;
 	}
 
 	phy_set_drvdata(priv->phy, priv);
@@ -434,8 +434,12 @@ static int phy_g12a_usb3_pcie_probe(struct platform_device *pdev)
 
 	phy_provider = devm_of_phy_provider_register(dev,
 						     phy_g12a_usb3_pcie_xlate);
+	if (IS_ERR(phy_provider)) {
+		ret = PTR_ERR(phy_provider);
+		goto err_disable_clk_ref;
+	}
 
-	return PTR_ERR_OR_ZERO(phy_provider);
+	return 0;
 
 err_disable_clk_ref:
 	clk_disable_unprepare(priv->clk_ref);
diff --git a/drivers/phy/motorola/phy-mapphone-mdm6600.c b/drivers/phy/motorola/phy-mapphone-mdm6600.c
index 5172971f4c36..3cd4d51c247c 100644
--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -629,7 +629,8 @@ static int phy_mdm6600_probe(struct platform_device *pdev)
 cleanup:
 	if (error < 0)
 		phy_mdm6600_device_power_off(ddata);
-
+	pm_runtime_disable(ddata->dev);
+	pm_runtime_dont_use_autosuspend(ddata->dev);
 	return error;
 }
 
diff --git a/drivers/phy/samsung/phy-exynos5250-sata.c b/drivers/phy/samsung/phy-exynos5250-sata.c
index 9ec234243f7c..595adba5fb8f 100644
--- a/drivers/phy/samsung/phy-exynos5250-sata.c
+++ b/drivers/phy/samsung/phy-exynos5250-sata.c
@@ -187,6 +187,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	sata_phy->client = of_find_i2c_device_by_node(node);
+	of_node_put(node);
 	if (!sata_phy->client)
 		return -EPROBE_DEFER;
 
@@ -195,20 +196,21 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 	sata_phy->phyclk = devm_clk_get(dev, "sata_phyctrl");
 	if (IS_ERR(sata_phy->phyclk)) {
 		dev_err(dev, "failed to get clk for PHY\n");
-		return PTR_ERR(sata_phy->phyclk);
+		ret = PTR_ERR(sata_phy->phyclk);
+		goto put_dev;
 	}
 
 	ret = clk_prepare_enable(sata_phy->phyclk);
 	if (ret < 0) {
 		dev_err(dev, "failed to enable source clk\n");
-		return ret;
+		goto put_dev;
 	}
 
 	sata_phy->phy = devm_phy_create(dev, NULL, &exynos_sata_phy_ops);
 	if (IS_ERR(sata_phy->phy)) {
-		clk_disable_unprepare(sata_phy->phyclk);
 		dev_err(dev, "failed to create PHY\n");
-		return PTR_ERR(sata_phy->phy);
+		ret = PTR_ERR(sata_phy->phy);
+		goto clk_disable;
 	}
 
 	phy_set_drvdata(sata_phy->phy, sata_phy);
@@ -216,11 +218,18 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 	phy_provider = devm_of_phy_provider_register(dev,
 					of_phy_simple_xlate);
 	if (IS_ERR(phy_provider)) {
-		clk_disable_unprepare(sata_phy->phyclk);
-		return PTR_ERR(phy_provider);
+		ret = PTR_ERR(phy_provider);
+		goto clk_disable;
 	}
 
 	return 0;
+
+clk_disable:
+	clk_disable_unprepare(sata_phy->phyclk);
+put_dev:
+	put_device(&sata_phy->client->dev);
+
+	return ret;
 }
 
 static const struct of_device_id exynos_sata_phy_of_match[] = {
diff --git a/drivers/phy/ti/phy-am654-serdes.c b/drivers/phy/ti/phy-am654-serdes.c
index 2ff56ce77b30..21c0088f5ca9 100644
--- a/drivers/phy/ti/phy-am654-serdes.c
+++ b/drivers/phy/ti/phy-am654-serdes.c
@@ -838,7 +838,7 @@ static int serdes_am654_probe(struct platform_device *pdev)
 
 clk_err:
 	of_clk_del_provider(node);
-
+	pm_runtime_disable(dev);
 	return ret;
 }
 
diff --git a/drivers/phy/ti/phy-omap-usb2.c b/drivers/phy/ti/phy-omap-usb2.c
index ebceb1520ce8..ca8532a3f193 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -215,7 +215,7 @@ static int omap_usb2_enable_clocks(struct omap_usb *phy)
 	return 0;
 
 err1:
-	clk_disable(phy->wkupclk);
+	clk_disable_unprepare(phy->wkupclk);
 
 err0:
 	return ret;
diff --git a/drivers/pinctrl/mediatek/Kconfig b/drivers/pinctrl/mediatek/Kconfig
index 7040a7a7bd5d..246b0e951e1c 100644
--- a/drivers/pinctrl/mediatek/Kconfig
+++ b/drivers/pinctrl/mediatek/Kconfig
@@ -30,6 +30,7 @@ config PINCTRL_MTK_MOORE
 	select GENERIC_PINMUX_FUNCTIONS
 	select GPIOLIB
 	select OF_GPIO
+	select EINT_MTK
 	select PINCTRL_MTK_V2
 
 config PINCTRL_MTK_PARIS
diff --git a/drivers/pinctrl/pinctrl-pistachio.c b/drivers/pinctrl/pinctrl-pistachio.c
index 8d271c6b0ca4..5de691c630b4 100644
--- a/drivers/pinctrl/pinctrl-pistachio.c
+++ b/drivers/pinctrl/pinctrl-pistachio.c
@@ -1374,10 +1374,10 @@ static int pistachio_gpio_register(struct pistachio_pinctrl *pctl)
 		}
 
 		irq = irq_of_parse_and_map(child, 0);
-		if (irq < 0) {
-			dev_err(pctl->dev, "No IRQ for bank %u: %d\n", i, irq);
+		if (!irq) {
+			dev_err(pctl->dev, "No IRQ for bank %u\n", i);
 			of_node_put(child);
-			ret = irq;
+			ret = -EINVAL;
 			goto err;
 		}
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 923ff21a44c0..543a4991cf70 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -455,95 +455,110 @@ static  struct rockchip_mux_recalced_data rk3128_mux_recalced_data[] = {
 
 static struct rockchip_mux_recalced_data rk3308_mux_recalced_data[] = {
 	{
+		/* gpio1b6_sel */
 		.num = 1,
 		.pin = 14,
 		.reg = 0x28,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio1b7_sel */
 		.num = 1,
 		.pin = 15,
 		.reg = 0x2c,
 		.bit = 0,
 		.mask = 0x3
 	}, {
+		/* gpio1c2_sel */
 		.num = 1,
 		.pin = 18,
 		.reg = 0x30,
 		.bit = 4,
 		.mask = 0xf
 	}, {
+		/* gpio1c3_sel */
 		.num = 1,
 		.pin = 19,
 		.reg = 0x30,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio1c4_sel */
 		.num = 1,
 		.pin = 20,
 		.reg = 0x30,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio1c5_sel */
 		.num = 1,
 		.pin = 21,
 		.reg = 0x34,
 		.bit = 0,
 		.mask = 0xf
 	}, {
+		/* gpio1c6_sel */
 		.num = 1,
 		.pin = 22,
 		.reg = 0x34,
 		.bit = 4,
 		.mask = 0xf
 	}, {
+		/* gpio1c7_sel */
 		.num = 1,
 		.pin = 23,
 		.reg = 0x34,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio3b4_sel */
 		.num = 3,
 		.pin = 12,
 		.reg = 0x68,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio3b5_sel */
 		.num = 3,
 		.pin = 13,
 		.reg = 0x68,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio2a2_sel */
 		.num = 2,
 		.pin = 2,
-		.reg = 0x608,
-		.bit = 0,
-		.mask = 0x7
+		.reg = 0x40,
+		.bit = 4,
+		.mask = 0x3
 	}, {
+		/* gpio2a3_sel */
 		.num = 2,
 		.pin = 3,
-		.reg = 0x608,
-		.bit = 4,
-		.mask = 0x7
+		.reg = 0x40,
+		.bit = 6,
+		.mask = 0x3
 	}, {
+		/* gpio2c0_sel */
 		.num = 2,
 		.pin = 16,
-		.reg = 0x610,
-		.bit = 8,
-		.mask = 0x7
+		.reg = 0x50,
+		.bit = 0,
+		.mask = 0x3
 	}, {
+		/* gpio3b2_sel */
 		.num = 3,
 		.pin = 10,
-		.reg = 0x610,
-		.bit = 0,
-		.mask = 0x7
+		.reg = 0x68,
+		.bit = 4,
+		.mask = 0x3
 	}, {
+		/* gpio3b3_sel */
 		.num = 3,
 		.pin = 11,
-		.reg = 0x610,
-		.bit = 4,
-		.mask = 0x7
+		.reg = 0x68,
+		.bit = 6,
+		.mask = 0x3
 	},
 };
 
diff --git a/drivers/pinctrl/samsung/Kconfig b/drivers/pinctrl/samsung/Kconfig
index dfd805e76862..7b0576f71376 100644
--- a/drivers/pinctrl/samsung/Kconfig
+++ b/drivers/pinctrl/samsung/Kconfig
@@ -4,14 +4,13 @@
 #
 config PINCTRL_SAMSUNG
 	bool
-	depends on OF_GPIO
+	select GPIOLIB
 	select PINMUX
 	select PINCONF
 
 config PINCTRL_EXYNOS
 	bool "Pinctrl common driver part for Samsung Exynos SoCs"
-	depends on OF_GPIO
-	depends on ARCH_EXYNOS || ARCH_S5PV210 || COMPILE_TEST
+	depends on ARCH_EXYNOS || ARCH_S5PV210 || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG
 	select PINCTRL_EXYNOS_ARM if ARM && (ARCH_EXYNOS || ARCH_S5PV210)
 	select PINCTRL_EXYNOS_ARM64 if ARM64 && ARCH_EXYNOS
@@ -26,12 +25,10 @@ config PINCTRL_EXYNOS_ARM64
 
 config PINCTRL_S3C24XX
 	bool "Samsung S3C24XX SoC pinctrl driver"
-	depends on OF_GPIO
-	depends on ARCH_S3C24XX || COMPILE_TEST
+	depends on ARCH_S3C24XX || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG
 
 config PINCTRL_S3C64XX
 	bool "Samsung S3C64XX SoC pinctrl driver"
-	depends on OF_GPIO
-	depends on ARCH_S3C64XX || COMPILE_TEST
+	depends on ARCH_S3C64XX || (COMPILE_TEST && OF)
 	select PINCTRL_SAMSUNG
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 8934b4878fa8..97a4fb5a9328 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -225,6 +225,13 @@ static void stm32_gpio_free(struct gpio_chip *chip, unsigned offset)
 	pinctrl_gpio_free(chip->base + offset);
 }
 
+static int stm32_gpio_get_noclk(struct gpio_chip *chip, unsigned int offset)
+{
+	struct stm32_gpio_bank *bank = gpiochip_get_data(chip);
+
+	return !!(readl_relaxed(bank->base + STM32_GPIO_IDR) & BIT(offset));
+}
+
 static int stm32_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct stm32_gpio_bank *bank = gpiochip_get_data(chip);
@@ -232,7 +239,7 @@ static int stm32_gpio_get(struct gpio_chip *chip, unsigned offset)
 
 	clk_enable(bank->clk);
 
-	ret = !!(readl_relaxed(bank->base + STM32_GPIO_IDR) & BIT(offset));
+	ret = stm32_gpio_get_noclk(chip, offset);
 
 	clk_disable(bank->clk);
 
@@ -311,8 +318,12 @@ static void stm32_gpio_irq_trigger(struct irq_data *d)
 	struct stm32_gpio_bank *bank = d->domain->host_data;
 	int level;
 
+	/* Do not access the GPIO if this is not LEVEL triggered IRQ. */
+	if (!(bank->irq_type[d->hwirq] & IRQ_TYPE_LEVEL_MASK))
+		return;
+
 	/* If level interrupt type then retrig */
-	level = stm32_gpio_get(&bank->gpio_chip, d->hwirq);
+	level = stm32_gpio_get_noclk(&bank->gpio_chip, d->hwirq);
 	if ((level == 0 && bank->irq_type[d->hwirq] == IRQ_TYPE_LEVEL_LOW) ||
 	    (level == 1 && bank->irq_type[d->hwirq] == IRQ_TYPE_LEVEL_HIGH))
 		irq_chip_retrigger_hierarchy(d);
@@ -354,6 +365,7 @@ static int stm32_gpio_irq_request_resources(struct irq_data *irq_data)
 {
 	struct stm32_gpio_bank *bank = irq_data->domain->host_data;
 	struct stm32_pinctrl *pctl = dev_get_drvdata(bank->gpio_chip.parent);
+	unsigned long flags;
 	int ret;
 
 	ret = stm32_gpio_direction_input(&bank->gpio_chip, irq_data->hwirq);
@@ -367,6 +379,10 @@ static int stm32_gpio_irq_request_resources(struct irq_data *irq_data)
 		return ret;
 	}
 
+	flags = irqd_get_trigger_type(irq_data);
+	if (flags & IRQ_TYPE_LEVEL_MASK)
+		clk_enable(bank->clk);
+
 	return 0;
 }
 
@@ -374,6 +390,9 @@ static void stm32_gpio_irq_release_resources(struct irq_data *irq_data)
 {
 	struct stm32_gpio_bank *bank = irq_data->domain->host_data;
 
+	if (bank->irq_type[irq_data->hwirq] & IRQ_TYPE_LEVEL_MASK)
+		clk_disable(bank->clk);
+
 	gpiochip_unlock_as_irq(&bank->gpio_chip, irq_data->hwirq);
 }
 
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index c8cdc614a357..6aa5fe973613 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -67,7 +67,7 @@ static int evaluate_odvp(struct int3400_thermal_priv *priv);
 struct odvp_attr {
 	int odvp;
 	struct int3400_thermal_priv *priv;
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 };
 
 static ssize_t data_vault_read(struct file *file, struct kobject *kobj,
@@ -272,7 +272,7 @@ static int int3400_thermal_run_osc(acpi_handle handle,
 	return result;
 }
 
-static ssize_t odvp_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t odvp_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct odvp_attr *odvp_attr;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8643b143c408..2294d5b633b5 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -73,6 +73,8 @@ module_param(debug, int, 0600);
  */
 #define MAX_MRU 1500
 #define MAX_MTU 1500
+/* SOF, ADDR, CTRL, LEN1, LEN2, ..., FCS, EOF */
+#define PROT_OVERHEAD 7
 #define	GSM_NET_TX_TIMEOUT (HZ*10)
 
 /*
@@ -231,6 +233,7 @@ struct gsm_mux {
 	int initiator;			/* Did we initiate connection */
 	bool dead;			/* Has the mux been shut down */
 	struct gsm_dlci *dlci[NUM_DLCI];
+	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
 	spinlock_t tx_lock;
@@ -820,7 +823,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 			break;
 		case 2:	/* Unstructed with modem bits.
 		Always one byte as we never send inline break data */
-			*dp++ = gsm_encode_modem(dlci);
+			*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
 			break;
 		}
 		WARN_ON(kfifo_out_locked(&dlci->fifo, dp , len, &dlci->lock) != len);
@@ -1081,7 +1084,6 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
-	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	int slen;
@@ -1111,17 +1113,8 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 			return;
 	}
 	len--;
-	if (len > 0) {
-		while (gsm_read_ea(&brk, *dp++) == 0) {
-			len--;
-			if (len == 0)
-				return;
-		}
-		modem <<= 7;
-		modem |= (brk & 0x7f);
-	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, slen);
+	gsm_process_modem(tty, dlci, modem, slen - len);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1300,11 +1293,12 @@ static void gsm_control_response(struct gsm_mux *gsm, unsigned int command,
 
 static void gsm_control_transmit(struct gsm_mux *gsm, struct gsm_control *ctrl)
 {
-	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1, gsm->ftype);
+	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 2, gsm->ftype);
 	if (msg == NULL)
 		return;
-	msg->data[0] = (ctrl->cmd << 1) | 2 | EA;	/* command */
-	memcpy(msg->data + 1, ctrl->data, ctrl->len);
+	msg->data[0] = (ctrl->cmd << 1) | CR | EA;	/* command */
+	msg->data[1] = (ctrl->len << 1) | EA;
+	memcpy(msg->data + 2, ctrl->data, ctrl->len);
 	gsm_data_queue(gsm->dlci[0], msg);
 }
 
@@ -1327,7 +1321,6 @@ static void gsm_control_retransmit(struct timer_list *t)
 	spin_lock_irqsave(&gsm->control_lock, flags);
 	ctrl = gsm->pending_cmd;
 	if (ctrl) {
-		gsm->cretries--;
 		if (gsm->cretries == 0) {
 			gsm->pending_cmd = NULL;
 			ctrl->error = -ETIMEDOUT;
@@ -1336,6 +1329,7 @@ static void gsm_control_retransmit(struct timer_list *t)
 			wake_up(&gsm->event);
 			return;
 		}
+		gsm->cretries--;
 		gsm_control_transmit(gsm, ctrl);
 		mod_timer(&gsm->t2_timer, jiffies + gsm->t2 * HZ / 100);
 	}
@@ -1376,7 +1370,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 
 	/* If DLCI0 is in ADM mode skip retries, it won't respond */
 	if (gsm->dlci[0]->mode == DLCI_MODE_ADM)
-		gsm->cretries = 1;
+		gsm->cretries = 0;
 	else
 		gsm->cretries = gsm->n2;
 
@@ -1424,13 +1418,17 @@ static int gsm_control_wait(struct gsm_mux *gsm, struct gsm_control *control)
 
 static void gsm_dlci_close(struct gsm_dlci *dlci)
 {
+	unsigned long flags;
+
 	del_timer(&dlci->t1);
 	if (debug & 8)
 		pr_debug("DLCI %d goes closed.\n", dlci->addr);
 	dlci->state = DLCI_CLOSED;
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
+		spin_lock_irqsave(&dlci->lock, flags);
 		kfifo_reset(&dlci->fifo);
+		spin_unlock_irqrestore(&dlci->lock, flags);
 		/* Ensure that gsmtty_open() can return. */
 		tty_port_set_initialized(&dlci->port, 0);
 		wake_up_interruptible(&dlci->port.open_wait);
@@ -1593,6 +1591,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 		tty = tty_port_tty_get(port);
 		if (tty) {
 			gsm_process_modem(tty, dlci, modem, slen);
+			tty_wakeup(tty);
 			tty_kref_put(tty);
 		}
 		fallthrough;
@@ -1818,7 +1817,6 @@ static void gsm_queue(struct gsm_mux *gsm)
 		gsm_response(gsm, address, UA);
 		gsm_dlci_close(dlci);
 		break;
-	case UA:
 	case UA|PF:
 		if (cr == 0 || dlci == NULL)
 			break;
@@ -1962,6 +1960,16 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 
 static void gsm1_receive(struct gsm_mux *gsm, unsigned char c)
 {
+	/* handle XON/XOFF */
+	if ((c & ISO_IEC_646_MASK) == XON) {
+		gsm->constipated = true;
+		return;
+	} else if ((c & ISO_IEC_646_MASK) == XOFF) {
+		gsm->constipated = false;
+		/* Kick the link in case it is idling */
+		gsm_data_kick(gsm, NULL);
+		return;
+	}
 	if (c == GSM1_SOF) {
 		/* EOF is only valid in frame if we have got to the data state
 		   and received at least one byte (the FCS) */
@@ -1976,7 +1984,8 @@ static void gsm1_receive(struct gsm_mux *gsm, unsigned char c)
 		}
 		/* Any partial frame was a runt so go back to start */
 		if (gsm->state != GSM_START) {
-			gsm->malformed++;
+			if (gsm->state != GSM_SEARCH)
+				gsm->malformed++;
 			gsm->state = GSM_START;
 		}
 		/* A SOF in GSM_START means we are still reading idling or
@@ -2048,74 +2057,43 @@ static void gsm_error(struct gsm_mux *gsm,
 	gsm->io_error++;
 }
 
-static int gsm_disconnect(struct gsm_mux *gsm)
-{
-	struct gsm_dlci *dlci = gsm->dlci[0];
-	struct gsm_control *gc;
-
-	if (!dlci)
-		return 0;
-
-	/* In theory disconnecting DLCI 0 is sufficient but for some
-	   modems this is apparently not the case. */
-	gc = gsm_control_send(gsm, CMD_CLD, NULL, 0);
-	if (gc)
-		gsm_control_wait(gsm, gc);
-
-	del_timer_sync(&gsm->t2_timer);
-	/* Now we are sure T2 has stopped */
-
-	gsm_dlci_begin_close(dlci);
-	wait_event_interruptible(gsm->event,
-				dlci->state == DLCI_CLOSED);
-
-	if (signal_pending(current))
-		return -EINTR;
-
-	return 0;
-}
-
 /**
  *	gsm_cleanup_mux		-	generic GSM protocol cleanup
  *	@gsm: our mux
+ *	@disc: disconnect link?
  *
  *	Clean up the bits of the mux which are the same for all framing
  *	protocols. Remove the mux from the mux table, stop all the timers
  *	and then shut down each device hanging up the channels as we go.
  */
 
-static void gsm_cleanup_mux(struct gsm_mux *gsm)
+static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 {
 	int i;
 	struct gsm_dlci *dlci = gsm->dlci[0];
 	struct gsm_msg *txq, *ntxq;
 
 	gsm->dead = true;
+	mutex_lock(&gsm->mutex);
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == gsm) {
-			gsm_mux[i] = NULL;
-			break;
+	if (dlci) {
+		if (disc && dlci->state != DLCI_CLOSED) {
+			gsm_dlci_begin_close(dlci);
+			wait_event(gsm->event, dlci->state == DLCI_CLOSED);
 		}
+		dlci->dead = true;
 	}
-	spin_unlock(&gsm_mux_lock);
-	/* open failed before registering => nothing to do */
-	if (i == MAX_MUX)
-		return;
 
+	/* Finish outstanding timers, making sure they are done */
 	del_timer_sync(&gsm->t2_timer);
-	/* Now we are sure T2 has stopped */
-	if (dlci)
-		dlci->dead = true;
 
-	/* Free up any link layer users */
-	mutex_lock(&gsm->mutex);
-	for (i = 0; i < NUM_DLCI; i++)
+	/* Free up any link layer users and finally the control channel */
+	for (i = NUM_DLCI - 1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
+	tty_ldisc_flush(gsm->tty);
 	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
 		kfree(txq);
 	INIT_LIST_HEAD(&gsm->tx_list);
@@ -2133,7 +2111,6 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm)
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
-	int i = 0;
 
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
@@ -2145,18 +2122,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	else
 		gsm->receive = gsm1_receive;
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == NULL) {
-			gsm->num = i;
-			gsm_mux[i] = gsm;
-			break;
-		}
-	}
-	spin_unlock(&gsm_mux_lock);
-	if (i == MAX_MUX)
-		return -EBUSY;
-
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
 		return -ENOMEM;
@@ -2172,6 +2137,15 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
  */
 static void gsm_free_mux(struct gsm_mux *gsm)
 {
+	int i;
+
+	for (i = 0; i < MAX_MUX; i++) {
+		if (gsm == gsm_mux[i]) {
+			gsm_mux[i] = NULL;
+			break;
+		}
+	}
+	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
 	kfree(gsm);
@@ -2191,12 +2165,20 @@ static void gsm_free_muxr(struct kref *ref)
 
 static inline void mux_get(struct gsm_mux *gsm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsm_mux_lock, flags);
 	kref_get(&gsm->ref);
+	spin_unlock_irqrestore(&gsm_mux_lock, flags);
 }
 
 static inline void mux_put(struct gsm_mux *gsm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsm_mux_lock, flags);
 	kref_put(&gsm->ref, gsm_free_muxr);
+	spin_unlock_irqrestore(&gsm_mux_lock, flags);
 }
 
 static inline unsigned int mux_num_to_base(struct gsm_mux *gsm)
@@ -2217,6 +2199,7 @@ static inline unsigned int mux_line_to_num(unsigned int line)
 
 static struct gsm_mux *gsm_alloc_mux(void)
 {
+	int i;
 	struct gsm_mux *gsm = kzalloc(sizeof(struct gsm_mux), GFP_KERNEL);
 	if (gsm == NULL)
 		return NULL;
@@ -2225,7 +2208,7 @@ static struct gsm_mux *gsm_alloc_mux(void)
 		kfree(gsm);
 		return NULL;
 	}
-	gsm->txframe = kmalloc(2 * MAX_MRU + 2, GFP_KERNEL);
+	gsm->txframe = kmalloc(2 * (MAX_MTU + PROT_OVERHEAD - 1), GFP_KERNEL);
 	if (gsm->txframe == NULL) {
 		kfree(gsm->buf);
 		kfree(gsm);
@@ -2246,6 +2229,26 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	gsm->mtu = 64;
 	gsm->dead = true;	/* Avoid early tty opens */
 
+	/* Store the instance to the mux array or abort if no space is
+	 * available.
+	 */
+	spin_lock(&gsm_mux_lock);
+	for (i = 0; i < MAX_MUX; i++) {
+		if (!gsm_mux[i]) {
+			gsm_mux[i] = gsm;
+			gsm->num = i;
+			break;
+		}
+	}
+	spin_unlock(&gsm_mux_lock);
+	if (i == MAX_MUX) {
+		mutex_destroy(&gsm->mutex);
+		kfree(gsm->txframe);
+		kfree(gsm->buf);
+		kfree(gsm);
+		return NULL;
+	}
+
 	return gsm;
 }
 
@@ -2281,7 +2284,7 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 	/* Check the MRU/MTU range looks sane */
 	if (c->mru > MAX_MRU || c->mtu > MAX_MTU || c->mru < 8 || c->mtu < 8)
 		return -EINVAL;
-	if (c->n2 < 3)
+	if (c->n2 > 255)
 		return -EINVAL;
 	if (c->encapsulation > 1)	/* Basic, advanced, no I */
 		return -EINVAL;
@@ -2312,19 +2315,11 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 
 	/*
 	 * Close down what is needed, restart and initiate the new
-	 * configuration
+	 * configuration. On the first time there is no DLCI[0]
+	 * and closing or cleaning up is not necessary.
 	 */
-
-	if (need_close || need_restart) {
-		int ret;
-
-		ret = gsm_disconnect(gsm);
-
-		if (ret)
-			return ret;
-	}
-	if (need_restart)
-		gsm_cleanup_mux(gsm);
+	if (need_close || need_restart)
+		gsm_cleanup_mux(gsm, true);
 
 	gsm->initiator = c->initiator;
 	gsm->mru = c->mru;
@@ -2393,6 +2388,9 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	int ret, i;
 
 	gsm->tty = tty_kref_get(tty);
+	/* Turn off tty XON/XOFF handling to handle it explicitly. */
+	gsm->old_c_iflag = tty->termios.c_iflag;
+	tty->termios.c_iflag &= (IXON | IXOFF);
 	ret =  gsm_activate_mux(gsm);
 	if (ret != 0)
 		tty_kref_put(gsm->tty);
@@ -2433,7 +2431,8 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	WARN_ON(tty != gsm->tty);
 	for (i = 1; i < NUM_DLCI; i++)
 		tty_unregister_device(gsm_tty_driver, base + i);
-	gsm_cleanup_mux(gsm);
+	/* Restore tty XON/XOFF handling. */
+	gsm->tty->termios.c_iflag = gsm->old_c_iflag;
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }
@@ -2498,6 +2497,12 @@ static void gsmld_close(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
 
+	/* The ldisc locks and closes the port before calling our close. This
+	 * means we have no way to do a proper disconnect. We will not bother
+	 * to do one.
+	 */
+	gsm_cleanup_mux(gsm, false);
+
 	gsmld_detach_gsm(tty, gsm);
 
 	gsmld_flush_buffer(tty);
@@ -2536,7 +2541,7 @@ static int gsmld_open(struct tty_struct *tty)
 
 	ret = gsmld_attach_gsm(tty, gsm);
 	if (ret != 0) {
-		gsm_cleanup_mux(gsm);
+		gsm_cleanup_mux(gsm, false);
 		mux_put(gsm);
 	}
 	return ret;
@@ -2895,19 +2900,19 @@ static struct tty_ldisc_ops tty_ldisc_packet = {
 
 static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
 {
-	u8 modembits[5];
+	u8 modembits[3];
 	struct gsm_control *ctrl;
 	int len = 2;
 
-	if (brk)
+	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
+	if (!brk) {
+		modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	} else {
+		modembits[1] = gsm_encode_modem(dlci) << 1;
+		modembits[2] = (brk << 4) | 2 | EA; /* Length, Break, EA */
 		len++;
-
-	modembits[0] = len << 1 | EA;		/* Data bytes */
-	modembits[1] = dlci->addr << 2 | 3;	/* DLCI, EA, 1 */
-	modembits[2] = gsm_encode_modem(dlci) << 1 | EA;
-	if (brk)
-		modembits[3] = brk << 4 | 2 | EA;	/* Valid, EA */
-	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len + 1);
+	}
+	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len);
 	if (ctrl == NULL)
 		return -ENOMEM;
 	return gsm_control_wait(dlci->gsm, ctrl);
@@ -3092,13 +3097,17 @@ static unsigned int gsmtty_chars_in_buffer(struct tty_struct *tty)
 static void gsmtty_flush_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	unsigned long flags;
+
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	/* Caution needed: If we implement reliable transport classes
 	   then the data being transmitted can't simply be junked once
 	   it has first hit the stack. Until then we can just blow it
 	   away */
+	spin_lock_irqsave(&dlci->lock, flags);
 	kfifo_reset(&dlci->fifo);
+	spin_unlock_irqrestore(&dlci->lock, flags);
 	/* Need to unhook this DLCI from the transmit queue logic */
 }
 
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 114a49da564a..e7b9805903f4 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2940,7 +2940,7 @@ enum pci_board_num_t {
 	pbn_panacom2,
 	pbn_panacom4,
 	pbn_plx_romulus,
-	pbn_endrun_2_4000000,
+	pbn_endrun_2_3906250,
 	pbn_oxsemi,
 	pbn_oxsemi_1_3906250,
 	pbn_oxsemi_2_3906250,
@@ -3472,10 +3472,10 @@ static struct pciserial_board pci_boards[] = {
 	* signal now many ports are available
 	* 2 port 952 Uart support
 	*/
-	[pbn_endrun_2_4000000] = {
+	[pbn_endrun_2_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 2,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
@@ -4418,7 +4418,7 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	*/
 	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_endrun_2_4000000 },
+		pbn_endrun_2_3906250 },
 	/*
 	 * Quatech cards. These actually have configurable clocks but for
 	 * now we just use the default.
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 723ec0806799..2285ef947755 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -3340,7 +3340,7 @@ static void serial8250_console_restore(struct uart_8250_port *up)
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
-	serial8250_out_MCR(up, UART_MCR_DTR | UART_MCR_RTS);
+	serial8250_out_MCR(up, up->mcr | UART_MCR_DTR | UART_MCR_RTS);
 }
 
 /*
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index da54f827c5ef..3d40306971b8 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1288,13 +1288,18 @@ static inline bool pl011_dma_rx_running(struct uart_amba_port *uap)
 
 static void pl011_rs485_tx_stop(struct uart_amba_port *uap)
 {
+	/*
+	 * To be on the safe side only time out after twice as many iterations
+	 * as fifo size.
+	 */
+	const int MAX_TX_DRAIN_ITERS = uap->port.fifosize * 2;
 	struct uart_port *port = &uap->port;
 	int i = 0;
 	u32 cr;
 
 	/* Wait until hardware tx queue is empty */
 	while (!pl011_tx_empty(port)) {
-		if (i == port->fifosize) {
+		if (i > MAX_TX_DRAIN_ITERS) {
 			dev_warn(port->dev,
 				 "timeout while draining hardware tx queue\n");
 			break;
@@ -2099,7 +2104,7 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * with the given baud rate. We use this as the poll interval when we
 	 * wait for the tx queue to empty.
 	 */
-	uap->rs485_tx_drain_interval = (bits * 1000 * 1000) / baud;
+	uap->rs485_tx_drain_interval = DIV_ROUND_UP(bits * 1000 * 1000, baud);
 
 	pl011_setup_status_masks(port, termios);
 
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 7820049aba5a..b7ef075a4005 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1438,7 +1438,7 @@ static int imx_uart_startup(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4) & ~(UCR4_OREN | UCR4_INVR);
-	if (!sport->dma_is_enabled)
+	if (!dma_is_inited)
 		ucr4 |= UCR4_OREN;
 	if (sport->inverted_rx)
 		ucr4 |= UCR4_INVR;
diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index f9af7ebe003d..d6d515d598dc 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2684,6 +2684,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	struct usb_request *request;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *trb = NULL;
+	struct cdns3_trb trb_tmp;
 	int ret;
 	int val;
 
@@ -2693,8 +2694,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	if (request) {
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
-		if (trb)
+		if (trb) {
+			trb_tmp = *trb;
 			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+		}
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2709,7 +2712,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+			*trb = trb_tmp;
 
 		cdns3_rearm_transfer(priv_ep, 1);
 	}
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index fa66e6e58792..656ba91c3283 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1197,12 +1197,16 @@ static int do_proc_control(struct usb_dev_state *ps,
 
 		usb_unlock_device(dev);
 		i = usbfs_start_wait_urb(urb, tmo, &actlen);
+
+		/* Linger a bit, prior to the next control message. */
+		if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
+			msleep(200);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, actlen, i, COMPLETE, tbuf, actlen);
 		if (!i && actlen) {
 			if (copy_to_user(ctrl->data, tbuf, actlen)) {
 				ret = -EFAULT;
-				goto recv_fault;
+				goto done;
 			}
 		}
 	} else {
@@ -1219,6 +1223,10 @@ static int do_proc_control(struct usb_dev_state *ps,
 
 		usb_unlock_device(dev);
 		i = usbfs_start_wait_urb(urb, tmo, &actlen);
+
+		/* Linger a bit, prior to the next control message. */
+		if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
+			msleep(200);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, actlen, i, COMPLETE, NULL, 0);
 	}
@@ -1230,10 +1238,6 @@ static int do_proc_control(struct usb_dev_state *ps,
 	}
 	ret = (i < 0 ? i : actlen);
 
- recv_fault:
-	/* Linger a bit, prior to the next control message. */
-	if (dev->quirks & USB_QUIRK_DELAY_CTRL_MSG)
-		msleep(200);
  done:
 	kfree(dr);
 	usb_free_urb(urb);
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index d3c14b5ed4a1..97b44a68668a 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -404,6 +404,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Realtek Semiconductor Corp. Mass Storage Device (Multicard Reader)*/
+	{ USB_DEVICE(0x0bda, 0x0151), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Realtek hub in Dell WD19 (Type-C) */
 	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
 
@@ -507,6 +510,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VCOM device */
+	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 357b7805896e..5cb1350ec66d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -275,7 +275,8 @@ static int dwc3_core_soft_reset(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
-	dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+	reg &= ~DWC3_DCTL_RUN_STOP;
+	dwc3_gadget_dctl_write_safe(dwc, reg);
 
 	/*
 	 * For DWC_usb31 controller 1.90a and later, the DCTL.CSFRST bit
@@ -1268,10 +1269,10 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 	u8			lpm_nyet_threshold;
 	u8			tx_de_emphasis;
 	u8			hird_threshold;
-	u8			rx_thr_num_pkt_prd;
-	u8			rx_max_burst_prd;
-	u8			tx_thr_num_pkt_prd;
-	u8			tx_max_burst_prd;
+	u8			rx_thr_num_pkt_prd = 0;
+	u8			rx_max_burst_prd = 0;
+	u8			tx_thr_num_pkt_prd = 0;
+	u8			tx_max_burst_prd = 0;
 	u8			tx_fifo_resize_max_num;
 	const char		*usb_psy_name;
 	int			ret;
diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
index d7f76835137f..f148b0370f82 100644
--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -571,16 +571,15 @@ int dwc3_drd_init(struct dwc3 *dwc)
 {
 	int ret, irq;
 
+	if (ROLE_SWITCH &&
+	    device_property_read_bool(dwc->dev, "usb-role-switch"))
+		return dwc3_setup_role_switch(dwc);
+
 	dwc->edev = dwc3_get_extcon(dwc);
 	if (IS_ERR(dwc->edev))
 		return PTR_ERR(dwc->edev);
 
-	if (ROLE_SWITCH &&
-	    device_property_read_bool(dwc->dev, "usb-role-switch")) {
-		ret = dwc3_setup_role_switch(dwc);
-		if (ret < 0)
-			return ret;
-	} else if (dwc->edev) {
+	if (dwc->edev) {
 		dwc->edev_nb.notifier_call = dwc3_drd_notifier;
 		ret = extcon_register_notifier(dwc->edev, EXTCON_USB_HOST,
 					       &dwc->edev_nb);
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 4d9608cc55f7..f08b2178fd32 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -44,6 +44,8 @@
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
+#define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
+#define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
@@ -421,6 +423,12 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 00cf8ebcb338..c32f3116d1a0 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3199,6 +3199,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event,
 		struct dwc3_request *req, int status)
 {
+	int request_status;
 	int ret;
 
 	if (req->request.num_mapped_sgs)
@@ -3219,7 +3220,35 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		req->needs_extra_trb = false;
 	}
 
-	dwc3_gadget_giveback(dep, req, status);
+	/*
+	 * The event status only reflects the status of the TRB with IOC set.
+	 * For the requests that don't set interrupt on completion, the driver
+	 * needs to check and return the status of the completed TRBs associated
+	 * with the request. Use the status of the last TRB of the request.
+	 */
+	if (req->request.no_interrupt) {
+		struct dwc3_trb *trb;
+
+		trb = dwc3_ep_prev_trb(dep, dep->trb_dequeue);
+		switch (DWC3_TRB_SIZE_TRBSTS(trb->size)) {
+		case DWC3_TRBSTS_MISSED_ISOC:
+			/* Isoc endpoint only */
+			request_status = -EXDEV;
+			break;
+		case DWC3_TRB_STS_XFER_IN_PROG:
+			/* Applicable when End Transfer with ForceRM=0 */
+		case DWC3_TRBSTS_SETUP_PENDING:
+			/* Control endpoint only */
+		case DWC3_TRBSTS_OK:
+		default:
+			request_status = 0;
+			break;
+		}
+	} else {
+		request_status = status;
+	}
+
+	dwc3_gadget_giveback(dep, req, request_status);
 
 out:
 	return ret;
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 477e72a1d11e..5ade844db404 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1447,6 +1447,8 @@ static void configfs_composite_unbind(struct usb_gadget *gadget)
 	usb_ep_autoconfig_reset(cdev->gadget);
 	spin_lock_irqsave(&gi->spinlock, flags);
 	cdev->gadget = NULL;
+	cdev->deactivations = 0;
+	gadget->deactivated = false;
 	set_gadget_data(gadget, NULL);
 	spin_unlock_irqrestore(&gi->spinlock, flags);
 }
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 7d00ad7c154c..99dc9adf56ef 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -264,6 +264,8 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
+	queue->buf_used = 0;
+
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1e7dc130c39a..f65f1ba2b592 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1434,7 +1434,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
-								 msecs_to_jiffies(100)))
+								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
 						 hcd->self.busnum, wIndex + 1);
 				spin_lock_irqsave(&xhci->lock, flags);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index de9a9ea2cabc..cb8b481a9499 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
@@ -266,7 +267,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d0b6806275e0..f9707997969d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3141,6 +3141,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 		if (event_loop++ < TRBS_PER_SEGMENT / 2)
 			continue;
 		xhci_update_erst_dequeue(xhci, event_ring_deq);
+		event_ring_deq = xhci->event_ring->dequeue;
 
 		/* ring is half-full, force isoc trbs to interrupt more often */
 		if (xhci->isoc_bei_interval > AVOID_BEI_INTERVAL_MIN)
diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index c8af2cd2216d..996958a6565c 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1034,13 +1034,13 @@ static int tegra_xusb_unpowergate_partitions(struct tegra_xusb *tegra)
 	int rc;
 
 	if (tegra->use_genpd) {
-		rc = pm_runtime_get_sync(tegra->genpd_dev_ss);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_ss);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB SS partition\n");
 			return rc;
 		}
 
-		rc = pm_runtime_get_sync(tegra->genpd_dev_host);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_host);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB Host partition\n");
 			pm_runtime_put_sync(tegra->genpd_dev_ss);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2c1cc9480887..90f5a3ce7c34 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -778,6 +778,17 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
 
+	/* Don't poll the roothubs after shutdown. */
+	xhci_dbg(xhci, "%s: stopping usb%d port polling.\n",
+			__func__, hcd->self.busnum);
+	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+	del_timer_sync(&hcd->rh_timer);
+
+	if (xhci->shared_hcd) {
+		clear_bit(HCD_FLAG_POLL_RH, &xhci->shared_hcd->flags);
+		del_timer_sync(&xhci->shared_hcd->rh_timer);
+	}
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 748139d26263..0be8efcda15d 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -71,6 +71,7 @@ static void destroy_priv(struct kref *kref)
 
 	dev_dbg(&priv->usbdev->dev, "destroying priv datastructure\n");
 	usb_put_dev(priv->usbdev);
+	priv->usbdev = NULL;
 	kfree(priv);
 }
 
@@ -736,7 +737,6 @@ static int uss720_probe(struct usb_interface *intf,
 	parport_announce_port(pp);
 
 	usb_set_intfdata(intf, pp);
-	usb_put_dev(usbdev);
 	return 0;
 
 probe_abort:
@@ -754,7 +754,6 @@ static void uss720_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 	if (pp) {
 		priv = pp->private_data;
-		priv->usbdev = NULL;
 		priv->pp = NULL;
 		dev_dbg(&intf->dev, "parport_remove_port\n");
 		parport_remove_port(pp);
diff --git a/drivers/usb/mtu3/mtu3_dr.c b/drivers/usb/mtu3/mtu3_dr.c
index a6b04831b20b..9b8aded3d95e 100644
--- a/drivers/usb/mtu3/mtu3_dr.c
+++ b/drivers/usb/mtu3/mtu3_dr.c
@@ -21,10 +21,8 @@ static inline struct ssusb_mtk *otg_sx_to_ssusb(struct otg_switch_mtk *otg_sx)
 
 static void toggle_opstate(struct ssusb_mtk *ssusb)
 {
-	if (!ssusb->otg_switch.is_u3_drd) {
-		mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL, DC_SESSION);
-		mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT, SOFT_CONN);
-	}
+	mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL, DC_SESSION);
+	mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT, SOFT_CONN);
 }
 
 /* only port0 supports dual-role mode */
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 661a229c105d..34b9f8140187 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -268,6 +268,13 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop)
 			return -EPROBE_DEFER;
 	}
 
+	nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
+	if (PTR_ERR(nop->vbus_draw) == -ENODEV)
+		nop->vbus_draw = NULL;
+	if (IS_ERR(nop->vbus_draw))
+		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
+				     "could not get vbus regulator\n");
+
 	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 08554e154842..bd006e1712cc 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -194,6 +194,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
+	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e7755d9cfc61..1364ce7f0abf 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,6 +432,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_CLS8			0x00b0
 #define CINTERION_PRODUCT_MV31_MBIM		0x00b3
 #define CINTERION_PRODUCT_MV31_RMNET		0x00b7
+#define CINTERION_PRODUCT_MV32_WA		0x00f1
+#define CINTERION_PRODUCT_MV32_WB		0x00f2
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1217,6 +1219,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1057, 0xff),	/* Telit FN980 */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1058, 0xff),	/* Telit FN980 (PCIe) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1060, 0xff),	/* Telit LN920 (rmnet) */
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1061, 0xff),	/* Telit LN920 (MBIM) */
@@ -1233,6 +1239,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1073, 0xff),	/* Telit FN990 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
@@ -1969,6 +1977,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_RMNET, 0xff),
 	  .driver_info = RSVD(0)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA, 0xff),
+	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB, 0xff),
+	  .driver_info = RSVD(3)},
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD120),
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index da65d14c9ed5..06aad0d727dd 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -584,9 +584,8 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
 		switch (command) {
 		case WHITEHEAT_GET_DTR_RTS:
 			info = usb_get_serial_port_data(port);
-			memcpy(&info->mcr, command_info->result_buffer,
-					sizeof(struct whiteheat_dr_info));
-				break;
+			info->mcr = command_info->result_buffer[0];
+			break;
 		}
 	}
 exit:
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 5ef5bd0e87cf..8a7e2dd52ad5 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -955,6 +955,8 @@ static int ucsi_dr_swap(struct typec_port *port, enum typec_data_role role)
 	     role == TYPEC_HOST))
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_UOR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_UOR_ROLE(role);
 	command |= UCSI_SET_UOR_ACCEPT_ROLE_SWAPS;
@@ -962,14 +964,18 @@ static int ucsi_dr_swap(struct typec_port *port, enum typec_data_role role)
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-					msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
-		ret = -ETIMEDOUT;
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	return 0;
 
 out_unlock:
 	mutex_unlock(&con->lock);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
@@ -991,6 +997,8 @@ static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
 	if (cur_role == role)
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_PDR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_PDR_ROLE(role);
 	command |= UCSI_SET_PDR_ACCEPT_ROLE_SWAPS;
@@ -998,11 +1006,13 @@ static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-				msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS))) {
-		ret = -ETIMEDOUT;
-		goto out_unlock;
-	}
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	mutex_lock(&con->lock);
 
 	/* Something has gone wrong while swapping the role */
 	if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) !=
diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 90f48b71fd8f..d9eec1b60e66 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1649,8 +1649,9 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	const struct device_attribute *attr;
 	struct dlfb_data *dlfb;
 	struct fb_info *info;
-	int retval = -ENOMEM;
+	int retval;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *out;
 
 	/* usb initialization */
 	dlfb = kzalloc(sizeof(*dlfb), GFP_KERNEL);
@@ -1664,6 +1665,12 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	dlfb->udev = usb_get_dev(usbdev);
 	usb_set_intfdata(intf, dlfb);
 
+	retval = usb_find_common_endpoints(intf->cur_altsetting, NULL, &out, NULL, NULL);
+	if (retval) {
+		dev_err(&intf->dev, "Device should have at lease 1 bulk endpoint!\n");
+		goto error;
+	}
+
 	dev_dbg(&intf->dev, "console enable=%d\n", console);
 	dev_dbg(&intf->dev, "fb_defio enable=%d\n", fb_defio);
 	dev_dbg(&intf->dev, "shadow enable=%d\n", shadow);
@@ -1673,6 +1680,7 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	if (!dlfb_parse_vendor_descriptor(dlfb, intf)) {
 		dev_err(&intf->dev,
 			"firmware not recognized, incompatible device?\n");
+		retval = -ENODEV;
 		goto error;
 	}
 
@@ -1686,8 +1694,10 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 
 	/* allocates framebuffer driver structure, not framebuffer memory */
 	info = framebuffer_alloc(0, &dlfb->udev->dev);
-	if (!info)
+	if (!info) {
+		retval = -ENOMEM;
 		goto error;
+	}
 
 	dlfb->info = info;
 	info->par = dlfb;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e90d80a8a9e3..290cfe11e790 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3216,6 +3216,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 			ret = btrfs_alloc_log_tree_node(trans, log_root_tree);
 			if (ret) {
 				mutex_unlock(&fs_info->tree_root->log_mutex);
+				blk_finish_plug(&plug);
 				goto out;
 			}
 		}
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 09900a9015ea..d1faa9d2f1e8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2266,6 +2266,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
@@ -2286,6 +2288,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index db3ead52ec7c..0c1af2dd9069 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1849,9 +1849,17 @@ smb2_copychunk_range(const unsigned int xid,
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
+	struct inode *inode;
 
 	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
 
+	/*
+	 * We need to flush all unwritten data before we can send the
+	 * copychunk ioctl to the server.
+	 */
+	inode = d_inode(trgtfile->dentry);
+	filemap_write_and_wait(inode->i_mapping);
+
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fa21d8180319..d12f11c6fbf2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1167,20 +1167,25 @@ static void ext4_put_super(struct super_block *sb)
 	int aborted = 0;
 	int i, err;
 
-	ext4_unregister_li_request(sb);
-	ext4_quota_off_umount(sb);
-
-	flush_work(&sbi->s_error_work);
-	destroy_workqueue(sbi->rsv_conversion_wq);
-	ext4_release_orphan_info(sb);
-
 	/*
 	 * Unregister sysfs before destroying jbd2 journal.
 	 * Since we could still access attr_journal_task attribute via sysfs
 	 * path which could have sbi->s_journal->j_task as NULL
+	 * Unregister sysfs before flush sbi->s_error_work.
+	 * Since user may read /proc/fs/ext4/xx/mb_groups during umount, If
+	 * read metadata verify failed then will queue error work.
+	 * flush_stashed_error_work will call start_this_handle may trigger
+	 * BUG_ON.
 	 */
 	ext4_unregister_sysfs(sb);
 
+	ext4_unregister_li_request(sb);
+	ext4_quota_off_umount(sb);
+
+	flush_work(&sbi->s_error_work);
+	destroy_workqueue(sbi->rsv_conversion_wq);
+	ext4_release_orphan_info(sb);
+
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
 		err = jbd2_journal_destroy(sbi->s_journal);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 247b8d95b5ef..eb5ea0262f3c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -858,9 +858,9 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 		leftover = fault_in_iov_iter_writeable(to, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(gh))
-				goto retry;
-			goto retry_under_glock;
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 	if (gfs2_holder_queued(gh))
@@ -927,9 +927,9 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 		leftover = fault_in_iov_iter_readable(from, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(gh))
-				goto retry;
-			goto retry_under_glock;
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 out:
@@ -996,12 +996,9 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		leftover = fault_in_iov_iter_writeable(to, window_size);
 		gfs2_holder_disallow_demote(&gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(&gh)) {
-				if (written)
-					goto out_uninit;
-				goto retry;
-			}
-			goto retry_under_glock;
+			if (gfs2_holder_queued(&gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 	if (gfs2_holder_queued(&gh))
@@ -1021,6 +1018,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder *statfs_gh = NULL;
 	size_t prev_count = 0, window_size = 0;
+	size_t orig_count = iov_iter_count(from);
 	size_t read = 0;
 	ssize_t ret;
 
@@ -1065,6 +1063,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
 
+	from->count = orig_count - read;
 	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
 		size_t leftover;
 
@@ -1072,12 +1071,10 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 		leftover = fault_in_iov_iter_readable(from, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(gh)) {
-				if (read)
-					goto out_uninit;
-				goto retry;
-			}
-			goto retry_under_glock;
+			from->count = min(from->count, window_size - leftover);
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 out_unlock:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1bf1ea2cd8b0..7aad4bde92e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4786,6 +4786,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5007,6 +5009,8 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 192d8308afc2..1ed3046dd5b3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -11,6 +11,7 @@
 #include <linux/statfs.h>
 #include <linux/ethtool.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 
 #include "glob.h"
 #include "smb2pdu.h"
@@ -4997,15 +4998,17 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	case FS_SECTOR_SIZE_INFORMATION:
 	{
 		struct smb3_fs_ss_info *info;
+		unsigned int sector_size =
+			min_t(unsigned int, path.mnt->mnt_sb->s_blocksize, 4096);
 
 		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
 
-		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
+		info->LogicalBytesPerSector = cpu_to_le32(sector_size);
 		info->PhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
-		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
+		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(sector_size);
 		info->FSEffPhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
 		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
 				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
 		info->ByteOffsetForSectorAlignment = 0;
@@ -5768,8 +5771,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
 			pr_err("parent dir is opened with delete access\n");
+			ksmbd_fd_put(work, parent_fp);
 			return -ESHARE;
 		}
+		ksmbd_fd_put(work, parent_fp);
 	}
 next:
 	return smb2_rename(work, fp, user_ns, rename_info,
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 29c1db66bd0f..8b873d92d785 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -497,6 +497,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
+			lfp = ksmbd_fp_get(lfp);
 			read_unlock(&ci->m_lock);
 			return lfp;
 		}
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index bced33b76bea..b34ccfd71b0f 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -35,6 +35,17 @@ static inline int zonefs_zone_mgmt(struct inode *inode,
 
 	lockdep_assert_held(&zi->i_truncate_mutex);
 
+	/*
+	 * With ZNS drives, closing an explicitly open zone that has not been
+	 * written will change the zone state to "closed", that is, the zone
+	 * will remain active. Since this can then cause failure of explicit
+	 * open operation on other zones if the drive active zone resources
+	 * are exceeded, make sure that the zone does not remain active by
+	 * resetting it.
+	 */
+	if (op == REQ_OP_ZONE_CLOSE && !zi->i_wpoffset)
+		op = REQ_OP_ZONE_RESET;
+
 	trace_zonefs_zone_mgmt(inode, op);
 	ret = blkdev_zone_mgmt(inode->i_sb->s_bdev, op, zi->i_zsector,
 			       zi->i_zone_size >> SECTOR_SHIFT, GFP_NOFS);
@@ -1144,6 +1155,7 @@ static struct inode *zonefs_alloc_inode(struct super_block *sb)
 	inode_init_once(&zi->i_vnode);
 	mutex_init(&zi->i_truncate_mutex);
 	zi->i_wr_refcnt = 0;
+	zi->i_flags = 0;
 
 	return &zi->i_vnode;
 }
@@ -1295,12 +1307,13 @@ static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
 	inc_nlink(parent);
 }
 
-static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
-				   enum zonefs_ztype type)
+static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
+				  enum zonefs_ztype type)
 {
 	struct super_block *sb = inode->i_sb;
 	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	int ret = 0;
 
 	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
 	inode->i_mode = S_IFREG | sbi->s_perm;
@@ -1325,6 +1338,22 @@ static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	sb->s_maxbytes = max(zi->i_max_size, sb->s_maxbytes);
 	sbi->s_blocks += zi->i_max_size >> sb->s_blocksize_bits;
 	sbi->s_used_blocks += zi->i_wpoffset >> sb->s_blocksize_bits;
+
+	/*
+	 * For sequential zones, make sure that any open zone is closed first
+	 * to ensure that the initial number of open zones is 0, in sync with
+	 * the open zone accounting done when the mount option
+	 * ZONEFS_MNTOPT_EXPLICIT_OPEN is used.
+	 */
+	if (type == ZONEFS_ZTYPE_SEQ &&
+	    (zone->cond == BLK_ZONE_COND_IMP_OPEN ||
+	     zone->cond == BLK_ZONE_COND_EXP_OPEN)) {
+		mutex_lock(&zi->i_truncate_mutex);
+		ret = zonefs_zone_mgmt(inode, REQ_OP_ZONE_CLOSE);
+		mutex_unlock(&zi->i_truncate_mutex);
+	}
+
+	return ret;
 }
 
 static struct dentry *zonefs_create_inode(struct dentry *parent,
@@ -1334,6 +1363,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 	struct inode *dir = d_inode(parent);
 	struct dentry *dentry;
 	struct inode *inode;
+	int ret;
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
@@ -1344,10 +1374,16 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 		goto dput;
 
 	inode->i_ctime = inode->i_mtime = inode->i_atime = dir->i_ctime;
-	if (zone)
-		zonefs_init_file_inode(inode, zone, type);
-	else
+	if (zone) {
+		ret = zonefs_init_file_inode(inode, zone, type);
+		if (ret) {
+			iput(inode);
+			goto dput;
+		}
+	} else {
 		zonefs_init_dir_inode(dir, inode, type);
+	}
+
 	d_add(dentry, inode);
 	dir->i_size++;
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2776423a587e..f56cd8879a59 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -277,7 +277,7 @@ static inline char *hex_byte_pack_upper(char *buf, u8 byte)
 	return buf;
 }
 
-extern int hex_to_bin(char ch);
+extern int hex_to_bin(unsigned char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 extern char *bin2hex(char *dst, const void *src, size_t count);
 
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 88227044fc86..8a2c60235ebb 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -394,10 +394,8 @@ struct mtd_info {
 	/* List of partitions attached to this MTD device */
 	struct list_head partitions;
 
-	union {
-		struct mtd_part part;
-		struct mtd_master master;
-	};
+	struct mtd_part part;
+	struct mtd_master master;
 };
 
 static inline struct mtd_info *mtd_get_master(struct mtd_info *mtd)
diff --git a/include/memory/renesas-rpc-if.h b/include/memory/renesas-rpc-if.h
index 77c694a19149..15dd0076c293 100644
--- a/include/memory/renesas-rpc-if.h
+++ b/include/memory/renesas-rpc-if.h
@@ -66,6 +66,7 @@ struct rpcif {
 	size_t size;
 	enum rpcif_data_dir dir;
 	u8 bus_size;
+	u8 xfer_size;
 	void *buffer;
 	u32 xferlen;
 	u32 smcr;
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 028eaea1c854..42d50856fcf2 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -57,7 +57,7 @@ struct ip6_tnl {
 
 	/* These fields used only by GRE */
 	__u32 i_seqno;	/* The last seen seqno	*/
-	__u32 o_seqno;	/* The last output seqno */
+	atomic_t o_seqno;	/* The last output seqno */
 	int hlen;       /* tun_hlen + encap_hlen */
 	int tun_hlen;	/* Precalculated header length */
 	int encap_hlen; /* Encap header length (FOU,GUE) */
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index bc3b13ec93c9..37d5d4968e20 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -113,7 +113,7 @@ struct ip_tunnel {
 
 	/* These four fields used only by GRE */
 	u32		i_seqno;	/* The last seen seqno	*/
-	u32		o_seqno;	/* The last output seqno */
+	atomic_t	o_seqno;	/* The last output seqno */
 	int		tun_hlen;	/* Precalculated header length */
 
 	/* These four fields used only by ERSPAN */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 31d384c3778a..91ac329ca578 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -470,6 +470,7 @@ int __cookie_v4_check(const struct iphdr *iph, const struct tcphdr *th,
 		      u32 cookie);
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    const struct tcp_request_sock_ops *af_ops,
 					    struct sock *sk, struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
 
@@ -608,6 +609,7 @@ void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
 void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
+void tcp_check_space(struct sock *sk);
 
 /* tcp_timer.c */
 void tcp_init_xmit_timers(struct sock *);
@@ -1026,6 +1028,7 @@ struct rate_sample {
 	int  losses;		/* number of packets marked lost upon ACK */
 	u32  acked_sacked;	/* number of packets newly (S)ACKed upon ACK */
 	u32  prior_in_flight;	/* in flight before this ACK */
+	u32  last_end_seq;	/* end_seq of most recently ACKed packet */
 	bool is_app_limited;	/* is sample from packet with bubble in pipe? */
 	bool is_retrans;	/* is sample from retransmission? */
 	bool is_ack_delayed;	/* is this (likely) a delayed ACK? */
@@ -1148,6 +1151,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
 		  bool is_sack_reneg, struct rate_sample *rs);
 void tcp_rate_check_app_limited(struct sock *sk);
 
+static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
+{
+	return t1 > t2 || (t1 == t2 && after(seq1, seq2));
+}
+
 /* These functions determine how the current flow behaves in respect of SACK
  * handling. SACK is negotiated with the peer, and therefore it can vary
  * between different flows.
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 9301578f98e8..06833d404398 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -22,15 +22,33 @@ EXPORT_SYMBOL(hex_asc_upper);
  *
  * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
  * input.
+ *
+ * This function is used to load cryptographic keys, so it is coded in such a
+ * way that there are no conditions or memory accesses that depend on data.
+ *
+ * Explanation of the logic:
+ * (ch - '9' - 1) is negative if ch <= '9'
+ * ('0' - 1 - ch) is negative if ch >= '0'
+ * we "and" these two values, so the result is negative if ch is in the range
+ *	'0' ... '9'
+ * we are only interested in the sign, so we do a shift ">> 8"; note that right
+ *	shift of a negative value is implementation-defined, so we cast the
+ *	value to (unsigned) before the shift --- we have 0xffffff if ch is in
+ *	the range '0' ... '9', 0 otherwise
+ * we "and" this value with (ch - '0' + 1) --- we have a value 1 ... 10 if ch is
+ *	in the range '0' ... '9', 0 otherwise
+ * we add this value to -1 --- we have a value 0 ... 9 if ch is in the range '0'
+ *	... '9', -1 otherwise
+ * the next line is similar to the previous one, but we need to decode both
+ *	uppercase and lowercase letters, so we use (ch & 0xdf), which converts
+ *	lowercase to uppercase
  */
-int hex_to_bin(char ch)
+int hex_to_bin(unsigned char ch)
 {
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	ch = tolower(ch);
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	return -1;
+	unsigned char cu = ch & 0xdf;
+	return -1 +
+		((ch - '0' +  1) & (unsigned)((ch - '9' - 1) & ('0' - 1 - ch)) >> 8) +
+		((cu - 'A' + 11) & (unsigned)((cu - 'F' - 1) & ('A' - 1 - cu)) >> 8);
 }
 EXPORT_SYMBOL(hex_to_bin);
 
@@ -45,10 +63,13 @@ EXPORT_SYMBOL(hex_to_bin);
 int hex2bin(u8 *dst, const char *src, size_t count)
 {
 	while (count--) {
-		int hi = hex_to_bin(*src++);
-		int lo = hex_to_bin(*src++);
+		int hi, lo;
 
-		if ((hi < 0) || (lo < 0))
+		hi = hex_to_bin(*src++);
+		if (unlikely(hi < 0))
+			return -EINVAL;
+		lo = hex_to_bin(*src++);
+		if (unlikely(lo < 0))
 			return -EINVAL;
 
 		*dst++ = (hi << 4) | lo;
diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 47ed4fc33a29..1bd6a3f13467 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -315,6 +315,13 @@ static void per_cpu_remove_cache(void *arg)
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	/*
+	 * Ensure the ordering between the writing to q->offline and
+	 * per_cpu_remove_cache.  Prevent cpu_quarantine from being corrupted
+	 * by interrupt.
+	 */
+	if (READ_ONCE(q->offline))
+		return;
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
 }
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 2f7940bcf715..3fd207fe1284 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -158,10 +158,8 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return dst->lwtstate->orig_output(net, sk, skb);
 }
 
-static int xmit_check_hhlen(struct sk_buff *skb)
+static int xmit_check_hhlen(struct sk_buff *skb, int hh_len)
 {
-	int hh_len = skb_dst(skb)->dev->hard_header_len;
-
 	if (skb_headroom(skb) < hh_len) {
 		int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
 
@@ -273,6 +271,7 @@ static int bpf_xmit(struct sk_buff *skb)
 
 	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
 	if (bpf->xmit.prog) {
+		int hh_len = dst->dev->hard_header_len;
 		__be16 proto = skb->protocol;
 		int ret;
 
@@ -290,7 +289,7 @@ static int bpf_xmit(struct sk_buff *skb)
 			/* If the header was expanded, headroom might be too
 			 * small for L2 header to come, expand as needed.
 			 */
-			ret = xmit_check_hhlen(skb);
+			ret = xmit_check_hhlen(skb, hh_len);
 			if (unlikely(ret))
 				return ret;
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 616330a16d31..63e88de96393 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1201,8 +1201,10 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+			of_node_put(phy_np);
 			return dsa_port_phylink_register(dp);
 		}
+		of_node_put(phy_np);
 		return 0;
 	}
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e7f3e37e4aa8..276a3b7b0e9c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -459,14 +459,12 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       __be16 proto)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-
-	if (tunnel->parms.o_flags & TUNNEL_SEQ)
-		tunnel->o_seqno++;
+	__be16 flags = tunnel->parms.o_flags;
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
-			 tunnel->parms.o_flags, proto, tunnel->parms.o_key,
-			 htonl(tunnel->o_seqno));
+			 flags, proto, tunnel->parms.o_key,
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
@@ -504,7 +502,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 		(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 	gre_build_header(skb, tunnel_hlen, flags, proto,
 			 tunnel_id_to_key32(tun_info->key.tun_id),
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -581,7 +579,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	gre_build_header(skb, 8, TUNNEL_SEQ,
-			 proto, 0, htonl(tunnel->o_seqno++));
+			 proto, 0, htonl(atomic_fetch_inc(&tunnel->o_seqno)));
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 33792cf55a79..10b469aee492 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -283,6 +283,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 EXPORT_SYMBOL(cookie_ecn_ok);
 
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    const struct tcp_request_sock_ops *af_ops,
 					    struct sock *sk,
 					    struct sk_buff *skb)
 {
@@ -299,6 +300,10 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 		return NULL;
 
 	treq = tcp_rsk(req);
+
+	/* treq->af_specific might be used to perform TCP_MD5 lookup */
+	treq->af_specific = af_ops;
+
 	treq->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
 #if IS_ENABLED(CONFIG_MPTCP)
 	treq->is_mptcp = sk_is_mptcp(sk);
@@ -366,7 +371,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops, sk, skb);
+	req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops,
+				     &tcp_request_sock_ipv4_ops, sk, skb);
 	if (!req)
 		goto out;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 509f577869d4..dfd32cd3b95e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3860,7 +3860,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_process_tlp_ack(sk, ack, flag);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
-		if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
+		if (!(flag & (FLAG_SND_UNA_ADVANCED |
+			      FLAG_NOT_DUP | FLAG_DSACKING_ACK))) {
 			num_dupack = 1;
 			/* Consider if pure acks were aggregated in tcp_add_backlog() */
 			if (!(flag & FLAG_DATA))
@@ -5420,7 +5421,17 @@ static void tcp_new_space(struct sock *sk)
 	INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
 }
 
-static void tcp_check_space(struct sock *sk)
+/* Caller made space either from:
+ * 1) Freeing skbs in rtx queues (after tp->snd_una has advanced)
+ * 2) Sent skbs from output queue (and thus advancing tp->snd_nxt)
+ *
+ * We might be able to generate EPOLLOUT to the application if:
+ * 1) Space consumed in output/rtx queues is below sk->sk_sndbuf/2
+ * 2) notsent amount (tp->write_seq - tp->snd_nxt) became
+ *    small enough that tcp_stream_memory_free() decides it
+ *    is time to generate EPOLLOUT.
+ */
+void tcp_check_space(struct sock *sk)
 {
 	/* pairs with tcp_poll() */
 	smp_mb();
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0a4f3f16140a..13783fc58e03 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -538,7 +538,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->tsoffset = treq->ts_off;
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
-	if (newtp->af_specific->md5_lookup(sk, newsk))
+	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 369752f5f676..df413282fa2e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -82,6 +82,7 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
 
 	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
 		      tcp_skb_pcount(skb));
+	tcp_check_space(sk);
 }
 
 /* SND.NXT, if window was not shrunk or the amount of shrunk was less than one
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 0de693565963..6ab197928abb 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -73,26 +73,31 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
  *
  * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
  * called multiple times. We favor the information from the most recently
- * sent skb, i.e., the skb with the highest prior_delivered count.
+ * sent skb, i.e., the skb with the most recently sent time and the highest
+ * sequence.
  */
 void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 			    struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
+	u64 tx_tstamp;
 
 	if (!scb->tx.delivered_mstamp)
 		return;
 
+	tx_tstamp = tcp_skb_timestamp_us(skb);
 	if (!rs->prior_delivered ||
-	    after(scb->tx.delivered, rs->prior_delivered)) {
+	    tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
+			       scb->end_seq, rs->last_end_seq)) {
 		rs->prior_delivered  = scb->tx.delivered;
 		rs->prior_mstamp     = scb->tx.delivered_mstamp;
 		rs->is_app_limited   = scb->tx.is_app_limited;
 		rs->is_retrans	     = scb->sacked & TCPCB_RETRANS;
+		rs->last_end_seq     = scb->end_seq;
 
 		/* Record send time of most recently ACKed packet: */
-		tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
+		tp->first_tx_mstamp  = tx_tstamp;
 		/* Find the duration of the "send phase" of this window: */
 		rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
 						     scb->tx.first_tx_mstamp);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 869c3337e319..a817ac6d9759 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -724,6 +724,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 {
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
+	__be16 flags;
 
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
@@ -739,7 +740,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	if (tunnel->parms.collect_md) {
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
-		__be16 flags;
 		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
@@ -766,19 +766,19 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
 						      : 0);
 
 	} else {
-		if (tunnel->parms.o_flags & TUNNEL_SEQ)
-			tunnel->o_seqno++;
-
 		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
 			return -ENOMEM;
 
-		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
+		flags = tunnel->parms.o_flags;
+
+		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 htonl(tunnel->o_seqno));
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
+						      : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
@@ -1056,7 +1056,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	/* Push GRE header. */
 	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
 					   : htons(ETH_P_ERSPAN2);
-	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(t->o_seqno++));
+	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6ab710b5a1a8..118e834e9190 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,14 +24,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
+	struct net_device *dev = skb_dst(skb)->dev;
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
 		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
 	struct flowi6 fl6 = {
-		.flowi6_oif = sk && sk->sk_bound_dev_if ? sk->sk_bound_dev_if :
-			strict ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
@@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	if (sk && sk->sk_bound_dev_if)
+		fl6.flowi6_oif = sk->sk_bound_dev_if;
+	else if (strict)
+		fl6.flowi6_oif = dev->ifindex;
+	else
+		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
+
 	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
 	err = dst->error;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e8cfb9e997bf..ca92dd6981de 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -170,7 +170,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops, sk, skb);
+	req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops,
+				     &tcp_request_sock_ipv6_ops, sk, skb);
 	if (!req)
 		goto out;
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2c467c422dc6..fb67f1ca2495 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..55aa55b252b2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -823,7 +823,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
 		.procname	= "nf_flowtable_udp_timeout",
 		.maxlen		= sizeof(unsigned int),
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index d600a566da32..7325bee7d144 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -349,7 +349,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-				p = &parent->rb_left;
+				overlap = false;
+				if (nft_rbtree_interval_end(rbe))
+					p = &parent->rb_left;
+				else
+					p = &parent->rb_right;
 			}
 		}
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index b8f011145765..9ad9cc0d1d27 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -53,6 +53,32 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
 }
 #endif
 
+static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
+{
+	const struct net_device *indev = nft_in(pkt);
+	const struct sk_buff *skb = pkt->skb;
+	struct sock *sk = NULL;
+
+	if (!indev)
+		return NULL;
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, indev);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, indev);
+		break;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return sk;
+}
+
 static void nft_socket_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -66,20 +92,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		sk = NULL;
 
 	if (!sk)
-		switch(nft_pf(pkt)) {
-		case NFPROTO_IPV4:
-			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
-		case NFPROTO_IPV6:
-			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#endif
-		default:
-			WARN_ON_ONCE(1);
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		sk = nft_socket_do_lookup(pkt);
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
@@ -197,6 +210,16 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_socket_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_LOCAL_OUT));
+}
+
 static struct nft_expr_type nft_socket_type;
 static const struct nft_expr_ops nft_socket_ops = {
 	.type		= &nft_socket_type,
@@ -204,6 +227,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.validate	= nft_socket_validate,
 };
 
 static struct nft_expr_type nft_socket_type __read_mostly = {
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index b3815b568e8e..463c4a58d2c3 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -458,6 +458,10 @@ void sctp_generate_reconf_event(struct timer_list *t)
 		goto out_unlock;
 	}
 
+	/* This happens when the response arrives after the timer is triggered. */
+	if (!asoc->strreset_chunk)
+		goto out_unlock;
+
 	error = sctp_do_sm(net, SCTP_EVENT_T_TIMEOUT,
 			   SCTP_ST_TIMEOUT(SCTP_EVENT_TIMEOUT_RECONF),
 			   asoc->state, asoc->ep, asoc,
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 499058248bdb..fb801c249d92 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1223,6 +1223,8 @@ static void smc_connect_work(struct work_struct *work)
 		smc->sk.sk_state = SMC_CLOSED;
 		if (rc == -EPIPE || rc == -EAGAIN)
 			smc->sk.sk_err = EPIPE;
+		else if (rc == -ECONNREFUSED)
+			smc->sk.sk_err = ECONNREFUSED;
 		else if (signal_pending(current))
 			smc->sk.sk_err = -sock_intr_errno(timeo);
 		sock_put(&smc->sk); /* passive closing */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b932469ee69c..a40553e83f8b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -483,11 +483,13 @@ static int tls_push_data(struct sock *sk,
 		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
 		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		rc = tls_device_copy_data(page_address(pfrag->page) +
-					  pfrag->offset, copy, msg_iter);
-		if (rc)
-			goto handle_error;
-		tls_append_frag(record, pfrag, copy);
+		if (copy) {
+			rc = tls_device_copy_data(page_address(pfrag->page) +
+						  pfrag->offset, copy, msg_iter);
+			if (rc)
+				goto handle_error;
+			tls_append_frag(record, pfrag, copy);
+		}
 
 		size -= copy;
 		if (!size) {
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 426e287431d2..444ad0bc0908 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -655,7 +655,7 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (sk_can_busy_loop(sk))
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
 
-	if (xsk_no_wakeup(sk))
+	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
 
 	pool = xs->pool;
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index dcee7b2bd3d7..859ebcec8383 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -602,7 +602,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 	ret = wm8731_reset(wm8731->regmap);
 	if (ret < 0) {
 		dev_err(dev, "Failed to issue reset: %d\n", ret);
-		goto err_regulator_enable;
+		goto err;
 	}
 
 	/* Clear POWEROFF, keep everything else disabled */
@@ -619,10 +619,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 
 	regcache_mark_dirty(wm8731->regmap);
 
-err_regulator_enable:
-	/* Regulators will be enabled by bias management */
-	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
-
+err:
 	return ret;
 }
 
@@ -766,21 +763,27 @@ static int wm8731_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm8731->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	ret = wm8731_hw_init(&i2c->dev, wm8731);
 	if (ret != 0)
-		return ret;
+		goto err_regulator_enable;
 
 	ret = devm_snd_soc_register_component(&i2c->dev,
 			&soc_component_dev_wm8731, &wm8731_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	return 0;
+
+err_regulator_enable:
+	/* Regulators will be enabled by bias management */
+	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
+
+	return ret;
 }
 
 static int wm8731_i2c_remove(struct i2c_client *client)
diff --git a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
index 11801b905ecc..c93d8019b0e5 100644
--- a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
@@ -127,13 +127,13 @@ static const struct snd_soc_acpi_adr_device mx8373_1_adr[] = {
 	{
 		.adr = 0x000123019F837300ull,
 		.num_endpoints = 1,
-		.endpoints = &spk_l_endpoint,
+		.endpoints = &spk_r_endpoint,
 		.name_prefix = "Right"
 	},
 	{
 		.adr = 0x000127019F837300ull,
 		.num_endpoints = 1,
-		.endpoints = &spk_r_endpoint,
+		.endpoints = &spk_l_endpoint,
 		.name_prefix = "Left"
 	}
 };
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 81982948f981..58350fe1944b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -393,12 +393,12 @@ static int add_dead_ends(struct objtool_file *file)
 		else if (reloc->addend == reloc->sym->sec->sh.sh_size) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find unreachable insn at %s+0x%x",
+				WARN("can't find unreachable insn at %s+0x%lx",
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find unreachable insn at %s+0x%x",
+			WARN("can't find unreachable insn at %s+0x%lx",
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
@@ -428,12 +428,12 @@ static int add_dead_ends(struct objtool_file *file)
 		else if (reloc->addend == reloc->sym->sec->sh.sh_size) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
-				WARN("can't find reachable insn at %s+0x%x",
+				WARN("can't find reachable insn at %s+0x%lx",
 				     reloc->sym->sec->name, reloc->addend);
 				return -1;
 			}
 		} else {
-			WARN("can't find reachable insn at %s+0x%x",
+			WARN("can't find reachable insn at %s+0x%lx",
 			     reloc->sym->sec->name, reloc->addend);
 			return -1;
 		}
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index fee03b744a6e..a3395467c316 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -485,7 +485,7 @@ static struct section *elf_create_reloc_section(struct elf *elf,
 						int reltype);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, int addend)
+		  unsigned int type, struct symbol *sym, long addend)
 {
 	struct reloc *reloc;
 
@@ -514,37 +514,180 @@ int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
 	return 0;
 }
 
-int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
-			  unsigned long offset, unsigned int type,
-			  struct section *insn_sec, unsigned long insn_off)
+/*
+ * Ensure that any reloc section containing references to @sym is marked
+ * changed such that it will get re-generated in elf_rebuild_reloc_sections()
+ * with the new symbol index.
+ */
+static void elf_dirty_reloc_sym(struct elf *elf, struct symbol *sym)
+{
+	struct section *sec;
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		struct reloc *reloc;
+
+		if (sec->changed)
+			continue;
+
+		list_for_each_entry(reloc, &sec->reloc_list, list) {
+			if (reloc->sym == sym) {
+				sec->changed = true;
+				break;
+			}
+		}
+	}
+}
+
+/*
+ * Move the first global symbol, as per sh_info, into a new, higher symbol
+ * index. This fees up the shndx for a new local symbol.
+ */
+static int elf_move_global_symbol(struct elf *elf, struct section *symtab,
+				  struct section *symtab_shndx)
 {
+	Elf_Data *data, *shndx_data = NULL;
+	Elf32_Word first_non_local;
 	struct symbol *sym;
-	int addend;
+	Elf_Scn *s;
 
-	if (insn_sec->sym) {
-		sym = insn_sec->sym;
-		addend = insn_off;
+	first_non_local = symtab->sh.sh_info;
 
-	} else {
-		/*
-		 * The Clang assembler strips section symbols, so we have to
-		 * reference the function symbol instead:
-		 */
-		sym = find_symbol_containing(insn_sec, insn_off);
-		if (!sym) {
-			/*
-			 * Hack alert.  This happens when we need to reference
-			 * the NOP pad insn immediately after the function.
-			 */
-			sym = find_symbol_containing(insn_sec, insn_off - 1);
+	sym = find_symbol_by_index(elf, first_non_local);
+	if (!sym) {
+		WARN("no non-local symbols !?");
+		return first_non_local;
+	}
+
+	s = elf_getscn(elf->elf, symtab->idx);
+	if (!s) {
+		WARN_ELF("elf_getscn");
+		return -1;
+	}
+
+	data = elf_newdata(s);
+	if (!data) {
+		WARN_ELF("elf_newdata");
+		return -1;
+	}
+
+	data->d_buf = &sym->sym;
+	data->d_size = sizeof(sym->sym);
+	data->d_align = 1;
+	data->d_type = ELF_T_SYM;
+
+	sym->idx = symtab->sh.sh_size / sizeof(sym->sym);
+	elf_dirty_reloc_sym(elf, sym);
+
+	symtab->sh.sh_info += 1;
+	symtab->sh.sh_size += data->d_size;
+	symtab->changed = true;
+
+	if (symtab_shndx) {
+		s = elf_getscn(elf->elf, symtab_shndx->idx);
+		if (!s) {
+			WARN_ELF("elf_getscn");
+			return -1;
 		}
 
-		if (!sym) {
-			WARN("can't find symbol containing %s+0x%lx", insn_sec->name, insn_off);
+		shndx_data = elf_newdata(s);
+		if (!shndx_data) {
+			WARN_ELF("elf_newshndx_data");
 			return -1;
 		}
 
-		addend = insn_off - sym->offset;
+		shndx_data->d_buf = &sym->sec->idx;
+		shndx_data->d_size = sizeof(Elf32_Word);
+		shndx_data->d_align = 4;
+		shndx_data->d_type = ELF_T_WORD;
+
+		symtab_shndx->sh.sh_size += 4;
+		symtab_shndx->changed = true;
+	}
+
+	return first_non_local;
+}
+
+static struct symbol *
+elf_create_section_symbol(struct elf *elf, struct section *sec)
+{
+	struct section *symtab, *symtab_shndx;
+	Elf_Data *shndx_data = NULL;
+	struct symbol *sym;
+	Elf32_Word shndx;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (symtab) {
+		symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
+		if (symtab_shndx)
+			shndx_data = symtab_shndx->data;
+	} else {
+		WARN("no .symtab");
+		return NULL;
+	}
+
+	sym = malloc(sizeof(*sym));
+	if (!sym) {
+		perror("malloc");
+		return NULL;
+	}
+	memset(sym, 0, sizeof(*sym));
+
+	sym->idx = elf_move_global_symbol(elf, symtab, symtab_shndx);
+	if (sym->idx < 0) {
+		WARN("elf_move_global_symbol");
+		return NULL;
+	}
+
+	sym->name = sec->name;
+	sym->sec = sec;
+
+	// st_name 0
+	sym->sym.st_info = GELF_ST_INFO(STB_LOCAL, STT_SECTION);
+	// st_other 0
+	// st_value 0
+	// st_size 0
+	shndx = sec->idx;
+	if (shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) {
+		sym->sym.st_shndx = shndx;
+		if (!shndx_data)
+			shndx = 0;
+	} else {
+		sym->sym.st_shndx = SHN_XINDEX;
+		if (!shndx_data) {
+			WARN("no .symtab_shndx");
+			return NULL;
+		}
+	}
+
+	if (!gelf_update_symshndx(symtab->data, shndx_data, sym->idx, &sym->sym, shndx)) {
+		WARN_ELF("gelf_update_symshndx");
+		return NULL;
+	}
+
+	elf_add_symbol(elf, sym);
+
+	return sym;
+}
+
+int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
+			  unsigned long offset, unsigned int type,
+			  struct section *insn_sec, unsigned long insn_off)
+{
+	struct symbol *sym = insn_sec->sym;
+	int addend = insn_off;
+
+	if (!sym) {
+		/*
+		 * Due to how weak functions work, we must use section based
+		 * relocations. Symbol based relocations would result in the
+		 * weak and non-weak function annotations being overlaid on the
+		 * non-weak function after linking.
+		 */
+		sym = elf_create_section_symbol(elf, insn_sec);
+		if (!sym)
+			return -1;
+
+		insn_sec->sym = sym;
 	}
 
 	return elf_add_reloc(elf, sec, offset, type, sym, addend);
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 075d8291b854..b4d01f8fd09b 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -69,7 +69,7 @@ struct reloc {
 	struct symbol *sym;
 	unsigned long offset;
 	unsigned int type;
-	int addend;
+	long addend;
 	int idx;
 	bool jump_table_start;
 };
@@ -131,7 +131,7 @@ struct elf *elf_open_read(const char *name, int flags);
 struct section *elf_create_section(struct elf *elf, const char *name, unsigned int sh_flags, size_t entsize, int nr);
 
 int elf_add_reloc(struct elf *elf, struct section *sec, unsigned long offset,
-		  unsigned int type, struct symbol *sym, int addend);
+		  unsigned int type, struct symbol *sym, long addend);
 int elf_add_reloc_to_insn(struct elf *elf, struct section *sec,
 			  unsigned long offset, unsigned int type,
 			  struct section *insn_sec, unsigned long insn_off);
diff --git a/tools/perf/arch/arm64/util/Build b/tools/perf/arch/arm64/util/Build
index 9fcb4e68add9..78dfc282e5e2 100644
--- a/tools/perf/arch/arm64/util/Build
+++ b/tools/perf/arch/arm64/util/Build
@@ -1,5 +1,4 @@
 perf-y += header.o
-perf-y += machine.o
 perf-y += perf_regs.o
 perf-y += tsc.o
 perf-y += pmu.o
diff --git a/tools/perf/arch/arm64/util/machine.c b/tools/perf/arch/arm64/util/machine.c
deleted file mode 100644
index 7e7714290a87..000000000000
--- a/tools/perf/arch/arm64/util/machine.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <inttypes.h>
-#include <stdio.h>
-#include <string.h>
-#include "debug.h"
-#include "symbol.h"
-
-/* On arm64, kernel text segment starts at high memory address,
- * for example 0xffff 0000 8xxx xxxx. Modules start at a low memory
- * address, like 0xffff 0000 00ax xxxx. When only small amount of
- * memory is used by modules, gap between end of module's text segment
- * and start of kernel text segment may reach 2G.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-
-#define SYMBOL_LIMIT (1 << 12) /* 4K */
-
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if ((strchr(p->name, '[') && strchr(c->name, '[') == NULL) ||
-			(strchr(p->name, '[') == NULL && strchr(c->name, '[')))
-		/* Limit range of last symbol in module and kernel */
-		p->end += SYMBOL_LIMIT;
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/arch/powerpc/util/Build b/tools/perf/arch/powerpc/util/Build
index 8a79c4126e5b..0115f3166568 100644
--- a/tools/perf/arch/powerpc/util/Build
+++ b/tools/perf/arch/powerpc/util/Build
@@ -1,5 +1,4 @@
 perf-y += header.o
-perf-y += machine.o
 perf-y += kvm-stat.o
 perf-y += perf_regs.o
 perf-y += mem-events.o
diff --git a/tools/perf/arch/powerpc/util/machine.c b/tools/perf/arch/powerpc/util/machine.c
deleted file mode 100644
index e652a1aa8132..000000000000
--- a/tools/perf/arch/powerpc/util/machine.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <inttypes.h>
-#include <stdio.h>
-#include <string.h>
-#include <internal/lib.h> // page_size
-#include "debug.h"
-#include "symbol.h"
-
-/* On powerpc kernel text segment start at memory addresses, 0xc000000000000000
- * whereas the modules are located at very high memory addresses,
- * for example 0xc00800000xxxxxxx. The gap between end of kernel text segment
- * and beginning of first module's text segment is very high.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
-		/* Limit the range of last kernel symbol */
-		p->end += page_size;
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
index 7644a4f6d4a4..98bc3f39d5f3 100644
--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -35,19 +35,3 @@ int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 
 	return 0;
 }
-
-/* On s390 kernel text segment start is located at very low memory addresses,
- * for example 0x10000. Modules are located at very high memory addresses,
- * for example 0x3ff xxxx xxxx. The gap between end of kernel text segment
- * and beginning of first module's text segment is very big.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
-		/* Last kernel symbol mapped to end of page */
-		p->end = roundup(p->end, page_size);
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 7054f23150e1..235549bb28b9 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -927,7 +927,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 	attr.type = PERF_TYPE_HARDWARE;
 	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
 	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
-			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC;
+			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
+			    PERF_SAMPLE_ADDR;
 	if (spe->timeless_decoding)
 		attr.sample_type &= ~(u64)PERF_SAMPLE_TIME;
 	else
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 31cd59a2b66e..ecd377938eea 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1290,7 +1290,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
-		symbols__fixup_end(&dso->symbols);
+		symbols__fixup_end(&dso->symbols, false);
 		symbols__fixup_duplicate(&dso->symbols);
 		if (kmap) {
 			/*
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 61379ed2b75c..b1e5fd99e38a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -101,11 +101,6 @@ static int prefix_underscores_count(const char *str)
 	return tail - str;
 }
 
-void __weak arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	p->end = c->start;
-}
-
 const char * __weak arch__normalize_symbol_name(const char *name)
 {
 	return name;
@@ -217,7 +212,8 @@ void symbols__fixup_duplicate(struct rb_root_cached *symbols)
 	}
 }
 
-void symbols__fixup_end(struct rb_root_cached *symbols)
+/* Update zero-sized symbols using the address of the next symbol */
+void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms)
 {
 	struct rb_node *nd, *prevnd = rb_first_cached(symbols);
 	struct symbol *curr, *prev;
@@ -231,8 +227,29 @@ void symbols__fixup_end(struct rb_root_cached *symbols)
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start || prev->end != curr->start)
-			arch__symbols__fixup_end(prev, curr);
+		/*
+		 * On some architecture kernel text segment start is located at
+		 * some low memory address, while modules are located at high
+		 * memory addresses (or vice versa).  The gap between end of
+		 * kernel text segment and beginning of first module's text
+		 * segment is very big.  Therefore do not fill this gap and do
+		 * not assign it to the kernel dso map (kallsyms).
+		 *
+		 * In kallsyms, it determines module symbols using '[' character
+		 * like in:
+		 *   ffffffffc1937000 T hdmi_driver_init  [snd_hda_codec_hdmi]
+		 */
+		if (prev->end == prev->start) {
+			/* Last kernel/module symbol mapped to end of page */
+			if (is_kallsyms && (!strchr(prev->name, '[') !=
+					    !strchr(curr->name, '[')))
+				prev->end = roundup(prev->end + 4096, 4096);
+			else
+				prev->end = curr->start;
+
+			pr_debug4("%s sym:%s end:%#" PRIx64 "\n",
+				  __func__, prev->name, prev->end);
+		}
 	}
 
 	/* Last entry */
@@ -1456,7 +1473,7 @@ int __dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (kallsyms__delta(kmap, filename, &delta))
 		return -1;
 
-	symbols__fixup_end(&dso->symbols);
+	symbols__fixup_end(&dso->symbols, true);
 	symbols__fixup_duplicate(&dso->symbols);
 
 	if (dso->kernel == DSO_SPACE__KERNEL_GUEST)
@@ -1648,7 +1665,7 @@ int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 #undef bfd_asymbol_section
 #endif
 
-	symbols__fixup_end(&dso->symbols);
+	symbols__fixup_end(&dso->symbols, false);
 	symbols__fixup_duplicate(&dso->symbols);
 	dso->adjust_symbols = 1;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 954d6a049ee2..28721d761d91 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -192,7 +192,7 @@ void __symbols__insert(struct rb_root_cached *symbols, struct symbol *sym,
 		       bool kernel);
 void symbols__insert(struct rb_root_cached *symbols, struct symbol *sym);
 void symbols__fixup_duplicate(struct rb_root_cached *symbols);
-void symbols__fixup_end(struct rb_root_cached *symbols);
+void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms);
 void maps__fixup_end(struct maps *maps);
 
 typedef int (*mapfn_t)(u64 start, u64 len, u64 pgoff, void *data);
@@ -230,7 +230,6 @@ const char *arch__normalize_symbol_name(const char *name);
 #define SYMBOL_A 0
 #define SYMBOL_B 1
 
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
 int arch__compare_symbol_names(const char *namea, const char *nameb);
 int arch__compare_symbol_names_n(const char *namea, const char *nameb,
 				 unsigned int n);
diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 0624d1bd71b5..e3ce33a9954e 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -6,9 +6,11 @@
 
 #include <errno.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
+#include <stdbool.h>
 
 #include "../kselftest.h"
 
@@ -64,6 +66,59 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/*
+ * Returns false if the requested remap region overlaps with an
+ * existing mapping (e.g text, stack) else returns true.
+ */
+static bool is_remap_region_valid(void *addr, unsigned long long size)
+{
+	void *remap_addr = NULL;
+	bool ret = true;
+
+	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
+	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
+					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					 -1, 0);
+
+	if (remap_addr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ret = false;
+	} else {
+		munmap(remap_addr, size);
+	}
+
+	return ret;
+}
+
+/* Returns mmap_min_addr sysctl tunable from procfs */
+static unsigned long long get_mmap_min_addr(void)
+{
+	FILE *fp;
+	int n_matched;
+	static unsigned long long addr;
+
+	if (addr)
+		return addr;
+
+	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
+	if (fp == NULL) {
+		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		exit(KSFT_SKIP);
+	}
+
+	n_matched = fscanf(fp, "%llu", &addr);
+	if (n_matched != 1) {
+		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		fclose(fp);
+		exit(KSFT_SKIP);
+	}
+
+	fclose(fp);
+	return addr;
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -72,11 +127,18 @@ static void *get_source_mapping(struct config c)
 {
 	unsigned long long addr = 0ULL;
 	void *src_addr = NULL;
+	unsigned long long mmap_min_addr;
+
+	mmap_min_addr = get_mmap_min_addr();
+
 retry:
 	addr += c.src_alignment;
+	if (addr < mmap_min_addr)
+		goto retry;
+
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-			-1, 0);
+					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					-1, 0);
 	if (src_addr == MAP_FAILED) {
 		if (errno == EPERM || errno == EEXIST)
 			goto retry;
@@ -91,8 +153,10 @@ static void *get_source_mapping(struct config c)
 	 * alignment in the tests.
 	 */
 	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment))
+			!((unsigned long long) src_addr & c.src_alignment)) {
+		munmap(src_addr, c.region_size);
 		goto retry;
+	}
 
 	if (!src_addr)
 		goto error;
@@ -141,9 +205,20 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
+	/* Don't destroy existing mappings unless expected to overlap */
+	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+		/* Check for unsigned overflow */
+		if (addr + c.dest_alignment < addr) {
+			ksft_print_msg("Couldn't find a valid region to remap to\n");
+			ret = -1;
+			goto out;
+		}
+		addr += c.dest_alignment;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
-			MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
+					  MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
 	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
