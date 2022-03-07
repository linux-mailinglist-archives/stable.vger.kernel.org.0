Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF124CF93A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiCGKEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240463AbiCGKBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B449635D;
        Mon,  7 Mar 2022 01:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D8BB8102B;
        Mon,  7 Mar 2022 09:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8973C340F3;
        Mon,  7 Mar 2022 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646505;
        bh=wucGYhU/4fjXHEiYCpmNe9ovLCQpTNtpqblxmIxE1Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hO2jdL4bnkqWZR0yJegijaomf6EFlPQM4TZKEBWAFSMH7ZWqwhzz+umxByJzRfbwa
         FVoKQ/q0chK0IsieIYJrx/+6sPT+dgyjVA9+/6k1TZ++KWF4fLEnE7wV4UyjaxZOva
         8oiMidObUaI/+KZS8K8N6ATIpUt6cB5VVJv+EgJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/262] ARM: tegra: Move panels to AUX bus
Date:   Mon,  7 Mar 2022 10:19:18 +0100
Message-Id: <20220307091708.973077975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 8d3b01e0d4bb54368d73d0984466d72c2eeeac74 ]

Move the eDP panel on Venice 2 and Nyan boards into the corresponding
AUX bus device tree node. This allows us to avoid a nasty circular
dependency that would otherwise be created between the DPAUX and panel
nodes via the DDC/I2C phandle.

Fixes: eb481f9ac95c ("ARM: tegra: add Acer Chromebook 13 device tree")
Fixes: 59fe02cb079f ("ARM: tegra: Add DTS for the nyan-blaze board")
Fixes: 40e231c770a4 ("ARM: tegra: Enable eDP for Venice2")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra124-nyan-big.dts   | 15 +++++++++------
 arch/arm/boot/dts/tegra124-nyan-blaze.dts | 15 +++++++++------
 arch/arm/boot/dts/tegra124-venice2.dts    | 14 +++++++-------
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 1d2aac2cb6d0..fdc1d64dfff9 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -13,12 +13,15 @@
 		     "google,nyan-big-rev1", "google,nyan-big-rev0",
 		     "google,nyan-big", "google,nyan", "nvidia,tegra124";
 
-	panel: panel {
-		compatible = "auo,b133xtn01";
-
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
+	host1x@50000000 {
+		dpaux@545c0000 {
+			aux-bus {
+				panel: panel {
+					compatible = "auo,b133xtn01";
+					backlight = <&backlight>;
+				};
+			};
+		};
 	};
 
 	mmc@700b0400 { /* SD Card on this bus */
diff --git a/arch/arm/boot/dts/tegra124-nyan-blaze.dts b/arch/arm/boot/dts/tegra124-nyan-blaze.dts
index 677babde6460..abdf4456826f 100644
--- a/arch/arm/boot/dts/tegra124-nyan-blaze.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-blaze.dts
@@ -15,12 +15,15 @@
 		     "google,nyan-blaze-rev0", "google,nyan-blaze",
 		     "google,nyan", "nvidia,tegra124";
 
-	panel: panel {
-		compatible = "samsung,ltn140at29-301";
-
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
+	host1x@50000000 {
+		dpaux@545c0000 {
+			aux-bus {
+				panel: panel {
+					compatible = "samsung,ltn140at29-301";
+					backlight = <&backlight>;
+				};
+			};
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index e6b54ac1ebd1..84e2d24065e9 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -48,6 +48,13 @@
 		dpaux@545c0000 {
 			vdd-supply = <&vdd_3v3_panel>;
 			status = "okay";
+
+			aux-bus {
+				panel: panel {
+					compatible = "lg,lp129qe";
+					backlight = <&backlight>;
+				};
+			};
 		};
 	};
 
@@ -1079,13 +1086,6 @@
 		};
 	};
 
-	panel: panel {
-		compatible = "lg,lp129qe";
-		power-supply = <&vdd_3v3_panel>;
-		backlight = <&backlight>;
-		ddc-i2c-bus = <&dpaux>;
-	};
-
 	vdd_mux: regulator@0 {
 		compatible = "regulator-fixed";
 		regulator-name = "+VDD_MUX";
-- 
2.34.1



