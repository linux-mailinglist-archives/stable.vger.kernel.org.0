Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB048C3D8
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 23:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfHMVj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 17:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfHMVj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 17:39:27 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEF9206C2;
        Tue, 13 Aug 2019 21:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565732366;
        bh=SLjfcwbdwmabtb3IRJfhPQib4w4zMhzFzDEtnvCK6a4=;
        h=Date:From:To:Subject:From;
        b=LyNiDg6RK77fPkWx0nV81oV13DvHFPzRRb1z06Ggz4xm/bamp5J+qyw06FtMMFPDr
         YM2q4BZp1v/4J6p5PE7YNL8VXeGWYHoHF+wby7iqluUleRPYt9IPTGNk7eJWEQhEvT
         4ZNB4wH/3zCbFwjJha8ZH7MEFTnfdBSpXT51UGI8=
Date:   Tue, 13 Aug 2019 14:39:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        pavel.tatashin@microsoft.com, osalvador@suse.de,
        n-horiguchi@ah.jp.nec.com, m.mizuma@jp.fujitsu.com,
        mgorman@techsingularity.net, rientjes@google.com
Subject:  +
 =?us-ascii?Q?mm-page=5Falloc-move=5Ffreepages-should-not-examine-struct-p?=
 =?us-ascii?Q?age-of-reserved-memory.patch?= added to -mm tree
Message-ID: <20190813213925.68XY7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move_freepages should not examine struct page of reserved memory
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: move_freepages should not examine struct page of reserved memory

After commit 907ec5fca3dc ("mm: zero remaining unavailable struct pages"),
struct page of reserved memory is zeroed.  This causes page->flags to be 0
and fixes issues related to reading /proc/kpageflags, for example, of
reserved memory.

The VM_BUG_ON() in move_freepages_block(), however, assumes that
page_zone() is meaningful even for reserved memory.  That assumption is no
longer true after the aforementioned commit.

There's no reason why move_freepages_block() should be testing the
legitimacy of page_zone() for reserved memory; its scope is limited only
to pages on the zone's freelist.

Note that pfn_valid() can be true for reserved memory: there is a backing
struct page.  The check for page_to_nid(page) is also buggy but reserved
memory normally only appears on node 0 so the zeroing doesn't affect this.

Move the debug checks to after verifying PageBuddy is true.  This isolates
the scope of the checks to only be for buddy pages which are on the zone's
freelist which move_freepages_block() is operating on.  In this case, an
incorrect node or zone is a bug worthy of being warned about (and the
examination of struct page is acceptable bcause this memory is not
reserved).

Why does move_freepages_block() gets called on reserved memory?  It's
simply math after finding a valid free page from the per-zone free area to
use as fallback.  We find the beginning and end of the pageblock of the
valid page and that can bring us into memory that was reserved per the
e820.  pfn_valid() is still true (it's backed by a struct page), but since
it's zero'd we shouldn't make any inferences here about comparing its node
or zone.  The current node check just happens to succeed most of the time
by luck because reserved memory typically appears on node 0.

The fix here is to validate that we actually have buddy pages before
testing if there's any type of zone or node strangeness going on.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1908122036560.10779@chino.kir.corp.google.com
Fixes: 907ec5fca3dc ("mm: zero remaining unavailable struct pages")
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory
+++ a/mm/page_alloc.c
@@ -2238,27 +2238,12 @@ static int move_freepages(struct zone *z
 	unsigned int order;
 	int pages_moved = 0;
 
-#ifndef CONFIG_HOLES_IN_ZONE
-	/*
-	 * page_zone is not safe to call in this context when
-	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
-	 * anyway as we check zone boundaries in move_freepages_block().
-	 * Remove at a later date when no bug reports exist related to
-	 * grouping pages by mobility
-	 */
-	VM_BUG_ON(pfn_valid(page_to_pfn(start_page)) &&
-	          pfn_valid(page_to_pfn(end_page)) &&
-	          page_zone(start_page) != page_zone(end_page));
-#endif
 	for (page = start_page; page <= end_page;) {
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
 		}
 
-		/* Make sure we are not inadvertently changing nodes */
-		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
-
 		if (!PageBuddy(page)) {
 			/*
 			 * We assume that pages that could be isolated for
@@ -2273,6 +2258,10 @@ static int move_freepages(struct zone *z
 			continue;
 		}
 
+		/* Make sure we are not inadvertently changing nodes */
+		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
+		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
+
 		order = page_order(page);
 		move_to_free_area(page, &zone->free_area[order], migratetype);
 		page += 1 << order;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch

