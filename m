Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EF539E898
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhFGUne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFGUnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96EC061159;
        Mon,  7 Jun 2021 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098484;
        bh=irW1ZGKbfJX4BpTrUbh80bcG42IL6BWcZQGZqJctGjI=;
        h=Date:From:To:Subject:From;
        b=MCEi12LoCQIfKfPSGblpgLVrK14Foc7XAtHIu1eK5ppOBWsXJ3Wb9Se4FRMVVp0TG
         BXEzZ+drNbK7Hl38GIAtLKsU+cOqCUGUbsTiuBdxFYJJ+pJsNs7a9kyDkytuHhVuvN
         I0CNx9USFe4vHTu2aWgQ93+eBcUxctOLC/Jx+oPw=
Date:   Mon, 07 Jun 2021 13:41:24 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch
 removed from -mm tree
Message-ID: <20210607204124.nq0OxGVyS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-simple-resv_huge_pages-underflow-on-uffdio_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
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

mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

