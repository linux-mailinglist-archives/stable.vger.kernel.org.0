Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A95BE3FD
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiITK5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiITK53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414DC5F9A1;
        Tue, 20 Sep 2022 03:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6CDB81C6D;
        Tue, 20 Sep 2022 10:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3657C433D6;
        Tue, 20 Sep 2022 10:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663671442;
        bh=fj1CCPIhvQEFkFNurpZaT7vGu43n+NbysVAVKs36J68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnNyQ/3nj5yDsD4F4LztcXDxHwtE9NMcP949R2h7L8/VUMxAYfz/ZH23YKZMcriLW
         3RmU1SOoqZPQUzvW2EtNNYJoZEsIOV4UTvzBYyNUz4oR/fjeccD3n+/Wv1Xbnukgir
         /+VcW5d6JWHXkPs+5sMXUY9dtcD0SeKPHH81JIUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.69
Date:   Tue, 20 Sep 2022 12:57:46 +0200
Message-Id: <166367146537196@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <1663671465161217@kroah.com>
References: <1663671465161217@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml b/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
index b6bbc312a7cf..1414ba9977c1 100644
--- a/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
+++ b/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
@@ -24,8 +24,10 @@ properties:
 
   interrupts:
     minItems: 1
+    maxItems: 2
     description:
       Should be configured with type IRQ_TYPE_EDGE_RISING.
+      If two interrupts are provided, expected order is INT1 and INT2.
 
 required:
   - compatible
diff --git a/Documentation/input/joydev/joystick.rst b/Documentation/input/joydev/joystick.rst
index f615906a0821..6d721396717a 100644
--- a/Documentation/input/joydev/joystick.rst
+++ b/Documentation/input/joydev/joystick.rst
@@ -517,6 +517,7 @@ All I-Force devices are supported by the iforce module. This includes:
 * AVB Mag Turbo Force
 * AVB Top Shot Pegasus
 * AVB Top Shot Force Feedback Racing Wheel
+* Boeder Force Feedback Wheel
 * Logitech WingMan Force
 * Logitech WingMan Force Wheel
 * Guillemot Race Leader Force Feedback
diff --git a/Makefile b/Makefile
index d6b672375c07..2134d5711dcc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 68
+SUBLEVEL = 69
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index bac0e49cc577..2038e387be28 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -169,8 +169,8 @@ mcp16502@5b {
 			regulators {
 				vdd_3v3: VDD_IO {
 					regulator-name = "VDD_IO";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -188,8 +188,8 @@ regulator-state-mem {
 
 				vddioddr: VDD_DDR {
 					regulator-name = "VDD_DDR";
-					regulator-min-microvolt = <1300000>;
-					regulator-max-microvolt = <1450000>;
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -209,8 +209,8 @@ regulator-state-mem {
 
 				vddcore: VDD_CORE {
 					regulator-name = "VDD_CORE";
-					regulator-min-microvolt = <1100000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1150000>;
+					regulator-max-microvolt = <1150000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -228,8 +228,8 @@ regulator-state-mem {
 
 				vddcpu: VDD_OTHER {
 					regulator-name = "VDD_OTHER";
-					regulator-min-microvolt = <1125000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-ramp-delay = <3125>;
@@ -248,8 +248,8 @@ regulator-state-mem {
 
 				vldo1: LDO1 {
 					regulator-name = "LDO1";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
 
 					regulator-state-standby {
diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
index 7e2b0f198dfa..1053b7c584d8 100644
--- a/arch/arm/boot/dts/imx28-evk.dts
+++ b/arch/arm/boot/dts/imx28-evk.dts
@@ -129,7 +129,7 @@ ssp2: spi@80014000 {
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "sst,sst25vf016b", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx28-m28evk.dts b/arch/arm/boot/dts/imx28-m28evk.dts
index f3bddc5ada4b..13acdc7916b9 100644
--- a/arch/arm/boot/dts/imx28-m28evk.dts
+++ b/arch/arm/boot/dts/imx28-m28evk.dts
@@ -33,7 +33,7 @@ ssp2: spi@80014000 {
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "m25p80", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx28-sps1.dts b/arch/arm/boot/dts/imx28-sps1.dts
index 43be7a6a769b..90928db0df70 100644
--- a/arch/arm/boot/dts/imx28-sps1.dts
+++ b/arch/arm/boot/dts/imx28-sps1.dts
@@ -51,7 +51,7 @@ ssp2: spi@80014000 {
 				pinctrl-0 = <&spi2_pins_a>;
 				status = "okay";
 
-				flash: m25p80@0 {
+				flash: flash@0 {
 					#address-cells = <1>;
 					#size-cells = <1>;
 					compatible = "everspin,mr25h256", "mr25h256";
diff --git a/arch/arm/boot/dts/imx6dl-rex-basic.dts b/arch/arm/boot/dts/imx6dl-rex-basic.dts
index 0f1616bfa9a8..b72f8ea1e6f6 100644
--- a/arch/arm/boot/dts/imx6dl-rex-basic.dts
+++ b/arch/arm/boot/dts/imx6dl-rex-basic.dts
@@ -19,7 +19,7 @@ memory@10000000 {
 };
 
 &ecspi3 {
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
index 6330d75f8f39..f266f1b7e0cf 100644
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
@@ -142,7 +142,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: n25q032@0 {
+	flash: flash@0 {
 		compatible = "jedec,spi-nor";
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6q-bx50v3.dtsi b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
index 10922375c51e..ead83091e193 100644
--- a/arch/arm/boot/dts/imx6q-bx50v3.dtsi
+++ b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
@@ -160,7 +160,7 @@ &ecspi5 {
 	pinctrl-0 = <&pinctrl_ecspi5>;
 	status = "okay";
 
-	m25_eeprom: m25p80@0 {
+	m25_eeprom: flash@0 {
 		compatible = "atmel,at25";
 		spi-max-frequency = <10000000>;
 		size = <0x8000>;
diff --git a/arch/arm/boot/dts/imx6q-cm-fx6.dts b/arch/arm/boot/dts/imx6q-cm-fx6.dts
index bfb530f29d9d..1ad41c944b4b 100644
--- a/arch/arm/boot/dts/imx6q-cm-fx6.dts
+++ b/arch/arm/boot/dts/imx6q-cm-fx6.dts
@@ -260,7 +260,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	m25p80@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
index c713ac03b3b9..9591848cbd37 100644
--- a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
+++ b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
@@ -102,7 +102,7 @@ &ecspi5 {
 	cs-gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "m25p80", "jedec,spi-nor";
 		spi-max-frequency = <40000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-dms-ba16.dts b/arch/arm/boot/dts/imx6q-dms-ba16.dts
index 48fb47e715f6..137db38f0d27 100644
--- a/arch/arm/boot/dts/imx6q-dms-ba16.dts
+++ b/arch/arm/boot/dts/imx6q-dms-ba16.dts
@@ -47,7 +47,7 @@ &ecspi5 {
 	pinctrl-0 = <&pinctrl_ecspi5>;
 	status = "okay";
 
-	m25_eeprom: m25p80@0 {
+	m25_eeprom: flash@0 {
 		compatible = "atmel,at25256B", "atmel,at25";
 		spi-max-frequency = <20000000>;
 		size = <0x8000>;
diff --git a/arch/arm/boot/dts/imx6q-gw5400-a.dts b/arch/arm/boot/dts/imx6q-gw5400-a.dts
index 4cde45d5c90c..e894faba571f 100644
--- a/arch/arm/boot/dts/imx6q-gw5400-a.dts
+++ b/arch/arm/boot/dts/imx6q-gw5400-a.dts
@@ -137,7 +137,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,w25q256", "jedec,spi-nor";
 		spi-max-frequency = <30000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/imx6q-marsboard.dts
index 05ee28388229..cc1801002394 100644
--- a/arch/arm/boot/dts/imx6q-marsboard.dts
+++ b/arch/arm/boot/dts/imx6q-marsboard.dts
@@ -100,7 +100,7 @@ &ecspi1 {
 	cs-gpios = <&gpio2 30 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	m25p80@0 {
+	flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6q-rex-pro.dts b/arch/arm/boot/dts/imx6q-rex-pro.dts
index 1767e1a3cd53..271f4b2d9b9f 100644
--- a/arch/arm/boot/dts/imx6q-rex-pro.dts
+++ b/arch/arm/boot/dts/imx6q-rex-pro.dts
@@ -19,7 +19,7 @@ memory@10000000 {
 };
 
 &ecspi3 {
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf032b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
index e21f6ac864e5..baa197c90060 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos.dtsi
@@ -96,7 +96,7 @@ &ecspi4 {
 	pinctrl-0 = <&pinctrl_ecspi4>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q128a11", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
index 563bf9d44fe0..2ba577e602e7 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
@@ -131,7 +131,7 @@ &ecspi4 {
 	pinctrl-0 = <&pinctrl_ecspi4>;
 	status = "okay";
 
-	flash: m25p80@1 {
+	flash: flash@1 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q128a11", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi b/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
index 648f5fcb72e6..2c1d6f28e695 100644
--- a/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi
@@ -35,7 +35,7 @@ &ecspi3 {
 	pinctrl-0 = <&pinctrl_ecspi3>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "sst,sst25vf040b", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 9a3e5f782715..6b791d515e29 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -248,8 +248,8 @@ &ecspi4 {
 	status = "okay";
 
 	/* default boot source: workaround #1 for errata ERR006282 */
-	smarc_flash: spi-flash@0 {
-		compatible = "winbond,w25q16dw", "jedec,spi-nor";
+	smarc_flash: flash@0 {
+		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <20000000>;
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
index ac34709e9741..0ad4cb4f1e82 100644
--- a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
@@ -179,7 +179,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
index c96f4d7e1e0d..beaa2dcd436c 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
@@ -321,7 +321,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
index 92d09a3ebe0e..ee7e2371f94b 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi
@@ -252,7 +252,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 49da30d7510c..904d5d051d63 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -237,7 +237,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 5e58740d40c5..1368a4762037 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -272,7 +272,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1 &pinctrl_ecspi1_cs>;
 	status = "disabled"; /* pin conflict with WEIM NOR */
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index eb9a0b104f1c..901b9a761b66 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -313,7 +313,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "sst,sst25vf016b", "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 0c0105468a2f..37482a9023fc 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -197,7 +197,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
index 25f6f2fb1555..f16c830f1e91 100644
--- a/arch/arm/boot/dts/imx6sl-evk.dts
+++ b/arch/arm/boot/dts/imx6sl-evk.dts
@@ -137,7 +137,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "st,m25p32", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
index 66af78e83b70..a2c79bcf9a11 100644
--- a/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
+++ b/arch/arm/boot/dts/imx6sx-nitrogen6sx.dts
@@ -107,7 +107,7 @@ &ecspi1 {
 	pinctrl-0 = <&pinctrl_ecspi1>;
 	status = "okay";
 
-	flash: m25p80@0 {
+	flash: flash@0 {
 		compatible = "microchip,sst25vf016b";
 		spi-max-frequency = <20000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6sx-sdb-reva.dts b/arch/arm/boot/dts/imx6sx-sdb-reva.dts
index dce5dcf96c25..7dda42553f4b 100644
--- a/arch/arm/boot/dts/imx6sx-sdb-reva.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb-reva.dts
@@ -123,7 +123,7 @@ &qspi2 {
 	pinctrl-0 = <&pinctrl_qspi2>;
 	status = "okay";
 
-	flash0: s25fl128s@0 {
+	flash0: flash@0 {
 		reg = <0>;
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -133,7 +133,7 @@ flash0: s25fl128s@0 {
 		spi-tx-bus-width = <4>;
 	};
 
-	flash1: s25fl128s@2 {
+	flash1: flash@2 {
 		reg = <2>;
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
index 99f4cf777a38..969cfe920d25 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb.dts
@@ -108,7 +108,7 @@ &qspi2 {
 	pinctrl-0 = <&pinctrl_qspi2>;
 	status = "okay";
 
-	flash0: n25q256a@0 {
+	flash0: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
@@ -118,7 +118,7 @@ flash0: n25q256a@0 {
 		reg = <0>;
 	};
 
-	flash1: n25q256a@2 {
+	flash1: flash@2 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index a3fde3316c73..1a18c41ce385 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -286,7 +286,7 @@ &qspi {
 	pinctrl-0 = <&pinctrl_qspi>;
 	status = "okay";
 
-	flash0: n25q256a@0 {
+	flash0: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "micron,n25q256a", "jedec,spi-nor";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
index 47d3ce5d255f..acd936540d89 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi
@@ -19,7 +19,7 @@ memory@80000000 {
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
index a095a7654ac6..29ed38dce580 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi
@@ -18,7 +18,7 @@ memory@80000000 {
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
index 2a449a3c1ae2..09a83dbdf651 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi
@@ -19,7 +19,7 @@ &ecspi2 {
 	pinctrl-0 = <&pinctrl_ecspi2>;
 	status = "okay";
 
-	spi-flash@0 {
+	flash@0 {
 		compatible = "mxicy,mx25v8035f", "jedec,spi-nor";
 		spi-max-frequency = <50000000>;
 		reg = <0>;
diff --git a/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi b/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
index b7e984284e1a..d000606c0704 100644
--- a/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
+++ b/arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi
@@ -18,7 +18,7 @@ memory@80000000 {
 };
 
 &qspi {
-	spi-flash@0 {
+	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "spi-nand";
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 32f9796c4ffe..60225bc09b01 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -72,7 +72,7 @@ static __always_inline void __exit_to_kernel_mode(struct pt_regs *regs)
 	if (interrupts_enabled(regs)) {
 		if (regs->exit_rcu) {
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
 			return;
@@ -117,7 +117,7 @@ static __always_inline void enter_from_user_mode(struct pt_regs *regs)
 static __always_inline void __exit_to_user_mode(void)
 {
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	user_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
@@ -175,7 +175,7 @@ static void noinstr arm64_exit_nmi(struct pt_regs *regs)
 	ftrace_nmi_exit();
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
@@ -211,7 +211,7 @@ static void noinstr arm64_exit_el1_dbg(struct pt_regs *regs)
 
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index dd5ea1bdf04c..75efc4c6f076 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -143,7 +143,7 @@ extern void cea_set_pte(void *cea_vaddr, phys_addr_t pa, pgprot_t flags);
 
 extern struct cpu_entry_area *get_cpu_entry_area(int cpu);
 
-static inline struct entry_stack *cpu_entry_stack(int cpu)
+static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 {
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 4bde0dc66100..56891399fa2a 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -15,7 +15,7 @@ extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
 
-static inline unsigned long __phys_addr_nodebug(unsigned long x)
+static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
 	unsigned long y = x - __START_KERNEL_map;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4d6f7a70bdd1..cd0c93ec72fa 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -26,7 +26,7 @@ static __always_inline void kvm_guest_enter_irqoff(void)
 	 */
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_enter_irqoff();
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 3c25ce8c95ba..19358a641610 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -416,6 +416,16 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 {
 	int i;
 
+#ifdef CONFIG_X86
+	/*
+	 * IRQ override isn't needed on modern AMD Zen systems and
+	 * this override breaks active low IRQs on AMD Ryzen 6000 and
+	 * newer systems. Skip it.
+	 */
+	if (boot_cpu_has(X86_FEATURE_ZEN))
+		return false;
+#endif
+
 	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
 		const struct irq_override_cmp *entry = &skip_override_table[i];
 
diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index d26bff29157b..369a832d9620 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -373,6 +373,13 @@ static void gpio_mockup_debugfs_setup(struct device *dev,
 	}
 }
 
+static void gpio_mockup_debugfs_cleanup(void *data)
+{
+	struct gpio_mockup_chip *chip = data;
+
+	debugfs_remove_recursive(chip->dbg_dir);
+}
+
 static void gpio_mockup_dispose_mappings(void *data)
 {
 	struct gpio_mockup_chip *chip = data;
@@ -455,7 +462,7 @@ static int gpio_mockup_probe(struct platform_device *pdev)
 
 	gpio_mockup_debugfs_setup(dev, chip);
 
-	return 0;
+	return devm_add_action_or_reset(dev, gpio_mockup_debugfs_cleanup, chip);
 }
 
 static const struct of_device_id gpio_mockup_of_match[] = {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 5b41c29f3ed5..65744c3bd364 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2505,7 +2505,7 @@ static int psp_load_smu_fw(struct psp_context *psp)
 static bool fw_load_skip_check(struct psp_context *psp,
 			       struct amdgpu_firmware_info *ucode)
 {
-	if (!ucode->fw)
+	if (!ucode->fw || !ucode->ucode_size)
 		return true;
 
 	if (ucode->ucode_id == AMDGPU_UCODE_ID_SMC &&
diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index b55398a34fa4..e3f0dd4a3679 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -191,6 +191,9 @@ static int rd_open(struct inode *inode, struct file *file)
 	file->private_data = rd;
 	rd->open = true;
 
+	/* Reset fifo to clear any previously unread data: */
+	rd->fifo.head = rd->fifo.tail = 0;
+
 	/* the parsing tools need to know gpu-id to know which
 	 * register database to load.
 	 */
diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
index 6a5cc11aefd8..35dddc5015b3 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.h
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.h
@@ -105,7 +105,7 @@ struct report_list {
  * @multi_packet_cnt:	Count of fragmented packet count
  *
  * This structure is used to store completion flags and per client data like
- * like report description, number of HID devices etc.
+ * report description, number of HID devices etc.
  */
 struct ishtp_cl_data {
 	/* completion flags */
diff --git a/drivers/hid/intel-ish-hid/ishtp/client.c b/drivers/hid/intel-ish-hid/ishtp/client.c
index 405e0d5212cc..df0a825694f5 100644
--- a/drivers/hid/intel-ish-hid/ishtp/client.c
+++ b/drivers/hid/intel-ish-hid/ishtp/client.c
@@ -626,13 +626,14 @@ static void ishtp_cl_read_complete(struct ishtp_cl_rb *rb)
 }
 
 /**
- * ipc_tx_callback() - IPC tx callback function
+ * ipc_tx_send() - IPC tx send function
  * @prm: Pointer to client device instance
  *
- * Send message over IPC either first time or on callback on previous message
- * completion
+ * Send message over IPC. Message will be split into fragments
+ * if message size is bigger than IPC FIFO size, and all
+ * fragments will be sent one by one.
  */
-static void ipc_tx_callback(void *prm)
+static void ipc_tx_send(void *prm)
 {
 	struct ishtp_cl	*cl = prm;
 	struct ishtp_cl_tx_ring	*cl_msg;
@@ -677,32 +678,41 @@ static void ipc_tx_callback(void *prm)
 			    list);
 	rem = cl_msg->send_buf.size - cl->tx_offs;
 
-	ishtp_hdr.host_addr = cl->host_client_id;
-	ishtp_hdr.fw_addr = cl->fw_client_id;
-	ishtp_hdr.reserved = 0;
-	pmsg = cl_msg->send_buf.data + cl->tx_offs;
+	while (rem > 0) {
+		ishtp_hdr.host_addr = cl->host_client_id;
+		ishtp_hdr.fw_addr = cl->fw_client_id;
+		ishtp_hdr.reserved = 0;
+		pmsg = cl_msg->send_buf.data + cl->tx_offs;
+
+		if (rem <= dev->mtu) {
+			/* Last fragment or only one packet */
+			ishtp_hdr.length = rem;
+			ishtp_hdr.msg_complete = 1;
+			/* Submit to IPC queue with no callback */
+			ishtp_write_message(dev, &ishtp_hdr, pmsg);
+			cl->tx_offs = 0;
+			cl->sending = 0;
 
-	if (rem <= dev->mtu) {
-		ishtp_hdr.length = rem;
-		ishtp_hdr.msg_complete = 1;
-		cl->sending = 0;
-		list_del_init(&cl_msg->list);	/* Must be before write */
-		spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
-		/* Submit to IPC queue with no callback */
-		ishtp_write_message(dev, &ishtp_hdr, pmsg);
-		spin_lock_irqsave(&cl->tx_free_list_spinlock, tx_free_flags);
-		list_add_tail(&cl_msg->list, &cl->tx_free_list.list);
-		++cl->tx_ring_free_size;
-		spin_unlock_irqrestore(&cl->tx_free_list_spinlock,
-			tx_free_flags);
-	} else {
-		/* Send IPC fragment */
-		spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
-		cl->tx_offs += dev->mtu;
-		ishtp_hdr.length = dev->mtu;
-		ishtp_hdr.msg_complete = 0;
-		ishtp_send_msg(dev, &ishtp_hdr, pmsg, ipc_tx_callback, cl);
+			break;
+		} else {
+			/* Send ipc fragment */
+			ishtp_hdr.length = dev->mtu;
+			ishtp_hdr.msg_complete = 0;
+			/* All fregments submitted to IPC queue with no callback */
+			ishtp_write_message(dev, &ishtp_hdr, pmsg);
+			cl->tx_offs += dev->mtu;
+			rem = cl_msg->send_buf.size - cl->tx_offs;
+		}
 	}
+
+	list_del_init(&cl_msg->list);
+	spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
+
+	spin_lock_irqsave(&cl->tx_free_list_spinlock, tx_free_flags);
+	list_add_tail(&cl_msg->list, &cl->tx_free_list.list);
+	++cl->tx_ring_free_size;
+	spin_unlock_irqrestore(&cl->tx_free_list_spinlock,
+		tx_free_flags);
 }
 
 /**
@@ -720,7 +730,7 @@ static void ishtp_cl_send_msg_ipc(struct ishtp_device *dev,
 		return;
 
 	cl->tx_offs = 0;
-	ipc_tx_callback(cl);
+	ipc_tx_send(cl);
 	++cl->send_msg_cnt_ipc;
 }
 
diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 7e6c3ba8df6a..aecd64a7dbba 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -501,7 +501,8 @@ enum irdma_status_code irdma_uk_send(struct irdma_qp_uk *qp,
 			      FIELD_PREP(IRDMAQPSQ_IMMDATA, info->imm_data));
 		i = 0;
 	} else {
-		qp->wqe_ops.iw_set_fragment(wqe, 0, op_info->sg_list,
+		qp->wqe_ops.iw_set_fragment(wqe, 0,
+					    frag_cnt ? op_info->sg_list : NULL,
 					    qp->swqe_polarity);
 		i = 1;
 	}
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index b2a68bc9f0b4..b86de1312512 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -50,6 +50,7 @@ static struct iforce_device iforce_device[] = {
 	{ 0x046d, 0xc291, "Logitech WingMan Formula Force",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x020a, "AVB Top Shot Pegasus",			btn_joystick_avb, abs_avb_pegasus, ff_iforce },
 	{ 0x05ef, 0x8884, "AVB Mag Turbo Force",			btn_wheel, abs_wheel, ff_iforce },
+	{ 0x05ef, 0x8886, "Boeder Force Feedback Wheel",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x8888, "AVB Top Shot Force Feedback Racing Wheel",	btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc0a4, "ACT LABS Force RS",                          btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc084, "ACT LABS Force RS",				btn_wheel, abs_wheel, ff_iforce },
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 3667f7e51fde..9a9deea51163 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -94,6 +94,7 @@ static const struct goodix_chip_data gt9x_chip_data = {
 
 static const struct goodix_chip_id goodix_chip_ids[] = {
 	{ .id = "1151", .data = &gt1x_chip_data },
+	{ .id = "1158", .data = &gt1x_chip_data },
 	{ .id = "5663", .data = &gt1x_chip_data },
 	{ .id = "5688", .data = &gt1x_chip_data },
 	{ .id = "917S", .data = &gt1x_chip_data },
@@ -1362,6 +1363,7 @@ MODULE_DEVICE_TABLE(acpi, goodix_acpi_match);
 #ifdef CONFIG_OF
 static const struct of_device_id goodix_of_match[] = {
 	{ .compatible = "goodix,gt1151" },
+	{ .compatible = "goodix,gt1158" },
 	{ .compatible = "goodix,gt5663" },
 	{ .compatible = "goodix,gt5688" },
 	{ .compatible = "goodix,gt911" },
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index bc5444daca9b..2affdccb58e4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -191,38 +191,6 @@ static phys_addr_t root_entry_uctp(struct root_entry *re)
 	return re->hi & VTD_PAGE_MASK;
 }
 
-static inline void context_clear_pasid_enable(struct context_entry *context)
-{
-	context->lo &= ~(1ULL << 11);
-}
-
-static inline bool context_pasid_enabled(struct context_entry *context)
-{
-	return !!(context->lo & (1ULL << 11));
-}
-
-static inline void context_set_copied(struct context_entry *context)
-{
-	context->hi |= (1ull << 3);
-}
-
-static inline bool context_copied(struct context_entry *context)
-{
-	return !!(context->hi & (1ULL << 3));
-}
-
-static inline bool __context_present(struct context_entry *context)
-{
-	return (context->lo & 1);
-}
-
-bool context_present(struct context_entry *context)
-{
-	return context_pasid_enabled(context) ?
-	     __context_present(context) :
-	     __context_present(context) && !context_copied(context);
-}
-
 static inline void context_set_present(struct context_entry *context)
 {
 	context->lo |= 1;
@@ -270,6 +238,26 @@ static inline void context_clear_entry(struct context_entry *context)
 	context->hi = 0;
 }
 
+static inline bool context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	if (!iommu->copied_tables)
+		return false;
+
+	return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
+static inline void
+set_context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	set_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
+static inline void
+clear_context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	clear_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
 /*
  * This domain is a statically identity mapping domain.
  *	1. This domain creats a static 1:1 mapping to all usable memory.
@@ -792,6 +780,13 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 	struct context_entry *context;
 	u64 *entry;
 
+	/*
+	 * Except that the caller requested to allocate a new entry,
+	 * returning a copied context entry makes no sense.
+	 */
+	if (!alloc && context_copied(iommu, bus, devfn))
+		return NULL;
+
 	entry = &root->lo;
 	if (sm_supported(iommu)) {
 		if (devfn >= 0x80) {
@@ -1899,6 +1894,11 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 		iommu->domain_ids = NULL;
 	}
 
+	if (iommu->copied_tables) {
+		bitmap_free(iommu->copied_tables);
+		iommu->copied_tables = NULL;
+	}
+
 	g_iommus[iommu->seq_id] = NULL;
 
 	/* free context mapping */
@@ -2107,7 +2107,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		goto out_unlock;
 
 	ret = 0;
-	if (context_present(context))
+	if (context_present(context) && !context_copied(iommu, bus, devfn))
 		goto out_unlock;
 
 	/*
@@ -2119,7 +2119,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	 * in-flight DMA will exist, and we don't need to worry anymore
 	 * hereafter.
 	 */
-	if (context_copied(context)) {
+	if (context_copied(iommu, bus, devfn)) {
 		u16 did_old = context_domain_id(context);
 
 		if (did_old < cap_ndoms(iommu->cap)) {
@@ -2130,6 +2130,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 			iommu->flush.flush_iotlb(iommu, did_old, 0, 0,
 						 DMA_TLB_DSI_FLUSH);
 		}
+
+		clear_context_copied(iommu, bus, devfn);
 	}
 
 	context_clear_entry(context);
@@ -3024,32 +3026,14 @@ static int copy_context_table(struct intel_iommu *iommu,
 		/* Now copy the context entry */
 		memcpy(&ce, old_ce + idx, sizeof(ce));
 
-		if (!__context_present(&ce))
+		if (!context_present(&ce))
 			continue;
 
 		did = context_domain_id(&ce);
 		if (did >= 0 && did < cap_ndoms(iommu->cap))
 			set_bit(did, iommu->domain_ids);
 
-		/*
-		 * We need a marker for copied context entries. This
-		 * marker needs to work for the old format as well as
-		 * for extended context entries.
-		 *
-		 * Bit 67 of the context entry is used. In the old
-		 * format this bit is available to software, in the
-		 * extended format it is the PGE bit, but PGE is ignored
-		 * by HW if PASIDs are disabled (and thus still
-		 * available).
-		 *
-		 * So disable PASIDs first and then mark the entry
-		 * copied. This means that we don't copy PASID
-		 * translations from the old kernel, but this is fine as
-		 * faults there are not fatal.
-		 */
-		context_clear_pasid_enable(&ce);
-		context_set_copied(&ce);
-
+		set_context_copied(iommu, bus, devfn);
 		new_ce[idx] = ce;
 	}
 
@@ -3076,8 +3060,8 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	bool new_ext, ext;
 
 	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
-	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
-	new_ext    = !!ecap_ecs(iommu->ecap);
+	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
+	new_ext    = !!sm_supported(iommu);
 
 	/*
 	 * The RTT bit can only be changed when translation is disabled,
@@ -3088,6 +3072,10 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	if (new_ext != ext)
 		return -EINVAL;
 
+	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
+	if (!iommu->copied_tables)
+		return -ENOMEM;
+
 	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
 	if (!old_rt_phys)
 		return -EINVAL;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e0e0e70d801..8aab07419263 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18078,16 +18078,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
 
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
+
 	netif_device_detach(dev);
 
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
-		tg3_power_down(tp);
+	tg3_power_down(tp);
 
 	rtnl_unlock();
+
+	pci_disable_device(pdev);
 }
 
 /**
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 89c046b204e0..4517517215f2 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -504,6 +504,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
 		goto err_tx;
 
 	if (status & CC2520_STATUS_TX_UNDERFLOW) {
+		rc = -EINVAL;
 		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
 		goto err_tx;
 	}
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 889c5433c94d..fba5a77c58d6 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1501,6 +1501,9 @@ static void nvmet_tcp_state_change(struct sock *sk)
 		goto done;
 
 	switch (sk->sk_state) {
+	case TCP_FIN_WAIT2:
+	case TCP_LAST_ACK:
+		break;
 	case TCP_FIN_WAIT1:
 	case TCP_CLOSE_WAIT:
 	case TCP_CLOSE:
diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index 513de1f54e2d..933b96e243b8 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -117,7 +117,7 @@ static int pmu_parse_irqs(struct arm_pmu *pmu)
 
 	if (num_irqs == 1) {
 		int irq = platform_get_irq(pdev, 0);
-		if (irq && irq_is_percpu_devid(irq))
+		if ((irq > 0) && irq_is_percpu_devid(irq))
 			return pmu_parse_percpu_irq(pmu, irq);
 	}
 
diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 1679811eff50..5c0451c56ea8 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -558,6 +558,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 2 */
+	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 694b45ed06a2..8c2a73d5428d 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -99,6 +99,7 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x27, {KEY_HELP} },
 	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
@@ -112,7 +113,13 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_IGNORE, 0x48, {KEY_VOLUMEUP} },
 	{KE_IGNORE, 0x49, {KEY_VOLUMEDOWN} },
 	{KE_IGNORE, 0x4a, {KEY_VOLUMEDOWN} },
-	{KE_IGNORE, 0x61, {KEY_SWITCHVIDEOMODE} },
+	/*
+	 * 0x61 is KEY_SWITCHVIDEOMODE. Usually this is a duplicate input event
+	 * with the "Video Bus" input device events. But sometimes it is not
+	 * a dup. Map it to KEY_UNKNOWN instead of using KE_IGNORE so that
+	 * udev/hwdb can override it on systems where it is not a dup.
+	 */
+	{KE_KEY, 0x61, {KEY_UNKNOWN} },
 	{KE_IGNORE, 0x62, {KEY_BRIGHTNESSUP} },
 	{KE_IGNORE, 0x63, {KEY_BRIGHTNESSDOWN} },
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 4df32bc4c7a6..c5d46152d468 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
 	  buffer management facilities for software to interact with
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 5226a47b68fd..885a7f593d85 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -281,6 +281,12 @@ static struct usb_endpoint_descriptor ss_ep_int_desc = {
 	.bInterval = 4,
 };
 
+static struct usb_ss_ep_comp_descriptor ss_ep_int_desc_comp = {
+	.bLength = sizeof(ss_ep_int_desc_comp),
+	.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
+	.wBytesPerInterval = cpu_to_le16(6),
+};
+
 /* Audio Streaming OUT Interface - Alt0 */
 static struct usb_interface_descriptor std_as_out_if0_desc = {
 	.bLength = sizeof std_as_out_if0_desc,
@@ -594,7 +600,8 @@ static struct usb_descriptor_header *ss_audio_desc[] = {
 	(struct usb_descriptor_header *)&in_feature_unit_desc,
 	(struct usb_descriptor_header *)&io_out_ot_desc,
 
-  (struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc,
+	(struct usb_descriptor_header *)&ss_ep_int_desc_comp,
 
 	(struct usb_descriptor_header *)&std_as_out_if0_desc,
 	(struct usb_descriptor_header *)&std_as_out_if1_desc,
@@ -721,6 +728,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 	struct usb_ss_ep_comp_descriptor *epout_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_desc_comp = NULL;
 	struct usb_ss_ep_comp_descriptor *epin_fback_desc_comp = NULL;
+	struct usb_ss_ep_comp_descriptor *ep_int_desc_comp = NULL;
 	struct usb_endpoint_descriptor *epout_desc;
 	struct usb_endpoint_descriptor *epin_desc;
 	struct usb_endpoint_descriptor *epin_fback_desc;
@@ -748,6 +756,7 @@ static void setup_headers(struct f_uac2_opts *opts,
 		epin_fback_desc = &ss_epin_fback_desc;
 		epin_fback_desc_comp = &ss_epin_fback_desc_comp;
 		ep_int_desc = &ss_ep_int_desc;
+		ep_int_desc_comp = &ss_ep_int_desc_comp;
 	}
 
 	i = 0;
@@ -760,15 +769,15 @@ static void setup_headers(struct f_uac2_opts *opts,
 		headers[i++] = USBDHDR(&out_clk_src_desc);
 		headers[i++] = USBDHDR(&usb_out_it_desc);
 
-    if (FUOUT_EN(opts))
-      headers[i++] = USBDHDR(out_feature_unit_desc);
-  }
+		if (FUOUT_EN(opts))
+			headers[i++] = USBDHDR(out_feature_unit_desc);
+	}
 
 	if (EPIN_EN(opts)) {
 		headers[i++] = USBDHDR(&io_in_it_desc);
 
-    if (FUIN_EN(opts))
-      headers[i++] = USBDHDR(in_feature_unit_desc);
+		if (FUIN_EN(opts))
+			headers[i++] = USBDHDR(in_feature_unit_desc);
 
 		headers[i++] = USBDHDR(&usb_in_ot_desc);
 	}
@@ -776,10 +785,13 @@ static void setup_headers(struct f_uac2_opts *opts,
 	if (EPOUT_EN(opts))
 		headers[i++] = USBDHDR(&io_out_ot_desc);
 
-  if (FUOUT_EN(opts) || FUIN_EN(opts))
-      headers[i++] = USBDHDR(ep_int_desc);
+	if (FUOUT_EN(opts) || FUIN_EN(opts)) {
+		headers[i++] = USBDHDR(ep_int_desc);
+		if (ep_int_desc_comp)
+			headers[i++] = USBDHDR(ep_int_desc_comp);
+	}
 
-  if (EPOUT_EN(opts)) {
+	if (EPOUT_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_out_if0_desc);
 		headers[i++] = USBDHDR(&std_as_out_if1_desc);
 		headers[i++] = USBDHDR(&as_out_hdr_desc);
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 4051c8cd0cd8..23ab3b048d9b 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -62,6 +62,13 @@ UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
+/* Reported-by: Tom Hu <huxiaoying@kylinos.cn> */
+UNUSUAL_DEV(0x0b05, 0x1932, 0x0000, 0x9999,
+		"ASUS",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: David Webb <djw@noc.ac.uk> */
 UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		"Seagate",
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index f2625a372a3a..066e8344934d 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -141,6 +141,8 @@ struct tracefs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
 	umode_t mode;
+	/* Opt_* bitfield. */
+	unsigned int opts;
 };
 
 enum {
@@ -241,6 +243,7 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 	kgid_t gid;
 	char *p;
 
+	opts->opts = 0;
 	opts->mode = TRACEFS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
@@ -275,24 +278,36 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 		 * but traditionally tracefs has ignored all mount options
 		 */
 		}
+
+		opts->opts |= BIT(token);
 	}
 
 	return 0;
 }
 
-static int tracefs_apply_options(struct super_block *sb)
+static int tracefs_apply_options(struct super_block *sb, bool remount)
 {
 	struct tracefs_fs_info *fsi = sb->s_fs_info;
 	struct inode *inode = sb->s_root->d_inode;
 	struct tracefs_mount_opts *opts = &fsi->mount_opts;
 
-	inode->i_mode &= ~S_IALLUGO;
-	inode->i_mode |= opts->mode;
+	/*
+	 * On remount, only reset mode/uid/gid if they were provided as mount
+	 * options.
+	 */
+
+	if (!remount || opts->opts & BIT(Opt_mode)) {
+		inode->i_mode &= ~S_IALLUGO;
+		inode->i_mode |= opts->mode;
+	}
 
-	inode->i_uid = opts->uid;
+	if (!remount || opts->opts & BIT(Opt_uid))
+		inode->i_uid = opts->uid;
 
-	/* Set all the group ids to the mount option */
-	set_gid(sb->s_root, opts->gid);
+	if (!remount || opts->opts & BIT(Opt_gid)) {
+		/* Set all the group ids to the mount option */
+		set_gid(sb->s_root, opts->gid);
+	}
 
 	return 0;
 }
@@ -307,7 +322,7 @@ static int tracefs_remount(struct super_block *sb, int *flags, char *data)
 	if (err)
 		goto fail;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, true);
 
 fail:
 	return err;
@@ -359,7 +374,7 @@ static int trace_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &tracefs_super_operations;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, false);
 
 	return 0;
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 05a65eb155f7..81da7107e3bd 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -196,7 +196,6 @@
 #define ecap_dis(e)		(((e) >> 27) & 0x1)
 #define ecap_nest(e)		(((e) >> 26) & 0x1)
 #define ecap_mts(e)		(((e) >> 25) & 0x1)
-#define ecap_ecs(e)		(((e) >> 24) & 0x1)
 #define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
 #define ecap_max_iotlb_offset(e) (ecap_iotlb_offset(e) + 16)
 #define ecap_coherent(e)	((e) & 0x1)
@@ -264,7 +263,6 @@
 #define DMA_GSTS_CFIS (((u32)1) << 23)
 
 /* DMA_RTADDR_REG */
-#define DMA_RTADDR_RTT (((u64)1) << 11)
 #define DMA_RTADDR_SMT (((u64)1) << 10)
 
 /* CCMD_REG */
@@ -594,6 +592,7 @@ struct intel_iommu {
 #ifdef CONFIG_INTEL_IOMMU
 	unsigned long 	*domain_ids; /* bitmap of domains */
 	struct dmar_domain ***domains; /* ptr to domains */
+	unsigned long	*copied_tables; /* bitmap of copied tables */
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
@@ -713,6 +712,11 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
 }
 
+static inline bool context_present(struct context_entry *context)
+{
+	return (context->lo & 1);
+}
+
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 extern int dmar_find_matched_atsr_unit(struct pci_dev *dev);
 
@@ -806,7 +810,6 @@ static inline void intel_iommu_debugfs_init(void) {}
 #endif /* CONFIG_INTEL_IOMMU_DEBUGFS */
 
 extern const struct attribute_group *intel_iommu_groups[];
-bool context_present(struct context_entry *context);
 struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc);
 
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 600c10da321a..747f40e0c326 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -20,13 +20,13 @@
 #ifdef CONFIG_PROVE_LOCKING
   extern void lockdep_softirqs_on(unsigned long ip);
   extern void lockdep_softirqs_off(unsigned long ip);
-  extern void lockdep_hardirqs_on_prepare(unsigned long ip);
+  extern void lockdep_hardirqs_on_prepare(void);
   extern void lockdep_hardirqs_on(unsigned long ip);
   extern void lockdep_hardirqs_off(unsigned long ip);
 #else
   static inline void lockdep_softirqs_on(unsigned long ip) { }
   static inline void lockdep_softirqs_off(unsigned long ip) { }
-  static inline void lockdep_hardirqs_on_prepare(unsigned long ip) { }
+  static inline void lockdep_hardirqs_on_prepare(void) { }
   static inline void lockdep_hardirqs_on(unsigned long ip) { }
   static inline void lockdep_hardirqs_off(unsigned long ip) { }
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb70dd4ff3b6..38b7e9ab48b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -436,7 +436,7 @@ static __always_inline void guest_state_enter_irqoff(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_context_enter_irqoff();
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 71467d661fb6..5ddc30405f7f 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -593,7 +593,9 @@ bool nfs_commit_end(struct nfs_mds_commit_info *cinfo);
 static inline int
 nfs_have_writebacks(struct inode *inode)
 {
-	return atomic_long_read(&NFS_I(inode)->nrequests) != 0;
+	if (S_ISREG(inode->i_mode))
+		return atomic_long_read(&NFS_I(inode)->nrequests) != 0;
+	return 0;
 }
 
 /*
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index d10150587d81..1009b6b5ce40 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -16,7 +16,7 @@
  * try_get_task_stack() instead.  task_stack_page will return a pointer
  * that could get freed out from under you.
  */
-static inline void *task_stack_page(const struct task_struct *task)
+static __always_inline void *task_stack_page(const struct task_struct *task)
 {
 	return task->stack;
 }
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d5a61d565ad5..998bdb7b8bf7 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -124,7 +124,7 @@ static __always_inline void __exit_to_user_mode(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	user_enter_irqoff();
@@ -412,7 +412,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 			instrumentation_begin();
 			/* Tell the tracer that IRET will enable interrupts */
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			instrumentation_end();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
@@ -465,7 +465,7 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
 	ftrace_nmi_exit();
 	if (irq_state.lockdep) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 	instrumentation_end();
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 120bbdacd58b..e6a282bc1665 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1368,7 +1368,7 @@ static struct lock_list *alloc_list_entry(void)
  */
 static int add_lock_to_list(struct lock_class *this,
 			    struct lock_class *links_to, struct list_head *head,
-			    unsigned long ip, u16 distance, u8 dep,
+			    u16 distance, u8 dep,
 			    const struct lock_trace *trace)
 {
 	struct lock_list *entry;
@@ -3121,19 +3121,15 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance,
-			       calc_dep(prev, next),
-			       *trace);
+			       &hlock_class(prev)->locks_after, distance,
+			       calc_dep(prev, next), *trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance,
-			       calc_depb(prev, next),
-			       *trace);
+			       &hlock_class(next)->locks_before, distance,
+			       calc_depb(prev, next), *trace);
 	if (!ret)
 		return 0;
 
@@ -4224,14 +4220,13 @@ static void __trace_hardirqs_on_caller(void)
 
 /**
  * lockdep_hardirqs_on_prepare - Prepare for enabling interrupts
- * @ip:		Caller address
  *
  * Invoked before a possible transition to RCU idle from exit to user or
  * guest mode. This ensures that all RCU operations are done before RCU
  * stops watching. After the RCU transition lockdep_hardirqs_on() has to be
  * invoked to set the final state.
  */
-void lockdep_hardirqs_on_prepare(unsigned long ip)
+void lockdep_hardirqs_on_prepare(void)
 {
 	if (unlikely(!debug_locks))
 		return;
@@ -4828,8 +4823,7 @@ EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 static void
 print_lock_nested_lock_not_held(struct task_struct *curr,
-				struct held_lock *hlock,
-				unsigned long ip)
+				struct held_lock *hlock)
 {
 	if (!debug_locks_off())
 		return;
@@ -5005,7 +4999,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	chain_key = iterate_chain_key(chain_key, hlock_id(hlock));
 
 	if (nest_lock && !__lock_is_held(nest_lock, -1)) {
-		print_lock_nested_lock_not_held(curr, hlock, ip);
+		print_lock_nested_lock_not_held(curr, hlock);
 		return 0;
 	}
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d17b0a5ce6ac..499a3e286cd0 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -105,7 +105,7 @@ void __cpuidle default_idle_call(void)
 		 * last -- this is very similar to the entry code.
 		 */
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(_THIS_IP_);
+		lockdep_hardirqs_on_prepare();
 		rcu_idle_enter();
 		lockdep_hardirqs_on(_THIS_IP_);
 
diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f4938040c228..1e130da1b742 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -46,7 +46,7 @@ void trace_hardirqs_on(void)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -94,15 +94,15 @@ __visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	lockdep_hardirqs_on(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
+	lockdep_hardirqs_on(caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 NOKPROBE_SYMBOL(trace_hardirqs_on_caller);
 
 __visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
-	lockdep_hardirqs_off(CALLER_ADDR0);
+	lockdep_hardirqs_off(caller_addr);
 
 	if (!this_cpu_read(tracing_irq_cpu)) {
 		this_cpu_write(tracing_irq_cpu, 1);
diff --git a/mm/mmap.c b/mm/mmap.c
index cd1d2680ac58..5c2c7651ca29 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2638,6 +2638,7 @@ static void unmap_region(struct mm_struct *mm,
 {
 	struct vm_area_struct *next = vma_next(mm, prev);
 	struct mmu_gather tlb;
+	struct vm_area_struct *cur_vma;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
@@ -2652,8 +2653,12 @@ static void unmap_region(struct mm_struct *mm,
 	 * concurrent flush in this region has to be coming through the rmap,
 	 * and we synchronize against that using the rmap lock.
 	 */
-	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
-		tlb_flush_mmu(&tlb);
+	for (cur_vma = vma; cur_vma; cur_vma = cur_vma->vm_next) {
+		if ((cur_vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0) {
+			tlb_flush_mmu(&tlb);
+			break;
+		}
+	}
 
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index eb204ad36eee..846588c0070a 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -45,7 +45,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev) {
-		netdev_warn(dev, "Failed to get source port: %d\n", port);
+		netdev_warn_once(dev, "Failed to get source port: %d\n", port);
 		return NULL;
 	}
 
