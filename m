Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6A304A8D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbhAZFEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731182AbhAYSww (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF97221E3;
        Mon, 25 Jan 2021 18:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600731;
        bh=w33vISWJupVIFl1t4grFVsev4X4ZZpMPtah+DOP/3Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJGzFntyRhFMLk6zs7t4wf42ldesomX5PG7gv4CVZZuz69bjYm0gkRX9qv+oXMIKT
         MMytGMWcLejX4dOkKT0Sq0iD1ISL3RmANTSVtTg2WPyubA0dyixgvWWyQhQaCT/aax
         6m9IN+KNFcFKs7Kt90nZ9QJmD9jy1KMaUW6Fj9IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 122/199] mm: fix initialization of struct page for holes in memory layout
Date:   Mon, 25 Jan 2021 19:39:04 +0100
Message-Id: <20210125183221.375246952@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit d3921cb8be29ce5668c64e23ffdaeec5f8c69399 upstream.

There could be struct pages that are not backed by actual physical
memory.  This can happen when the actual memory bank is not a multiple
of SECTION_SIZE or when an architecture does not register memory holes
reserved by the firmware as memblock.memory.

Such pages are currently initialized using init_unavailable_mem()
function that iterates through PFNs in holes in memblock.memory and if
there is a struct page corresponding to a PFN, the fields if this page
are set to default values and the page is marked as Reserved.

init_unavailable_mem() does not take into account zone and node the page
belongs to and sets both zone and node links in struct page to zero.

On a system that has firmware reserved holes in a zone above ZONE_DMA,
for instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
in struct page) in the same pageblock.

Update init_unavailable_mem() to use zone constraints defined by an
architecture to properly setup the zone link and use node ID of the
adjacent range in memblock.memory to set the node link.

Link: https://lkml.kernel.org/r/20210111194017.22696-3-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   84 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7003,23 +7003,26 @@ void __init free_area_init_memoryless_no
  * Initialize all valid struct pages in the range [spfn, epfn) and mark them
  * PageReserved(). Return the number of struct pages that were initialized.
  */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
+static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int nid)
 {
-	unsigned long pfn;
+	unsigned long pfn, zone_spfn, zone_epfn;
 	u64 pgcnt = 0;
 
+	zone_spfn = arch_zone_lowest_possible_pfn[zone];
+	zone_epfn = arch_zone_highest_possible_pfn[zone];
+
+	spfn = clamp(spfn, zone_spfn, zone_epfn);
+	epfn = clamp(epfn, zone_spfn, zone_epfn);
+
 	for (pfn = spfn; pfn < epfn; pfn++) {
 		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
 			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
 				+ pageblock_nr_pages - 1;
 			continue;
 		}
-		/*
-		 * Use a fake node/zone (0) for now. Some of these pages
-		 * (in memblock.reserved but not in memblock.memory) will
-		 * get re-initialized via reserve_bootmem_region() later.
-		 */
-		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
+
+		__init_single_page(pfn_to_page(pfn), pfn, zone, nid);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
 	}
@@ -7028,51 +7031,64 @@ static u64 __init init_unavailable_range
 }
 
 /*
- * Only struct pages that are backed by physical memory are zeroed and
- * initialized by going through __init_single_page(). But, there are some
- * struct pages which are reserved in memblock allocator and their fields
- * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly initialize those struct pages.
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init().
  *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=, or when the highest physical
- * address (max_pfn) does not end on a section boundary.
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
+ * - zone link is set accorging to the architecture constrains
+ * - node is set to node id of the next populated region except for the
+ *   trailing hole where last node id is used
  */
-static void __init init_unavailable_mem(void)
+static void __init init_zone_unavailable_mem(int zone)
 {
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next = 0;
+	unsigned long start, end;
+	int i, nid;
+	u64 pgcnt;
+	unsigned long next = 0;
 
 	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
+	 * Loop through holes in memblock.memory and initialize struct
+	 * pages corresponding to these holes
 	 */
 	pgcnt = 0;
-	for_each_mem_range(i, &start, &end) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
 		if (next < start)
-			pgcnt += init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
+			pgcnt += init_unavailable_range(next, start, zone, nid);
 		next = end;
 	}
 
 	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
+	 * Last section may surpass the actual end of memory (e.g. we can
+	 * have 1Gb section and 512Mb of RAM pouplated).
+	 * Make sure that memmap has a well defined state in this case.
 	 */
-	pgcnt += init_unavailable_range(PFN_DOWN(next),
-					round_up(max_pfn, PAGES_PER_SECTION));
+	end = round_up(max_pfn, PAGES_PER_SECTION);
+	pgcnt += init_unavailable_range(next, end, zone, nid);
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
 	 * firmware is using some of this memory, or for some other reasons.
 	 */
 	if (pgcnt)
-		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
+		pr_info("Zone %s: zeroed struct page in unavailable ranges: %lld pages", zone_names[zone], pgcnt);
+}
+
+static void __init init_unavailable_mem(void)
+{
+	int zone;
+
+	for (zone = 0; zone < ZONE_MOVABLE; zone++)
+		init_zone_unavailable_mem(zone);
 }
 #else
 static inline void __init init_unavailable_mem(void)


