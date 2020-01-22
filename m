Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BCA145616
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAVNUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbgAVNUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:33 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2A02467A;
        Wed, 22 Jan 2020 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699233;
        bh=utNVuAMCxW6oVVh79DaUgx79g7Q4A4WySSe8B60SzRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aj6SS2xKL7vxZNGqeIaNyyasj1gCpCazQFiPlqVgVg1IVzb/Q0rz4wBCliifSKIgk
         8bgsE15NT5MPiG9HfGO28zE203riRPaoYsLie9QTYls0p6CTbSkgr6AdIHOFx/SyTM
         MujpUNR/kjs0etygp4q/G2kFKCGWKkzW9pI1j9qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 082/222] mm, debug_pagealloc: dont rely on static keys too early
Date:   Wed, 22 Jan 2020 10:27:48 +0100
Message-Id: <20200122092839.582654920@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 8e57f8acbbd121ecfb0c9dc13b8b030f86c6bd3b upstream.

Commit 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable
debugging") has introduced a static key to reduce overhead when
debug_pagealloc is compiled in but not enabled.  It relied on the
assumption that jump_label_init() is called before parse_early_param()
as in start_kernel(), so when the "debug_pagealloc=on" option is parsed,
it is safe to enable the static key.

However, it turns out multiple architectures call parse_early_param()
earlier from their setup_arch().  x86 also calls jump_label_init() even
earlier, so no issue was found while testing the commit, but same is not
true for e.g.  ppc64 and s390 where the kernel would not boot with
debug_pagealloc=on as found by our QA.

To fix this without tricky changes to init code of multiple
architectures, this patch partially reverts the static key conversion
from 96a2b03f281d.  Init-time and non-fastpath calls (such as in arch
code) of debug_pagealloc_enabled() will again test a simple bool
variable.  Fastpath mm code is converted to a new
debug_pagealloc_enabled_static() variant that relies on the static key,
which is enabled in a well-defined point in mm_init() where it's
guaranteed that jump_label_init() has been called, regardless of
architecture.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mm.h |   18 +++++++++++++++---
 init/main.c        |    1 +
 mm/page_alloc.c    |   37 +++++++++++++------------------------
 mm/slab.c          |    4 ++--
 mm/slub.c          |    2 +-
 mm/vmalloc.c       |    4 ++--
 6 files changed, 34 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2666,14 +2666,26 @@ static inline bool want_init_on_free(voi
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
 
--- a/init/main.c
+++ b/init/main.c
@@ -553,6 +553,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	init_debug_pagealloc();
 	report_meminit();
 	mem_init();
 	kmem_cache_init();
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
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
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1415,7 +1415,7 @@ static void kmem_rcu_free(struct rcu_hea
 #if DEBUG
 static bool is_debug_pagealloc_cache(struct kmem_cache *cachep)
 {
-	if (debug_pagealloc_enabled() && OFF_SLAB(cachep) &&
+	if (debug_pagealloc_enabled_static() && OFF_SLAB(cachep) &&
 		(cachep->size % PAGE_SIZE) == 0)
 		return true;
 
@@ -2007,7 +2007,7 @@ int __kmem_cache_create(struct kmem_cach
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
+	if (debug_pagealloc_enabled_static() && (flags & SLAB_POISON) &&
 		size >= 256 && cachep->object_size > cache_line_size()) {
 		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
 			size_t tmp_size = ALIGN(size, PAGE_SIZE);
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -290,7 +290,7 @@ static inline void *get_freepointer_safe
 	unsigned long freepointer_addr;
 	void *p;
 
-	if (!debug_pagealloc_enabled())
+	if (!debug_pagealloc_enabled_static())
 		return get_freepointer(s, object);
 
 	freepointer_addr = (unsigned long)object + s->offset;
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1349,7 +1349,7 @@ static void free_unmap_vmap_area(struct
 {
 	flush_cache_vunmap(va->va_start, va->va_end);
 	unmap_vmap_area(va);
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(va->va_start, va->va_end);
 
 	free_vmap_area_noflush(va);
@@ -1647,7 +1647,7 @@ static void vb_free(const void *addr, un
 
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range((unsigned long)addr,
 					(unsigned long)addr + size);
 


