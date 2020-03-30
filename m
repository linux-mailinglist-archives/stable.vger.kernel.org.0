Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8967E19874F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgC3WXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 18:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgC3WXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 18:23:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACDD20771;
        Mon, 30 Mar 2020 22:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585606986;
        bh=byQL8CQkPbveXppasiwtC80gmgM7lCres5yzqiePbz8=;
        h=Date:From:To:Subject:From;
        b=E1O9LoK7AvYjOx84KEHdG8F0AEYc87j5eGdKY/Kamgbij2h4EXeI40Jpy0EKTEts8
         0r5j1RZFtAWlJykPwNFcXzA5Ao2JK9pISQsp3k1kf+Kh7XKSWwgUtkHE+odf4kysX9
         41N1bLtXYG/XNi+stNygh6dFb4cXhbSw9r/kIFh0=
Date:   Mon, 30 Mar 2020 15:23:06 -0700
From:   akpm@linux-foundation.org
To:     bharata@linux.ibm.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-fork-fix-kernel=5Fstack-memcg-stats-for-various-stack-i?=
 =?US-ASCII?Q?mplementations.patch?= removed from -mm tree
Message-ID: <20200330222306.B8yVlf9m6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations
has been removed from the -mm tree.  Its filename was
     mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations

Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio the
space for task stacks can be allocated using __vmalloc_node_range(),
alloc_pages_node() and kmem_cache_alloc_node().  In the first and the
second cases page->mem_cgroup pointer is set, but in the third it's not:
memcg membership of a slab page should be determined using the
memcg_from_slab_page() function, which looks at
page->slab_cache->memcg_params.memcg .  In this case, using
mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
page->mem_cgroup pointer is NULL even for pages charged to a non-root
memory cgroup.

It can lead to kernel_stack per-memcg counters permanently showing 0 on
some architectures (depending on the configuration).

In order to fix it, let's introduce a mod_memcg_obj_state() helper, which
takes a pointer to a kernel object as a first argument, uses
mem_cgroup_from_obj() to get a RCU-protected memcg pointer and calls
mod_memcg_state().  It allows to handle all possible configurations
(CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE values) without
spilling any memcg/kmem specifics into fork.c .

Note: This is a special version of the patch created for stable
backports. It contains code from the following two patches:
  - mm: memcg/slab: introduce mem_cgroup_from_obj()
  - mm: fork: fix kernel_stack memcg stats for various stack implementations

[guro@fb.com: introduce mem_cgroup_from_obj()]
  Link: http://lkml.kernel.org/r/20200324004221.GA36662@carbon.dhcp.thefacebook.com
Link: http://lkml.kernel.org/r/20200303233550.251375-1-guro@fb.com
Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 +++++++++++
 kernel/fork.c              |    4 +--
 mm/memcontrol.c            |   38 +++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/include/linux/memcontrol.h
@@ -695,6 +695,7 @@ static inline unsigned long lruvec_page_
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void mod_memcg_obj_state(void *p, int idx, int val);
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
@@ -1123,6 +1124,10 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_memcg_obj_state(void *p, int idx, int val)
+{
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
@@ -1427,6 +1432,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1468,6 +1475,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/kernel/fork.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/kernel/fork.c
@@ -397,8 +397,8 @@ static void account_kernel_stack(struct
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
-				     account * (THREAD_SIZE / 1024));
+		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
+				    account * (THREAD_SIZE / 1024));
 	}
 }
 
--- a/mm/memcontrol.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/mm/memcontrol.c
@@ -777,6 +777,17 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_unlock();
 }
 
+void mod_memcg_obj_state(void *p, int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
@@ -2661,6 +2672,33 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct page *page;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	page = virt_to_head_page(p);
+
+	/*
+	 * Slab pages don't have page->mem_cgroup set because corresponding
+	 * kmem caches can be reparented during the lifetime. That's why
+	 * memcg_from_slab_page() should be used instead.
+	 */
+	if (PageSlab(page))
+		return memcg_from_slab_page(page);
+
+	/* All other pages use page->mem_cgroup */
+	return page->mem_cgroup;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch

