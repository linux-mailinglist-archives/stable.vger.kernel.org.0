Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24313802A
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgAKK0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgAKK0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:26:37 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C499B20842;
        Sat, 11 Jan 2020 10:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738396;
        bh=2fWph/ItbPzO4DF1XjbTfqheJe3a3uYNXv0N8SZl55w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wzyHeABeC9JJpW4mcvtYFkjazY2MLc9MNgJDaIJM/y7MT++er88WRqqTeTdY+oLH
         7IeALHUgJzfHrW4fiyXY2q4cOJTgbeUFfVFqD/yw5SP1NIiX8JMH7+XhafHILCIscp
         0z0GITKan75QPqPMcPg4TC23eb+rpvsaqIRXrKoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Hu <jian.hu@amlogic.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/165] clk: walk orphan list on clock provider registration
Date:   Sat, 11 Jan 2020 10:49:47 +0100
Message-Id: <20200111094926.831944277@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 66d9506440bb05289eb4867059e7b8c6ed209717 ]

So far, we walked the orphan list every time a new clock was registered
in CCF. This was fine since the clocks were only referenced by name.

Now that the clock can be referenced through DT, it is not enough:
* Controller A register first a reference clocks from controller B
  through DT.
* Controller B register all its clocks then register the provider.

Each time controller B registers a new clock, the orphan list is walked
but it can't match since the provider is registered yet. When the
provider is finally registered, the orphan list is not walked unless
another clock is registered afterward.

This can lead to situation where some clocks remain orphaned even if
the parent is available.

Walking the orphan list on provider registration solves the problem.

Reported-by: Jian Hu <jian.hu@amlogic.com>
Fixes: fc0c209c147f ("clk: Allow parents to be specified without string names")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lkml.kernel.org/r/20191203080805.104628-1-jbrunet@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 62 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1c677d7f7f53..9c570bfc40d6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3231,6 +3231,41 @@ static inline void clk_debug_unregister(struct clk_core *core)
 }
 #endif
 
+static void clk_core_reparent_orphans_nolock(void)
+{
+	struct clk_core *orphan;
+	struct hlist_node *tmp2;
+
+	/*
+	 * walk the list of orphan clocks and reparent any that newly finds a
+	 * parent.
+	 */
+	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
+		struct clk_core *parent = __clk_init_parent(orphan);
+
+		/*
+		 * We need to use __clk_set_parent_before() and _after() to
+		 * to properly migrate any prepare/enable count of the orphan
+		 * clock. This is important for CLK_IS_CRITICAL clocks, which
+		 * are enabled during init but might not have a parent yet.
+		 */
+		if (parent) {
+			/* update the clk tree topology */
+			__clk_set_parent_before(orphan, parent);
+			__clk_set_parent_after(orphan, parent, NULL);
+			__clk_recalc_accuracies(orphan);
+			__clk_recalc_rates(orphan, 0);
+		}
+	}
+}
+
+static void clk_core_reparent_orphans(void)
+{
+	clk_prepare_lock();
+	clk_core_reparent_orphans_nolock();
+	clk_prepare_unlock();
+}
+
 /**
  * __clk_core_init - initialize the data structures in a struct clk_core
  * @core:	clk_core being initialized
@@ -3241,8 +3276,6 @@ static inline void clk_debug_unregister(struct clk_core *core)
 static int __clk_core_init(struct clk_core *core)
 {
 	int ret;
-	struct clk_core *orphan;
-	struct hlist_node *tmp2;
 	unsigned long rate;
 
 	if (!core)
@@ -3389,27 +3422,8 @@ static int __clk_core_init(struct clk_core *core)
 		clk_enable_unlock(flags);
 	}
 
-	/*
-	 * walk the list of orphan clocks and reparent any that newly finds a
-	 * parent.
-	 */
-	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
-		struct clk_core *parent = __clk_init_parent(orphan);
+	clk_core_reparent_orphans_nolock();
 
-		/*
-		 * We need to use __clk_set_parent_before() and _after() to
-		 * to properly migrate any prepare/enable count of the orphan
-		 * clock. This is important for CLK_IS_CRITICAL clocks, which
-		 * are enabled during init but might not have a parent yet.
-		 */
-		if (parent) {
-			/* update the clk tree topology */
-			__clk_set_parent_before(orphan, parent);
-			__clk_set_parent_after(orphan, parent, NULL);
-			__clk_recalc_accuracies(orphan);
-			__clk_recalc_rates(orphan, 0);
-		}
-	}
 
 	kref_init(&core->ref);
 out:
@@ -4255,6 +4269,8 @@ int of_clk_add_provider(struct device_node *np,
 	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clock from %pOF\n", np);
 
+	clk_core_reparent_orphans();
+
 	ret = of_clk_set_defaults(np, true);
 	if (ret < 0)
 		of_clk_del_provider(np);
@@ -4290,6 +4306,8 @@ int of_clk_add_hw_provider(struct device_node *np,
 	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clk_hw provider from %pOF\n", np);
 
+	clk_core_reparent_orphans();
+
 	ret = of_clk_set_defaults(np, true);
 	if (ret < 0)
 		of_clk_del_provider(np);
-- 
2.20.1



