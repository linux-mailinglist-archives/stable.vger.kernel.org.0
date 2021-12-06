Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852E2469A5C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345893AbhLFPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345794AbhLFPGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF269C0698D2;
        Mon,  6 Dec 2021 07:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6522961309;
        Mon,  6 Dec 2021 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46574C341C1;
        Mon,  6 Dec 2021 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802957;
        bh=7JpP0lptwNPN8vq+tqsvdM2mu8FUPmre0t1PtyJFCKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ezs4fRrQEUlqYvBoHgpm6M76x5u+cjAezfvv6qU34d/aO4DB6ZnUi9UySZufq3f7C
         EMPGZaUuGCviuZesH/lBkx0bIX9VbrSgOiWeu3YAZkZh7Sjrv2IamjnOnzbu3VpVEq
         Ef/uYSmyB+spPRldQFSnTgeNbp+8j0wzTJaHCJEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michal Hocko <mhocko@kernel.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 39/62] hugetlb: take PMD sharing into account when flushing tlb/caches
Date:   Mon,  6 Dec 2021 15:56:22 +0100
Message-Id: <20211206145550.542537902@linuxfoundation.org>
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

From: Mike Kravetz <mike.kravetz@oracle.com>

commit dff11abe280b47c21b804a8ace318e0638bb9a49 upstream.

When fixing an issue with PMD sharing and migration, it was discovered via
code inspection that other callers of huge_pmd_unshare potentially have an
issue with cache and tlb flushing.

Use the routine adjust_range_if_pmd_sharing_possible() to calculate worst
case ranges for mmu notifiers.  Ensure that this range is flushed if
huge_pmd_unshare succeeds and unmaps a PUD_SUZE area.

Link: http://lkml.kernel.org/r/20180823205917.16297-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   53 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3393,8 +3393,8 @@ void __unmap_hugepage_range(struct mmu_g
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	const unsigned long mmun_start = start;	/* For mmu_notifiers */
-	const unsigned long mmun_end   = end;	/* For mmu_notifiers */
+	unsigned long mmun_start = start;	/* For mmu_notifiers */
+	unsigned long mmun_end   = end;		/* For mmu_notifiers */
 	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
@@ -3402,6 +3402,11 @@ void __unmap_hugepage_range(struct mmu_g
 	BUG_ON(end & ~huge_page_mask(h));
 
 	tlb_start_vma(tlb, vma);
+
+	/*
+	 * If sharing possible, alert mmu notifiers of worst case.
+	 */
+	adjust_range_if_pmd_sharing_possible(vma, &mmun_start, &mmun_end);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	address = start;
 	for (; address < end; address += sz) {
@@ -3512,12 +3517,23 @@ void unmap_hugepage_range(struct vm_area
 {
 	struct mm_struct *mm;
 	struct mmu_gather tlb;
+	unsigned long tlb_start = start;
+	unsigned long tlb_end = end;
+
+	/*
+	 * If shared PMDs were possibly used within this vma range, adjust
+	 * start/end for worst case tlb flushing.
+	 * Note that we can not be sure if PMDs are shared until we try to
+	 * unmap pages.  However, we want to make sure TLB flushing covers
+	 * the largest possible range.
+	 */
+	adjust_range_if_pmd_sharing_possible(vma, &tlb_start, &tlb_end);
 
 	mm = vma->vm_mm;
 
-	tlb_gather_mmu(&tlb, mm, start, end);
+	tlb_gather_mmu(&tlb, mm, tlb_start, tlb_end);
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page);
-	tlb_finish_mmu(&tlb, start, end);
+	tlb_finish_mmu(&tlb, tlb_start, tlb_end);
 }
 
 /*
@@ -4205,11 +4221,21 @@ unsigned long hugetlb_change_protection(
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long pages = 0;
+	unsigned long f_start = start;
+	unsigned long f_end = end;
+	bool shared_pmd = false;
+
+	/*
+	 * In the case of shared PMDs, the area to flush could be beyond
+	 * start/end.  Set f_start/f_end to cover the maximum possible
+	 * range if PMD sharing is possible.
+	 */
+	adjust_range_if_pmd_sharing_possible(vma, &f_start, &f_end);
 
 	BUG_ON(address >= end);
-	flush_cache_range(vma, address, end);
+	flush_cache_range(vma, f_start, f_end);
 
-	mmu_notifier_invalidate_range_start(mm, start, end);
+	mmu_notifier_invalidate_range_start(mm, f_start, f_end);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
@@ -4220,6 +4246,7 @@ unsigned long hugetlb_change_protection(
 		if (huge_pmd_unshare(mm, &address, ptep)) {
 			pages++;
 			spin_unlock(ptl);
+			shared_pmd = true;
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
@@ -4254,12 +4281,18 @@ unsigned long hugetlb_change_protection(
 	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
 	 * may have cleared our pud entry and done put_page on the page table:
 	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.
+	 * and that page table be reused and filled with junk.  If we actually
+	 * did unshare a page of pmds, flush the range corresponding to the pud.
 	 */
-	flush_hugetlb_tlb_range(vma, start, end);
-	mmu_notifier_invalidate_range(mm, start, end);
+	if (shared_pmd) {
+		flush_hugetlb_tlb_range(vma, f_start, f_end);
+		mmu_notifier_invalidate_range(mm, f_start, f_end);
+	} else {
+		flush_hugetlb_tlb_range(vma, start, end);
+		mmu_notifier_invalidate_range(mm, start, end);
+	}
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
-	mmu_notifier_invalidate_range_end(mm, start, end);
+	mmu_notifier_invalidate_range_end(mm, f_start, f_end);
 
 	return pages << h->order;
 }


