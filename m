Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270BE6B4594
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjCJOfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjCJOe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9186AED0EE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 764E8B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE60C433EF;
        Fri, 10 Mar 2023 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458894;
        bh=yGPjqMG810Z6jKaOYLpDFbzat1RHhVbl/gGt7L+NLOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPFgaO+uJHMpKT9QEWvelcGl6UibtqZJ53fB3FDS2I0sK5JNSLwHtQvDvTX4I47OM
         13U926MRv+bv3B10Lvd+axfYQyKBa7YKYWP5Kze55KMP/7doPf0/B6HdAxV4GmnljV
         l1JJKpg6fBihoJey8Nb4bI9MP0l/Yt5bszjoult8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/357] clk: renesas: cpg-mssr: Use enum clk_reg_layout instead of a boolean flag
Date:   Fri, 10 Mar 2023 14:37:21 +0100
Message-Id: <20230310133741.421217454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit ffbf9cf3f9460e320c3f1a90a51145da86c16781 ]

Geert suggested defining multiple register layout variants using an enum
[1] to support further devices like R-Car V3U.  So, use enum
clk_reg_layout instead of a boolean .stbyctrl flag.  No behavioral
change.

[1] https://lore.kernel.org/linux-renesas-soc/CAMuHMdVAgN69p9FFnQdO4iHk2CHkeNaVui2Q-FOY6_BFVjQ-Nw@mail.gmail.com/

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1599810232-29035-2-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 1c052043c79a ("clk: renesas: cpg-mssr: Remove superfluous check in resume code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r7s9210-cpg-mssr.c |  2 +-
 drivers/clk/renesas/renesas-cpg-mssr.c | 27 +++++++++++++-------------
 drivers/clk/renesas/renesas-cpg-mssr.h | 12 +++++++-----
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/renesas/r7s9210-cpg-mssr.c b/drivers/clk/renesas/r7s9210-cpg-mssr.c
index cf65d4e0e1166..2772eb0b8ba76 100644
--- a/drivers/clk/renesas/r7s9210-cpg-mssr.c
+++ b/drivers/clk/renesas/r7s9210-cpg-mssr.c
@@ -213,7 +213,7 @@ const struct cpg_mssr_info r7s9210_cpg_mssr_info __initconst = {
 	.cpg_clk_register = rza2_cpg_clk_register,
 
 	/* RZ/A2 has Standby Control Registers */
-	.stbyctrl = true,
+	.reg_layout = CLK_REG_LAYOUT_RZ_A,
 };
 
 static void __init r7s9210_cpg_mssr_early_init(struct device_node *np)
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 9ffd1bf80b6a3..fd9ca86cc60f6 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -111,12 +111,12 @@ static const u16 srcr[] = {
  * @rcdev: Optional reset controller entity
  * @dev: CPG/MSSR device
  * @base: CPG/MSSR register block base address
+ * @reg_layout: CPG/MSSR register layout
  * @rmw_lock: protects RMW register accesses
  * @np: Device node in DT for this CPG/MSSR module
  * @num_core_clks: Number of Core Clocks in clks[]
  * @num_mod_clks: Number of Module Clocks in clks[]
  * @last_dt_core_clk: ID of the last Core Clock exported to DT
- * @stbyctrl: This device has Standby Control Registers
  * @notifiers: Notifier chain to save/restore clock state for system resume
  * @smstpcr_saved[].mask: Mask of SMSTPCR[] bits under our control
  * @smstpcr_saved[].val: Saved values of SMSTPCR[]
@@ -128,13 +128,13 @@ struct cpg_mssr_priv {
 #endif
 	struct device *dev;
 	void __iomem *base;
+	enum clk_reg_layout reg_layout;
 	spinlock_t rmw_lock;
 	struct device_node *np;
 
 	unsigned int num_core_clks;
 	unsigned int num_mod_clks;
 	unsigned int last_dt_core_clk;
-	bool stbyctrl;
 
 	struct raw_notifier_head notifiers;
 	struct {
@@ -177,7 +177,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 		enable ? "ON" : "OFF");
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 
-	if (priv->stbyctrl) {
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 		value = readb(priv->base + STBCR(reg));
 		if (enable)
 			value &= ~bitmask;
@@ -199,7 +199,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 
 	spin_unlock_irqrestore(&priv->rmw_lock, flags);
 
-	if (!enable || priv->stbyctrl)
+	if (!enable || priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		return 0;
 
 	for (i = 1000; i > 0; --i) {
@@ -233,7 +233,7 @@ static int cpg_mstp_clock_is_enabled(struct clk_hw *hw)
 	struct cpg_mssr_priv *priv = clock->priv;
 	u32 value;
 
-	if (priv->stbyctrl)
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		value = readb(priv->base + STBCR(clock->index / 32));
 	else
 		value = readl(priv->base + MSTPSR(clock->index / 32));
@@ -272,7 +272,7 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 
 	case CPG_MOD:
 		type = "module";
-		if (priv->stbyctrl) {
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 			idx = MOD_CLK_PACK_10(clkidx);
 			range_check = 7 - (clkidx % 10);
 		} else {
@@ -800,7 +800,8 @@ static int cpg_mssr_suspend_noirq(struct device *dev)
 	/* Save module registers with bits under our control */
 	for (reg = 0; reg < ARRAY_SIZE(priv->smstpcr_saved); reg++) {
 		if (priv->smstpcr_saved[reg].mask)
-			priv->smstpcr_saved[reg].val = priv->stbyctrl ?
+			priv->smstpcr_saved[reg].val =
+				priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
 				readb(priv->base + STBCR(reg)) :
 				readl(priv->base + SMSTPCR(reg));
 	}
@@ -830,7 +831,7 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		if (!mask)
 			continue;
 
-		if (priv->stbyctrl)
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 			oldval = readb(priv->base + STBCR(reg));
 		else
 			oldval = readl(priv->base + SMSTPCR(reg));
@@ -839,7 +840,7 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		if (newval == oldval)
 			continue;
 
-		if (priv->stbyctrl) {
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 			writeb(newval, priv->base + STBCR(reg));
 			/* dummy read to ensure write has completed */
 			readb(priv->base + STBCR(reg));
@@ -862,8 +863,8 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 
 		if (!i)
 			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
-				 priv->stbyctrl ? "STB" : "SMSTP", reg,
-				 oldval & mask);
+				 priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
+				 "STB" : "SMSTP", reg, oldval & mask);
 	}
 
 	return 0;
@@ -911,7 +912,7 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
 	RAW_INIT_NOTIFIER_HEAD(&priv->notifiers);
-	priv->stbyctrl = info->stbyctrl;
+	priv->reg_layout = info->reg_layout;
 
 	for (i = 0; i < nclks; i++)
 		priv->clks[i] = ERR_PTR(-ENOENT);
@@ -991,7 +992,7 @@ static int __init cpg_mssr_probe(struct platform_device *pdev)
 		return error;
 
 	/* Reset Controller not supported for Standby Control SoCs */
-	if (info->stbyctrl)
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		return 0;
 
 	error = cpg_mssr_reset_controller_register(priv);
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.h b/drivers/clk/renesas/renesas-cpg-mssr.h
index 4ddcdf3bfb95f..f05521b5fa6e2 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.h
+++ b/drivers/clk/renesas/renesas-cpg-mssr.h
@@ -85,6 +85,11 @@ struct mssr_mod_clk {
 
 struct device_node;
 
+enum clk_reg_layout {
+	CLK_REG_LAYOUT_RCAR_GEN2_AND_GEN3 = 0,
+	CLK_REG_LAYOUT_RZ_A,
+};
+
     /**
      * SoC-specific CPG/MSSR Description
      *
@@ -105,6 +110,7 @@ struct device_node;
      * @crit_mod_clks: Array with Module Clock IDs of critical clocks that
      *                 should not be disabled without a knowledgeable driver
      * @num_crit_mod_clks: Number of entries in crit_mod_clks[]
+     * @reg_layout: CPG/MSSR register layout from enum clk_reg_layout
      *
      * @core_pm_clks: Array with IDs of Core Clocks that are suitable for Power
      *                Management, in addition to Module Clocks
@@ -112,10 +118,6 @@ struct device_node;
      *
      * @init: Optional callback to perform SoC-specific initialization
      * @cpg_clk_register: Optional callback to handle special Core Clock types
-     *
-     * @stbyctrl: This device has Standby Control Registers which are 8-bits
-     *            wide, no status registers (MSTPSR) and have different address
-     *            offsets.
      */
 
 struct cpg_mssr_info {
@@ -130,7 +132,7 @@ struct cpg_mssr_info {
 	unsigned int num_core_clks;
 	unsigned int last_dt_core_clk;
 	unsigned int num_total_core_clks;
-	bool stbyctrl;
+	enum clk_reg_layout reg_layout;
 
 	/* Module Clocks */
 	const struct mssr_mod_clk *mod_clks;
-- 
2.39.2



