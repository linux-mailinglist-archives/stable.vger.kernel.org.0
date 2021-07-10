Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6FD3C2DAF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhGJCYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhGJCYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E934B613D1;
        Sat, 10 Jul 2021 02:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883725;
        bh=68VD4ixq7rgT+0ZzTw8Xbq7rDTl4b1R1dNyXoqd/3MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArOTTUpCxxDT0dLq4Jbqw5oj6PPCs/4Z80YMnZhIIFlBgO3P4iQ0kLhZ3N/ac9KH4
         zDvABiE0zEXG5mgEqhVb13bauxiMvKO2MX2HX9T4oxTGsWdOWQpwykQP37wRelglDq
         fYZsi+4nTrr1aJGsvXnZin2/eYw9xxot5uP1jXGTesEWiZlEJ+7N57r2q1wBOwAH3C
         ap8FUG4QMOimbnoi9cDx79yUCQKh8bLzCTAYal/0dFeel5+8mccnkSOhxvR97KQXH3
         IxN2Dmb5QvoDbxBpU9GrYTuIy+SHiqstXDUJRQf2jP5+mA+MlrTYbW0U3pdAoo1f0V
         NjoY7wfMv7r8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 006/104] srcu: Fix broken node geometry after early ssp init
Date:   Fri,  9 Jul 2021 22:20:18 -0400
Message-Id: <20210710022156.3168825-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit b5befe842e6612cf894cf4a199924ee872d8b7d8 ]

An srcu_struct structure that is initialized before rcu_init_geometry()
will have its srcu_node hierarchy based on CONFIG_NR_CPUS.  Once
rcu_init_geometry() is called, this hierarchy is compressed as needed
for the actual maximum number of CPUs for this system.

Later on, that srcu_struct structure is confused, sometimes referring
to its initial CONFIG_NR_CPUS-based hierarchy, and sometimes instead
to the new num_possible_cpus() hierarchy.  For example, each of its
->mynode fields continues to reference the original leaf rcu_node
structures, some of which might no longer exist.  On the other hand,
srcu_for_each_node_breadth_first() traverses to the new node hierarchy.

There are at least two bad possible outcomes to this:

1) a) A callback enqueued early on an srcu_data structure (call it
      *sdp) is recorded pending on sdp->mynode->srcu_data_have_cbs in
      srcu_funnel_gp_start() with sdp->mynode pointing to a deep leaf
      (say 3 levels).

   b) The grace period ends after rcu_init_geometry() shrinks the
      nodes level to a single one.  srcu_gp_end() walks through the new
      srcu_node hierarchy without ever reaching the old leaves so the
      callback is never executed.

   This is easily reproduced on an 8 CPUs machine with CONFIG_NR_CPUS >= 32
   and "rcupdate.rcu_self_test=1". The srcu_barrier() after early tests
   verification never completes and the boot hangs:

	[ 5413.141029] INFO: task swapper/0:1 blocked for more than 4915 seconds.
	[ 5413.147564]       Not tainted 5.12.0-rc4+ #28
	[ 5413.151927] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	[ 5413.159753] task:swapper/0       state:D stack:    0 pid:    1 ppid:     0 flags:0x00004000
	[ 5413.168099] Call Trace:
	[ 5413.170555]  __schedule+0x36c/0x930
	[ 5413.174057]  ? wait_for_completion+0x88/0x110
	[ 5413.178423]  schedule+0x46/0xf0
	[ 5413.181575]  schedule_timeout+0x284/0x380
	[ 5413.185591]  ? wait_for_completion+0x88/0x110
	[ 5413.189957]  ? mark_held_locks+0x61/0x80
	[ 5413.193882]  ? mark_held_locks+0x61/0x80
	[ 5413.197809]  ? _raw_spin_unlock_irq+0x24/0x50
	[ 5413.202173]  ? wait_for_completion+0x88/0x110
	[ 5413.206535]  wait_for_completion+0xb4/0x110
	[ 5413.210724]  ? srcu_torture_stats_print+0x110/0x110
	[ 5413.215610]  srcu_barrier+0x187/0x200
	[ 5413.219277]  ? rcu_tasks_verify_self_tests+0x50/0x50
	[ 5413.224244]  ? rdinit_setup+0x2b/0x2b
	[ 5413.227907]  rcu_verify_early_boot_tests+0x2d/0x40
	[ 5413.232700]  do_one_initcall+0x63/0x310
	[ 5413.236541]  ? rdinit_setup+0x2b/0x2b
	[ 5413.240207]  ? rcu_read_lock_sched_held+0x52/0x80
	[ 5413.244912]  kernel_init_freeable+0x253/0x28f
	[ 5413.249273]  ? rest_init+0x250/0x250
	[ 5413.252846]  kernel_init+0xa/0x110
	[ 5413.256257]  ret_from_fork+0x22/0x30

2) An srcu_struct structure that is initialized before rcu_init_geometry()
   and used afterward will always have stale rdp->mynode references,
   resulting in callbacks to be missed in srcu_gp_end(), just like in
   the previous scenario.

This commit therefore causes init_srcu_struct_nodes to initialize the
geometry, if needed.  This ensures that the srcu_node hierarchy is
properly built and distributed from the get-go.

Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcu.h      |  2 ++
 kernel/rcu/srcutree.c |  3 +++
 kernel/rcu/tree.c     | 16 +++++++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index bf0827d4b659..cfd06fb5ba6d 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -308,6 +308,8 @@ static inline void rcu_init_levelspread(int *levelspread, const int *levelcnt)
 	}
 }
 
+extern void rcu_init_geometry(void);
+
 /* Returns a pointer to the first leaf rcu_node structure. */
 #define rcu_first_leaf_node() (rcu_state.level[rcu_num_lvls - 1])
 
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index e26547b34ad3..072e47288f1f 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -90,6 +90,9 @@ static void init_srcu_struct_nodes(struct srcu_struct *ssp, bool is_static)
 	struct srcu_node *snp;
 	struct srcu_node *snp_first;
 
+	/* Initialize geometry if it has not already been initialized. */
+	rcu_init_geometry();
+
 	/* Work out the overall tree geometry. */
 	ssp->level[0] = &ssp->node[0];
 	for (i = 1; i < rcu_num_lvls; i++)
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7356764e49a0..bbca0cba3c58 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4502,11 +4502,25 @@ static void __init rcu_init_one(void)
  * replace the definitions in tree.h because those are needed to size
  * the ->node array in the rcu_state structure.
  */
-static void __init rcu_init_geometry(void)
+void rcu_init_geometry(void)
 {
 	ulong d;
 	int i;
+	static unsigned long old_nr_cpu_ids;
 	int rcu_capacity[RCU_NUM_LVLS];
+	static bool initialized;
+
+	if (initialized) {
+		/*
+		 * Warn if setup_nr_cpu_ids() had not yet been invoked,
+		 * unless nr_cpus_ids == NR_CPUS, in which case who cares?
+		 */
+		WARN_ON_ONCE(old_nr_cpu_ids != nr_cpu_ids);
+		return;
+	}
+
+	old_nr_cpu_ids = nr_cpu_ids;
+	initialized = true;
 
 	/*
 	 * Initialize any unspecified boot parameters.
-- 
2.30.2

