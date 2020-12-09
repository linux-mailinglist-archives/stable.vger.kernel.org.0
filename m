Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9572C2D4E86
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 00:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgLIXK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 18:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgLIXK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 18:10:27 -0500
Date:   Wed, 09 Dec 2020 15:09:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607555386;
        bh=XCTwcDy84UGV2DxzvSjOM2EeckFOkcHNDcY7+/eCUus=;
        h=From:To:Subject:From;
        b=ZwfTIbqoQLxSVzAr8wgYtAefzU3Zgmt5P3yEIhwDmfNZAXbpXMki6X14gSLhggwZy
         dBetiI9k7bl8KDqRqSyblHmQTN24SIEqKdnV0zeuRlGaGXY0awGcVEdPgP8SNMgGf6
         H4FFGZP8eVz1s16fLlUrxJBHWe4ZOKqBTADGEkfo=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        mhocko@kernel.org, mgorman@suse.de, david@redhat.com, cai@lca.pw,
        bhe@redhat.com, aarcange@redhat.com, rppt@linux.ibm.com
Subject:  +
 mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch added
 to -mm tree
Message-ID: <20201209230944.01RDs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memblock: enforce overlap of memory.memblock and memory.reserved
has been added to the -mm tree.  Its filename is
     mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch

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
Subject: mm: memblock: enforce overlap of memory.memblock and memory.reserved

Patch series "mm: fix initialization of struct page for holes in  memory layout", v2.

Commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
rather that check each PFN") exposed several issues with the memory map
initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported back
in April [1].  It seemed back then that the probelm was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and after a long
discussion between us [3] I think these patches are the proper fix.

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org


This patch (of 2):

memblock does not require that the reserved memory ranges will be a subset
of memblock.memory.

As a result there may be reserved pages that are not in the range of any
zone or node because zone and node boundaries are detected based on
memblock.memory and pages that only present in memblock.reserved are not
taken into account during zone/node size detection.

Make sure that all ranges in memblock.reserved are added to
memblock.memory before calculating node and zone boundaries.

Link: https://lkml.kernel.org/r/20201209214304.6812-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20201209214304.6812-2-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
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

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 mm/page_alloc.c          |    7 +++++++
 3 files changed, 32 insertions(+)

--- a/include/linux/memblock.h~mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved
+++ a/include/linux/memblock.h
@@ -120,6 +120,7 @@ int memblock_clear_nomap(phys_addr_t bas
 unsigned long memblock_free_all(void);
 void reset_node_managed_pages(pg_data_t *pgdat);
 void reset_all_zones_managed_pages(void);
+void memblock_enforce_memory_reserved_overlap(void);
 
 /* Low level functions */
 void __next_mem_range(u64 *idx, int nid, enum memblock_flags flags,
--- a/mm/memblock.c~mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved
+++ a/mm/memblock.c
@@ -1857,6 +1857,30 @@ void __init_memblock memblock_trim_memor
 	}
 }
 
+/**
+ * memblock_enforce_memory_reserved_overlap - make sure every range in
+ * @memblock.reserved is covered by @memblock.memory
+ *
+ * The data in @memblock.memory is used to detect zone and node boundaries
+ * during initialization of the memory map and the page allocator. Make
+ * sure that every memory range present in @memblock.reserved is also added
+ * to @memblock.memory even if the architecture specific memory
+ * initialization failed to do so
+ */
+void __init memblock_enforce_memory_reserved_overlap(void)
+{
+	phys_addr_t start, end;
+	int nid;
+	u64 i;
+
+	__for_each_mem_range(i, &memblock.reserved, &memblock.memory,
+			     NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, &nid) {
+		pr_warn("memblock: reserved range [%pa-%pa] is not in memory\n",
+			&start, &end);
+		memblock_add_node(start, (end - start), nid);
+	}
+}
+
 void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
 	memblock.current_limit = limit;
--- a/mm/page_alloc.c~mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved
+++ a/mm/page_alloc.c
@@ -7507,6 +7507,13 @@ void __init free_area_init(unsigned long
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
+	/*
+	 * Some architectures (e.g. x86) have reserved pages outside of
+	 * memblock.memory. Make sure these pages are taken into account
+	 * when detecting zone and node boundaries
+	 */
+	memblock_enforce_memory_reserved_overlap();
+
 	start_pfn = find_min_pfn_with_active_regions();
 	descending = arch_has_descending_max_zone_pfns();
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

