Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395EE14B949
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgA1O35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgA1O3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC41524690;
        Tue, 28 Jan 2020 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221785;
        bh=W4VAAy0WrCD4RSg8yRI6X/Eamei/83tO7n5kzYUUbvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMqJqvBH+UyLQHtEbH0eA/Ky8ywGygYJ3MZ1sBTzaHhz07pdm+aAlL1WRL60TflMb
         27382k5K+OFoZYcqWMLdn2DaZLWmSkiKbpqcKtY+ra8G+gSOkJPzZ10JbuU++eKwq7
         fd7suw+Sby+uZCfeMrFMNTjgi9VjsGv9VTucRVKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Stefan Agner <stefan@agner.ch>,
        Nicholas Piggin <npiggin@gmail.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arun KS <arunks@codeaurora.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Wei Yang <richard.weiyang@gmail.com>, Qian Cai <cai@lca.pw>,
        Mathieu Malaterre <malat@debian.org>,
        Andrew Banman <andrew.banman@hpe.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mike Travis <mike.travis@hpe.com>,
        Oscar Salvador <osalvador@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 80/92] mm/memory_hotplug: make __remove_pages() and arch_remove_memory() never fail
Date:   Tue, 28 Jan 2020 15:08:48 +0100
Message-Id: <20200128135819.719552669@linuxfoundation.org>
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

commit ac5c94264580f498e484c854031d0226b3c1038f upstream.

-- snip --

Minor conflict in arch/powerpc/mm/mem.c

-- snip --

All callers of arch_remove_memory() ignore errors.  And we should really
try to remove any errors from the memory removal path.  No more errors are
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/mm/init.c            |   11 +++--------
 arch/powerpc/mm/mem.c          |    9 +++------
 arch/s390/mm/init.c            |    5 +++--
 arch/sh/mm/init.c              |   11 +++--------
 arch/x86/mm/init_32.c          |    5 +++--
 arch/x86/mm/init_64.c          |   10 +++-------
 include/linux/memory_hotplug.h |    8 ++++----
 mm/memory_hotplug.c            |    5 ++---
 8 files changed, 24 insertions(+), 40 deletions(-)

--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -662,20 +662,15 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
-	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
-	ret = __remove_pages(zone, start_pfn, nr_pages, altmap);
-	if (ret)
-		pr_warn("%s: Problem encountered in __remove_pages() as"
-			" ret=%d\n", __func__,  ret);
-
-	return ret;
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -140,7 +140,7 @@ int __ref arch_add_memory(int nid, u64 s
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __ref arch_remove_memory(int nid, u64 start, u64 size,
+void __ref arch_remove_memory(int nid, u64 start, u64 size,
 			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
@@ -156,14 +156,13 @@ int __ref arch_remove_memory(int nid, u6
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
 
-	ret = __remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
-	if (ret)
-		return ret;
+	__remove_pages(page_zone(page), start_pfn, nr_pages, altmap);
 
 	/* Remove htab bolted mappings for this section of memory */
 	start = (unsigned long)__va(start);
 	flush_inval_dcache_range(start, start + size);
 	ret = remove_section_mapping(start, start + size);
+	WARN_ON_ONCE(ret);
 
 	/* Ensure all vmalloc mappings are flushed in case they also
 	 * hit that section of memory
@@ -171,8 +170,6 @@ int __ref arch_remove_memory(int nid, u6
 	vm_unmap_aliases();
 
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
-
-	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -240,14 +240,15 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
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
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -444,20 +444,15 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 #endif
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
-	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
-	ret = __remove_pages(zone, start_pfn, nr_pages, altmap);
-	if (unlikely(ret))
-		pr_warn("%s: Failed, __remove_pages() == %d\n", __func__,
-			ret);
-
-	return ret;
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -861,14 +861,15 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(int nid, u64 start, u64 size,
+			struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 
 	zone = page_zone(pfn_to_page(start_pfn));
-	return __remove_pages(zone, start_pfn, nr_pages, altmap);
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 }
 #endif
 #endif
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1142,24 +1142,20 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-int __ref arch_remove_memory(int nid, u64 start, u64 size,
-				struct vmem_altmap *altmap)
+void __ref arch_remove_memory(int nid, u64 start, u64 size,
+			      struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct page *page = pfn_to_page(start_pfn);
 	struct zone *zone;
-	int ret;
 
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
 	zone = page_zone(page);
-	ret = __remove_pages(zone, start_pfn, nr_pages, altmap);
-	WARN_ON_ONCE(ret);
+	__remove_pages(zone, start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
-
-	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -109,10 +109,10 @@ static inline bool movable_node_is_enabl
 }
 
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
 
 /* reasonably generic interface to expand the physical pages */
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -509,8 +509,8 @@ static void __remove_section(struct zone
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
-		 unsigned long nr_pages, struct vmem_altmap *altmap)
+void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+		    unsigned long nr_pages, struct vmem_altmap *altmap)
 {
 	unsigned long i;
 	unsigned long map_offset = 0;
@@ -541,7 +541,6 @@ int __remove_pages(struct zone *zone, un
 	}
 
 	set_zone_contiguous(zone);
-	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 


