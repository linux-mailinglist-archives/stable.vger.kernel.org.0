Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57B72D4E74
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 00:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgLIXDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 18:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgLIXC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 18:02:58 -0500
Date:   Wed, 09 Dec 2020 15:02:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607554937;
        bh=HXLVpslXNzeKA/8x51/rqCE7y+Di/qtBF2ldrA0mJAI=;
        h=From:To:Subject:From;
        b=c9GicvS/OTiT+BlYVF/YIREhtAMDOWGvKL/8PRc7f4WG0I3N3EpWXIDDavanqsRR3
         nM1qpeSO4KGb/ehuOSynXtlCyrNEliJg9eXPiASoU2/sq6GKAoLhOf3FZbpCjnRasr
         wned7O53I5X94ZgPsJ4SS8NeiE36tWdOmGvzG3KQ=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        rppt@linux.ibm.com, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, cai@lca.pw, bhe@redhat.com, aarcange@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-initialize-struct-pages-in-reserved-regions-outside-of-t?=
 =?us-ascii?Q?he-zone-ranges.patch?= removed from -mm tree
Message-ID: <20201209230215.uF4T7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
has been removed from the -mm tree.  Its filename was
     mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: initialize struct pages in reserved regions outside of the zone ranges

Without this change, the pfn 0 isn't in any zone spanned range, and it's
also not in any memory.memblock range, so the struct page of pfn 0 wasn't
initialized and the PagePoison remained set when reserve_bootmem_region
called __SetPageReserved, inducing a silent boot failure with DEBUG_VM
(and correctly so, because the crash signaled the nodeid/nid of pfn 0
would be again wrong).

There's no enforcement that all memblock.reserved ranges must overlap
memblock.memory ranges, so the memblock.reserved ranges also require an
explicit initialization and the zones ranges need to be extended to
include all memblock.reserved ranges with struct pages too or they'll be
left uninitialized with PagePoison as it happened to pfn 0.

Link: https://lkml.kernel.org/r/20201205013238.21663-2-aarcange@redhat.com
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   17 ++++++++---
 mm/debug.c               |    3 +
 mm/memblock.c            |    4 +-
 mm/page_alloc.c          |   57 +++++++++++++++++++++++++++++--------
 4 files changed, 63 insertions(+), 18 deletions(-)

--- a/include/linux/memblock.h~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
+++ a/include/linux/memblock.h
@@ -251,7 +251,8 @@ static inline bool memblock_is_nomap(str
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
-			  unsigned long *out_end_pfn, int *out_nid);
+			  unsigned long *out_end_pfn, int *out_nid,
+			  struct memblock_type *type);
 
 /**
  * for_each_mem_pfn_range - early memory pfn range iterator
@@ -263,9 +264,17 @@ void __next_mem_pfn_range(int *idx, int
  *
  * Walks over configured memory ranges.
  */
-#define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
-	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
-	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
+#define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		  \
+	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid, \
+					  &memblock.memory);		  \
+	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid, \
+					  &memblock.memory))
+
+#define for_each_res_pfn_range(i, nid, p_start, p_end, p_nid)		  \
+	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid, \
+					  &memblock.reserved);		  \
+	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid, \
+					  &memblock.reserved))
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
--- a/mm/debug.c~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
+++ a/mm/debug.c
@@ -64,7 +64,8 @@ void __dump_page(struct page *page, cons
 	 * dump_page() when detected.
 	 */
 	if (page_poisoned) {
-		pr_warn("page:%px is uninitialized and poisoned", page);
+		pr_warn("page:%px pfn:%ld is uninitialized and poisoned",
+			page, page_to_pfn(page));
 		goto hex_only;
 	}
 
--- a/mm/memblock.c~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
+++ a/mm/memblock.c
@@ -1198,9 +1198,9 @@ void __init_memblock __next_mem_range_re
  */
 void __init_memblock __next_mem_pfn_range(int *idx, int nid,
 				unsigned long *out_start_pfn,
-				unsigned long *out_end_pfn, int *out_nid)
+				unsigned long *out_end_pfn, int *out_nid,
+				struct memblock_type *type)
 {
-	struct memblock_type *type = &memblock.memory;
 	struct memblock_region *r;
 	int r_nid;
 
--- a/mm/page_alloc.c~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
+++ a/mm/page_alloc.c
@@ -1458,6 +1458,7 @@ static void __meminit init_reserved_page
 {
 	pg_data_t *pgdat;
 	int nid, zid;
+	bool found = false;
 
 	if (!early_page_uninitialised(pfn))
 		return;
@@ -1468,10 +1469,15 @@ static void __meminit init_reserved_page
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 		struct zone *zone = &pgdat->node_zones[zid];
 
-		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
+		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone)) {
+			found = true;
 			break;
+		}
 	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+	if (likely(found))
+		__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+	else
+		WARN_ON_ONCE(1);
 }
 #else
 static inline void init_reserved_page(unsigned long pfn)
@@ -6227,7 +6233,7 @@ void __init __weak memmap_init(unsigned
 			       unsigned long zone,
 			       unsigned long range_start_pfn)
 {
-	unsigned long start_pfn, end_pfn, next_pfn = 0;
+	unsigned long start_pfn, end_pfn, prev_pfn = 0;
 	unsigned long range_end_pfn = range_start_pfn + size;
 	u64 pgcnt = 0;
 	int i;
@@ -6235,7 +6241,7 @@ void __init __weak memmap_init(unsigned
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
 		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
-		next_pfn = clamp(next_pfn, range_start_pfn, range_end_pfn);
+		prev_pfn = clamp(prev_pfn, range_start_pfn, range_end_pfn);
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
@@ -6243,10 +6249,10 @@ void __init __weak memmap_init(unsigned
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 
-		if (next_pfn < start_pfn)
-			pgcnt += init_unavailable_range(next_pfn, start_pfn,
+		if (prev_pfn < start_pfn)
+			pgcnt += init_unavailable_range(prev_pfn, start_pfn,
 							zone, nid);
-		next_pfn = end_pfn;
+		prev_pfn = end_pfn;
 	}
 
 	/*
@@ -6256,12 +6262,31 @@ void __init __weak memmap_init(unsigned
 	 * considered initialized. Make sure that memmap has a well defined
 	 * state.
 	 */
-	if (next_pfn < range_end_pfn)
-		pgcnt += init_unavailable_range(next_pfn, range_end_pfn,
+	if (prev_pfn < range_end_pfn)
+		pgcnt += init_unavailable_range(prev_pfn, range_end_pfn,
 						zone, nid);
 
+	/*
+	 * memblock.reserved isn't enforced to overlap with
+	 * memblock.memory so initialize the struct pages for
+	 * memblock.reserved too in case it wasn't overlapping.
+	 *
+	 * If any struct page associated with a memblock.reserved
+	 * range isn't overlapping with a zone range, it'll be left
+	 * uninitialized, ideally with PagePoison, and it'll be a more
+	 * easily detectable error.
+	 */
+	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
+		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+
+		if (end_pfn > start_pfn)
+			pgcnt += init_unavailable_range(start_pfn, end_pfn,
+							zone, nid);
+	}
+
 	if (pgcnt)
-		pr_info("%s: Zeroed struct page in unavailable ranges: %lld\n",
+		pr_info("%s: pages in unavailable ranges: %lld\n",
 			zone_names[zone], pgcnt);
 }
 
@@ -6499,6 +6524,10 @@ void __init get_pfn_range_for_nid(unsign
 		*start_pfn = min(*start_pfn, this_start_pfn);
 		*end_pfn = max(*end_pfn, this_end_pfn);
 	}
+	for_each_res_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
+		*start_pfn = min(*start_pfn, this_start_pfn);
+		*end_pfn = max(*end_pfn, this_end_pfn);
+	}
 
 	if (*start_pfn == -1UL)
 		*start_pfn = 0;
@@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
  */
 unsigned long __init find_min_pfn_with_active_regions(void)
 {
-	return PHYS_PFN(memblock_start_of_DRAM());
+	/*
+	 * reserved regions must be included so that their page
+	 * structure can be part of a zone and obtain a valid zoneid
+	 * before __SetPageReserved().
+	 */
+	return min(PHYS_PFN(memblock_start_of_DRAM()),
+		   PHYS_PFN(memblock.reserved.regions[0].base));
 }
 
 /*
_

Patches currently in -mm which might be from aarcange@redhat.com are


