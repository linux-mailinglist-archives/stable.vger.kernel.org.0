Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529407FA13
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbfHBNbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394124AbfHBNYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:24:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC34A21773;
        Fri,  2 Aug 2019 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752255;
        bh=LKco+Ml/mXlTaYOYivdcpiSyFipxOrOj1dGMu4fxzos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPK/b148+btOzu8t2VuozUHmWM0u8vexwVcX7YdPtGz31W934fnvC0waoid5LG7yt
         RPOxEEoJ+86VRK1D3UyLWJlOzViTP5xnHrfj9hsoMCLcmbuXvDe0/0posmYE+Gd0UF
         7LZji9Q8vkENsmBQ6m7GW6V0HiiFTaFXh8uHNSRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 39/42] sched/fair: Use RCU accessors consistently for ->numa_group
Date:   Fri,  2 Aug 2019 09:22:59 -0400
Message-Id: <20190802132302.13537-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit cb361d8cdef69990f6b4504dc1fd9a594d983c97 ]

The old code used RCU annotations and accessors inconsistently for
->numa_group, which can lead to use-after-frees and NULL dereferences.

Let all accesses to ->numa_group use proper RCU helpers to prevent such
issues.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Fixes: 8c8a743c5087 ("sched/numa: Use {cpu, pid} to create task groups for shared faults")
Link: https://lkml.kernel.org/r/20190716152047.14424-3-jannh@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  10 +++-
 kernel/sched/fair.c   | 120 ++++++++++++++++++++++++++++--------------
 2 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dc024e283979..20f5ba262cc0d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1023,7 +1023,15 @@ struct task_struct {
 	u64				last_sum_exec_runtime;
 	struct callback_head		numa_work;
 
-	struct numa_group		*numa_group;
+	/*
+	 * This pointer is only modified for current in syscall and
+	 * pagefault context (and for tasks being destroyed), so it can be read
+	 * from any of the following contexts:
+	 *  - RCU read-side critical section
+	 *  - current->numa_group from everywhere
+	 *  - task's runqueue locked, task not running
+	 */
+	struct numa_group __rcu		*numa_group;
 
 	/*
 	 * numa_faults is an array split into four regions:
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34b998678b97d..75f322603d442 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1053,6 +1053,21 @@ struct numa_group {
 	unsigned long faults[0];
 };
 
+/*
+ * For functions that can be called in multiple contexts that permit reading
+ * ->numa_group (see struct task_struct for locking rules).
+ */
+static struct numa_group *deref_task_numa_group(struct task_struct *p)
+{
+	return rcu_dereference_check(p->numa_group, p == current ||
+		(lockdep_is_held(&task_rq(p)->lock) && !READ_ONCE(p->on_cpu)));
+}
+
+static struct numa_group *deref_curr_numa_group(struct task_struct *p)
+{
+	return rcu_dereference_protected(p->numa_group, p == current);
+}
+
 static inline unsigned long group_faults_priv(struct numa_group *ng);
 static inline unsigned long group_faults_shared(struct numa_group *ng);
 
@@ -1096,10 +1111,12 @@ static unsigned int task_scan_start(struct task_struct *p)
 {
 	unsigned long smin = task_scan_min(p);
 	unsigned long period = smin;
+	struct numa_group *ng;
 
 	/* Scale the maximum scan period with the amount of shared memory. */
-	if (p->numa_group) {
-		struct numa_group *ng = p->numa_group;
+	rcu_read_lock();
+	ng = rcu_dereference(p->numa_group);
+	if (ng) {
 		unsigned long shared = group_faults_shared(ng);
 		unsigned long private = group_faults_priv(ng);
 
@@ -1107,6 +1124,7 @@ static unsigned int task_scan_start(struct task_struct *p)
 		period *= shared + 1;
 		period /= private + shared + 1;
 	}
+	rcu_read_unlock();
 
 	return max(smin, period);
 }
@@ -1115,13 +1133,14 @@ static unsigned int task_scan_max(struct task_struct *p)
 {
 	unsigned long smin = task_scan_min(p);
 	unsigned long smax;
+	struct numa_group *ng;
 
 	/* Watch for min being lower than max due to floor calculations */
 	smax = sysctl_numa_balancing_scan_period_max / task_nr_scan_windows(p);
 
 	/* Scale the maximum scan period with the amount of shared memory. */
-	if (p->numa_group) {
-		struct numa_group *ng = p->numa_group;
+	ng = deref_curr_numa_group(p);
+	if (ng) {
 		unsigned long shared = group_faults_shared(ng);
 		unsigned long private = group_faults_priv(ng);
 		unsigned long period = smax;
@@ -1153,7 +1172,7 @@ void init_numa_balancing(unsigned long clone_flags, struct task_struct *p)
 	p->numa_scan_period		= sysctl_numa_balancing_scan_delay;
 	p->numa_work.next		= &p->numa_work;
 	p->numa_faults			= NULL;
-	p->numa_group			= NULL;
+	RCU_INIT_POINTER(p->numa_group, NULL);
 	p->last_task_numa_placement	= 0;
 	p->last_sum_exec_runtime	= 0;
 
@@ -1200,7 +1219,16 @@ static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 
 pid_t task_numa_group_id(struct task_struct *p)
 {
-	return p->numa_group ? p->numa_group->gid : 0;
+	struct numa_group *ng;
+	pid_t gid = 0;
+
+	rcu_read_lock();
+	ng = rcu_dereference(p->numa_group);
+	if (ng)
+		gid = ng->gid;
+	rcu_read_unlock();
+
+	return gid;
 }
 
 /*
@@ -1225,11 +1253,13 @@ static inline unsigned long task_faults(struct task_struct *p, int nid)
 
 static inline unsigned long group_faults(struct task_struct *p, int nid)
 {
-	if (!p->numa_group)
+	struct numa_group *ng = deref_task_numa_group(p);
+
+	if (!ng)
 		return 0;
 
-	return p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 0)] +
-		p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 1)];
+	return ng->faults[task_faults_idx(NUMA_MEM, nid, 0)] +
+		ng->faults[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
@@ -1367,12 +1397,13 @@ static inline unsigned long task_weight(struct task_struct *p, int nid,
 static inline unsigned long group_weight(struct task_struct *p, int nid,
 					 int dist)
 {
+	struct numa_group *ng = deref_task_numa_group(p);
 	unsigned long faults, total_faults;
 
-	if (!p->numa_group)
+	if (!ng)
 		return 0;
 
-	total_faults = p->numa_group->total_faults;
+	total_faults = ng->total_faults;
 
 	if (!total_faults)
 		return 0;
@@ -1386,7 +1417,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 				int src_nid, int dst_cpu)
 {
-	struct numa_group *ng = p->numa_group;
+	struct numa_group *ng = deref_curr_numa_group(p);
 	int dst_nid = cpu_to_node(dst_cpu);
 	int last_cpupid, this_cpupid;
 
@@ -1592,13 +1623,14 @@ static bool load_too_imbalanced(long src_load, long dst_load,
 static void task_numa_compare(struct task_numa_env *env,
 			      long taskimp, long groupimp, bool maymove)
 {
+	struct numa_group *cur_ng, *p_ng = deref_curr_numa_group(env->p);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
+	long imp = p_ng ? groupimp : taskimp;
 	struct task_struct *cur;
 	long src_load, dst_load;
-	long load;
-	long imp = env->p->numa_group ? groupimp : taskimp;
-	long moveimp = imp;
 	int dist = env->dist;
+	long moveimp = imp;
+	long load;
 
 	if (READ_ONCE(dst_rq->numa_migrate_on))
 		return;
@@ -1637,21 +1669,22 @@ static void task_numa_compare(struct task_numa_env *env,
 	 * If dst and source tasks are in the same NUMA group, or not
 	 * in any group then look only at task weights.
 	 */
-	if (cur->numa_group == env->p->numa_group) {
+	cur_ng = rcu_dereference(cur->numa_group);
+	if (cur_ng == p_ng) {
 		imp = taskimp + task_weight(cur, env->src_nid, dist) -
 		      task_weight(cur, env->dst_nid, dist);
 		/*
 		 * Add some hysteresis to prevent swapping the
 		 * tasks within a group over tiny differences.
 		 */
-		if (cur->numa_group)
+		if (cur_ng)
 			imp -= imp / 16;
 	} else {
 		/*
 		 * Compare the group weights. If a task is all by itself
 		 * (not part of a group), use the task weight instead.
 		 */
-		if (cur->numa_group && env->p->numa_group)
+		if (cur_ng && p_ng)
 			imp += group_weight(cur, env->src_nid, dist) -
 			       group_weight(cur, env->dst_nid, dist);
 		else
@@ -1749,11 +1782,12 @@ static int task_numa_migrate(struct task_struct *p)
 		.best_imp = 0,
 		.best_cpu = -1,
 	};
+	unsigned long taskweight, groupweight;
 	struct sched_domain *sd;
+	long taskimp, groupimp;
+	struct numa_group *ng;
 	struct rq *best_rq;
-	unsigned long taskweight, groupweight;
 	int nid, ret, dist;
-	long taskimp, groupimp;
 
 	/*
 	 * Pick the lowest SD_NUMA domain, as that would have the smallest
@@ -1799,7 +1833,8 @@ static int task_numa_migrate(struct task_struct *p)
 	 *   multiple NUMA nodes; in order to better consolidate the group,
 	 *   we need to check other locations.
 	 */
-	if (env.best_cpu == -1 || (p->numa_group && p->numa_group->active_nodes > 1)) {
+	ng = deref_curr_numa_group(p);
+	if (env.best_cpu == -1 || (ng && ng->active_nodes > 1)) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
@@ -1832,7 +1867,7 @@ static int task_numa_migrate(struct task_struct *p)
 	 * A task that migrated to a second choice node will be better off
 	 * trying for a better one later. Do not set the preferred node here.
 	 */
-	if (p->numa_group) {
+	if (ng) {
 		if (env.best_cpu == -1)
 			nid = env.src_nid;
 		else
@@ -2127,6 +2162,7 @@ static void task_numa_placement(struct task_struct *p)
 	unsigned long total_faults;
 	u64 runtime, period;
 	spinlock_t *group_lock = NULL;
+	struct numa_group *ng;
 
 	/*
 	 * The p->mm->numa_scan_seq field gets updated without
@@ -2144,8 +2180,9 @@ static void task_numa_placement(struct task_struct *p)
 	runtime = numa_get_avg_runtime(p, &period);
 
 	/* If the task is part of a group prevent parallel updates to group stats */
-	if (p->numa_group) {
-		group_lock = &p->numa_group->lock;
+	ng = deref_curr_numa_group(p);
+	if (ng) {
+		group_lock = &ng->lock;
 		spin_lock_irq(group_lock);
 	}
 
@@ -2186,7 +2223,7 @@ static void task_numa_placement(struct task_struct *p)
 			p->numa_faults[cpu_idx] += f_diff;
 			faults += p->numa_faults[mem_idx];
 			p->total_numa_faults += diff;
-			if (p->numa_group) {
+			if (ng) {
 				/*
 				 * safe because we can only change our own group
 				 *
@@ -2194,14 +2231,14 @@ static void task_numa_placement(struct task_struct *p)
 				 * nid and priv in a specific region because it
 				 * is at the beginning of the numa_faults array.
 				 */
-				p->numa_group->faults[mem_idx] += diff;
-				p->numa_group->faults_cpu[mem_idx] += f_diff;
-				p->numa_group->total_faults += diff;
-				group_faults += p->numa_group->faults[mem_idx];
+				ng->faults[mem_idx] += diff;
+				ng->faults_cpu[mem_idx] += f_diff;
+				ng->total_faults += diff;
+				group_faults += ng->faults[mem_idx];
 			}
 		}
 
-		if (!p->numa_group) {
+		if (!ng) {
 			if (faults > max_faults) {
 				max_faults = faults;
 				max_nid = nid;
@@ -2212,8 +2249,8 @@ static void task_numa_placement(struct task_struct *p)
 		}
 	}
 
-	if (p->numa_group) {
-		numa_group_count_active_nodes(p->numa_group);
+	if (ng) {
+		numa_group_count_active_nodes(ng);
 		spin_unlock_irq(group_lock);
 		max_nid = preferred_group_nid(p, max_nid);
 	}
@@ -2247,7 +2284,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	int cpu = cpupid_to_cpu(cpupid);
 	int i;
 
-	if (unlikely(!p->numa_group)) {
+	if (unlikely(!deref_curr_numa_group(p))) {
 		unsigned int size = sizeof(struct numa_group) +
 				    4*nr_node_ids*sizeof(unsigned long);
 
@@ -2283,7 +2320,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	if (!grp)
 		goto no_join;
 
-	my_grp = p->numa_group;
+	my_grp = deref_curr_numa_group(p);
 	if (grp == my_grp)
 		goto no_join;
 
@@ -2354,7 +2391,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
  */
 void task_numa_free(struct task_struct *p, bool final)
 {
-	struct numa_group *grp = p->numa_group;
+	/* safe: p either is current or is being freed by current */
+	struct numa_group *grp = rcu_dereference_raw(p->numa_group);
 	unsigned long *numa_faults = p->numa_faults;
 	unsigned long flags;
 	int i;
@@ -2434,7 +2472,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * actively using should be counted as local. This allows the
 	 * scan rate to slow down when a workload has settled down.
 	 */
-	ng = p->numa_group;
+	ng = deref_curr_numa_group(p);
 	if (!priv && !local && ng && ng->active_nodes > 1 &&
 				numa_is_active_node(cpu_node, ng) &&
 				numa_is_active_node(mem_node, ng))
@@ -10234,18 +10272,22 @@ void show_numa_stats(struct task_struct *p, struct seq_file *m)
 {
 	int node;
 	unsigned long tsf = 0, tpf = 0, gsf = 0, gpf = 0;
+	struct numa_group *ng;
 
+	rcu_read_lock();
+	ng = rcu_dereference(p->numa_group);
 	for_each_online_node(node) {
 		if (p->numa_faults) {
 			tsf = p->numa_faults[task_faults_idx(NUMA_MEM, node, 0)];
 			tpf = p->numa_faults[task_faults_idx(NUMA_MEM, node, 1)];
 		}
-		if (p->numa_group) {
-			gsf = p->numa_group->faults[task_faults_idx(NUMA_MEM, node, 0)],
-			gpf = p->numa_group->faults[task_faults_idx(NUMA_MEM, node, 1)];
+		if (ng) {
+			gsf = ng->faults[task_faults_idx(NUMA_MEM, node, 0)],
+			gpf = ng->faults[task_faults_idx(NUMA_MEM, node, 1)];
 		}
 		print_numa_stats(m, node, tsf, tpf, gsf, gpf);
 	}
+	rcu_read_unlock();
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
-- 
2.20.1

