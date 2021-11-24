Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D434445C623
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349896AbhKXOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353751AbhKXOCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D728B61A81;
        Wed, 24 Nov 2021 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759405;
        bh=cX5CyYvbcEYag1cmPgNea++N9v20C836Mt7qe6OHTUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQiGqSTMTOEk7OkqnjMiw3xcoy9kpT2vpWqRUdrFUlbOVjnvlt/Wk+6J075rmoWll
         XkIqEwSJ9knPgSPc4jPwN0JpOHirzLqRQr/FGBzAWm7OBKx57s57I9BDxBftgjfP3X
         xH81yZkTOTfUrqje+O394fR262ldWCDjALrzLPZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Xu <weixugc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 197/279] hugetlb, userfaultfd: fix reservation restore on userfaultfd error
Date:   Wed, 24 Nov 2021 12:58:04 +0100
Message-Id: <20211124115725.541561611@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mina Almasry <almasrymina@google.com>

commit cc30042df6fcc82ea18acf0dace831503e60a0b7 upstream.

Currently in the is_continue case in hugetlb_mcopy_atomic_pte(), if we
bail out using "goto out_release_unlock;" in the cases where idx >=
size, or !huge_pte_none(), the code will detect that new_pagecache_page
== false, and so call restore_reserve_on_error().  In this case I see
restore_reserve_on_error() delete the reservation, and the following
call to remove_inode_hugepages() will increment h->resv_hugepages
causing a 100% reproducible leak.

We should treat the is_continue case similar to adding a page into the
pagecache and set new_pagecache_page to true, to indicate that there is
no reservation to restore on the error path, and we need not call
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5236,13 +5236,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
@@ -5330,7 +5331,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
-		new_pagecache_page = true;
+		page_in_pagecache = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5394,7 +5395,7 @@ out_release_unlock:
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	if (!new_pagecache_page)
+	if (!page_in_pagecache)
 		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;


