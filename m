Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6216114B215
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgA1Jvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgA1Jvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7MB7oUPUx8XhDuAF7Akvb1jkOAALGY6qLQV69vnf48=;
        b=BhWefdQCNktLHfv8sxBHTRWm9D4ShXZNiBxIwpWdRL6Pu7o4XTJZxC0XstUksNz6MWHJ2E
        4QvFuLNwjA8Agze/+BqC1rLhJiGZSFOPhtQvgOU5w9iJSAq4cPmC8wT1mVBROBcuG+2GsZ
        3iTVbKGznkBTHykj+6XeWz/fjiemjuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-Y6JgBZm6MNKFx3yGnqpUkA-1; Tue, 28 Jan 2020 04:51:44 -0500
X-MC-Unique: Y6JgBZm6MNKFx3yGnqpUkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43EEA8010DA;
        Tue, 28 Jan 2020 09:51:43 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1132160BE0;
        Tue, 28 Jan 2020 09:51:40 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 22/24] mm/memunmap: don't access uninitialized memmap in memunmap_pages()
Date:   Tue, 28 Jan 2020 10:50:19 +0100
Message-Id: <20200128095021.8076-23-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 77e080e7680e1e615587352f70c87b9e98126d03 upstream.

-- snip --

- Missing mm/hmm.c and kernel/memremap.c unification.
-- hmm code does not need fixes (no altmap)
- Missing 7cc7867fb061 ("mm/devm_memremap_pages: enable sub-section remap=
")

-- snip --

Patch series "mm/memory_hotplug: Shrink zones before removing memory",
v6.

This series fixes the access of uninitialized memmaps when shrinking
zones/nodes and when removing memory.  Also, it contains all fixes for
crashes that can be triggered when removing certain namespace using
memunmap_pages() - ZONE_DEVICE, reported by Aneesh.

We stop trying to shrink ZONE_DEVICE, as it's buggy, fixing it would be
more involved (we don't have SECTION_IS_ONLINE as an indicator), and
shrinking is only of limited use (set_zone_contiguous() cannot detect
the ZONE_DEVICE as contiguous).

We continue shrinking !ZONE_DEVICE zones, however, I reduced the amount
of code to a minimum.  Shrinking is especially necessary to keep
zone->contiguous set where possible, especially, on memory unplug of
DIMMs at zone boundaries.

-------------------------------------------------------------------------=
-

Zones are now properly shrunk when offlining memory blocks or when
onlining failed.  This allows to properly shrink zones on memory unplug
even if the separate memory blocks of a DIMM were onlined to different
zones or re-onlined to a different zone after offlining.

Example:

  :/# cat /proc/zoneinfo
  Node 1, zone  Movable
          spanned  0
          present  0
          managed  0
  :/# echo "online_movable" > /sys/devices/system/memory/memory41/state
  :/# echo "online_movable" > /sys/devices/system/memory/memory43/state
  :/# cat /proc/zoneinfo
  Node 1, zone  Movable
          spanned  98304
          present  65536
          managed  65536
  :/# echo 0 > /sys/devices/system/memory/memory43/online
  :/# cat /proc/zoneinfo
  Node 1, zone  Movable
          spanned  32768
          present  32768
          managed  32768
  :/# echo 0 > /sys/devices/system/memory/memory41/online
  :/# cat /proc/zoneinfo
  Node 1, zone  Movable
          spanned  0
          present  0
          managed  0

This patch (of 10):

With an altmap, the memmap falling into the reserved altmap space are not
initialized and, therefore, contain a garbage NID and a garbage zone.
Make sure to read the NID/zone from a memmap that was initialized.

This fixes a kernel crash that is observed when destroying a namespace:

  kernel BUG at include/linux/mm.h:1107!
  cpu 0x1: Vector: 700 (Program Check) at [c000000274087890]
      pc: c0000000004b9728: memunmap_pages+0x238/0x340
      lr: c0000000004b9724: memunmap_pages+0x234/0x340
  ...
      pid   =3D 3669, comm =3D ndctl
  kernel BUG at include/linux/mm.h:1107!
    devm_action_release+0x30/0x50
    release_nodes+0x268/0x2d0
    device_release_driver_internal+0x174/0x240
    unbind_store+0x13c/0x190
    drv_attr_store+0x44/0x60
    sysfs_kf_write+0x70/0xa0
    kernfs_fop_write+0x1ac/0x290
    __vfs_write+0x3c/0x70
    vfs_write+0xe4/0x200
    ksys_write+0x7c/0x140
    system_call+0x5c/0x68

The "page_zone(pfn_to_page(pfn)" was introduced by 69324b8f4833 ("mm,
devm_memremap_pages: add MEMORY_DEVICE_PRIVATE support"), however, I
think we will never have driver reserved memory with
MEMORY_DEVICE_PRIVATE (no altmap AFAIKS).

[david@redhat.com: minimze code changes, rephrase description]
Link: http://lkml.kernel.org/r/20191006085646.5768-2-david@redhat.com
Fixes: 2c2a5af6fed2 ("mm, memory_hotplug: add nid parameter to arch_remov=
e_memory")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Damian Tometzki <damian.tometzki@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
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
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/memremap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 2ee2e672d5fc..1ec1f8fd97f5 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -120,6 +120,7 @@ static void devm_memremap_pages_release(void *data)
 	struct device *dev =3D pgmap->dev;
 	struct resource *res =3D &pgmap->res;
 	resource_size_t align_start, align_size;
+	struct page *first_page;
 	unsigned long pfn;
 	int nid;
=20
@@ -132,13 +133,16 @@ static void devm_memremap_pages_release(void *data)
 	align_size =3D ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
=20
-	nid =3D page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
+	/* make sure to access a memmap that was actually initialized */
+	first_page =3D pfn_to_page(pfn_first(pgmap));
+
+	nid =3D page_to_nid(first_page);
=20
 	mem_hotplug_begin();
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
 		pfn =3D align_start >> PAGE_SHIFT;
-		__remove_pages(page_zone(pfn_to_page(pfn)), pfn,
-				align_size >> PAGE_SHIFT, NULL);
+		__remove_pages(page_zone(first_page), pfn,
+			       align_size >> PAGE_SHIFT, NULL);
 	} else {
 		arch_remove_memory(nid, align_start, align_size,
 				pgmap->altmap_valid ? &pgmap->altmap : NULL);
--=20
2.24.1

