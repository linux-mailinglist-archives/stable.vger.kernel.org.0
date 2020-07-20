Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFEF2267A3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbgGTQNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732072AbgGTQNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01D162065E;
        Mon, 20 Jul 2020 16:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261597;
        bh=DdTdjg0Gk5lifM3rDmsGOBqulmNd1kG27YSq2pSijzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usiK8KhA9zNMh3J9tn0D4/75oiFORego/yDrMRAs3XRpHg35elK7Kr3WWrcfUnRIN
         oEn87vWlfetjO3RjIBiym4+0XILGT5y7PCmoZPzZFIzeMHl5NSQkLHlyrfeC5ZUubi
         QxseDz8p5wNKpPqvbqCGp0UYwmmrwd9EZWfzwmOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.7 143/244] clk: qcom: gcc: Add GPU and NPU clocks for SM8150
Date:   Mon, 20 Jul 2020 17:36:54 +0200
Message-Id: <20200720152832.653270549@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -1616,6 +1616,36 @@ static struct clk_branch gcc_gpu_cfg_ahb
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
@@ -1698,6 +1728,36 @@ static struct clk_branch gcc_npu_cfg_ahb
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
@@ -3374,12 +3434,16 @@ static struct clk_regmap *gcc_sm8150_clo
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


