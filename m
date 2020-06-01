Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDDD1EA959
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgFASA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbgFASA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B212065C;
        Mon,  1 Jun 2020 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034456;
        bh=C+0eu+c6hf0a10pkFzZBBmUwVlqk0CUncGWU6OZ/5pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDnqDij+EuVWZSl4KvASrA+l3/DFRz5zavApp7BJuTs7jiuHUuVhgGKYSlvoKfvJ3
         c+5HrGnmq+rMrjTO0hsgCJAl5tE0P9BM68N3fY+psHqAgfyRqrryuyRBaMgM1z7uMG
         MfqpPHxX49xJKTzAgZyx6bv0sfqSMzNt03ac0cTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Ian Ray <ian.ray@ge.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/77] ARM: dts/imx6q-bx50v3: Set display interface clock parents
Date:   Mon,  1 Jun 2020 19:53:44 +0200
Message-Id: <20200601174023.442576949@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

[ Upstream commit 665e7c73a7724a393b4ec92d1ae1e029925ef2b7 ]

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
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-b450v3.dts  |  7 -------
 arch/arm/boot/dts/imx6q-b650v3.dts  |  7 -------
 arch/arm/boot/dts/imx6q-b850v3.dts  | 11 -----------
 arch/arm/boot/dts/imx6q-bx50v3.dtsi | 15 +++++++++++++++
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-b450v3.dts b/arch/arm/boot/dts/imx6q-b450v3.dts
index 404a93d9596b..dc7d65da7d01 100644
--- a/arch/arm/boot/dts/imx6q-b450v3.dts
+++ b/arch/arm/boot/dts/imx6q-b450v3.dts
@@ -65,13 +65,6 @@
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
index 7f9f176901d4..101d61f93070 100644
--- a/arch/arm/boot/dts/imx6q-b650v3.dts
+++ b/arch/arm/boot/dts/imx6q-b650v3.dts
@@ -65,13 +65,6 @@
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
index 46bdc6722715..8fc831dc3156 100644
--- a/arch/arm/boot/dts/imx6q-b850v3.dts
+++ b/arch/arm/boot/dts/imx6q-b850v3.dts
@@ -53,17 +53,6 @@
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
index 8420378d095d..f3c2c5587616 100644
--- a/arch/arm/boot/dts/imx6q-bx50v3.dtsi
+++ b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
@@ -388,3 +388,18 @@
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
2.25.1



