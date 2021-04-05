Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAAE353D7F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbhDEJAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237119AbhDEJAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96AA560238;
        Mon,  5 Apr 2021 09:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613202;
        bh=f+WFWDJqaCm2e5vQgPs4np4tgFAjZmeiq0evN5RxexE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqQI5mot4Mdyt1U1XpX41wN3zxhVFzvimO25a94t0Fs6d9YF3laz3nWmLsTV1D+T0
         hrMh/LDuiTJURM7dcbYgnZY0yCXdA2eaOPINK7B+J8F5VxCt8FBIsvTqwzRBfQmCCe
         lkaedD0bi3UoMJcTEIeQbyOsDSHkkW0kTfb+JP5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/52] mm: memcg: make sure memory.events is uptodate when waking pollers
Date:   Mon,  5 Apr 2021 10:53:59 +0200
Message-Id: <20210405085023.076458735@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit e27be240df53f1a20c659168e722b5d9f16cc7f4 upstream.

Commit a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
memory.stat reporting") added per-cpu drift to all memory cgroup stats
and events shown in memory.stat and memory.events.

For memory.stat this is acceptable.  But memory.events issues file
notifications, and somebody polling the file for changes will be
confused when the counters in it are unchanged after a wakeup.

Luckily, the events in memory.events - MEMCG_LOW, MEMCG_HIGH, MEMCG_MAX,
MEMCG_OOM - are sufficiently rare and high-level that we don't need
per-cpu buffering for them: MEMCG_HIGH and MEMCG_MAX would be the most
frequent, but they're counting invocations of reclaim, which is a
complex operation that touches many shared cachelines.

This splits memory.events from the generic VM events and tracks them in
their own, unbuffered atomic counters.  That's also cleaner, as it
eliminates the ugly enum nesting of VM and cgroup events.

[hannes@cmpxchg.org: "array subscript is above array bounds"]
  Link: http://lkml.kernel.org/r/20180406155441.GA20806@cmpxchg.org
Link: http://lkml.kernel.org/r/20180405175507.GA24817@cmpxchg.org
Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 35 ++++++++++++++++++-----------------
 mm/memcontrol.c            | 28 ++++++++++++++++------------
 mm/vmscan.c                |  2 +-
 3 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c46016bb25eb..6503a9ca27c1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -48,13 +48,12 @@ enum memcg_stat_item {
 	MEMCG_NR_STAT,
 };
 
-/* Cgroup-specific events, on top of universal VM events */
-enum memcg_event_item {
-	MEMCG_LOW = NR_VM_EVENT_ITEMS,
+enum memcg_memory_event {
+	MEMCG_LOW,
 	MEMCG_HIGH,
 	MEMCG_MAX,
 	MEMCG_OOM,
-	MEMCG_NR_EVENTS,
+	MEMCG_NR_MEMORY_EVENTS,
 };
 
 struct mem_cgroup_reclaim_cookie {
@@ -88,7 +87,7 @@ enum mem_cgroup_events_target {
 
 struct mem_cgroup_stat_cpu {
 	long count[MEMCG_NR_STAT];
-	unsigned long events[MEMCG_NR_EVENTS];
+	unsigned long events[NR_VM_EVENT_ITEMS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
@@ -202,7 +201,8 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
-	/* handle for "memory.events" */
+	/* memory.events */
+	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
 	struct cgroup_file events_file;
 
 	/* protect arrays of thresholds */
@@ -231,9 +231,10 @@ struct mem_cgroup {
 	struct task_struct	*move_lock_task;
 	unsigned long		move_lock_flags;
 
+	/* memory.stat */
 	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
 	atomic_long_t		stat[MEMCG_NR_STAT];
-	atomic_long_t		events[MEMCG_NR_EVENTS];
+	atomic_long_t		events[NR_VM_EVENT_ITEMS];
 
 	unsigned long		socket_pressure;
 
@@ -645,9 +646,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void __count_memcg_events(struct mem_cgroup *memcg,
-					int idx, unsigned long count)
+					enum vm_event_item idx,
+					unsigned long count)
 {
 	unsigned long x;
 
@@ -663,7 +664,8 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 }
 
 static inline void count_memcg_events(struct mem_cgroup *memcg,
-				      int idx, unsigned long count)
+				      enum vm_event_item idx,
+				      unsigned long count)
 {
 	unsigned long flags;
 
@@ -672,9 +674,8 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 	local_irq_restore(flags);
 }
 
-/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void count_memcg_page_event(struct page *page,
-					  int idx)
+					  enum vm_event_item idx)
 {
 	if (page->mem_cgroup)
 		count_memcg_events(page->mem_cgroup, idx, 1);
@@ -698,10 +699,10 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-static inline void mem_cgroup_event(struct mem_cgroup *memcg,
-				    enum memcg_event_item event)
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
 {
-	count_memcg_events(memcg, event, 1);
+	atomic_long_inc(&memcg->memory_events[event]);
 	cgroup_file_notify(&memcg->events_file);
 }
 
@@ -721,8 +722,8 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
-static inline void mem_cgroup_event(struct mem_cgroup *memcg,
-				    enum memcg_event_item event)
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e763cdccb33..31972189a827 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1872,7 +1872,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 			}
 		}
 
-		for (i = 0; i < MEMCG_NR_EVENTS; i++) {
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
 			long x;
 
 			x = this_cpu_xchg(memcg->stat_cpu->events[i], 0);
@@ -1891,7 +1891,7 @@ static void reclaim_high(struct mem_cgroup *memcg,
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
 			continue;
-		mem_cgroup_event(memcg, MEMCG_HIGH);
+		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 }
@@ -1982,7 +1982,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	mem_cgroup_event(mem_over_limit, MEMCG_MAX);
+	memcg_memory_event(mem_over_limit, MEMCG_MAX);
 
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
@@ -2025,7 +2025,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (fatal_signal_pending(current))
 		goto force;
 
-	mem_cgroup_event(mem_over_limit, MEMCG_OOM);
+	memcg_memory_event(mem_over_limit, MEMCG_OOM);
 
 	mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
@@ -2790,10 +2790,10 @@ static void tree_events(struct mem_cgroup *memcg, unsigned long *events)
 	struct mem_cgroup *iter;
 	int i;
 
-	memset(events, 0, sizeof(*events) * MEMCG_NR_EVENTS);
+	memset(events, 0, sizeof(*events) * NR_VM_EVENT_ITEMS);
 
 	for_each_mem_cgroup_tree(iter, memcg) {
-		for (i = 0; i < MEMCG_NR_EVENTS; i++)
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			events[i] += memcg_sum_events(iter, i);
 	}
 }
@@ -5299,7 +5299,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		mem_cgroup_event(memcg, MEMCG_OOM);
+		memcg_memory_event(memcg, MEMCG_OOM);
 		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
 			break;
 	}
@@ -5312,10 +5312,14 @@ static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 
-	seq_printf(m, "low %lu\n", memcg_sum_events(memcg, MEMCG_LOW));
-	seq_printf(m, "high %lu\n", memcg_sum_events(memcg, MEMCG_HIGH));
-	seq_printf(m, "max %lu\n", memcg_sum_events(memcg, MEMCG_MAX));
-	seq_printf(m, "oom %lu\n", memcg_sum_events(memcg, MEMCG_OOM));
+	seq_printf(m, "low %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_LOW]));
+	seq_printf(m, "high %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_HIGH]));
+	seq_printf(m, "max %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_MAX]));
+	seq_printf(m, "oom %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_OOM]));
 	seq_printf(m, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
 
 	return 0;
@@ -5325,7 +5329,7 @@ static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long events[MEMCG_NR_EVENTS];
+	unsigned long events[NR_VM_EVENT_ITEMS];
 	int i;
 
 	/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ee6fbdec8a8..b37e6dd50925 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2628,7 +2628,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 					sc->memcg_low_skipped = 1;
 					continue;
 				}
-				mem_cgroup_event(memcg, MEMCG_LOW);
+				memcg_memory_event(memcg, MEMCG_LOW);
 			}
 
 			reclaimed = sc->nr_reclaimed;
-- 
2.30.2



