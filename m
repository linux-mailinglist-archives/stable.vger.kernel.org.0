Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA101EB41E
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 06:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBEMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 00:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgFBEMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 00:12:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E42E206F1;
        Tue,  2 Jun 2020 04:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591071133;
        bh=mxIoVF3sTQF9NVKU/tfRSKf4rPkmmjQXHz733zPLmTA=;
        h=Date:From:To:Subject:From;
        b=xJBhBA0LjAz174p+ZYZp50A8CKv5kyT0h5hmTO2+q09sa0ZKzW04O1v408gS/s4lc
         Df5zCEDEOHtUu6WBvnhgSnG9tgki9Zm6MjQiF4yfKAQfyH1BKA1SjdgVW7bsJVg0XV
         8biipsvYuCmDWCtxlGkUMEricA0kBT3eYnkG8R+w=
Date:   Mon, 01 Jun 2020 21:12:12 -0700
From:   akpm@linux-foundation.org
To:     khlebnikov@yandex-team.ru, mgorman@techsingularity.net,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [obsolete]
 mm-compaction-avoid-vm_bug_onpageslab-in-page_mapcount.patch removed from
 -mm tree
Message-ID: <20200602041212.WhSqEMJZs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/compaction: avoid VM_BUG_ON(PageSlab()) in page_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-vm_bug_onpageslab-in-page_mapcount.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/compaction: avoid VM_BUG_ON(PageSlab()) in page_mapcount()

isolate_migratepages_block() runs some checks out of lru_lock when
choosing pages for migration.  After checking PageLRU() it checks extra
page references by comparing page_count() and page_mapcount().  Between
these two checks page could be removed from lru, freed and taken by slab.

As a result this race triggers VM_BUG_ON(PageSlab()) in page_mapcount(). 
Race window is tiny.  For certain workload this happens around once a
year.

 page:ffffea0105ca9380 count:1 mapcount:0 mapping:ffff88ff7712c180 index:0x0 compound_mapcount: 0
 flags: 0x500000000008100(slab|head)
 raw: 0500000000008100 dead000000000100 dead000000000200 ffff88ff7712c180
 raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
 page dumped because: VM_BUG_ON_PAGE(PageSlab(page))
 ------------[ cut here ]------------
 kernel BUG at ./include/linux/mm.h:628!
 invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 77 PID: 504 Comm: kcompactd1 Tainted: G        W         4.19.109-27 #1
 Hardware name: Yandex T175-N41-Y3N/MY81-EX0-Y3N, BIOS R05 06/20/2019
 RIP: 0010:isolate_migratepages_block+0x986/0x9b0

To fix just opencode page_mapcount() in racy check for 0-order case and
recheck carefully under lru_lock when page cannot escape from lru.

Also add checking extra references for file pages and swap cache.

Link: http://lkml.kernel.org/r/158937872515.474360.5066096871639561424.stgit@buzz
Fixes: 119d6d59dcc0 ("mm, compaction: avoid isolating pinned pages")
Fixes: 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to page_mapcount()")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-avoid-vm_bug_onpageslab-in-page_mapcount
+++ a/mm/compaction.c
@@ -935,12 +935,16 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
-		 * Migration will fail if an anonymous page is pinned in memory,
+		 * Migration will fail if an page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
-		 * admittedly racy check.
+		 * admittedly racy check simplest case for 0-order pages.
+		 *
+		 * Open code page_mapcount() to avoid VM_BUG_ON(PageSlab(page)).
+		 * Page could have extra reference from mapping or swap cache.
 		 */
-		if (!page_mapping(page) &&
-		    page_count(page) > page_mapcount(page))
+		if (!PageCompound(page) &&
+		    page_count(page) > atomic_read(&page->_mapcount) + 1 +
+				(!PageAnon(page) || PageSwapCache(page)))
 			goto isolate_fail;
 
 		/*
@@ -975,6 +979,11 @@ isolate_migratepages_block(struct compac
 				low_pfn += compound_nr(page) - 1;
 				goto isolate_fail;
 			}
+
+			/* Recheck page extra references under lock */
+			if (page_count(page) > page_mapcount(page) +
+				    (!PageAnon(page) || PageSwapCache(page)))
+				goto isolate_fail;
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch

