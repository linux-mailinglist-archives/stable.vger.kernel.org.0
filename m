Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44876604031
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiJSJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiJSJk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AAD21A;
        Wed, 19 Oct 2022 02:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34E3617E9;
        Wed, 19 Oct 2022 09:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCE2C433C1;
        Wed, 19 Oct 2022 09:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170954;
        bh=lC9p0OqQqCZX6b9FuUy8Ig6O3v6yhsSoGJOijnrTgG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9SV4eePrz9f8BL2shS8bFqxi3k1auaHScuhGWr/d1NMAl35OzDx0c8J+ZWu+0ZGH
         OTsSfsuxgkYlHJKkwLZufgpJZv55R/1NNiMApliOdaoBYWmV2ie9Z7EAmzNwTSlPL/
         V79qxe7nYlyVF/MJdYDNcPqjvYnDxpe767SB1GiE=
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
Subject: [PATCH 6.0 848/862] mm: hugetlb: fix UAF in hugetlb_handle_userfault
Date:   Wed, 19 Oct 2022 10:35:35 +0200
Message-Id: <20221019083327.339557041@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -5482,7 +5482,6 @@ static inline vm_fault_t hugetlb_handle_
 						  unsigned long addr,
 						  unsigned long reason)
 {
-	vm_fault_t ret;
 	u32 hash;
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -5500,18 +5499,14 @@ static inline vm_fault_t hugetlb_handle_
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
@@ -5529,6 +5524,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5539,7 +5535,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -5556,12 +5552,10 @@ retry:
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
@@ -5621,10 +5615,9 @@ retry:
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
 
@@ -5682,6 +5675,8 @@ retry:
 
 	unlock_page(page);
 out:
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
 	return ret;
 
 backout:
@@ -5780,11 +5775,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
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
 


