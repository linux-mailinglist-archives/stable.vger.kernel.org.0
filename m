Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0221396A47
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 02:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhFAAel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 20:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhFAAel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 20:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7BBA611BE;
        Tue,  1 Jun 2021 00:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622507580;
        bh=wHULhfAIvhSmuXdGHot/JFXuDvOsD2MrBFuIPdZWyz0=;
        h=Date:From:To:Subject:From;
        b=A6u2u779v8iI2UWU2IhmkwionaxGeNIAoCJ3bDmKRAbLEI29BgETGCi0MkhZZ6wO5
         CWHN69uWPCA5sdh9G93rNhe4dUhIUagCNogJoMFSXf6iQ+pPXBS0g+Vzi58+0uqrgm
         VXwjkG7dYdAwPNpZLkhNE2CpQ2fMG66b2ejvIEhk=
Date:   Mon, 31 May 2021 17:33:00 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org
Subject:  +
 mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch added
 to -mm tree
Message-ID: <20210601003300.HoDvKd81k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch

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
Subject: mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

The userfaultfd hugetlb tests cause a resv_huge_pages underflow. This
happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on an
index for which we already have a page in the cache.  When this happens,
we allocate a second page, double consuming the reservation, and then fail
to insert the page into the cache and return -EEXIST.

To fix this, we first check if there is a page in the cache which already
consumed the reservation, and return -EEXIST immediately if so.

There is still a rare condition where we fail to copy the page contents
AND race with a call for hugetlb_no_page() for this index and again we
will underflow resv_huge_pages.  That is fixed in a more complicated patch
not targeted for -stable.

Test:
Hacked the code locally such that resv_huge_pages underflows produce
a warning, then:

./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings. After the
test runs number of free/resv hugepages is correct.

[mike.kravetz@oracle.com: changelog fixes]
Link: https://lkml.kernel.org/r/20210528004649.85298-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy
+++ a/mm/hugetlb.c
@@ -4889,10 +4889,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		if (!page)
 			goto out;
 	} else if (!*pagep) {
-		ret = -ENOMEM;
+		/* If a page already exists, then it's UFFDIO_COPY for
+		 * a non-missing case. Return -EEXIST.
+		 */
+		if (vm_shared &&
+		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			ret = -EEXIST;
+			goto out;
+		}
+
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			ret = -ENOMEM;
 			goto out;
+		}
 
 		ret = copy_huge_page_from_user(page,
 						(const void __user *) src_addr,
_

Patches currently in -mm which might be from almasrymina@google.com are

mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

