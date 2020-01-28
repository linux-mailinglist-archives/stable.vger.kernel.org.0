Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBD14B20D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgA1JvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:51:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgA1JvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jq/hk/mYwy3jtadjMsBWqSAUq0105izCjsUsvQg8vgw=;
        b=RkPqvBqaOFx3xdHfBITvDtYnkoNm+gHiKqH5lYiHC4uuGXQ6eF6eSXttTn3J2vBwEYSSnl
        6G45X5hXsUqE+nHpars8h1moXycUZFT2Q6nZFc2w4smA/aGIuLsKNMZrG69V1rCGr/bKU8
        SNVWNOuuQ3lJ9tyPnflrW32MnC9L0R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-4HhcOxkWPkGjVjAQYkZqCA-1; Tue, 28 Jan 2020 04:51:11 -0500
X-MC-Unique: 4HhcOxkWPkGjVjAQYkZqCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BFF2800D4E;
        Tue, 28 Jan 2020 09:51:10 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10B5E60BE0;
        Tue, 28 Jan 2020 09:51:07 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 14/24] mm/memory_hotplug: allow arch_remove_memory() without CONFIG_MEMORY_HOTREMOVE
Date:   Tue, 28 Jan 2020 10:50:11 +0100
Message-Id: <20200128095021.8076-15-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 80ec922dbd87fd38d15719c86a94457204648aeb upstream.

-- snip --

Missing arm64 memory hot(un)plug support.

-- snip --

We want to improve error handling while adding memory by allowing to use
arch_remove_memory() and __remove_pages() even if
CONFIG_MEMORY_HOTREMOVE is not set to e.g., implement something like:

	arch_add_memory()
	rc =3D do_something();
	if (rc) {
		arch_remove_memory();
	}

We won't get rid of CONFIG_MEMORY_HOTREMOVE for now, as it will require
quite some dependencies for memory offlining.

Link: http://lkml.kernel.org/r/20190527111152.16324-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "mike.travis@hpe.com" <mike.travis@hpe.com>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/ia64/mm/init.c            | 2 --
 arch/powerpc/mm/mem.c          | 2 --
 arch/s390/mm/init.c            | 2 --
 arch/sh/mm/init.c              | 2 --
 arch/x86/mm/init_32.c          | 2 --
 arch/x86/mm/init_64.c          | 2 --
 drivers/base/memory.c          | 2 --
 include/linux/memory.h         | 2 --
 include/linux/memory_hotplug.h | 2 --
 mm/memory_hotplug.c            | 2 --
 mm/sparse.c                    | 6 ------
 11 files changed, 26 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 950a9e0a4548..778781e5f22e 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -661,7 +661,6 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 	return ret;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void arch_remove_memory(int nid, u64 start, u64 size,
 			struct vmem_altmap *altmap)
 {
@@ -673,4 +672,3 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
-#endif
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index ab79f2831f9c..84c6d37638a7 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -139,7 +139,6 @@ int __ref arch_add_memory(int nid, u64 start, u64 siz=
e, struct vmem_altmap *altm
 	return __add_pages(nid, start_pfn, nr_pages, altmap, want_memblock);
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void __ref arch_remove_memory(int nid, u64 start, u64 size,
 			     struct vmem_altmap *altmap)
 {
@@ -172,7 +171,6 @@ void __ref arch_remove_memory(int nid, u64 start, u64=
 size,
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
 }
 #endif
-#endif /* CONFIG_MEMORY_HOTPLUG */
=20
 /*
  * walk_memory_resource() needs to make sure there is no holes in a give=
n
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index fc761001fa94..e0b0788cfecb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -239,7 +239,6 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 	return rc;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void arch_remove_memory(int nid, u64 start, u64 size,
 			struct vmem_altmap *altmap)
 {
@@ -251,5 +250,4 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 	__remove_pages(zone, start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
-#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 59ae5d7dc081..0da784ac0e34 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -443,7 +443,6 @@ int memory_add_physaddr_to_nid(u64 addr)
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void arch_remove_memory(int nid, u64 start, u64 size,
 			struct vmem_altmap *altmap)
 {
@@ -454,5 +453,4 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 	zone =3D page_zone(pfn_to_page(start_pfn));
 	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
-#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c6a50a0f240b..64f54f77052b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -860,7 +860,6 @@ int arch_add_memory(int nid, u64 start, u64 size, str=
uct vmem_altmap *altmap,
 	return __add_pages(nid, start_pfn, nr_pages, altmap, want_memblock);
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void arch_remove_memory(int nid, u64 start, u64 size,
 			struct vmem_altmap *altmap)
 {
@@ -872,7 +871,6 @@ void arch_remove_memory(int nid, u64 start, u64 size,
 	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
-#endif
=20
 int kernel_set_to_readonly __read_mostly;
=20
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b9e15f25b921..50df7ca142f9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1132,7 +1132,6 @@ void __ref vmemmap_free(unsigned long start, unsign=
ed long end,
 	remove_pagetable(start, end, false, altmap);
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1157,7 +1156,6 @@ void __ref arch_remove_memory(int nid, u64 start, u=
64 size,
 	__remove_pages(zone, start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
-#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
=20
 static struct kcore_list kcore_vsyscall;
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5b9950d982dc..9a5f81dc32c5 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -737,7 +737,6 @@ int hotplug_memory_register(int nid, struct mem_secti=
on *section)
 	return ret;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static void
 unregister_memory(struct memory_block *memory)
 {
@@ -776,7 +775,6 @@ void unregister_memory_section(struct mem_section *se=
ction)
 out_unlock:
 	mutex_unlock(&mem_sysfs_mutex);
 }
-#endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 /* return true if the memory block is offlined, otherwise, return false =
*/
 bool is_memblock_offlined(struct memory_block *mem)
diff --git a/include/linux/memory.h b/include/linux/memory.h
index e1dc1bb2b787..474c7c60c8f2 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -112,9 +112,7 @@ extern void unregister_memory_notifier(struct notifie=
r_block *nb);
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb=
);
 int hotplug_memory_register(int nid, struct mem_section *section);
-#ifdef CONFIG_MEMORY_HOTREMOVE
 extern void unregister_memory_section(struct mem_section *);
-#endif
 extern int memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 04c40da0228a..5ac58325e8fc 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -108,12 +108,10 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 extern void arch_remove_memory(int nid, u64 start, u64 size,
 			       struct vmem_altmap *altmap);
 extern void __remove_pages(struct zone *zone, unsigned long start_pfn,
 			   unsigned long nr_pages, struct vmem_altmap *altmap);
-#endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long n=
r_pages,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7905e3275289..6b5ce0bd907f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -315,7 +315,6 @@ int __ref __add_pages(int nid, unsigned long phys_sta=
rt_pfn,
 	return err;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
 static unsigned long find_smallest_section_pfn(int nid, struct zone *zon=
e,
 				     unsigned long start_pfn,
@@ -542,7 +541,6 @@ void __remove_pages(struct zone *zone, unsigned long =
phys_start_pfn,
=20
 	set_zone_contiguous(zone);
 }
-#endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 int set_online_page_callback(online_page_callback_t callback)
 {
diff --git a/mm/sparse.c b/mm/sparse.c
index f52e8c328761..6f624ce9252e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -576,7 +576,6 @@ static void __kfree_section_memmap(struct page *memma=
p,
=20
 	vmemmap_free(start, end, altmap);
 }
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start =3D (unsigned long)memmap;
@@ -584,7 +583,6 @@ static void free_map_bootmem(struct page *memmap)
=20
 	vmemmap_free(start, end, NULL);
 }
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #else
 static struct page *__kmalloc_section_memmap(void)
 {
@@ -623,7 +621,6 @@ static void __kfree_section_memmap(struct page *memma=
p,
 			   get_order(sizeof(struct page) * PAGES_PER_SECTION));
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
@@ -653,7 +650,6 @@ static void free_map_bootmem(struct page *memmap)
 			put_page_bootmem(page);
 	}
 }
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
=20
 /*
@@ -712,7 +708,6 @@ int __meminit sparse_add_one_section(int nid, unsigne=
d long start_pfn,
 	return ret;
 }
=20
-#ifdef CONFIG_MEMORY_HOTREMOVE
 #ifdef CONFIG_MEMORY_FAILURE
 static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 {
@@ -780,5 +775,4 @@ void sparse_remove_one_section(struct zone *zone, str=
uct mem_section *ms,
 			PAGES_PER_SECTION - map_offset);
 	free_section_usemap(memmap, usemap, altmap);
 }
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
--=20
2.24.1

