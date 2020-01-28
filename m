Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB414B20A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA1JvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgA1JvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPmAsJVmWgTHFDXtzWx64QwzgVZuqBt2C+7HcqIVcJc=;
        b=S2+JdVfOeGbIBM30xEpa0lDuple8UUj8RK9vVmVk5fFVoUpJQ9uxxjXwVIb5dSPHw4pm9k
        ztsdnunzifPQ4rbDIqDXddyow78Hj/dywh+T6uKyhHjivvtyGvstiVAdk2x3RtE341MoGX
        J9vt5eO0C99SIrNBNJ463WG3ceCwvWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-q11lAtR4PmWIy3S8XQFV7g-1; Tue, 28 Jan 2020 04:51:02 -0500
X-MC-Unique: q11lAtR4PmWIy3S8XQFV7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B1658017CC;
        Tue, 28 Jan 2020 09:51:01 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01E0B60BE0;
        Tue, 28 Jan 2020 09:50:58 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 12/24] mm/memory_hotplug: make __remove_pages() and arch_remove_memory() never fail
Date:   Tue, 28 Jan 2020 10:50:09 +0100
Message-Id: <20200128095021.8076-13-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ac5c94264580f498e484c854031d0226b3c1038f upstream.

-- snip --

Minor conflict in arch/powerpc/mm/mem.c

-- snip --

All callers of arch_remove_memory() ignore errors.  And we should really
try to remove any errors from the memory removal path.  No more errors ar=
e
reported from __remove_pages().  BUG() in s390x code in case
arch_remove_memory() is triggered.  We may implement that properly later.
WARN in case powerpc code failed to remove the section mapping, which is
better than ignoring the error completely right now.

Link: http://lkml.kernel.org/r/20190409100148.24703-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/ia64/mm/init.c            | 11 +++--------
 arch/powerpc/mm/mem.c          |  9 +++------
 arch/s390/mm/init.c            |  5 +++--
 arch/sh/mm/init.c              | 11 +++--------
 arch/x86/mm/init_32.c          |  5 +++--
 arch/x86/mm/init_64.c          | 10 +++-------
 include/linux/memory_hotplug.h |  8 ++++----
 mm/memory_hotplug.c            |  5 ++---
 8 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index b54d0ee74b53..950a9e0a4548 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -662,20 +662,15 @@ int arch_add_memory(int nid, u64 start, u64 size, s=
truct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
 	struct zone *zone;
-	int ret;
=20
 	zone =3D page_zone(pfn_to_page(start_pfn));
-	ret =3D __remove_pages(zone, start_pfn, nr_pages, altmap);
-	if (ret)
-		pr_warn("%s: Problem encountered in __remove_pages() as"
-			" ret=3D%d\n", __func__,  ret);
-
-	return ret;
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 625d78547fe7..ab79f2831f9c 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -140,7 +140,7 @@ int __ref arch_add_memory(int nid, u64 start, u64 siz=
e, struct vmem_altmap *altm
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __ref arch_remove_memory(int nid, u64 start, u64 size,
+void __ref arch_remove_memory(int nid, u64 start, u64 size,
 			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
@@ -156,14 +156,13 @@ int __ref arch_remove_memory(int nid, u64 start, u6=
4 size,
 	if (altmap)
 		page +=3D vmem_altmap_offset(altmap);
=20
-	ret =3D __remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
-	if (ret)
-		return ret;
+	__remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
=20
 	/* Remove htab bolted mappings for this section of memory */
 	start =3D (unsigned long)__va(start);
 	flush_inval_dcache_range(start, start + size);
 	ret =3D remove_section_mapping(start, start + size);
+	WARN_ON_ONCE(ret);
=20
 	/* Ensure all vmalloc mappings are flushed in case they also
 	 * hit that section of memory
@@ -171,8 +170,6 @@ int __ref arch_remove_memory(int nid, u64 start, u64 =
size,
 	vm_unmap_aliases();
=20
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
-
-	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index bc49b560625e..0da486d914e4 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -240,14 +240,15 @@ int arch_add_memory(int nid, u64 start, u64 size, s=
truct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	/*
 	 * There is no hardware or firmware interface which could trigger a
 	 * hot memory remove on s390. So there is nothing that needs to be
 	 * implemented.
 	 */
-	return -EBUSY;
+	BUG();
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 5c91bb6abc35..59ae5d7dc081 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -444,20 +444,15 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D PFN_DOWN(start);
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
 	struct zone *zone;
-	int ret;
=20
 	zone =3D page_zone(pfn_to_page(start_pfn));
-	ret =3D __remove_pages(zone, start_pfn, nr_pages, altmap);
-	if (unlikely(ret))
-		pr_warn("%s: Failed, __remove_pages() =3D=3D %d\n", __func__,
-			ret);
-
-	return ret;
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9fa503f2f56c..c6a50a0f240b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -861,14 +861,15 @@ int arch_add_memory(int nid, u64 start, u64 size, s=
truct vmem_altmap *altmap,
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap =
*altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
 	struct zone *zone;
=20
 	zone =3D page_zone(pfn_to_page(start_pfn));
-	return __remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32066d5dc9af..b9e15f25b921 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1142,24 +1142,20 @@ kernel_physical_mapping_remove(unsigned long star=
t, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
=20
-int __ref arch_remove_memory(int nid, u64 start, u64 size,
-				struct vmem_altmap *altmap)
+void __ref arch_remove_memory(int nid, u64 start, u64 size,
+			      struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn =3D start >> PAGE_SHIFT;
 	unsigned long nr_pages =3D size >> PAGE_SHIFT;
 	struct page *page =3D pfn_to_page(start_pfn);
 	struct zone *zone;
-	int ret;
=20
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page +=3D vmem_altmap_offset(altmap);
 	zone =3D page_zone(page);
-	ret =3D __remove_pages(zone, start_pfn, nr_pages, altmap);
-	WARN_ON_ONCE(ret);
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
-
-	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index df77a7597aba..04c40da0228a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -109,10 +109,10 @@ static inline bool movable_node_is_enabled(void)
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int arch_remove_memory(int nid, u64 start, u64 size,
-				struct vmem_altmap *altmap);
-extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void arch_remove_memory(int nid, u64 start, u64 size,
+			       struct vmem_altmap *altmap);
+extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
+			   unsigned long nr_pages, struct vmem_altmap *altmap);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 /* reasonably generic interface to expand the physical pages */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a9fcae50a33a..7905e3275289 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -509,8 +509,8 @@ static void __remove_section(struct zone *zone, struc=
t mem_section *ms,
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
-		 unsigned long nr_pages, struct vmem_altmap *altmap)
+void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+		    unsigned long nr_pages, struct vmem_altmap *altmap)
 {
 	unsigned long i;
 	unsigned long map_offset =3D 0;
@@ -541,7 +541,6 @@ int __remove_pages(struct zone *zone, unsigned long p=
hys_start_pfn,
 	}
=20
 	set_zone_contiguous(zone);
-	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
--=20
2.24.1

