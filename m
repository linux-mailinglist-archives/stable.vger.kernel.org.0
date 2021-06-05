Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9986739C558
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFEDDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhFEDDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E777613FA;
        Sat,  5 Jun 2021 03:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862081;
        bh=urv8S2NBsm7Wzf+94B3oUxaZsUX9IKnFFZ28y5SIHVU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=w9CyTyK/FuFfrHbBq87lJFo43S9IjtHj1IzJ4QVOOArM2o2AWoRGN7x69NNJP3D6Y
         1jL2Qqxk+C7RR8d14qCtc0n7FLR5afz1/DIi89sDsqyeOallS0nISMFkFhZT9tUk3o
         N8tEbPGD0HqhHoDcUCfkpsO3CXYh2pwo+qVDRenc=
Date:   Fri, 04 Jun 2021 20:01:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        dinghui@sangfor.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/13] mm/page_alloc: fix counting of free pages
 after take off from buddy
Message-ID: <20210605030121.lwfIztzg3%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>
Subject: mm/page_alloc: fix counting of free pages after take off from buddy

Recently we found that there is a lot MemFree left in /proc/meminfo after
do a lot of pages soft offline, it's not quite correct.

Before Oscar rework soft offline for free pages [1], if we soft offline
free pages, these pages are left in buddy with HWPoison flag, and
NR_FREE_PAGES is not updated immediately.  So the difference between
NR_FREE_PAGES and real number of available free pages is also even big at
the beginning.

However, with the workload running, when we catch HWPoison page in any
alloc functions subsequently, we will remove it from buddy, meanwhile
update the NR_FREE_PAGES and try again, so the NR_FREE_PAGES will get more
and more closer to the real number of available free pages.  (regardless
of unpoison_memory())

Now, for offline free pages, after a successful call
take_page_off_buddy(), the page is no longer belong to buddy allocator,
and will not be used any more, but we missed accounting NR_FREE_PAGES in
this situation, and there is no chance to be updated later.

Do update in take_page_off_buddy() like rmqueue() does, but avoid double
counting if some one already set_migratetype_isolate() on the page.

[1]: commit 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")

Link: https://lkml.kernel.org/r/20210526075247.11130-1-dinghui@sangfor.com.cn
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy
+++ a/mm/page_alloc.c
@@ -9158,6 +9158,8 @@ bool take_page_off_buddy(struct page *pa
 			del_page_from_free_list(page_head, zone, page_order);
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
+			if (!is_migrate_isolate(migratetype))
+				__mod_zone_freepage_state(zone, -1, migratetype);
 			ret = true;
 			break;
 		}
_
