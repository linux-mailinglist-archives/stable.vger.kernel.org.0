Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B82D3A0100
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhFHSur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234350AbhFHSrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3FC613DD;
        Tue,  8 Jun 2021 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177473;
        bh=L17dMDqViDJjliDQM2ImeP0qsqt21qLjtnutnvdm9kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsEvYUAGlXOHkGmFXCBAxAYSROzjx20lD8+Bqk1iHzMqnJnEO6WaSIi+qyEUbXsm8
         b1iUzUPSWEnziFcVGW1TMCZW4IhbHWe7Wk6jSW77+2PkvvVUJYs0v6nIUWZEFIC2Rl
         wpsSAdxOWSNEf4rIL+QbSGjnIpYZ//O/DAPY1D+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/78] mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY
Date:   Tue,  8 Jun 2021 20:27:32 +0200
Message-Id: <20210608175937.401008718@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit d84cf06e3dd8c5c5b547b5d8931015fc536678e5 ]

The userfaultfd hugetlb tests cause a resv_huge_pages underflow.  This
happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
an index for which we already have a page in the cache.  When this
happens, we allocate a second page, double consuming the reservation,
and then fail to insert the page into the cache and return -EEXIST.

To fix this, we first check if there is a page in the cache which
already consumed the reservation, and return -EEXIST immediately if so.

There is still a rare condition where we fail to copy the page contents
AND race with a call for hugetlb_no_page() for this index and again we
will underflow resv_huge_pages.  That is fixed in a more complicated
patch not targeted for -stable.

Test:

  Hacked the code locally such that resv_huge_pages underflows produce a
  warning, then:

  ./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
  ./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings.  After the test runs number
of free/resv hugepages is correct.

[mike.kravetz@oracle.com: changelog fixes]

Link: https://lkml.kernel.org/r/20210528004649.85298-1-almasrymina@google.com
Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3b08e34a775d..fe15e7d8220a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4338,10 +4338,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	struct page *page;
 
 	if (!*pagep) {
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
-- 
2.30.2



