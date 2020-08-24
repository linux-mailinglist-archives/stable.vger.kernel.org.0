Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E77A24F90C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgHXIpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgHXIps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:45:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BC3204FD;
        Mon, 24 Aug 2020 08:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258747;
        bh=fKxUG6pFb12sFDw3b1VR9N2fW73B3Gv9sp5kDgMzyq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmebvA+0ziOfcqRYjRCCUxZo3JkkWP1EpSZpLQWWF+jXjllWtcmUpO09f4Qo8Mhr+
         r/0MdJeTPtD1/xaCeC0j9QgG2950KUxK9iik9MociuXTwqqvF891I3DDN1JOgAqSem
         YCmXGRYQMHZeRGF70ppPtx+YAtoIURlxqMm1D6b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 030/107] mm, page_alloc: fix core hung in free_pcppages_bulk()
Date:   Mon, 24 Aug 2020 10:29:56 +0200
Message-Id: <20200824082406.605935413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <charante@codeaurora.org>

commit 88e8ac11d2ea3acc003cf01bb5a38c8aa76c3cfd upstream.

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

Fixes: 5f8dcc21211a ("page-allocator: split per-cpu list into one-list-per-migrate-type")
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: <stable@vger.kernel.org> [2.6+]
Link: http://lkml.kernel.org/r/1597150703-19003-1-git-send-email-charante@codeaurora.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1256,6 +1256,11 @@ static void free_pcppages_bulk(struct zo
 	struct page *page, *tmp;
 	LIST_HEAD(head);
 
+	/*
+	 * Ensure proper count is passed which otherwise would stuck in the
+	 * below while (list_empty(list)) loop.
+	 */
+	count = min(pcp->count, count);
 	while (count) {
 		struct list_head *list;
 


