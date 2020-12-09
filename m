Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CAF2D4D0F
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 22:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388188AbgLIVoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 16:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388024AbgLIVoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 16:44:01 -0500
From:   Mike Rapoport <rppt@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm: fix initialization of struct page for holes in memory layout
Date:   Wed,  9 Dec 2020 23:43:04 +0200
Message-Id: <20201209214304.6812-3-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201209214304.6812-1-rppt@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
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
that iterated through PFNs in holes in memblock.memory and if there is a
struct page corresponding to a PFN, the fields if this page are set to
default values and it is marked as Reserved.

init_unavailable_mem() does not take into account zone and node the page
belongs to and sets both zone and node links in struct page to zero.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link in
struct page) in the same pageblock.

Interleave initialization of pages that correspond to holes with the
initialization of memory map, so that zone and node information will be
properly set on such pages.

Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
that check each PFN")
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 mm/page_alloc.c | 152 +++++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 87 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dbc57dbbacd8..ea5aefef0004 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6185,24 +6185,85 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	}
 }
 
-void __meminit __weak memmap_init(unsigned long size, int nid,
-				  unsigned long zone,
-				  unsigned long range_start_pfn)
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+/*
+ * Only struct pages that are backed by physical memory available to the
+ * kernel are zeroed and initialized by memmap_init_zone().
+ * But, there are some struct pages that are either reserved by firmware or
+ * do not correspond to physical page frames becuase the actual memory bank
+ * is not a multiple of SECTION_SIZE.
+ * Fields of those struct pages may be accessed (for example page_to_pfn()
+ * on some configuration accesses page flags) so we must explicitly
+ * initialize those struct pages.
+ */
+static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int node)
 {
-	unsigned long start_pfn, end_pfn;
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
+void __init __weak memmap_init(unsigned long size, int nid,
+			       unsigned long zone,
+			       unsigned long range_start_pfn)
+{
+	unsigned long start_pfn, end_pfn, hole_start_pfn = 0;
 	unsigned long range_end_pfn = range_start_pfn + size;
+	u64 pgcnt = 0;
 	int i;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
 		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+		hole_start_pfn = clamp(hole_start_pfn, range_start_pfn,
+				       range_end_pfn);
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
+
+		if (hole_start_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_start_pfn,
+							start_pfn, zone, nid);
+		hole_start_pfn = end_pfn;
 	}
+
+	/*
+	 * Early sections always have a fully populated memmap for the whole
+	 * section - see pfn_valid(). If the last section has holes at the
+	 * end and that section is marked "online", the memmap will be
+	 * considered initialized. Make sure that memmap has a well defined
+	 * state.
+	 */
+	if (hole_start_pfn < range_end_pfn)
+		pgcnt += init_unavailable_range(hole_start_pfn, range_end_pfn,
+						zone, nid);
+
+	if (pgcnt)
+		pr_info("%s: Zeroed struct page in unavailable ranges: %lld\n",
+			zone_names[zone], pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -6995,88 +7056,6 @@ void __init free_area_init_memoryless_node(int nid)
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
@@ -7507,7 +7486,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
-- 
2.28.0

