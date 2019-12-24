Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BC129C19
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 01:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLXAra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 19:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfLXAra (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 19:47:30 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9555520643;
        Tue, 24 Dec 2019 00:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577148448;
        bh=ArNuM/UANoqHn/rfxdZImxU331FE2wIqQw2rp2iAYhI=;
        h=Date:From:To:Subject:From;
        b=UYk9+LK4OX6XSISVBvLYy8i0kFmqfGHQuADKxM6c+ECoDNYUUBZjeeBh9aomAg5l9
         fpKOE4f9helJR+yPaMkwJp5FiwochuLiRq79TPlOPqwF3JEkp81LISvG0U0Duol9uj
         zXwJtuigOIJt5iBC8KtWbVOz2tsBLrhdnCYdrFpk=
Date:   Mon, 23 Dec 2019 16:47:28 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, peterz@infradead.org, mhocko@kernel.org,
        mgorman@techsingularity.net, kirill.shutemov@linux.intel.com,
        iamjoonsoo.kim@lge.com, cai@lca.pw, bp@alien8.de, vbabka@suse.cz
Subject:  +
 mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch added to -mm tree
Message-ID: <20191224004728.wtiTO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, debug_pagealloc: don't rely on static keys too early
has been added to the -mm tree.  Its filename is
     mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, debug_pagealloc: don't rely on static keys too early

Commit 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable
debugging") has introduced a static key to reduce overhead when
debug_pagealloc is compiled in but not enabled.  It relied on the
assumption that jump_label_init() is called before parse_early_param() as
in start_kernel(), so when the "debug_pagealloc=on" option is parsed, it
is safe to enable the static key.

However, it turns out multiple architectures call parse_early_param()
earlier from their setup_arch().  x86 also calls jump_label_init() even
earlier, so no issue was found while testing the commit, but same is not
true for e.g.  ppc64 and s390 where the kernel would not boot with
debug_pagealloc=on as found by our QA.

To fix this without tricky changes to init code of multiple architectures,
this patch partially reverts the static key conversion from 96a2b03f281d. 
Init-time and non-fastpath calls (such as in arch code) of
debug_pagealloc_enabled() will again test a simple bool variable. 
Fastpath mm code is converted to a new debug_pagealloc_enabled_static()
variant that relies on the static key, which is enabled in a well-defined
point in mm_init() where it's guaranteed that jump_label_init() has been
called, regardless of architecture.

Link: http://lkml.kernel.org/r/20191219130612.23171-1-vbabka@suse.cz
Fixes: 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugging")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   18 +++++++++++++++---
 init/main.c        |    1 +
 mm/page_alloc.c    |   36 ++++++++++++------------------------
 mm/slab.c          |    4 ++--
 mm/slub.c          |    2 +-
 mm/vmalloc.c       |    4 ++--
 6 files changed, 33 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/include/linux/mm.h
@@ -2652,14 +2652,26 @@ static inline bool want_init_on_free(voi
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
 {
+	return IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
+		_debug_pagealloc_enabled_early;
+}
+
+/*
+ * For use in fast paths after init_debug_pagealloc() has run, or when a
+ * false negative result is not harmful when called too early.
+ */
+static inline bool debug_pagealloc_enabled_static(void)
+{
 	if (!IS_ENABLED(CONFIG_DEBUG_PAGEALLOC))
 		return false;
 
--- a/init/main.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/init/main.c
@@ -554,6 +554,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	init_debug_pagealloc();
 	report_meminit();
 	mem_init();
 	kmem_cache_init();
--- a/mm/page_alloc.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/mm/page_alloc.c
@@ -694,34 +694,26 @@ void prep_compound_page(struct page *pag
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
 
@@ -1186,7 +1178,7 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		kernel_map_pages(page, 1 << order, 0);
 
 	kasan_free_nondeferred_pages(page, order);
@@ -1207,7 +1199,7 @@ static bool free_pcp_prepare(struct page
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return free_pages_check(page);
 	else
 		return false;
@@ -1221,7 +1213,7 @@ static bool bulkfree_pcp_prepare(struct
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
@@ -2106,7 +2094,7 @@ static inline bool free_pages_prezeroed(
  */
 static inline bool check_pcp_refill(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2128,7 +2116,7 @@ static inline bool check_pcp_refill(stru
 }
 static inline bool check_new_pcp(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2155,7 +2143,7 @@ inline void post_alloc_hook(struct page
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
--- a/mm/slab.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/mm/slab.c
@@ -1416,7 +1416,7 @@ static void kmem_rcu_free(struct rcu_hea
 #if DEBUG
 static bool is_debug_pagealloc_cache(struct kmem_cache *cachep)
 {
-	if (debug_pagealloc_enabled() && OFF_SLAB(cachep) &&
+	if (debug_pagealloc_enabled_static() && OFF_SLAB(cachep) &&
 		(cachep->size % PAGE_SIZE) == 0)
 		return true;
 
@@ -2008,7 +2008,7 @@ int __kmem_cache_create(struct kmem_cach
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
+	if (debug_pagealloc_enabled_static() && (flags & SLAB_POISON) &&
 		size >= 256 && cachep->object_size > cache_line_size()) {
 		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
 			size_t tmp_size = ALIGN(size, PAGE_SIZE);
--- a/mm/slub.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/mm/slub.c
@@ -288,7 +288,7 @@ static inline void *get_freepointer_safe
 	unsigned long freepointer_addr;
 	void *p;
 
-	if (!debug_pagealloc_enabled())
+	if (!debug_pagealloc_enabled_static())
 		return get_freepointer(s, object);
 
 	freepointer_addr = (unsigned long)object + s->offset;
--- a/mm/vmalloc.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/mm/vmalloc.c
@@ -1383,7 +1383,7 @@ static void free_unmap_vmap_area(struct
 {
 	flush_cache_vunmap(va->va_start, va->va_end);
 	unmap_vmap_area(va);
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(va->va_start, va->va_end);
 
 	free_vmap_area_noflush(va);
@@ -1681,7 +1681,7 @@ static void vb_free(const void *addr, un
 
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range((unsigned long)addr,
 					(unsigned long)addr + size);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-thp-tweak-reclaim-compaction-effort-of-local-only-and-all-node-allocations.patch
mm-debug_pagealloc-dont-rely-on-static-keys-too-early.patch

