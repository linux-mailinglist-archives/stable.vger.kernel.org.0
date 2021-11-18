Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC74456554
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 23:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhKRWHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 17:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhKRWHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 17:07:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DC7610FC;
        Thu, 18 Nov 2021 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637273072;
        bh=cfQgggidWR/rUD0Jmhzy8dNAtDW8yk6uw+KcRH1dJlw=;
        h=Date:From:To:Subject:From;
        b=nopPLLGYHqcz7JWR3GnTQkFhy54jgHm83yjDBKogWQCJU0VWeXPfE8sV2QaMd4v0X
         RqNwYxWkk2Ry8pa7OCBPeQhA465q9+8PSTtf6hgOyAn2Osxky6dcxvqagZt19Mz6qN
         QoFc0y53lo+nDr9lHLCLYa37+1DD95e1OBEUgz4o=
Date:   Thu, 18 Nov 2021 14:04:32 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, jthoughton@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        weixugc@google.com
Subject:  +
 hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch
 added to -mm tree
Message-ID: <20211118220432.Hwbkn6UvN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb, userfaultfd: fix reservation restore on userfaultfd error
has been added to the -mm tree.  Its filename is
     hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error
+++ a/mm/hugetlb.c
@@ -5734,13 +5734,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
@@ -5828,7 +5829,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
-		new_pagecache_page = true;
+		page_in_pagecache = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5892,7 +5893,7 @@ out_release_unlock:
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

hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

