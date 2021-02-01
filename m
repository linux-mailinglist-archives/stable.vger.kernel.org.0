Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C0330B36D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 00:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhBAXXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 18:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhBAXXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 18:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3AAB64EBD;
        Mon,  1 Feb 2021 23:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612221776;
        bh=Jz2sUzt4Uu6tgjnQx6lPWmWk1UfFOIboWw+LZ+LnKSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LmW4yKv6qoQ4brvoDIOPS5OpYqW3264kIMII1H/5UKxjJJDei8bLg4VAVkWbOnYmK
         w9AgV9+ZfKJe7y/QvxXeDf820UvtivGyCTjgJWobft/Cx02G/uATW8mQBd/JZz/wws
         zg9I7gGa4xEkwesY4U7fuzIXig9usKb8Rt52qXotVBb+8Rf0oriK3TfaX68ks8ZRSs
         8qnmWGZi6e/MqJo1NmDdiCNip7tKdmkVSu4ZcJUj+/3Bfstq542aOQg1Z/IS9CSQfw
         HYbzKdXt3BxQ2Zg9Wkzw/45CN7Xb3zKvHGErk/NtifdYar1cpGqmNq1jFG5dgS/LJZ
         65R7vDJf+v7qw==
Date:   Tue, 2 Feb 2021 01:22:43 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <20210201232243.GM242749@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
 <20210201143014.GI242749@kernel.org>
 <759698b8-ac81-de31-4916-023d8dfa9fe5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759698b8-ac81-de31-4916-023d8dfa9fe5@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 03:32:33PM +0100, David Hildenbrand wrote:
> On 01.02.21 15:30, Mike Rapoport wrote:
> > > 
> > > I'd suggest going through all zone ranges in free_area_init() first, dealing
> > > with zones that have "not section aligned start/end", clamping them up/down
> > > if required such that no holes within a section are left uncovered by a
> > > zone.
> > 
> > I thought about changing the way zone extents are calculated so that zone
> > start/end will be always on a section boundary, but zone->zone_start_pfn
> > depends on node->node_start_pfn which is defined by hardware and expanding
> > a node to make its start pfn aligned at the section boundary might violate
> > the HW addressing scheme.
> > 
> > Maybe this could never happen, or maybe it's not really important as the
> > pages there will be reserved anyway, but I'm not sure I can estimate all
> > the implications.
> > 
> 
> I'm suggesting to let zone (+node?) ranges cover memory holes with a valid
> memmap. Not to move actual memory between nodes/zones.

I didn't think you suggest to move actual memory :)

My concern was that extending node range might cause troubles, but TBH, I
cannot think of a memory layout that will be crazy enough to actually get
us into those troubles.

So something like the patch below might work. It'll need nice wrapping and
some comments, but generally it implements your suggestion to extend node's
range to include partial sections, and then interleave initialization of
struct pages representing unpopulated memory with the initialization of the
"real" memory map. Since zone's start/end are derived from node's start/end
we also get zones covering the holes.


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 519a60d5b6f7..179d1eb4a9bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6257,24 +6257,69 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	}
 }
 
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
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
+
 void __meminit __weak memmap_init(unsigned long size, int nid,
 				  unsigned long zone,
 				  unsigned long range_start_pfn)
 {
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn, end_pfn, next_pfn = 0;
 	unsigned long range_end_pfn = range_start_pfn + size;
+	u64 pgcnt = 0;
 	int i;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
 		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+		next_pfn = clamp(next_pfn, range_start_pfn, range_end_pfn);
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
+
+		if (next_pfn < start_pfn)
+			pgcnt += init_unavailable_range(next_pfn, start_pfn,
+							zone, nid);
+		next_pfn = end_pfn;
 	}
+
+	if (next_pfn < range_end_pfn)
+		pgcnt += init_unavailable_range(next_pfn, range_end_pfn,
+						zone, nid);
+
+	if (pgcnt)
+		pr_info("%s: Zeroed struct page in unavailable ranges: %lld\n",
+			zone_names[zone], pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -6523,6 +6568,12 @@ void __init get_pfn_range_for_nid(unsigned int nid,
 
 	if (*start_pfn == -1UL)
 		*start_pfn = 0;
+	else {
+#ifdef CONFIG_SPARSEMEM
+		*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
+		*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
+#endif
+	}
 }
 
 /*
@@ -7075,88 +7126,6 @@ void __init free_area_init_memoryless_node(int nid)
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
@@ -7516,7 +7485,7 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
-	start_pfn = find_min_pfn_with_active_regions();
+	start_pfn = 0;
 	descending = arch_has_descending_max_zone_pfns();
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -7580,7 +7549,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 

-- 
Sincerely yours,
Mike.
