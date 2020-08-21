Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FBB24C952
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHUAma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgHUAm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41A3E207DF;
        Fri, 21 Aug 2020 00:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970548;
        bh=1wvSiHvuWZnDBNIn5JsqNr5M3Uhb2qcavuavim3AV+s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CMEqUpSqJjNwOYo7INengoxxWoZyC9yg/VSOhUi+DFZ3xCA4MmotVuFLZFiPI2nzf
         6AzlnZObLb8q8EeLL+rNJ9Mg6n+/bC6/zKAJ1PMjh2MgO/H5lopH4jqZCkIz34Tle6
         HLwn4hFYIUggAUxACTmuVF5jr3IC/cK4PTXYs/FY=
Date:   Thu, 20 Aug 2020 17:42:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [patch 11/11] mm, page_alloc: fix core hung in
 free_pcppages_bulk()
Message-ID: <20200821004227.b25Sz83Ph%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Acked-by: Michal Hocko <mhocko@suse.com>
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
@@ -1302,6 +1302,11 @@ static void free_pcppages_bulk(struct zo
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
