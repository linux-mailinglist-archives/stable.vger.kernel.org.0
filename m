Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A36411A87
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbhITQuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243494AbhITQso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3A06127B;
        Mon, 20 Sep 2021 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156434;
        bh=QRr37YfJQPLZnRmjJRbWWLgo8DpD2vvwR6bdK9vMWKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKDthbAeqAjrOaYtpG8G8J6X1y32WNNDzZMW62k3XtfN3nX1UtIrfo2TGOrckT+6/
         znoxbGlD8tJCHi7z3UJYGrp9loElr3Zb9XR0evG0dtZ/l+GbPWf0aVs7NLa6/w+w7w
         ALFsGceCzPQra6mzNUpG8PwnC5zVE6ec3KapAEYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 025/133] mm/page_alloc: speed up the iteration of max_order
Date:   Mon, 20 Sep 2021 18:41:43 +0200
Message-Id: <20210920163913.435100103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 7ad69832f37e3cea8557db6df7c793905f1135e8 upstream.

When we free a page whose order is very close to MAX_ORDER and greater
than pageblock_order, it wastes some CPU cycles to increase max_order to
MAX_ORDER one by one and check the pageblock migratetype of that page
repeatedly especially when MAX_ORDER is much larger than pageblock_order.

We also should not be checking migratetype of buddy when "order ==
MAX_ORDER - 1" as the buddy pfn may be invalid, so adjust the condition.
With the new check, we don't need the max_order check anymore, so we
replace it.

Also adjust max_order initialization so that it's lower by one than
previously, which makes the code hopefully more clear.

Link: https://lkml.kernel.org/r/20201204155109.55451-1-songmuchun@bytedance.com
Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -700,7 +700,7 @@ static inline void __free_one_page(struc
 	struct page *buddy;
 	unsigned int max_order;
 
-	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
+	max_order = min_t(unsigned int, MAX_ORDER - 1, pageblock_order);
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
@@ -715,7 +715,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 continue_merging:
-	while (order < max_order - 1) {
+	while (order < max_order) {
 		buddy_idx = __find_buddy_index(page_idx, order);
 		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
@@ -736,7 +736,7 @@ continue_merging:
 		page_idx = combined_idx;
 		order++;
 	}
-	if (max_order < MAX_ORDER) {
+	if (order < MAX_ORDER - 1) {
 		/* If we are here, it means order is >= pageblock_order.
 		 * We want to prevent merge between freepages on isolate
 		 * pageblock and normal pageblock. Without this, pageblock
@@ -757,7 +757,7 @@ continue_merging:
 						is_migrate_isolate(buddy_mt)))
 				goto done_merging;
 		}
-		max_order++;
+		max_order = order + 1;
 		goto continue_merging;
 	}
 


