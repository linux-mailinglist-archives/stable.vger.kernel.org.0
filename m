Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA41105E65
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 02:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKVByB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 20:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfKVByA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 20:54:00 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2C5206CB;
        Fri, 22 Nov 2019 01:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574387639;
        bh=yHVJsaehfNsBrMdK3lMb7ajJ1qLyQpOg5+UQ+MYBYoI=;
        h=Date:From:To:Subject:From;
        b=2rAKCHA3kDsuhlBvQxM+3fLAi9z/pdWbJxYemgWj7BLRqgDHyLZQoJyb9TNDoLZnJ
         a7eMCms8jNt4/dEjavivnk/PaK+INJs9gzixlUSEGoJRsBTrIjhRM1xVG+vJ4DVDGK
         4eQ0MmopmcFzBSlK5tMTsO0SA5FVI3dfvE0kr6Kc=
Date:   Thu, 21 Nov 2019 17:53:56 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr,
        dalias@libc.org, damian.tometzki@gmail.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, fenghua.yu@intel.com, gerald.schaefer@de.ibm.com,
        glider@google.com, gor@linux.ibm.com, gregkh@linuxfoundation.org,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com,
        luto@kernel.org, mark.rutland@arm.com, mgorman@techsingularity.net,
        mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, osalvador@suse.de, pagupta@redhat.com,
        pasha.tatashin@soleen.com, pasic@linux.ibm.com, paulus@samba.org,
        pavel.tatashin@microsoft.com, peterz@infradead.org,
        richard.weiyang@gmail.com, richardw.yang@linux.intel.com,
        robin.murphy@arm.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        steve.capper@arm.com, t-fukasawa@vx.jp.nec.com, tglx@linutronix.de,
        thomas.lendacky@amd.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, will@kernel.org,
        willy@infradead.org, yamada.masahiro@socionext.com,
        yaojun8558363@gmail.com, ysato@users.sourceforge.jp,
        yuzhao@google.com
Subject:  [patch 3/4] mm/memory_hotplug: don't access uninitialized
 memmaps in shrink_zone_span()
Message-ID: <20191122015356.2g-fSbCJ0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: don't access uninitialized memmaps in shrink_zone_span()

Let's limit shrinking to !ZONE_DEVICE so we can fix the current code.  We
should never try to touch the memmap of offline sections where we could
have uninitialized memmaps and could trigger BUGs when calling
page_to_nid() on poisoned pages.

There is no reliable way to distinguish an uninitialized memmap from an
initialized memmap that belongs to ZONE_DEVICE, as we don't have anything
like SECTION_IS_ONLINE we can use similar to pfn_to_online_section() for
!ZONE_DEVICE memory.  E.g., set_zone_contiguous() similarly relies on
pfn_to_online_section() and will therefore never set a ZONE_DEVICE zone
consecutive.  Stopping to shrink the ZONE_DEVICE therefore results in no
observable changes, besides /proc/zoneinfo indicating different boundaries
- something we can totally live with.

Before commit d0dc12e86b31 ("mm/memory_hotplug: optimize memory hotplug"),
the memmap was initialized with 0 and the node with the right value.  So
the zone might be wrong but not garbage.  After that commit, both the zone
and the node will be garbage when touching uninitialized memmaps.



Toshiki reported a BUG (race between delayed initialization of
ZONE_DEVICE memmaps without holding the memory hotplug lock and
concurrent zone shrinking).

https://lkml.org/lkml/2019/11/14/1040

"Iteration of create and destroy namespace causes the panic as below:

[   41.207694] kernel BUG at mm/page_alloc.c:535!
[   41.208109] invalid opcode: 0000 [#1] SMP PTI
[   41.208508] CPU: 7 PID: 2766 Comm: ndctl Not tainted 5.4.0-rc4 #6
[   41.209064] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
[   41.210175] RIP: 0010:set_pfnblock_flags_mask+0x95/0xf0
[   41.210643] Code: 04 41 83 e2 3c 48 8d 04 a8 48 c1 e0 07 48 03 04 dd e0 59 55 bb 48 8b 58 68 48 39 da 73 0e 48 c7 c6 70 ac 11 bb e8 1b b2 fd ff <0f> 0b 48 03 58 78 48 39 da 73 e9 49 01 ca b9 3f 00 00 00 4f 8d 0c
[   41.212354] RSP: 0018:ffffac0d41557c80 EFLAGS: 00010246
[   41.212821] RAX: 000000000000004a RBX: 0000000000244a00 RCX: 0000000000000000
[   41.213459] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffbb1197dc
[   41.214100] RBP: 000000000000000c R08: 0000000000000439 R09: 0000000000000059
[   41.214736] R10: 0000000000000000 R11: ffffac0d41557b08 R12: ffff8be475ea72b0
[   41.215376] R13: 000000000000fa00 R14: 0000000000250000 R15: 00000000fffc0bb5
[   41.216008] FS:  00007f30862ab600(0000) GS:ffff8be57bc40000(0000) knlGS:0000000000000000
[   41.216771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.217299] CR2: 000055e824d0d508 CR3: 0000000231dac000 CR4: 00000000000006e0
[   41.217934] Call Trace:
[   41.218225]  memmap_init_zone_device+0x165/0x17c
[   41.218642]  memremap_pages+0x4c1/0x540
[   41.218989]  devm_memremap_pages+0x1d/0x60
[   41.219367]  pmem_attach_disk+0x16b/0x600 [nd_pmem]
[   41.219804]  ? devm_nsio_enable+0xb8/0xe0
[   41.220172]  nvdimm_bus_probe+0x69/0x1c0
[   41.220526]  really_probe+0x1c2/0x3e0
[   41.220856]  driver_probe_device+0xb4/0x100
[   41.221238]  device_driver_attach+0x4f/0x60
[   41.221611]  bind_store+0xc9/0x110
[   41.221919]  kernfs_fop_write+0x116/0x190
[   41.222326]  vfs_write+0xa5/0x1a0
[   41.222626]  ksys_write+0x59/0xd0
[   41.222927]  do_syscall_64+0x5b/0x180
[   41.223264]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   41.223714] RIP: 0033:0x7f30865d0ed8
[   41.224037] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 45 78 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[   41.225920] RSP: 002b:00007fffe5d30a78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   41.226608] RAX: ffffffffffffffda RBX: 000055e824d07f40 RCX: 00007f30865d0ed8
[   41.227242] RDX: 0000000000000007 RSI: 000055e824d07f40 RDI: 0000000000000004
[   41.227870] RBP: 0000000000000007 R08: 0000000000000007 R09: 0000000000000006
[   41.228753] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
[   41.229419] R13: 00007f30862ab528 R14: 0000000000000001 R15: 000055e824d07f40

While creating a namespace and initializing memmap, if you destroy the
namespace and shrink the zone, it will initialize the memmap outside
the zone and trigger VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page),
pfn), page) in set_pfnblock_flags_mask()."

This BUG is also mitigated by this commit, where we for now stop to
shrink the ZONE_DEVICE zone until we can do it in a safe and clean way.

Link: http://lkml.kernel.org/r/20191006085646.5768-5-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Damian Tometzki <damian.tometzki@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Rich Felker <dalias@libc.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-dont-access-uninitialized-memmaps-in-shrink_zone_span
+++ a/mm/memory_hotplug.c
@@ -331,7 +331,7 @@ static unsigned long find_smallest_secti
 				     unsigned long end_pfn)
 {
 	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(start_pfn)))
+		if (unlikely(!pfn_to_online_page(start_pfn)))
 			continue;
 
 		if (unlikely(pfn_to_nid(start_pfn) != nid))
@@ -356,7 +356,7 @@ static unsigned long find_biggest_sectio
 	/* pfn is the end pfn of a memory section. */
 	pfn = end_pfn - 1;
 	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
 		if (unlikely(pfn_to_nid(pfn) != nid))
@@ -415,7 +415,7 @@ static void shrink_zone_span(struct zone
 	 */
 	pfn = zone_start_pfn;
 	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
 		if (page_zone(pfn_to_page(pfn)) != zone)
@@ -471,6 +471,16 @@ static void __remove_zone(struct zone *z
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long flags;
 
+#ifdef CONFIG_ZONE_DEVICE
+	/*
+	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
+	 * we will not try to shrink the zones - which is okay as
+	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 */
+	if (zone_idx(zone) == ZONE_DEVICE)
+		return;
+#endif
+
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
_
