Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F54C9D855
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfHZVbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfHZVbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C2F21872;
        Mon, 26 Aug 2019 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855093;
        bh=kuYd2K5hJpZoCMNIcsPscNp4NeHgFTRMjIkFAnX1p/M=;
        h=Date:From:To:Subject:From;
        b=0cN3lNLvVoG9VjVGmZlQY/OkimZ0aMI3jmBwio2/RKbAwvBZ15nAccxDpeFbSNaej
         DfTnucT4emtK0bvDSQksQlI2GW8VAQKoGB27Bf4P25ZUfkwj5TUAq+M+F37Kd4b/Cp
         vMmzpIwRDYKoNfxzFTpUT1JaHV0O9nXblZXDPzg8=
Date:   Mon, 26 Aug 2019 14:31:32 -0700
From:   akpm@linux-foundation.org
To:     m.mizuma@jp.fujitsu.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, pavel.tatashin@microsoft.com,
        rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-move=5Ffreepages-should-not-examine-struct-p?=
 =?US-ASCII?Q?age-of-reserved-memory.patch?= removed from -mm tree
Message-ID: <20190826213132.y9ZtfpYZ-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move_freepages should not examine struct page of reserved memory
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

We noticed it almost immediately after bringing 907ec5fca3dc in on
CONFIG_DEBUG_VM builds.  It depends on finding specific free pages in
the per-zone free area where the math in move_freepages() will bring
the start or end pfn into reserved memory and wanting to claim that
entire pageblock as a new migratetype.  So the path will be rare,
require CONFIG_DEBUG_VM, and require fallback to a different
migratetype.

Some struct pages were already zeroed from reserve pages before
907ec5fca3c so it theoretically could trigger before this commit.  I
think it's rare enough under a config option that most people don't run
that others may not have noticed.  I wouldn't argue against a stable
tag and the backport should be easy enough, but probably wouldn't
single out a commit that this is fixing.


Mel said:

: The overhead of the debugging check is higher with this patch although
: it'll only affect debug builds and the path is not particularly hot. 
: If this was a concern, I think it would be reasonable to simply remove
: the debugging check as the zone boundaries are checked in
: move_freepages_block and we never expect a zone/node to be smaller than
: a pageblock and stuck in the middle of another zone.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1908122036560.10779@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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


