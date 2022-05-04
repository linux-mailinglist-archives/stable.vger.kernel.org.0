Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6051A683
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbiEDQz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353934AbiEDQxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF4247AD0;
        Wed,  4 May 2022 09:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CD9961744;
        Wed,  4 May 2022 16:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91F5C385A4;
        Wed,  4 May 2022 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682932;
        bh=deIqDv/0Rt/scr+yTil7UlSkLsq1Meot7xNX2NjZ+m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgkjNjJItPEO3bcCeg7VrO5T5KMDPJUpq5zAOMhxhvgq1+YlqbVsc1fg3bDy9flae
         SOdgM6nMnyeCA/UxRX7Z5uSv4W8SFh0RAEVdav17+mMNzcP/qH0j4fvmk1XmbGU5/t
         TUgpeYXCOzinZ8FsiB/PG+3yNC1Mz7JVuVATjhgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/84] ARM: dts: am3517-evm: Fix misc pinmuxing
Date:   Wed,  4 May 2022 18:44:24 +0200
Message-Id: <20220504152930.858173332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 942da3af32b2288e674736eb159d1fc676261691 ]

The bootloader for the AM3517 has previously done much of the pin
muxing, but as the bootloader is moving more and more to a model
based on the device tree, it may no longer automatically mux the
pins, so it is necessary to add the pinmuxing to the Linux device
trees so the respective peripherals can remain functional.

Fixes: 6ed1d7997561 ("ARM: dts: am3517-evm: Add support for UI board and Audio")
Signed-off-by: Adam Ford <aford173@gmail.com>
Message-Id: <20220226214820.747847-1-aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am3517-evm.dts  | 45 +++++++++++++++++++++++++++----
 arch/arm/boot/dts/am3517-som.dtsi |  9 +++++++
 2 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/am3517-evm.dts b/arch/arm/boot/dts/am3517-evm.dts
index a1fd3e63e86e..3db30ce134b9 100644
--- a/arch/arm/boot/dts/am3517-evm.dts
+++ b/arch/arm/boot/dts/am3517-evm.dts
@@ -160,6 +160,8 @@ pwm11: dmtimer-pwm@11 {
 
 	/* HS USB Host PHY on PORT 1 */
 	hsusb1_phy: hsusb1_phy {
+		pinctrl-names = "default";
+		pinctrl-0 = <&hsusb1_rst_pins>;
 		compatible = "usb-nop-xceiv";
 		reset-gpios = <&gpio2 25 GPIO_ACTIVE_LOW>; /* gpio_57 */
 		#phy-cells = <0>;
@@ -167,7 +169,9 @@ hsusb1_phy: hsusb1_phy {
 };
 
 &davinci_emac {
-	     status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_pins>;
+	status = "okay";
 };
 
 &davinci_mdio {
@@ -192,6 +196,8 @@ dpi_out: endpoint {
 };
 
 &i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
 	clock-frequency = <400000>;
 	/* User DIP swithes [1:8] / User LEDS [1:2] */
 	tca6416: gpio@21 {
@@ -204,6 +210,8 @@ tca6416: gpio@21 {
 };
 
 &i2c3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c3_pins>;
 	clock-frequency = <400000>;
 };
 
@@ -222,6 +230,8 @@ &mmc3 {
 };
 
 &usbhshost {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hsusb1_pins>;
 	port1-mode = "ehci-phy";
 };
 
@@ -230,8 +240,35 @@ &usbhsehci {
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
@@ -299,8 +336,6 @@ OMAP3_CORE1_IOPAD(0x20ba, PIN_OUTPUT | MUX_MODE4)	/* gpmc_ncs6.gpio_57 */
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
-- 
2.35.1



