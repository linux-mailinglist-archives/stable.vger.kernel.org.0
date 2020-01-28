Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8949414B93D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgA1O30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733283AbgA1O30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059FB20716;
        Tue, 28 Jan 2020 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221765;
        bh=HFhmV/HKV9aCser5rs1DVz4NhpEaXn7uDj7uLe4G3HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lw1rAqFvIFbkGrHiR2DeSCoOULo88AD34pEeo3EYi6eh9uRUgKesJDNoONY3IOr5p
         EuY6LG/AAF+eBzZvW3lCQk0FBMdOidZsXPEOTx6tw862sDhCrlzzgok6TTO4XzXlLC
         D9avwCdPsoKw1DY8WVi+YyDqJ2KbvtLEphksp9Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 73/92] mm, memory_hotplug: add nid parameter to arch_remove_memory
Date:   Tue, 28 Jan 2020 15:08:41 +0100
Message-Id: <20200128135818.772522977@linuxfoundation.org>
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

From: Oscar Salvador <osalvador@suse.com>

commit 2c2a5af6fed20cf74401c9d64319c76c5ff81309 upstream.

-- snip --

Missing unification of mm/hmm.c and kernel/memremap.c

-- snip --

Patch series "Do not touch pages in hot-remove path", v2.

This patchset aims for two things:

 1) A better definition about offline and hot-remove stage
 2) Solving bugs where we can access non-initialized pages
    during hot-remove operations [2] [3].

This is achieved by moving all page/zone handling to the offline
stage, so we do not need to access pages when hot-removing memory.

[1] https://patchwork.kernel.org/cover/10691415/
[2] https://patchwork.kernel.org/patch/10547445/
[3] https://www.spinics.net/lists/linux-mm/msg161316.html

This patch (of 5):

This is a preparation for the following-up patches.  The idea of passing
the nid is that it will allow us to get rid of the zone parameter
afterwards.

Link: http://lkml.kernel.org/r/20181127162005.15833-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/mm/init.c            |    2 +-
 arch/powerpc/mm/mem.c          |    3 ++-
 arch/s390/mm/init.c            |    2 +-
 arch/sh/mm/init.c              |    2 +-
 arch/x86/mm/init_32.c          |    2 +-
 arch/x86/mm/init_64.c          |    3 ++-
 include/linux/memory_hotplug.h |    4 ++--
 kernel/memremap.c              |    5 ++++-
 mm/hmm.c                       |    4 +++-
 mm/memory_hotplug.c            |    2 +-
 10 files changed, 18 insertions(+), 11 deletions(-)

--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -662,7 +662,7 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -140,7 +140,8 @@ int __meminit arch_add_memory(int nid, u
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __meminit arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int __meminit arch_remove_memory(int nid, u64 start, u64 size,
+					struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -240,7 +240,7 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	/*
 	 * There is no hardware or firmware interface which could trigger a
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -444,7 +444,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 #endif
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -861,7 +861,7 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1142,7 +1142,8 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-int __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int __ref arch_remove_memory(int nid, u64 start, u64 size,
+				struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -109,8 +109,8 @@ static inline bool movable_node_is_enabl
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int arch_remove_memory(u64 start, u64 size,
-		struct vmem_altmap *altmap);
+extern int arch_remove_memory(int nid, u64 start, u64 size,
+				struct vmem_altmap *altmap);
 extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages, struct vmem_altmap *altmap);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -121,6 +121,7 @@ static void devm_memremap_pages_release(
 	struct resource *res = &pgmap->res;
 	resource_size_t align_start, align_size;
 	unsigned long pfn;
+	int nid;
 
 	pgmap->kill(pgmap->ref);
 	for_each_device_pfn(pfn, pgmap)
@@ -131,13 +132,15 @@ static void devm_memremap_pages_release(
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
 
+	nid = page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
+
 	mem_hotplug_begin();
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		pfn = align_start >> PAGE_SHIFT;
 		__remove_pages(page_zone(pfn_to_page(pfn)), pfn,
 				align_size >> PAGE_SHIFT, NULL);
 	} else {
-		arch_remove_memory(align_start, align_size,
+		arch_remove_memory(nid, align_start, align_size,
 				pgmap->altmap_valid ? &pgmap->altmap : NULL);
 		kasan_remove_zero_shadow(__va(align_start), align_size);
 	}
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -999,6 +999,7 @@ static void hmm_devmem_release(void *dat
 	unsigned long start_pfn, npages;
 	struct zone *zone;
 	struct page *page;
+	int nid;
 
 	/* pages are dead and unused, undo the arch mapping */
 	start_pfn = (resource->start & ~(PA_SECTION_SIZE - 1)) >> PAGE_SHIFT;
@@ -1006,12 +1007,13 @@ static void hmm_devmem_release(void *dat
 
 	page = pfn_to_page(start_pfn);
 	zone = page_zone(page);
+	nid = page_to_nid(page);
 
 	mem_hotplug_begin();
 	if (resource->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY)
 		__remove_pages(zone, start_pfn, npages, NULL);
 	else
-		arch_remove_memory(start_pfn << PAGE_SHIFT,
+		arch_remove_memory(nid, start_pfn << PAGE_SHIFT,
 				   npages << PAGE_SHIFT, NULL);
 	mem_hotplug_done();
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1916,7 +1916,7 @@ void __ref __remove_memory(int nid, u64
 	memblock_free(start, size);
 	memblock_remove(start, size);
 
-	arch_remove_memory(start, size, NULL);
+	arch_remove_memory(nid, start, size, NULL);
 
 	try_offline_node(nid);
 


