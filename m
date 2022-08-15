Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FC1594B55
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352040AbiHPAOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357310AbiHPANV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C064D176526;
        Mon, 15 Aug 2022 13:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFE0B61135;
        Mon, 15 Aug 2022 20:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA7C433C1;
        Mon, 15 Aug 2022 20:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595394;
        bh=/EF4z/uxQCTHAXnRvEbMiDLRJBQ1km36r9FTaXO2r6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrAuOuTw1z55TcoFopFNZGSiLRyvcv2VQwDLIK8KuMCFC1GawSlwjF2qzrTZm/eeq
         Jyx57eEPY+4Tu2Lt8TI4LcNu26AtXXH7IhCWBeRNSzRScVXpDWIlTCvDuNnCaoqXS4
         tikFTYOGuvRgl4VFApktBhVwZOLrsR8+ETaZ1gvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0750/1157] clk: qcom: gcc-msm8939: Add missing system_mm_noc_bfdcd_clk_src
Date:   Mon, 15 Aug 2022 20:01:46 +0200
Message-Id: <20220815180509.492125676@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit dd363e2f7196278e7a30f509a0e8a841cb763b14 ]

The msm8939 has an additional higher operating point for the multi-media
peripherals. The higher throughput MM componets operate off of the
system-mm noc not the system noc.

system_mm_noc_bfdcd_clk_src is the source clock for the higher frequency
capable system noc mm.

Maximum frequency for the MM SNOC is 400 MHz.

Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220504163835.40130-4-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8939.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8939.c b/drivers/clk/qcom/gcc-msm8939.c
index 31568658d23d..12bab9067ea8 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -644,6 +644,18 @@ static struct clk_rcg2 bimc_ddr_clk_src = {
 	},
 };
 
+static struct clk_rcg2 system_mm_noc_bfdcd_clk_src = {
+	.cmd_rcgr = 0x2600c,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll6a_map,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "system_mm_noc_bfdcd_clk_src",
+		.parent_data = gcc_xo_gpll0_gpll6a_parent_data,
+		.num_parents = 3,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_camss_ahb_clk[] = {
 	F(40000000, P_GPLL0, 10, 1, 2),
 	F(80000000, P_GPLL0, 10, 0, 0),
@@ -3623,6 +3635,7 @@ static struct clk_regmap *gcc_msm8939_clocks[] = {
 	[GPLL2_VOTE] = &gpll2_vote,
 	[PCNOC_BFDCD_CLK_SRC] = &pcnoc_bfdcd_clk_src.clkr,
 	[SYSTEM_NOC_BFDCD_CLK_SRC] = &system_noc_bfdcd_clk_src.clkr,
+	[SYSTEM_MM_NOC_BFDCD_CLK_SRC] = &system_mm_noc_bfdcd_clk_src.clkr,
 	[CAMSS_AHB_CLK_SRC] = &camss_ahb_clk_src.clkr,
 	[APSS_AHB_CLK_SRC] = &apss_ahb_clk_src.clkr,
 	[CSI0_CLK_SRC] = &csi0_clk_src.clkr,
-- 
2.35.1



