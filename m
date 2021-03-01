Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58603286ED
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhCARRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbhCARIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934B065018;
        Mon,  1 Mar 2021 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616940;
        bh=PdDv6asHfFZeqWj+Jpj+s9b7R1PhIqgfylTfSnMy+rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpQyTlNmXXWsCgv8BgjU1Lkp3E1CyIU8x+rW2jjiDvYH1kwNikxHhxYAq5Olm2KFy
         vJx5NIU7ip6FGfTcZbh0lu21zkzX8bfLc/IQ0F/NKWldhBJcQhdmMtLSzYbh8sbQBs
         uhVYoG2lI9Dsywm0komW4ZOQ8NggBwUlB9tgZO6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/247] clk: qcom: gcc-msm8998: Fix Alpha PLL type for all GPLLs
Date:   Mon,  1 Mar 2021 17:12:47 +0100
Message-Id: <20210301161038.870932496@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 292f75ecff07e8a07fe2e3e19b4b567d0b698842 ]

All of the GPLLs in the MSM8998 Global Clock Controller are Fabia PLLs
and not generic alphas: this was producing bad effects over the entire
clock tree of MSM8998, where any GPLL child clock was declaring a false
clock rate, due to their parent also showing the same.

The issue resides in the calculation of the clock rate for the specific
Alpha PLL type, where Fabia has a different register layout; switching
the MSM8998 GPLLs to the correct Alpha Fabia PLL type fixes the rate
(calculation) reading. While at it, also make these PLLs fixed since
their rate is supposed to *never* be changed while the system runs, as
this would surely crash the entire SoC.

Now all the children of all the PLLs are also complying with their
specified clock table and system stability is improved.

Fixes: b5f5f525c547 ("clk: qcom: Add MSM8998 Global Clock Control (GCC) driver")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210114221059.483390-7-angelogioacchino.delregno@somainline.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8998.c | 100 ++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8998.c b/drivers/clk/qcom/gcc-msm8998.c
index 772a08101ddf2..0ccd6b79cb5e7 100644
--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -124,7 +124,7 @@ static struct pll_vco fabia_vco[] = {
 
 static struct clk_alpha_pll gpll0 = {
 	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.vco_table = fabia_vco,
 	.num_vco = ARRAY_SIZE(fabia_vco),
 	.clkr = {
@@ -134,58 +134,58 @@ static struct clk_alpha_pll gpll0 = {
 			.name = "gpll0",
 			.parent_names = (const char *[]){ "xo" },
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_ops,
+			.ops = &clk_alpha_pll_fixed_fabia_ops,
 		}
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll0_out_even = {
 	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_even",
 		.parent_names = (const char *[]){ "gpll0" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll0_out_main = {
 	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_main",
 		.parent_names = (const char *[]){ "gpll0" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll0_out_odd = {
 	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_odd",
 		.parent_names = (const char *[]){ "gpll0" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll0_out_test = {
 	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll0_out_test",
 		.parent_names = (const char *[]){ "gpll0" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll gpll1 = {
 	.offset = 0x1000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.vco_table = fabia_vco,
 	.num_vco = ARRAY_SIZE(fabia_vco),
 	.clkr = {
@@ -195,58 +195,58 @@ static struct clk_alpha_pll gpll1 = {
 			.name = "gpll1",
 			.parent_names = (const char *[]){ "xo" },
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_ops,
+			.ops = &clk_alpha_pll_fixed_fabia_ops,
 		}
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll1_out_even = {
 	.offset = 0x1000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll1_out_even",
 		.parent_names = (const char *[]){ "gpll1" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll1_out_main = {
 	.offset = 0x1000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll1_out_main",
 		.parent_names = (const char *[]){ "gpll1" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll1_out_odd = {
 	.offset = 0x1000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll1_out_odd",
 		.parent_names = (const char *[]){ "gpll1" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll1_out_test = {
 	.offset = 0x1000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll1_out_test",
 		.parent_names = (const char *[]){ "gpll1" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll gpll2 = {
 	.offset = 0x2000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.vco_table = fabia_vco,
 	.num_vco = ARRAY_SIZE(fabia_vco),
 	.clkr = {
@@ -256,58 +256,58 @@ static struct clk_alpha_pll gpll2 = {
 			.name = "gpll2",
 			.parent_names = (const char *[]){ "xo" },
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_ops,
+			.ops = &clk_alpha_pll_fixed_fabia_ops,
 		}
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll2_out_even = {
 	.offset = 0x2000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll2_out_even",
 		.parent_names = (const char *[]){ "gpll2" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll2_out_main = {
 	.offset = 0x2000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll2_out_main",
 		.parent_names = (const char *[]){ "gpll2" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll2_out_odd = {
 	.offset = 0x2000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll2_out_odd",
 		.parent_names = (const char *[]){ "gpll2" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll2_out_test = {
 	.offset = 0x2000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll2_out_test",
 		.parent_names = (const char *[]){ "gpll2" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll gpll3 = {
 	.offset = 0x3000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.vco_table = fabia_vco,
 	.num_vco = ARRAY_SIZE(fabia_vco),
 	.clkr = {
@@ -317,58 +317,58 @@ static struct clk_alpha_pll gpll3 = {
 			.name = "gpll3",
 			.parent_names = (const char *[]){ "xo" },
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_ops,
+			.ops = &clk_alpha_pll_fixed_fabia_ops,
 		}
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll3_out_even = {
 	.offset = 0x3000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll3_out_even",
 		.parent_names = (const char *[]){ "gpll3" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll3_out_main = {
 	.offset = 0x3000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll3_out_main",
 		.parent_names = (const char *[]){ "gpll3" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll3_out_odd = {
 	.offset = 0x3000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll3_out_odd",
 		.parent_names = (const char *[]){ "gpll3" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll3_out_test = {
 	.offset = 0x3000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll3_out_test",
 		.parent_names = (const char *[]){ "gpll3" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll gpll4 = {
 	.offset = 0x77000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.vco_table = fabia_vco,
 	.num_vco = ARRAY_SIZE(fabia_vco),
 	.clkr = {
@@ -378,52 +378,52 @@ static struct clk_alpha_pll gpll4 = {
 			.name = "gpll4",
 			.parent_names = (const char *[]){ "xo" },
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_ops,
+			.ops = &clk_alpha_pll_fixed_fabia_ops,
 		}
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll4_out_even = {
 	.offset = 0x77000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4_out_even",
 		.parent_names = (const char *[]){ "gpll4" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll4_out_main = {
 	.offset = 0x77000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4_out_main",
 		.parent_names = (const char *[]){ "gpll4" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll4_out_odd = {
 	.offset = 0x77000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4_out_odd",
 		.parent_names = (const char *[]){ "gpll4" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
 static struct clk_alpha_pll_postdiv gpll4_out_test = {
 	.offset = 0x77000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gpll4_out_test",
 		.parent_names = (const char *[]){ "gpll4" },
 		.num_parents = 1,
-		.ops = &clk_alpha_pll_postdiv_ops,
+		.ops = &clk_alpha_pll_postdiv_fabia_ops,
 	},
 };
 
-- 
2.27.0



