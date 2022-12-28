Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD5657E5A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiL1Pw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiL1Pwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4313186BC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61D5161570
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72343C433D2;
        Wed, 28 Dec 2022 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242773;
        bh=ao/zCP+5wM+bBx2k8+4Ko7LKgp2A0wGkuydgVR+P1BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGB3G0oL0tl066bm2GozS8KJdb6TSUT8gqLodVzh5cUDoGVPoGzZj8G67WCk1sT3P
         Frl/EftnoX3zBUV0V1ZjMp0ocQ+uR3LbS2UK3AhTnH+ar93SVF/wfsbyVHZAfDqhhz
         VRtDOnITFMbgO/VU0U8ooE+rmqgqSmI6ZB85WDbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Taniya Das <quic_tdas@quicinc.com>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0450/1073] clk: qcom: lpass: Handle the regmap overlap of lpasscc and lpass_aon
Date:   Wed, 28 Dec 2022 15:33:58 +0100
Message-Id: <20221228144340.254126077@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 0cbcfbe50cbff331c775982a53bc4fa66c875b36 ]

Move registration of lpass_q6ss_ahbm_clk and lpass_q6ss_ahbs_clk to
lpass_aon_cc_sc7280_probe and register them only if "qcom,adsp-pil-mode"
is enabled in the lpass_aon DT node.

Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1662005846-4838-3-git-send-email-quic_c_skakit@quicinc.com
Stable-dep-of: d470be3c4f30 ("clk: qcom: lpass-sc7280: Fix pm_runtime usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpassaudiocc-sc7280.c | 44 ++++++++++++++++++++++++++
 drivers/clk/qcom/lpasscc-sc7280.c      | 44 --------------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/clk/qcom/lpassaudiocc-sc7280.c b/drivers/clk/qcom/lpassaudiocc-sc7280.c
index 6ab6e5a34c72..606732879fea 100644
--- a/drivers/clk/qcom/lpassaudiocc-sc7280.c
+++ b/drivers/clk/qcom/lpassaudiocc-sc7280.c
@@ -12,6 +12,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 
+#include <dt-bindings/clock/qcom,lpass-sc7280.h>
 #include <dt-bindings/clock/qcom,lpassaudiocc-sc7280.h>
 
 #include "clk-alpha-pll.h"
@@ -38,6 +39,32 @@ static const struct pll_vco zonda_vco[] = {
 	{ 595200000UL, 3600000000UL, 0 },
 };
 
+static struct clk_branch lpass_q6ss_ahbm_clk = {
+	.halt_reg = 0x901c,
+	.halt_check = BRANCH_HALT,
+	.clkr = {
+		.enable_reg = 0x901c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+				.name = "lpass_q6ss_ahbm_clk",
+				.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch lpass_q6ss_ahbs_clk = {
+	.halt_reg = 0x9020,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x9020,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "lpass_q6ss_ahbs_clk",
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 /* 1128.96MHz configuration */
 static const struct alpha_pll_config lpass_audio_cc_pll_config = {
 	.l = 0x3a,
@@ -614,6 +641,11 @@ static struct gdsc lpass_aon_cc_lpass_audio_hm_gdsc = {
 	.flags = RETAIN_FF_ENABLE,
 };
 
+static struct clk_regmap *lpass_cc_sc7280_clocks[] = {
+	[LPASS_Q6SS_AHBM_CLK] = &lpass_q6ss_ahbm_clk.clkr,
+	[LPASS_Q6SS_AHBS_CLK] = &lpass_q6ss_ahbs_clk.clkr,
+};
+
 static struct clk_regmap *lpass_aon_cc_sc7280_clocks[] = {
 	[LPASS_AON_CC_AUDIO_HM_H_CLK] = &lpass_aon_cc_audio_hm_h_clk.clkr,
 	[LPASS_AON_CC_VA_MEM0_CLK] = &lpass_aon_cc_va_mem0_clk.clkr,
@@ -659,6 +691,12 @@ static struct regmap_config lpass_audio_cc_sc7280_regmap_config = {
 	.fast_io = true,
 };
 
+static const struct qcom_cc_desc lpass_cc_sc7280_desc = {
+	.config = &lpass_audio_cc_sc7280_regmap_config,
+	.clks = lpass_cc_sc7280_clocks,
+	.num_clks = ARRAY_SIZE(lpass_cc_sc7280_clocks),
+};
+
 static const struct qcom_cc_desc lpass_audio_cc_sc7280_desc = {
 	.config = &lpass_audio_cc_sc7280_regmap_config,
 	.clks = lpass_audio_cc_sc7280_clocks,
@@ -785,6 +823,12 @@ static int lpass_aon_cc_sc7280_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (of_property_read_bool(pdev->dev.of_node, "qcom,adsp-pil-mode")) {
+		lpass_audio_cc_sc7280_regmap_config.name = "cc";
+		desc = &lpass_cc_sc7280_desc;
+		return qcom_cc_probe(pdev, desc);
+	}
+
 	lpass_audio_cc_sc7280_regmap_config.name = "lpasscc_aon";
 	lpass_audio_cc_sc7280_regmap_config.max_register = 0xa0008;
 	desc = &lpass_aon_cc_sc7280_desc;
diff --git a/drivers/clk/qcom/lpasscc-sc7280.c b/drivers/clk/qcom/lpasscc-sc7280.c
index b39ee1c9647b..5c1e17bd0d76 100644
--- a/drivers/clk/qcom/lpasscc-sc7280.c
+++ b/drivers/clk/qcom/lpasscc-sc7280.c
@@ -17,32 +17,6 @@
 #include "clk-branch.h"
 #include "common.h"
 
-static struct clk_branch lpass_q6ss_ahbm_clk = {
-	.halt_reg = 0x1c,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0x1c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "lpass_q6ss_ahbm_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch lpass_q6ss_ahbs_clk = {
-	.halt_reg = 0x20,
-	.halt_check = BRANCH_HALT_VOTED,
-	.clkr = {
-		.enable_reg = 0x20,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "lpass_q6ss_ahbs_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch lpass_top_cc_lpi_q6_axim_hs_clk = {
 	.halt_reg = 0x0,
 	.halt_check = BRANCH_HALT,
@@ -105,17 +79,6 @@ static struct regmap_config lpass_regmap_config = {
 	.fast_io	= true,
 };
 
-static struct clk_regmap *lpass_cc_sc7280_clocks[] = {
-	[LPASS_Q6SS_AHBM_CLK] = &lpass_q6ss_ahbm_clk.clkr,
-	[LPASS_Q6SS_AHBS_CLK] = &lpass_q6ss_ahbs_clk.clkr,
-};
-
-static const struct qcom_cc_desc lpass_cc_sc7280_desc = {
-	.config = &lpass_regmap_config,
-	.clks = lpass_cc_sc7280_clocks,
-	.num_clks = ARRAY_SIZE(lpass_cc_sc7280_clocks),
-};
-
 static struct clk_regmap *lpass_cc_top_sc7280_clocks[] = {
 	[LPASS_TOP_CC_LPI_Q6_AXIM_HS_CLK] =
 				&lpass_top_cc_lpi_q6_axim_hs_clk.clkr,
@@ -169,13 +132,6 @@ static int lpass_cc_sc7280_probe(struct platform_device *pdev)
 	if (ret)
 		goto destroy_pm_clk;
 
-	lpass_regmap_config.name = "cc";
-	desc = &lpass_cc_sc7280_desc;
-
-	ret = qcom_cc_probe_by_index(pdev, 2, desc);
-	if (ret)
-		goto destroy_pm_clk;
-
 	return 0;
 
 destroy_pm_clk:
-- 
2.35.1



