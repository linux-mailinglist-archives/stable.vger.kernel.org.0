Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C527E38D74C
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 21:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhEVTwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 15:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhEVTwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 15:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E654B61163;
        Sat, 22 May 2021 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621713053;
        bh=5AA8g/ZVVf7jEqsxp4c7/vArP2+QDfx3AUbbnm1ztpQ=;
        h=Date:From:To:Subject:From;
        b=o45H9zLbGw8p8xQirn/Xb2voIHyTG/VU1qnPW2AOoLpHkhvzWZks5ZjVf9V51IjU1
         UPsd7bwwJUaAC9Yt1eKynFG/WcVXUcfVHjJqBfNZ/3swHyJFkBv2y2sH3j8QKQsvW0
         WjBavnYhSXyLocM6bR4c6NvQyOJEvQ0QTRLrYyKE=
Date:   Sat, 22 May 2021 12:50:52 -0700
From:   akpm@linux-foundation.org
To:     almasry.mina@google.com, almasrymina@google.com, david@redhat.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, songmuchun@bytedance.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  +
 userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path.patch added to -mm
 tree
Message-ID: <20210522195052.yS3JsOmS2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: fix new flag usage in error path
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path.patch

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
Subject: userfaultfd: hugetlbfs: fix new flag usage in error path

In commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") the use of PagePrivate to indicate a reservation count should
be restored at free time was changed to the hugetlb specific flag
HPageRestoreReserve.  Changes to a userfaultfd error path as well as a
VM_BUG_ON() in remove_inode_hugepages() were overlooked.

Users could see incorrect hugetlb reserve counts if they experience an
error with a UFFDIO_COPY operation.  Specifically, this would be the
result of an unlikely copy_huge_page_from_user error.  There is not an
increased chance of hitting the VM_BUG_ON.

Link: https://lkml.kernel.org/r/20210521233952.236434-1-mike.kravetz@oracle.com
Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mina Almasry <almasry.mina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/userfaultfd.c     |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/hugetlbfs/inode.c~userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path
+++ a/fs/hugetlbfs/inode.c
@@ -529,7 +529,7 @@ static void remove_inode_hugepages(struc
 			 * the subpool and global reserve usage count can need
 			 * to be adjusted.
 			 */
-			VM_BUG_ON(PagePrivate(page));
+			VM_BUG_ON(HPageRestoreReserve(page));
 			remove_huge_page(page);
 			freed++;
 			if (!truncate_op) {
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path
+++ a/mm/userfaultfd.c
@@ -360,38 +360,38 @@ out:
 		 * If a reservation for the page existed in the reservation
 		 * map of a private mapping, the map was modified to indicate
 		 * the reservation was consumed when the page was allocated.
-		 * We clear the PagePrivate flag now so that the global
+		 * We clear the HPageRestoreReserve flag now so that the global
 		 * reserve count will not be incremented in free_huge_page.
 		 * The reservation map will still indicate the reservation
 		 * was consumed and possibly prevent later page allocation.
 		 * This is better than leaking a global reservation.  If no
-		 * reservation existed, it is still safe to clear PagePrivate
-		 * as no adjustments to reservation counts were made during
-		 * allocation.
+		 * reservation existed, it is still safe to clear
+		 * HPageRestoreReserve as no adjustments to reservation counts
+		 * were made during allocation.
 		 *
 		 * The reservation map for shared mappings indicates which
 		 * pages have reservations.  When a huge page is allocated
 		 * for an address with a reservation, no change is made to
-		 * the reserve map.  In this case PagePrivate will be set
-		 * to indicate that the global reservation count should be
+		 * the reserve map.  In this case HPageRestoreReserve will be
+		 * set to indicate that the global reservation count should be
 		 * incremented when the page is freed.  This is the desired
 		 * behavior.  However, when a huge page is allocated for an
 		 * address without a reservation a reservation entry is added
-		 * to the reservation map, and PagePrivate will not be set.
-		 * When the page is freed, the global reserve count will NOT
-		 * be incremented and it will appear as though we have leaked
-		 * reserved page.  In this case, set PagePrivate so that the
-		 * global reserve count will be incremented to match the
-		 * reservation map entry which was created.
+		 * to the reservation map, and HPageRestoreReserve will not be
+		 * set. When the page is freed, the global reserve count will
+		 * NOT be incremented and it will appear as though we have
+		 * leaked reserved page.  In this case, set HPageRestoreReserve
+		 * so that the global reserve count will be incremented to
+		 * match the reservation map entry which was created.
 		 *
 		 * Note that vm_alloc_shared is based on the flags of the vma
 		 * for which the page was originally allocated.  dst_vma could
 		 * be different or NULL on error.
 		 */
 		if (vm_alloc_shared)
-			SetPagePrivate(page);
+			SetHPageRestoreReserve(page);
 		else
-			ClearPagePrivate(page);
+			ClearHPageRestoreReserve(page);
 		put_page(page);
 	}
 	BUG_ON(copied < 0);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

userfaultfd-hugetlbfs-fix-new-flag-usage-in-error-path.patch

