Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26E945BC68
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbhKXMar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244320AbhKXM1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:27:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 409ED61250;
        Wed, 24 Nov 2021 12:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756191;
        bh=NmTb+fwwUk/1rqGlLUUQ8Ah9mhgpzkKaBM5BB3/xJTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9WkbkjDn0C9J+h058+3TZqQ2Ah5LNw7EJjb/xL83DmyUeupJJr9nQU9TDVwOEv1C
         1QcigK643XfT7kxsIgEiEGgQJWOD3WUOu0mh/awtx4fiOHMBaBdxfXlnLPHNynKilp
         4sRQwvhapwszLSAqBNz3R9e++qthb18ZlDdReIbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 207/207] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Wed, 24 Nov 2021 12:57:58 +0100
Message-Id: <20211124115710.648851955@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
 include/asm-generic/tlb.h |   17 +++++++++++++++++
 mm/hugetlb.c              |   19 +++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -202,6 +202,23 @@ static inline bool __tlb_remove_pte_page
 #define tlb_end_vma	__tlb_end_vma
 #endif
 
+static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
+				unsigned long address, unsigned long size)
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
+
 #ifndef __tlb_remove_tlb_entry
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
 #endif
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


