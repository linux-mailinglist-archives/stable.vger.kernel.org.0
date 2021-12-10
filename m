Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68CC470696
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbhLJREf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:04:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35638 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbhLJREf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:04:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05BB9CE1C90;
        Fri, 10 Dec 2021 17:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC6FC00446;
        Fri, 10 Dec 2021 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639155657;
        bh=KZSrHzXkKKoL2Rj6PO7tyfGoORTnaAP5mVVjoj0LXXM=;
        h=Date:From:To:Subject:From;
        b=wXi581f+SoCkg1oXBgmTshYt3bvRw65eoOJ6cV/hG3Q+eaW6RJIzBSaRBYfVkbcvG
         kTToe7AW706JprSL1UylMrcqblHy9hMHi2APCbngPNAbzWr/ise4uYXV0VmenXqKmC
         o5mo68nJGKHbRIQXSwnAkkn3w9C305MMrExJfFR4=
Date:   Fri, 10 Dec 2021 09:00:56 -0800
From:   akpm@linux-foundation.org
To:     luofei@unicloud.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, stable@vger.kernel.org
Subject:  +
 mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch added to -mm tree
Message-ID: <20211210170056.AD9wqxVAz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: fix condition in free hugetlb page path
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch

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
Subject: mm, hwpoison: fix condition in free hugetlb page path

When a memory error hits a tail page of a free hugepage,
__page_handle_poison() is expected to be called to isolate the error in
4kB unit, but it's not called due to the outdated if-condition in
memory_failure_hugetlb().  This loses the chance to isolate the error in
the finer unit, so it's not optimal.  Drop the condition.

This "(p != head && TestSetPageHWPoison(head)" condition is based on the
old semantics of PageHWPoison on hugepage (where PG_hwpoison flag was set
on the subpage), so it's not necessray any more.  By getting to set
PG_hwpoison on head page for hugepages, concurrent error events on
different subpages in a single hugepage can be prevented by
TestSetPageHWPoison(head) at the beginning of memory_failure_hugetlb(). 
So dropping the condition should not reopen the race window originally
mentioned in commit b985194c8c0a ("hwpoison, hugetlb:
lock_page/unlock_page does not match for handling a free hugepage")

Link: https://lkml.kernel.org/r/20211210110208.879740-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Fei Luo <luofei@unicloud.com>
Cc: <stable@vger.kernel.org>	[5.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-condition-in-free-hugetlb-page-path
+++ a/mm/memory-failure.c
@@ -1470,24 +1470,17 @@ static int memory_failure_hugetlb(unsign
 	if (!(flags & MF_COUNT_INCREASED)) {
 		res = get_hwpoison_page(p, flags);
 		if (!res) {
-			/*
-			 * Check "filter hit" and "race with other subpage."
-			 */
 			lock_page(head);
-			if (PageHWPoison(head)) {
-				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
-				    || (p != head && TestSetPageHWPoison(head))) {
+			if (hwpoison_filter(p)) {
+				if (TestClearPageHWPoison(head))
 					num_poisoned_pages_dec();
-					unlock_page(head);
-					return 0;
-				}
+				unlock_page(head);
+				return 0;
 			}
 			unlock_page(head);
-			res = MF_FAILED;
-			if (__page_handle_poison(p)) {
-				page_ref_inc(p);
-				res = MF_RECOVERED;
-			}
+			res = MF_RECOVERED;
+			if (!page_handle_poison(p, true, false))
+				res = MF_FAILED;
 			action_result(pfn, MF_MSG_FREE_HUGE, res);
 			return res == MF_RECOVERED ? 0 : -EBUSY;
 		} else if (res < 0) {
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch
mm-hwpoison-mf_mutex-for-soft-offline-and-unpoison.patch
mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch
mm-hwpoison-fix-unpoison_memory.patch

