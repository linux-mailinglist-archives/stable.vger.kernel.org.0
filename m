Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B79150D13
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgBCQe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730879AbgBCQe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:56 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32152087E;
        Mon,  3 Feb 2020 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747696;
        bh=cOyqk97cutL1s+fJwmtKJKAfj/jZXdg6ZAmb/dhgNH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBHw4LUk6S3AERQe8WFg8xvzSmou28FADGkag7LKQAucfDzfPTRmX1sIgqExx+kW+
         kXGGb5euOoS1KWGIcaAsq18bfdyEldRkuN/f7nxdVN7ILY6YAuXbP046z3bWTvT9WM
         Pnon+RuJCVTLslFfbhf3UKGywtUilZTbcJKA4gdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/90] clk: sunxi-ng: sun8i-r: Fix divider on APB0 clock
Date:   Mon,  3 Feb 2020 16:19:35 +0000
Message-Id: <20200203161921.931106732@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 47d64fef1f3ffbdf960d3330b9865fc9f12fdf84 ]

According to the BSP source code, the APB0 clock on the H3 and H5 has a
normal M divider, not a power-of-two divider. This matches the hardware
in the A83T (as described in both the BSP source code and the manual).
Since the A83T and H3/A64 clocks are actually the same, we can merge the
definitions.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-r.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-r.c b/drivers/clk/sunxi-ng/ccu-sun8i-r.c
index 4646fdc61053b..4c8c491b87c27 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-r.c
@@ -51,19 +51,7 @@ static struct ccu_div ar100_clk = {
 
 static CLK_FIXED_FACTOR_HW(ahb0_clk, "ahb0", &ar100_clk.common.hw, 1, 1, 0);
 
-static struct ccu_div apb0_clk = {
-	.div		= _SUNXI_CCU_DIV_FLAGS(0, 2, CLK_DIVIDER_POWER_OF_TWO),
-
-	.common		= {
-		.reg		= 0x0c,
-		.hw.init	= CLK_HW_INIT_HW("apb0",
-						 &ahb0_clk.hw,
-						 &ccu_div_ops,
-						 0),
-	},
-};
-
-static SUNXI_CCU_M(a83t_apb0_clk, "apb0", "ahb0", 0x0c, 0, 2, 0);
+static SUNXI_CCU_M(apb0_clk, "apb0", "ahb0", 0x0c, 0, 2, 0);
 
 /*
  * Define the parent as an array that can be reused to save space
@@ -127,7 +115,7 @@ static struct ccu_mp a83t_ir_clk = {
 
 static struct ccu_common *sun8i_a83t_r_ccu_clks[] = {
 	&ar100_clk.common,
-	&a83t_apb0_clk.common,
+	&apb0_clk.common,
 	&apb0_pio_clk.common,
 	&apb0_ir_clk.common,
 	&apb0_timer_clk.common,
@@ -167,7 +155,7 @@ static struct clk_hw_onecell_data sun8i_a83t_r_hw_clks = {
 	.hws	= {
 		[CLK_AR100]		= &ar100_clk.common.hw,
 		[CLK_AHB0]		= &ahb0_clk.hw,
-		[CLK_APB0]		= &a83t_apb0_clk.common.hw,
+		[CLK_APB0]		= &apb0_clk.common.hw,
 		[CLK_APB0_PIO]		= &apb0_pio_clk.common.hw,
 		[CLK_APB0_IR]		= &apb0_ir_clk.common.hw,
 		[CLK_APB0_TIMER]	= &apb0_timer_clk.common.hw,
@@ -282,9 +270,6 @@ static void __init sunxi_r_ccu_init(struct device_node *node,
 
 static void __init sun8i_a83t_r_ccu_setup(struct device_node *node)
 {
-	/* Fix apb0 bus gate parents here */
-	apb0_gate_parent[0] = &a83t_apb0_clk.common.hw;
-
 	sunxi_r_ccu_init(node, &sun8i_a83t_r_ccu_desc);
 }
 CLK_OF_DECLARE(sun8i_a83t_r_ccu, "allwinner,sun8i-a83t-r-ccu",
-- 
2.20.1



