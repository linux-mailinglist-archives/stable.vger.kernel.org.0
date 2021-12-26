Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D99747F941
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 23:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhLZWUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 17:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhLZWUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 17:20:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B2C06173E;
        Sun, 26 Dec 2021 14:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0889B80DE2;
        Sun, 26 Dec 2021 22:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D450C36AEB;
        Sun, 26 Dec 2021 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557205;
        bh=oxHKm4rVyp7+RN+eA2NL739goH0xHrKkJqCDF9JaBGI=;
        h=Date:From:To:Subject:From;
        b=fenuz4wNDKt1M8EuIPebv5cPcw6mbxVa+EARrbM49hQC+EPdxjBCHmWaoFuI1TvVd
         qMGYUxAeVJbuAxwmOKX6i5GMWBi6MPjmM6uHkr+2NKjOv0E8AwZeHY66JgEXnH/aYy
         IGyjTBxUUUdvAHDZAyytWEBxIhT1PxHYZcW1msd4=
Date:   Sun, 26 Dec 2021 14:20:05 -0800
From:   akpm@linux-foundation.org
To:     luofei@unicloud.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch removed from -mm
 tree
Message-ID: <20211226222005.io-zrMSG3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: fix condition in free hugetlb page path
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[naoya.horiguchi@linux.dev: fix "HardwareCorrupted" counter]
  Link: https://lkml.kernel.org/r/20211220084851.GA1460264@u2004
Link: https://lkml.kernel.org/r/20211210110208.879740-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Fei Luo <luofei@unicloud.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>	[5.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-condition-in-free-hugetlb-page-path
+++ a/mm/memory-failure.c
@@ -1470,17 +1470,12 @@ static int memory_failure_hugetlb(unsign
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
 			res = MF_FAILED;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-mf_mutex-for-soft-offline-and-unpoison.patch
mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch
mm-hwpoison-fix-unpoison_memory.patch

