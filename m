Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814D9226646
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbgGTQBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbgGTQBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A2C20672;
        Mon, 20 Jul 2020 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260907;
        bh=FQsF0DA/IXrvq+RpcXmh+sDlHG+IjbwiwYDz8ZJnW/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6TfLEE8GwnwMy8J58s1Bd2Y9SzKPTUURN8akB1RHzmoaquDst/KZpNTNVJDJfHeo
         CX8oTdY8/wBBX1kJMuHrg7XYFjx+OxGjwcdJKDME++/2+/ySWuMPxryoVUVBkADFxv
         zufsCUGqKL57IE9NVwiXqwIUZJiyNQ5S2QF9wYw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 140/215] clk: qcom: gcc: Add GPU and NPU clocks for SM8150
Date:   Mon, 20 Jul 2020 17:37:02 +0200
Message-Id: <20200720152826.851906552@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

commit f73a4230d5bbc8fc7e1a2479ac997f786111c7bb upstream.

Add the GPU and NPU clocks for SM8150. They were missed in earlier
addition of clock driver.

Fixes: 2a1d7eb854bb ("clk: qcom: gcc: Add global clock controller driver for SM8150")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lkml.kernel.org/r/20200513065420.32735-1-vkoul@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/gcc-sm8150.c |   64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/clk/qcom/gcc-sm8150.c
+++ b/drivers/clk/qcom/gcc-sm8150.c
@@ -1615,6 +1615,36 @@ static struct clk_branch gcc_gpu_cfg_ahb
 	},
 };
 
+static struct clk_branch gcc_gpu_gpll0_clk_src = {
+	.clkr = {
+		.enable_reg = 0x52004,
+		.enable_mask = BIT(15),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_gpu_gpll0_clk_src",
+			.parent_hws = (const struct clk_hw *[]){
+				&gpll0.clkr.hw },
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_gpu_gpll0_div_clk_src = {
+	.clkr = {
+		.enable_reg = 0x52004,
+		.enable_mask = BIT(16),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_gpu_gpll0_div_clk_src",
+			.parent_hws = (const struct clk_hw *[]){
+				&gcc_gpu_gpll0_clk_src.clkr.hw },
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_gpu_iref_clk = {
 	.halt_reg = 0x8c010,
 	.halt_check = BRANCH_HALT,
@@ -1697,6 +1727,36 @@ static struct clk_branch gcc_npu_cfg_ahb
 	},
 };
 
+static struct clk_branch gcc_npu_gpll0_clk_src = {
+	.clkr = {
+		.enable_reg = 0x52004,
+		.enable_mask = BIT(18),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_npu_gpll0_clk_src",
+			.parent_hws = (const struct clk_hw *[]){
+				&gpll0.clkr.hw },
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_npu_gpll0_div_clk_src = {
+	.clkr = {
+		.enable_reg = 0x52004,
+		.enable_mask = BIT(19),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_npu_gpll0_div_clk_src",
+			.parent_hws = (const struct clk_hw *[]){
+				&gcc_npu_gpll0_clk_src.clkr.hw },
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_npu_trig_clk = {
 	.halt_reg = 0x4d00c,
 	.halt_check = BRANCH_VOTED,
@@ -3331,12 +3391,16 @@ static struct clk_regmap *gcc_sm8150_clo
 	[GCC_GP3_CLK] = &gcc_gp3_clk.clkr,
 	[GCC_GP3_CLK_SRC] = &gcc_gp3_clk_src.clkr,
 	[GCC_GPU_CFG_AHB_CLK] = &gcc_gpu_cfg_ahb_clk.clkr,
+	[GCC_GPU_GPLL0_CLK_SRC] = &gcc_gpu_gpll0_clk_src.clkr,
+	[GCC_GPU_GPLL0_DIV_CLK_SRC] = &gcc_gpu_gpll0_div_clk_src.clkr,
 	[GCC_GPU_IREF_CLK] = &gcc_gpu_iref_clk.clkr,
 	[GCC_GPU_MEMNOC_GFX_CLK] = &gcc_gpu_memnoc_gfx_clk.clkr,
 	[GCC_GPU_SNOC_DVM_GFX_CLK] = &gcc_gpu_snoc_dvm_gfx_clk.clkr,
 	[GCC_NPU_AT_CLK] = &gcc_npu_at_clk.clkr,
 	[GCC_NPU_AXI_CLK] = &gcc_npu_axi_clk.clkr,
 	[GCC_NPU_CFG_AHB_CLK] = &gcc_npu_cfg_ahb_clk.clkr,
+	[GCC_NPU_GPLL0_CLK_SRC] = &gcc_npu_gpll0_clk_src.clkr,
+	[GCC_NPU_GPLL0_DIV_CLK_SRC] = &gcc_npu_gpll0_div_clk_src.clkr,
 	[GCC_NPU_TRIG_CLK] = &gcc_npu_trig_clk.clkr,
 	[GCC_PCIE0_PHY_REFGEN_CLK] = &gcc_pcie0_phy_refgen_clk.clkr,
 	[GCC_PCIE1_PHY_REFGEN_CLK] = &gcc_pcie1_phy_refgen_clk.clkr,


