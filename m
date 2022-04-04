Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE74F1380
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355773AbiDDK7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiDDK7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F4B3389C
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4078B815A0
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 10:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA3EC2BBE4;
        Mon,  4 Apr 2022 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649069824;
        bh=DyHHCaiH9KBHEYtEyLhPM9Q7ICua/+Qf8ck3v1xFLFM=;
        h=Subject:To:Cc:From:Date:From;
        b=s5YGc6vNg6jQYjN2UEtrBIp4K/05N8JIjpqLunaOXOu+Hyyzz61OrUedqQKG24l8k
         nQAfywefOeudbG/20oobu9Bdno7Pg0OdZalEvuH40NOfJWAtKEE/mM42FPaP6rqDPZ
         Q6EdZN7pzE0sSJ3fKTTRj+Prz8i56IcfJmUilF8M=
Subject: FAILED: patch "[PATCH] clk: qcom: smd: Add missing RPM clocks for msm8992/4" failed to apply to 5.15-stable tree
To:     konrad.dybcio@somainline.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 12:57:02 +0200
Message-ID: <164906982276139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f804360bb3a50decbed6e2761247964dca72c080 Mon Sep 17 00:00:00 2001
From: Konrad Dybcio <konrad.dybcio@somainline.org>
Date: Sat, 26 Feb 2022 22:41:25 +0100
Subject: [PATCH] clk: qcom: smd: Add missing RPM clocks for msm8992/4

XO and MSS_CFG were omitted when first adding the clocks for these SoCs.
Add them, and while at it, move the XO clock to the top of the definition
list, as ideally everyone should start using it sooner or later..

Fixes: b4297844995f ("clk: qcom: smd: Add support for MSM8992/4 rpm clocks")
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220226214126.21209-2-konrad.dybcio@somainline.org

diff --git a/drivers/clk/qcom/clk-smd-rpm.c b/drivers/clk/qcom/clk-smd-rpm.c
index ea28e45ca371..418f017e933f 100644
--- a/drivers/clk/qcom/clk-smd-rpm.c
+++ b/drivers/clk/qcom/clk-smd-rpm.c
@@ -413,6 +413,7 @@ static const struct clk_ops clk_smd_rpm_branch_ops = {
 	.recalc_rate	= clk_smd_rpm_recalc_rate,
 };
 
+DEFINE_CLK_SMD_RPM_BRANCH(sdm660, bi_tcxo, bi_tcxo_a, QCOM_SMD_RPM_MISC_CLK, 0, 19200000);
 DEFINE_CLK_SMD_RPM(msm8916, pcnoc_clk, pcnoc_a_clk, QCOM_SMD_RPM_BUS_CLK, 0);
 DEFINE_CLK_SMD_RPM(msm8916, snoc_clk, snoc_a_clk, QCOM_SMD_RPM_BUS_CLK, 1);
 DEFINE_CLK_SMD_RPM(msm8916, bimc_clk, bimc_a_clk, QCOM_SMD_RPM_MEM_CLK, 0);
@@ -604,7 +605,11 @@ DEFINE_CLK_SMD_RPM_XO_BUFFER(msm8992, ln_bb_clk, ln_bb_a_clk, 8, 19200000);
 DEFINE_CLK_SMD_RPM(msm8992, ce1_clk, ce1_a_clk, QCOM_SMD_RPM_CE_CLK, 0);
 DEFINE_CLK_SMD_RPM(msm8992, ce2_clk, ce2_a_clk, QCOM_SMD_RPM_CE_CLK, 1);
 
+DEFINE_CLK_SMD_RPM_BRANCH(msm8992, mss_cfg_ahb_clk, mss_cfg_ahb_a_clk,
+			  QCOM_SMD_RPM_MCFG_CLK, 0, 19200000);
 static struct clk_smd_rpm *msm8992_clks[] = {
+	[RPM_SMD_XO_CLK_SRC] = &sdm660_bi_tcxo,
+	[RPM_SMD_XO_A_CLK_SRC] = &sdm660_bi_tcxo_a,
 	[RPM_SMD_PNOC_CLK] = &msm8916_pcnoc_clk,
 	[RPM_SMD_PNOC_A_CLK] = &msm8916_pcnoc_a_clk,
 	[RPM_SMD_OCMEMGX_CLK] = &msm8974_ocmemgx_clk,
@@ -637,6 +642,8 @@ static struct clk_smd_rpm *msm8992_clks[] = {
 	[RPM_SMD_LN_BB_A_CLK] = &msm8992_ln_bb_a_clk,
 	[RPM_SMD_MMSSNOC_AHB_CLK] = &msm8974_mmssnoc_ahb_clk,
 	[RPM_SMD_MMSSNOC_AHB_A_CLK] = &msm8974_mmssnoc_ahb_a_clk,
+	[RPM_SMD_MSS_CFG_AHB_CLK] = &msm8992_mss_cfg_ahb_clk,
+	[RPM_SMD_MSS_CFG_AHB_A_CLK] = &msm8992_mss_cfg_ahb_a_clk,
 	[RPM_SMD_QDSS_CLK] = &msm8916_qdss_clk,
 	[RPM_SMD_QDSS_A_CLK] = &msm8916_qdss_a_clk,
 	[RPM_SMD_RF_CLK1] = &msm8916_rf_clk1,
@@ -661,6 +668,8 @@ static const struct rpm_smd_clk_desc rpm_clk_msm8992 = {
 DEFINE_CLK_SMD_RPM(msm8994, ce3_clk, ce3_a_clk, QCOM_SMD_RPM_CE_CLK, 2);
 
 static struct clk_smd_rpm *msm8994_clks[] = {
+	[RPM_SMD_XO_CLK_SRC] = &sdm660_bi_tcxo,
+	[RPM_SMD_XO_A_CLK_SRC] = &sdm660_bi_tcxo_a,
 	[RPM_SMD_PNOC_CLK] = &msm8916_pcnoc_clk,
 	[RPM_SMD_PNOC_A_CLK] = &msm8916_pcnoc_a_clk,
 	[RPM_SMD_OCMEMGX_CLK] = &msm8974_ocmemgx_clk,
@@ -693,6 +702,8 @@ static struct clk_smd_rpm *msm8994_clks[] = {
 	[RPM_SMD_LN_BB_A_CLK] = &msm8992_ln_bb_a_clk,
 	[RPM_SMD_MMSSNOC_AHB_CLK] = &msm8974_mmssnoc_ahb_clk,
 	[RPM_SMD_MMSSNOC_AHB_A_CLK] = &msm8974_mmssnoc_ahb_a_clk,
+	[RPM_SMD_MSS_CFG_AHB_CLK] = &msm8992_mss_cfg_ahb_clk,
+	[RPM_SMD_MSS_CFG_AHB_A_CLK] = &msm8992_mss_cfg_ahb_a_clk,
 	[RPM_SMD_QDSS_CLK] = &msm8916_qdss_clk,
 	[RPM_SMD_QDSS_A_CLK] = &msm8916_qdss_a_clk,
 	[RPM_SMD_RF_CLK1] = &msm8916_rf_clk1,
@@ -857,8 +868,6 @@ static const struct rpm_smd_clk_desc rpm_clk_msm8998 = {
 	.num_clks = ARRAY_SIZE(msm8998_clks),
 };
 
-DEFINE_CLK_SMD_RPM_BRANCH(sdm660, bi_tcxo, bi_tcxo_a, QCOM_SMD_RPM_MISC_CLK, 0,
-								19200000);
 DEFINE_CLK_SMD_RPM_XO_BUFFER(sdm660, ln_bb_clk3, ln_bb_clk3_a, 3, 19200000);
 DEFINE_CLK_SMD_RPM_XO_BUFFER_PINCTRL(sdm660, ln_bb_clk3_pin, ln_bb_clk3_pin_a, 3, 19200000);
 
diff --git a/include/linux/soc/qcom/smd-rpm.h b/include/linux/soc/qcom/smd-rpm.h
index 860dd8cdf9f3..82c9d489833a 100644
--- a/include/linux/soc/qcom/smd-rpm.h
+++ b/include/linux/soc/qcom/smd-rpm.h
@@ -40,6 +40,7 @@ struct qcom_smd_rpm;
 #define QCOM_SMD_RPM_AGGR_CLK	0x72676761
 #define QCOM_SMD_RPM_HWKM_CLK	0x6d6b7768
 #define QCOM_SMD_RPM_PKA_CLK	0x616b70
+#define QCOM_SMD_RPM_MCFG_CLK	0x6766636d
 
 int qcom_rpm_smd_write(struct qcom_smd_rpm *rpm,
 		       int state,

