Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBB52E8198
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 19:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLaSXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 13:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgLaSXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 13:23:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C89C223E0;
        Thu, 31 Dec 2020 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438964;
        bh=kczjqQ9QtjP6FYcMTr5xKp7Uh/vb8xYvuzgWJLjVZJg=;
        h=Date:From:To:Subject:From;
        b=sR8cZv4G7p0i9hFCUQpEicwwQicZRi2RojIw97Ii/5TQhmVbJWiPeb0WhS22rtmVe
         Bo6o/tgNy+RJ+EJeo3dcRpQF855dbjW1eK2+0FGmLIvh9ir6etDO1UUkfoAlr/aPZM
         pJ/iRwMK139TBAAv5eAT8ulYKih1XICc7jDoXY4U=
Date:   Thu, 31 Dec 2020 10:22:44 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net,
        hughd@google.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch removed from -mm
 tree
Message-ID: <20201231182244._w28iTi6u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix deadlock in hugetlb_cow error path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

