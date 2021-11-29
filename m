Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F07462454
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhK2WRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhK2WQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D087C127132;
        Mon, 29 Nov 2021 10:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84CD5CE13DE;
        Mon, 29 Nov 2021 18:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69EEC53FAD;
        Mon, 29 Nov 2021 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210148;
        bh=4khhonQ7GYPrOrbKCwq6/vqUS/oJL20bp9jF08QmF5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoF0WLtZ/bU4PovkNP7PnfIqE+5twg98bKGW6UIiHu4GmhRKK1bMbAS+Q2bCDJXn4
         kY68smBSFMsDRKF+TLE0B+mu2021ZXFd14Obj4GMt5yFiMc7xHIFw0uMeJd98ePVI0
         3tfYlN9mxaYFNhKjbG+UmN8o44n0fnj7xp/cEpTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 58/69] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Mon, 29 Nov 2021 19:18:40 +0100
Message-Id: <20211129181705.532465891@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
 arch/s390/include/asm/tlb.h |   16 ++++++++++++++++
 arch/sh/include/asm/tlb.h   |   10 ++++++++++
 arch/um/include/asm/tlb.h   |   12 ++++++++++++
 include/asm-generic/tlb.h   |    2 ++
 mm/hugetlb.c                |   23 +++++++++++++++++++----
 mm/memory.c                 |   10 ++++++++++
 8 files changed, 87 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -280,6 +280,14 @@ tlb_remove_pmd_tlb_entry(struct mmu_gath
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
@@ -268,6 +268,16 @@ __tlb_remove_tlb_entry (struct mmu_gathe
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
@@ -177,6 +191,8 @@ static inline void pud_free_tlb(struct m
 #define tlb_remove_tlb_entry(tlb, ptep, addr)	do { } while (0)
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, addr)	do { } while (0)
 #define tlb_migrate_finish(mm)			do { } while (0)
+#define tlb_flush_pmd_range(tlb, addr, sz)	do { } while (0)
+
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	tlb_remove_tlb_entry(tlb, ptep, address)
 
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -127,6 +127,16 @@ static inline void tlb_remove_page_size(
 	return tlb_remove_page(tlb, page);
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
 #define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
 static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 						     unsigned int page_size)
--- a/arch/um/include/asm/tlb.h
+++ b/arch/um/include/asm/tlb.h
@@ -130,6 +130,18 @@ static inline void tlb_remove_page_size(
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
@@ -118,6 +118,8 @@ void arch_tlb_gather_mmu(struct mmu_gath
 void tlb_flush_mmu(struct mmu_gather *tlb);
 void arch_tlb_finish_mmu(struct mmu_gather *tlb,
 			 unsigned long start, unsigned long end, bool force);
+void tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+			 unsigned long size);
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
 				   int page_size);
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3425,6 +3425,7 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long sz = huge_page_size(h);
 	unsigned long mmun_start = start;	/* For mmu_notifiers */
 	unsigned long mmun_end   = end;		/* For mmu_notifiers */
+	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -3451,10 +3452,8 @@ void __unmap_hugepage_range(struct mmu_g
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep)) {
 			spin_unlock(ptl);
-			/*
-			 * We just unmapped a page of PMDs by clearing a PUD.
-			 * The caller's TLB flush range should cover this area.
-			 */
+			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
+			force_flush = true;
 			continue;
 		}
 
@@ -3511,6 +3510,22 @@ void __unmap_hugepage_range(struct mmu_g
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
+		tlb_flush_mmu_tlbonly(tlb);
 }
 
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -324,6 +324,16 @@ bool __tlb_remove_page_size(struct mmu_g
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
+}
 #endif /* HAVE_GENERIC_MMU_GATHER */
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE


