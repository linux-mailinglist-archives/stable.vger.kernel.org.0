Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A28594639
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350497AbiHOWjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351317AbiHOWh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B3B1322E4;
        Mon, 15 Aug 2022 12:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3825A6123B;
        Mon, 15 Aug 2022 19:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED21C433D6;
        Mon, 15 Aug 2022 19:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593062;
        bh=VDHLpJeXgtOYXNXVIclwxev6mqDfXvY9gFVcYGXaWFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ca/s8FF3rsDsF/sXodVIP93SZpOBlmuU1Oe2JQSctLJP+d0cbVeX6yEholuPvcgHz
         ypDWQOC48mY9y9uZW6dKKf0chhIDFFtZ6qDxnTipCMtuCm9/0gaDdZFx9yVG/gSe/y
         B6JKl5+6uqegsrMoq4G2fLhbzRBYkSBWKzDZWjYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0207/1157] ARM: dts: imx7-colibri: move aliases, chosen, extcon and gpio-keys
Date:   Mon, 15 Aug 2022 19:52:43 +0200
Message-Id: <20220815180447.924486635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 0ef1969ea5699b00394e1a8c8c7f927b2d0bc5bb ]

Move aliases, chosen, extcon and gpio-keys to module-level device tree
given they are standard Colibri functionalities.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri-aster.dtsi   | 18 ------------
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi | 31 --------------------
 arch/arm/boot/dts/imx7-colibri.dtsi         | 32 +++++++++++++++++++++
 3 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-colibri-aster.dtsi b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
index 69ee85084ad4..02c49ed686a8 100644
--- a/arch/arm/boot/dts/imx7-colibri-aster.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
@@ -5,24 +5,6 @@
  */
 
 / {
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_gpiokeys>;
-
-		power {
-			label = "Wake-Up";
-			gpios = <&gpio1 1 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
-			linux,code = <KEY_WAKEUP>;
-			debounce-interval = <10>;
-			wakeup-source;
-		};
-	};
-
 	reg_3v3: regulator-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "3.3V";
diff --git a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
index d6775e3c64f1..4cf4107fb642 100644
--- a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
@@ -4,15 +4,6 @@
  */
 
 / {
-	aliases {
-		rtc0 = &rtc;
-		rtc1 = &snvs_rtc;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
 	/* fixed crystal dedicated to mpc258x */
 	clk16m: clk16m {
 		compatible = "fixed-clock";
@@ -20,27 +11,6 @@ clk16m: clk16m {
 		clock-frequency = <16000000>;
 	};
 
-	extcon_usbc_det: usbc-det {
-		compatible = "linux,extcon-usb-gpio";
-		id-gpio = <&gpio7 14 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_usbc_det>;
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_gpiokeys>;
-
-		power {
-			label = "Wake-Up";
-			gpios = <&gpio1 1 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>;
-			linux,code = <KEY_WAKEUP>;
-			debounce-interval = <10>;
-			wakeup-source;
-		};
-	};
-
 	reg_3v3: regulator-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "3.3V";
@@ -148,7 +118,6 @@ &uart3 {
 };
 
 &usbotg1 {
-	extcon = <0>, <&extcon_usbc_det>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/imx7-colibri.dtsi b/arch/arm/boot/dts/imx7-colibri.dtsi
index 4146564c3e4b..79f041988c7b 100644
--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -6,6 +6,11 @@
 #include <dt-bindings/pwm/pwm.h>
 
 / {
+	aliases {
+		rtc0 = &rtc;
+		rtc1 = &snvs_rtc;
+	};
+
 	backlight: backlight {
 		brightness-levels = <0 45 63 88 119 158 203 255>;
 		compatible = "pwm-backlight";
@@ -18,6 +23,32 @@ backlight: backlight {
 		status = "disabled";
 	};
 
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
+	extcon_usbc_det: usbc-det {
+		compatible = "linux,extcon-usb-gpio";
+		debounce = <25>;
+		id-gpio = <&gpio7 14 GPIO_ACTIVE_HIGH>; /* SODIMM 137 / USBC_DET */
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usbc_det>;
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_gpiokeys>;
+
+		wakeup {
+			debounce-interval = <10>;
+			gpios = <&gpio1 1 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>; /* SODIMM 45 */
+			label = "Wake-Up";
+			linux,code = <KEY_WAKEUP>;
+			wakeup-source;
+		};
+	};
+
 	panel_dpi: panel-dpi {
 		backlight = <&backlight>;
 		compatible = "edt,et057090dhu";
@@ -498,6 +529,7 @@ &uart3 {
 
 &usbotg1 {
 	dr_mode = "otg";
+	extcon = <0>, <&extcon_usbc_det>;
 };
 
 &usdhc1 {
-- 
2.35.1



