Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3101A9D05
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897474AbgDOLmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897462AbgDOLmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7F9214AF;
        Wed, 15 Apr 2020 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950950;
        bh=DksuQ38nJfLb4sp4c+Nn8D1bB3/+1y9uU6bntieEtl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXm1+q7T8NAg6nj08yAXDMGsAgHAmUobE+pilmFrGXbsv47YYtt4/DkDH169K3SHF
         e9pzowkHTmSzggsuO3t6yDUimMw6BGtADPi8To/NPbCQGp3FlKSwj2VwU4ZDFZ23bX
         xYUredhmSnOpk8ByJzj9k/aurfkNMwldlCUypLpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 003/106] clk: Don't cache errors from clk_ops::get_phase()
Date:   Wed, 15 Apr 2020 07:40:43 -0400
Message-Id: <20200415114226.13103-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit f21cf9c77ee82ef8adfeb2143adfacf21ec1d5cc ]

We don't check for errors from clk_ops::get_phase() before storing away
the result into the clk_core::phase member. This can lead to some fairly
confusing debugfs information if these ops do return an error. Let's
skip the store when this op fails to fix this. While we're here, move
the locking outside of clk_core_get_phase() to simplify callers from
the debugfs side.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20200205232802.29184-2-sboyd@kernel.org
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 48 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 66f056ac4c156..f266222fd6df5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2660,12 +2660,14 @@ static int clk_core_get_phase(struct clk_core *core)
 {
 	int ret;
 
-	clk_prepare_lock();
+	lockdep_assert_held(&prepare_lock);
+	if (!core->ops->get_phase)
+		return 0;
+
 	/* Always try to update cached phase if possible */
-	if (core->ops->get_phase)
-		core->phase = core->ops->get_phase(core->hw);
-	ret = core->phase;
-	clk_prepare_unlock();
+	ret = core->ops->get_phase(core->hw);
+	if (ret >= 0)
+		core->phase = ret;
 
 	return ret;
 }
@@ -2679,10 +2681,16 @@ static int clk_core_get_phase(struct clk_core *core)
  */
 int clk_get_phase(struct clk *clk)
 {
+	int ret;
+
 	if (!clk)
 		return 0;
 
-	return clk_core_get_phase(clk->core);
+	clk_prepare_lock();
+	ret = clk_core_get_phase(clk->core);
+	clk_prepare_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_get_phase);
 
@@ -2896,13 +2904,21 @@ static struct hlist_head *orphan_list[] = {
 static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {
-	seq_printf(s, "%*s%-*s %7d %8d %8d %11lu %10lu %5d %6d\n",
+	int phase;
+
+	seq_printf(s, "%*s%-*s %7d %8d %8d %11lu %10lu ",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
 		   c->enable_count, c->prepare_count, c->protect_count,
-		   clk_core_get_rate(c), clk_core_get_accuracy(c),
-		   clk_core_get_phase(c),
-		   clk_core_get_scaled_duty_cycle(c, 100000));
+		   clk_core_get_rate(c), clk_core_get_accuracy(c));
+
+	phase = clk_core_get_phase(c);
+	if (phase >= 0)
+		seq_printf(s, "%5d", phase);
+	else
+		seq_puts(s, "-----");
+
+	seq_printf(s, " %6d\n", clk_core_get_scaled_duty_cycle(c, 100000));
 }
 
 static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
@@ -2939,6 +2955,7 @@ DEFINE_SHOW_ATTRIBUTE(clk_summary);
 
 static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 {
+	int phase;
 	unsigned long min_rate, max_rate;
 
 	clk_core_get_boundaries(c, &min_rate, &max_rate);
@@ -2952,7 +2969,9 @@ static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 	seq_printf(s, "\"min_rate\": %lu,", min_rate);
 	seq_printf(s, "\"max_rate\": %lu,", max_rate);
 	seq_printf(s, "\"accuracy\": %lu,", clk_core_get_accuracy(c));
-	seq_printf(s, "\"phase\": %d,", clk_core_get_phase(c));
+	phase = clk_core_get_phase(c);
+	if (phase >= 0)
+		seq_printf(s, "\"phase\": %d,", phase);
 	seq_printf(s, "\"duty_cycle\": %u",
 		   clk_core_get_scaled_duty_cycle(c, 100000));
 }
@@ -3393,14 +3412,11 @@ static int __clk_core_init(struct clk_core *core)
 		core->accuracy = 0;
 
 	/*
-	 * Set clk's phase.
+	 * Set clk's phase by clk_core_get_phase() caching the phase.
 	 * Since a phase is by definition relative to its parent, just
 	 * query the current clock phase, or just assume it's in phase.
 	 */
-	if (core->ops->get_phase)
-		core->phase = core->ops->get_phase(core->hw);
-	else
-		core->phase = 0;
+	clk_core_get_phase(core);
 
 	/*
 	 * Set clk's duty cycle.
-- 
2.20.1

