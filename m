Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3264D408E4C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhIMNcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242335AbhIMNal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131BB610CE;
        Mon, 13 Sep 2021 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539489;
        bh=k0eFH03eg6ySoPnVC+Xbdhj+RnyB2dgx4sfO4LDKI2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hELuGd8vLB5ku0+rWOKD8IIRyqaM3oCXEQF9nkTFIHO9rX8UgXTpJZt3BMZzl2vpN
         doZTbrOdblosl4IQ1Fe3CYvN2Dgzxe/xGisDCB7+SbVwl3nnUnFRC4iGtNOJPzimXk
         N4D5J5Szo/nXhY34xhLE33X0bPHkBHVBKY+WIvq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/236] rcu: Add lockdep_assert_irqs_disabled() to rcu_sched_clock_irq() and callees
Date:   Mon, 13 Sep 2021 15:12:30 +0200
Message-Id: <20210913131101.883625265@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit a649d25dcc671a33b9cc3176411920fdc5fbd98e ]

This commit adds a number of lockdep_assert_irqs_disabled() calls
to rcu_sched_clock_irq() and a number of the functions that it calls.
The point of this is to help track down a situation where lockdep appears
to be insisting that interrupts are enabled within these functions, which
should only ever be invoked from the scheduling-clock interrupt handler.

Link: https://lore.kernel.org/lkml/20201111133813.GA81547@elver.google.com/
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c        | 4 ++++
 kernel/rcu/tree_plugin.h | 1 +
 kernel/rcu/tree_stall.h  | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8c3ba0185082..8c81c05c4236 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2561,6 +2561,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 void rcu_sched_clock_irq(int user)
 {
 	trace_rcu_utilization(TPS("Start scheduler-tick"));
+	lockdep_assert_irqs_disabled();
 	raw_cpu_inc(rcu_data.ticks_this_gp);
 	/* The load-acquire pairs with the store-release setting to true. */
 	if (smp_load_acquire(this_cpu_ptr(&rcu_data.rcu_urgent_qs))) {
@@ -2574,6 +2575,7 @@ void rcu_sched_clock_irq(int user)
 	rcu_flavor_sched_clock_irq(user);
 	if (rcu_pending(user))
 		invoke_rcu_core();
+	lockdep_assert_irqs_disabled();
 
 	trace_rcu_utilization(TPS("End scheduler-tick"));
 }
@@ -3730,6 +3732,8 @@ static int rcu_pending(int user)
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 	struct rcu_node *rnp = rdp->mynode;
 
+	lockdep_assert_irqs_disabled();
+
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rdp);
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7d4f78bf4057..574aeaac9272 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -682,6 +682,7 @@ static void rcu_flavor_sched_clock_irq(int user)
 {
 	struct task_struct *t = current;
 
+	lockdep_assert_irqs_disabled();
 	if (user || rcu_is_cpu_rrupt_from_idle()) {
 		rcu_note_voluntary_context_switch(current);
 	}
diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index cdfaa44ffd70..3fc21617546d 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -262,6 +262,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 	struct task_struct *t;
 	struct task_struct *ts[8];
 
+	lockdep_assert_irqs_disabled();
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return 0;
 	pr_err("\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
@@ -286,6 +287,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 				".q"[rscr.rs.b.need_qs],
 				".e"[rscr.rs.b.exp_hint],
 				".l"[rscr.on_blkd_list]);
+		lockdep_assert_irqs_disabled();
 		put_task_struct(t);
 		ndetected++;
 	}
@@ -474,6 +476,8 @@ static void print_other_cpu_stall(unsigned long gp_seq, unsigned long gps)
 	struct rcu_node *rnp;
 	long totqlen = 0;
 
+	lockdep_assert_irqs_disabled();
+
 	/* Kick and suppress, if so configured. */
 	rcu_stall_kick_kthreads();
 	if (rcu_stall_is_suppressed())
@@ -495,6 +499,7 @@ static void print_other_cpu_stall(unsigned long gp_seq, unsigned long gps)
 				}
 		}
 		ndetected += rcu_print_task_stall(rnp, flags); // Releases rnp->lock.
+		lockdep_assert_irqs_disabled();
 	}
 
 	for_each_possible_cpu(cpu)
@@ -540,6 +545,8 @@ static void print_cpu_stall(unsigned long gps)
 	struct rcu_node *rnp = rcu_get_root();
 	long totqlen = 0;
 
+	lockdep_assert_irqs_disabled();
+
 	/* Kick and suppress, if so configured. */
 	rcu_stall_kick_kthreads();
 	if (rcu_stall_is_suppressed())
@@ -594,6 +601,7 @@ static void check_cpu_stall(struct rcu_data *rdp)
 	unsigned long js;
 	struct rcu_node *rnp;
 
+	lockdep_assert_irqs_disabled();
 	if ((rcu_stall_is_suppressed() && !READ_ONCE(rcu_kick_kthreads)) ||
 	    !rcu_gp_in_progress())
 		return;
-- 
2.30.2



