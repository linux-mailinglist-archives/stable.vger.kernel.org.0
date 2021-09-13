Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154E8409606
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346960AbhIMOrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345099AbhIMOpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711646322F;
        Mon, 13 Sep 2021 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541491;
        bh=/5WfoIA9trcOShL0r1epCZXNrnIgRJUNluHQwvKt0E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDsuAnSC16fEyLomC5VYliX2Ud/L3NFadU/jY0H95oZfCLJ7NH66jqZJH6CSnJFT5
         wgtNwa9T6xJn7ryCbxYG/03IrZW54uY8ihr8AzK/R0anQFsUTfIx22txRLTJqJfSb/
         xL/9Dy64Fh0NEoOFYpokRj+Dlo8m6jQf4gCBHyQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.14 319/334] ARM: dts: at91: add pinctrl-{names, 0} for all gpios
Date:   Mon, 13 Sep 2021 15:16:13 +0200
Message-Id: <20210913131124.216533388@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit bf781869e5cf3e4ec1a47dad69b6f0df97629cbd upstream.

Add pinctrl-names and pinctrl-0 properties on controllers that claims to
use pins to avoid failures due to
commit 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
and also to avoid using pins that may be claimed my other IPs.

Fixes: b7c2b6157079 ("ARM: at91: add Atmel's SAMA5D3 Xplained board")
Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Fixes: 38153a017896 ("ARM: at91/dt: sama5d4: add dts for sama5d4 xplained board")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210727074006.1609989-1-claudiu.beznea@microchip.com
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts        |   16 ++++++++++++++-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts |   29 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts |   19 ++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -92,6 +92,8 @@
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
 		status = "okay"; /* Conflict with pwm0. */
 
 		red {
@@ -537,6 +539,10 @@
 				 AT91_PIOA 19 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)	/* PA19 DAT2 periph A with pullup */
 				 AT91_PIOA 20 AT91_PERIPH_A (AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DRIVE_STRENGTH_HI)>;	/* PA20 DAT3 periph A with pullup */
 		};
+		pinctrl_sdmmc0_cd: sdmmc0_cd {
+			atmel,pins =
+				<AT91_PIOA 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+		};
 	};
 
 	sdmmc1 {
@@ -569,6 +575,14 @@
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
@@ -580,7 +594,7 @@
 &sdmmc0 {
 	bus-width = <4>;
 	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_sdmmc0_default>;
+	pinctrl-0 = <&pinctrl_sdmmc0_default &pinctrl_sdmmc0_cd>;
 	status = "okay";
 	cd-gpios = <&pioA 23 GPIO_ACTIVE_LOW>;
 	disable-wp;
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -57,6 +57,8 @@
 			};
 
 			spi0: spi@f0004000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
 				status = "okay";
 			};
@@ -169,6 +171,8 @@
 			};
 
 			spi1: spi@f8008000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioC 25 0>;
 				status = "okay";
 			};
@@ -248,6 +252,26 @@
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
@@ -339,6 +363,8 @@
 
 	vcc_mmc0_reg: fixedregulator_mmc0 {
 		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_vcc_mmc0_reg_gpio>;
 		gpio = <&pioE 2 GPIO_ACTIVE_LOW>;
 		regulator-name = "mmc0-card-supply";
 		regulator-min-microvolt = <3300000>;
@@ -362,6 +388,9 @@
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
+		status = "okay";
 
 		d2 {
 			label = "d2";
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -90,6 +90,8 @@
 			};
 
 			spi1: spi@fc018000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioB 21 0>;
 				status = "okay";
 			};
@@ -147,6 +149,19 @@
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
@@ -252,6 +267,8 @@
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpio_leds>;
 		status = "okay";
 
 		d8 {
@@ -278,6 +295,8 @@
 
 	vcc_mmc1_reg: fixedregulator_mmc1 {
 		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_vcc_mmc1_reg>;
 		gpio = <&pioE 4 GPIO_ACTIVE_LOW>;
 		regulator-name = "VDD MCI1";
 		regulator-min-microvolt = <3300000>;


