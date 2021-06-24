Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E023B38EC
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 23:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFXVth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 17:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhFXVtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 17:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB9C261220;
        Thu, 24 Jun 2021 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624571237;
        bh=ORqjvg4I6gXUJtG4gF5UNN6gZzLUDUNdNAKPuTfFUcU=;
        h=Date:From:To:Subject:From;
        b=PkALyt92c3xEY4o6P8Z71Zc+MuCfszNcWSCRyEuyoO0nidYZfw4kvr99p0ogn9jTR
         IQK6qeOMmfM7d+X/zh+Dvr801No8kfozlwPqewLZgGegC9T6y7aD8pv//Unhpylx4p
         Sf7ymwsMA2PJaG3SLz8LNVeW4JH8oc/9n3ylqx58=
Date:   Thu, 24 Jun 2021 14:47:16 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, bp@alien8.de, david@redhat.com,
        mm-commits@vger.kernel.org, robert.shteynfeld@gmail.com,
        rppt@linux.ibm.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch
 added to -mm tree
Message-ID: <20210624214716.HW1S12PSD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix memory map initialization for descending nodes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/page_alloc: fix memory map initialization for descending nodes

On systems with memory nodes sorted in descending order, for instance Dell
Precision WorkStation T5500, the struct pages for higher PFNs and
respectively lower nodes, could be overwritten by the initialization of
struct pages corresponding to the holes in the memory sections.

For example for the below memory layout

[    0.245624] Early memory node ranges
[    0.248496]   node   1: [mem 0x0000000000001000-0x0000000000090fff]
[    0.251376]   node   1: [mem 0x0000000000100000-0x00000000dbdf8fff]
[    0.254256]   node   1: [mem 0x0000000100000000-0x0000001423ffffff]
[    0.257144]   node   0: [mem 0x0000001424000000-0x0000002023ffffff]

the range 0x1424000000 - 0x1428000000 in the beginning of node 0 starts in
the middle of a section and will be considered as a hole during the
initialization of the last section in node 1.

This results in a kernel panic in early boot.

Reorder order of the memory map initialization so that the outer loop will
always iterate over populated memory regions in the ascending order and
the inner loop will select the zone corresponding to the PFN range.

This way initialization of the struct pages for the memory holes will be
always done for the ranges that are actually not populated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213073
Link: https://lkml.kernel.org/r/20210624062305.10940-1-rppt@kernel.org
Fixes: 0740a50b9baa ("mm/page_alloc.c: refactor initialization of struct page for holes in memory layout")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Boris Petkov <bp@alien8.de>
Cc: Robert Shteynfeld <robert.shteynfeld@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/page_alloc.c    |   96 ++++++++++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 38 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-fix-memory-map-initialization-for-descending-nodes
+++ a/include/linux/mm.h
@@ -2474,7 +2474,6 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_range(unsigned long, int, unsigned long,
 		unsigned long, unsigned long, enum meminit_context,
 		struct vmem_altmap *, int migratetype);
-extern void memmap_init_zone(struct zone *zone);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/mm/page_alloc.c~mm-page_alloc-fix-memory-map-initialization-for-descending-nodes
+++ a/mm/page_alloc.c
@@ -6400,7 +6400,7 @@ void __ref memmap_init_zone_device(struc
 		return;
 
 	/*
-	 * The call to memmap_init_zone should have already taken care
+	 * The call to memmap_init should have already taken care
 	 * of the pages reserved for the memmap, so we can just jump to
 	 * the end of that region and start processing the device pages.
 	 */
@@ -6465,7 +6465,7 @@ static void __meminit zone_init_free_lis
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
- * memmap_init_zone().
+ * memmap_init_zone_range().
  *
  * But, there could be struct pages that correspond to holes in
  * memblock.memory. This can happen because of the following reasons:
@@ -6484,9 +6484,9 @@ static void __meminit zone_init_free_lis
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static u64 __meminit init_unavailable_range(unsigned long spfn,
-					    unsigned long epfn,
-					    int zone, int node)
+static void __init init_unavailable_range(unsigned long spfn,
+					  unsigned long epfn,
+					  int zone, int node)
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
@@ -6502,56 +6502,77 @@ static u64 __meminit init_unavailable_ra
 		pgcnt++;
 	}
 
-	return pgcnt;
+	if (pgcnt)
+		pr_info("On node %d, zone %s: %lld pages in unavailable ranges",
+			node, zone_names[zone], pgcnt);
 }
 #else
-static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
-					 int zone, int node)
+static inline void init_unavailable_range(unsigned long spfn,
+					  unsigned long epfn,
+					  int zone, int node)
 {
-	return 0;
 }
 #endif
 
-void __meminit __weak memmap_init_zone(struct zone *zone)
+static void __init memmap_init_zone_range(struct zone *zone,
+					  unsigned long start_pfn,
+					  unsigned long end_pfn,
+					  unsigned long *hole_pfn)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
-	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
-	static unsigned long hole_pfn;
+	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+
+	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
+	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
+
+	if (start_pfn >= end_pfn)
+		return;
+
+	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
+			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+
+	if (*hole_pfn < start_pfn)
+		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+
+	*hole_pfn = end_pfn;
+}
+
+static void __init memmap_init(void)
+{
 	unsigned long start_pfn, end_pfn;
-	u64 pgcnt = 0;
+	unsigned long hole_pfn = 0;
+	int i, j, zone_id, nid;
 
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
-		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
-		end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		struct pglist_data *node = NODE_DATA(nid);
+
+		for (j = 0; j < MAX_NR_ZONES; j++) {
+			struct zone *zone = node->node_zones + j;
+
+			if (!populated_zone(zone))
+				continue;
 
-		if (end_pfn > start_pfn)
-			memmap_init_range(end_pfn - start_pfn, nid,
-					zone_id, start_pfn, zone_end_pfn,
-					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
-
-		if (hole_pfn < start_pfn)
-			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
-							zone_id, nid);
-		hole_pfn = end_pfn;
+			memmap_init_zone_range(zone, start_pfn, end_pfn,
+					       &hole_pfn);
+			zone_id = j;
+		}
 	}
 
 #ifdef CONFIG_SPARSEMEM
 	/*
-	 * Initialize the hole in the range [zone_end_pfn, section_end].
-	 * If zone boundary falls in the middle of a section, this hole
-	 * will be re-initialized during the call to this function for the
-	 * higher zone.
+	 * Initialize the memory map for hole in the range [memory_end,
+	 * section_end].
+	 * Append the pages in this hole to the highest zone in the last
+	 * node.
+	 * The call to init_unavailable_range() is outside the ifdef to
+	 * silence the compiler warining about zone_id set but not used;
+	 * for FLATMEM it is is nop anyway
 	 */
-	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
+	end_pfn = round_up(end_pfn, PAGES_PER_SECTION);
 	if (hole_pfn < end_pfn)
-		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
-						zone_id, nid);
 #endif
-
-	if (pgcnt)
-		pr_info("  %s zone: %llu pages in unavailable ranges\n",
-			zone->name, pgcnt);
+		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -7254,7 +7275,6 @@ static void __init free_area_init_core(s
 		set_pageblock_order();
 		setup_usemap(zone);
 		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
-		memmap_init_zone(zone);
 	}
 }
 
@@ -7780,6 +7800,8 @@ void __init free_area_init(unsigned long
 			node_set_state(nid, N_MEMORY);
 		check_for_memory(pgdat, nid);
 	}
+
+	memmap_init();
 }
 
 static int __init cmdline_parse_core(char *p, unsigned long *core,
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-page_alloc-fix-memory-map-initialization-for-descending-nodes.patch
mm-mmzoneh-simplify-is_highmem_idx.patch
alpha-remove-discontigmem-and-numa.patch
arc-update-comment-about-highmem-implementation.patch
arc-remove-support-for-discontigmem.patch
m68k-remove-support-for-discontigmem.patch
mm-remove-config_discontigmem.patch
arch-mm-remove-stale-mentions-of-disconigmem.patch
docs-remove-description-of-discontigmem.patch
mm-replace-config_need_multiple_nodes-with-config_numa.patch
mm-replace-config_need_multiple_nodes-with-config_numa-fix.patch
mm-replace-config_flat_node_mem_map-with-config_flatmem.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

