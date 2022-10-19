Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216ED603E95
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiJSJQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiJSJOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B8BA6C0E;
        Wed, 19 Oct 2022 02:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1933B617DF;
        Wed, 19 Oct 2022 09:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB46C433C1;
        Wed, 19 Oct 2022 09:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170209;
        bh=ugBjsepRYvYP6ewZJtg3S2+9ioUPke2+iMbvqyO+qVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RONCrz/LAVxsOjuTpGS62qyeRl27dTnlAqybtkPttgYPnTCQfZttu6I8I504wR3WU
         INXYMjAEVAvCLUkrJCTDBr+bJ+9H88UoWeLEROCGo3N0d+zVQpWLDGYGKnUlAH2dnX
         ECkOtKVXIkYFXHgTSEBjs2cxTRvwnB7VJzTQsOP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Skladowski <a_skl39@protonmail.com>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 569/862] clk: qcom: gcc-sm6115: Override default Alpha PLL regs
Date:   Wed, 19 Oct 2022 10:30:56 +0200
Message-Id: <20221019083315.123056749@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Skladowski <a_skl39@protonmail.com>

[ Upstream commit 068a0605ef5a6b430e7278c169bfcd25b680b28f ]

The DEFAULT and BRAMMO PLL offsets are non-standard in downstream, but
currently only BRAMMO ones are overridden. Override DEFAULT ones too.

A very similar thing is happening in gcc-qcm2290 driver.

Fixes: cbe63bfdc54f ("clk: qcom: Add Global Clock controller (GCC) driver for SM6115")
Signed-off-by: Adam Skladowski <a_skl39@protonmail.com>
Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220830075620.974009-2-iskren.chernev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6115.c | 46 +++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm6115.c b/drivers/clk/qcom/gcc-sm6115.c
index 68fe9f6f0d2f..e24a977c2580 100644
--- a/drivers/clk/qcom/gcc-sm6115.c
+++ b/drivers/clk/qcom/gcc-sm6115.c
@@ -53,11 +53,25 @@ static struct pll_vco gpll10_vco[] = {
 	{ 750000000, 1500000000, 1 },
 };
 
+static const u8 clk_alpha_pll_regs_offset[][PLL_OFF_MAX_REGS] = {
+	[CLK_ALPHA_PLL_TYPE_DEFAULT] =  {
+		[PLL_OFF_L_VAL] = 0x04,
+		[PLL_OFF_ALPHA_VAL] = 0x08,
+		[PLL_OFF_ALPHA_VAL_U] = 0x0c,
+		[PLL_OFF_TEST_CTL] = 0x10,
+		[PLL_OFF_TEST_CTL_U] = 0x14,
+		[PLL_OFF_USER_CTL] = 0x18,
+		[PLL_OFF_USER_CTL_U] = 0x1c,
+		[PLL_OFF_CONFIG_CTL] = 0x20,
+		[PLL_OFF_STATUS] = 0x24,
+	},
+};
+
 static struct clk_alpha_pll gpll0 = {
 	.offset = 0x0,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(0),
@@ -83,7 +97,7 @@ static struct clk_alpha_pll_postdiv gpll0_out_aux2 = {
 	.post_div_table = post_div_table_gpll0_out_aux2,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll0_out_aux2),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_aux2",
 		.parent_hws = (const struct clk_hw *[]){ &gpll0.clkr.hw },
@@ -115,7 +129,7 @@ static struct clk_alpha_pll_postdiv gpll0_out_main = {
 	.post_div_table = post_div_table_gpll0_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll0_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll0.clkr.hw },
@@ -137,7 +151,7 @@ static struct clk_alpha_pll gpll10 = {
 	.offset = 0xa000,
 	.vco_table = gpll10_vco,
 	.num_vco = ARRAY_SIZE(gpll10_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(10),
@@ -163,7 +177,7 @@ static struct clk_alpha_pll_postdiv gpll10_out_main = {
 	.post_div_table = post_div_table_gpll10_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll10_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll10_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll10.clkr.hw },
@@ -189,7 +203,7 @@ static struct clk_alpha_pll gpll11 = {
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
 	.flags = SUPPORTS_DYNAMIC_UPDATE,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(11),
@@ -215,7 +229,7 @@ static struct clk_alpha_pll_postdiv gpll11_out_main = {
 	.post_div_table = post_div_table_gpll11_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll11_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll11_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll11.clkr.hw },
@@ -229,7 +243,7 @@ static struct clk_alpha_pll gpll3 = {
 	.offset = 0x3000,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(3),
@@ -248,7 +262,7 @@ static struct clk_alpha_pll gpll4 = {
 	.offset = 0x4000,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(4),
@@ -274,7 +288,7 @@ static struct clk_alpha_pll_postdiv gpll4_out_main = {
 	.post_div_table = post_div_table_gpll4_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll4_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll4.clkr.hw },
@@ -287,7 +301,7 @@ static struct clk_alpha_pll gpll6 = {
 	.offset = 0x6000,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(6),
@@ -313,7 +327,7 @@ static struct clk_alpha_pll_postdiv gpll6_out_main = {
 	.post_div_table = post_div_table_gpll6_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll6_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll6_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll6.clkr.hw },
@@ -326,7 +340,7 @@ static struct clk_alpha_pll gpll7 = {
 	.offset = 0x7000,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x79000,
 		.enable_mask = BIT(7),
@@ -352,7 +366,7 @@ static struct clk_alpha_pll_postdiv gpll7_out_main = {
 	.post_div_table = post_div_table_gpll7_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll7_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll7_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll7.clkr.hw },
@@ -380,7 +394,7 @@ static struct clk_alpha_pll gpll8 = {
 	.offset = 0x8000,
 	.vco_table = default_vco,
 	.num_vco = ARRAY_SIZE(default_vco),
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.flags = SUPPORTS_DYNAMIC_UPDATE,
 	.clkr = {
 		.enable_reg = 0x79000,
@@ -407,7 +421,7 @@ static struct clk_alpha_pll_postdiv gpll8_out_main = {
 	.post_div_table = post_div_table_gpll8_out_main,
 	.num_post_div = ARRAY_SIZE(post_div_table_gpll8_out_main),
 	.width = 4,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs_offset[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll8_out_main",
 		.parent_hws = (const struct clk_hw *[]){ &gpll8.clkr.hw },
-- 
2.35.1



