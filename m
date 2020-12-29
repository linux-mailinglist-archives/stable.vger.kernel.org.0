Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5302E6D53
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 03:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgL2Ce1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 21:34:27 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:48215 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgL2Ce0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 21:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609209264; x=1640745264;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SS/81BAdxP3uyD+Jfi2LPCxxT330L/x6Efhwdr7evs4=;
  b=OBudeyyqU2VaJ4uhJ1JrJ9L8MaQ84rKfKSWglQx/jk7ZJa2XKIMcO9QQ
   aRiPskeceWB49P2xCm7ZYzyrikXqAWqFqh3etSljRzJRyAAQ2fjDMnTna
   +dTwaTRSitMXrWhTUVQaL2yBZqXvnvWZPE+qNKeoU/bhSPXKe8DBQ3qM9
   4=;
X-IronPort-AV: E=Sophos;i="5.78,456,1599523200"; 
   d="scan'208";a="906639840"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 29 Dec 2020 02:33:44 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 5B597A17C0
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 02:33:44 +0000 (UTC)
Received: from EX13D46UWC004.ant.amazon.com (10.43.162.173) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 29 Dec 2020 02:33:43 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D46UWC004.ant.amazon.com (10.43.162.173) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 29 Dec 2020 02:33:43 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 29 Dec 2020 02:33:43 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 6E3EC452F4; Tue, 29 Dec 2020 02:33:42 +0000 (UTC)
Date:   Tue, 29 Dec 2020 02:33:42 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <shaoyi@amazon.com>, <surajjs@amazon.com>
Subject: [PATCH 4.14 1/3] mm: memcontrol: eliminate raw access to stat and
 event counters
Message-ID: <20201229023342.GA24991@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit c9019e9bf42e66d028d70d2da6206cad4dd9250d upstream

Replace all raw 'this_cpu_' modifications of the stat and event per-cpu
counters with API functions such as mod_memcg_state().

This makes the code easier to read, but is also in preparation for the
next patch, which changes the per-cpu implementation of those counters.

Link: http://lkml.kernel.org/r/20171103153336.24044-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 include/linux/memcontrol.h | 31 +++++++++++++++---------
 mm/memcontrol.c            | 59 ++++++++++++++++++++--------------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69966c461d1c..2c80b69dd266 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -272,13 +272,6 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_event(struct mem_cgroup *memcg,
-				    enum memcg_event_item event)
-{
-	this_cpu_inc(memcg->stat->events[event]);
-	cgroup_file_notify(&memcg->events_file);
-}
-
 bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg);
 
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
@@ -627,15 +620,23 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
+/* idx can be of type enum memcg_event_item or vm_event_item */
+static inline void __count_memcg_events(struct mem_cgroup *memcg,
+					int idx, unsigned long count)
+{
+	if (!mem_cgroup_disabled())
+		__this_cpu_add(memcg->stat->events[idx], count);
+}
+
+/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void count_memcg_events(struct mem_cgroup *memcg,
-				      enum vm_event_item idx,
-				      unsigned long count)
+				      int idx, unsigned long count)
 {
 	if (!mem_cgroup_disabled())
 		this_cpu_add(memcg->stat->events[idx], count);
 }
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
+/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void count_memcg_page_event(struct page *page,
 					  int idx)
 {
@@ -654,12 +655,20 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (likely(memcg)) {
-		this_cpu_inc(memcg->stat->events[idx]);
+		count_memcg_events(memcg, idx, 1);
 		if (idx == OOM_KILL)
 			cgroup_file_notify(&memcg->events_file);
 	}
 	rcu_read_unlock();
 }
+
+static inline void mem_cgroup_event(struct mem_cgroup *memcg,
+				    enum memcg_event_item event)
+{
+	count_memcg_events(memcg, event, 1);
+	cgroup_file_notify(&memcg->events_file);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70707d44a690..eba9dc4795b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -586,23 +586,23 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	 * counted as CACHE even if it's on ANON LRU.
 	 */
 	if (PageAnon(page))
-		__this_cpu_add(memcg->stat->count[MEMCG_RSS], nr_pages);
+		__mod_memcg_state(memcg, MEMCG_RSS, nr_pages);
 	else {
-		__this_cpu_add(memcg->stat->count[MEMCG_CACHE], nr_pages);
+		__mod_memcg_state(memcg, MEMCG_CACHE, nr_pages);
 		if (PageSwapBacked(page))
-			__this_cpu_add(memcg->stat->count[NR_SHMEM], nr_pages);
+			__mod_memcg_state(memcg, NR_SHMEM, nr_pages);
 	}
 
 	if (compound) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		__this_cpu_add(memcg->stat->count[MEMCG_RSS_HUGE], nr_pages);
+		__mod_memcg_state(memcg, MEMCG_RSS_HUGE, nr_pages);
 	}
 
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
-		__this_cpu_inc(memcg->stat->events[PGPGIN]);
+		__count_memcg_events(memcg, PGPGIN, 1);
 	else {
-		__this_cpu_inc(memcg->stat->events[PGPGOUT]);
+		__count_memcg_events(memcg, PGPGOUT, 1);
 		nr_pages = -nr_pages; /* for event */
 	}
 
@@ -2444,18 +2444,11 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 	for (i = 1; i < HPAGE_PMD_NR; i++)
 		head[i].mem_cgroup = head->mem_cgroup;
 
-	__this_cpu_sub(head->mem_cgroup->stat->count[MEMCG_RSS_HUGE],
-		       HPAGE_PMD_NR);
+	__mod_memcg_state(head->mem_cgroup, MEMCG_RSS_HUGE, -HPAGE_PMD_NR);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_MEMCG_SWAP
-static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
-				       int nr_entries)
-{
-	this_cpu_add(memcg->stat->count[MEMCG_SWAP], nr_entries);
-}
-
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
@@ -2479,8 +2472,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 	new_id = mem_cgroup_id(to);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
-		mem_cgroup_swap_statistics(from, -1);
-		mem_cgroup_swap_statistics(to, 1);
+		mod_memcg_state(from, MEMCG_SWAP, -1);
+		mod_memcg_state(to, MEMCG_SWAP, 1);
 		return 0;
 	}
 	return -EINVAL;
@@ -4632,8 +4625,8 @@ static int mem_cgroup_move_account(struct page *page,
 	spin_lock_irqsave(&from->move_lock, flags);
 
 	if (!anon && page_mapped(page)) {
-		__this_cpu_sub(from->stat->count[NR_FILE_MAPPED], nr_pages);
-		__this_cpu_add(to->stat->count[NR_FILE_MAPPED], nr_pages);
+		__mod_memcg_state(from, NR_FILE_MAPPED, -nr_pages);
+		__mod_memcg_state(to, NR_FILE_MAPPED, nr_pages);
 	}
 
 	/*
@@ -4645,16 +4638,14 @@ static int mem_cgroup_move_account(struct page *page,
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping_cap_account_dirty(mapping)) {
-			__this_cpu_sub(from->stat->count[NR_FILE_DIRTY],
-				       nr_pages);
-			__this_cpu_add(to->stat->count[NR_FILE_DIRTY],
-				       nr_pages);
+			__mod_memcg_state(from, NR_FILE_DIRTY, -nr_pages);
+			__mod_memcg_state(to, NR_FILE_DIRTY, nr_pages);
 		}
 	}
 
 	if (PageWriteback(page)) {
-		__this_cpu_sub(from->stat->count[NR_WRITEBACK], nr_pages);
-		__this_cpu_add(to->stat->count[NR_WRITEBACK], nr_pages);
+		__mod_memcg_state(from, NR_WRITEBACK, -nr_pages);
+		__mod_memcg_state(to, NR_WRITEBACK, nr_pages);
 	}
 
 	/*
@@ -5690,11 +5681,11 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	}
 
 	local_irq_save(flags);
-	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS], ug->nr_anon);
-	__this_cpu_sub(ug->memcg->stat->count[MEMCG_CACHE], ug->nr_file);
-	__this_cpu_sub(ug->memcg->stat->count[MEMCG_RSS_HUGE], ug->nr_huge);
-	__this_cpu_sub(ug->memcg->stat->count[NR_SHMEM], ug->nr_shmem);
-	__this_cpu_add(ug->memcg->stat->events[PGPGOUT], ug->pgpgout);
+	__mod_memcg_state(ug->memcg, MEMCG_RSS, -ug->nr_anon);
+	__mod_memcg_state(ug->memcg, MEMCG_CACHE, -ug->nr_file);
+	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
+	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
+	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
 	__this_cpu_add(ug->memcg->stat->nr_page_events, nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
@@ -5926,7 +5917,7 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (in_softirq())
 		gfp_mask = GFP_NOWAIT;
 
-	this_cpu_add(memcg->stat->count[MEMCG_SOCK], nr_pages);
+	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
 		return true;
@@ -5947,7 +5938,7 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		return;
 	}
 
-	this_cpu_sub(memcg->stat->count[MEMCG_SOCK], nr_pages);
+	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
 	refill_stock(memcg, nr_pages);
 }
@@ -6071,7 +6062,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg),
 				   nr_entries);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(swap_memcg, nr_entries);
+	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
 	page->mem_cgroup = NULL;
 
@@ -6137,7 +6128,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg), nr_pages);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(memcg, nr_pages);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	return 0;
 }
@@ -6165,7 +6156,7 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 			else
 				page_counter_uncharge(&memcg->memsw, nr_pages);
 		}
-		mem_cgroup_swap_statistics(memcg, -nr_pages);
+		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 		mem_cgroup_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
-- 
2.16.6

