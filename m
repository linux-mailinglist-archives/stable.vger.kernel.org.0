Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB2412198
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358458AbhITSGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357657AbhITSEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECC660E9C;
        Mon, 20 Sep 2021 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158234;
        bh=LuXBu0F0vEH74EqU7V777LUfD8EjvlLmaU1imLG8JrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukti8WtHlXRE5g9SAKXcnUltH/bOGYSL7VTc7J+Ig0EY6Y1YqjBZPFRXjr1UNQaLQ
         nprYWGj2usJZGyhmf9l+Emfsbm0ubU5PHNUSxnLKV8uQpIZJSORjsD8WoRt25gFoxI
         5oAQRK3NjGvxS0/P1uOnA4jcve8/H9QXleOvMHIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/260] clk: at91: clk-generated: pass the id of changeable parent at registration
Date:   Mon, 20 Sep 2021 18:41:21 +0200
Message-Id: <20210920163933.274027710@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 64c9247b9e87e96e41cea545eb64727cee10c55c ]

Pass the ID of changeable parent at registration. This will allow
the scalability of this clock driver with regards to the changeable
parent ID for versions of this IP where changeable parent is not the
last one in the parents list (e.g. SAMA7G5). With this the clock flags
are set to zero in case we have no changeable parent. Also in
clk_generated_best_diff() the *best_diff variable is check against
tmp_diff variable using ">=" operator instead of ">" so that in case
the requested frequency could be obtained using fix parents + gck
dividers but the clock also supports changeable parent to be able
to force the usage of the changeable parent.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1595403506-8209-11-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-generated.c | 26 ++++++++++++++------------
 drivers/clk/at91/dt-compat.c     |  8 +++++---
 drivers/clk/at91/pmc.h           |  4 ++--
 drivers/clk/at91/sam9x60.c       |  3 +--
 drivers/clk/at91/sama5d2.c       | 31 +++++++++++++++----------------
 5 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index 44a46dcc0518..273d0447d727 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -18,8 +18,6 @@
 
 #define GENERATED_MAX_DIV	255
 
-#define GCK_INDEX_DT_AUDIO_PLL	5
-
 struct clk_generated {
 	struct clk_hw hw;
 	struct regmap *regmap;
@@ -29,7 +27,7 @@ struct clk_generated {
 	u32 gckdiv;
 	const struct clk_pcr_layout *layout;
 	u8 parent_id;
-	bool audio_pll_allowed;
+	int chg_pid;
 };
 
 #define to_clk_generated(hw) \
@@ -109,7 +107,7 @@ static void clk_generated_best_diff(struct clk_rate_request *req,
 		tmp_rate = parent_rate / div;
 	tmp_diff = abs(req->rate - tmp_rate);
 
-	if (*best_diff < 0 || *best_diff > tmp_diff) {
+	if (*best_diff < 0 || *best_diff >= tmp_diff) {
 		*best_rate = tmp_rate;
 		*best_diff = tmp_diff;
 		req->best_parent_rate = parent_rate;
@@ -129,7 +127,10 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 	int i;
 	u32 div;
 
-	for (i = 0; i < clk_hw_get_num_parents(hw) - 1; i++) {
+	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
+		if (gck->chg_pid == i)
+			continue;
+
 		parent = clk_hw_get_parent_by_index(hw, i);
 		if (!parent)
 			continue;
@@ -161,10 +162,10 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 	 * that the only clks able to modify gck rate are those of audio IPs.
 	 */
 
-	if (!gck->audio_pll_allowed)
+	if (gck->chg_pid < 0)
 		goto end;
 
-	parent = clk_hw_get_parent_by_index(hw, GCK_INDEX_DT_AUDIO_PLL);
+	parent = clk_hw_get_parent_by_index(hw, gck->chg_pid);
 	if (!parent)
 		goto end;
 
@@ -271,8 +272,8 @@ struct clk_hw * __init
 at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 			    const struct clk_pcr_layout *layout,
 			    const char *name, const char **parent_names,
-			    u8 num_parents, u8 id, bool pll_audio,
-			    const struct clk_range *range)
+			    u8 num_parents, u8 id,
+			    const struct clk_range *range, int chg_pid)
 {
 	struct clk_generated *gck;
 	struct clk_init_data init;
@@ -287,15 +288,16 @@ at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 	init.ops = &generated_ops;
 	init.parent_names = parent_names;
 	init.num_parents = num_parents;
-	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE |
-		CLK_SET_RATE_PARENT;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+	if (chg_pid >= 0)
+		init.flags |= CLK_SET_RATE_PARENT;
 
 	gck->id = id;
 	gck->hw.init = &init;
 	gck->regmap = regmap;
 	gck->lock = lock;
 	gck->range = *range;
-	gck->audio_pll_allowed = pll_audio;
+	gck->chg_pid = chg_pid;
 	gck->layout = layout;
 
 	clk_generated_startup(gck);
diff --git a/drivers/clk/at91/dt-compat.c b/drivers/clk/at91/dt-compat.c
index aa1754eac59f..8a652c44c25a 100644
--- a/drivers/clk/at91/dt-compat.c
+++ b/drivers/clk/at91/dt-compat.c
@@ -22,6 +22,8 @@
 
 #define SYSTEM_MAX_ID		31
 
+#define GCK_INDEX_DT_AUDIO_PLL	5
+
 #ifdef CONFIG_HAVE_AT91_AUDIO_PLL
 static void __init of_sama5d2_clk_audio_pll_frac_setup(struct device_node *np)
 {
@@ -135,7 +137,7 @@ static void __init of_sama5d2_clk_generated_setup(struct device_node *np)
 		return;
 
 	for_each_child_of_node(np, gcknp) {
-		bool pll_audio = false;
+		int chg_pid = INT_MIN;
 
 		if (of_property_read_u32(gcknp, "reg", &id))
 			continue;
@@ -152,12 +154,12 @@ static void __init of_sama5d2_clk_generated_setup(struct device_node *np)
 		if (of_device_is_compatible(np, "atmel,sama5d2-clk-generated") &&
 		    (id == GCK_ID_I2S0 || id == GCK_ID_I2S1 ||
 		     id == GCK_ID_CLASSD))
-			pll_audio = true;
+			chg_pid = GCK_INDEX_DT_AUDIO_PLL;
 
 		hw = at91_clk_register_generated(regmap, &pmc_pcr_lock,
 						 &dt_pcr_layout, name,
 						 parent_names, num_parents,
-						 id, pll_audio, &range);
+						 id, &range, chg_pid);
 		if (IS_ERR(hw))
 			continue;
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 9b8db9cdcda5..8a88ad236074 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -118,8 +118,8 @@ struct clk_hw * __init
 at91_clk_register_generated(struct regmap *regmap, spinlock_t *lock,
 			    const struct clk_pcr_layout *layout,
 			    const char *name, const char **parent_names,
-			    u8 num_parents, u8 id, bool pll_audio,
-			    const struct clk_range *range);
+			    u8 num_parents, u8 id,
+			    const struct clk_range *range, int chg_pid);
 
 struct clk_hw * __init
 at91_clk_register_h32mx(struct regmap *regmap, const char *name,
diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index bee1120e7041..39923899478f 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -282,8 +282,7 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
 						 sam9x60_gck[i].n,
 						 parent_names, 6,
 						 sam9x60_gck[i].id,
-						 false,
-						 &sam9x60_gck[i].r);
+						 &sam9x60_gck[i].r, INT_MIN);
 		if (IS_ERR(hw))
 			goto err_free;
 
diff --git a/drivers/clk/at91/sama5d2.c b/drivers/clk/at91/sama5d2.c
index ff7e3f727082..d3c4bceb032d 100644
--- a/drivers/clk/at91/sama5d2.c
+++ b/drivers/clk/at91/sama5d2.c
@@ -115,21 +115,20 @@ static const struct {
 	char *n;
 	u8 id;
 	struct clk_range r;
-	bool pll;
+	int chg_pid;
 } sama5d2_gck[] = {
-	{ .n = "sdmmc0_gclk", .id = 31, },
-	{ .n = "sdmmc1_gclk", .id = 32, },
-	{ .n = "tcb0_gclk",   .id = 35, .r = { .min = 0, .max = 83000000 }, },
-	{ .n = "tcb1_gclk",   .id = 36, .r = { .min = 0, .max = 83000000 }, },
-	{ .n = "pwm_gclk",    .id = 38, .r = { .min = 0, .max = 83000000 }, },
-	{ .n = "isc_gclk",    .id = 46, },
-	{ .n = "pdmic_gclk",  .id = 48, },
-	{ .n = "i2s0_gclk",   .id = 54, .pll = true },
-	{ .n = "i2s1_gclk",   .id = 55, .pll = true },
-	{ .n = "can0_gclk",   .id = 56, .r = { .min = 0, .max = 80000000 }, },
-	{ .n = "can1_gclk",   .id = 57, .r = { .min = 0, .max = 80000000 }, },
-	{ .n = "classd_gclk", .id = 59, .r = { .min = 0, .max = 100000000 },
-	  .pll = true },
+	{ .n = "sdmmc0_gclk", .id = 31, .chg_pid = INT_MIN, },
+	{ .n = "sdmmc1_gclk", .id = 32, .chg_pid = INT_MIN, },
+	{ .n = "tcb0_gclk",   .id = 35, .chg_pid = INT_MIN, .r = { .min = 0, .max = 83000000 }, },
+	{ .n = "tcb1_gclk",   .id = 36, .chg_pid = INT_MIN, .r = { .min = 0, .max = 83000000 }, },
+	{ .n = "pwm_gclk",    .id = 38, .chg_pid = INT_MIN, .r = { .min = 0, .max = 83000000 }, },
+	{ .n = "isc_gclk",    .id = 46, .chg_pid = INT_MIN, },
+	{ .n = "pdmic_gclk",  .id = 48, .chg_pid = INT_MIN, },
+	{ .n = "i2s0_gclk",   .id = 54, .chg_pid = 5, },
+	{ .n = "i2s1_gclk",   .id = 55, .chg_pid = 5, },
+	{ .n = "can0_gclk",   .id = 56, .chg_pid = INT_MIN, .r = { .min = 0, .max = 80000000 }, },
+	{ .n = "can1_gclk",   .id = 57, .chg_pid = INT_MIN, .r = { .min = 0, .max = 80000000 }, },
+	{ .n = "classd_gclk", .id = 59, .chg_pid = 5, .r = { .min = 0, .max = 100000000 }, },
 };
 
 static const struct clk_programmable_layout sama5d2_programmable_layout = {
@@ -317,8 +316,8 @@ static void __init sama5d2_pmc_setup(struct device_node *np)
 						 sama5d2_gck[i].n,
 						 parent_names, 6,
 						 sama5d2_gck[i].id,
-						 sama5d2_gck[i].pll,
-						 &sama5d2_gck[i].r);
+						 &sama5d2_gck[i].r,
+						 sama5d2_gck[i].chg_pid);
 		if (IS_ERR(hw))
 			goto err_free;
 
-- 
2.30.2



