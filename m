Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C036139E35
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 01:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgANA3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 19:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:22 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85FFD2084D;
        Tue, 14 Jan 2020 00:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578961761;
        bh=KWl2p7alri5oK+YFVOZ4FhRmZmqm8L+8gOMyGzmKubQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=G1FXr+2M08ju8p2c0M/qCbYDFX2ltn5SbKUBLPHBM/SSw+M5ehLWxOV6iGaFPZf9L
         cmfBfnRgL+w6PfG8R9RvlqfmlOC7iMpxyBDiOGmJo4ERKn/IbOMJC59HguPO4AFJKv
         Mzf9k7scQ6JRlPUagEWAGdCVBIFnHTYq5wLEritY=
Date:   Mon, 13 Jan 2020 16:29:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     willy@infradead.org, stable@vger.kernel.org, sfr@canb.auug.org.au,
        peterz@infradead.org, mhocko@kernel.org,
        mgorman@techsingularity.net, kirill.shutemov@linux.intel.com,
        iamjoonsoo.kim@lge.com, cai@lca.pw, bp@alien8.de, vbabka@suse.cz,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/11] mm, debug_pagealloc: don't rely on static
 keys too early
Message-ID: <20200114002920.lOmmY%akpm@linux-foundation.org>
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
User-Agent: s-nail v14.9.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[sfr@canb.auug.org.au: export _debug_pagealloc_enabled_early]
  Link: http://lkml.kernel.org/r/20200106164944.063ac07b@canb.auug.org.au
Link: http://lkml.kernel.org/r/20191219130612.23171-1-vbabka@suse.cz
Fixes: 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugging")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
 mm/page_alloc.c    |   37 +++++++++++++------------------------
 mm/slab.c          |    4 ++--
 mm/slub.c          |    2 +-
 mm/vmalloc.c       |    4 ++--
 6 files changed, 34 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/include/linux/mm.h
@@ -2658,14 +2658,26 @@ static inline bool want_init_on_free(voi
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
@@ -553,6 +553,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	init_debug_pagealloc();
 	report_meminit();
 	mem_init();
 	kmem_cache_init();
--- a/mm/page_alloc.c~mm-debug_pagealloc-dont-rely-on-static-keys-too-early
+++ a/mm/page_alloc.c
@@ -694,34 +694,27 @@ void prep_compound_page(struct page *pag
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT
-DEFINE_STATIC_KEY_TRUE(_debug_pagealloc_enabled);
-#else
+bool _debug_pagealloc_enabled_early __read_mostly
+			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
+EXPORT_SYMBOL(_debug_pagealloc_enabled_early);
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
 
@@ -1186,7 +1179,7 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		kernel_map_pages(page, 1 << order, 0);
 
 	kasan_free_nondeferred_pages(page, order);
@@ -1207,7 +1200,7 @@ static bool free_pcp_prepare(struct page
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return free_pages_check(page);
 	else
 		return false;
@@ -1221,7 +1214,7 @@ static bool bulkfree_pcp_prepare(struct
  */
 static bool free_pcp_prepare(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return free_pages_prepare(page, 0, true);
 	else
 		return free_pages_prepare(page, 0, false);
@@ -1973,10 +1966,6 @@ void __init page_alloc_init_late(void)
 
 	for_each_populated_zone(zone)
 		set_zone_contiguous(zone);
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	init_debug_guardpage();
-#endif
 }
 
 #ifdef CONFIG_CMA
@@ -2106,7 +2095,7 @@ static inline bool free_pages_prezeroed(
  */
 static inline bool check_pcp_refill(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2128,7 +2117,7 @@ static inline bool check_pcp_refill(stru
 }
 static inline bool check_new_pcp(struct page *page)
 {
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		return check_new_page(page);
 	else
 		return false;
@@ -2155,7 +2144,7 @@ inline void post_alloc_hook(struct page
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
