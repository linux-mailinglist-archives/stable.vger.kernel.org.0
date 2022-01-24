Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6047449A2E4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385736AbiAXXyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845966AbiAXXOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39976C0A02BA;
        Mon, 24 Jan 2022 13:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAF2DB81188;
        Mon, 24 Jan 2022 21:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1195EC340E4;
        Mon, 24 Jan 2022 21:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059202;
        bh=qVTsRmkfHHvtcYhP+AfBxHTCm0Hpp40vXIcFjCKm+lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZp7poPCKQ3WGkBME7ZwfAARuiNNmLXOML4gKSOCcbP0gIfAbEfQ2qH2eRRZ/X1BH
         eQwnmKQ1j5sWrkdd/J+RaHSPf6aWKJ/7q6msW9jlO/OqwBIBOpZAlpFZ0IkBIFPTOc
         9j/ar9zZIZUGcj1Bj5ZzPburoCYvoNsUxqCJVQjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        "Sicelo A. Mhlongo" <absicsz@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0537/1039] ARM: dts: omap3-n900: Fix lp5523 for multi color
Date:   Mon, 24 Jan 2022 19:38:46 +0100
Message-Id: <20220124184143.330009016@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sicelo A. Mhlongo <absicsz@gmail.com>

[ Upstream commit e9af026a3b24f59d7af4609f73e0ef60a4d6d516 ]

Since the LED multicolor framework support was added in commit
92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
LEDs on this platform stopped working.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Fixes: ac219bf3c9bd ("leds: lp55xx: Convert to use GPIO descriptors")
Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
Signed-off-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 50 +++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 32335d4ce478b..d40c3d2c4914e 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -8,6 +8,7 @@
 
 #include "omap34xx.dtsi"
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/leds/common.h>
 
 /*
  * Default secure signed bootloader (Nokia X-Loader) does not enable L3 firewall
@@ -630,63 +631,92 @@
 	};
 
 	lp5523: lp5523@32 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "national,lp5523";
 		reg = <0x32>;
 		clock-mode = /bits/ 8 <0>; /* LP55XX_CLOCK_AUTO */
-		enable-gpio = <&gpio2 9 GPIO_ACTIVE_HIGH>; /* 41 */
+		enable-gpios = <&gpio2 9 GPIO_ACTIVE_HIGH>; /* 41 */
 
-		chan0 {
+		led@0 {
+			reg = <0>;
 			chan-name = "lp5523:kb1";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 
-		chan1 {
+		led@1 {
+			reg = <1>;
 			chan-name = "lp5523:kb2";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 
-		chan2 {
+		led@2 {
+			reg = <2>;
 			chan-name = "lp5523:kb3";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 
-		chan3 {
+		led@3 {
+			reg = <3>;
 			chan-name = "lp5523:kb4";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 
-		chan4 {
+		led@4 {
+			reg = <4>;
 			chan-name = "lp5523:b";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_BLUE>;
+			function = LED_FUNCTION_STATUS;
 		};
 
-		chan5 {
+		led@5 {
+			reg = <5>;
 			chan-name = "lp5523:g";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_GREEN>;
+			function = LED_FUNCTION_STATUS;
 		};
 
-		chan6 {
+		led@6 {
+			reg = <6>;
 			chan-name = "lp5523:r";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_RED>;
+			function = LED_FUNCTION_STATUS;
 		};
 
-		chan7 {
+		led@7 {
+			reg = <7>;
 			chan-name = "lp5523:kb5";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 
-		chan8 {
+		led@8 {
+			reg = <8>;
 			chan-name = "lp5523:kb6";
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
+			color = <LED_COLOR_ID_WHITE>;
+			function = LED_FUNCTION_KBD_BACKLIGHT;
 		};
 	};
 
-- 
2.34.1



