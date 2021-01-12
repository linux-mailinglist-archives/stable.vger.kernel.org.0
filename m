Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886B2F2525
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhALAys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhALAyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 19:54:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBDA92253A;
        Tue, 12 Jan 2021 00:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610412846;
        bh=cigcvxM47gH8g26kS6gkZ9wCXDK5QLoClXWyCISsKyE=;
        h=Date:From:To:Subject:From;
        b=q56Rx5Qq9FUM0ytKLMEBAVSmKLVcys+aVvcAFFWvkxzNajwBempL3qphxzBy9mYYg
         /OUOXOKGvawaAjEfcqER+5yeInJWudaWcMLL+XMVjmCtyTe9egmZqq/heSGTTjGcrv
         lNuqHnDQbNmXKb9C5AUR4mJwGtMDGfUyoGedWdRo=
Date:   Mon, 11 Jan 2021 16:54:05 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
 removed from -mm tree
Message-ID: <20210112005405.I9flYBs2J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memblock: enforce overlap of memory.memblock and memory.reserved
has been removed from the -mm tree.  Its filename was
     mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch

This patch was dropped because an updated version will be merged

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
@@ -1860,6 +1860,30 @@ void __init_memblock memblock_trim_memor
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
@@ -7513,6 +7513,13 @@ void __init free_area_init(unsigned long
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

mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
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

