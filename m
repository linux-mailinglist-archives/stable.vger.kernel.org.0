Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2125C982
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 21:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgICT3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 15:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgICT3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 15:29:03 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5FB206EF;
        Thu,  3 Sep 2020 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161342;
        bh=sMCKS+E6u2EB80XPD2BBSYYo9l/B/+fP5653BznJWVQ=;
        h=Date:From:To:Subject:From;
        b=Jqzj+40dDjkGxuUueBPENnX4xazqzQFgL/zaMIk7GaqU9zFt7RF5yNJMJLdbrR5GY
         qlaFMFq0an/8BqG/+K3mboIiAdzsfWcVl/jWnUh7ouabZ15Ok6afYWsWIewkQXIovj
         tzNpSzWIwlfNXUTjonM15DJQ1r+sLWqULEUQpET0=
Date:   Thu, 03 Sep 2020 12:29:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        rientjes@google.com, richard.weiyang@gmail.com, osalvador@suse.de,
        mhocko@suse.com, david@redhat.com, pasha.tatashin@soleen.com
Subject:  +
 mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch added
 to -mm tree
Message-ID: <20200903192901.PWYfu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: drain per-cpu pages again during memory offline
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/memory_hotplug: drain per-cpu pages again during memory offline

There is a race during page offline that can lead to infinite loop:
a page never ends up on a buddy list and __offline_pages() keeps
retrying infinitely or until a termination signal is received.

Thread#1 - a new process:

load_elf_binary
 begin_new_exec
  exec_mmap
   mmput
    exit_mmap
     tlb_finish_mmu
      tlb_flush_mmu
       release_pages
        free_unref_page_list
         free_unref_page_prepare
          set_pcppage_migratetype(page, migratetype);
             // Set page->index migration type below  MIGRATE_PCPTYPES

Thread#2 - hot-removes memory
__offline_pages
  start_isolate_page_range
    set_migratetype_isolate
      set_pageblock_migratetype(page, MIGRATE_ISOLATE);
        Set migration type to MIGRATE_ISOLATE-> set
        drain_all_pages(zone);
             // drain per-cpu page lists to buddy allocator.

Thread#1 - continue
         free_unref_page_commit
           migratetype = get_pcppage_migratetype(page);
              // get old migration type
           list_add(&page->lru, &pcp->lists[migratetype]);
              // add new page to already drained pcp list

Thread#2
Never drains pcp again, and therefore gets stuck in the loop.

The fix is to try to drain per-cpu lists again after
check_pages_isolated_cb() fails.

Link: https://lkml.kernel.org/r/20200903140032.380431-1-pasha.tatashin@soleen.com
Fixes: c52e75935f8d ("mm: remove extra drain pages on pcp list")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   14 ++++++++++++++
 mm/page_isolation.c |    8 ++++++++
 2 files changed, 22 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline
+++ a/mm/memory_hotplug.c
@@ -1575,6 +1575,20 @@ static int __ref __offline_pages(unsigne
 		/* check again */
 		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
 					    NULL, check_pages_isolated_cb);
+		/*
+		 * per-cpu pages are drained in start_isolate_page_range, but if
+		 * there are still pages that are not free, make sure that we
+		 * drain again, because when we isolated range we might
+		 * have raced with another thread that was adding pages to pcp
+		 * list.
+		 *
+		 * Forward progress should be still guaranteed because
+		 * pages on the pcp list can only belong to MOVABLE_ZONE
+		 * because has_unmovable_pages explicitly checks for
+		 * PageBuddy on freed pages on other zones.
+		 */
+		if (ret)
+			drain_all_pages(zone);
 	} while (ret);
 
 	/* Ok, all of our target is isolated.
--- a/mm/page_isolation.c~mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline
+++ a/mm/page_isolation.c
@@ -170,6 +170,14 @@ __first_valid_page(unsigned long pfn, un
  * pageblocks we may have modified and return -EBUSY to caller. This
  * prevents two threads from simultaneously working on overlapping ranges.
  *
+ * Please note that there is no strong synchronization with the page allocator
+ * either. Pages might be freed while their page blocks are marked ISOLATED.
+ * In some cases pages might still end up on pcp lists and that would allow
+ * for their allocation even when they are in fact isolated already. Depending
+ * on how strong of a guarantee the caller needs drain_all_pages might be needed
+ * (e.g. __offline_pages will need to call it after check for isolated range for
+ * a next retry).
+ *
  * Return: the number of isolated pageblocks on success and -EBUSY if any part
  * of range cannot be isolated.
  */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch

