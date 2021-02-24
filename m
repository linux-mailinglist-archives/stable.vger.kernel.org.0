Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D0D324183
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhBXP73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 10:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233192AbhBXPlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 10:41:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE7B64EFC;
        Wed, 24 Feb 2021 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614181219;
        bh=M9c2R5GuM+TZLKaR1t08J+4DTl0WksAIAlVHE7TNc48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDs81muDOMzC0iog4+Ed2LDpbRa3UHSuqagL5k3/4pH5eLmw7K/wWlMM+s/Wlh3tc
         GA33/kAF/zJj+n7z0I4do+Rf+VAyOgg0VlcXvwlDSt2xwS1jvj1IT9GP7eW94JALug
         VUIfkEnd55vzR2J64PLhoRK11s/2Y38IxByzsyzDwkele/sjLBLo5POIjvGacx9XeC
         ZiKONUU7YfEXKn5XJdIkPhcUpYJcgYGzZyMEx3+Z85zHRhXqjWR3lTQzs9DW5ECTZp
         TSyD9AmdteMRcz5x+0uuXI5gwLW6FVXqbp7kafRzrwcfBZoECitRwszZB/ASdAEiaD
         hDJ4riniU8YwA==
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?=C5=81ukasz=20Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of struct page for holes in memory layout
Date:   Wed, 24 Feb 2021 17:39:50 +0200
Message-Id: <20210224153950.20789-2-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210224153950.20789-1-rppt@kernel.org>
References: <20210224153950.20789-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

There could be struct pages that are not backed by actual physical memory.
This can happen when the actual memory bank is not a multiple of
SECTION_SIZE or when an architecture does not register memory holes
reserved by the firmware as memblock.memory.

Such pages are currently initialized using init_unavailable_mem() function
that iterates through PFNs in holes in memblock.memory and if there is a
struct page corresponding to a PFN, the fields of this page are set to
default values and it is marked as Reserved.

init_unavailable_mem() does not take into account zone and node the page
belongs to and sets both zone and node links in struct page to zero.

Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
rather that check each PFN") the holes inside a zone were re-initialized
during memmap_init() and got their zone/node links right. However, after
that commit nothing updates the struct pages representing such holes.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
in struct page) in the same pageblock.

Interleave initialization of the unavailable pages with the normal
initialization of memory map, so that zone and node information will be
properly set on struct pages that are not backed by the actual memory.

With this change the pages for holes inside a zone will get proper
zone/node links and the pages that are not spanned by any node will get
links to the adjacent zone/node.

Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
---
 mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 83 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e93f8b29bae..a11a9acde708 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6280,12 +6280,60 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	}
 }
 
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+/*
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init_zone().
+ *
+ * But, there could be struct pages that correspond to holes in
+ * memblock.memory. This can happen because of the following reasons:
+ * - phyiscal memory bank size is not necessarily the exact multiple of the
+ *   arbitrary section size
+ * - early reserved memory may not be listed in memblock.memory
+ * - memory layouts defined with memmap= kernel parameter may not align
+ *   nicely with memmap sections
+ *
+ * Explicitly initialize those struct pages so that:
+ * - PG_Reserved is set
+ * - zone and node links point to zone and node that span the page
+ */
+static u64 __meminit init_unavailable_range(unsigned long spfn,
+					    unsigned long epfn,
+					    int zone, int node)
+{
+	unsigned long pfn;
+	u64 pgcnt = 0;
+
+	for (pfn = spfn; pfn < epfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
+			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
+				+ pageblock_nr_pages - 1;
+			continue;
+		}
+		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
+		__SetPageReserved(pfn_to_page(pfn));
+		pgcnt++;
+	}
+
+	return pgcnt;
+}
+#else
+static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int node)
+{
+	return 0;
+}
+#endif
+
 void __meminit __weak memmap_init_zone(struct zone *zone)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+	static unsigned long hole_pfn = 0;
 	unsigned long start_pfn, end_pfn;
+	u64 pgcnt = 0;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
@@ -6295,7 +6343,23 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
 			memmap_init_range(end_pfn - start_pfn, nid,
 					zone_id, start_pfn, zone_end_pfn,
 					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+
+		if (hole_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
+							zone_id, nid);
+		hole_pfn = end_pfn;
 	}
+
+#ifdef CONFIG_SPARSEMEM
+	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
+	if (hole_pfn < end_pfn)
+		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
+						zone_id, nid);
+#endif
+
+	if (pgcnt)
+		pr_info("  %s zone: %lld pages in unavailable ranges\n",
+			zone->name, pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -7092,88 +7156,6 @@ void __init free_area_init_memoryless_node(int nid)
 	free_area_init_node(nid);
 }
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
-/*
- * Initialize all valid struct pages in the range [spfn, epfn) and mark them
- * PageReserved(). Return the number of struct pages that were initialized.
- */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
-{
-	unsigned long pfn;
-	u64 pgcnt = 0;
-
-	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
-				+ pageblock_nr_pages - 1;
-			continue;
-		}
-		/*
-		 * Use a fake node/zone (0) for now. Some of these pages
-		 * (in memblock.reserved but not in memblock.memory) will
-		 * get re-initialized via reserve_bootmem_region() later.
-		 */
-		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
-		__SetPageReserved(pfn_to_page(pfn));
-		pgcnt++;
-	}
-
-	return pgcnt;
-}
-
-/*
- * Only struct pages that are backed by physical memory are zeroed and
- * initialized by going through __init_single_page(). But, there are some
- * struct pages which are reserved in memblock allocator and their fields
- * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly initialize those struct pages.
- *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=, or when the highest physical
- * address (max_pfn) does not end on a section boundary.
- */
-static void __init init_unavailable_mem(void)
-{
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next = 0;
-
-	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
-	 */
-	pgcnt = 0;
-	for_each_mem_range(i, &start, &end) {
-		if (next < start)
-			pgcnt += init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
-		next = end;
-	}
-
-	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
-	 */
-	pgcnt += init_unavailable_range(PFN_DOWN(next),
-					round_up(max_pfn, PAGES_PER_SECTION));
-
-	/*
-	 * Struct pages that do not have backing memory. This could be because
-	 * firmware is using some of this memory, or for some other reasons.
-	 */
-	if (pgcnt)
-		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
-}
-#else
-static inline void __init init_unavailable_mem(void)
-{
-}
-#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
-
 #if MAX_NUMNODES > 1
 /*
  * Figure out the number of possible node ids.
@@ -7597,7 +7579,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
-- 
2.28.0

