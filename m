Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87E48006D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhL0PqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbhL0Por (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59CBF610A2;
        Mon, 27 Dec 2021 15:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B06C36AEA;
        Mon, 27 Dec 2021 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619884;
        bh=GVZWDSy7d4AbwiKbYJ1h5Ls7xMXkmzsQC7rQL1OgdZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mB85GW22H1ehMnzBYEez6QNrNRp4of8pXf1D7j6XlLydgXvbUTwACCdXJlgKHEPfM
         5RrCz1KHwzA/uaC4MMG2Y9gO5BYdroB5pcSVVQG/Kb/S3Usts+YH2IkGxxYmnAlyy/
         RNmCn+njCCin3U6aaLlaBrsleKWY3GLz7ckcP0lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Fei Luo <luofei@unicloud.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 103/128] mm, hwpoison: fix condition in free hugetlb page path
Date:   Mon, 27 Dec 2021 16:31:18 +0100
Message-Id: <20211227151334.954562629@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit e37e7b0b3bd52ec4f8ab71b027bcec08f57f1b3b upstream.

When a memory error hits a tail page of a free hugepage,
__page_handle_poison() is expected to be called to isolate the error in
4kB unit, but it's not called due to the outdated if-condition in
memory_failure_hugetlb().  This loses the chance to isolate the error in
the finer unit, so it's not optimal.  Drop the condition.

This "(p != head && TestSetPageHWPoison(head)" condition is based on the
old semantics of PageHWPoison on hugepage (where PG_hwpoison flag was
set on the subpage), so it's not necessray any more.  By getting to set
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1437,17 +1437,12 @@ static int memory_failure_hugetlb(unsign
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


