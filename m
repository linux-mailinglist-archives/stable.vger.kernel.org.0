Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7D33BC87
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhCOO0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhCOOZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:25:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FE965091;
        Mon, 15 Mar 2021 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818312;
        bh=cbIzL6B9gOdilNMP1qovJWgMFi+1qLqXCx39xn+hbzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdqRGSA2i6D+2auBTS/2ESBZ4X/1ZY6h7E+3c+snz93qV6iKcwYoJ7SNNfzQ1BKIr
         iHluYjUOugfPNQH/IopF+TgzkeElRi2l+oFyPWr1vhAmcBnUHBnGABXj29y7oirTbP
         UfMjir6Wfg2E+I5RqSWQUVH5jWdPprP8BqKSxoqU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?=C5=81ukasz=20Majczak?= <lma@semihalf.com>,
        Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@kernel.org>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 305/306] mm/page_alloc.c: refactor initialization of struct page for holes in memory layout
Date:   Mon, 15 Mar 2021 15:24:30 +0100
Message-Id: <20210315135518.007943444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Mike Rapoport <rppt@linux.ibm.com>

commit 0740a50b9baa4472cfb12442df4b39e2712a64a4 upstream.

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

Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock
regions rather that check each PFN") the holes inside a zone were
re-initialized during memmap_init() and got their zone/node links right.
However, after that commit nothing updates the struct pages representing
such holes.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

in set_pfnblock_flags_mask() when called with a struct page from a range
other than E820_TYPE_RAM because there are pages in the range of
ZONE_DMA32 but the unset zone link in struct page makes them appear as a
part of ZONE_DMA.

Interleave initialization of the unavailable pages with the normal
initialization of memory map, so that zone and node information will be
properly set on struct pages that are not backed by the actual memory.

With this change the pages for holes inside a zone will get proper
zone/node links and the pages that are not spanned by any node will get
links to the adjacent zone/node.  The holes between nodes will be
prepended to the zone/node above the hole and the trailing pages in the
last section that will be appended to the zone/node below.

[akpm@linux-foundation.org: don't initialize static to zero, use %llu for u64]

Link: https://lkml.kernel.org/r/20210225224351.7356-2-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Łukasz Majczak <lma@semihalf.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |  158 ++++++++++++++++++++++++++------------------------------
 1 file changed, 75 insertions(+), 83 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6262,13 +6262,66 @@ static void __meminit zone_init_free_lis
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
+ * - physical memory bank size is not necessarily the exact multiple of the
+ *   arbitrary section size
+ * - early reserved memory may not be listed in memblock.memory
+ * - memory layouts defined with memmap= kernel parameter may not align
+ *   nicely with memmap sections
+ *
+ * Explicitly initialize those struct pages so that:
+ * - PG_Reserved is set
+ * - zone and node links point to zone and node that span the page if the
+ *   hole is in the middle of a zone
+ * - zone and node links point to adjacent zone/node if the hole falls on
+ *   the zone boundary; the pages in such holes will be prepended to the
+ *   zone/node above the hole except for the trailing pages in the last
+ *   section that will be appended to the zone/node below.
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
 void __meminit __weak memmap_init(unsigned long size, int nid,
 				  unsigned long zone,
 				  unsigned long range_start_pfn)
 {
+	static unsigned long hole_pfn;
 	unsigned long start_pfn, end_pfn;
 	unsigned long range_end_pfn = range_start_pfn + size;
 	int i;
+	u64 pgcnt = 0;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
@@ -6279,7 +6332,29 @@ void __meminit __weak memmap_init(unsign
 			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
+
+		if (hole_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
+							zone, nid);
+		hole_pfn = end_pfn;
 	}
+
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * Initialize the hole in the range [zone_end_pfn, section_end].
+	 * If zone boundary falls in the middle of a section, this hole
+	 * will be re-initialized during the call to this function for the
+	 * higher zone.
+	 */
+	end_pfn = round_up(range_end_pfn, PAGES_PER_SECTION);
+	if (hole_pfn < end_pfn)
+		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
+						zone, nid);
+#endif
+
+	if (pgcnt)
+		pr_info("  %s zone: %llu pages in unavailable ranges\n",
+			zone_names[zone], pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -7080,88 +7155,6 @@ void __init free_area_init_memoryless_no
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
@@ -7585,7 +7578,6 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);


