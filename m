Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4598A231FA
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbfETLJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:09:19 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45607 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfETLJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 07:09:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 879CE2B008;
        Mon, 20 May 2019 07:09:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 May 2019 07:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vo+sSI
        6kYPC2+bzm39HRqa65xWo+ypktHrxqV5kHmzI=; b=OnbBGfRyPP1XM5+ZgEVmiy
        Pfdqj5LdRmJxLdLGFL5FO62kX8341JRSdmxfVLHEJ+SVJyYM8LRNrndIXsxv9h7p
        4PX8knMXf0yNAECN7kHKQsJFVFz7v6jRAUZf9s21+BdPQx8DwLllPFYWy5TXzJAP
        xbDw3fAfcQDK+VqeZB+w4B3B24bp29vyOO/MOOX1MtMpFcdKzFwiD6cqfO9BMZz/
        T4IGHie9zaJBdxU5drM7K7nLAFyIJKfW0DS6lJYCeHkLweiO5m2dY7MNStOPS+Qe
        nPngwRGM/7Nf6jywplhEb+hH47TMEf0Q53nowZpJzX7I0yv0ifIkz/RroLu201+A
        ==
X-ME-Sender: <xms:3oriXMNVu7R34inJlzfxzaBFkCy_G0LDgSp0HJ4bqxhRT1Qz1yS0NA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:3oriXMitYskCaYKxwVWWBZAYRwth368hoaabt0iaKUvQL_0uU6Ih2Q>
    <xmx:3oriXOuQEumOMVj7ZqBu3ooBUd6Sg0G-SxUX9LqlGhUXd_uxRBzTDw>
    <xmx:3oriXDYXIE2V47r-K4cFQJqZAMfUhnL84vZVeQShicBAklFW9f_OaQ>
    <xmx:3oriXAW34ciPH1qFQr6z6in76TZnVo30ZBmfyLKF_1uDCidl9pR7bQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E33E1103CB;
        Mon, 20 May 2019 07:09:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/mm: convert to the generic get_user_pages_fast code" failed to apply to 4.19-stable tree
To:     schwidefsky@de.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 13:09:15 +0200
Message-ID: <1558350555229156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1a42010cdc26bb7e5912984f3c91b8c6d55f089a Mon Sep 17 00:00:00 2001
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Tue, 23 Apr 2019 10:53:21 +0200
Subject: [PATCH] s390/mm: convert to the generic get_user_pages_fast code

Define the gup_fast_permitted to check against the asce_limit of the
mm attached to the current task, then replace the s390 specific gup
code with the generic implementation in mm/gup.c.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 566f0b460d21..1c3fcf19c3af 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -149,6 +149,7 @@ config S390
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
+	select HAVE_GENERIC_GUP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index d48be9c27df9..394bec31cb97 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1265,6 +1265,18 @@ static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
 
+static inline bool gup_fast_permitted(unsigned long start, int nr_pages)
+{
+	unsigned long len, end;
+
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
+	if (end < start)
+		return false;
+	return end <= current->mm->context.asce_limit;
+}
+#define gup_fast_permitted gup_fast_permitted
+
 #define pfn_pte(pfn,pgprot) mk_pte_phys(__pa((pfn) << PAGE_SHIFT),(pgprot))
 #define pte_pfn(x) (pte_val(x) >> PAGE_SHIFT)
 #define pte_page(x) pfn_to_page(pte_pfn(x))
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index f5880bfd1b0c..3175413186b9 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-y		:= init.o fault.o extmem.o mmap.o vmem.o maccess.o
-obj-y		+= page-states.o gup.o pageattr.o pgtable.o pgalloc.o
+obj-y		+= page-states.o pageattr.o pgtable.o pgalloc.o
 
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
deleted file mode 100644
index a5ffcb132191..000000000000
--- a/arch/s390/mm/gup.c
+++ /dev/null
@@ -1,291 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  Lockless get_user_pages_fast for s390
- *
- *  Copyright IBM Corp. 2010
- *  Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
- */
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/hugetlb.h>
-#include <linux/vmstat.h>
-#include <linux/pagemap.h>
-#include <linux/rwsem.h>
-#include <asm/pgtable.h>
-
-/*
- * The performance critical leaf functions are made noinline otherwise gcc
- * inlines everything into a single function which results in too much
- * register pressure.
- */
-static inline int gup_pte_range(pmd_t pmd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	struct page *head, *page;
-	unsigned long mask;
-	pte_t *ptep, pte;
-
-	mask = (write ? _PAGE_PROTECT : 0) | _PAGE_INVALID | _PAGE_SPECIAL;
-
-	ptep = pte_offset_map(&pmd, addr);
-	do {
-		pte = *ptep;
-		barrier();
-		/* Similar to the PMD case, NUMA hinting must take slow path */
-		if (pte_protnone(pte))
-			return 0;
-		if ((pte_val(pte) & mask) != 0)
-			return 0;
-		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
-		page = pte_page(pte);
-		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
-			return 0;
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
-			put_page(head);
-			return 0;
-		}
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-		pages[*nr] = page;
-		(*nr)++;
-
-	} while (ptep++, addr += PAGE_SIZE, addr != end);
-
-	return 1;
-}
-
-static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	struct page *head, *page;
-	unsigned long mask;
-	int refs;
-
-	mask = (write ? _SEGMENT_ENTRY_PROTECT : 0) | _SEGMENT_ENTRY_INVALID;
-	if ((pmd_val(pmd) & mask) != 0)
-		return 0;
-	VM_BUG_ON(!pfn_valid(pmd_val(pmd) >> PAGE_SHIFT));
-
-	refs = 0;
-	head = pmd_page(pmd);
-	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	do {
-		VM_BUG_ON(compound_head(page) != head);
-		pages[*nr] = page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr += PAGE_SIZE, addr != end);
-
-	if (!page_cache_add_speculative(head, refs)) {
-		*nr -= refs;
-		return 0;
-	}
-
-	if (unlikely(pmd_val(pmd) != pmd_val(*pmdp))) {
-		*nr -= refs;
-		while (refs--)
-			put_page(head);
-		return 0;
-	}
-
-	return 1;
-}
-
-
-static inline int gup_pmd_range(pud_t pud, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	unsigned long next;
-	pmd_t *pmdp, pmd;
-
-	pmdp = pmd_offset(&pud, addr);
-	do {
-		pmd = *pmdp;
-		barrier();
-		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd))
-			return 0;
-		if (unlikely(pmd_large(pmd))) {
-			/*
-			 * NUMA hinting faults need to be handled in the GUP
-			 * slowpath for accounting purposes and so that they
-			 * can be serialised against THP migration.
-			 */
-			if (pmd_protnone(pmd))
-				return 0;
-			if (!gup_huge_pmd(pmdp, pmd, addr, next,
-					  write, pages, nr))
-				return 0;
-		} else if (!gup_pte_range(pmd, addr, next,
-					  write, pages, nr))
-			return 0;
-	} while (pmdp++, addr = next, addr != end);
-
-	return 1;
-}
-
-static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	struct page *head, *page;
-	unsigned long mask;
-	int refs;
-
-	mask = (write ? _REGION_ENTRY_PROTECT : 0) | _REGION_ENTRY_INVALID;
-	if ((pud_val(pud) & mask) != 0)
-		return 0;
-	VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
-
-	refs = 0;
-	head = pud_page(pud);
-	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-		pages[*nr] = page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr += PAGE_SIZE, addr != end);
-
-	if (!page_cache_add_speculative(head, refs)) {
-		*nr -= refs;
-		return 0;
-	}
-
-	if (unlikely(pud_val(pud) != pud_val(*pudp))) {
-		*nr -= refs;
-		while (refs--)
-			put_page(head);
-		return 0;
-	}
-
-	return 1;
-}
-
-static inline int gup_pud_range(p4d_t p4d, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	unsigned long next;
-	pud_t *pudp, pud;
-
-	pudp = pud_offset(&p4d, addr);
-	do {
-		pud = *pudp;
-		barrier();
-		next = pud_addr_end(addr, end);
-		if (pud_none(pud))
-			return 0;
-		if (unlikely(pud_large(pud))) {
-			if (!gup_huge_pud(pudp, pud, addr, next, write, pages,
-					  nr))
-				return 0;
-		} else if (!gup_pmd_range(pud, addr, next, write, pages,
-					  nr))
-			return 0;
-	} while (pudp++, addr = next, addr != end);
-
-	return 1;
-}
-
-static inline int gup_p4d_range(pgd_t pgd, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	unsigned long next;
-	p4d_t *p4dp, p4d;
-
-	p4dp = p4d_offset(&pgd, addr);
-	do {
-		p4d = *p4dp;
-		barrier();
-		next = p4d_addr_end(addr, end);
-		if (p4d_none(p4d))
-			return 0;
-		if (!gup_pud_range(p4d, addr, next, write, pages, nr))
-			return 0;
-	} while (p4dp++, addr = next, addr != end);
-
-	return 1;
-}
-
-/*
- * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
- * back to the regular GUP.
- * Note a difference with get_user_pages_fast: this always returns the
- * number of pages pinned, 0 if no pages were pinned.
- */
-int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			  struct page **pages)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
-	unsigned long next, flags;
-	pgd_t *pgdp, pgd;
-	int nr = 0;
-
-	start &= PAGE_MASK;
-	addr = start;
-	len = (unsigned long) nr_pages << PAGE_SHIFT;
-	end = start + len;
-	if ((end <= start) || (end > mm->context.asce_limit))
-		return 0;
-	/*
-	 * local_irq_save() doesn't prevent pagetable teardown, but does
-	 * prevent the pagetables from being freed on s390.
-	 *
-	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
-	 */
-	local_irq_save(flags);
-	pgdp = pgd_offset(mm, addr);
-	do {
-		pgd = *pgdp;
-		barrier();
-		next = pgd_addr_end(addr, end);
-		if (pgd_none(pgd))
-			break;
-		if (!gup_p4d_range(pgd, addr, next, write, pages, &nr))
-			break;
-	} while (pgdp++, addr = next, addr != end);
-	local_irq_restore(flags);
-
-	return nr;
-}
-
-/**
- * get_user_pages_fast() - pin user pages in memory
- * @start:	starting user address
- * @nr_pages:	number of pages from start to pin
- * @write:	whether pages will be written to
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long.
- *
- * Attempt to pin user pages in memory without taking mm->mmap_sem.
- * If not successful, it will fall back to taking the lock and
- * calling get_user_pages().
- *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno.
- */
-int get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			struct page **pages)
-{
-	int nr, ret;
-
-	might_sleep();
-	start &= PAGE_MASK;
-	nr = __get_user_pages_fast(start, nr_pages, write, pages);
-	if (nr == nr_pages)
-		return nr;
-
-	/* Try to get the remaining pages with get_user_pages */
-	start += nr << PAGE_SHIFT;
-	pages += nr;
-	ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
-				      write ? FOLL_WRITE : 0);
-	/* Have to be a bit careful with return values */
-	if (nr > 0)
-		ret = (ret < 0) ? nr : ret + nr;
-	return ret;
-}

