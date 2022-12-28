Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59C4657EC5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiL1P5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiL1P5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:57:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2770C17E2C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8326613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10B7C433F2;
        Wed, 28 Dec 2022 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243037;
        bh=o+y151IPseMCCT0U0XE/oHNRBzgip+BsIVPLHV30Z/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC/pCQoro/6DUjKzGlTCeImdBdBDdPdaZ12aaz6cWPNgh//aq4LLOhpw9DLHDZzgC
         XtjkzDdk0gQhQ1Ql8Y1lOQOSljihlVh+sDhOEbeVLEnaLuTQKYi39hkiFpQXbnjHyj
         2HBjMHZSDpo8PEQBf5Rd0Z5e6+U82ib/haWrBZN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Taniya Das <quic_tdas@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0451/1073] clk: qcom: lpass: Add support for resets & external mclk for SC7280
Date:   Wed, 28 Dec 2022 15:33:59 +0100
Message-Id: <20221228144340.281486448@linuxfoundation.org>
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

[ Upstream commit 7c6a6641c24d30ab6f5456d19e15e64bea971b82 ]

The clock gating control for TX/RX/WSA core bus clocks would be required
to be reset(moved from hardware control) from audio core driver. Thus
add the support for the reset clocks.

Update the lpass_aon_cc_main_rcg_clk_src ops to park the RCG at XO after
disable as this clock signal is used by hardware to turn ON memories in
LPASS. Also add the external mclk to interface external MI2S.

Fixes: a9dd26639d05 ("clk: qcom: lpass: Add support for LPASS clock controller for SC7280")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1662005846-4838-6-git-send-email-quic_c_skakit@quicinc.com
Stable-dep-of: d470be3c4f30 ("clk: qcom: lpass-sc7280: Fix pm_runtime usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpassaudiocc-sc7280.c | 24 +++++++++++++++++--
 drivers/clk/qcom/lpasscorecc-sc7280.c  | 33 ++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/lpassaudiocc-sc7280.c b/drivers/clk/qcom/lpassaudiocc-sc7280.c
index 606732879fea..5d4bc563073c 100644
--- a/drivers/clk/qcom/lpassaudiocc-sc7280.c
+++ b/drivers/clk/qcom/lpassaudiocc-sc7280.c
@@ -23,6 +23,7 @@
 #include "clk-regmap-mux.h"
 #include "common.h"
 #include "gdsc.h"
+#include "reset.h"
 
 enum {
 	P_BI_TCXO,
@@ -248,7 +249,7 @@ static struct clk_rcg2 lpass_aon_cc_main_rcg_clk_src = {
 		.parent_data = lpass_aon_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(lpass_aon_cc_parent_data_0),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -703,6 +704,18 @@ static const struct qcom_cc_desc lpass_audio_cc_sc7280_desc = {
 	.num_clks = ARRAY_SIZE(lpass_audio_cc_sc7280_clocks),
 };
 
+static const struct qcom_reset_map lpass_audio_cc_sc7280_resets[] = {
+	[LPASS_AUDIO_SWR_RX_CGCR] =  { 0xa0, 1 },
+	[LPASS_AUDIO_SWR_TX_CGCR] =  { 0xa8, 1 },
+	[LPASS_AUDIO_SWR_WSA_CGCR] = { 0xb0, 1 },
+};
+
+static const struct qcom_cc_desc lpass_audio_cc_reset_sc7280_desc = {
+	.config = &lpass_audio_cc_sc7280_regmap_config,
+	.resets = lpass_audio_cc_sc7280_resets,
+	.num_resets = ARRAY_SIZE(lpass_audio_cc_sc7280_resets),
+};
+
 static const struct of_device_id lpass_audio_cc_sc7280_match_table[] = {
 	{ .compatible = "qcom,sc7280-lpassaudiocc" },
 	{ }
@@ -772,13 +785,20 @@ static int lpass_audio_cc_sc7280_probe(struct platform_device *pdev)
 	regmap_write(regmap, 0x4, 0x3b);
 	regmap_write(regmap, 0x8, 0xff05);
 
-	ret = qcom_cc_really_probe(pdev, &lpass_audio_cc_sc7280_desc, regmap);
+	ret = qcom_cc_probe_by_index(pdev, 0, &lpass_audio_cc_sc7280_desc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register LPASS AUDIO CC clocks\n");
 		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
+	ret = qcom_cc_probe_by_index(pdev, 1, &lpass_audio_cc_reset_sc7280_desc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register LPASS AUDIO CC Resets\n");
+		pm_runtime_disable(&pdev->dev);
+		return ret;
+	}
+
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
diff --git a/drivers/clk/qcom/lpasscorecc-sc7280.c b/drivers/clk/qcom/lpasscorecc-sc7280.c
index 1f1f1bd1b68e..6ad19b06b1ce 100644
--- a/drivers/clk/qcom/lpasscorecc-sc7280.c
+++ b/drivers/clk/qcom/lpasscorecc-sc7280.c
@@ -190,6 +190,19 @@ static struct clk_rcg2 lpass_core_cc_ext_if1_clk_src = {
 	},
 };
 
+static struct clk_rcg2 lpass_core_cc_ext_mclk0_clk_src = {
+	.cmd_rcgr = 0x20000,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = lpass_core_cc_parent_map_0,
+	.freq_tbl = ftbl_lpass_core_cc_ext_if0_clk_src,
+	.clkr.hw.init = &(const struct clk_init_data){
+		.name = "lpass_core_cc_ext_mclk0_clk_src",
+		.parent_data = lpass_core_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(lpass_core_cc_parent_data_0),
+		.ops = &clk_rcg2_ops,
+	},
+};
 
 static struct clk_branch lpass_core_cc_core_clk = {
 	.halt_reg = 0x1f000,
@@ -283,6 +296,24 @@ static struct clk_branch lpass_core_cc_lpm_mem0_core_clk = {
 	},
 };
 
+static struct clk_branch lpass_core_cc_ext_mclk0_clk = {
+	.halt_reg = 0x20014,
+	.halt_check = BRANCH_HALT,
+	.clkr = {
+		.enable_reg = 0x20014,
+		.enable_mask = BIT(0),
+		.hw.init = &(const struct clk_init_data){
+			.name = "lpass_core_cc_ext_mclk0_clk",
+			.parent_hws = (const struct clk_hw*[]){
+				&lpass_core_cc_ext_mclk0_clk_src.clkr.hw,
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch lpass_core_cc_sysnoc_mport_core_clk = {
 	.halt_reg = 0x23000,
 	.halt_check = BRANCH_HALT_VOTED,
@@ -326,6 +357,8 @@ static struct clk_regmap *lpass_core_cc_sc7280_clocks[] = {
 	[LPASS_CORE_CC_LPM_CORE_CLK] = &lpass_core_cc_lpm_core_clk.clkr,
 	[LPASS_CORE_CC_LPM_MEM0_CORE_CLK] = &lpass_core_cc_lpm_mem0_core_clk.clkr,
 	[LPASS_CORE_CC_SYSNOC_MPORT_CORE_CLK] = &lpass_core_cc_sysnoc_mport_core_clk.clkr,
+	[LPASS_CORE_CC_EXT_MCLK0_CLK] = &lpass_core_cc_ext_mclk0_clk.clkr,
+	[LPASS_CORE_CC_EXT_MCLK0_CLK_SRC] = &lpass_core_cc_ext_mclk0_clk_src.clkr,
 };
 
 static struct regmap_config lpass_core_cc_sc7280_regmap_config = {
-- 
2.35.1



