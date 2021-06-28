Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00583B6048
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhF1OXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233421AbhF1OWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2149061C95;
        Mon, 28 Jun 2021 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889980;
        bh=/B3PocEAdMGFBNlkc9BqDH+WNw/ZyVBO3rD7Cb0QLyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q92LE29AdQ6WLeDGMIp+CCLgIAiGFR73+TeJ8uJkLfusDjCiaVdQSdOue7L/8TqxN
         5tQCknYy/hVt21JX4zJMZXFS5Byr+bJ4nPiY8y6dLEJZvdPyvxIHzPfDExIY3UWdbe
         JOkfULIB0XPoTLZDvT8j5PEULeuJPKZaiw1EBhyWArDIdJLY595KhzQk+J0CuC3hRL
         NAEVfBv/5EWoVuBq1VnObUNJYKsZX/324io+jYWVyooLSb2a8IUj+ZP7AkoIJnyJ8l
         cS1NSh3vX2FoPi0We0nIg5ASRgty+Iq1WRFQXA0nTdpWz3l3ydl9sV3KKpUmmMizDP
         +7Fl/LkuH4cIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Borislav Petkov <bp@suse.de>,
        Oscar Salvador <osalvador@suse.de>,
        Aili Yao <yaoaili@kingsoft.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        David Hildenbrand <david@redhat.com>,
        Jue Wang <juew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 081/110] mm/memory-failure: use a mutex to avoid memory_failure() races
Date:   Mon, 28 Jun 2021 10:17:59 -0400
Message-Id: <20210628141828.31757-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit 171936ddaf97e6f4e1264f4128bb5cf15691339c upstream.

Patch series "mm,hwpoison: fix sending SIGBUS for Action Required MCE", v5.

I wrote this patchset to materialize what I think is the current
allowable solution mentioned by the previous discussion [1].  I simply
borrowed Tony's mutex patch and Aili's return code patch, then I queued
another one to find error virtual address in the best effort manner.  I
know that this is not a perfect solution, but should work for some
typical case.

[1]: https://lore.kernel.org/linux-mm/20210331192540.2141052f@alex-virtual-machine/

This patch (of 2):

There can be races when multiple CPUs consume poison from the same page.
The first into memory_failure() atomically sets the HWPoison page flag
and begins hunting for tasks that map this page.  Eventually it
invalidates those mappings and may send a SIGBUS to the affected tasks.

But while all that work is going on, other CPUs see a "success" return
code from memory_failure() and so they believe the error has been
handled and continue executing.

Fix by wrapping most of the internal parts of memory_failure() in a
mutex.

[akpm@linux-foundation.org: make mf_mutex local to memory_failure()]

Link: https://lkml.kernel.org/r/20210521030156.2612074-1-nao.horiguchi@gmail.com
Link: https://lkml.kernel.org/r/20210521030156.2612074-2-nao.horiguchi@gmail.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 704d05057d8c..2dd60ad81216 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1429,9 +1429,10 @@ int memory_failure(unsigned long pfn, int flags)
 	struct page *hpage;
 	struct page *orig_head;
 	struct dev_pagemap *pgmap;
-	int res;
+	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	static DEFINE_MUTEX(mf_mutex);
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1449,13 +1450,18 @@ int memory_failure(unsigned long pfn, int flags)
 		return -ENXIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 try_again:
-	if (PageHuge(p))
-		return memory_failure_hugetlb(pfn, flags);
+	if (PageHuge(p)) {
+		res = memory_failure_hugetlb(pfn, flags);
+		goto unlock_mutex;
+	}
+
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	orig_head = hpage = compound_head(p);
@@ -1488,17 +1494,19 @@ try_again:
 				res = MF_FAILED;
 			}
 			action_result(pfn, MF_MSG_BUDDY, res);
-			return res == MF_RECOVERED ? 0 : -EBUSY;
+			res = res == MF_RECOVERED ? 0 : -EBUSY;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
 		}
+		goto unlock_mutex;
 	}
 
 	if (PageTransHuge(hpage)) {
 		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
+			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
@@ -1522,7 +1530,7 @@ try_again:
 	if (PageCompound(p) && compound_head(p) != orig_head) {
 		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1542,14 +1550,14 @@ try_again:
 		num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	/*
@@ -1573,7 +1581,7 @@ try_again:
 	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1582,13 +1590,15 @@ try_again:
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
-out:
+unlock_page:
 	unlock_page(p);
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
 	return res;
 }
 EXPORT_SYMBOL_GPL(memory_failure);
-- 
2.30.2

