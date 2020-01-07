Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6DA133150
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgAGU7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbgAGU7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE49E24676;
        Tue,  7 Jan 2020 20:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430773;
        bh=2rl+PEfXEeI7BizGZNIr+h/CpR2gPgnom3E3d1Mpi10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1kBPnDc1bMgf4idt+RRcbXfuaveLfjfZ00wls+/uxRLgqyASmxaYwfxODXWBMF81
         T+Bpu/yrUC2KNWY8Ii9noMSYh1awhWKoGEl6jl0rWWtvBUFK0a95zgeiVQDkkok8uJ
         BaglXqjc5RSOGZCi6gwbo/XNyK1H0YXyVAl6r4cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 083/191] mm/memory_hotplug: shrink zones when offlining memory
Date:   Tue,  7 Jan 2020 21:53:23 +0100
Message-Id: <20200107205337.428473293@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit feee6b2989165631b17ac6d4ccdbf6759254e85a upstream.

We currently try to shrink a single zone when removing memory.  We use
the zone of the first page of the memory we are removing.  If that
memmap was never initialized (e.g., memory was never onlined), we will
read garbage and can trigger kernel BUGs (due to a stale pointer):

    BUG: unable to handle page fault for address: 000000000000353d
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    PGD 0 P4D 0
    Oops: 0002 [#1] SMP PTI
    CPU: 1 PID: 7 Comm: kworker/u8:0 Not tainted 5.3.0-rc5-next-20190820+ #317
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.4
    Workqueue: kacpi_hotplug acpi_hotplug_work_fn
    RIP: 0010:clear_zone_contiguous+0x5/0x10
    Code: 48 89 c6 48 89 c3 e8 2a fe ff ff 48 85 c0 75 cf 5b 5d c3 c6 85 fd 05 00 00 01 5b 5d c3 0f 1f 840
    RSP: 0018:ffffad2400043c98 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: 0000000200000000 RCX: 0000000000000000
    RDX: 0000000000200000 RSI: 0000000000140000 RDI: 0000000000002f40
    RBP: 0000000140000000 R08: 0000000000000000 R09: 0000000000000001
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000140000
    R13: 0000000000140000 R14: 0000000000002f40 R15: ffff9e3e7aff3680
    FS:  0000000000000000(0000) GS:ffff9e3e7bb00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 000000000000353d CR3: 0000000058610000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     __remove_pages+0x4b/0x640
     arch_remove_memory+0x63/0x8d
     try_remove_memory+0xdb/0x130
     __remove_memory+0xa/0x11
     acpi_memory_device_remove+0x70/0x100
     acpi_bus_trim+0x55/0x90
     acpi_device_hotplug+0x227/0x3a0
     acpi_hotplug_work_fn+0x1a/0x30
     process_one_work+0x221/0x550
     worker_thread+0x50/0x3b0
     kthread+0x105/0x140
     ret_from_fork+0x3a/0x50
    Modules linked in:
    CR2: 000000000000353d

Instead, shrink the zones when offlining memory or when onlining failed.
Introduce and use remove_pfn_range_from_zone(() for that.  We now
properly shrink the zones, even if we have DIMMs whereby

 - Some memory blocks fall into no zone (never onlined)

 - Some memory blocks fall into multiple zones (offlined+re-onlined)

 - Multiple memory blocks that fall into different zones

Drop the zone parameter (with a potential dubious value) from
__remove_pages() and __remove_section().

Link: http://lkml.kernel.org/r/20191006085646.5768-6-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/mmu.c            |    4 +---
 arch/ia64/mm/init.c            |    4 +---
 arch/powerpc/mm/mem.c          |    3 +--
 arch/s390/mm/init.c            |    4 +---
 arch/sh/mm/init.c              |    4 +---
 arch/x86/mm/init_32.c          |    4 +---
 arch/x86/mm/init_64.c          |    4 +---
 include/linux/memory_hotplug.h |    7 +++++--
 mm/memory_hotplug.c            |   31 ++++++++++++++++---------------
 mm/memremap.c                  |    2 +-
 10 files changed, 29 insertions(+), 38 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1069,7 +1069,6 @@ void arch_remove_memory(int nid, u64 sta
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct zone *zone;
 
 	/*
 	 * FIXME: Cleanup page tables (also in arch_add_memory() in case
@@ -1078,7 +1077,6 @@ void arch_remove_memory(int nid, u64 sta
 	 * unplug. ARCH_ENABLE_MEMORY_HOTREMOVE must not be
 	 * unlocked yet.
 	 */
-	zone = page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -689,9 +689,7 @@ void arch_remove_memory(int nid, u64 sta
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct zone *zone;
 
-	zone = page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -130,10 +130,9 @@ void __ref arch_remove_memory(int nid, u
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn) + vmem_altmap_offset(altmap);
 	int ret;
 
-	__remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 
 	/* Remove htab bolted mappings for this section of memory */
 	start = (unsigned long)__va(start);
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -291,10 +291,8 @@ void arch_remove_memory(int nid, u64 sta
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct zone *zone;
 
-	zone = page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -434,9 +434,7 @@ void arch_remove_memory(int nid, u64 sta
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct zone *zone;
 
-	zone = page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -865,10 +865,8 @@ void arch_remove_memory(int nid, u64 sta
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct zone *zone;
 
-	zone = page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
 
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1212,10 +1212,8 @@ void __ref arch_remove_memory(int nid, u
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn) + vmem_altmap_offset(altmap);
-	struct zone *zone = page_zone(page);
 
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -125,8 +125,8 @@ static inline bool movable_node_is_enabl
 
 extern void arch_remove_memory(int nid, u64 start, u64 size,
 			       struct vmem_altmap *altmap);
-extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
-			   unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
+			   struct vmem_altmap *altmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -345,6 +345,9 @@ extern int add_memory(int nid, u64 start
 extern int add_memory_resource(int nid, struct resource *resource);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void remove_pfn_range_from_zone(struct zone *zone,
+				       unsigned long start_pfn,
+				       unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -465,8 +465,9 @@ static void update_pgdat_span(struct pgl
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
-static void __remove_zone(struct zone *zone, unsigned long start_pfn,
-		unsigned long nr_pages)
+void __ref remove_pfn_range_from_zone(struct zone *zone,
+				      unsigned long start_pfn,
+				      unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long flags;
@@ -481,28 +482,30 @@ static void __remove_zone(struct zone *z
 		return;
 #endif
 
+	clear_zone_contiguous(zone);
+
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
+	set_zone_contiguous(zone);
 }
 
-static void __remove_section(struct zone *zone, unsigned long pfn,
-		unsigned long nr_pages, unsigned long map_offset,
-		struct vmem_altmap *altmap)
+static void __remove_section(unsigned long pfn, unsigned long nr_pages,
+			     unsigned long map_offset,
+			     struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __nr_to_section(pfn_to_section_nr(pfn));
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	__remove_zone(zone, pfn, nr_pages);
 	sparse_remove_section(ms, pfn, nr_pages, map_offset, altmap);
 }
 
 /**
- * __remove_pages() - remove sections of pages from a zone
- * @zone: zone from which pages need to be removed
+ * __remove_pages() - remove sections of pages
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
@@ -512,16 +515,14 @@ static void __remove_section(struct zone
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-void __remove_pages(struct zone *zone, unsigned long pfn,
-		    unsigned long nr_pages, struct vmem_altmap *altmap)
+void __remove_pages(unsigned long pfn, unsigned long nr_pages,
+		    struct vmem_altmap *altmap)
 {
 	unsigned long map_offset = 0;
 	unsigned long nr, start_sec, end_sec;
 
 	map_offset = vmem_altmap_offset(altmap);
 
-	clear_zone_contiguous(zone);
-
 	if (check_pfn_span(pfn, nr_pages, "remove"))
 		return;
 
@@ -533,13 +534,11 @@ void __remove_pages(struct zone *zone, u
 		cond_resched();
 		pfns = min(nr_pages, PAGES_PER_SECTION
 				- (pfn & ~PAGE_SECTION_MASK));
-		__remove_section(zone, pfn, pfns, map_offset, altmap);
+		__remove_section(pfn, pfns, map_offset, altmap);
 		pfn += pfns;
 		nr_pages -= pfns;
 		map_offset = 0;
 	}
-
-	set_zone_contiguous(zone);
 }
 
 int set_online_page_callback(online_page_callback_t callback)
@@ -867,6 +866,7 @@ failed_addition:
 		 (unsigned long long) pfn << PAGE_SHIFT,
 		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	remove_pfn_range_from_zone(zone, pfn, nr_pages);
 	mem_hotplug_done();
 	return ret;
 }
@@ -1602,6 +1602,7 @@ static int __ref __offline_pages(unsigne
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
+	remove_pfn_range_from_zone(zone, start_pfn, nr_pages);
 	mem_hotplug_done();
 	return 0;
 
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -120,7 +120,7 @@ void memunmap_pages(struct dev_pagemap *
 
 	mem_hotplug_begin();
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
-		__remove_pages(page_zone(first_page), PHYS_PFN(res->start),
+		__remove_pages(PHYS_PFN(res->start),
 			       PHYS_PFN(resource_size(res)), NULL);
 	} else {
 		arch_remove_memory(nid, res->start, resource_size(res),


