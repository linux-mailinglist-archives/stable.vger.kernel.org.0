Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CB2140195
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 02:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgAQBxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 20:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgAQBxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 20:53:47 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBF32072B;
        Fri, 17 Jan 2020 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579226025;
        bh=/8WuWU2wSpXK9lDhKck3gp9wflJt/0ZgfVlAdXHsxuU=;
        h=Date:From:To:Subject:From;
        b=mi7kZ4CMX1I+wbxpVrSILzmsialatw5+pCwXR0vZYUq8/Aq0+3quZNiLdQiw+2h5P
         UaYRMTgPh3wPWNJTLQPDT6XgtQu4sInnnU5/04mY2WrLkXurmOKO09U6QJODf0N+v5
         aCVgFMJSFf1pgiVEZfVXBAUD3GVYcYVIolNXS2Fw=
Date:   Thu, 16 Jan 2020 17:53:45 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com
Subject:  +
 powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case.patch added to -mm
 tree
Message-ID: <20200117015345.urT5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
has been added to the -mm tree.  Its filename is
     powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case

Patch series "Fixup page directory freeing", v4.

This is a repost of patch series from Peter with the arch specific changes
except ppc64 dropped.  ppc64 changes are added here because we are redoing
the patch series on top of ppc64 changes.  This makes it easy to backport
these changes.  Only the first 2 patches need to be backported to stable. 


The thing is, on anything SMP, freeing page directories should observe the
exact same order as normal page freeing:

 1) unhook page/directory
 2) TLB invalidate
 3) free page/directory

Without this, any concurrent page-table walk could end up with a
Use-after-Free.  This is esp.  trivial for anything that has software
page-table walkers (HAVE_FAST_GUP / software TLB fill) or the hardware
caches partial page-walks (ie.  caches page directories).

Even on UP this might give issues since mmu_gather is preemptible these
days.  An interrupt or preempted task accessing user pages might stumble
into the free page if the hardware caches page directories.

This patch series fixes ppc64 and add generic MMU_GATHER changes to
support the conversion of other architectures.  I haven't added patches
w.r.t other architecture because they are yet to be acked.


This patch (of 9):

A followup patch is going to make sure we correctly invalidate page walk
cache before we free page table pages.  In order to keep things simple
enable RCU_TABLE_FREE even for !SMP so that we don't have to fixup the
!SMP case differently in the followup patch

!SMP case is right now broken for radix translation w.r.t page walk cache
flush.  We can get interrupted in between page table free and that would
imply we have page walk cache entries pointing to tables which got freed
already.

Link: http://lkml.kernel.org/r/20200116064531.483522-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                         |    2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h |    8 --------
 arch/powerpc/include/asm/book3s/64/pgalloc.h |    2 --
 arch/powerpc/include/asm/nohash/pgalloc.h    |    8 --------
 arch/powerpc/mm/book3s64/pgtable.c           |    7 -------
 5 files changed, 1 insertion(+), 26 deletions(-)

--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h~powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case
+++ a/arch/powerpc/include/asm/book3s/32/pgalloc.h
@@ -49,7 +49,6 @@ static inline void pgtable_free(void *ta
 
 #define get_hugepd_cache_index(x)  (x)
 
-#ifdef CONFIG_SMP
 static inline void pgtable_free_tlb(struct mmu_gather *tlb,
 				    void *table, int shift)
 {
@@ -66,13 +65,6 @@ static inline void __tlb_remove_table(vo
 
 	pgtable_free(table, shift);
 }
-#else
-static inline void pgtable_free_tlb(struct mmu_gather *tlb,
-				    void *table, int shift)
-{
-	pgtable_free(table, shift);
-}
-#endif
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h~powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case
+++ a/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -19,9 +19,7 @@ extern struct vmemmap_backing *vmemmap_l
 extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long);
 extern void pmd_fragment_free(unsigned long *);
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift);
-#ifdef CONFIG_SMP
 extern void __tlb_remove_table(void *_table);
-#endif
 void pte_frag_destroy(void *pte_frag);
 
 static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
--- a/arch/powerpc/include/asm/nohash/pgalloc.h~powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case
+++ a/arch/powerpc/include/asm/nohash/pgalloc.h
@@ -46,7 +46,6 @@ static inline void pgtable_free(void *ta
 
 #define get_hugepd_cache_index(x)	(x)
 
-#ifdef CONFIG_SMP
 static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
 {
 	unsigned long pgf = (unsigned long)table;
@@ -64,13 +63,6 @@ static inline void __tlb_remove_table(vo
 	pgtable_free(table, shift);
 }
 
-#else
-static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
-{
-	pgtable_free(table, shift);
-}
-#endif
-
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
 {
--- a/arch/powerpc/Kconfig~powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case
+++ a/arch/powerpc/Kconfig
@@ -222,7 +222,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE		if SMP
+	select HAVE_RCU_TABLE_FREE
 	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -378,7 +378,6 @@ static inline void pgtable_free(void *ta
 	}
 }
 
-#ifdef CONFIG_SMP
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
 {
 	unsigned long pgf = (unsigned long)table;
@@ -395,12 +394,6 @@ void __tlb_remove_table(void *_table)
 
 	return pgtable_free(table, index);
 }
-#else
-void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
-{
-	return pgtable_free(table, index);
-}
-#endif
 
 #ifdef CONFIG_PROC_FS
 atomic_long_t direct_pages_count[MMU_PAGE_COUNT];
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-pgmap-use-correct-alignment-when-looking-at-first-pfn-from-a-region.patch
mm-memmap_init-update-variable-name-in-memmap_init_zone.patch
powerpc-mmu_gather-enable-rcu_table_free-even-for-smp-case.patch

