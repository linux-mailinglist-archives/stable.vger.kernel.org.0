Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22965F378A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 23:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJCVRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 17:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJCVPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 17:15:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2E51F9FA;
        Mon,  3 Oct 2022 14:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A616B81123;
        Mon,  3 Oct 2022 21:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF815C433D6;
        Mon,  3 Oct 2022 21:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831393;
        bh=vvsnzXf7Aogp7xfFS9H9C6/DsJJAGbsz3okrFxMwuZo=;
        h=Date:To:From:Subject:From;
        b=W+IZQvLBMY29xfOtYO0qjb/YoIm6MMtGnxZaT6Jj1D1jax2eo7jq4q3VwZTQwz0m5
         7YBFYvsJ/f4luDQJCWpzZKL5K40SKNqewqlIUpb0/LCDZEdeo/6VhgHUs0utHxhU4E
         6RZ2XusmaNlBnZ0yJMdilWt0l0QDA98Ar/NrkMk8=
Date:   Mon, 03 Oct 2022 14:09:53 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        liuzixian4@huawei.com, jhubbard@nvidia.com, david@redhat.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch removed from -mm tree
Message-Id: <20221003210953.BF815C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: fix UAF in hugetlb_handle_userfault
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: hugetlb: fix UAF in hugetlb_handle_userfault
Date: Fri, 23 Sep 2022 12:21:13 +0800

The vma_lock and hugetlb_fault_mutex are dropped before handling userfault
and reacquire them again after handle_userfault(), but reacquire the
vma_lock could lead to UAF[1,2] due to the following race,

hugetlb_fault
  hugetlb_no_page
    /*unlock vma_lock */
    hugetlb_handle_userfault
      handle_userfault
        /* unlock mm->mmap_lock*/
                                           vm_mmap_pgoff
                                             do_mmap
                                               mmap_region
                                                 munmap_vma_range
                                                   /* clean old vma */
        /* lock vma_lock again  <--- UAF */
    /* unlock vma_lock */

Since the vma_lock will unlock immediately after
hugetlb_handle_userfault(), let's drop the unneeded lock and unlock in
hugetlb_handle_userfault() to fix the issue.

[1] https://lore.kernel.org/linux-mm/000000000000d5e00a05e834962e@google.com/
[2] https://lore.kernel.org/linux-mm/20220921014457.1668-1-liuzixian4@huawei.com/
Link: https://lkml.kernel.org/r/20220923042113.137273-1-liushixin2@huawei.com
Fixes: 1a1aad8a9b7b ("userfaultfd: hugetlbfs: add userfaultfd hugetlb hook")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: syzbot+193f9cee8638750b23cf@syzkaller.appspotmail.com
Reported-by: Liu Zixian <liuzixian4@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault
+++ a/mm/hugetlb.c
@@ -5489,7 +5489,6 @@ static inline vm_fault_t hugetlb_handle_
 						  unsigned long addr,
 						  unsigned long reason)
 {
-	vm_fault_t ret;
 	u32 hash;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -5507,18 +5506,14 @@ static inline vm_fault_t hugetlb_handle_
 	};
 
 	/*
-	 * vma_lock and hugetlb_fault_mutex must be
-	 * dropped before handling userfault.  Reacquire
-	 * after handling fault to make calling code simpler.
+	 * vma_lock and hugetlb_fault_mutex must be dropped before handling
+	 * userfault. Also mmap_lock could be dropped due to handling
+	 * userfault, any vma operation should be careful from here.
 	 */
 	hugetlb_vma_unlock_read(vma);
 	hash = hugetlb_fault_mutex_hash(mapping, idx);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-	ret = handle_userfault(&vmf, reason);
-	mutex_lock(&hugetlb_fault_mutex_table[hash]);
-	hugetlb_vma_lock_read(vma);
-
-	return ret;
+	return handle_userfault(&vmf, reason);
 }
 
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
@@ -5536,6 +5531,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5546,7 +5542,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -5560,12 +5556,10 @@ static vm_fault_t hugetlb_no_page(struct
 		if (idx >= size)
 			goto out;
 		/* Check for page in userfault range */
-		if (userfaultfd_missing(vma)) {
-			ret = hugetlb_handle_userfault(vma, mapping, idx,
+		if (userfaultfd_missing(vma))
+			return hugetlb_handle_userfault(vma, mapping, idx,
 						       flags, haddr, address,
 						       VM_UFFD_MISSING);
-			goto out;
-		}
 
 		page = alloc_huge_page(vma, haddr, 0);
 		if (IS_ERR(page)) {
@@ -5631,10 +5625,9 @@ static vm_fault_t hugetlb_no_page(struct
 		if (userfaultfd_minor(vma)) {
 			unlock_page(page);
 			put_page(page);
-			ret = hugetlb_handle_userfault(vma, mapping, idx,
+			return hugetlb_handle_userfault(vma, mapping, idx,
 						       flags, haddr, address,
 						       VM_UFFD_MINOR);
-			goto out;
 		}
 	}
 
@@ -5692,6 +5685,8 @@ static vm_fault_t hugetlb_no_page(struct
 
 	unlock_page(page);
 out:
+	hugetlb_vma_unlock_read(vma);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
 backout:
@@ -5789,11 +5784,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	entry = huge_ptep_get(ptep);
 	/* PTE markers should be handled the same way as none pte */
-	if (huge_pte_none_mostly(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
+	if (huge_pte_none_mostly(entry))
+		/*
+		 * hugetlb_no_page will drop vma lock and hugetlb fault
+		 * mutex internally, which make us return immediately.
+		 */
+		return hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
 				      entry, flags);
-		goto out_mutex;
-	}
 
 	ret = 0;
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are


