Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4608B272E95
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgIUQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbgIUQua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02292388B;
        Mon, 21 Sep 2020 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707029;
        bh=HbNoSSYOXLEEhv12kudrQ5HwgWF88cDoCx4+TtWfGTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8rvCthVTse9mr3t32/I6q+bk6gMVGGhm6qHWBXab5zBDeWUppvZGUghNeTENeuIa
         dnbNSN80dMaTzMnRN354U5ofaisL2iAm9V9EnPLEIXHsQMs6RdcFQ3r0jdpgViIxvY
         WZF076fxrwcEAUC8Eq5HNUOIMBFTxPhe2xdzWGzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 70/72] mm/memory_hotplug: drain per-cpu pages again during memory offline
Date:   Mon, 21 Sep 2020 18:31:49 +0200
Message-Id: <20200921163125.191811835@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

commit 9683182612214aa5f5e709fad49444b847cd866a upstream.

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

Fixes: c52e75935f8d ("mm: remove extra drain pages on pcp list")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200903140032.380431-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20200904151448.100489-2-pasha.tatashin@soleen.com
Link: http://lkml.kernel.org/r/20200904070235.GA15277@dhcp22.suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |   14 ++++++++++++++
 mm/page_isolation.c |    8 ++++++++
 2 files changed, 22 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1566,6 +1566,20 @@ static int __ref __offline_pages(unsigne
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
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -187,6 +187,14 @@ __first_valid_page(unsigned long pfn, un
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


