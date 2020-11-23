Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62B62C084E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgKWMrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732736AbgKWMrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CAC20732;
        Mon, 23 Nov 2020 12:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135651;
        bh=ocowNOY67OESTHjQ6GUvDU++pqmKCXEJDlJ8wR1J/8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zix0FTOf0GUlaSjmegidiPk7OhYLtnAIy0iPcbBUgGR9Dazkk9yTP2BkxkJteTk5F
         oJ4fb3DU2qUtF8CTe/kb/zcdDAaQzGQeYRMOyo+ZgMVn3igCvaa0mzWGwzKcboVwVI
         wWnaUpsZtrUR1sA68zqfafP5gsfu/64FkDWKdIcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com,
        syzbot+f04854e1c5c9e913cc27@syzkaller.appspotmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 115/252] rcu: Dont invoke try_invoke_on_locked_down_task() with irqs disabled
Date:   Mon, 23 Nov 2020 13:21:05 +0100
Message-Id: <20201123121841.144605557@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit c583bcb8f5edd48c1798798e341f78afb9bf4f6f ]

The try_invoke_on_locked_down_task() function requires that
interrupts be enabled, but it is called with interrupts disabled from
rcu_print_task_stall(), resulting in an "IRQs not enabled as expected"
diagnostic.  This commit therefore updates rcu_print_task_stall()
to accumulate a list of the first few tasks while holding the current
leaf rcu_node structure's ->lock, then releases that lock and only then
uses try_invoke_on_locked_down_task() to attempt to obtain per-task
detailed information.  Of course, as soon as ->lock is released, the
task might exit, so the get_task_struct() function is used to prevent
the task structure from going away in the meantime.

Link: https://lore.kernel.org/lkml/000000000000903d5805ab908fc4@google.com/
Fixes: 5bef8da66a9c ("rcu: Add per-task state to RCU CPU stall warnings")
Reported-by: syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com
Reported-by: syzbot+f04854e1c5c9e913cc27@syzkaller.appspotmail.com
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_stall.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index b5d3b4794db48..e3c0f6fb5806d 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -249,13 +249,16 @@ static bool check_slow_task(struct task_struct *t, void *arg)
 
 /*
  * Scan the current list of tasks blocked within RCU read-side critical
- * sections, printing out the tid of each.
+ * sections, printing out the tid of each of the first few of them.
  */
-static int rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
+	int i = 0;
 	int ndetected = 0;
 	struct rcu_stall_chk_rdr rscr;
 	struct task_struct *t;
+	struct task_struct *ts[8];
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return 0;
@@ -264,6 +267,14 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 	t = list_entry(rnp->gp_tasks->prev,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
+		get_task_struct(t);
+		ts[i++] = t;
+		if (i >= ARRAY_SIZE(ts))
+			break;
+	}
+	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
+	for (i--; i; i--) {
+		t = ts[i];
 		if (!try_invoke_on_locked_down_task(t, check_slow_task, &rscr))
 			pr_cont(" P%d", t->pid);
 		else
@@ -273,6 +284,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 				".q"[rscr.rs.b.need_qs],
 				".e"[rscr.rs.b.exp_hint],
 				".l"[rscr.on_blkd_list]);
+		put_task_struct(t);
 		ndetected++;
 	}
 	pr_cont("\n");
@@ -293,8 +305,9 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
  * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
-static int rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 {
+	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	return 0;
 }
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
@@ -472,7 +485,6 @@ static void print_other_cpu_stall(unsigned long gp_seq, unsigned long gps)
 	pr_err("INFO: %s detected stalls on CPUs/tasks:\n", rcu_state.name);
 	rcu_for_each_leaf_node(rnp) {
 		raw_spin_lock_irqsave_rcu_node(rnp, flags);
-		ndetected += rcu_print_task_stall(rnp);
 		if (rnp->qsmask != 0) {
 			for_each_leaf_node_possible_cpu(rnp, cpu)
 				if (rnp->qsmask & leaf_node_cpu_bit(rnp, cpu)) {
@@ -480,7 +492,7 @@ static void print_other_cpu_stall(unsigned long gp_seq, unsigned long gps)
 					ndetected++;
 				}
 		}
-		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
+		ndetected += rcu_print_task_stall(rnp, flags); // Releases rnp->lock.
 	}
 
 	for_each_possible_cpu(cpu)
-- 
2.27.0



