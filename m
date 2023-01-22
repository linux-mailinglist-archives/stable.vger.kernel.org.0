Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7853D676F83
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjAVPWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjAVPWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9457E22A2A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3975AB80B1F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97620C433EF;
        Sun, 22 Jan 2023 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400931;
        bh=8W3DQFxRpvWT2iSEAZ4MBYw0j3AQ39Qd/fHl5PwdzGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEAMBKN9wKqtQlpuFmLb8vLYBjYv8C9Wpn/wGZO7qg1iVid+qFIVNRLYGHJWTWgth
         CgX3MFw+oCaGCLoOD9RJHLf3jLAJvEoCNf+QOipxysseYM1HMzcKovb4PqxxtfPblY
         S+1CVBVGgTjM0L1YtmCFSXrka5u2XE+r/CbJU/p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 046/193] hugetlb: unshare some PMDs when splitting VMAs
Date:   Sun, 22 Jan 2023 16:02:55 +0100
Message-Id: <20230122150248.496230412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Houghton <jthoughton@google.com>

commit b30c14cd61025eeea2f2e8569606cd167ba9ad2d upstream.

PMD sharing can only be done in PUD_SIZE-aligned pieces of VMAs; however,
it is possible that HugeTLB VMAs are split without unsharing the PMDs
first.

Without this fix, it is possible to hit the uffd-wp-related WARN_ON_ONCE
in hugetlb_change_protection [1].  The key there is that
hugetlb_unshare_all_pmds will not attempt to unshare PMDs in
non-PUD_SIZE-aligned sections of the VMA.

It might seem ideal to unshare in hugetlb_vm_op_open, but we need to
unshare in both the new and old VMAs, so unsharing in hugetlb_vm_op_split
seems natural.

[1]: https://lore.kernel.org/linux-mm/CADrL8HVeOkj0QH5VZZbRzybNE8CG-tEGFshnA+bG9nMgcWtBSg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230104231910.1464197-1-jthoughton@google.com
Fixes: 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp")
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -94,6 +94,8 @@ static int hugetlb_acct_memory(struct hs
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -4825,6 +4827,25 @@ static int hugetlb_vm_op_split(struct vm
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+
+	/*
+	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
+	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
+	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 */
+	if (addr & ~PUD_MASK) {
+		/*
+		 * hugetlb_vm_op_split is called right before we attempt to
+		 * split the VMA. We will need to unshare PMDs in the old and
+		 * new VMAs, so let's unshare before we split.
+		 */
+		unsigned long floor = addr & PUD_MASK;
+		unsigned long ceil = floor + PUD_SIZE;
+
+		if (floor >= vma->vm_start && ceil <= vma->vm_end)
+			hugetlb_unshare_pmds(vma, floor, ceil);
+	}
+
 	return 0;
 }
 
@@ -7386,26 +7407,21 @@ void move_hugetlb_state(struct page *old
 	}
 }
 
-/*
- * This function will unconditionally remove all the shared pmd pgtable entries
- * within the specific vma for a hugetlbfs memory range.
- */
-void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+				   unsigned long start,
+				   unsigned long end)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long address, start, end;
+	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	start = ALIGN(vma->vm_start, PUD_SIZE);
-	end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
-
 	if (start >= end)
 		return;
 
@@ -7437,6 +7453,16 @@ void hugetlb_unshare_all_pmds(struct vm_
 	mmu_notifier_invalidate_range_end(&range);
 }
 
+/*
+ * This function will unconditionally remove all the shared pmd pgtable entries
+ * within the specific vma for a hugetlbfs memory range.
+ */
+void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+{
+	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+}
+
 #ifdef CONFIG_CMA
 static bool cma_reserve_called __initdata;
 


