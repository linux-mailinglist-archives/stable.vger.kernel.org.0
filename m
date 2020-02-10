Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE40157A8F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgBJNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728663AbgBJMhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:12 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317E12051A;
        Mon, 10 Feb 2020 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338231;
        bh=umZ8qvNJVUO4pM3hHHLwj3O2jPhnSNExIOdVA6tCJBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHD7Bmdbj4olBm2w5Va4TmTff6pJoSMxX1rtIOVMc+a4pNtQbicn6gzTFPXOPeb7P
         GMjJsHJpd8OQzKc3CAZSH2k60rUPzBecfEMfjoOxVr3M0tAv/oPn4EfP9WylhURb5r
         0niKR3bd5gUFD+cHWkroIYqAFKHBpGx+Q6yCXHeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 074/309] powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
Date:   Mon, 10 Feb 2020 04:30:30 -0800
Message-Id: <20200210122412.974846456@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 12e4d53f3f04e81f9e83d6fc10edc7314ab9f6b9 upstream.

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

!SMP case is right now broken for radix translation w.r.t page walk
cache flush.  We can get interrupted in between page table free and
that would imply we have page walk cache entries pointing to tables
which got freed already.  Michael said "both our platforms that run on
Power9 force SMP on in Kconfig, so the !SMP case is unlikely to be a
problem for anyone in practice, unless they've hacked their kernel to
build it !SMP."

Link: http://lkml.kernel.org/r/20200116064531.483522-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Kconfig                         |    2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h |    8 --------
 arch/powerpc/include/asm/book3s/64/pgalloc.h |    2 --
 arch/powerpc/include/asm/nohash/pgalloc.h    |    8 --------
 arch/powerpc/mm/book3s64/pgtable.c           |    7 -------
 5 files changed, 1 insertion(+), 26 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -221,7 +221,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE		if SMP
+	select HAVE_RCU_TABLE_FREE
 	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/32/pgalloc.h
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
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -19,9 +19,7 @@ extern struct vmemmap_backing *vmemmap_l
 extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long);
 extern void pmd_fragment_free(unsigned long *);
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift);
-#ifdef CONFIG_SMP
 extern void __tlb_remove_table(void *_table);
-#endif
 void pte_frag_destroy(void *pte_frag);
 
 static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
--- a/arch/powerpc/include/asm/nohash/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/pgalloc.h
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
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
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


