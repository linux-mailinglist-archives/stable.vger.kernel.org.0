Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3999A14B1FD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgA1Jug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:50:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43972 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgA1Jug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoiHHeUIEfbcdwNvi4DAnQk4D+sJ+U+HwJ73oXNEYN4=;
        b=dCfGr6a0xD15kgErMUYEAhane5i6nfoQ9nUajLk/8ralk80HxByXZXjhkHEP4p9yLSJMLK
        Ste2TxR+ieFzlcaAqDMXVu87ad+Slt73ACZ1pqYOtEEYGwyXNy1apBFq6sv3xb3DE3jX9R
        cAhjE7Yr0QGc5pfoph+E5hW1hZ3AY+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-rryUkx73NbWhZBfyqdTKpw-1; Tue, 28 Jan 2020 04:50:30 -0500
X-MC-Unique: rryUkx73NbWhZBfyqdTKpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 342D1107ACC4;
        Tue, 28 Jan 2020 09:50:29 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FCA160C05;
        Tue, 28 Jan 2020 09:50:24 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 01/24] mm/memory_hotplug: make remove_memory() take the device_hotplug_lock
Date:   Tue, 28 Jan 2020 10:49:58 +0100
Message-Id: <20200128095021.8076-2-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d15e59260f62bd5e0f625cf5f5240f6ffac78ab6 upstream.

Patch series "mm: online/offline_pages called w.o. mem_hotplug_lock", v3.

Reading through the code and studying how mem_hotplug_lock is to be used,
I noticed that there are two places where we can end up calling
device_online()/device_offline() - online_pages()/offline_pages() without
the mem_hotplug_lock.  And there are other places where we call
device_online()/device_offline() without the device_hotplug_lock.

While e.g.
	echo "online" > /sys/devices/system/memory/memory9/state
is fine, e.g.
	echo 1 > /sys/devices/system/memory/memory9/online
Will not take the mem_hotplug_lock. However the device_lock() and
device_hotplug_lock.

E.g.  via memory_probe_store(), we can end up calling
add_memory()->online_pages() without the device_hotplug_lock.  So we can
have concurrent callers in online_pages().  We e.g.  touch in
online_pages() basically unprotected zone->present_pages then.

Looks like there is a longer history to that (see Patch #2 for details),
and fixing it to work the way it was intended is not really possible.  We
would e.g.  have to take the mem_hotplug_lock in device/base/core.c, whic=
h
sounds wrong.

Summary: We had a lock inversion on mem_hotplug_lock and device_lock().
More details can be found in patch 3 and patch 6.

I propose the general rules (documentation added in patch 6):

1. add_memory/add_memory_resource() must only be called with
   device_hotplug_lock.
2. remove_memory() must only be called with device_hotplug_lock. This is
   already documented and holds for all callers.
3. device_online()/device_offline() must only be called with
   device_hotplug_lock. This is already documented and true for now in co=
re
   code. Other callers (related to memory hotplug) have to be fixed up.
4. mem_hotplug_lock is taken inside of add_memory/remove_memory/
   online_pages/offline_pages.

To me, this looks way cleaner than what we have right now (and easier to
verify).  And looking at the documentation of remove_memory, using
lock_device_hotplug also for add_memory() feels natural.

This patch (of 6):

remove_memory() is exported right now but requires the
device_hotplug_lock, which is not exported.  So let's provide a variant
that takes the lock and only export that one.

The lock is already held in
	arch/powerpc/platforms/pseries/hotplug-memory.c
	drivers/acpi/acpi_memhotplug.c
	arch/powerpc/platforms/powernv/memtrace.c

Apart from that, there are not other users in the tree.

Link: http://lkml.kernel.org/r/20180925091457.28651-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Rashmica Gupta <rashmica.g@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Rashmica Gupta <rashmica.g@gmail.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/powernv/memtrace.c       | 2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c | 6 +++---
 drivers/acpi/acpi_memhotplug.c                  | 2 +-
 include/linux/memory_hotplug.h                  | 3 ++-
 mm/memory_hotplug.c                             | 9 ++++++++-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/pla=
tforms/powernv/memtrace.c
index dd3cc4632b9a..84d038ed3882 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -122,7 +122,7 @@ static u64 memtrace_alloc_node(u32 nid, u64 size)
 			 */
 			end_pfn =3D base_pfn + nr_pages;
 			for (pfn =3D base_pfn; pfn < end_pfn; pfn +=3D bytes>> PAGE_SHIFT) {
-				remove_memory(nid, pfn << PAGE_SHIFT, bytes);
+				__remove_memory(nid, pfn << PAGE_SHIFT, bytes);
 			}
 			unlock_device_hotplug();
 			return base_pfn << PAGE_SHIFT;
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/power=
pc/platforms/pseries/hotplug-memory.c
index 62d3c72cd931..c2c6f32848e1 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -301,7 +301,7 @@ static int pseries_remove_memblock(unsigned long base=
, unsigned int memblock_siz
 	nid =3D memory_add_physaddr_to_nid(base);
=20
 	for (i =3D 0; i < sections_per_block; i++) {
-		remove_memory(nid, base, MIN_MEMORY_BLOCK_SIZE);
+		__remove_memory(nid, base, MIN_MEMORY_BLOCK_SIZE);
 		base +=3D MIN_MEMORY_BLOCK_SIZE;
 	}
=20
@@ -393,7 +393,7 @@ static int dlpar_remove_lmb(struct drmem_lmb *lmb)
 	block_sz =3D pseries_memory_block_size();
 	nid =3D memory_add_physaddr_to_nid(lmb->base_addr);
=20
-	remove_memory(nid, lmb->base_addr, block_sz);
+	__remove_memory(nid, lmb->base_addr, block_sz);
=20
 	/* Update memory regions for memory remove */
 	memblock_remove(lmb->base_addr, block_sz);
@@ -680,7 +680,7 @@ static int dlpar_add_lmb(struct drmem_lmb *lmb)
=20
 	rc =3D dlpar_online_lmb(lmb);
 	if (rc) {
-		remove_memory(nid, lmb->base_addr, block_sz);
+		__remove_memory(nid, lmb->base_addr, block_sz);
 		invalidate_lmb_associativity_index(lmb);
 	} else {
 		lmb->flags |=3D DRCONF_MEM_ASSIGNED;
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplu=
g.c
index 2ccfbb61ca89..8fe0960ea572 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -282,7 +282,7 @@ static void acpi_memory_remove_memory(struct acpi_mem=
ory_device *mem_device)
 			nid =3D memory_add_physaddr_to_nid(info->start_addr);
=20
 		acpi_unbind_memory_blocks(info);
-		remove_memory(nid, info->start_addr, info->length);
+		__remove_memory(nid, info->start_addr, info->length);
 		list_del(&info->list);
 		kfree(info);
 	}
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 4915e6cd7fd5..6f13a5a33b51 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -303,6 +303,7 @@ extern bool is_mem_section_removable(unsigned long pf=
n, unsigned long nr_pages);
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages=
);
 extern void remove_memory(int nid, u64 start, u64 size);
+extern void __remove_memory(int nid, u64 start, u64 size);
=20
 #else
 static inline bool is_mem_section_removable(unsigned long pfn,
@@ -319,6 +320,7 @@ static inline int offline_pages(unsigned long start_p=
fn, unsigned long nr_pages)
 }
=20
 static inline void remove_memory(int nid, u64 start, u64 size) {}
+static inline void __remove_memory(int nid, u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 extern void __ref free_area_init_core_hotplug(int nid);
@@ -333,7 +335,6 @@ extern void move_pfn_range_to_zone(struct zone *zone,=
 unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages=
);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern void remove_memory(int nid, u64 start, u64 size);
 extern int sparse_add_one_section(struct pglist_data *pgdat,
 		unsigned long start_pfn, struct vmem_altmap *altmap);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_sect=
ion *ms,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 413f6709039a..e2e2cf7014ee 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1893,7 +1893,7 @@ EXPORT_SYMBOL(try_offline_node);
  * and online/offline operations before this call, as required by
  * try_offline_node().
  */
-void __ref remove_memory(int nid, u64 start, u64 size)
+void __ref __remove_memory(int nid, u64 start, u64 size)
 {
 	int ret;
=20
@@ -1922,5 +1922,12 @@ void __ref remove_memory(int nid, u64 start, u64 s=
ize)
=20
 	mem_hotplug_done();
 }
+
+void remove_memory(int nid, u64 start, u64 size)
+{
+	lock_device_hotplug();
+	__remove_memory(nid, start, size);
+	unlock_device_hotplug();
+}
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
--=20
2.24.1

