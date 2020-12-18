Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668F72DE9DA
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 20:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgLRTkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 14:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgLRTkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Dec 2020 14:40:02 -0500
Date:   Fri, 18 Dec 2020 11:39:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608320362;
        bh=1EC5O6cMBUtln6vfplhf3raQksT8CFKls9i3WFU7BXg=;
        h=From:To:Subject:From;
        b=dc1pGgzSfLPHRqVqiHy1I+f/9sC6YBHv3DmdBdIy5M1VjekiPojCaiGrpX1pSXuXK
         NKUmYhiADnMR0iK9KDY+Kf9EQq/BH/9fl6Ud15FnvWeGD0badcxJY77rAc+0uO3+1z
         8wMWpJpHVm1v5HILffFwy+l2bP8EPb0O0kwPgtpM=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, mhocko@kernel.org, hughd@google.com,
        dave@stgolabs.net, aneesh.kumar@linux.vnet.ibm.com,
        mike.kravetz@oracle.com
Subject:  + mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch
 added to -mm tree
Message-ID: <20201218193921.AbdXS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix deadlock in hugetlb_cow error path
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: fix deadlock in hugetlb_cow error path

syzbot reported the deadlock here [1].  The issue is in hugetlb cow error
handling when there are not enough huge pages for the faulting task which
took the original reservation.  It is possible that other (child) tasks
could have consumed pages associated with the reservation.  In this case,
we want the task which took the original reservation to succeed.  So, we
unmap any associated pages in children so that they can be used by the
faulting task that owns the reservation.

The unmapping code needs to hold i_mmap_rwsem in write mode.  However, due
to commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") we are already holding i_mmap_rwsem in read mode when
hugetlb_cow is called.  Technically, i_mmap_rwsem does not need to be held
in read mode for COW mappings as they can not share pmd's.  Modifying the
fault code to not take i_mmap_rwsem in read mode for COW (and other
non-sharable) mappings is too involved for a stable fix.  Instead, we
simply drop the hugetlb_fault_mutex and i_mmap_rwsem before unmapping. 
This is OK as it is technically not needed.  They are reacquired after
unmapping as expected by calling code.  Since this is done in an uncommon
error path, the overhead of dropping and reacquiring mutexes is
acceptable.

While making changes, remove redundant BUG_ON after unmap_ref_private.

[1] https://lkml.kernel.org/r/000000000000b73ccc05b5cf8558@google.com

Link: https://lkml.kernel.org/r/4c5781b8-3b00-761e-c0c7-c5edebb6ec1a@oracle.com
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: syzbot+5eee4145df3c15e96625@syzkaller.appspotmail.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path
+++ a/mm/hugetlb.c
@@ -4105,10 +4105,30 @@ retry_avoidcopy:
 		 * may get SIGKILLed if it later faults.
 		 */
 		if (outside_reserve) {
+			struct address_space *mapping = vma->vm_file->f_mapping;
+			pgoff_t idx;
+			u32 hash;
+
 			put_page(old_page);
 			BUG_ON(huge_pte_none(pte));
+			/*
+			 * Drop hugetlb_fault_mutex and i_mmap_rwsem before
+			 * unmapping.  unmapping needs to hold i_mmap_rwsem
+			 * in write mode.  Dropping i_mmap_rwsem in read mode
+			 * here is OK as COW mappings do not interact with
+			 * PMD sharing.
+			 *
+			 * Reacquire both after unmap operation.
+			 */
+			idx = vma_hugecache_offset(h, vma, haddr);
+			hash = hugetlb_fault_mutex_hash(mapping, idx);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			i_mmap_unlock_read(mapping);
+
 			unmap_ref_private(mm, vma, old_page, haddr);
-			BUG_ON(huge_pte_none(pte));
+
+			i_mmap_lock_read(mapping);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			spin_lock(ptl);
 			ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 			if (likely(ptep &&
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch

