Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CC12F2526
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbhALAyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhALAyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 19:54:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67E4225AB;
        Tue, 12 Jan 2021 00:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610412849;
        bh=vO++9mXr13+yri+4o7B0YqLbYY9C0/4+AgWHtCXEHiE=;
        h=Date:From:To:Subject:From;
        b=YiI3gOlVZEmx5TxpRqB49rDGY24ImyF4ocuSJYGBsRPhHF/zZDz6W8Fm1trkJtq0M
         FAvMyEV5eCt+MsWT4Unprrmjg+ZsLOSf6kEJMZbzw7x0cXGHAK97aGae1Tprt8eMK9
         R4F4SIBVpQSMqKRAyq/JJN+g3YIc1tyK5Ya2n2lA=
Date:   Mon, 11 Jan 2021 16:54:08 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
 removed from -mm tree
Message-ID: <20210112005408.nq5lKQhCa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix initialization of struct page for holes in memory layout
has been removed from the -mm tree.  Its filename was
     mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: fix initialization of struct page for holes in memory layout

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

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/20201209214304.6812-3-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  152 +++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 87 deletions(-)

--- a/mm/page_alloc.c~mm-fix-initialization-of-struct-page-for-holes-in-memory-layout
+++ a/mm/page_alloc.c
@@ -6254,24 +6254,85 @@ static void __meminit zone_init_free_lis
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
+ * do not correspond to physical page frames because the actual memory bank
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
 			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
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
@@ -7072,88 +7133,6 @@ void __init free_area_init_memoryless_no
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
@@ -7584,7 +7563,6 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

