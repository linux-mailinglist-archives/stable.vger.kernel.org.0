Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F063ECF0E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhHPHNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13325 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbhHPHNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gp5303vJkz86Wq;
        Mon, 16 Aug 2021 15:12:44 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:49 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:49 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "Xiongchun Duan" <duanxiongchun@bytedance.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PATCH 5.10.y 08/11] mm: memcontrol: use obj_cgroup APIs to charge kmem pages
Date:   Mon, 16 Aug 2021 07:21:44 +0000
Message-ID: <20210816072147.3481782-9-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20210816072147.3481782-1-chenhuang5@huawei.com>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema756-chm.china.huawei.com (10.1.198.198)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

Since Roman's series "The new cgroup slab memory controller" applied.
All slab objects are charged via the new APIs of obj_cgroup.  The new
APIs introduce a struct obj_cgroup to charge slab objects.  It prevents
long-living objects from pinning the original memory cgroup in the
memory.  But there are still some corner objects (e.g.  allocations
larger than order-1 page on SLUB) which are not charged via the new
APIs.  Those objects (include the pages which are allocated from buddy
allocator directly) are charged as kmem pages which still hold a
reference to the memory cgroup.

We want to reuse the obj_cgroup APIs to charge the kmem pages.  If we do
that, we should store an object cgroup pointer to page->memcg_data for
the kmem pages.

Finally, page->memcg_data will have 3 different meanings.

  1) For the slab pages, page->memcg_data points to an object cgroups
     vector.

  2) For the kmem pages (exclude the slab pages), page->memcg_data
     points to an object cgroup.

  3) For the user pages (e.g. the LRU pages), page->memcg_data points
     to a memory cgroup.

We do not change the behavior of page_memcg() and page_memcg_rcu().  They
are also suitable for LRU pages and kmem pages.  Why?

Because memory allocations pinning memcgs for a long time - it exists at a
larger scale and is causing recurring problems in the real world: page
cache doesn't get reclaimed for a long time, or is used by the second,
third, fourth, ...  instance of the same job that was restarted into a new
cgroup every time.  Unreclaimable dying cgroups pile up, waste memory, and
make page reclaim very inefficient.

We can convert LRU pages and most other raw memcg pins to the objcg
direction to fix this problem, and then the page->memcg will always point
to an object cgroup pointer.  At that time, LRU pages and kmem pages will
be treated the same.  The implementation of page_memcg() will remove the
kmem page check.

This patch aims to charge the kmem pages by using the new APIs of
obj_cgroup.  Finally, the page->memcg_data of the kmem page points to an
object cgroup.  We can use the __page_objcg() to get the object cgroup
associated with a kmem page.  Or we can use page_memcg() to get the memory
cgroup associated with a kmem page, but caller must ensure that the
returned memcg won't be released (e.g.  acquire the rcu_read_lock or
css_set_lock).

  Link: https://lkml.kernel.org/r/20210401030141.37061-1-songmuchun@bytedance.com

Link: https://lkml.kernel.org/r/20210319163821.20704-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
[songmuchun@bytedance.com: fix forget to obtain the ref to objcg in split_page_memcg]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Conflicts:
	include/linux/memcontrol.h
	mm/memcontrol.c
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 include/linux/memcontrol.h | 126 ++++++++++++++++++++++++++++++-------
 mm/memcontrol.c            | 117 ++++++++++++++++------------------
 2 files changed, 157 insertions(+), 86 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1a357edd2a1e..b8bb5d37d4ad 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,6 +354,62 @@ enum page_memcg_data_flags {
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
 
+static inline bool PageMemcgKmem(struct page *page);
+
+/*
+ * After the initialization objcg->memcg is always pointing at
+ * a valid memcg, but can be atomically swapped to the parent memcg.
+ *
+ * The caller must ensure that the returned memcg won't be released:
+ * e.g. acquire the rcu_read_lock or css_set_lock.
+ */
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return READ_ONCE(objcg->memcg);
+}
+
+/*
+ * __page_memcg - get the memory cgroup associated with a non-kmem page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages or
+ * kmem pages.
+ */
+static inline struct mem_cgroup *__page_memcg(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
+/*
+ * __page_objcg - get the object cgroup associated with a kmem page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper object cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages or
+ * LRU pages.
+ */
+static inline struct obj_cgroup *__page_objcg(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(!(memcg_data & MEMCG_DATA_KMEM), page);
+
+	return (struct obj_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
 /*
  * page_memcg - get the memory cgroup associated with a page
  * @page: a pointer to the page struct
@@ -363,20 +419,23 @@ enum page_memcg_data_flags {
  * proper memory cgroup pointer. It's not safe to call this function
  * against some type of pages, e.g. slab pages or ex-slab pages.
  *
- * Any of the following ensures page and memcg binding stability:
+ * For a non-kmem page any of the following ensures page and memcg binding
+ * stability:
+ *
  * - the page lock
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ *
+ * For a kmem page a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem page from being released.
  */
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
-	unsigned long memcg_data = page->memcg_data;
-
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
-
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	if (PageMemcgKmem(page))
+		return obj_cgroup_memcg(__page_objcg(page));
+	else
+		return __page_memcg(page);
 }
 
 /*
@@ -390,11 +449,19 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
  */
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
-				     ~MEMCG_DATA_FLAGS_MASK);
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		struct obj_cgroup *objcg;
+
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		return obj_cgroup_memcg(objcg);
+	}
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -402,15 +469,21 @@ static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
  * @page: a pointer to the page struct
  *
  * Returns a pointer to the memory cgroup associated with the page,
- * or NULL. This function unlike page_memcg() can take any  page
+ * or NULL. This function unlike page_memcg() can take any page
  * as an argument. It has to be used in cases when it's not known if a page
- * has an associated memory cgroup pointer or an object cgroups vector.
+ * has an associated memory cgroup pointer or an object cgroups vector or
+ * an object cgroup.
+ *
+ * For a non-kmem page any of the following ensures page and memcg binding
+ * stability:
  *
- * Any of the following ensures page and memcg binding stability:
  * - the page lock
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ *
+ * For a kmem page a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem page from being released.
  */
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
 {
@@ -423,6 +496,13 @@ static inline struct mem_cgroup *page_memcg_check(struct page *page)
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		struct obj_cgroup *objcg;
+
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		return obj_cgroup_memcg(objcg);
+	}
+
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
@@ -681,21 +761,15 @@ static inline void obj_cgroup_get(struct obj_cgroup *objcg)
 	percpu_ref_get(&objcg->refcnt);
 }
 
-static inline void obj_cgroup_put(struct obj_cgroup *objcg)
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
 {
-	percpu_ref_put(&objcg->refcnt);
+	percpu_ref_get_many(&objcg->refcnt, nr);
 }
 
-/*
- * After the initialization objcg->memcg is always pointing at
- * a valid memcg, but can be atomically swapped to the parent memcg.
- *
- * The caller must ensure that the returned memcg won't be released:
- * e.g. acquire the rcu_read_lock or css_set_lock.
- */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
-	return READ_ONCE(objcg->memcg);
+	percpu_ref_put(&objcg->refcnt);
 }
 
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
@@ -1007,18 +1081,22 @@ static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
-	struct mem_cgroup *memcg = page_memcg(head);
+	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
+	rcu_read_lock();
+	memcg = page_memcg(head);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
+		rcu_read_unlock();
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
+	rcu_read_unlock();
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73418413958c..738051c79cdd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1068,20 +1068,6 @@ static __always_inline struct mem_cgroup *active_memcg(void)
 		return current->active_memcg;
 }
 
-static __always_inline struct mem_cgroup *get_active_memcg(void)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-	memcg = active_memcg();
-	/* remote memcg must hold a ref. */
-	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
-	rcu_read_unlock();
-
-	return memcg;
-}
-
 static __always_inline bool memcg_kmem_bypass(void)
 {
 	/* Allow remote memcg charging from any context. */
@@ -1095,20 +1081,6 @@ static __always_inline bool memcg_kmem_bypass(void)
 	return false;
 }
 
-/**
- * If active memcg is set, do not fallback to current->mm->memcg.
- */
-static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
-{
-	if (memcg_kmem_bypass())
-		return NULL;
-
-	if (unlikely(active_memcg()))
-		return get_active_memcg();
-
-	return get_mem_cgroup_from_mm(current->mm);
-}
-
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -3128,18 +3100,18 @@ void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	int ret = 0;
 
-	memcg = get_mem_cgroup_from_current();
-	if (memcg && !mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
+	objcg = get_obj_cgroup_from_current();
+	if (objcg) {
+		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
-			page->memcg_data = (unsigned long)memcg |
+			page->memcg_data = (unsigned long)objcg |
 				MEMCG_DATA_KMEM;
 			return 0;
 		}
-		css_put(&memcg->css);
+		obj_cgroup_put(objcg);
 	}
 	return ret;
 }
@@ -3151,16 +3123,16 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct obj_cgroup *objcg;
 	unsigned int nr_pages = 1 << order;
 
-	if (!memcg)
+	if (!PageMemcgKmem(page))
 		return;
 
-	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
-	__memcg_kmem_uncharge(memcg, nr_pages);
+	objcg = __page_objcg(page);
+	obj_cgroup_uncharge_pages(objcg, nr_pages);
 	page->memcg_data = 0;
-	css_put(&memcg->css);
+	obj_cgroup_put(objcg);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -3299,12 +3271,13 @@ void split_page_memcg(struct page *head, unsigned int nr)
 	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < nr; i++) {
-		head[i].memcg_data = (unsigned long)memcg;
-		if (kmemcg)
-			__SetPageKmemcg(head + i);
-	}
-	css_get_many(&memcg->css, nr - 1);
+	for (i = 1; i < nr; i++)
+		head[i].memcg_data = head->memcg_data;
+
+	if (PageMemcgKmem(head))
+		obj_cgroup_get_many(__page_objcg(head), nr - 1);
+	else
+		css_get_many(&memcg->css, nr - 1);
 }
 
 #ifdef CONFIG_MEMCG_SWAP
@@ -6852,7 +6825,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
-	unsigned long nr_pages;
+	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	struct page *dummy_page;
@@ -6867,10 +6840,10 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 {
 	unsigned long flags;
 
-	if (!mem_cgroup_is_root(ug->memcg)) {
-		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
+	if (ug->nr_memory) {
+		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
+			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
 			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
@@ -6878,7 +6851,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
+	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
@@ -6889,40 +6862,60 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
 	unsigned long nr_pages;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (!page_memcg(page))
-		return;
-
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page_memcg(page) at this point, we have fully
+	 * page memcg or objcg at this point, we have fully
 	 * exclusive access to the page.
 	 */
+	if (PageMemcgKmem(page)) {
+		objcg = __page_objcg(page);
+		/*
+		 * This get matches the put at the end of the function and
+		 * kmem pages do not hold memcg references anymore.
+		 */
+		memcg = get_mem_cgroup_from_objcg(objcg);
+	} else {
+		memcg = __page_memcg(page);
+	}
+
+	if (!memcg)
+		return;
 
-	if (ug->memcg != page_memcg(page)) {
+	if (ug->memcg != memcg) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg = page_memcg(page);
+		ug->memcg = memcg;
 		ug->dummy_page = page;
 
 		/* pairs with css_put in uncharge_batch */
-		css_get(&ug->memcg->css);
+		css_get(&memcg->css);
 	}
 
 	nr_pages = compound_nr(page);
-	ug->nr_pages += nr_pages;
 
-	if (PageMemcgKmem(page))
+	if (PageMemcgKmem(page)) {
+		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
-	else
+
+		page->memcg_data = 0;
+		obj_cgroup_put(objcg);
+	} else {
+		/* LRU pages aren't accounted at the root level */
+		if (!mem_cgroup_is_root(memcg))
+			ug->nr_memory += nr_pages;
 		ug->pgpgout++;
 
-	page->memcg_data = 0;
-	css_put(&ug->memcg->css);
+		page->memcg_data = 0;
+	}
+
+	css_put(&memcg->css);
 }
 
 static void uncharge_list(struct list_head *page_list)
-- 
2.18.0.huawei.25

