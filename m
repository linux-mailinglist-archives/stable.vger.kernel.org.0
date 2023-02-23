Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3636A0988
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjBWNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbjBWNHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:07:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7525652F
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AAFACE2023
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623ABC433EF;
        Thu, 23 Feb 2023 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157649;
        bh=sHpeTvxJ2hbd0m1Y4dPLVp6TbmXXDaERRH1DBBK2bMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mN8dtZPelP4w82KMeMeWSlLXuKCfOBOXjCV5qVPqjD1wxmhr2s7VwW3eT3Lw2dFW1
         8l4naF62i6/Z1rPjHqPzMNNVS2mFU0l5VrHnZiA6UMW9zYZPfeFAlmqUJb/w45Wdxi
         2vBG08tZKpo5nHnVZae8Z30gd6ndHtktGapAh5/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi xin Zhu <yzhu@maxlinear.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/25] clk: mxl: Remove redundant spinlocks
Date:   Thu, 23 Feb 2023 14:06:21 +0100
Message-Id: <20230223130426.974572135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit eaabee88a88a26b108be8d120fc072dfaf462cef ]

Patch 1/4 of this patch series switches from direct readl/writel
based register access to regmap based register access. Instead
of using direct readl/writel, regmap API's are used to read, write
& read-modify-write clk registers. Regmap API's already use their
own spinlocks to serialize the register accesses across multiple
cores in which case additional driver spinlocks becomes redundant.

Hence, remove redundant spinlocks from driver in this patch 2/4.

Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/a8a02c8773b88924503a9fdaacd37dd2e6488bf3.1665642720.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 106ef3bda210 ("clk: mxl: Fix a clk entry by adding relevant flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu-pll.c | 13 ------
 drivers/clk/x86/clk-cgu.c     | 80 ++++-------------------------------
 drivers/clk/x86/clk-cgu.h     |  6 ---
 drivers/clk/x86/clk-lgm.c     |  1 -
 4 files changed, 9 insertions(+), 91 deletions(-)

diff --git a/drivers/clk/x86/clk-cgu-pll.c b/drivers/clk/x86/clk-cgu-pll.c
index c83083affe88e..409dbf55f4cae 100644
--- a/drivers/clk/x86/clk-cgu-pll.c
+++ b/drivers/clk/x86/clk-cgu-pll.c
@@ -41,13 +41,10 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
 	unsigned int div, mult, frac;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	mult = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 0, 12);
 	div = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 18, 6);
 	frac = lgm_get_clk_val(pll->membase, pll->reg, 2, 24);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	if (pll->type == TYPE_LJPLL)
 		div *= 4;
@@ -58,12 +55,9 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 static int lgm_pll_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	ret = lgm_get_clk_val(pll->membase, pll->reg, 0, 1);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
 }
@@ -71,16 +65,13 @@ static int lgm_pll_is_enabled(struct clk_hw *hw)
 static int lgm_pll_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	u32 val;
 	int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 1);
 	ret = regmap_read_poll_timeout_atomic(pll->membase, pll->reg,
 					      val, (val & 0x1), 1, 100);
 
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
 }
@@ -88,11 +79,8 @@ static int lgm_pll_enable(struct clk_hw *hw)
 static void lgm_pll_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 0);
-	spin_unlock_irqrestore(&pll->lock, flags);
 }
 
 static const struct clk_ops lgm_pll_ops = {
@@ -123,7 +111,6 @@ lgm_clk_register_pll(struct lgm_clk_provider *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	pll->membase = ctx->membase;
-	pll->lock = ctx->lock;
 	pll->reg = list->reg;
 	pll->flags = list->flags;
 	pll->type = list->type;
diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index f5f30a18f4869..1f7e93de67bc0 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -25,14 +25,10 @@
 static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 					     const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return clk_hw_register_fixed_rate(NULL, list->name,
 					  list->parent_data[0].name,
@@ -42,33 +38,27 @@ static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 static u8 lgm_clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		val = mux->reg;
 	else
 		val = lgm_get_clk_val(mux->membase, mux->reg, mux->shift,
 				      mux->width);
-	spin_unlock_irqrestore(&mux->lock, flags);
 	return clk_mux_val_to_index(hw, NULL, mux->flags, val);
 }
 
 static int lgm_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
 	val = clk_mux_index_to_val(NULL, mux->flags, index);
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		mux->reg = val;
 	else
 		lgm_set_clk_val(mux->membase, mux->reg, mux->shift,
 				mux->width, val);
-	spin_unlock_irqrestore(&mux->lock, flags);
 
 	return 0;
 }
@@ -91,7 +81,7 @@ static struct clk_hw *
 lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 		     const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->mux_flags;
+	unsigned long cflags = list->mux_flags;
 	struct device *dev = ctx->dev;
 	u8 shift = list->mux_shift;
 	u8 width = list->mux_width;
@@ -112,7 +102,6 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	init.num_parents = list->num_parents;
 
 	mux->membase = ctx->membase;
-	mux->lock = ctx->lock;
 	mux->reg = reg;
 	mux->shift = shift;
 	mux->width = width;
@@ -124,11 +113,8 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&mux->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(mux->membase, reg, shift, width, list->mux_val);
-		spin_unlock_irqrestore(&mux->lock, flags);
-	}
 
 	return hw;
 }
@@ -137,13 +123,10 @@ static unsigned long
 lgm_clk_divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	unsigned int val;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	val = lgm_get_clk_val(divider->membase, divider->reg,
 			      divider->shift, divider->width);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return divider_recalc_rate(hw, parent_rate, val, divider->table,
 				   divider->flags, divider->width);
@@ -164,7 +147,6 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 			 unsigned long prate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	int value;
 
 	value = divider_get_val(rate, prate, divider->table,
@@ -172,10 +154,8 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (value < 0)
 		return value;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	lgm_set_clk_val(divider->membase, divider->reg,
 			divider->shift, divider->width, value);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return 0;
 }
@@ -183,12 +163,9 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&div->lock, flags);
 	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
 			div->width_gate, enable);
-	spin_unlock_irqrestore(&div->lock, flags);
 	return 0;
 }
 
@@ -214,7 +191,7 @@ static struct clk_hw *
 lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 			 const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->div_flags;
+	unsigned long cflags = list->div_flags;
 	struct device *dev = ctx->dev;
 	struct lgm_clk_divider *div;
 	struct clk_init_data init = {};
@@ -237,7 +214,6 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	init.num_parents = 1;
 
 	div->membase = ctx->membase;
-	div->lock = ctx->lock;
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
@@ -252,11 +228,8 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&div->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(div->membase, reg, shift, width, list->div_val);
-		spin_unlock_irqrestore(&div->lock, flags);
-	}
 
 	return hw;
 }
@@ -265,7 +238,6 @@ static struct clk_hw *
 lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 	struct clk_hw *hw;
 
 	hw = clk_hw_register_fixed_factor(ctx->dev, list->name,
@@ -274,12 +246,9 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 	if (IS_ERR(hw))
 		return ERR_CAST(hw);
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return hw;
 }
@@ -287,13 +256,10 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 static int lgm_clk_gate_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_EN(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return 0;
 }
@@ -301,25 +267,19 @@ static int lgm_clk_gate_enable(struct clk_hw *hw)
 static void lgm_clk_gate_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_DIS(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 }
 
 static int lgm_clk_gate_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
 	unsigned int reg, ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_STAT(gate->reg);
 	ret = lgm_get_clk_val(gate->membase, reg, gate->shift, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return ret;
 }
@@ -334,7 +294,7 @@ static struct clk_hw *
 lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		      const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->gate_flags;
+	unsigned long cflags = list->gate_flags;
 	const char *pname = list->parent_data[0].name;
 	struct device *dev = ctx->dev;
 	u8 shift = list->gate_shift;
@@ -355,7 +315,6 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 	init.num_parents = pname ? 1 : 0;
 
 	gate->membase = ctx->membase;
-	gate->lock = ctx->lock;
 	gate->reg = reg;
 	gate->shift = shift;
 	gate->flags = cflags;
@@ -367,9 +326,7 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		return ERR_PTR(ret);
 
 	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&gate->lock, flags);
 		lgm_set_clk_val(gate->membase, reg, shift, 1, list->gate_val);
-		spin_unlock_irqrestore(&gate->lock, flags);
 	}
 
 	return hw;
@@ -444,24 +401,18 @@ lgm_clk_ddiv_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 static int lgm_clk_ddiv_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 	return 0;
 }
 
 static void lgm_clk_ddiv_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 0);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 }
 
 static int
@@ -498,32 +449,25 @@ lgm_clk_ddiv_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)prate, rate);
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 		div = div * 2;
 	}
 
-	if (div <= 0) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (div <= 0)
 		return -EINVAL;
-	}
 
-	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2)) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2))
 		return -EINVAL;
-	}
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift0, ddiv->width0,
 			ddiv1 - 1);
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg,  ddiv->shift1, ddiv->width1,
 			ddiv2 - 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return 0;
 }
@@ -534,18 +478,15 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 	u64 rate64;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)*prate, rate);
 
 	/* if predivide bit is enabled, modify div by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = div * 2;
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	if (div <= 0)
 		return *prate;
@@ -559,12 +500,10 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 	do_div(rate64, ddiv2);
 
 	/* if predivide bit is enabled, modify rounded rate by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		rate64 = rate64 * 2;
 		rate64 = DIV_ROUND_CLOSEST_ULL(rate64, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return rate64;
 }
@@ -601,7 +540,6 @@ int lgm_clk_register_ddiv(struct lgm_clk_provider *ctx,
 		init.num_parents = 1;
 
 		ddiv->membase = ctx->membase;
-		ddiv->lock = ctx->lock;
 		ddiv->reg = list->reg;
 		ddiv->shift0 = list->shift0;
 		ddiv->width0 = list->width0;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index dbcb664687975..0aa0f35d63a0b 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -18,7 +18,6 @@ struct lgm_clk_mux {
 	u8 shift;
 	u8 width;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_divider {
@@ -31,7 +30,6 @@ struct lgm_clk_divider {
 	u8 width_gate;
 	unsigned long flags;
 	const struct clk_div_table *table;
-	spinlock_t lock;
 };
 
 struct lgm_clk_ddiv {
@@ -49,7 +47,6 @@ struct lgm_clk_ddiv {
 	unsigned int mult;
 	unsigned int div;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_gate {
@@ -58,7 +55,6 @@ struct lgm_clk_gate {
 	unsigned int reg;
 	u8 shift;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 enum lgm_clk_type {
@@ -82,7 +78,6 @@ struct lgm_clk_provider {
 	struct device_node *np;
 	struct device *dev;
 	struct clk_hw_onecell_data clk_data;
-	spinlock_t lock;
 };
 
 enum pll_type {
@@ -97,7 +92,6 @@ struct lgm_clk_pll {
 	unsigned int reg;
 	unsigned long flags;
 	enum pll_type type;
-	spinlock_t lock;
 };
 
 /**
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 4fa2bcaf71c89..e312af42e97ae 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -444,7 +444,6 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 
 	ctx->np = np;
 	ctx->dev = dev;
-	spin_lock_init(&ctx->lock);
 
 	ret = lgm_clk_register_plls(ctx, lgm_pll_clks,
 				    ARRAY_SIZE(lgm_pll_clks));
-- 
2.39.0



