Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C815302F55
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 23:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbhAYWpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 17:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732882AbhAYVfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 16:35:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782F4208C7;
        Mon, 25 Jan 2021 21:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610489;
        bh=tHBRtFM+DBhfjg+9yisl4TLz5gr0WP9baJk3JUE7D0M=;
        h=Date:From:To:Subject:From;
        b=Qy0y2emKDU1nS7wWDwq6anttR2DMqHMplIcHsSx3eK5djY5lQQmMuQKLR4wOdL8MY
         r5HJ7xKx9APyjfZZJ+4FJy4rMGuOWKiXs6VN0X5bb4D3KcoFOTfQJ4ewXQBzBSNBQE
         8DxuQOMlepKp53oUGHq9eJHoJQCKWCv2qILY2Jhk=
Date:   Mon, 25 Jan 2021 13:34:49 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, bp@alien8.de, cai@lca.pw, david@redhat.com,
        hpa@zytor.com, mgorman@suse.de, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch removed from -mm tree
Message-ID: <20210125213449.I2QHaqedF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: x86/setup: don't remove E820_TYPE_RAM for pfn 0
has been removed from the -mm tree.  Its filename was
     x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: x86/setup: don't remove E820_TYPE_RAM for pfn 0

Patch series "mm: fix initialization of struct page for holes in  memory layout", v3.

Commit 73a6e474cb37 ("mm: memmap_init: iterate over
memblock regions rather that check each PFN") exposed several issues with
the memory map initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported back
in April [1]. It seemed back then that the problem was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and there was an additional
discussion at [3].

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org


This patch (of 2):

The first 4Kb of memory is a BIOS owned area and to avoid its allocation
for the kernel it was not listed in e820 tables as memory.  As the result,
pfn 0 was never recognised by the generic memory management and it is not
a part of neither node 0 nor ZONE_DMA.

If set_pfnblock_flags_mask() would be ever called for the pageblock
corresponding to the first 2Mbytes of memory, having pfn 0 outside of
ZONE_DMA would trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

Along with reserving the first 4Kb in e820 tables, several first pages are
reserved with memblock in several places during setup_arch().  These
reservations are enough to ensure the kernel does not touch the BIOS area
and it is not necessary to remove E820_TYPE_RAM for pfn 0.

Remove the update of e820 table that changes the type of pfn 0 and move
the comment describing why it was done to trim_low_memory_range() that
reserves the beginning of the memory.

Link: https://lkml.kernel.org/r/20210111194017.22696-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
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
---

 arch/x86/kernel/setup.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-setup-dont-remove-e820_type_ram-for-pfn-0
+++ a/arch/x86/kernel/setup.c
@@ -661,17 +661,6 @@ static void __init trim_platform_memory_
 static void __init trim_bios_range(void)
 {
 	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 *
-	 * This typically reserves additional memory (64KiB by default)
-	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_RESERVE_LOW.
-	 */
-	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
-
-	/*
 	 * special case: Some BIOSes report the PC BIOS
 	 * area (640Kb -> 1Mb) as RAM even though it is not.
 	 * take them out.
@@ -728,6 +717,15 @@ early_param("reservelow", parse_reservel
 
 static void __init trim_low_memory_range(void)
 {
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
+	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

