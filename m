Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41374F47EF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347973AbiDEVXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573657AbiDETha (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 15:37:30 -0400
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF6245BD;
        Tue,  5 Apr 2022 12:35:29 -0700 (PDT)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1nboxN-00CFHs-0R; Tue, 05 Apr 2022 19:35:13 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org
Subject: [PATCH v2] ARM: dts: imx8mm-venice-gw{71xx,72xx,73xx}: fix OTG controller OC mode
Date:   Tue,  5 Apr 2022 12:35:09 -0700
Message-Id: <20220405193509.8231-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GW71xx, GW72xx and GW73xx boards have USB1 routed to a USB OTG
connectors and USB2 routed to a USB hub.

The OTG connector has a over-currently protection with an active-low
pin and the USB1 to HUB connection has no over-current protection (as
the HUB itself implements this for its downstream ports).

Add proper dt nodes to specify the over-current pin polarity for USB1
and disable over-current protection for USB2.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
v2: add gw71xx as well
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi | 2 ++
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi | 2 ++
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
index 73addc0b8e57..6671b99177e5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -146,12 +146,14 @@
 
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
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
index 1e7badb2a82e..b6b3578a0f89 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -211,12 +211,14 @@
 
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
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
index 7a5d45e80982..89fc2c595056 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -239,12 +239,14 @@
 
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
-- 
2.17.1

