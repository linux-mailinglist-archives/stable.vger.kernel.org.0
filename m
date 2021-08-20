Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDBB3F2492
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhHTCFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 22:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831D6610FE;
        Fri, 20 Aug 2021 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425064;
        bh=Vc5t3ffg54MDOH+Bu8ofC9/2wjypspqcsOqm1+KcvWk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DSnLOvfhNTTCjMAGUesYSoYC5NE8hjHCjhDcwIXLRDR4wva/B2xy/l3r0SbiALSI9
         wA2fPccdtVYBRVricPnbQBtSIha2nnu+MYbnfZPc5sdwsA/GFJYHP3Iy2YN9S8yxXK
         4xcM6eItqD3zYL4pAt4NmwX2449/fjNSFxSnjDHA=
Date:   Thu, 19 Aug 2021 19:04:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 07/10] mm/hwpoison: retry with shake_page() for
 unhandlable pages
Message-ID: <20210820020424.MPo-2MFQJ%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: retry with shake_page() for unhandlable pages

HWPoisonHandlable() sometimes returns false for typical user pages due to
races with average memory events like transfers over LRU lists.  This
causes failures in hwpoison handling.

There's retry code for such a case but does not work because the retry
loop reaches the retry limit too quickly before the page settles down to
handlable state.  Let get_any_page() call shake_page() to fix it.

[naoya.horiguchi@nec.com: get_any_page(): return -EIO when retry limit reached]
  Link: https://lkml.kernel.org/r/20210819001958.2365157-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20210817053703.2267588-1-naoya.horiguchi@linux.dev
Fixes: 25182f05ffed ("mm,hwpoison: fix race with hugetlb page allocation")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>		[5.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-retry-with-shake_page-for-unhandlable-pages
+++ a/mm/memory-failure.c
@@ -1146,7 +1146,7 @@ static int __get_hwpoison_page(struct pa
 	 * unexpected races caused by taking a page refcount.
 	 */
 	if (!HWPoisonHandlable(head))
-		return 0;
+		return -EBUSY;
 
 	if (PageTransHuge(head)) {
 		/*
@@ -1199,9 +1199,15 @@ try_again:
 			}
 			goto out;
 		} else if (ret == -EBUSY) {
-			/* We raced with freeing huge page to buddy, retry. */
-			if (pass++ < 3)
+			/*
+			 * We raced with (possibly temporary) unhandlable
+			 * page, retry.
+			 */
+			if (pass++ < 3) {
+				shake_page(p, 1);
 				goto try_again;
+			}
+			ret = -EIO;
 			goto out;
 		}
 	}
_
