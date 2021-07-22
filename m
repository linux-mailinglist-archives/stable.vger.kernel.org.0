Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB373D28A5
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhGVP5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232988AbhGVP5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42AA61362;
        Thu, 22 Jul 2021 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971884;
        bh=Hfm3pnE+r7php39eKohzPYd7dfQ8s4ESqxt/l9Dj39M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6Vlj6p3rcHncUbkJoz9mae7myUzLfrRVfISKA3KKdESFamtDdkzQr1GtyNfJgN4G
         yFZwG+Y9dII5Dy206fdqoW3XrHJ/jNoE/qElvaMHMzYpjybIgMyShAmaRwKWvJNsD/
         eBCC/2NCazgTfdAzx79/3RvPQb/y8cqJnJ3dJets=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/125] arm64: dts: imx8mq: assign PCIe clocks
Date:   Thu, 22 Jul 2021 18:30:54 +0200
Message-Id: <20210722155626.791290067@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1258,6 +1258,14 @@
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
 
@@ -1287,6 +1295,14 @@
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



