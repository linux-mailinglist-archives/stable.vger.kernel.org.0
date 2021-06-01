Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB8D38F00D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhEXQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233383AbhEXP76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA4A6197F;
        Mon, 24 May 2021 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871142;
        bh=aAjVCoHuBFFB0qLuAjZcEcA3juRVQ2S3H8dDHZ8/oMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viPQvWYu0p6ViMiDea3dN2TRboPvZ5QiSmy9gwLnPZhUhQUemJVCZezxeMuqkNe+q
         fijguUoAqooV+3VtvgiiytPugrKAM4I9GCTZvMGsKPirldTCy+dW023BGOhU5JPcL+
         pCA/MH3HqxlJX5Fpr7ssGTHGTfzRupUGHQG3sU3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Mina Almasry <almasry.mina@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 091/127] userfaultfd: hugetlbfs: fix new flag usage in error path
Date:   Mon, 24 May 2021 17:26:48 +0200
Message-Id: <20210524152337.926625839@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit e32905e57358fdfb82f9de024534f205b3af7dac upstream.

In commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") the use of PagePrivate to indicate a reservation count
should be restored at free time was changed to the hugetlb specific flag
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 mm/userfaultfd.c     |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -532,7 +532,7 @@ static void remove_inode_hugepages(struc
 			 * the subpool and global reserve usage count can need
 			 * to be adjusted.
 			 */
-			VM_BUG_ON(PagePrivate(page));
+			VM_BUG_ON(HPageRestoreReserve(page));
 			remove_huge_page(page);
 			freed++;
 			if (!truncate_op) {
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -362,38 +362,38 @@ out:
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


