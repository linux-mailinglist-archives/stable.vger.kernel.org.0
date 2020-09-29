Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B3827C786
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgI2Lyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730426AbgI2Lp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25016208B8;
        Tue, 29 Sep 2020 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379948;
        bh=GF3zCaaAQ+Px9QviReQ6k0DJF3kb91Az1R7zRNbO1JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBsYLsdfG2QMyk83dgXF9hHhC4QU/1/7VQ0WH08wCDBRkGu/AnoHjMYUXucS2iaHG
         1xZ/HOA7bVPH94R3ot0A11vwT2XvhJdHwT7yBmji0rwMGj4ggs2qCwRAQxqtMfVNnE
         t2wufKLudvhbb1z/vPBLmZIDGVkSNti9780w6VRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.4 381/388] mm/gup: fix gup_fast with dynamic page table folding
Date:   Tue, 29 Sep 2020 13:01:52 +0200
Message-Id: <20200929110028.907409108@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit d3f7b1bb204099f2f7306318896223e8599bb6a2 upstream.

Currently to make sure that every page table entry is read just once
gup_fast walks perform READ_ONCE and pass pXd value down to the next
gup_pXd_range function by value e.g.:

  static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
                           unsigned int flags, struct page **pages, int *nr)
  ...
          pudp = pud_offset(&p4d, addr);

This function passes a reference on that local value copy to pXd_offset,
and might get the very same pointer in return.  This happens when the
level is folded (on most arches), and that pointer should not be
iterated.

On s390 due to the fact that each task might have different 5,4 or
3-level address translation and hence different levels folded the logic
is more complex and non-iteratable pointer to a local copy leads to
severe problems.

Here is an example of what happens with gup_fast on s390, for a task
with 3-level paging, crossing a 2 GB pud boundary:

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

This happens since s390 moved to common gup code with commit
d1874a0c2805 ("s390/mm: make the pxd_offset functions more robust") and
commit 1a42010cdc26 ("s390/mm: convert to the generic
get_user_pages_fast code").

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

Fixes: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
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
Link: https://lkml.kernel.org/r/patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |   44 +++++++++++++++++++++++++++++-----------
 include/asm-generic/pgtable.h   |   10 +++++++++
 mm/gup.c                        |   18 ++++++++--------
 3 files changed, 51 insertions(+), 21 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1247,26 +1247,46 @@ static inline pgd_t *pgd_offset_raw(pgd_
 #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
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
 }
 
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long address)
 {
-	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
-		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
-	return (pmd_t *) pud;
+	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
+		return (pud_t *) p4d_deref(p4d) + pud_index(address);
+	return (pud_t *) p4dp;
 }
+#define pud_offset_lockless pud_offset_lockless
+
+static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
+{
+	return pud_offset_lockless(p4dp, *p4dp, address);
+}
+#define pud_offset pud_offset
+
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud, unsigned long address)
+{
+	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
+		return (pmd_t *) pud_deref(pud) + pmd_index(address);
+	return (pmd_t *) pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
+static inline pmd_t *pmd_offset(pud_t *pudp, unsigned long address)
+{
+	return pmd_offset_lockless(pudp, *pudp, address);
+}
+#define pmd_offset pmd_offset
 
 static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
 {
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1171,6 +1171,16 @@ static inline bool arch_has_pfn_modify_c
 #endif
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
  * On some architectures it depends on the mm if the p4d/pud or pmd
  * layer of the page table hierarchy is folded or not.
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2184,13 +2184,13 @@ static int gup_huge_pgd(pgd_t orig, pgd_
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
 
@@ -2227,13 +2227,13 @@ static int gup_pmd_range(pud_t pud, unsi
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
 
@@ -2248,20 +2248,20 @@ static int gup_pud_range(p4d_t p4d, unsi
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
 
@@ -2273,7 +2273,7 @@ static int gup_p4d_range(pgd_t pgd, unsi
 			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
 					 P4D_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pud_range(p4d, addr, next, flags, pages, nr))
+		} else if (!gup_pud_range(p4dp, p4d, addr, next, flags, pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -2301,7 +2301,7 @@ static void gup_pgd_range(unsigned long
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
 					 PGDIR_SHIFT, next, flags, pages, nr))
 				return;
-		} else if (!gup_p4d_range(pgd, addr, next, flags, pages, nr))
+		} else if (!gup_p4d_range(pgdp, pgd, addr, next, flags, pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }


