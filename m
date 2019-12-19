Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827531262E3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 14:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLSNGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 08:06:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:33094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfLSNGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 08:06:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 139B1B371;
        Thu, 19 Dec 2019 13:06:30 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] mm, debug_pagealloc: don't rely on static keys too early
Date:   Thu, 19 Dec 2019 14:06:12 +0100
Message-Id: <20191219130612.23171-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugging")
has introduced a static key to reduce overhead when debug_pagealloc is compiled
in but not enabled. It relied on the assumption that jump_label_init() is
called before parse_early_param() as in start_kernel(), so when the
"debug_pagealloc=on" option is parsed, it is safe to enable the static key.

However, it turns out multiple architectures call parse_early_param() earlier
from their setup_arch(). x86 also calls jump_label_init() even earlier, so no
issue was found while testing the commit, but same is not true for e.g. ppc64
and s390 where the kernel would not boot with debug_pagealloc=on as found by
our QA.

To fix this without tricky changes to init code of multiple architectures, this
patch partially reverts the static key conversion from 96a2b03f281d. Init-time
and non-fastpath calls (such as in arch code) of debug_pagealloc_enabled() will
again test a simple bool variable. Fastpath mm code is converted to a new
debug_pagealloc_enabled_static() variant that relies on the static key, which
is enabled in a well-defined point in mm_init() where it's guaranteed that
jump_label_init() has been called, regardless of architecture.

Fixes: 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugging")
Cc: <stable@vger.kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h | 18 +++++++++++++++---
 init/main.c        |  1 +
 mm/page_alloc.c    | 36 ++++++++++++------------------------
 mm/slab.c          |  4 ++--
 mm/slub.c          |  2 +-
 mm/vmalloc.c       |  4 ++--
 6 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c97ea3b694e6..5cf260d5e248 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2655,13 +2655,25 @@ static inline bool want_init_on_free(void)
 	       !page_poisoning_enabled();
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT
-DECLARE_STATIC_KEY_TRUE(_debug_pagealloc_enabled);
+#ifdef CONFIG_DEBUG_PAGEALLOC
+extern void init_debug_pagealloc(void);
 #else
-DECLARE_STATIC_KEY_FALSE(_debug_pagealloc_enabled);
+static inline void init_debug_pagealloc(void) {}
 #endif
+extern bool _debug_pagealloc_enabled_early;
+DECLARE_STATIC_KEY_FALSE(_debug_pagealloc_enabled);
 
 static inline bool debug_pagealloc_enabled(void)
+{
+	return IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
+		_debug_pagealloc_enabled_early;
+}
+
+/*
+ * For use in fast paths after init_debug_pagealloc() has run, or when a
+ * false negative result is not harmful when called too early.
+ */
+static inline bool debug_pagealloc_enabled_static(void)
 {
 	if (!IS_ENABLED(CONFIG_DEBUG_PAGEALLOC))
 		return false;
diff --git a/init/main.c b/init/main.c
index ec3a1463ac69..c93b9cc201fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -554,6 +554,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	init_debug_pagealloc();
 	report_meminit();
 	mem_init();
 	kmem_cache_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4785a8a2040e..5e3fe156ffb4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -694,34 +694,26 @@ void prep_compound_page(struct page *page, unsigned int order)
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT
-DEFINE_STATIC_KEY_TRUE(_debug_pagealloc_enabled);
-#else
+bool _debug_pagealloc_enabled_early __read_mostly
+			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
 DEFINE_STATIC_KEY_FALSE(_debug_pagealloc_enabled);
-#endif
 EXPORT_SYMBOL(_debug_pagealloc_enabled);
 
 DEFINE_STATIC_KEY_FALSE(_debug_guardpage_enabled);
 
 static int __init early_debug_pagealloc(char *buf)
 {
-	bool enable = false;
-
-	if (kstrtobool(buf, &enable))
-		return -EINVAL;
-
-	if (enable)
-		static_branch_enable(&_debug_pagealloc_enabled);
-
-	return 0;
+	return kstrtobool(buf, &_debug_pagealloc_enabled_early);
 }
 early_param("debug_pagealloc", early_debug_pagealloc);
 
-static void init_debug_guardpage(void)
+void init_debug_pagealloc(void)
 {
 	if (!debug_pagealloc_enabled())
 		return;
 
+	static_branch_enable(&_debug_pagealloc_enabled);
+
 	if (!debug_guardpage_minorder())
 		return;
 
@@ -1186,7 +1178,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		kernel_map_pages(page, 1 << order, 0);
 
 	kasan_free_nondeferred_pages(page, order);
@@ -1207,7 +1199,7 @@ static bool free_pcp_prepare(struct page *page)
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return free_pages_check(page);
 	else
 		return false;
@@ -1221,7 +1213,7 @@ static bool bulkfree_pcp_prepare(struct page *page)
  */
 static bool free_pcp_prepare(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return free_pages_prepare(page, 0, true);
 	else
 		return free_pages_prepare(page, 0, false);
@@ -1973,10 +1965,6 @@ void __init page_alloc_init_late(void)
 
 	for_each_populated_zone(zone)
 		set_zone_contiguous(zone);
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	init_debug_guardpage();
-#endif
 }
 
 #ifdef CONFIG_CMA
@@ -2106,7 +2094,7 @@ static inline bool free_pages_prezeroed(void)
  */
 static inline bool check_pcp_refill(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2128,7 +2116,7 @@ static inline bool check_pcp_refill(struct page *page)
 }
 static inline bool check_new_pcp(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2155,7 +2143,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
diff --git a/mm/slab.c b/mm/slab.c
index f1e1840af533..a89633603b2d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1416,7 +1416,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 #if DEBUG
 static bool is_debug_pagealloc_cache(struct kmem_cache *cachep)
 {
-	if (debug_pagealloc_enabled() && OFF_SLAB(cachep) &&
+	if (debug_pagealloc_enabled_static() && OFF_SLAB(cachep) &&
 		(cachep->size % PAGE_SIZE) == 0)
 		return true;
 
@@ -2008,7 +2008,7 @@ int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
+	if (debug_pagealloc_enabled_static() && (flags & SLAB_POISON) &&
 		size >= 256 && cachep->object_size > cache_line_size()) {
 		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
 			size_t tmp_size = ALIGN(size, PAGE_SIZE);
diff --git a/mm/slub.c b/mm/slub.c
index d11389710b12..8eafccf75940 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -288,7 +288,7 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 	unsigned long freepointer_addr;
 	void *p;
 
-	if (!debug_pagealloc_enabled())
+	if (!debug_pagealloc_enabled_static())
 		return get_freepointer(s, object);
 
 	freepointer_addr = (unsigned long)object + s->offset;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4d3b3d60d893..544cc9a725cf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1375,7 +1375,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 {
 	flush_cache_vunmap(va->va_start, va->va_end);
 	unmap_vmap_area(va);
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(va->va_start, va->va_end);
 
 	free_vmap_area_noflush(va);
@@ -1673,7 +1673,7 @@ static void vb_free(const void *addr, unsigned long size)
 
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range((unsigned long)addr,
 					(unsigned long)addr + size);
 
-- 
2.24.0

