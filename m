Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7474947AD41
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhLTOvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53596 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhLTOsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F6A4B80EE2;
        Mon, 20 Dec 2021 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58434C36AEC;
        Mon, 20 Dec 2021 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011702;
        bh=qR5byrAjvd05gXLDGBxL9qUXAANpNn00QRXIChG19c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGcOLZP/B1MAKJDmpSJUswDRqxaAqqMGUnA8QhCMX45ZnOjIl/rK0OB0+LEoipq4X
         qVUUVUhhFpgUPocdw+1NL/gPnmP4EWOWV4385lRoK/bm9ZzDVD+Mg0GPARgBA3qLEr
         AEjW+Tj0q7Wm3DovN/S+IJxrJKGK/QwJl1YMq0Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 5.10 16/99] arm64: dts: imx8m: correct assigned clocks for FEC
Date:   Mon, 20 Dec 2021 15:33:49 +0100
Message-Id: <20211220143029.901554056@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 70eacf42a93aff6589a8b91279bbfe5f73c4ca3d upstream.

CLK_ENET_TIMER assigned clocks twice, should be a typo, correct to
CLK_ENET_PHY_REF clock.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi |    7 ++++---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi |    7 ++++---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi |    7 ++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -866,11 +866,12 @@
 				assigned-clocks = <&clk IMX8MM_CLK_ENET_AXI>,
 						  <&clk IMX8MM_CLK_ENET_TIMER>,
 						  <&clk IMX8MM_CLK_ENET_REF>,
-						  <&clk IMX8MM_CLK_ENET_TIMER>;
+						  <&clk IMX8MM_CLK_ENET_PHY_REF>;
 				assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_266M>,
 							 <&clk IMX8MM_SYS_PLL2_100M>,
-							 <&clk IMX8MM_SYS_PLL2_125M>;
-				assigned-clock-rates = <0>, <0>, <125000000>, <100000000>;
+							 <&clk IMX8MM_SYS_PLL2_125M>,
+							 <&clk IMX8MM_SYS_PLL2_50M>;
+				assigned-clock-rates = <0>, <100000000>, <125000000>, <0>;
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
 				status = "disabled";
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -753,11 +753,12 @@
 				assigned-clocks = <&clk IMX8MN_CLK_ENET_AXI>,
 						  <&clk IMX8MN_CLK_ENET_TIMER>,
 						  <&clk IMX8MN_CLK_ENET_REF>,
-						  <&clk IMX8MN_CLK_ENET_TIMER>;
+						  <&clk IMX8MN_CLK_ENET_PHY_REF>;
 				assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_266M>,
 							 <&clk IMX8MN_SYS_PLL2_100M>,
-							 <&clk IMX8MN_SYS_PLL2_125M>;
-				assigned-clock-rates = <0>, <0>, <125000000>, <100000000>;
+							 <&clk IMX8MN_SYS_PLL2_125M>,
+							 <&clk IMX8MN_SYS_PLL2_50M>;
+				assigned-clock-rates = <0>, <100000000>, <125000000>, <0>;
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
 				status = "disabled";
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -725,11 +725,12 @@
 				assigned-clocks = <&clk IMX8MP_CLK_ENET_AXI>,
 						  <&clk IMX8MP_CLK_ENET_TIMER>,
 						  <&clk IMX8MP_CLK_ENET_REF>,
-						  <&clk IMX8MP_CLK_ENET_TIMER>;
+						  <&clk IMX8MP_CLK_ENET_PHY_REF>;
 				assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_266M>,
 							 <&clk IMX8MP_SYS_PLL2_100M>,
-							 <&clk IMX8MP_SYS_PLL2_125M>;
-				assigned-clock-rates = <0>, <0>, <125000000>, <100000000>;
+							 <&clk IMX8MP_SYS_PLL2_125M>,
+							 <&clk IMX8MP_SYS_PLL2_50M>;
+				assigned-clock-rates = <0>, <100000000>, <125000000>, <0>;
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
 				status = "disabled";


