Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7503626B817
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIPAgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbgIPAgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 20:36:15 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 215482078E;
        Wed, 16 Sep 2020 00:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600216570;
        bh=/FjpwMazlryP1/fZjXhNwEHhm4imm7WYgs/BQnDa1zE=;
        h=Date:From:To:Subject:From;
        b=tJgD4o5Oq48L0aHCbgRFpnB4s7/UNRtQAsCvN+dbH4uU0syIEpT25zwavLHhZILvx
         lclJqzffeqZSe5esGcktzLFZV2JHSrwzruYmb/ekONijNV4c961fIsCnxlQ5LS5dHy
         4FQ2X9SvLCUQnezC6FH0Z5kbppYZ9FxLHX/SgfAc=
Date:   Tue, 15 Sep 2020 17:36:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, rppt@linux.ibm.com, richard@nod.at,
        peterz@infradead.org, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, linux@armlinux.org.uk,
        jgg@nvidia.com, jdike@addtoit.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        dave.hansen@linux.intel.com, dave.hansen@intel.com,
        catalin.marinas@arm.com, bp@alien8.de, borntraeger@de.ibm.com,
        benh@kernel.crashing.org, aryabinin@virtuozzo.com, arnd@arndb.de,
        agordeev@linux.ibm.com, gor@linux.ibm.com
Subject:  + mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
 added to -mm tree
Message-ID: <20200916003608.ib4Ln%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/gup: fix gup_fast with dynamic page table folding
has been added to the -mm tree.  Its filename is
     mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Gorbik <gor@linux.ibm.com>
Subject: mm/gup: fix gup_fast with dynamic page table folding

Currently to make sure that every page table entry is read just once
gup_fast walks perform READ_ONCE and pass pXd value down to the next
gup_pXd_range function by value e.g.:

static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
                         unsigned int flags, struct page **pages, int *nr)
...
        pudp = pud_offset(&p4d, addr);

This function passes a reference on that local value copy to pXd_offset,
and might get the very same pointer in return.  This happens when the
level is folded (on most arches), and that pointer should not be iterated.

On s390 due to the fact that each task might have different 5,4 or 3-level
address translation and hence different levels folded the logic is more
complex and non-iteratable pointer to a local copy leads to severe
problems.

Here is an example of what happens with gup_fast on s390, for a task with
3-levels paging, crossing a 2 GB pud boundary:

// addr = 0x1007ffff000, end = 0x10080001000
static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
                         unsigned int flags, struct page **pages, int *nr)
{
        unsigned long next;
        pud_t *pudp;

        // pud_offset returns &p4d itself (a pointer to a value on stack)
        pudp = pud_offset(&p4d, addr);
        do {
                // on second iteratation reading "random" stack value
                pud_t pud = READ_ONCE(*pudp);

                // next = 0x10080000000, due to PUD_SIZE/MASK != PGDIR_SIZE/MASK on s390
                next = pud_addr_end(addr, end);
                ...
        } while (pudp++, addr = next, addr != end); // pudp++ iterating over stack

        return 1;
}

This happens since s390 moved to common gup code with commit d1874a0c2805
("s390/mm: make the pxd_offset functions more robust") and commit
1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code").
s390 tried to mimic static level folding by changing pXd_offset
primitives to always calculate top level page table offset in pgd_offset
and just return the value passed when pXd_offset has to act as folded.

What is crucial for gup_fast and what has been overlooked is that
PxD_SIZE/MASK and thus pXd_addr_end should also change correspondingly. 
And the latter is not possible with dynamic folding.

To fix the issue in addition to pXd values pass original pXdp pointers
down to gup_pXd_range functions.  And introduce pXd_offset_lockless
helpers, which take an additional pXd entry value parameter.  This has
already been discussed in
https://lkml.kernel.org/r/20190418100218.0a4afd51@mschwideX1

Link: https://lkml.kernel.org/r/patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours
Fixes: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |   42 +++++++++++++++++++++---------
 include/linux/pgtable.h         |   10 +++++++
 mm/gup.c                        |   18 ++++++------
 3 files changed, 49 insertions(+), 21 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
+++ a/arch/s390/include/asm/pgtable.h
@@ -1260,26 +1260,44 @@ static inline pgd_t *pgd_offset_raw(pgd_
 
 #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
 
-static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long address)
 {
-	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
-		return (p4d_t *) pgd_deref(*pgd) + p4d_index(address);
-	return (p4d_t *) pgd;
+	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
+		return (p4d_t *) pgd_deref(pgd) + p4d_index(address);
+	return (p4d_t *) pgdp;
 }
+#define p4d_offset_lockless p4d_offset_lockless
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address)
 {
-	if ((p4d_val(*p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
-		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
-	return (pud_t *) p4d;
+	return p4d_offset_lockless(pgdp, *pgdp, address);
+}
+
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long address)
+{
+	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
+		return (pud_t *) p4d_deref(p4d) + pud_index(address);
+	return (pud_t *) p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
+static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
+{
+	return pud_offset_lockless(p4dp, *p4dp, address);
 }
 #define pud_offset pud_offset
 
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud, unsigned long address)
+{
+	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
+		return (pmd_t *) pud_deref(pud) + pmd_index(address);
+	return (pmd_t *) pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
+static inline pmd_t *pmd_offset(pud_t *pudp, unsigned long address)
 {
-	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
-		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
-	return (pmd_t *) pud;
+	return pmd_offset_lockless(pudp, *pudp, address);
 }
 #define pmd_offset pmd_offset
 
--- a/include/linux/pgtable.h~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
+++ a/include/linux/pgtable.h
@@ -1427,6 +1427,16 @@ typedef unsigned int pgtbl_mod_mask;
 #define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
 #endif
 
+#ifndef p4d_offset_lockless
+#define p4d_offset_lockless(pgdp, pgd, address) p4d_offset(&(pgd), address)
+#endif
+#ifndef pud_offset_lockless
+#define pud_offset_lockless(p4dp, p4d, address) pud_offset(&(p4d), address)
+#endif
+#ifndef pmd_offset_lockless
+#define pmd_offset_lockless(pudp, pud, address) pmd_offset(&(pud), address)
+#endif
+
 /*
  * p?d_leaf() - true if this entry is a final mapping to a physical address.
  * This differs from p?d_huge() by the fact that they are always available (if
--- a/mm/gup.c~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
+++ a/mm/gup.c
@@ -2485,13 +2485,13 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	return 1;
 }
 
-static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
+static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
 
-	pmdp = pmd_offset(&pud, addr);
+	pmdp = pmd_offset_lockless(pudp, pud, addr);
 	do {
 		pmd_t pmd = READ_ONCE(*pmdp);
 
@@ -2528,13 +2528,13 @@ static int gup_pmd_range(pud_t pud, unsi
 	return 1;
 }
 
-static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
+static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
 
-	pudp = pud_offset(&p4d, addr);
+	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
 		pud_t pud = READ_ONCE(*pudp);
 
@@ -2549,20 +2549,20 @@ static int gup_pud_range(p4d_t p4d, unsi
 			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
 					 PUD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
+		} else if (!gup_pmd_range(pudp, pud, addr, next, flags, pages, nr))
 			return 0;
 	} while (pudp++, addr = next, addr != end);
 
 	return 1;
 }
 
-static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
+static int gup_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp;
 
-	p4dp = p4d_offset(&pgd, addr);
+	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
 		p4d_t p4d = READ_ONCE(*p4dp);
 
@@ -2574,7 +2574,7 @@ static int gup_p4d_range(pgd_t pgd, unsi
 			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
 					 P4D_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pud_range(p4d, addr, next, flags, pages, nr))
+		} else if (!gup_pud_range(p4dp, p4d, addr, next, flags, pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -2602,7 +2602,7 @@ static void gup_pgd_range(unsigned long
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
 					 PGDIR_SHIFT, next, flags, pages, nr))
 				return;
-		} else if (!gup_p4d_range(pgd, addr, next, flags, pages, nr))
+		} else if (!gup_p4d_range(pgdp, pgd, addr, next, flags, pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
_

Patches currently in -mm which might be from gor@linux.ibm.com are

mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch

