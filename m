Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1123C900E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbhGNTxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240862AbhGNTuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458DF6144C;
        Wed, 14 Jul 2021 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291970;
        bh=FVVhDArWvHZKrLL2z3Z9uZI70N+2fCLfOT3eWNGkKz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXkCncVhaH3TNQ4zyMcy8Y034n7DYEDgOozBjg3jvrTdQv072fJYXHJ2gO7qs1XW7
         5ipdf6LXzEMKedWbFfErvPEqKjnqBJRGgqTAyzYzDhZukLYWDhJuiTmkfa+bj/62wt
         EmR91bhPCLow3ml3SlIhianuMX8S6In1/qOxg56GEd7cQIWskH+YgGeH//PIB/bria
         aS2YVKRI81POwIZUhxbZ+LT+GLauQp4vjvC58LnNpahOtHQw/rYuvFwqh0Y05h8ZT7
         WhtKmg6xIO9e30job9h8R65l6J0s543BUJBUB+KH/SyPtY718iSsMA2CENudb/Ppt+
         Z0RfXJJwNW3Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 40/51] arm64: dts: imx8mq: assign PCIe clocks
Date:   Wed, 14 Jul 2021 15:45:02 -0400
Message-Id: <20210714194513.54827-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 15a5261e4d052bf85c7fba24dbe0e9a7c8c05925 ]

This fixes multiple issues with the current non-existent PCIe clock setup:

The controller can run at up to 250MHz, so use a parent that provides this
clock.

The PHY needs an exact 100MHz reference clock to function if the PCIe
refclock is not fed in via the refclock pads. While this mode is not
supported (yet) in the driver it doesn't hurt to make sure we are
providing a clock with the right rate.

The AUX clock is specified to have a maximum clock rate of 10MHz. So
the current setup, which drives it straight from the 25MHz oscillator is
actually overclocking the AUX input.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index f1011bcd5ed5..3dae8d7c7619 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1056,6 +1056,14 @@ pcie0: pcie@33800000 {
 			         <&src IMX8MQ_RESET_PCIE_CTRL_APPS_EN>,
 			         <&src IMX8MQ_RESET_PCIE_CTRL_APPS_TURNOFF>;
 			reset-names = "pciephy", "apps", "turnoff";
+			assigned-clocks = <&clk IMX8MQ_CLK_PCIE1_CTRL>,
+			                  <&clk IMX8MQ_CLK_PCIE1_PHY>,
+			                  <&clk IMX8MQ_CLK_PCIE1_AUX>;
+			assigned-clock-parents = <&clk IMX8MQ_SYS2_PLL_250M>,
+			                         <&clk IMX8MQ_SYS2_PLL_100M>,
+			                         <&clk IMX8MQ_SYS1_PLL_80M>;
+			assigned-clock-rates = <250000000>, <100000000>,
+			                       <10000000>;
 			status = "disabled";
 		};
 
@@ -1085,6 +1093,14 @@ pcie1: pcie@33c00000 {
 			         <&src IMX8MQ_RESET_PCIE2_CTRL_APPS_EN>,
 			         <&src IMX8MQ_RESET_PCIE2_CTRL_APPS_TURNOFF>;
 			reset-names = "pciephy", "apps", "turnoff";
+			assigned-clocks = <&clk IMX8MQ_CLK_PCIE2_CTRL>,
+			                  <&clk IMX8MQ_CLK_PCIE2_PHY>,
+			                  <&clk IMX8MQ_CLK_PCIE2_AUX>;
+			assigned-clock-parents = <&clk IMX8MQ_SYS2_PLL_250M>,
+			                         <&clk IMX8MQ_SYS2_PLL_100M>,
+			                         <&clk IMX8MQ_SYS1_PLL_80M>;
+			assigned-clock-rates = <250000000>, <100000000>,
+			                       <10000000>;
 			status = "disabled";
 		};
 
-- 
2.30.2

