Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB2456548
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 23:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhKRWEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 17:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhKRWEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 17:04:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8114361A8E;
        Thu, 18 Nov 2021 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637272912;
        bh=1smsR2xEdjXD91VmcFHsxTD7k+owAPiSBdiSfHyRNpc=;
        h=Date:From:To:Subject:From;
        b=l+CQlNyg38usYiBiMzsaI3B5CwqfuGjVG6tNp7y849MFvkslSHFhWwbCKBGYB8sTk
         t8J7p/hZMOdL801Y8wS6TDUh3xABu0C+Dw1kZ/BACkfrxG7sTw3uBfvwATIxLUnt1W
         GTgN5YjCROgPpbh68TrToVspN/lw03uGJ8TMiRjk=
Date:   Thu, 18 Nov 2021 14:01:51 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, jthoughton@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, weixugc@google.com
Subject:  [to-be-updated]
 hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch
 removed from -mm tree
Message-ID: <20211118220151.UEitgQxpC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb, userfaultfd: fix reservation restore on userfaultfd error
has been removed from the -mm tree.  Its filename was
     hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

This patch was dropped because an updated version will be merged

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
restore_reserve_on_error().

Link: https://lkml.kernel.org/r/20211116235733.3774702-1-almasrymina@google.com
Fixes: c7b1850dfb41 ("hugetlb: don't pass page cache pages to restore_reserve_on_error")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reported-by: James Houghton <jthoughton@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/hugetlb.c~hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error
+++ a/mm/hugetlb.c
@@ -5743,6 +5743,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		page = find_lock_page(mapping, idx);
 		if (!page)
 			goto out;
+		/*
+		 * Set new_pagecache_page to true, as we've added a page to the
+		 * pagecache, but userfaultfd hasn't set up a mapping for this
+		 * page yet. If we bail out before setting up the mapping, we
+		 * want to indicate to restore_reserve_on_error() that we've
+		 * added the page to the page cache.
+		 */
+		new_pagecache_page = true;
 	} else if (!*pagep) {
 		/* If a page already exists, then it's UFFDIO_COPY for
 		 * a non-missing case. Return -EEXIST.
_

Patches currently in -mm which might be from almasrymina@google.com are


