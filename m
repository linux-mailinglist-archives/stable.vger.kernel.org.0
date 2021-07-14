Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792323C8F95
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbhGNTwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240194AbhGNTte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A42613EA;
        Wed, 14 Jul 2021 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291888;
        bh=WKRIXs+cuh2xcK/HLvBxZGE4X15v3mXLH7teDP4mdzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToWjEh0ahJF9EK1eX3X8JhOBh9MbtQu9jkZ3GGBNZkHXP5zIqt+wiEZA+BgsgL7u+
         Fc0LCBhlrS9+ItE7SaIdDUa/iMp1BU9HeGNj6xD5i+B31aGoLzrt/r4uG0T16DVIOK
         LmQ5muUSSQJDW1TTKEwAc2wJf/iaOkaB62o49UaxrfNuvgp1dYZjvyuhohInZS35XT
         HCaWViHhqSnjFogQvNdiAL3Ag80RQHuMP6IRd6QYQ2bUktudwUx3bQH9FIySFqM6hC
         xlupwg3id/7860Hy81yvK1ZzV05pfhCRETY28v7jq0/rbgFc91NlFegDnQlamwXCeJ
         K7NL2rrO0/pUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 70/88] arm64: dts: imx8mq: assign PCIe clocks
Date:   Wed, 14 Jul 2021 15:42:45 -0400
Message-Id: <20210714194303.54028-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index 5e0e7d0f1bc4..c86cf786f406 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1258,6 +1258,14 @@ pcie0: pcie@33800000 {
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
 
@@ -1287,6 +1295,14 @@ pcie1: pcie@33c00000 {
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

