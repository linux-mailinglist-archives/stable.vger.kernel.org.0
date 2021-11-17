Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F585453D2D
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 01:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhKQAfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 19:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhKQAfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 19:35:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA42F63227;
        Wed, 17 Nov 2021 00:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637109178;
        bh=siHhniUkAiintcq3THxMp48g742kgZng7H8rfFyh+HQ=;
        h=Date:From:To:Subject:From;
        b=CpdloZWOewbEDW1o+DER9GPovh3wG5OcH9vMAKDmIjOEjmFnZGKhvdMSJFNoKdgGo
         lKPkEUxzVVNyo6L811J3Il0JyVVDXRetvrukLsaXhmo0yofp/vh9Qd45uteDkgmRe/
         QCw7P9vAeM9Be8/yS7NK3cYIK1Zh7K7ow3oejO/U=
Date:   Tue, 16 Nov 2021 16:32:57 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, jthoughton@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, weixugc@google.com
Subject:  +
 hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch
 added to -mm tree
Message-ID: <20211117003257.2Gjiup_MW%akpm@linux-foundation.org>
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

hugetlb-userfaultfd-fix-reservation-restore-on-userfaultfd-error.patch

