Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBF329029
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbhCAUD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242372AbhCATxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34AA3652F4;
        Mon,  1 Mar 2021 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621196;
        bh=qm7VpN2YWJo2EZEaSzUlCmb0J1rwn8IGEG/yGm2879w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGypx67n5AQo2pn4MZHqONaAp/zjqwK/4UpeU7IuaNrL+x5gvboG79K8TFzB8dOJV
         AYMTMg8Ikf/J2jcYS58ocpvg5MpVE8h2SX239uAKOzO4NWPVvSR46qT5cOPqT6B23w
         Yy691etQHlUvAUG4UD6rnLAC5+mIYMwHRjJNIGAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 427/775] clk: qcom: gcc-sc7180: Mark the MM XO clocks to be always ON
Date:   Mon,  1 Mar 2021 17:09:55 +0100
Message-Id: <20210301161222.673150358@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit d79dfa19ca4235c28be62952bda6091babdcf8f3 ]

There are intermittent GDSC power-up failures observed for titan top
gdsc, which requires the XO clock. Thus mark all the MM XO clocks always
enabled from probe.

Fixes: 8d4025943e13 ("clk: qcom: camcc-sc7180: Use runtime PM ops instead of clk ones")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/1611128871-5898-1-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7180.c | 47 +++--------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc7180.c b/drivers/clk/qcom/gcc-sc7180.c
index b05901b249172..88e896abb6631 100644
--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2019-2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2019-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -919,19 +919,6 @@ static struct clk_branch gcc_camera_throttle_hf_axi_clk = {
 	},
 };
 
-static struct clk_branch gcc_camera_xo_clk = {
-	.halt_reg = 0xb02c,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0xb02c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_camera_xo_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_ce1_ahb_clk = {
 	.halt_reg = 0x4100c,
 	.halt_check = BRANCH_HALT_VOTED,
@@ -1096,19 +1083,6 @@ static struct clk_branch gcc_disp_throttle_hf_axi_clk = {
 	},
 };
 
-static struct clk_branch gcc_disp_xo_clk = {
-	.halt_reg = 0xb030,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0xb030,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_disp_xo_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_gp1_clk = {
 	.halt_reg = 0x64000,
 	.halt_check = BRANCH_HALT,
@@ -2159,19 +2133,6 @@ static struct clk_branch gcc_video_throttle_axi_clk = {
 	},
 };
 
-static struct clk_branch gcc_video_xo_clk = {
-	.halt_reg = 0xb028,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0xb028,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_video_xo_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_mss_cfg_ahb_clk = {
 	.halt_reg = 0x8a000,
 	.halt_check = BRANCH_HALT,
@@ -2304,7 +2265,6 @@ static struct clk_regmap *gcc_sc7180_clocks[] = {
 	[GCC_BOOT_ROM_AHB_CLK] = &gcc_boot_rom_ahb_clk.clkr,
 	[GCC_CAMERA_HF_AXI_CLK] = &gcc_camera_hf_axi_clk.clkr,
 	[GCC_CAMERA_THROTTLE_HF_AXI_CLK] = &gcc_camera_throttle_hf_axi_clk.clkr,
-	[GCC_CAMERA_XO_CLK] = &gcc_camera_xo_clk.clkr,
 	[GCC_CE1_AHB_CLK] = &gcc_ce1_ahb_clk.clkr,
 	[GCC_CE1_AXI_CLK] = &gcc_ce1_axi_clk.clkr,
 	[GCC_CE1_CLK] = &gcc_ce1_clk.clkr,
@@ -2317,7 +2277,6 @@ static struct clk_regmap *gcc_sc7180_clocks[] = {
 	[GCC_DISP_GPLL0_DIV_CLK_SRC] = &gcc_disp_gpll0_div_clk_src.clkr,
 	[GCC_DISP_HF_AXI_CLK] = &gcc_disp_hf_axi_clk.clkr,
 	[GCC_DISP_THROTTLE_HF_AXI_CLK] = &gcc_disp_throttle_hf_axi_clk.clkr,
-	[GCC_DISP_XO_CLK] = &gcc_disp_xo_clk.clkr,
 	[GCC_GP1_CLK] = &gcc_gp1_clk.clkr,
 	[GCC_GP1_CLK_SRC] = &gcc_gp1_clk_src.clkr,
 	[GCC_GP2_CLK] = &gcc_gp2_clk.clkr,
@@ -2413,7 +2372,6 @@ static struct clk_regmap *gcc_sc7180_clocks[] = {
 	[GCC_VIDEO_AXI_CLK] = &gcc_video_axi_clk.clkr,
 	[GCC_VIDEO_GPLL0_DIV_CLK_SRC] = &gcc_video_gpll0_div_clk_src.clkr,
 	[GCC_VIDEO_THROTTLE_AXI_CLK] = &gcc_video_throttle_axi_clk.clkr,
-	[GCC_VIDEO_XO_CLK] = &gcc_video_xo_clk.clkr,
 	[GPLL0] = &gpll0.clkr,
 	[GPLL0_OUT_EVEN] = &gpll0_out_even.clkr,
 	[GPLL6] = &gpll6.clkr,
@@ -2510,6 +2468,9 @@ static int gcc_sc7180_probe(struct platform_device *pdev)
 	regmap_update_bits(regmap, 0x0b004, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x0b008, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x0b00c, BIT(0), BIT(0));
+	regmap_update_bits(regmap, 0x0b02c, BIT(0), BIT(0));
+	regmap_update_bits(regmap, 0x0b028, BIT(0), BIT(0));
+	regmap_update_bits(regmap, 0x0b030, BIT(0), BIT(0));
 	regmap_update_bits(regmap, 0x71004, BIT(0), BIT(0));
 
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
-- 
2.27.0



