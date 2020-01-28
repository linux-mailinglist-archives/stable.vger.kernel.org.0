Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB814B951
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgA1OaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgA1OaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:30:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD33424698;
        Tue, 28 Jan 2020 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221818;
        bh=ce+zIUqgZVaCw2M2uGxh8Jj9B4ifS+24IzmbU10V8Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0f1tSdX5hGp2BDTjAO1XRlEcDVHsVuvgxisRf3E0542eArD9Q6i8lQvPBKVKqZnDl
         ApeN/5tZ3mxIQfwHtZJi0UFRvQelCLYtSznS42Iu5iWohFaWm83iJDLKfwHGw2SeyL
         5a8EePrFYsdhGsBIrXJJJC8mOvvYxJshK/Bu71xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 92/92] mm/memory_hotplug: shrink zones when offlining memory
Date:   Tue, 28 Jan 2020 15:09:00 +0100
Message-Id: <20200128135821.343688457@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
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

-- snip --

- Missing arm64 hot(un)plug support
- Missing some vmem_altmap_offset() cleanups
- Missing sub-section hotadd support
- Missing unification of mm/hmm.c and kernel/memremap.c

-- snip --

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
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/mm/init.c            |    4 +---
 arch/powerpc/mm/mem.c          |   11 +----------
 arch/s390/mm/init.c            |    4 +---
 arch/sh/mm/init.c              |    4 +---
 arch/x86/mm/init_32.c          |    4 +---
 arch/x86/mm/init_64.c          |    8 +-------
 include/linux/memory_hotplug.h |    7 +++++--
 kernel/memremap.c              |    3 +--
 mm/hmm.c                       |    4 +---
 mm/memory_hotplug.c            |   29 ++++++++++++++---------------
 10 files changed, 27 insertions(+), 51 deletions(-)

--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -666,9 +666,7 @@ void arch_remove_memory(int nid, u64 sta
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
@@ -144,18 +144,9 @@ void __ref arch_remove_memory(int nid, u
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page;
 	int ret;
 
-	/*
-	 * If we have an altmap then we need to skip over any reserved PFNs
-	 * when querying the zone.
-	 */
-	page = pfn_to_page(start_pfn);
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
-
-	__remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 
 	/* Remove htab bolted mappings for this section of memory */
 	start = (unsigned long)__va(start);
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -244,10 +244,8 @@ void arch_remove_memory(int nid, u64 sta
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
@@ -448,9 +448,7 @@ void arch_remove_memory(int nid, u64 sta
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
@@ -1146,14 +1146,8 @@ void __ref arch_remove_memory(int nid, u
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn);
-	struct zone *zone;
 
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
-	zone = page_zone(page);
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -110,8 +110,8 @@ static inline bool movable_node_is_enabl
 
 extern void arch_remove_memory(int nid, u64 start, u64 size,
 			       struct vmem_altmap *altmap);
-extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
-			   unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
+			   struct vmem_altmap *altmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -331,6 +331,9 @@ extern int arch_add_memory(int nid, u64
 		struct vmem_altmap *altmap, bool want_memblock);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void remove_pfn_range_from_zone(struct zone *zone,
+				       unsigned long start_pfn,
+				       unsigned long nr_pages);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_one_section(int nid, unsigned long start_pfn,
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -141,8 +141,7 @@ static void devm_memremap_pages_release(
 	mem_hotplug_begin();
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		pfn = align_start >> PAGE_SHIFT;
-		__remove_pages(page_zone(first_page), pfn,
-			       align_size >> PAGE_SHIFT, NULL);
+		__remove_pages(pfn, align_size >> PAGE_SHIFT, NULL);
 	} else {
 		arch_remove_memory(nid, align_start, align_size,
 				pgmap->altmap_valid ? &pgmap->altmap : NULL);
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -997,7 +997,6 @@ static void hmm_devmem_release(void *dat
 	struct hmm_devmem *devmem = data;
 	struct resource *resource = devmem->resource;
 	unsigned long start_pfn, npages;
-	struct zone *zone;
 	struct page *page;
 	int nid;
 
@@ -1006,12 +1005,11 @@ static void hmm_devmem_release(void *dat
 	npages = ALIGN(resource_size(resource), PA_SECTION_SIZE) >> PAGE_SHIFT;
 
 	page = pfn_to_page(start_pfn);
-	zone = page_zone(page);
 	nid = page_to_nid(page);
 
 	mem_hotplug_begin();
 	if (resource->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY)
-		__remove_pages(zone, start_pfn, npages, NULL);
+		__remove_pages(start_pfn, npages, NULL);
 	else
 		arch_remove_memory(nid, start_pfn << PAGE_SHIFT,
 				   npages << PAGE_SHIFT, NULL);
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -449,10 +449,11 @@ static void update_pgdat_span(struct pgl
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
-static void __remove_zone(struct zone *zone, unsigned long start_pfn)
+void __ref remove_pfn_range_from_zone(struct zone *zone,
+				      unsigned long start_pfn,
+				      unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	int nr_pages = PAGES_PER_SECTION;
 	unsigned long flags;
 
 #ifdef CONFIG_ZONE_DEVICE
@@ -465,14 +466,17 @@ static void __remove_zone(struct zone *z
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
 
-static void __remove_section(struct zone *zone, struct mem_section *ms,
-			     unsigned long map_offset,
+static void __remove_section(struct mem_section *ms, unsigned long map_offset,
 			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn;
@@ -483,14 +487,12 @@ static void __remove_section(struct zone
 
 	scn_nr = __section_nr(ms);
 	start_pfn = section_nr_to_pfn((unsigned long)scn_nr);
-	__remove_zone(zone, start_pfn);
 
 	sparse_remove_one_section(ms, map_offset, altmap);
 }
 
 /**
- * __remove_pages() - remove sections of pages from a zone
- * @zone: zone from which pages need to be removed
+ * __remove_pages() - remove sections of pages
  * @phys_start_pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
@@ -500,8 +502,8 @@ static void __remove_section(struct zone
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
-		    unsigned long nr_pages, struct vmem_altmap *altmap)
+void __remove_pages(unsigned long phys_start_pfn, unsigned long nr_pages,
+		    struct vmem_altmap *altmap)
 {
 	unsigned long i;
 	unsigned long map_offset = 0;
@@ -510,8 +512,6 @@ void __remove_pages(struct zone *zone, u
 	if (altmap)
 		map_offset = vmem_altmap_offset(altmap);
 
-	clear_zone_contiguous(zone);
-
 	/*
 	 * We can only remove entire sections
 	 */
@@ -523,12 +523,9 @@ void __remove_pages(struct zone *zone, u
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
 
 		cond_resched();
-		__remove_section(zone, __pfn_to_section(pfn), map_offset,
-				 altmap);
+		__remove_section(__pfn_to_section(pfn), map_offset, altmap);
 		map_offset = 0;
 	}
-
-	set_zone_contiguous(zone);
 }
 
 int set_online_page_callback(online_page_callback_t callback)
@@ -898,6 +895,7 @@ failed_addition:
 		 (unsigned long long) pfn << PAGE_SHIFT,
 		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	remove_pfn_range_from_zone(zone, pfn, nr_pages);
 	mem_hotplug_done();
 	return ret;
 }
@@ -1682,6 +1680,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
+	remove_pfn_range_from_zone(zone, start_pfn, nr_pages);
 	mem_hotplug_done();
 	return 0;
 


