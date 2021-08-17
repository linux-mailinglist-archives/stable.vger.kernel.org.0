Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16D3EF419
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 22:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhHQUch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 16:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230459AbhHQUch (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 16:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADCB56023E;
        Tue, 17 Aug 2021 20:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629232323;
        bh=uIavxu9uKJaSsw8MALMGLJLa81eFsOuWBNrUY1dAXrE=;
        h=Date:From:To:Subject:From;
        b=xwrWDtWU5mPYOiE5IOedzDxlHLpkqjkJ00LCboUJwYrnUkqpMU4k1ErRqJ8t2DQ9R
         CMBJ6Wr5ZzhdtrRUnAIBMHtwl6MilYOTq6C1ZXFzAQUfUmcIP/IvgresB2+RjpBT4y
         1PwJDjBQxcUixto7r2lxTpooN5U9oF11uFY7NqQg=
Date:   Tue, 17 Aug 2021 13:32:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, mhocko@suse.com,
        naoya.horiguchi@nec.com
Subject:  +
 mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch added to -mm
 tree
Message-ID: <20210817203203.Piw81%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: retry with shake_page() for unhandlable pages
has been added to the -mm tree.  Its filename is
     mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: retry with shake_page() for unhandlable pages

HWPoisonHandlable() sometimes returns false for typical user pages due to
races with average memory events like transfers over LRU lists.  This
causes failures in hwpoison handling.

There's retry code for such a case but does not work because the retry
loop reaches the retry limit too quickly before the page settles down to
handlable state.  Let get_any_page() call shake_page() to fix it.

Link: https://lkml.kernel.org/r/20210817053703.2267588-1-naoya.horiguchi@linux.dev
Fixes: 25182f05ffed ("mm,hwpoison: fix race with hugetlb page allocation")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>		[5.13]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

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
@@ -1199,9 +1199,14 @@ try_again:
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
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch
mm-sparse-set-section_nid_shift-to-6.patch

