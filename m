Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77E72E217D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 21:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgLWUgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 15:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgLWUgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 15:36:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1753224B1;
        Wed, 23 Dec 2020 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608755751;
        bh=ZTEqw8A9+kDvoe7tM5JlZgVl8A3JB25JYlfCgSrOB8U=;
        h=Date:From:To:Subject:From;
        b=BehgLbSFaoZmJIXkXGewlSwvw0cK+ng4lpNuzKTWSlRcM7HSgRcUiWPgbLxwu0xlR
         RA6Eak0ajnyoUxo+Vph0dynoztQbYtf7DsOHQdVsNfEcTF99zvFKEgGgALu8tEdNLz
         658fFlipkf6REa4nUobpg4fJDvS5qldTAwORu680=
Date:   Wed, 23 Dec 2020 12:35:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.ibm.com, gopakumarr@vmware.com, david@redhat.com,
        bhe@redhat.com
Subject:  + mm-memmap-defer-init-dosnt-work-as-expected.patch added
 to -mm tree
Message-ID: <20201223203551.8gSau%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memmap defer init dosn't work as expected
has been added to the -mm tree.  Its filename is
     mm-memmap-defer-init-dosnt-work-as-expected.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memmap-defer-init-dosnt-work-as-expected.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memmap-defer-init-dosnt-work-as-expected.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: memmap defer init dosn't work as expected

VMware observed a performance regression during memmap init on their
platform, and bisected to commit 73a6e474cb376 ("mm: memmap_init: iterate
over memblock regions rather that check each PFN") causing it.

Before the commit:

  [0.033176] Normal zone: 1445888 pages used for memmap
  [0.033176] Normal zone: 89391104 pages, LIFO batch:63
  [0.035851] ACPI: PM-Timer IO Port: 0x448

With commit

  [0.026874] Normal zone: 1445888 pages used for memmap
  [0.026875] Normal zone: 89391104 pages, LIFO batch:63
  [2.028450] ACPI: PM-Timer IO Port: 0x448

The root cause is the current memmap defer init doesn't work as expected. 
Before, memmap_init_zone() was used to do memmap init of one whole zone,
to initialize all low zones of one numa node, but defer memmap init of the
last zone in that numa node.  However, since commit 73a6e474cb376,
function memmap_init() is adapted to iterater over memblock regions inside
one zone, then call memmap_init_zone() to do memmap init for each region.

E.g, on VMware's system, the memory layout is as below, there are two
memory regions in node 2.  The current code will mistakenly initialize the
whole 1st region [mem 0xab00000000-0xfcffffffff], then do memmap defer to
iniatialize only one memmory section on the 2nd region [mem
0x10000000000-0x1033fffffff].  In fact, we only expect to see that there's
only one memory section's memmap initialized.  That's why more time is
costed at the time.

[    0.008842] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.008842] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.008843] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x55ffffffff]
[    0.008844] ACPI: SRAT: Node 1 PXM 1 [mem 0x5600000000-0xaaffffffff]
[    0.008844] ACPI: SRAT: Node 2 PXM 2 [mem 0xab00000000-0xfcffffffff]
[    0.008845] ACPI: SRAT: Node 2 PXM 2 [mem 0x10000000000-0x1033fffffff]

Now, let's add a parameter 'zone_end_pfn' to memmap_init_zone() to pass
down the real zone end pfn so that defer_init() can use it to judge
whether defer need be taken in zone wide.

Link: https://lkml.kernel.org/r/20201223080811.16211-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20201223080811.16211-2-bhe@redhat.com
Fixes: commit 73a6e474cb376 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Rahul Gopakumar <gopakumarr@vmware.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    4 ++--
 include/linux/mm.h  |    5 +++--
 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |    8 +++++---
 4 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/ia64/mm/init.c~mm-memmap-defer-init-dosnt-work-as-expected
+++ a/arch/ia64/mm/init.c
@@ -536,7 +536,7 @@ virtual_memmap_init(u64 start, u64 end,
 
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
-				 args->nid, args->zone, page_to_pfn(map_start),
+				 args->nid, args->zone, page_to_pfn(map_start), page_to_pfn(map_end),
 				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	return 0;
 }
@@ -546,7 +546,7 @@ memmap_init (unsigned long size, int nid
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn,
+		memmap_init_zone(size, nid, zone, start_pfn, start_pfn + size,
 				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
--- a/include/linux/mm.h~mm-memmap-defer-init-dosnt-work-as-expected
+++ a/include/linux/mm.h
@@ -2432,8 +2432,9 @@ extern int __meminit early_pfn_to_nid(un
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
-extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum meminit_context, struct vmem_altmap *, int migratetype);
+extern void memmap_init_zone(unsigned long, int, unsigned long,
+		unsigned long, unsigned long, enum meminit_context,
+		struct vmem_altmap *, int migratetype);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/mm/memory_hotplug.c~mm-memmap-defer-init-dosnt-work-as-expected
+++ a/mm/memory_hotplug.c
@@ -713,7 +713,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * expects the zone spans the pfn range. All the pages in the range
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
-	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
+	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype);
 
 	set_zone_contiguous(zone);
--- a/mm/page_alloc.c~mm-memmap-defer-init-dosnt-work-as-expected
+++ a/mm/page_alloc.c
@@ -423,6 +423,8 @@ defer_init(int nid, unsigned long pfn, u
 	if (end_pfn < pgdat_end_pfn(NODE_DATA(nid)))
 		return false;
 
+	if (NODE_DATA(nid)->first_deferred_pfn != ULONG_MAX)
+		return true;
 	/*
 	 * We start only with one section of pages, more pages are added as
 	 * needed until the rest of deferred pages are initialized.
@@ -6116,7 +6118,7 @@ overlap_memmap_init(unsigned long zone,
  * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn,
+		unsigned long start_pfn, unsigned long zone_end_pfn,
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype)
 {
@@ -6152,7 +6154,7 @@ void __meminit memmap_init_zone(unsigned
 		if (context == MEMINIT_EARLY) {
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
-			if (defer_init(nid, pfn, end_pfn))
+			if (defer_init(nid, pfn, zone_end_pfn))
 				break;
 		}
 
@@ -6266,7 +6268,7 @@ void __meminit __weak memmap_init(unsign
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
-			memmap_init_zone(size, nid, zone, start_pfn,
+			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-memmap-defer-init-dosnt-work-as-expected.patch

