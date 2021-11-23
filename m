Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3BB45AF5A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhKWWtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238872AbhKWWtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A454860F5B;
        Tue, 23 Nov 2021 22:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707557;
        bh=5tMIA9XNAUZArQtB3oaAttpPjb5FNx12bM3gfGv3aJg=;
        h=Date:From:To:Subject:From;
        b=kPguxAx2u+H0eTw0tdvjEBE7wPcdNpUvtI2OPYz5ywzQHisOc7IB1LPfm9B/UbAjf
         HKuPWW45sBxOlEhMScbAZijNBWwDH9PqxWfZMeVGH4Kgj5QhXPaCCiMVx08Sn/EyDx
         NfAYraHKrSYJeYAe+hu/UY1FU30jSJPKyqfLAYos=
Date:   Tue, 23 Nov 2021 14:45:57 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, jthoughton@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, weixugc@google.com
Subject:  [merged]
 hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch
 removed from -mm tree
Message-ID: <20211123224557.TWmUGXclm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb, userfaultfd: fix reservation restore on userfaultfd error
has been removed from the -mm tree.  Its filename was
     hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb, userfaultfd: fix reservation restore on userfaultfd error

Currently in the is_continue case in hugetlb_mcopy_atomic_pte(), if we
bail out using "goto out_release_unlock;" in the cases where idx >= size,
or !huge_pte_none(), the code will detect that new_pagecache_page ==
false, and so call restore_reserve_on_error().  In this case I see
restore_reserve_on_error() delete the reservation, and the following call
to remove_inode_hugepages() will increment h->resv_hugepages causing a
100% reproducible leak.

We should treat the is_continue case similar to adding a page into the
pagecache and set new_pagecache_page to true, to indicate that there is no
reservation to restore on the error path, and we need not call
restore_reserve_on_error().  Rename new_pagecache_page to
page_in_pagecache to make that clear.

Link: https://lkml.kernel.org/r/20211117193825.378528-1-almasrymina@google.com
Fixes: c7b1850dfb41 ("hugetlb: don't pass page cache pages to restore_reserve_on_error")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reported-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error
+++ a/mm/hugetlb.c
@@ -5736,13 +5736,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	int ret = -ENOMEM;
 	struct page *page;
 	int writable;
-	bool new_pagecache_page = false;
+	bool page_in_pagecache = false;
 
 	if (is_continue) {
 		ret = -EFAULT;
 		page = find_lock_page(mapping, idx);
 		if (!page)
 			goto out;
+		page_in_pagecache = true;
 	} else if (!*pagep) {
 		/* If a page already exists, then it's UFFDIO_COPY for
 		 * a non-missing case. Return -EEXIST.
@@ -5830,7 +5831,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
-		new_pagecache_page = true;
+		page_in_pagecache = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5894,7 +5895,7 @@ out_release_unlock:
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	if (!new_pagecache_page)
+	if (!page_in_pagecache)
 		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
_

Patches currently in -mm which might be from almasrymina@google.com are


