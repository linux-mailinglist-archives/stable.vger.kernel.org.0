Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041C32170E8
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgGGPWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729791AbgGGPWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31B39206E2;
        Tue,  7 Jul 2020 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135324;
        bh=pOz1h0Kui2vd4TQTtCN/LUp1rK8LonyhxFM4eNU/vBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIfuaEVJrJJ0FU73iXlHgr1gZ8D9Kl57Psqfy7QOt/cIL42LLZXKn63mbKvVBEAaC
         XCvEZ/wS2JdxgPecYxcWG0tPPOac+dD6pubRUuBFy2hBRuKv+3KWE3QaPyJb5oYQHk
         SWCdoZVFANRNOy6m26o8so6qARrohC23/XzaX+GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 61/65] mm, compaction: fully assume capture is not NULL in compact_zone_order()
Date:   Tue,  7 Jul 2020 17:17:40 +0200
Message-Id: <20200707145755.418273739@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 6467552ca64c4ddd2b83ed73192107d7145f533b upstream.

Dan reports:

The patch 5e1f0f098b46: "mm, compaction: capture a page under direct
compaction" from Mar 5, 2019, leads to the following Smatch complaint:

    mm/compaction.c:2321 compact_zone_order()
     error: we previously assumed 'capture' could be null (see line 2313)

mm/compaction.c
  2288  static enum compact_result compact_zone_order(struct zone *zone, int order,
  2289                  gfp_t gfp_mask, enum compact_priority prio,
  2290                  unsigned int alloc_flags, int classzone_idx,
  2291                  struct page **capture)
                                      ^^^^^^^

  2313		if (capture)
                    ^^^^^^^
Check for NULL

  2314			current->capture_control = &capc;
  2315
  2316		ret = compact_zone(&cc, &capc);
  2317
  2318		VM_BUG_ON(!list_empty(&cc.freepages));
  2319		VM_BUG_ON(!list_empty(&cc.migratepages));
  2320
  2321		*capture = capc.page;
                ^^^^^^^^
Unchecked dereference.

  2322		current->capture_control = NULL;
  2323

In practice this is not an issue, as the only caller path passes non-NULL
capture:

__alloc_pages_direct_compact()
  struct page *page = NULL;
  try_to_compact_pages(capture = &page);
    compact_zone_order(capture = capture);

So let's remove the unnecessary check, which should also make Smatch happy.

Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Link: http://lkml.kernel.org/r/18b0df3c-0589-d96c-23fa-040798fee187@suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2310,8 +2310,7 @@ static enum compact_result compact_zone_
 		.page = NULL,
 	};
 
-	if (capture)
-		current->capture_control = &capc;
+	current->capture_control = &capc;
 
 	ret = compact_zone(&cc, &capc);
 
@@ -2333,6 +2332,7 @@ int sysctl_extfrag_threshold = 500;
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
+ * @capture: Pointer to free page created by compaction will be stored here
  *
  * This is the main entry point for direct page compaction.
  */


