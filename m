Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DA214B939
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgA1O27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387574AbgA1O24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD47724688;
        Tue, 28 Jan 2020 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221735;
        bh=iDbiMnwGeER9BGZgyvwx353y1l2xxOoG5Wc/YUwcUJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSXZ+xdKQtyk56sQVisOHNMMjeWXBZB5R99dnx8EQNlPJkTFxf1zc4xl5+MYqYxKT
         p4avVio+DZsIjLGblLfWJjU7LTOX62dxhXdxwd71cIaaKKn4wZfnhr0dSiZ0oMKV/7
         N4lRseZKCTxy23Iaubf88neGQsV4ElsaKTLSS3aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rashmica Gupta <rashmica.g@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Michael Neuling <mikey@neuling.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>,
        Mathieu Malaterre <malat@debian.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Juergen Gross <jgross@suse.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 69/92] mm/memory_hotplug: make remove_memory() take the device_hotplug_lock
Date:   Tue, 28 Jan 2020 15:08:37 +0100
Message-Id: <20200128135818.210482948@linuxfoundation.org>
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
would e.g.  have to take the mem_hotplug_lock in device/base/core.c, which
sounds wrong.

Summary: We had a lock inversion on mem_hotplug_lock and device_lock().
More details can be found in patch 3 and patch 6.

I propose the general rules (documentation added in patch 6):

1. add_memory/add_memory_resource() must only be called with
   device_hotplug_lock.
2. remove_memory() must only be called with device_hotplug_lock. This is
   already documented and holds for all callers.
3. device_online()/device_offline() must only be called with
   device_hotplug_lock. This is already documented and true for now in core
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/memtrace.c       |    2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |    6 +++---
 drivers/acpi/acpi_memhotplug.c                  |    2 +-
 include/linux/memory_hotplug.h                  |    3 ++-
 mm/memory_hotplug.c                             |    9 ++++++++-
 5 files changed, 15 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -122,7 +122,7 @@ static u64 memtrace_alloc_node(u32 nid,
 			 */
 			end_pfn = base_pfn + nr_pages;
 			for (pfn = base_pfn; pfn < end_pfn; pfn += bytes>> PAGE_SHIFT) {
-				remove_memory(nid, pfn << PAGE_SHIFT, bytes);
+				__remove_memory(nid, pfn << PAGE_SHIFT, bytes);
 			}
 			unlock_device_hotplug();
 			return base_pfn << PAGE_SHIFT;
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -301,7 +301,7 @@ static int pseries_remove_memblock(unsig
 	nid = memory_add_physaddr_to_nid(base);
 
 	for (i = 0; i < sections_per_block; i++) {
-		remove_memory(nid, base, MIN_MEMORY_BLOCK_SIZE);
+		__remove_memory(nid, base, MIN_MEMORY_BLOCK_SIZE);
 		base += MIN_MEMORY_BLOCK_SIZE;
 	}
 
@@ -393,7 +393,7 @@ static int dlpar_remove_lmb(struct drmem
 	block_sz = pseries_memory_block_size();
 	nid = memory_add_physaddr_to_nid(lmb->base_addr);
 
-	remove_memory(nid, lmb->base_addr, block_sz);
+	__remove_memory(nid, lmb->base_addr, block_sz);
 
 	/* Update memory regions for memory remove */
 	memblock_remove(lmb->base_addr, block_sz);
@@ -680,7 +680,7 @@ static int dlpar_add_lmb(struct drmem_lm
 
 	rc = dlpar_online_lmb(lmb);
 	if (rc) {
-		remove_memory(nid, lmb->base_addr, block_sz);
+		__remove_memory(nid, lmb->base_addr, block_sz);
 		invalidate_lmb_associativity_index(lmb);
 	} else {
 		lmb->flags |= DRCONF_MEM_ASSIGNED;
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -282,7 +282,7 @@ static void acpi_memory_remove_memory(st
 			nid = memory_add_physaddr_to_nid(info->start_addr);
 
 		acpi_unbind_memory_blocks(info);
-		remove_memory(nid, info->start_addr, info->length);
+		__remove_memory(nid, info->start_addr, info->length);
 		list_del(&info->list);
 		kfree(info);
 	}
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -303,6 +303,7 @@ extern bool is_mem_section_removable(uns
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern void remove_memory(int nid, u64 start, u64 size);
+extern void __remove_memory(int nid, u64 start, u64 size);
 
 #else
 static inline bool is_mem_section_removable(unsigned long pfn,
@@ -319,6 +320,7 @@ static inline int offline_pages(unsigned
 }
 
 static inline void remove_memory(int nid, u64 start, u64 size) {}
+static inline void __remove_memory(int nid, u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern void __ref free_area_init_core_hotplug(int nid);
@@ -333,7 +335,6 @@ extern void move_pfn_range_to_zone(struc
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern void remove_memory(int nid, u64 start, u64 size);
 extern int sparse_add_one_section(struct pglist_data *pgdat,
 		unsigned long start_pfn, struct vmem_altmap *altmap);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
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
 
@@ -1922,5 +1922,12 @@ void __ref remove_memory(int nid, u64 st
 
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


