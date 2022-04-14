Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E1F501149
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345873AbiDNNyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345084AbiDNNpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3032C26577;
        Thu, 14 Apr 2022 06:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B3961D68;
        Thu, 14 Apr 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB3EC385A1;
        Thu, 14 Apr 2022 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943701;
        bh=/zL59KZRSsOPmiteEbeTcjJdAPvwMkypNSTyMN0PYOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfmUTbAl9hSq5R+ue2rxgN83sKBa4ISNpoSjaoxUU764NoNTrC5aSrbuxV5UXGqh7
         krTifu3lfHyFua9GGh/THBO5+dacshQYy9M8Kgab/SdtgeXJ74ZmlCQXUb55HAuCKl
         LxDe3I0V+0ez46X7QYj4YIlzKAEUlibtSWRSczr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/475] staging: mt7621-dts: fix LEDs and pinctrl on GB-PC1 devicetree
Date:   Thu, 14 Apr 2022 15:10:34 +0200
Message-Id: <20220414110902.080844065@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 1fb560ff059c..1713283e60d4 100644
--- a/drivers/staging/mt7621-dts/gbpc1.dts
+++ b/drivers/staging/mt7621-dts/gbpc1.dts
@@ -11,7 +11,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x0 0x1c000000>, <0x20000000 0x4000000>;
+		reg = <0x00000000 0x1c000000>,
+		      <0x20000000 0x04000000>;
 	};
 
 	chosen {
@@ -37,24 +38,16 @@
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
@@ -94,9 +87,8 @@
 
 		partition@50000 {
 			label = "firmware";
-			reg = <0x50000 0x1FB0000>;
+			reg = <0x50000 0x1fb0000>;
 		};
-
 	};
 };
 
@@ -118,9 +110,12 @@
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
@@ -129,12 +124,13 @@
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



