Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4304E49A986
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345124AbiAYDXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:23:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37874 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382785AbiAXUck (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:32:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8B3EB811F9;
        Mon, 24 Jan 2022 20:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9A6C340E7;
        Mon, 24 Jan 2022 20:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056357;
        bh=qVTsRmkfHHvtcYhP+AfBxHTCm0Hpp40vXIcFjCKm+lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACdPH7SVTfYQySczm/6iwHLto0QBOmhwgY9zPGLPpiCmMynO1HnzOATB3brgA+oDU
         x+OPh+JPWC2XnVvvDB6Xu+CXl5TXjkHGPSm8hlX2IAnG3eBCMtABodSDvMzJ7tNA5j
         +5ArpqqC05FUsi00ax0F3dne4KqByhooTvRxQOyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        "Sicelo A. Mhlongo" <absicsz@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/846] ARM: dts: omap3-n900: Fix lp5523 for multi color
Date:   Mon, 24 Jan 2022 19:39:34 +0100
Message-Id: <20220124184116.738683164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



