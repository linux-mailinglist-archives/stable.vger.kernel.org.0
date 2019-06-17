Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04874960C
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfFQXpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfFQXpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 19:45:52 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD42B20861;
        Mon, 17 Jun 2019 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560815151;
        bh=FoWDDd7J2gxHkJlDgwf8UameYSQyE1IYK05OaiixvzI=;
        h=Date:From:To:Subject:From;
        b=FSyNqr4Qas/W+k/6u9o3DOmwvznQiW09cHBvU3m4wfp4hEPBqoco187qM4Rbp/GF+
         wNRy0IfAdyPugPc58NJsxLumUoW+c4nmRPxx9Z0bMgXO976pt+wiE1gfkuGLKHmMnc
         yaPhINxjJBz89gk6uQUKQvOEc2wV1P+p2dVirBtc=
Date:   Mon, 17 Jun 2019 16:45:50 -0700
From:   akpm@linux-foundation.org
To:     jerry.t.chen@intel.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        qiuxu.zhuo@intel.com, stable@vger.kernel.org,
        xishi.qiuxishi@alibaba-inc.com
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-soft-offline-dissolve=5Ffree=5Fhuge=5Fpage-retu?=
 =?US-ASCII?Q?rn-zero-on-pagehuge-v3.patch?= added to -mm tree
Message-ID: <20190617234550.BAUVd6-Qh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3
has been added to the -mm tree.  Its filename is
     mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3

- add PageHuge check in dissolve_free_huge_page() outside hugetlb_lock
- update comment on dissolve_free_huge_page() about return value

Link: http://lkml.kernel.org/r/1560761476-4651-3-git-send-email-n-horiguchi@ah.jp.nec.com
Reported-by: Chen, Jerry T <jerry.t.chen@intel.com>
Tested-by: Chen, Jerry T <jerry.t.chen@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>
Cc: "Chen, Jerry T" <jerry.t.chen@intel.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3
+++ a/mm/hugetlb.c
@@ -1510,14 +1510,22 @@ static int free_pool_huge_page(struct hs
 
 /*
  * Dissolve a given free hugepage into free buddy pages. This function does
- * nothing for in-use (including surplus) hugepages. Returns -EBUSY if the
- * dissolution fails because a give page is not a free hugepage, or because
- * free hugepages are fully reserved.
+ * nothing for in-use hugepages and non-hugepages.
+ * This function returns values like below:
+ *
+ *  -EBUSY: failed to dissolved free hugepages or the hugepage is in-use
+ *          (allocated or reserved.)
+ *       0: successfully dissolved free hugepages or the page is not a
+ *          hugepage (considered as already dissolved)
  */
 int dissolve_free_huge_page(struct page *page)
 {
 	int rc = -EBUSY;
 
+	/* Not to disrupt normal path by vainly holding hugetlb_lock */
+	if (!PageHuge(page))
+		return 0;
+
 	spin_lock(&hugetlb_lock);
 	if (!PageHuge(page)) {
 		rc = 0;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch
mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge.patch
mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge-v3.patch

