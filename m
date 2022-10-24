Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ACE60AD19
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiJXORl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbiJXOQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479F6B1CD;
        Mon, 24 Oct 2022 05:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614E061299;
        Mon, 24 Oct 2022 12:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4574FC433D6;
        Mon, 24 Oct 2022 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616140;
        bh=CJQzFCSpz+lYJ0uCuw2di8h4ZYzJroJUUsO+QGDVdeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIMTjIyAI/u+WIcSjoroJVTh4LOPCTnnMb1LZSfLXnDUt6y8a8QPLhITncsMUqBLd
         IxZAX28JcDfTfwrIFdBXffdv8iRzicpMamyQrTus1bPqv47bikEnaKoeNANX9mRO+z
         XEkwl6FNsYgU1qtP3ngKyWS0RxHVly0npUHjC98Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        syzbot+193f9cee8638750b23cf@syzkaller.appspotmail.com,
        Liu Zixian <liuzixian4@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 516/530] mm: hugetlb: fix UAF in hugetlb_handle_userfault
Date:   Mon, 24 Oct 2022 13:34:20 +0200
Message-Id: <20221024113108.359729536@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

commit 958f32ce832ba781ac20e11bb2d12a9352ea28fc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4844,7 +4844,6 @@ static inline vm_fault_t hugetlb_handle_
 						  unsigned long haddr,
 						  unsigned long reason)
 {
-	vm_fault_t ret;
 	u32 hash;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -4861,18 +4860,14 @@ static inline vm_fault_t hugetlb_handle_
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
@@ -4889,6 +4884,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4898,7 +4894,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -4915,12 +4911,10 @@ retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		/* Check for page in userfault range */
-		if (userfaultfd_missing(vma)) {
-			ret = hugetlb_handle_userfault(vma, mapping, idx,
+		if (userfaultfd_missing(vma))
+			return hugetlb_handle_userfault(vma, mapping, idx,
 						       flags, haddr,
 						       VM_UFFD_MISSING);
-			goto out;
-		}
 
 		page = alloc_huge_page(vma, haddr, 0);
 		if (IS_ERR(page)) {
@@ -4980,10 +4974,9 @@ retry:
 		if (userfaultfd_minor(vma)) {
 			unlock_page(page);
 			put_page(page);
-			ret = hugetlb_handle_userfault(vma, mapping, idx,
+			return hugetlb_handle_userfault(vma, mapping, idx,
 						       flags, haddr,
 						       VM_UFFD_MINOR);
-			goto out;
 		}
 	}
 
@@ -5034,6 +5027,8 @@ retry:
 
 	unlock_page(page);
 out:
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
 	return ret;
 
 backout:
@@ -5131,10 +5126,12 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
-	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
-		goto out_mutex;
-	}
+	if (huge_pte_none(entry))
+		/*
+		 * hugetlb_no_page will drop vma lock and hugetlb fault
+		 * mutex internally, which make us return immediately.
+		 */
+		return hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
 
 	ret = 0;
 


