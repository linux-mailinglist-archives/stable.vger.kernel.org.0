Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31663D2A05
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhGVQHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235113AbhGVQG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387AE61DD9;
        Thu, 22 Jul 2021 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972440;
        bh=YkOZ46jkTySNfxBPuRR+1k4fuvV4mD24ccmUSE3uCJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6n1ubbiY3y7SdLR1nmkXyiYRPP4BX3LFDzE4rGW4MOLFIZY+OEPCh72lG1Caok23
         Fa8l1TyUD8GcZpV9Z3cIK4DVhQjcwfDRCy+pEpXyUw7+YL6VPKqGMm1wadw3q4kpyB
         6+wJSv1Wpob0i82gWqZ5Xtq0/G3Uv43vmw58Rovg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 081/156] arm64: dts: imx8: conn: fix enet clock setting
Date:   Thu, 22 Jul 2021 18:30:56 +0200
Message-Id: <20210722155631.009546278@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit dfda1fd16aa71c839e4002109b0cd15f61105ebb ]

enet_clk_ref actually is sourced from internal gpr clocks
which needs a default rate. Also update enet lpcg clock
output names to be more straightforward.

Cc: Abel Vesa <abel.vesa@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8-ss-conn.dtsi      | 50 ++++++++++++-------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
index e1e81ca0ca69..a79f42a9618e 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
@@ -77,9 +77,12 @@ conn_subsys: bus@5b000000 {
 			     <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&enet0_lpcg IMX_LPCG_CLK_4>,
 			 <&enet0_lpcg IMX_LPCG_CLK_2>,
-			 <&enet0_lpcg IMX_LPCG_CLK_1>,
+			 <&enet0_lpcg IMX_LPCG_CLK_3>,
 			 <&enet0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "ahb", "enet_clk_ref", "ptp";
+		assigned-clocks = <&clk IMX_SC_R_ENET_0 IMX_SC_PM_CLK_PER>,
+				  <&clk IMX_SC_R_ENET_0 IMX_SC_C_CLKDIV>;
+		assigned-clock-rates = <250000000>, <125000000>;
 		fsl,num-tx-queues=<3>;
 		fsl,num-rx-queues=<3>;
 		power-domains = <&pd IMX_SC_R_ENET_0>;
@@ -94,9 +97,12 @@ conn_subsys: bus@5b000000 {
 				<GIC_SPI 263 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&enet1_lpcg IMX_LPCG_CLK_4>,
 			 <&enet1_lpcg IMX_LPCG_CLK_2>,
-			 <&enet1_lpcg IMX_LPCG_CLK_1>,
+			 <&enet1_lpcg IMX_LPCG_CLK_3>,
 			 <&enet1_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "ahb", "enet_clk_ref", "ptp";
+		assigned-clocks = <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>,
+				  <&clk IMX_SC_R_ENET_1 IMX_SC_C_CLKDIV>;
+		assigned-clock-rates = <250000000>, <125000000>;
 		fsl,num-tx-queues=<3>;
 		fsl,num-rx-queues=<3>;
 		power-domains = <&pd IMX_SC_R_ENET_1>;
@@ -152,15 +158,19 @@ conn_subsys: bus@5b000000 {
 		#clock-cells = <1>;
 		clocks = <&clk IMX_SC_R_ENET_0 IMX_SC_PM_CLK_PER>,
 			 <&clk IMX_SC_R_ENET_0 IMX_SC_PM_CLK_PER>,
-			 <&conn_axi_clk>, <&conn_ipg_clk>, <&conn_ipg_clk>;
+			 <&conn_axi_clk>,
+			 <&clk IMX_SC_R_ENET_0 IMX_SC_C_TXCLK>,
+			 <&conn_ipg_clk>,
+			 <&conn_ipg_clk>;
 		clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_1>,
-				<IMX_LPCG_CLK_2>, <IMX_LPCG_CLK_4>,
-				<IMX_LPCG_CLK_5>;
-		clock-output-names = "enet0_ipg_root_clk",
-				     "enet0_tx_clk",
-				     "enet0_ahb_clk",
-				     "enet0_ipg_clk",
-				     "enet0_ipg_s_clk";
+				<IMX_LPCG_CLK_2>, <IMX_LPCG_CLK_3>,
+				<IMX_LPCG_CLK_4>, <IMX_LPCG_CLK_5>;
+		clock-output-names = "enet0_lpcg_timer_clk",
+				     "enet0_lpcg_txc_sampling_clk",
+				     "enet0_lpcg_ahb_clk",
+				     "enet0_lpcg_rgmii_txc_clk",
+				     "enet0_lpcg_ipg_clk",
+				     "enet0_lpcg_ipg_s_clk";
 		power-domains = <&pd IMX_SC_R_ENET_0>;
 	};
 
@@ -170,15 +180,19 @@ conn_subsys: bus@5b000000 {
 		#clock-cells = <1>;
 		clocks = <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>,
 			 <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>,
-			 <&conn_axi_clk>, <&conn_ipg_clk>, <&conn_ipg_clk>;
+			 <&conn_axi_clk>,
+			 <&clk IMX_SC_R_ENET_1 IMX_SC_C_TXCLK>,
+			 <&conn_ipg_clk>,
+			 <&conn_ipg_clk>;
 		clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_1>,
-				<IMX_LPCG_CLK_2>, <IMX_LPCG_CLK_4>,
-				<IMX_LPCG_CLK_5>;
-		clock-output-names = "enet1_ipg_root_clk",
-				     "enet1_tx_clk",
-				     "enet1_ahb_clk",
-				     "enet1_ipg_clk",
-				     "enet1_ipg_s_clk";
+				<IMX_LPCG_CLK_2>, <IMX_LPCG_CLK_3>,
+				<IMX_LPCG_CLK_4>, <IMX_LPCG_CLK_5>;
+		clock-output-names = "enet1_lpcg_timer_clk",
+				     "enet1_lpcg_txc_sampling_clk",
+				     "enet1_lpcg_ahb_clk",
+				     "enet1_lpcg_rgmii_txc_clk",
+				     "enet1_lpcg_ipg_clk",
+				     "enet1_lpcg_ipg_s_clk";
 		power-domains = <&pd IMX_SC_R_ENET_1>;
 	};
 };
-- 
2.30.2



