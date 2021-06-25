Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF143B3A8C
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhFYBmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhFYBmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71A9610A7;
        Fri, 25 Jun 2021 01:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585196;
        bh=6fkel34X+r3cYhGIPOjZI7eSlV9X/QHEPVs+9zgJ7VU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rf/ZOKKbewboIpa7i7AcpVMQVbQxWFFOStmsGacUL3KCmlg139h2AqCu8QIppTGlY
         GXtPJrQWOPYRvo6ogU4wR1IAXezwe+IOVsP2Fig6S147RSoajpWXI8Rfs8ovc9sjX9
         essyxz9jpSWb/yTE6R1FUYDV8BRjQbpCjYnNMnIs=
Date:   Thu, 24 Jun 2021 18:39:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, bp@suse.de,
        david@redhat.com, juew@google.com, linux-mm@kvack.org,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        yaoaili@kingsoft.com
Subject:  [patch 18/24] mm/memory-failure: use a mutex to avoid
 memory_failure() races
Message-ID: <20210625013955.Ag67YQBoO%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
