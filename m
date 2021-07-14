Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DB63C8D0E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhGNTnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhGNTnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F6DD613D8;
        Wed, 14 Jul 2021 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291608;
        bh=Qscmt7Nun27TYaNstMnTrXFhdZ+CUTGL/F3JW5XARhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8FdUAEoUJJbg2WF3a1+mjUEvSOpVlzXUNxpbeEpKqcvcr1DaSPU4GT5mw4+12a2a
         GxVWkYYJaH0x36NqScOp3Zf2tcUF0JoZme1J/4BEltIO7OsRKuPiTd8A5kmfXM+QoG
         wPrgRukGh13sVz/Oc5TSkxA2TLbBqlvr1mx2Uhldkz6uXarvh0hdV2fVO/KWd0GEVg
         Bte847Ko26jEW6xE+mwVjmQceWN8+b80coAidmKg8G5+4DblQFy+f16kuR/1FvuwI+
         ZUnWpeRYAabbCkWDh4ahkWGUv+BLks9xIgEBMHV9lt5opVUpP/j66tpocxU33MYzk9
         cO0mwYIBKaHBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, Abel Vesa <abel.vesa@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 088/108] arm64: dts: imx8: conn: fix enet clock setting
Date:   Wed, 14 Jul 2021 15:37:40 -0400
Message-Id: <20210714193800.52097-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -77,9 +77,12 @@ fec1: ethernet@5b040000 {
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
@@ -94,9 +97,12 @@ fec2: ethernet@5b050000 {
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
@@ -152,15 +158,19 @@ enet0_lpcg: clock-controller@5b230000 {
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
 
@@ -170,15 +180,19 @@ enet1_lpcg: clock-controller@5b240000 {
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

