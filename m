Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6975D14B205
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgA1Ju4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:50:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44027 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726114AbgA1Juz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WfLiWsQcA4JkQS1gdzJHEfdlgygWSRbtgs+Yw5M+ulU=;
        b=S+eG8bB5/TZlY0z6I1E59YkYpAoTqXS9yIeJqjYsrK5tOPT+oMTF9XyQqshU/akcx4tBhr
        hX/jsAyMNoFrsKq/PnfsG6NBxEbnBQUQorYbv90xl4MTBmcOYNdE68mo/jdAi6RcyfWOl+
        aTfQsuB16MD/WGKaFbqZCJrk5OuBowA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-a59YhwH5NHi4NOTQL2HnEw-1; Tue, 28 Jan 2020 04:50:42 -0500
X-MC-Unique: a59YhwH5NHi4NOTQL2HnEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EB6E18FF662;
        Tue, 28 Jan 2020 09:50:40 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3559B60C05;
        Tue, 28 Jan 2020 09:50:38 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 05/24] mm, memory_hotplug: add nid parameter to arch_remove_memory
Date:   Tue, 28 Jan 2020 10:50:02 +0100
Message-Id: <20200128095021.8076-6-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
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
---
 arch/ia64/mm/init.c            | 2 +-
 arch/powerpc/mm/mem.c          | 3 ++-
 arch/s390/mm/init.c            | 2 +-
 arch/sh/mm/init.c              | 2 +-
 arch/x86/mm/init_32.c          | 2 +-
 arch/x86/mm/init_64.c          | 3 ++-
 include/linux/memory_hotplug.h | 4 ++--
 kernel/memremap.c              | 5 ++++-
 mm/hmm.c                       | 4 +++-
 mm/memory_hotplug.c            | 2 +-
 10 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 3b85c3ecac38..b54d0ee74b53 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -662,7 +662,7 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 9a6afd9f3f9b..1b6e0ef5d14d 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -140,7 +140,8 @@ int __meminit arch_add_memory(int nid, u64 start, u64=
 size, struct vmem_altmap *
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __meminit arch_remove_memory(u64 start, u64 size, struct vmem_altmap=
 *altmap)
+int __meminit arch_remove_memory(int nid, u64 start, u64 size,
+					struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 3fa3e5323612..bc49b560625e 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -240,7 +240,7 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
 {
 	/*
 	 * There is no hardware or firmware interface which could trigger a
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 7713c084d040..5c91bb6abc35 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -444,7 +444,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
 {
 	unsigned long start_pfn =3D PFN_DOWN(start);
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 979e0a02cbe1..9fa503f2f56c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -861,7 +861,7 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a3e9c6ee3cf2..32066d5dc9af 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1142,7 +1142,8 @@ kernel_physical_mapping_remove(unsigned long start,=
 unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
=20
-int __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *al=
tmap)
+int __ref arch_remove_memory(int nid, u64 start, u64 size,
+				struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 008e5281e7d7..df77a7597aba 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -109,8 +109,8 @@ static inline bool movable_node_is_enabled(void)
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int arch_remove_memory(u64 start, u64 size,
-		struct vmem_altmap *altmap);
+extern int arch_remove_memory(int nid, u64 start, u64 size,
+				struct vmem_altmap *altmap);
 extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages, struct vmem_altmap *altmap);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 7c5fb8a208ac..2ee2e672d5fc 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -121,6 +121,7 @@ static void devm_memremap_pages_release(void *data)
 	struct resource *res =3D &pgmap->res;
 	resource_size_t align_start, align_size;
 	unsigned long pfn;
+	int nid;
=20
 	pgmap->kill(pgmap->ref);
 	for_each_device_pfn(pfn, pgmap)
@@ -131,13 +132,15 @@ static void devm_memremap_pages_release(void *data)
 	align_size =3D ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
=20
+	nid =3D page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
+
 	mem_hotplug_begin();
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
 		pfn =3D align_start >> PAGE_SHIFT;
 		__remove_pages(page_zone(pfn_to_page(pfn)), pfn,
 				align_size >> PAGE_SHIFT, NULL);
 	} else {
-		arch_remove_memory(align_start, align_size,
+		arch_remove_memory(nid, align_start, align_size,
 				pgmap->altmap_valid ? &pgmap->altmap : NULL);
 		kasan_remove_zero_shadow(__va(align_start), align_size);
 	}
diff --git a/mm/hmm.c b/mm/hmm.c
index 57f0d2a4ff34..ae1f6ad46d30 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -999,6 +999,7 @@ static void hmm_devmem_release(void *data)
 	unsigned long start_pfn, npages;
 	struct zone *zone;
 	struct page *page;
+	int nid;
=20
 	/* pages are dead and unused, undo the arch mapping */
 	start_pfn =3D (resource->start & ~(PA_SECTION_SIZE - 1)) >> PAGE_SHIFT;
@@ -1006,12 +1007,13 @@ static void hmm_devmem_release(void *data)
=20
 	page =3D pfn_to_page(start_pfn);
 	zone =3D page_zone(page);
+	nid =3D page_to_nid(page);
=20
 	mem_hotplug_begin();
 	if (resource->desc =3D=3D IORES_DESC_DEVICE_PRIVATE_MEMORY)
 		__remove_pages(zone, start_pfn, npages, NULL);
 	else
-		arch_remove_memory(start_pfn << PAGE_SHIFT,
+		arch_remove_memory(nid, start_pfn << PAGE_SHIFT,
 				   npages << PAGE_SHIFT, NULL);
 	mem_hotplug_done();
=20
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c109e3f0bc16..a51e5ffdaa04 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1916,7 +1916,7 @@ void __ref __remove_memory(int nid, u64 start, u64 =
size)
 	memblock_free(start, size);
 	memblock_remove(start, size);
=20
-	arch_remove_memory(start, size, NULL);
+	arch_remove_memory(nid, start, size, NULL);
=20
 	try_offline_node(nid);
=20
--=20
2.24.1

