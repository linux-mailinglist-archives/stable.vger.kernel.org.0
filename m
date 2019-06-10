Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD56B3BE81
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 23:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390064AbfFJVW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 17:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389998AbfFJVW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 17:22:57 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8FE2082E;
        Mon, 10 Jun 2019 21:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560201776;
        bh=6A4oWPa3qhW4Z77++Is2lXiigNCvk+CIUzOstqHeRnI=;
        h=Date:From:To:Subject:From;
        b=BDfMuTkY9Gej0T+fxWBaSbfcudsGQlaHeS5QhQTh6WOTlG8eBkfoQ+pBHWbiIG8kk
         h44SH5TjPsMcI9wL6vh3h3uz/1tlROHZwtYaVs4wc3NzDMUYCq5qy5s8Q4+CTR0nq/
         eWtF/txA8GCmIjJ9DOF2J8B6g6Qr2hOPHdIqYQx8=
Date:   Mon, 10 Jun 2019 14:22:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, xishi.qiuxishi@alibaba-inc.com,
        stable@vger.kernel.org, qiuxu.zhuo@intel.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, jerry.t.chen@intel.com,
        n-horiguchi@ah.jp.nec.com
Subject:  +
 mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch
 added to -mm tree
Message-ID: <20190610212256.xdV_I%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fails
has been added to the -mm tree.  Its filename is
     mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch

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
Subject: mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fails

The pass/fail of soft offline should be judged by checking whether the raw
error page was finally contained or not (i.e.  the result of
set_hwpoison_free_buddy_page()), but current code do not work like that. 
So this patch is suggesting to fix it.

Link: http://lkml.kernel.org/r/1560154686-18497-2-git-send-email-n-horiguchi@ah.jp.nec.com
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

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails
+++ a/mm/memory-failure.c
@@ -1730,6 +1730,8 @@ static int soft_offline_huge_page(struct
 		if (!ret) {
 			if (set_hwpoison_free_buddy_page(page))
 				num_poisoned_pages_inc();
+			else
+				ret = -EBUSY;
 		}
 	}
 	return ret;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch
mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge.patch

