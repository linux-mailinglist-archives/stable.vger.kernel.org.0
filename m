Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0813B5566
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhF0V4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823C161A1D;
        Sun, 27 Jun 2021 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830852;
        bh=BmuDkZ2rg0SlCnnw9mWYV4CNFAiV4hJ5S0+YueMrkIs=;
        h=Date:From:To:Subject:From;
        b=vJTVr6vBVQyy0wyLuQ1lbrQ6hlAWuvJP9QE3SlmKPh38eAgFPBYsiIqXS5ubZ/vqz
         S+eJhwKA0ZwF/udsnxI9+K+H1h5QrPjxCEvkMYkASB2eX6QkaKWVDXhihoamIKoXSY
         Bi05flVssesqXMNwF6q2d0D88hE88BctmRi7Ek04=
Date:   Sun, 27 Jun 2021 14:54:12 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com, yaoaili@kingsoft.com
Subject:  [merged]
 mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch removed
 from -mm tree
Message-ID: <20210627215412.pxIvw5LWw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: use a mutex to avoid memory_failure() races
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memory-failure: use a mutex to avoid memory_failure() races

Patch series "mm,hwpoison: fix sending SIGBUS for Action Required MCE", v5.

I wrote this patchset to materialize what I think is the current allowable
solution mentioned by the previous discussion [1].  I simply borrowed
Tony's mutex patch and Aili's return code patch, then I queued another one
to find error virtual address in the best effort manner.  I know that this
is not a perfect solution, but should work for some typical case.

[1]: https://lore.kernel.org/linux-mm/20210331192540.2141052f@alex-virtual-machine/


This patch (of 2):

There can be races when multiple CPUs consume poison from the same page. 
The first into memory_failure() atomically sets the HWPoison page flag and
begins hunting for tasks that map this page.  Eventually it invalidates
those mappings and may send a SIGBUS to the affected tasks.

But while all that work is going on, other CPUs see a "success" return
code from memory_failure() and so they believe the error has been handled
and continue executing.

Fix by wrapping most of the internal parts of memory_failure() in a mutex.

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
---

 mm/memory-failure.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races
+++ a/mm/memory-failure.c
@@ -1429,9 +1429,10 @@ int memory_failure(unsigned long pfn, in
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
@@ -1449,13 +1450,18 @@ int memory_failure(unsigned long pfn, in
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
_

Patches currently in -mm which might be from tony.luck@intel.com are


