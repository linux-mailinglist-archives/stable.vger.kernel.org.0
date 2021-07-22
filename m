Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A983D2A04
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhGVQHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233804AbhGVQGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961FE61DAF;
        Thu, 22 Jul 2021 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972438;
        bh=wKy5LLd2+rICSp9cO2L0BCG548XkV9zCo29TjeONGgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+2+0EuBUNWpVonO9WjQ4UpBgNo1OPmLVnjs3St/b6UwcoH4o8HhL+HeF3nxFPZAC
         ub4jQGDVXvUpgGHgC7hNJPL1sbMB/KBJoCsZ2K18aajnNiM3aBir1QjbVP0ab+6iD9
         cG9a5sNITXgLGYD3t96kPjj7GV5arV1W7eoUVmYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/156] arm64: dts: imx8mq: assign PCIe clocks
Date:   Thu, 22 Jul 2021 18:30:55 +0200
Message-Id: <20210722155630.979799687@linuxfoundation.org>
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
index 17c449e12c2e..91df9c5350ae 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1383,6 +1383,14 @@
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
 
@@ -1413,6 +1421,14 @@
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



