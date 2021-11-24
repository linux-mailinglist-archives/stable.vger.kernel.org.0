Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5151945C420
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348421AbhKXNpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350847AbhKXNmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7CA4632BC;
        Wed, 24 Nov 2021 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758709;
        bh=nlxhKVOrHmkpJmpdgT+IlZKsrUqOsFLG/b/iwZqWAu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsIgynFEtfEI5Ja2qjFO9JHo0Maw3RBN5yySZ2ZRtDysp9Tln5GrGnEjwCRQMGvsZ
         CJdC+rU24ULsaFIyQ/FeB/NwwlIxbe/i6GNcPm68X8Q13lQsm+OAX/afjbnvKnojfa
         oUiDQQYG65V6rZvL51REst+/1axd7mNSsp64bgS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 146/154] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Wed, 24 Nov 2021 12:59:02 +0100
Message-Id: <20211124115707.207416812@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
 mm/hugetlb.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3913,6 +3913,7 @@ void __unmap_hugepage_range(struct mmu_g
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mmu_notifier_range range;
+	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
@@ -3941,10 +3942,8 @@ void __unmap_hugepage_range(struct mmu_g
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			spin_unlock(ptl);
-			/*
-			 * We just unmapped a page of PMDs by clearing a PUD.
-			 * The caller's TLB flush range should cover this area.
-			 */
+			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
+			force_flush = true;
 			continue;
 		}
 
@@ -4001,6 +4000,22 @@ void __unmap_hugepage_range(struct mmu_g
 	}
 	mmu_notifier_invalidate_range_end(&range);
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


