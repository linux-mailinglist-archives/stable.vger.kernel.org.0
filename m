Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17075FFEC7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJPLEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiJPLEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFB2D40
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B02B60AF0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F9C433C1;
        Sun, 16 Oct 2022 11:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665918271;
        bh=cH4V7xZNbo1AuehCiPBL3SS5X7TtTWKLMBXGLiho1NM=;
        h=Subject:To:Cc:From:Date:From;
        b=z9R10jf3PPWBJianFSL1HRC5gdV0hIONVjG5v5d8sTs8mhcEOGJteyqLpm5utxraT
         ZxUEDpbmyIGh0AjnO/vcZ2vb+z46G79NtAT5GnmAEmrBQNgkXLH2iscMXO1jyC877w
         5g5mgY1k9lnnOp3zvH0p8CuL5NYuiIpSQ6S4y09U=
Subject: FAILED: patch "[PATCH] mm: hugetlb: fix UAF in hugetlb_handle_userfault" failed to apply to 5.15-stable tree
To:     liushixin2@huawei.com, akpm@linux-foundation.org, david@redhat.com,
        jhubbard@nvidia.com, liuzixian4@huawei.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        wangkefeng.wang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:05:13 +0200
Message-ID: <166591831320326@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

958f32ce832b ("mm: hugetlb: fix UAF in hugetlb_handle_userfault")
40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
378397ccb8e5 ("hugetlb: create hugetlb_unmap_file_folio to unmap single file folio")
8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
12710fd69634 ("hugetlb: rename vma_shareable() and refactor code")
c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
7e1813d48dd3 ("hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache")
3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
5e6b1bf1b5c3 ("hugetlb: remove meaningless BUG_ON(huge_pte_none())")
3a5497a2dae3 ("mm/hugetlb: fix missing call to restore_reserve_on_error()")
6614a3c3164a ("Merge tag 'mm-stable-2022-08-03' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 958f32ce832ba781ac20e11bb2d12a9352ea28fc Mon Sep 17 00:00:00 2001
From: Liu Shixin <liushixin2@huawei.com>
Date: Fri, 23 Sep 2022 12:21:13 +0800
Subject: [PATCH] mm: hugetlb: fix UAF in hugetlb_handle_userfault

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

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2182134216f0..3c1316ad54b5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5489,7 +5489,6 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_area_struct *vma,
 						  unsigned long addr,
 						  unsigned long reason)
 {
-	vm_fault_t ret;
 	u32 hash;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -5507,18 +5506,14 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_area_struct *vma,
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
@@ -5536,6 +5531,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5546,7 +5542,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -5560,12 +5556,10 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
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
@@ -5631,10 +5625,9 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
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
 
@@ -5692,6 +5685,8 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 
 	unlock_page(page);
 out:
+	hugetlb_vma_unlock_read(vma);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
 backout:
@@ -5789,11 +5784,13 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
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
 

