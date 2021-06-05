Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4326339C55B
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhFEDDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhFEDDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0DB561205;
        Sat,  5 Jun 2021 03:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862097;
        bh=BP9KmdZjvCAqiZBnH32/BHXJnx23Cz2BZ1gm3TVx6V0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XSKEjpmyZDUX7681HqPmhOmBYGjl/GrXlY375ap40jS0+r1yIUEu8K3Ou2B6k/3Ll
         T3I+4p10ZdCdhErjb64wnkbQTfo2FxaT9jHfcrqxAacoWMJ4OhM22Y9/YsbqPySqQL
         4GvY5DlGgPQnptZbmEMoOWZOGbm4eH2i+rUMdwow=
Date:   Fri, 04 Jun 2021 20:01:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/13] mm, hugetlb: fix simple resv_huge_pages
 underflow on UFFDIO_COPY
Message-ID: <20210605030136.4bhX4XMbm%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
