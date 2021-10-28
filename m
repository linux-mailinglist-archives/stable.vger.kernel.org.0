Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A643F1DE
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 23:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhJ1Vig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 17:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230476AbhJ1Vig (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BAF60FE3;
        Thu, 28 Oct 2021 21:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456968;
        bh=84gMrMkS11wA2Rk+CJ1QmnKRVd4oIENPgFHHYXhN+rA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VMN4m3C4Url1lvCikMOZE/mPmbO53vmzk4UoekmcnVF3/yqZhc+6BYjHKGMmQPykI
         TRcZJe9JtUhVIc1rxauLCDLa1XILkzXG4dYTMc9TDr/bPzIqiJD/Smfx6LASkgg1pq
         8C2Yyu5Pxg9e3iiCpqoo7YwIL6J6tA9LGRxnw/X4=
Date:   Thu, 28 Oct 2021 14:36:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 02/11] mm: hwpoison: remove the unnecessary THP
 check
Message-ID: <20211028213607.dE5Qz5QgJ%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: remove the unnecessary THP check

When handling THP hwpoison checked if the THP is in allocation or free
stage since hwpoison may mistreat it as hugetlb page.  After commit
415c64c1453a ("mm/memory-failure: split thp earlier in memory error
handling") the problem has been fixed, so this check is no longer needed. 
Remove it.  The side effect of the removal is hwpoison may report unsplit
THP instead of unknown error for shmem THP.  It seems not like a big deal.

The following patch "mm: filemap: check if THP has hwpoisoned subpage for
PMD page fault" depends on this, which fixes shmem THP with hwpoisoned
subpage(s) are mapped PMD wrongly.  So this patch needs to be backported
to -stable as well.

Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-the-unnecessary-thp-check
+++ a/mm/memory-failure.c
@@ -1147,20 +1147,6 @@ static int __get_hwpoison_page(struct pa
 	if (!HWPoisonHandlable(head))
 		return -EBUSY;
 
-	if (PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
-
 	if (get_page_unless_zero(head)) {
 		if (head == compound_head(page))
 			return 1;
_
