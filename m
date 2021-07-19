Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834893CD811
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbhGSOUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242063AbhGSOTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F32B61003;
        Mon, 19 Jul 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626706812;
        bh=Tt5uBhgXzIaB+C3QWLhUpxAZdG5SkyPJ7d3afc94PZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+eTXrvyHCI7kNhe3T9EGxCSOi9VRS144O5W6UJBNsLJv3V3lNJn4ZWodYplLSYkl
         WuHP8u2F80L3XvcApclRhXhloe2GDuoywQEHhsxH4M/T6grgx6OhcgBNeqYILnDDOJ
         0sPUtOPCyj4/MOrpMf04hKu2iHm9lAu4ehgfb7nHrKE/5MS+3wbT3ow5GVTPGVVqxP
         +97iaeTp4U2IXVbU+3+PAzGi/XHH9hOUvbm0mZgTSxNEAxw1O5pXWikUzTVB/TwVfb
         sR7hnWPfb3J6FKsbXx41WpH+K5tJLzZkDcFsHySVdUwiBCneNaTbFCK+mMbVxjBu/9
         8sqyhm6O1goOg==
Date:   Mon, 19 Jul 2021 18:00:04 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        david@redhat.com, robert.shteynfeld@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc: fix memory map
 initialization for descending" failed to apply to 5.10-stable tree
Message-ID: <YPWTdETYFq+MdlEL@kernel.org>
References: <16264592686170@kroah.com>
 <YPO+i7eeByNMMJiA@kernel.org>
 <YPUWXjzX/wnsUC/h@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPUWXjzX/wnsUC/h@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:06:22AM +0200, Greg KH wrote:
> On Sun, Jul 18, 2021 at 08:39:23AM +0300, Mike Rapoport wrote:
> > Hi,
> > 
> > On Fri, Jul 16, 2021 at 08:14:28PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > I'm confused. I've sent a version that applied cleanly to 5.10.49:
> > 
> > https://lore.kernel.org/stable/YOr4DMQITU8yzBNT@kernel.org
> > 
> > and I've got an email that it was added to the stable tree and the email
> > with the patch for stable preview:
> > 
> > https://lore.kernel.org/lkml/20210715182623.942552790@linuxfoundation.org
> > 
> > Was anything wrong with the patch?
> 
> Yes, it broke the build on ia64 due to duplicated function names :(

The version below takes care of compatibility with ia64 in the least
intrusive way I could think of. 

From ee3a273719e1372a447a91a20c8145cdb1b4792a Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Mon, 28 Jun 2021 19:33:26 -0700
Subject: [PATCH v2] mm/page_alloc: fix memory map initialization for descending nodes

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
[rppt: tweak for compatibility with IA64's override of memmap_init]
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/ia64/include/asm/pgtable.h |   5 +-
 arch/ia64/mm/init.c             |   6 +-
 mm/page_alloc.c                 | 106 ++++++++++++++++++++------------
 3 files changed, 75 insertions(+), 42 deletions(-)

diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
index 779b6972aa84..9f64fdfbf275 100644
--- a/arch/ia64/include/asm/pgtable.h
+++ b/arch/ia64/include/asm/pgtable.h
@@ -520,8 +520,9 @@ extern struct page *zero_page_memmap_ptr;
 
 #  ifdef CONFIG_VIRTUAL_MEM_MAP
   /* arch mem_map init routine is needed due to holes in a virtual mem_map */
-    extern void memmap_init (unsigned long size, int nid, unsigned long zone,
-			     unsigned long start_pfn);
+void memmap_init(void);
+void arch_memmap_init(unsigned long size, int nid, unsigned long zone,
+		      unsigned long start_pfn);
 #  endif /* CONFIG_VIRTUAL_MEM_MAP */
 # endif /* !__ASSEMBLY__ */
 
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 27ca549ff47e..f316a833b703 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -542,7 +542,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
 }
 
 void __meminit
-memmap_init (unsigned long size, int nid, unsigned long zone,
+arch_memmap_init (unsigned long size, int nid, unsigned long zone,
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
@@ -562,6 +562,10 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
 	}
 }
 
+void __init memmap_init(void)
+{
+}
+
 int
 ia64_pfn_valid (unsigned long pfn)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e30d88efd7fb..0166558d3d64 100644
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
@@ -6231,58 +6231,84 @@ static u64 __meminit init_unavailable_range(unsigned long spfn,
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
+
+			if (!populated_zone(zone))
+				continue;
 
-		if (hole_pfn < start_pfn)
-			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
-							zone, nid);
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
+	 * for FLATMEM it is a nop anyway
 	 */
-	end_pfn = round_up(range_end_pfn, PAGES_PER_SECTION);
+	end_pfn = round_up(end_pfn, PAGES_PER_SECTION);
 	if (hole_pfn < end_pfn)
-		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
-						zone, nid);
 #endif
+		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
+}
 
-	if (pgcnt)
-		pr_info("  %s zone: %llu pages in unavailable ranges\n",
-			zone_names[zone], pgcnt);
+/* A stub for backwards compatibility with custom implementatin on IA-64 */
+void __meminit __weak arch_memmap_init(unsigned long size, int nid,
+				       unsigned long zone,
+				       unsigned long range_start_pfn)
+{
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -6981,7 +7007,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
-		memmap_init(size, nid, j, zone_start_pfn);
+		arch_memmap_init(size, nid, j, zone_start_pfn);
 	}
 }
 
@@ -7507,6 +7533,8 @@ void __init free_area_init(unsigned long *max_zone_pfn)
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
