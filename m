Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBD43F647E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhHXRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234877AbhHXRCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B648D61882;
        Tue, 24 Aug 2021 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824289;
        bh=XeeMr38iQ0i4olwwCt11F3iC7LgHZ7gcMd/4yzKy7/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT8vQL3IQV4IgKJdD7CRt67FGu6rcCnsD0Pq19s74aKLzUPYYkDzk7Z83sYLHzEAU
         HGC7f2gGvNtHVXFBXSuG6s8U/mgrWe2g02eKSvPHxkrncL45ttj3ac+kYTEbXw0gBI
         x2qvHCyWXlHBxRryPRgNLdKgkjjZwMqJZAK80G369E2CbIpekKspcpmb5c02GdqnLl
         5ISI0jrBDqxLK+a9yfhIkrz7/oBpaBEne1y9omI3MD7i6kk8A0nVAPaVveQzRYdmfc
         zaVtr4qsGduR5KfG+2Ij7TfGLD+tmILQkvQurCjMULIT9xAneiFmGJLAHmq+wfzPDX
         J2k3SYcqEeuWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Tony Luck <tony.luck@intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 122/127] mm/hwpoison: retry with shake_page() for unhandlable pages
Date:   Tue, 24 Aug 2021 12:56:02 -0400
Message-Id: <20210824165607.709387-123-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

[ Upstream commit fcc00621d88b274b5dffd8daeea71d0e4c28b84e ]

HWPoisonHandlable() sometimes returns false for typical user pages due
to races with average memory events like transfers over LRU lists.  This
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 18e83150194a..624763fdecc5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -990,7 +990,7 @@ static int __get_hwpoison_page(struct page *page)
 	 * unexpected races caused by taking a page refcount.
 	 */
 	if (!HWPoisonHandlable(head))
-		return 0;
+		return -EBUSY;
 
 	if (PageTransHuge(head)) {
 		/*
@@ -1043,9 +1043,15 @@ try_again:
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
-- 
2.30.2

