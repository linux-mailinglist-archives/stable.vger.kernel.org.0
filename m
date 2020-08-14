Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007502443A9
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 05:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHNDAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 23:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgHNDAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 23:00:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07AC2078B;
        Fri, 14 Aug 2020 03:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597374015;
        bh=egEDfFWEsu8u2ioZb3d3d9OXAZsoL+GxKHwv/9cwC+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lP/NWdO/1n7E+7QOlzd7kpMCZTQaQ8a7Dw/+BjRSmFI0AChD7jPmmEVKrKv5jTPvM
         keU5T3zkrXbExU9+GjvIKvCAMUMQiXWJJ7+A+YMurhgsMXh/hPm+bbILv+QasgOKDi
         U28WDNBJKWqy4BIs7nV8UQ4HqjL3r7tGST8K4VCY=
Date:   Thu, 13 Aug 2020 20:00:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     charante@codeaurora.org, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org, vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  + mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch
 added to -mm tree
Message-ID: <20200814030014.ODl4NLbRv%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix core hung in free_pcppages_bulk()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm, page_alloc: fix core hung in free_pcppages_bulk()

The following race is observed with the repeated online, offline and a
delay between two successive online of memory blocks of movable zone.

P1						P2

Online the first memory block in
the movable zone. The pcp struct
values are initialized to default
values,i.e., pcp->high = 0 &
pcp->batch = 1.

					Allocate the pages from the
					movable zone.

Try to Online the second memory
block in the movable zone thus it
entered the online_pages() but yet
to call zone_pcp_update().
					This process is entered into
					the exit path thus it tries
					to release the order-0 pages
					to pcp lists through
					free_unref_page_commit().
					As pcp->high = 0, pcp->count = 1
					proceed to call the function
					free_pcppages_bulk().
Update the pcp values thus the
new pcp values are like, say,
pcp->high = 378, pcp->batch = 63.
					Read the pcp's batch value using
					READ_ONCE() and pass the same to
					free_pcppages_bulk(), pcp values
					passed here are, batch = 63,
					count = 1.

					Since num of pages in the pcp
					lists are less than ->batch,
					then it will stuck in
					while(list_empty(list)) loop
					with interrupts disabled thus
					a core hung.

Avoid this by ensuring free_pcppages_bulk() is called with proper count of
pcp list pages.

The mentioned race is some what easily reproducible without [1] because
pcp's are not updated for the first memory block online and thus there is
a enough race window for P2 between alloc+free and pcp struct values
update through onlining of second memory block.

With [1], the race still exists but it is very narrow as we update the pcp
struct values for the first memory block online itself.

This is not limited to the movable zone, it could also happen in cases
with the normal zone (e.g., hotplug to a node that only has DMA memory, or
no other memory yet).

[1]: https://patchwork.kernel.org/patch/11696389/

Link: http://lkml.kernel.org/r/1597150703-19003-1-git-send-email-charante@codeaurora.org
Fixes: 5f8dcc21211a ("page-allocator: split per-cpu list into one-list-per-migrate-type")
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: <stable@vger.kernel.org> [2.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-core-hung-in-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -1301,6 +1301,11 @@ static void free_pcppages_bulk(struct zo
 	struct page *page, *tmp;
 	LIST_HEAD(head);
 
+	/*
+	 * Ensure proper count is passed which otherwise would stuck in the
+	 * below while (list_empty(list)) loop.
+	 */
+	count = min(pcp->count, count);
 	while (count) {
 		struct list_head *list;
 
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-fix-core-hung-in-free_pcppages_bulk.patch

