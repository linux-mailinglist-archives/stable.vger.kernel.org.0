Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6A6BB35A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjCOMnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjCOMn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C40BA3B4D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C57D861D89
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D693BC4339C;
        Wed, 15 Mar 2023 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884131;
        bh=GD7bRPnmKLbCghxsUKpSfGGru8Lwm80DFDBP/5YwPmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1c3CN8Ll+3kS4T/pah0WTEBb0HO7udAjmZ3YyT5QRY1NzAcmYX6FHxy3spUEs2K6
         LNy0NvNiQEy2Yyx9E+IwCYuJArM/WBxsn4SvgwXf+1k/OzPITQ1F1lLON48P3l/8/Q
         IfL6dA78sQXAXCExOgjk1cNf627azz4KgGdT1+pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 118/141] clk: qcom: mmcc-apq8084: remove spdm clocks
Date:   Wed, 15 Mar 2023 13:13:41 +0100
Message-Id: <20230315115743.594890699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7b347f4b677b6d84687e67d82b6b17c6f55ea2b4 ]

SPDM is used for debug/profiling and does not have any other
functionality. These clocks can safely be removed.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Suggested-by: Georgi Djakov <djakov@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230111060402.1168726-11-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-apq8084.c | 271 --------------------------------
 1 file changed, 271 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index e9f9713591558..025e21793b3c4 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -2364,262 +2364,6 @@ static struct clk_branch mmss_rbcpr_clk = {
 	},
 };
 
-static struct clk_branch mmss_spdm_ahb_clk = {
-	.halt_reg = 0x0230,
-	.clkr = {
-		.enable_reg = 0x0230,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_ahb_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_ahb_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_axi_clk = {
-	.halt_reg = 0x0210,
-	.clkr = {
-		.enable_reg = 0x0210,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_axi_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_axi_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_csi0_clk = {
-	.halt_reg = 0x023c,
-	.clkr = {
-		.enable_reg = 0x023c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_csi0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_csi0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_gfx3d_clk = {
-	.halt_reg = 0x022c,
-	.clkr = {
-		.enable_reg = 0x022c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_gfx3d_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_gfx3d_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg0_clk = {
-	.halt_reg = 0x0204,
-	.clkr = {
-		.enable_reg = 0x0204,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg1_clk = {
-	.halt_reg = 0x0208,
-	.clkr = {
-		.enable_reg = 0x0208,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_jpeg2_clk = {
-	.halt_reg = 0x0224,
-	.clkr = {
-		.enable_reg = 0x0224,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_jpeg2_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_jpeg2_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_mdp_clk = {
-	.halt_reg = 0x020c,
-	.clkr = {
-		.enable_reg = 0x020c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_mdp_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_mdp_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_pclk0_clk = {
-	.halt_reg = 0x0234,
-	.clkr = {
-		.enable_reg = 0x0234,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_pclk0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_pclk0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_pclk1_clk = {
-	.halt_reg = 0x0228,
-	.clkr = {
-		.enable_reg = 0x0228,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_pclk1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_pclk1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vcodec0_clk = {
-	.halt_reg = 0x0214,
-	.clkr = {
-		.enable_reg = 0x0214,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vcodec0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vcodec0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vfe0_clk = {
-	.halt_reg = 0x0218,
-	.clkr = {
-		.enable_reg = 0x0218,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vfe0_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vfe0_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_vfe1_clk = {
-	.halt_reg = 0x021c,
-	.clkr = {
-		.enable_reg = 0x021c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_vfe1_clk",
-			.parent_names = (const char *[]){
-				"mmss_spdm_vfe1_div_clk",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_rm_axi_clk = {
-	.halt_reg = 0x0304,
-	.clkr = {
-		.enable_reg = 0x0304,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_rm_axi_clk",
-			.parent_names = (const char *[]){
-				"mmss_axi_clk_src",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch mmss_spdm_rm_ocmemnoc_clk = {
-	.halt_reg = 0x0308,
-	.clkr = {
-		.enable_reg = 0x0308,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "mmss_spdm_rm_ocmemnoc_clk",
-			.parent_names = (const char *[]){
-				"ocmemnoc_clk_src",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-
 static struct clk_branch mmss_misc_ahb_clk = {
 	.halt_reg = 0x502c,
 	.clkr = {
@@ -3252,21 +2996,6 @@ static struct clk_regmap *mmcc_apq8084_clocks[] = {
 	[MDSS_VSYNC_CLK] = &mdss_vsync_clk.clkr,
 	[MMSS_RBCPR_AHB_CLK] = &mmss_rbcpr_ahb_clk.clkr,
 	[MMSS_RBCPR_CLK] = &mmss_rbcpr_clk.clkr,
-	[MMSS_SPDM_AHB_CLK] = &mmss_spdm_ahb_clk.clkr,
-	[MMSS_SPDM_AXI_CLK] = &mmss_spdm_axi_clk.clkr,
-	[MMSS_SPDM_CSI0_CLK] = &mmss_spdm_csi0_clk.clkr,
-	[MMSS_SPDM_GFX3D_CLK] = &mmss_spdm_gfx3d_clk.clkr,
-	[MMSS_SPDM_JPEG0_CLK] = &mmss_spdm_jpeg0_clk.clkr,
-	[MMSS_SPDM_JPEG1_CLK] = &mmss_spdm_jpeg1_clk.clkr,
-	[MMSS_SPDM_JPEG2_CLK] = &mmss_spdm_jpeg2_clk.clkr,
-	[MMSS_SPDM_MDP_CLK] = &mmss_spdm_mdp_clk.clkr,
-	[MMSS_SPDM_PCLK0_CLK] = &mmss_spdm_pclk0_clk.clkr,
-	[MMSS_SPDM_PCLK1_CLK] = &mmss_spdm_pclk1_clk.clkr,
-	[MMSS_SPDM_VCODEC0_CLK] = &mmss_spdm_vcodec0_clk.clkr,
-	[MMSS_SPDM_VFE0_CLK] = &mmss_spdm_vfe0_clk.clkr,
-	[MMSS_SPDM_VFE1_CLK] = &mmss_spdm_vfe1_clk.clkr,
-	[MMSS_SPDM_RM_AXI_CLK] = &mmss_spdm_rm_axi_clk.clkr,
-	[MMSS_SPDM_RM_OCMEMNOC_CLK] = &mmss_spdm_rm_ocmemnoc_clk.clkr,
 	[MMSS_MISC_AHB_CLK] = &mmss_misc_ahb_clk.clkr,
 	[MMSS_MMSSNOC_AHB_CLK] = &mmss_mmssnoc_ahb_clk.clkr,
 	[MMSS_MMSSNOC_BTO_AHB_CLK] = &mmss_mmssnoc_bto_ahb_clk.clkr,
-- 
2.39.2



