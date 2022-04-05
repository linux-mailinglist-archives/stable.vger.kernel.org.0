Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636F04F2C48
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350364AbiDEJ5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343987AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9550167DB;
        Tue,  5 Apr 2022 02:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE5961564;
        Tue,  5 Apr 2022 09:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EF9C385A1;
        Tue,  5 Apr 2022 09:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149376;
        bh=6tQ1SmCuXGWeuod34frKtsQaqkmflRErCJOG0nxktR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sW6wtUbwlvwj3Kv87EkyOr6cyBwyM8Q3my0BDaMH7k9q+cO4mJZ+csZAEHJ6mHGUd
         cHCmFEWVzD8xsRZ0McpLsdy2Q+x+LVVLglGlPHgCoEcNOfqUhhQq9MTCt/ERkzfTpz
         /mkQUdaKeA4tBR1tnrHX6cvdqOXD2AVUyHuosvA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0692/1017] staging: mt7621-dts: fix LEDs and pinctrl on GB-PC1 devicetree
Date:   Tue,  5 Apr 2022 09:26:45 +0200
Message-Id: <20220405070414.814756737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 6256e18686158fa49e019297f990f1c1817aabf1 ]

Fix LED and pinctrl definitions on the GB-PC1 devicetree. Refer to the
schematics of the device for more information.

LED fixes:
- Change GPIO6 LED label from system to power as GPIO6 is connected to
PLED.
- Add default-on default-trigger to power LED.
- Change GPIO8 LED label from status to system as GPIO8 is connected to
SYS_LED.
- Add disk-activity default-trigger to system LED.
- Switch to the color:function naming scheme.
- Remove lan1 and lan2 LEDs as they don't exist.

Pinctrl fixes:
- Claim state_default node under pinctrl node.
- Change pinctrl0 node name to state-default.
- Change gpio node name to gpio-pinmux to respect
Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.yaml.
- Sort pin groups alphabetically.

Misc fixes:
- Fix formatting.
- Use the status value "okay".
- Define hexadecimal addresses in lower case.
- Make hexadecimal addresses for memory easier to read.

Link: https://github.com/ngiger/GnuBee_Docs/blob/master/GB-PCx/Documents/GB-PC1_V1.0_Schematic.pdf
Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20220311090320.3068-1-arinc.unal@arinc9.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/gbpc1.dts | 40 +++++++++++++---------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/mt7621-dts/gbpc1.dts b/drivers/staging/mt7621-dts/gbpc1.dts
index e38a083811e5..5ae94b1ad599 100644
--- a/drivers/staging/mt7621-dts/gbpc1.dts
+++ b/drivers/staging/mt7621-dts/gbpc1.dts
@@ -12,7 +12,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x0 0x1c000000>, <0x20000000 0x4000000>;
+		reg = <0x00000000 0x1c000000>,
+		      <0x20000000 0x04000000>;
 	};
 
 	chosen {
@@ -38,24 +39,16 @@
 	gpio-leds {
 		compatible = "gpio-leds";
 
-		system {
-			label = "gb-pc1:green:system";
+		power {
+			label = "green:power";
 			gpios = <&gpio 6 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "default-on";
 		};
 
-		status {
-			label = "gb-pc1:green:status";
+		system {
+			label = "green:system";
 			gpios = <&gpio 8 GPIO_ACTIVE_LOW>;
-		};
-
-		lan1 {
-			label = "gb-pc1:green:lan1";
-			gpios = <&gpio 24 GPIO_ACTIVE_LOW>;
-		};
-
-		lan2 {
-			label = "gb-pc1:green:lan2";
-			gpios = <&gpio 25 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "disk-activity";
 		};
 	};
 };
@@ -95,9 +88,8 @@
 
 		partition@50000 {
 			label = "firmware";
-			reg = <0x50000 0x1FB0000>;
+			reg = <0x50000 0x1fb0000>;
 		};
-
 	};
 };
 
@@ -106,9 +98,12 @@
 };
 
 &pinctrl {
-	state_default: pinctrl0 {
-		default_gpio: gpio {
-			groups = "wdt", "rgmii2", "uart3";
+	pinctrl-names = "default";
+	pinctrl-0 = <&state_default>;
+
+	state_default: state-default {
+		gpio-pinmux {
+			groups = "rgmii2", "uart3", "wdt";
 			function = "gpio";
 		};
 	};
@@ -117,12 +112,13 @@
 &switch0 {
 	ports {
 		port@0 {
+			status = "okay";
 			label = "ethblack";
-			status = "ok";
 		};
+
 		port@4 {
+			status = "okay";
 			label = "ethblue";
-			status = "ok";
 		};
 	};
 };
-- 
2.34.1



