Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18431443F9
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgAUSDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:03:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58921 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728901AbgAUSDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1S6QliRpSTPxwoG9oU08X7twvxrC/9c6HpCYp9lYE6w=;
        b=PwZ/pdyEANhF+woWtOAepiYI4V4G1NgPc6ZohSX/Txz1XoD9Gp1k+ZKFzlRlaTTGzpcBeO
        03rGdLpl0/HLWHrNZnycN2ZB714K7jKvtOCBfBCwVQbCPeYYrgH/AXCm4swqNiUv7V2eA8
        F4ZKtSj3uzEGu9JT8uNT5aDYm4Zm4IU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-nvhySwFqPfy4HFFmp2Hy3g-1; Tue, 21 Jan 2020 13:03:43 -0500
X-MC-Unique: nvhySwFqPfy4HFFmp2Hy3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BF3A802560;
        Tue, 21 Jan 2020 18:03:42 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E06A55C1C3;
        Tue, 21 Jan 2020 18:03:39 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v2 24/24] mm/memory_hotplug: shrink zones when offlining memory
Date:   Tue, 21 Jan 2020 19:01:50 +0100
Message-Id: <20200121180150.37454-25-david@redhat.com>
In-Reply-To: <20200121180150.37454-1-david@redhat.com>
References: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
    CPU: 1 PID: 7 Comm: kworker/u8:0 Not tainted 5.3.0-rc5-next-20190820+=
 #317
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.=
1-0-ga5cab58e9a3f-prebuilt.qemu.4
    Workqueue: kacpi_hotplug acpi_hotplug_work_fn
    RIP: 0010:clear_zone_contiguous+0x5/0x10
    Code: 48 89 c6 48 89 c3 e8 2a fe ff ff 48 85 c0 75 cf 5b 5d c3 c6 85 =
fd 05 00 00 01 5b 5d c3 0f 1f 840
    RSP: 0018:ffffad2400043c98 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: 0000000200000000 RCX: 0000000000000000
    RDX: 0000000000200000 RSI: 0000000000140000 RDI: 0000000000002f40
    RBP: 0000000140000000 R08: 0000000000000000 R09: 0000000000000001
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000140000
    R13: 0000000000140000 R14: 0000000000002f40 R15: ffff9e3e7aff3680
    FS:  0000000000000000(0000) GS:ffff9e3e7bb00000(0000) knlGS:000000000=
0000000
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
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memor=
y to zones until online")	[visible after d0dc12e86b319]
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
---
 arch/ia64/mm/init.c            |  4 +---
 arch/powerpc/mm/mem.c          | 11 +----------
 arch/s390/mm/init.c            |  4 +---
 arch/sh/mm/init.c              |  4 +---
 arch/x86/mm/init_32.c          |  4 +---
 arch/x86/mm/init_64.c          |  8 +-------
 include/linux/memory_hotplug.h |  7 +++++--
 kernel/memremap.c              |  3 +--
 mm/hmm.c                       |  4 +---
 mm/memory_hotplug.c            | 29 ++++++++++++++---------------
 10 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 778781e5f22e..79e5cc70f1fd 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -666,9 +666,7 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct zone *zone;
=20
-	zone =3D page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 84c6d37638a7..84a012e42a7e 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -144,18 +144,9 @@ void __ref arch_remove_memory(int nid, u64 start, u6=
4 size,
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct page *page;
 	int ret;
=20
-	/*
-	 * If we have an altmap then we need to skip over any reserved PFNs
-	 * when querying the zone.
-	 */
-	page =3D pfn_to_page(start_pfn);
-	if (altmap)
-		page +=3D vmem_altmap_offset(altmap);
-
-	__remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
=20
 	/* Remove htab bolted mappings for this section of memory */
 	start =3D (unsigned long)__va(start);
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index e0b0788cfecb..379a925d9e82 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -244,10 +244,8 @@ void arch_remove_memory(int nid, u64 start, u64 size=
,
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct zone *zone;
=20
-	zone =3D page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 0da784ac0e34..47882be91121 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -448,9 +448,7 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 {
 	unsigned long start_pfn =3D PFN_DOWN(start);
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct zone *zone;
=20
-	zone =3D page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 64f54f77052b..79b95910fd9f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -865,10 +865,8 @@ void arch_remove_memory(int nid, u64 start, u64 size=
,
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct zone *zone;
=20
-	zone =3D page_zone(pfn_to_page(start_pfn));
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
=20
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 50df7ca142f9..81e85a8dd300 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1146,14 +1146,8 @@ void __ref arch_remove_memory(int nid, u64 start, =
u64 size,
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
-	struct page *page =3D pfn_to_page(start_pfn);
-	struct zone *zone;
=20
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page +=3D vmem_altmap_offset(altmap);
-	zone =3D page_zone(page);
-	__remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 26bda048f8a7..d17d45c41a0b 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -110,8 +110,8 @@ static inline bool movable_node_is_enabled(void)
=20
 extern void arch_remove_memory(int nid, u64 start, u64 size,
 			       struct vmem_altmap *altmap);
-extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
-			   unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pag=
es,
+			   struct vmem_altmap *altmap);
=20
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long n=
r_pages,
@@ -331,6 +331,9 @@ extern int arch_add_memory(int nid, u64 start, u64 si=
ze,
 		struct vmem_altmap *altmap, bool want_memblock);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long star=
t_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void remove_pfn_range_from_zone(struct zone *zone,
+				       unsigned long start_pfn,
+				       unsigned long nr_pages);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages=
);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_one_section(int nid, unsigned long start_pfn,
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 1ec1f8fd97f5..331baad8efec 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -141,8 +141,7 @@ static void devm_memremap_pages_release(void *data)
 	mem_hotplug_begin();
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
 		pfn =3D align_start >> PAGE_SHIFT;
-		__remove_pages(page_zone(first_page), pfn,
-			       align_size >> PAGE_SHIFT, NULL);
+		__remove_pages(pfn, align_size >> PAGE_SHIFT, NULL);
 	} else {
 		arch_remove_memory(nid, align_start, align_size,
 				pgmap->altmap_valid ? &pgmap->altmap : NULL);
diff --git a/mm/hmm.c b/mm/hmm.c
index ae1f6ad46d30..c482c07bbab7 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -997,7 +997,6 @@ static void hmm_devmem_release(void *data)
 	struct hmm_devmem *devmem =3D data;
 	struct resource *resource =3D devmem->resource;
 	unsigned long start_pfn, npages;
-	struct zone *zone;
 	struct page *page;
 	int nid;
=20
@@ -1006,12 +1005,11 @@ static void hmm_devmem_release(void *data)
 	npages =3D ALIGN(resource_size(resource), PA_SECTION_SIZE) >> PAGE_SHIF=
T;
=20
 	page =3D pfn_to_page(start_pfn);
-	zone =3D page_zone(page);
 	nid =3D page_to_nid(page);
=20
 	mem_hotplug_begin();
 	if (resource->desc =3D=3D IORES_DESC_DEVICE_PRIVATE_MEMORY)
-		__remove_pages(zone, start_pfn, npages, NULL);
+		__remove_pages(start_pfn, npages, NULL);
 	else
 		arch_remove_memory(nid, start_pfn << PAGE_SHIFT,
 				   npages << PAGE_SHIFT, NULL);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ab34360920b..abc10dcbc9d5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -449,10 +449,11 @@ static void update_pgdat_span(struct pglist_data *p=
gdat)
 	pgdat->node_spanned_pages =3D node_end_pfn - node_start_pfn;
 }
=20
-static void __remove_zone(struct zone *zone, unsigned long start_pfn)
+void __ref remove_pfn_range_from_zone(struct zone *zone,
+				      unsigned long start_pfn,
+				      unsigned long nr_pages)
 {
 	struct pglist_data *pgdat =3D zone->zone_pgdat;
-	int nr_pages =3D PAGES_PER_SECTION;
 	unsigned long flags;
=20
 #ifdef CONFIG_ZONE_DEVICE
@@ -465,14 +466,17 @@ static void __remove_zone(struct zone *zone, unsign=
ed long start_pfn)
 		return;
 #endif
=20
+	clear_zone_contiguous(zone);
+
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
+	set_zone_contiguous(zone);
 }
=20
-static void __remove_section(struct zone *zone, struct mem_section *ms,
-			     unsigned long map_offset,
+static void __remove_section(struct mem_section *ms, unsigned long map_o=
ffset,
 			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn;
@@ -483,14 +487,12 @@ static void __remove_section(struct zone *zone, str=
uct mem_section *ms,
=20
 	scn_nr =3D __section_nr(ms);
 	start_pfn =3D section_nr_to_pfn((unsigned long)scn_nr);
-	__remove_zone(zone, start_pfn);
=20
 	sparse_remove_one_section(ms, map_offset, altmap);
 }
=20
 /**
- * __remove_pages() - remove sections of pages from a zone
- * @zone: zone from which pages need to be removed
+ * __remove_pages() - remove sections of pages
  * @phys_start_pfn: starting pageframe (must be aligned to start of a se=
ction)
  * @nr_pages: number of pages to remove (must be multiple of section siz=
e)
  * @altmap: alternative device page map or %NULL if default memmap is us=
ed
@@ -500,8 +502,8 @@ static void __remove_section(struct zone *zone, struc=
t mem_section *ms,
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
-		    unsigned long nr_pages, struct vmem_altmap *altmap)
+void __remove_pages(unsigned long phys_start_pfn, unsigned long nr_pages=
,
+		    struct vmem_altmap *altmap)
 {
 	unsigned long i;
 	unsigned long map_offset =3D 0;
@@ -510,8 +512,6 @@ void __remove_pages(struct zone *zone, unsigned long =
phys_start_pfn,
 	if (altmap)
 		map_offset =3D vmem_altmap_offset(altmap);
=20
-	clear_zone_contiguous(zone);
-
 	/*
 	 * We can only remove entire sections
 	 */
@@ -523,12 +523,9 @@ void __remove_pages(struct zone *zone, unsigned long=
 phys_start_pfn,
 		unsigned long pfn =3D phys_start_pfn + i*PAGES_PER_SECTION;
=20
 		cond_resched();
-		__remove_section(zone, __pfn_to_section(pfn), map_offset,
-				 altmap);
+		__remove_section(__pfn_to_section(pfn), map_offset, altmap);
 		map_offset =3D 0;
 	}
-
-	set_zone_contiguous(zone);
 }
=20
 int set_online_page_callback(online_page_callback_t callback)
@@ -898,6 +895,7 @@ int __ref online_pages(unsigned long pfn, unsigned lo=
ng nr_pages, int online_typ
 		 (unsigned long long) pfn << PAGE_SHIFT,
 		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	remove_pfn_range_from_zone(zone, pfn, nr_pages);
 	mem_hotplug_done();
 	return ret;
 }
@@ -1682,6 +1680,7 @@ static int __ref __offline_pages(unsigned long star=
t_pfn,
 	writeback_set_ratelimit();
=20
 	memory_notify(MEM_OFFLINE, &arg);
+	remove_pfn_range_from_zone(zone, start_pfn, nr_pages);
 	mem_hotplug_done();
 	return 0;
=20
--=20
2.24.1

