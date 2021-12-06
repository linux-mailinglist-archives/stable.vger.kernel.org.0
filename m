Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34622469A21
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345737AbhLFPFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:05:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37840 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345736AbhLFPFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C99AB8111A;
        Mon,  6 Dec 2021 15:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C343CC341C1;
        Mon,  6 Dec 2021 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802907;
        bh=nbGH1mLG1pnGjlrH2/ENL0Ytwk0Sb4j9/vL7kAMBIyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvY9WOclBH806td2LMClZtqH1JmNAPFpqKNXMY9CjYxl8v6vjI44s2tdwJDs0HvCt
         1Hz6aNflU2sw4q9NylZR7RMJOHABdrwp9TzQ0ESq3T3p9ChY0sh9xtU1laDOwv7v7o
         XlQdh9hsPUAikdvFvnKIxVYI1Luq+c2FYR3cE7Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 23/62] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Mon,  6 Dec 2021 15:56:06 +0100
Message-Id: <20211206145549.986494138@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit a4a118f2eead1d6c49e00765de89878288d4b890 upstream.

When __unmap_hugepage_range() calls to huge_pmd_unshare() succeed, a TLB
flush is missing.  This TLB flush must be performed before releasing the
i_mmap_rwsem, in order to prevent an unshared PMDs page from being
released and reused before the TLB flush took place.

Arguably, a comprehensive solution would use mmu_gather interface to
batch the TLB flushes and the PMDs page release, however it is not an
easy solution: (1) try_to_unmap_one() and try_to_migrate_one() also call
huge_pmd_unshare() and they cannot use the mmu_gather interface; and (2)
deferring the release of the page reference for the PMDs page until
after i_mmap_rwsem is dropeed can confuse huge_pmd_unshare() into
thinking PMDs are shared when they are not.

Fix __unmap_hugepage_range() by adding the missing TLB flush, and
forcing a flush when unshare is successful.

Fixes: 24669e58477e ("hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages)" # 3.6
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/tlb.h  |    8 ++++++++
 arch/ia64/include/asm/tlb.h |   10 ++++++++++
 arch/s390/include/asm/tlb.h |   14 ++++++++++++++
 arch/sh/include/asm/tlb.h   |   10 ++++++++++
 arch/um/include/asm/tlb.h   |   12 ++++++++++++
 include/asm-generic/tlb.h   |    2 ++
 mm/hugetlb.c                |   19 +++++++++++++++++++
 mm/memory.c                 |   16 ++++++++++++++++
 8 files changed, 91 insertions(+)

--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -278,6 +278,14 @@ tlb_remove_pmd_tlb_entry(struct mmu_gath
 	tlb_add_flush(tlb, addr);
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	tlb_add_flush(tlb, address);
+	tlb_add_flush(tlb, address + size - PMD_SIZE);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	__pte_free_tlb(tlb, ptep, addr)
 #define pmd_free_tlb(tlb, pmdp, addr)	__pmd_free_tlb(tlb, pmdp, addr)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -272,6 +272,16 @@ __tlb_remove_tlb_entry (struct mmu_gathe
 	tlb->end_addr = address + PAGE_SIZE;
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	if (tlb->start_addr > address)
+		tlb->start_addr = address;
+	if (tlb->end_addr < address + size)
+		tlb->end_addr = address + size;
+}
+
 #define tlb_migrate_finish(mm)	platform_tlb_migrate_finish(mm)
 
 #define tlb_start_vma(tlb, vma)			do { } while (0)
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -116,6 +116,20 @@ static inline void tlb_remove_page_size(
 	return tlb_remove_page(tlb, page);
 }
 
+static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
+				unsigned long address, unsigned long size)
+{
+	/*
+	 * the range might exceed the original range that was provided to
+	 * tlb_gather_mmu(), so we need to update it despite the fact it is
+	 * usually not updated.
+	 */
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
+
 /*
  * pte_free_tlb frees a pte table and clears the CRSTE for the
  * page table from the tlb.
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -115,6 +115,16 @@ static inline bool __tlb_remove_page_siz
 	return __tlb_remove_page(tlb, page);
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
--- a/arch/um/include/asm/tlb.h
+++ b/arch/um/include/asm/tlb.h
@@ -128,6 +128,18 @@ static inline void tlb_remove_page_size(
 	return tlb_remove_page(tlb, page);
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	tlb->need_flush = 1;
+
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -123,6 +123,8 @@ void tlb_finish_mmu(struct mmu_gather *t
 							unsigned long end);
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
 				   int page_size);
+void tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+			 unsigned long size);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address)
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3395,6 +3395,7 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long sz = huge_page_size(h);
 	const unsigned long mmun_start = start;	/* For mmu_notifiers */
 	const unsigned long mmun_end   = end;	/* For mmu_notifiers */
+	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -3411,6 +3412,8 @@ void __unmap_hugepage_range(struct mmu_g
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep)) {
 			spin_unlock(ptl);
+			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
+			force_flush = true;
 			continue;
 		}
 
@@ -3467,6 +3470,22 @@ void __unmap_hugepage_range(struct mmu_g
 	}
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	tlb_end_vma(tlb, vma);
+
+	/*
+	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
+	 * could defer the flush until now, since by holding i_mmap_rwsem we
+	 * guaranteed that the last refernece would not be dropped. But we must
+	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
+	 * dropped and the last reference to the shared PMDs page might be
+	 * dropped as well.
+	 *
+	 * In theory we could defer the freeing of the PMD pages as well, but
+	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
+	 * detect sharing, so we cannot defer the release of the page either.
+	 * Instead, do flush now.
+	 */
+	if (force_flush)
+		tlb_flush_mmu(tlb);
 }
 
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -320,6 +320,22 @@ bool __tlb_remove_page_size(struct mmu_g
 	return false;
 }
 
+void tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+			 unsigned long size)
+{
+	if (tlb->page_size != 0 && tlb->page_size != PMD_SIZE)
+		tlb_flush_mmu(tlb);
+
+	tlb->page_size = PMD_SIZE;
+	tlb->start = min(tlb->start, address);
+	tlb->end = max(tlb->end, address + size);
+	/*
+	 * Track the last address with which we adjusted the range. This
+	 * will be used later to adjust again after a mmu_flush due to
+	 * failed __tlb_remove_page
+	 */
+	tlb->addr = address + size - PMD_SIZE;
+}
 #endif /* HAVE_GENERIC_MMU_GATHER */
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE


