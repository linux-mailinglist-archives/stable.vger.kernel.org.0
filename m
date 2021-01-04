Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCB2E9994
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbhADQBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbhADQBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C0C420769;
        Mon,  4 Jan 2021 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776082;
        bh=Hs3jfzFDRSTfkmGsTGQDWdYn+bzYaFnWjFQ6xIXWCdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bequToN5yFMGw+veQ84vixrn+hXHRjbjH8z82OXKs0VLbglYlSFIUx9i2Pu4L+4CV
         l0yySHwl5liWooVeY47OX5UEodXTOkOoB+grVyMG4UBFAnyDDbCOORwDaI9mnfjB5l
         A9tYNnu7pTjtks/lvUEIZKEbELq4+G/Epx+kpMhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        syzbot+5eee4145df3c15e96625@syzkaller.appspotmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 14/63] mm/hugetlb: fix deadlock in hugetlb_cow error path
Date:   Mon,  4 Jan 2021 16:57:07 +0100
Message-Id: <20210104155709.506839137@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit e7dd91c456a8cdbcd7066997d15e36d14276a949 upstream.

syzbot reported the deadlock here [1].  The issue is in hugetlb cow
error handling when there are not enough huge pages for the faulting
task which took the original reservation.  It is possible that other
(child) tasks could have consumed pages associated with the reservation.
In this case, we want the task which took the original reservation to
succeed.  So, we unmap any associated pages in children so that they can
be used by the faulting task that owns the reservation.

The unmapping code needs to hold i_mmap_rwsem in write mode.  However,
due to commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd
sharing synchronization") we are already holding i_mmap_rwsem in read
mode when hugetlb_cow is called.

Technically, i_mmap_rwsem does not need to be held in read mode for COW
mappings as they can not share pmd's.  Modifying the fault code to not
take i_mmap_rwsem in read mode for COW (and other non-sharable) mappings
is too involved for a stable fix.

Instead, we simply drop the hugetlb_fault_mutex and i_mmap_rwsem before
unmapping.  This is OK as it is technically not needed.  They are
reacquired after unmapping as expected by calling code.  Since this is
done in an uncommon error path, the overhead of dropping and reacquiring
mutexes is acceptable.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4106,10 +4106,30 @@ retry_avoidcopy:
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


