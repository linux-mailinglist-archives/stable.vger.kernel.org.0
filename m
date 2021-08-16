Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1EC3ECF05
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhHPHNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:13:19 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13322 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhHPHNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 03:13:19 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gp52w6nf0z85qV;
        Mon, 16 Aug 2021 15:12:40 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:46 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 15:12:45 +0800
From:   Chen Huang <chenhuang5@huawei.com>
To:     Roman Gushchin <guro@fb.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Wang Hai" <wanghai38@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Chen Huang <chenhuang5@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10.y 02/11] mm: memcontrol/slab: Use helpers to access slab page's memcg_data
Date:   Mon, 16 Aug 2021 07:21:38 +0000
Message-ID: <20210816072147.3481782-3-chenhuang5@huawei.com>
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

From: Roman Gushchin <guro@fb.com>

To gather all direct accesses to struct page's memcg_data field in one
place, let's introduce 3 new helpers to use in the slab accounting code:

  struct obj_cgroup **page_objcgs(struct page *page);
  struct obj_cgroup **page_objcgs_check(struct page *page);
  bool set_page_objcgs(struct page *page, struct obj_cgroup **objcgs);

They are similar to the corresponding API for generic pages, except that
the setter can return false, indicating that the value has been already
set from a different thread.

Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lkml.kernel.org/r/20201027001657.3398190-3-guro@fb.com
Link: https://lore.kernel.org/bpf/20201201215900.3569844-3-guro@fb.com
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 include/linux/memcontrol.h | 64 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  6 ++--
 mm/slab.h                  | 35 +++++----------------
 3 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e3abc814f01b..2805fe81f97d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -416,6 +416,70 @@ static inline struct mem_cgroup *page_memcg_check(struct page *page)
 	return (struct mem_cgroup *)memcg_data;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+/*
+ * page_objcgs - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function assumes that the page is known to have an
+ * associated object cgroups vector. It's not safe to call this function
+ * against pages, which might have an associated memory cgroup: e.g.
+ * kernel stack pages.
+ */
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+}
+
+/*
+ * page_objcgs_check - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function is safe to use if the page can be directly associated
+ * with a memory cgroup.
+ */
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
+	if (memcg_data && (memcg_data & 0x1UL))
+		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+
+	return NULL;
+}
+
+/*
+ * set_page_objcgs - associate a page with a object cgroups vector
+ * @page: a pointer to the page struct
+ * @objcgs: a pointer to the object cgroups vector
+ *
+ * Atomically associates a page with a vector of object cgroups.
+ */
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+}
+#else
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	return NULL;
+}
+
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return true;
+}
+#endif
+
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
 	if (idx == MEMCG_PERCPU_B)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dea907c83d40..b9f49ddc5ced 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2908,7 +2908,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 	if (!vec)
 		return -ENOMEM;
 
-	if (cmpxchg(&page->memcg_data, 0, (unsigned long)vec | 0x1UL))
+	if (!set_page_objcgs(page, vec))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
@@ -2942,12 +2942,12 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 	 * Memcg membership data for each individual object is saved in
 	 * the page->obj_cgroups.
 	 */
-	if (page_has_obj_cgroups(page)) {
+	if (page_objcgs_check(page)) {
 		struct obj_cgroup *objcg;
 		unsigned int off;
 
 		off = obj_to_index(page->slab_cache, page, p);
-		objcg = page_obj_cgroups(page)[off];
+		objcg = page_objcgs(page)[off];
 		if (objcg)
 			return obj_cgroup_memcg(objcg);
 
diff --git a/mm/slab.h b/mm/slab.h
index ac43829b73d4..571757eb4a8f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -237,28 +237,12 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
-{
-	/*
-	 * Page's memory cgroup and obj_cgroups vector are sharing the same
-	 * space. To distinguish between them in case we don't know for sure
-	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
-	 * always set the lowest bit of obj_cgroups.
-	 */
-	return (struct obj_cgroup **)(page->memcg_data & ~0x1UL);
-}
-
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return page->memcg_data & 0x1UL;
-}
-
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
-	kfree(page_obj_cgroups(page));
+	kfree(page_objcgs(page));
 	page->memcg_data = 0;
 }
 
@@ -329,7 +313,7 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
 
-			if (!page_has_obj_cgroups(page) &&
+			if (!page_objcgs(page) &&
 			    memcg_alloc_page_obj_cgroups(page, s, flags)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
@@ -337,7 +321,7 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 
 			off = obj_to_index(s, page, p[i]);
 			obj_cgroup_get(objcg);
-			page_obj_cgroups(page)[off] = objcg;
+			page_objcgs(page)[off] = objcg;
 			mod_objcg_state(objcg, page_pgdat(page),
 					cache_vmstat_idx(s), obj_full_size(s));
 		} else {
@@ -351,6 +335,7 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 					void **p, int objects)
 {
 	struct kmem_cache *s;
+	struct obj_cgroup **objcgs;
 	struct obj_cgroup *objcg;
 	struct page *page;
 	unsigned int off;
@@ -364,7 +349,8 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 			continue;
 
 		page = virt_to_head_page(p[i]);
-		if (!page_has_obj_cgroups(page))
+		objcgs = page_objcgs(page);
+		if (!objcgs)
 			continue;
 
 		if (!s_orig)
@@ -373,11 +359,11 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 			s = s_orig;
 
 		off = obj_to_index(s, page, p[i]);
-		objcg = page_obj_cgroups(page)[off];
+		objcg = objcgs[off];
 		if (!objcg)
 			continue;
 
-		page_obj_cgroups(page)[off] = NULL;
+		objcgs[off] = NULL;
 		obj_cgroup_uncharge(objcg, obj_full_size(s));
 		mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
 				-obj_full_size(s));
@@ -386,11 +372,6 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 }
 
 #else /* CONFIG_MEMCG_KMEM */
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return false;
-}
-
 static inline struct mem_cgroup *memcg_from_slab_obj(void *ptr)
 {
 	return NULL;
-- 
2.18.0.huawei.25

