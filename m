Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CC960A3C3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiJXMAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiJXL7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CF87AC2D;
        Mon, 24 Oct 2022 04:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1677E61252;
        Mon, 24 Oct 2022 11:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F42C433D6;
        Mon, 24 Oct 2022 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611529;
        bh=YU3dLBhpv5jU/r+f4gU/MZ21d1RTiVhkqAKzdEe6idg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVIfcYxCuyH/UKukWZzo4dyadvSa5lLxfzwDegwu3CSRj3cYgPd28BZNKCiup6fEv
         G7HT2xVL+dU4KV9CafPg40xTFLgEnHa1qKschrSOMypG1K6uLyKIu45rAnzIWrdWPj
         sSFwjs7MBr/Kwu77t1NBOeI3eh71kKgJZVZ/Oi/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lori Hikichi <lori.hikichi@broadcom.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 014/159] clk: iproc: Minor tidy up of iproc pll data structures
Date:   Mon, 24 Oct 2022 13:29:28 +0200
Message-Id: <20221024112949.878116041@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lori Hikichi <lhikichi@broadcom.com>

[ Upstream commit b33db49783763e1b2a63b12fbe0e91fb7147a987 ]

There were a few fields in the iproc pll data structures that were
holding information that was not true state information.
Using stack variables is sufficient and simplifies the structure.
There are not any functional changes in this commit.

Signed-off-by: Lori Hikichi <lori.hikichi@broadcom.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Stable-dep-of: 1b24a132eba7 ("clk: iproc: Do not rely on node name for correct PLL setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-iproc-pll.c | 83 ++++++++++++++-------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index e04634c46395..53006f4305f8 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -69,16 +69,6 @@ enum vco_freq_range {
 	VCO_MAX       = 4000000000U,
 };
 
-struct iproc_pll;
-
-struct iproc_clk {
-	struct clk_hw hw;
-	const char *name;
-	struct iproc_pll *pll;
-	unsigned long rate;
-	const struct iproc_clk_ctrl *ctrl;
-};
-
 struct iproc_pll {
 	void __iomem *status_base;
 	void __iomem *control_base;
@@ -88,9 +78,12 @@ struct iproc_pll {
 	const struct iproc_pll_ctrl *ctrl;
 	const struct iproc_pll_vco_param *vco_param;
 	unsigned int num_vco_entries;
+};
 
-	struct clk_hw_onecell_data *clk_data;
-	struct iproc_clk *clks;
+struct iproc_clk {
+	struct clk_hw hw;
+	struct iproc_pll *pll;
+	const struct iproc_clk_ctrl *ctrl;
 };
 
 #define to_iproc_clk(hw) container_of(hw, struct iproc_clk, hw)
@@ -263,6 +256,7 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 	u32 val;
 	enum kp_band kp_index;
 	unsigned long ref_freq;
+	const char *clk_name = clk_hw_get_name(&clk->hw);
 
 	/*
 	 * reference frequency = parent frequency / PDIV
@@ -285,19 +279,19 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 		kp_index = KP_BAND_HIGH_HIGH;
 	} else {
 		pr_err("%s: pll: %s has invalid rate: %lu\n", __func__,
-				clk->name, rate);
+				clk_name, rate);
 		return -EINVAL;
 	}
 
 	kp = get_kp(ref_freq, kp_index);
 	if (kp < 0) {
-		pr_err("%s: pll: %s has invalid kp\n", __func__, clk->name);
+		pr_err("%s: pll: %s has invalid kp\n", __func__, clk_name);
 		return kp;
 	}
 
 	ret = __pll_enable(pll);
 	if (ret) {
-		pr_err("%s: pll: %s fails to enable\n", __func__, clk->name);
+		pr_err("%s: pll: %s fails to enable\n", __func__, clk_name);
 		return ret;
 	}
 
@@ -354,7 +348,7 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 
 	ret = pll_wait_for_lock(pll);
 	if (ret < 0) {
-		pr_err("%s: pll: %s failed to lock\n", __func__, clk->name);
+		pr_err("%s: pll: %s failed to lock\n", __func__, clk_name);
 		return ret;
 	}
 
@@ -390,16 +384,15 @@ static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
 	u32 val;
 	u64 ndiv, ndiv_int, ndiv_frac;
 	unsigned int pdiv;
+	unsigned long rate;
 
 	if (parent_rate == 0)
 		return 0;
 
 	/* PLL needs to be locked */
 	val = readl(pll->status_base + ctrl->status.offset);
-	if ((val & (1 << ctrl->status.shift)) == 0) {
-		clk->rate = 0;
+	if ((val & (1 << ctrl->status.shift)) == 0)
 		return 0;
-	}
 
 	/*
 	 * PLL output frequency =
@@ -421,14 +414,14 @@ static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
 	val = readl(pll->control_base + ctrl->pdiv.offset);
 	pdiv = (val >> ctrl->pdiv.shift) & bit_mask(ctrl->pdiv.width);
 
-	clk->rate = (ndiv * parent_rate) >> 20;
+	rate = (ndiv * parent_rate) >> 20;
 
 	if (pdiv == 0)
-		clk->rate *= 2;
+		rate *= 2;
 	else
-		clk->rate /= pdiv;
+		rate /= pdiv;
 
-	return clk->rate;
+	return rate;
 }
 
 static long iproc_pll_round_rate(struct clk_hw *hw, unsigned long rate,
@@ -518,6 +511,7 @@ static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
 	struct iproc_pll *pll = clk->pll;
 	u32 val;
 	unsigned int mdiv;
+	unsigned long rate;
 
 	if (parent_rate == 0)
 		return 0;
@@ -528,11 +522,11 @@ static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
 		mdiv = 256;
 
 	if (ctrl->flags & IPROC_CLK_MCLK_DIV_BY_2)
-		clk->rate = parent_rate / (mdiv * 2);
+		rate = parent_rate / (mdiv * 2);
 	else
-		clk->rate = parent_rate / mdiv;
+		rate = parent_rate / mdiv;
 
-	return clk->rate;
+	return rate;
 }
 
 static long iproc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
@@ -583,10 +577,6 @@ static int iproc_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 		val |= div << ctrl->mdiv.shift;
 	}
 	iproc_pll_write(pll, pll->control_base, ctrl->mdiv.offset, val);
-	if (ctrl->flags & IPROC_CLK_MCLK_DIV_BY_2)
-		clk->rate = parent_rate / (div * 2);
-	else
-		clk->rate = parent_rate / div;
 
 	return 0;
 }
@@ -629,6 +619,8 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 	struct iproc_clk *iclk;
 	struct clk_init_data init;
 	const char *parent_name;
+	struct iproc_clk *iclk_array;
+	struct clk_hw_onecell_data *clk_data;
 
 	if (WARN_ON(!pll_ctrl) || WARN_ON(!clk_ctrl))
 		return;
@@ -637,14 +629,14 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 	if (WARN_ON(!pll))
 		return;
 
-	pll->clk_data = kzalloc(sizeof(*pll->clk_data->hws) * num_clks +
-				sizeof(*pll->clk_data), GFP_KERNEL);
-	if (WARN_ON(!pll->clk_data))
+	clk_data = kzalloc(sizeof(*clk_data->hws) * num_clks +
+				sizeof(*clk_data), GFP_KERNEL);
+	if (WARN_ON(!clk_data))
 		goto err_clk_data;
-	pll->clk_data->num = num_clks;
+	clk_data->num = num_clks;
 
-	pll->clks = kcalloc(num_clks, sizeof(*pll->clks), GFP_KERNEL);
-	if (WARN_ON(!pll->clks))
+	iclk_array = kcalloc(num_clks, sizeof(struct iproc_clk), GFP_KERNEL);
+	if (WARN_ON(!iclk_array))
 		goto err_clks;
 
 	pll->control_base = of_iomap(node, 0);
@@ -674,9 +666,8 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 	/* initialize and register the PLL itself */
 	pll->ctrl = pll_ctrl;
 
-	iclk = &pll->clks[0];
+	iclk = &iclk_array[0];
 	iclk->pll = pll;
-	iclk->name = node->name;
 
 	init.name = node->name;
 	init.ops = &iproc_pll_ops;
@@ -697,7 +688,7 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 	if (WARN_ON(ret))
 		goto err_pll_register;
 
-	pll->clk_data->hws[0] = &iclk->hw;
+	clk_data->hws[0] = &iclk->hw;
 
 	/* now initialize and register all leaf clocks */
 	for (i = 1; i < num_clks; i++) {
@@ -711,8 +702,7 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 		if (WARN_ON(ret))
 			goto err_clk_register;
 
-		iclk = &pll->clks[i];
-		iclk->name = clk_name;
+		iclk = &iclk_array[i];
 		iclk->pll = pll;
 		iclk->ctrl = &clk_ctrl[i];
 
@@ -727,11 +717,10 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 		if (WARN_ON(ret))
 			goto err_clk_register;
 
-		pll->clk_data->hws[i] = &iclk->hw;
+		clk_data->hws[i] = &iclk->hw;
 	}
 
-	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get,
-				     pll->clk_data);
+	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (WARN_ON(ret))
 		goto err_clk_register;
 
@@ -739,7 +728,7 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 
 err_clk_register:
 	while (--i >= 0)
-		clk_hw_unregister(pll->clk_data->hws[i]);
+		clk_hw_unregister(clk_data->hws[i]);
 
 err_pll_register:
 	if (pll->status_base != pll->control_base)
@@ -756,10 +745,10 @@ void __init iproc_pll_clk_setup(struct device_node *node,
 	iounmap(pll->control_base);
 
 err_pll_iomap:
-	kfree(pll->clks);
+	kfree(iclk_array);
 
 err_clks:
-	kfree(pll->clk_data);
+	kfree(clk_data);
 
 err_clk_data:
 	kfree(pll);
-- 
2.35.1



