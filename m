Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D201B3DB8
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgDVKRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbgDVKRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2512075A;
        Wed, 22 Apr 2020 10:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550665;
        bh=75thLSJ4zjswmdRdpBYB2fBlkoCC/ZCTS41RhNUtlg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0mp8lyukHPymKcGlEK2aySuo/tFsaIyOwuZ10UBGKzhaMfbJ/fnVywN5n1x/KzNi
         9RH1wO4tYj/LePtM3SmRLfQEa6DKhHPpLLbTRXYybJ/8WcAe3NvUPUZssbi1BemZz/
         DaW0WxCNm5zTYOD49zDRfghY1eqLdCNtsvHR6qc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/118] clk: Dont cache errors from clk_ops::get_phase()
Date:   Wed, 22 Apr 2020 11:56:37 +0200
Message-Id: <20200422095037.828695876@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 62d0fc486d3a2..80b029713722b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2642,12 +2642,14 @@ static int clk_core_get_phase(struct clk_core *core)
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
@@ -2661,10 +2663,16 @@ static int clk_core_get_phase(struct clk_core *core)
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
 
@@ -2878,13 +2886,21 @@ static struct hlist_head *orphan_list[] = {
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
@@ -2921,6 +2937,7 @@ DEFINE_SHOW_ATTRIBUTE(clk_summary);
 
 static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 {
+	int phase;
 	unsigned long min_rate, max_rate;
 
 	clk_core_get_boundaries(c, &min_rate, &max_rate);
@@ -2934,7 +2951,9 @@ static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
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
@@ -3375,14 +3394,11 @@ static int __clk_core_init(struct clk_core *core)
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



