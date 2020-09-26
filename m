Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0264279617
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 03:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgIZB6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 21:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7024820BED;
        Sat, 26 Sep 2020 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085496;
        bh=ZzZwRtq7AXF4TR8CtH30UvR86KTIWIyWmXtP/O4ND5w=;
        h=Date:From:To:Subject:From;
        b=0pljXMov5QzkM/6zA783FwPU0oMeld3sYrQVF00DaddOFrCZ3mG0JOhz80UD2a3pR
         EjGYkkZywq+KIe116DyG/lL8+Omd2wf7eXp3O458D8Y19mSRKgmSp6gqguHNUpN8YP
         IzC2rIPv3lx7pC3PZjjbe8dkwcrElfmEDodupI8c=
Date:   Fri, 25 Sep 2020 18:58:16 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com,
        richard.weiyang@gmail.com, rientjes@google.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch
 removed from -mm tree
Message-ID: <20200926015816.-MdyU2uzZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: drain per-cpu pages again during memory offline
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drain-per-cpu-pages-again-during-memory-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Link: https://lkml.kernel.org/r/20200904151448.100489-2-pasha.tatashin@soleen.com
Link: http://lkml.kernel.org/r/20200904070235.GA15277@dhcp22.suse.cz
Fixes: c52e75935f8d ("mm: remove extra drain pages on pcp list")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
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


