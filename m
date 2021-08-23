Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11093F5052
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhHWSZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 14:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhHWSZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 14:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A266A61391;
        Mon, 23 Aug 2021 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743060;
        bh=XC98fyW/FL42Bt9m2kBp31tP0V3/KkINv330oZozwSs=;
        h=Date:From:To:Subject:From;
        b=La/ISxXq979iGTF9RHrXRF+5ecUNJ99jVAckoF9d8z33Lz5b+wzyt8ltVY3VcYSI1
         EixhaOxyuHIb2sSwjM9SM49A4XMW2jySoGBEk4cplZGTNnF/93x+zpUjoLa0aVN6go
         8XzEVqmfAzhGC66wdBWrBzGcG7RHFGg6hGI9ZRAc=
Date:   Mon, 23 Aug 2021 11:24:20 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, tony.luck@intel.com
Subject:  [merged]
 mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch removed from
 -mm tree
Message-ID: <20210823182420.61fcT5s8c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: retry with shake_page() for unhandlable pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-sparse-set-section_nid_shift-to-6.patch

