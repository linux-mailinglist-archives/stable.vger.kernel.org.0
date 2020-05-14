Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769851D375D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgENREq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 13:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENREq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 13:04:46 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91524C061A0E;
        Thu, 14 May 2020 10:04:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 4A6B92A2FA5
Received: by jupiter.universe (Postfix, from userid 1000)
        id 475BF4800F8; Thu, 14 May 2020 19:04:42 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Sebastian Reichel <sre@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com,
        Robert Beckett <bob.beckett@collabora.com>,
        stable@vger.kernel.org, Ian Ray <ian.ray@ge.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCHv1] ARM: dts/imx6q-bx50v3: Set display interface clock parents
Date:   Thu, 14 May 2020 19:02:37 +0200
Message-Id: <20200514170236.24814-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

Avoid LDB and IPU DI clocks both using the same parent. LDB requires
pasthrough clock to avoid breaking timing while IPU DI does not.

Force IPU DI clocks to use IMX6QDL_CLK_PLL2_PFD0_352M as parent
and LDB to use IMX6QDL_CLK_PLL5_VIDEO_DIV.

This fixes an issue where attempting atomic modeset while using
HDMI and display port at the same time causes LDB clock programming
to destroy the programming of HDMI that was done during the same
modeset.

Cc: stable@vger.kernel.org
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
[Use IMX6QDL_CLK_PLL2_PFD0_352M instead of IMX6QDL_CLK_PLL2_PFD2_396M
 originally chosen by Robert Beckett to avoid affecting eMMC clock
 by DRM atomic updates]
Signed-off-by: Ian Ray <ian.ray@ge.com>
[Squash Robert's and Ian's commits for bisectability, update patch
 description and add stable tag]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 arch/arm/boot/dts/imx6q-b450v3.dts  |  7 -------
 arch/arm/boot/dts/imx6q-b650v3.dts  |  7 -------
 arch/arm/boot/dts/imx6q-b850v3.dts  | 11 -----------
 arch/arm/boot/dts/imx6q-bx50v3.dtsi | 15 +++++++++++++++
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-b450v3.dts b/arch/arm/boot/dts/imx6q-b450v3.dts
index 95b8f2d71821..fb0980190aa0 100644
--- a/arch/arm/boot/dts/imx6q-b450v3.dts
+++ b/arch/arm/boot/dts/imx6q-b450v3.dts
@@ -65,13 +65,6 @@ panel_in_lvds0: endpoint {
 	};
 };
 
-&clks {
-	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
-			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>;
-	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL3_USB_OTG>,
-				 <&clks IMX6QDL_CLK_PLL3_USB_OTG>;
-};
-
 &ldb {
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/imx6q-b650v3.dts b/arch/arm/boot/dts/imx6q-b650v3.dts
index 611cb7ae7e55..8f762d9c5ae9 100644
--- a/arch/arm/boot/dts/imx6q-b650v3.dts
+++ b/arch/arm/boot/dts/imx6q-b650v3.dts
@@ -65,13 +65,6 @@ panel_in_lvds0: endpoint {
 	};
 };
 
-&clks {
-	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
-			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>;
-	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL3_USB_OTG>,
-				 <&clks IMX6QDL_CLK_PLL3_USB_OTG>;
-};
-
 &ldb {
 	status = "okay";
 
diff --git a/arch/arm/boot/dts/imx6q-b850v3.dts b/arch/arm/boot/dts/imx6q-b850v3.dts
index e4cb118f88c6..1ea64ecf4291 100644
--- a/arch/arm/boot/dts/imx6q-b850v3.dts
+++ b/arch/arm/boot/dts/imx6q-b850v3.dts
@@ -53,17 +53,6 @@ chosen {
 	};
 };
 
-&clks {
-	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
-			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
-			  <&clks IMX6QDL_CLK_IPU1_DI0_PRE_SEL>,
-			  <&clks IMX6QDL_CLK_IPU2_DI0_PRE_SEL>;
-	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
-				 <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
-				 <&clks IMX6QDL_CLK_PLL2_PFD2_396M>,
-				 <&clks IMX6QDL_CLK_PLL2_PFD2_396M>;
-};
-
 &ldb {
 	fsl,dual-channel;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6q-bx50v3.dtsi b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
index fa27dcdf06f1..1938b04199c4 100644
--- a/arch/arm/boot/dts/imx6q-bx50v3.dtsi
+++ b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
@@ -377,3 +377,18 @@ pci_root: root@0,0 {
 		#interrupt-cells = <1>;
 	};
 };
+
+&clks {
+	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
+			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
+			  <&clks IMX6QDL_CLK_IPU1_DI0_PRE_SEL>,
+			  <&clks IMX6QDL_CLK_IPU1_DI1_PRE_SEL>,
+			  <&clks IMX6QDL_CLK_IPU2_DI0_PRE_SEL>,
+			  <&clks IMX6QDL_CLK_IPU2_DI1_PRE_SEL>;
+	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
+				 <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
+				 <&clks IMX6QDL_CLK_PLL2_PFD0_352M>,
+				 <&clks IMX6QDL_CLK_PLL2_PFD0_352M>,
+				 <&clks IMX6QDL_CLK_PLL2_PFD0_352M>,
+				 <&clks IMX6QDL_CLK_PLL2_PFD0_352M>;
+};
-- 
2.26.2

