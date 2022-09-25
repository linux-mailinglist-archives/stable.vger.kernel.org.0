Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4315E9526
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiIYR4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 13:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIYR4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 13:56:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899D92A422;
        Sun, 25 Sep 2022 10:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41A62B80D4C;
        Sun, 25 Sep 2022 17:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94430C433C1;
        Sun, 25 Sep 2022 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664128570;
        bh=xSTTzbWzY6W8I972fWk1Onxvuq4QsvmY3C9KIrQesVM=;
        h=Date:To:From:Subject:From;
        b=EtehGjxw0tS4AIAjczhG0FJGon3DbEqyRYP5b2K9Da7cEtQ9dsOWUal1vGPaKDOGa
         PJviq354SNpiWKGLSpvB76+I8PrIX/lu8b0mOj3tgx1BugxdtCTKTcoYaGpK00A9aF
         jpViI6BMdutX+MZZDBNsY1CtHHMbhh975s/fKYFs=
Date:   Sun, 25 Sep 2022 10:56:09 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        liuzixian4@huawei.com, jhubbard@nvidia.com, david@redhat.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch added to mm-hotfixes-unstable branch
Message-Id: <20220925175610.94430C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix UAF in hugetlb_handle_userfault
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: hugetlb: fix UAF in hugetlb_handle_userfault
Date: Sat, 24 Sep 2022 11:49:05 +0800

The vma_lock and hugetlb_fault_mutex are dropped before handling
userfault and reacquire them again after handle_userfault(), but
reacquire the vma_lock could lead to UAF[1,2] due to the following
race,

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

Since the vma_lock will unlock immediately after hugetlb_handle_userfault(),
let's drop the unneeded lock and unlock in hugetlb_handle_userfault() to fix
the issue.

[1] https://lore.kernel.org/linux-mm/000000000000d5e00a05e834962e@google.com/
[2] https://lore.kernel.org/linux-mm/20220921014457.1668-1-liuzixian4@huawei.com/
Link: https://lkml.kernel.org/r/20220924034905.2694686-1-liushixin2@huawei.com
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


--- a/mm/hugetlb.c~mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault
+++ a/mm/hugetlb.c
@@ -5478,7 +5478,6 @@ static inline vm_fault_t hugetlb_handle_
 						  unsigned long addr,
 						  unsigned long reason)
 {
-	vm_fault_t ret;
 	u32 hash;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -5496,18 +5495,14 @@ static inline vm_fault_t hugetlb_handle_
 	};
 
 	/*
-	 * hugetlb_fault_mutex and i_mmap_rwsem must be
-	 * dropped before handling userfault.  Reacquire
-	 * after handling fault to make calling code simpler.
+	 * vma_lock and hugetlb_fault_mutex must be dropped before handling
+	 * userfault. Also mmap_lock will be dropped during handling
+	 * userfault, any vma operation should be careful from here.
 	 */
 	hash = hugetlb_fault_mutex_hash(mapping, idx);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	i_mmap_unlock_read(mapping);
-	ret = handle_userfault(&vmf, reason);
-	i_mmap_lock_read(mapping);
-	mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
-	return ret;
+	return handle_userfault(&vmf, reason);
 }
 
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
@@ -5525,6 +5520,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5535,7 +5531,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -5552,12 +5548,10 @@ retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
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
@@ -5617,10 +5611,9 @@ retry:
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
 
@@ -5678,6 +5671,8 @@ retry:
 
 	unlock_page(page);
 out:
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
 	return ret;
 
 backout:
@@ -5776,11 +5771,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
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

mm-hugetlb-fix-uaf-in-hugetlb_handle_userfault.patch
mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

