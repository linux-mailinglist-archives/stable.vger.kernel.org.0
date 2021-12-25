Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE847F201
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 06:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhLYFMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 00:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 00:12:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3814C061401;
        Fri, 24 Dec 2021 21:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 606E4B80939;
        Sat, 25 Dec 2021 05:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D675CC36AE5;
        Sat, 25 Dec 2021 05:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409166;
        bh=t1cKdzqXaN9juD51UD8CmyrMzm8EciQHDZMKnzSa3xk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oCc7X0JSK/XViToPutcUMR93WkiTlosKmOMselPvWweQ2xfsRlGV4fhngKzO5/Dq4
         MD6PoyAvEnmImr1kTzCKxK7ekbdOKYmcNbOizFOTsEUSWcbBnhoSUnQsux2tJ/RDOA
         0gXNN6ZQ3NTBafwGxAHzE6sgdfO2CqiKSsatZU58=
Date:   Fri, 24 Dec 2021 21:12:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, luofei@unicloud.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 5/9] mm, hwpoison: fix condition in free hugetlb
 page path
Message-ID: <20211225051245.qaFlHGVIZ%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
