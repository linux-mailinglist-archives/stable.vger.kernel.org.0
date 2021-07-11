Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE53C3D1A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhGKN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhGKN5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 09:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884ED60FF2;
        Sun, 11 Jul 2021 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626011667;
        bh=bqnrPlk8TpSF1/EAuSvfcXQfbnmx7uWmVDQtY+LmaSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUWdWELQFAjuOlhsOGpCh1eEQ/HbJEBhA+VPr9qpm6Bpz/aSjMgdmnU4cSBBuXA0Q
         lgnKT5g4zIvfjLrqR26S+dtFk7joTPj2vMGh0IGuVNGmnSbjthU4khrbiOql8PJ76/
         FbrSCmr0wrrqb9JyLZ8j8RU88WDHdXBP3scRrO3mn8bhwy0KfPk4FTYrvmokCPABTd
         785aXy++7ErCmKS2QljxC3XNbzekBc4sdGFRAafKfDVjVeBLGTZzEgt1M+XaFtYmmU
         IL+R0Bl9e3SKfsOsvPkcY6zAsIOyh7GW0VVw/HyYmLRANiVSt3lojN0TgADmYLaVr7
         rOLxIgQJcC+1w==
Date:   Sun, 11 Jul 2021 16:54:20 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        david@redhat.com, robert.shteynfeld@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc: fix memory map
 initialization for descending" failed to apply to 5.10-stable tree
Message-ID: <YOr4DMQITU8yzBNT@kernel.org>
References: <162600462725547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162600462725547@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Jul 11, 2021 at 01:57:07PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The version below applies to v5.10.49.

From a35538b0ab7d396367a8d0c9fefdadffd05a65e5 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Mon, 28 Jun 2021 19:33:26 -0700
Subject: [PATCH] mm/page_alloc: fix memory map initialization for descending nodes

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

The wrong initialization of the memory map causes panic on boot when
CONFIG_DEBUG_VM is enabled.

Reorder loop order of the memory map initialization so that the outer loop
will always iterate over populated memory regions in the ascending order
and the inner loop will select the zone corresponding to the PFN range.

This way initialization of the struct pages for the memory holes will be
always done for the ranges that are actually not populated.

[akpm@linux-foundation.org: coding style fixes]

Link: https://lkml.kernel.org/r/YNXlMqBbL+tBG7yq@kernel.org
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c | 100 +++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 40 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 81cc7fdc9c8f..e72153797203 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6129,7 +6129,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		return;
 
 	/*
-	 * The call to memmap_init_zone should have already taken care
+	 * The call to memmap_init should have already taken care
 	 * of the pages reserved for the memmap, so we can just jump to
 	 * the end of that region and start processing the device pages.
 	 */
@@ -6194,7 +6194,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
- * memmap_init_zone().
+ * memmap_init_zone_range().
  *
  * But, there could be struct pages that correspond to holes in
  * memblock.memory. This can happen because of the following reasons:
@@ -6213,9 +6213,9 @@ static void __meminit zone_init_free_lists(struct zone *zone)
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
@@ -6231,58 +6231,77 @@ static u64 __meminit init_unavailable_range(unsigned long spfn,
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
 
-void __meminit __weak memmap_init(unsigned long size, int nid,
-				  unsigned long zone,
-				  unsigned long range_start_pfn)
+static void __init memmap_init_zone_range(struct zone *zone,
+					  unsigned long start_pfn,
+					  unsigned long end_pfn,
+					  unsigned long *hole_pfn)
+{
+	unsigned long zone_start_pfn = zone->zone_start_pfn;
+	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
+	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+
+	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
+	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
+
+	if (start_pfn >= end_pfn)
+		return;
+
+	memmap_init_zone(end_pfn - start_pfn, nid, zone_id, start_pfn,
+			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+
+	if (*hole_pfn < start_pfn)
+		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+
+	*hole_pfn = end_pfn;
+}
+
+void __init __weak memmap_init(void)
 {
-	static unsigned long hole_pfn;
 	unsigned long start_pfn, end_pfn;
-	unsigned long range_end_pfn = range_start_pfn + size;
-	int i;
-	u64 pgcnt = 0;
+	unsigned long hole_pfn = 0;
+	int i, j, zone_id, nid;
 
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
-		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
-		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		struct pglist_data *node = NODE_DATA(nid);
 
-		if (end_pfn > start_pfn) {
-			size = end_pfn - start_pfn;
-			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
-					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
-		}
+		for (j = 0; j < MAX_NR_ZONES; j++) {
+			struct zone *zone = node->node_zones + j;
 
-		if (hole_pfn < start_pfn)
-			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
-							zone, nid);
-		hole_pfn = end_pfn;
+			if (!populated_zone(zone))
+				continue;
+
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
+	 * for FLATMEM it is a nop anyway
 	 */
-	end_pfn = round_up(range_end_pfn, PAGES_PER_SECTION);
+	end_pfn = round_up(end_pfn, PAGES_PER_SECTION);
 	if (hole_pfn < end_pfn)
-		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
-						zone, nid);
 #endif
-
-	if (pgcnt)
-		pr_info("  %s zone: %llu pages in unavailable ranges\n",
-			zone_names[zone], pgcnt);
+		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -6981,7 +7000,6 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
-		memmap_init(size, nid, j, zone_start_pfn);
 	}
 }
 
@@ -7507,6 +7525,8 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 			node_set_state(nid, N_MEMORY);
 		check_for_memory(pgdat, nid);
 	}
+
+	memmap_init();
 }
 
 static int __init cmdline_parse_core(char *p, unsigned long *core,
-- 
2.28.0

 

-- 
Sincerely yours,
Mike.
