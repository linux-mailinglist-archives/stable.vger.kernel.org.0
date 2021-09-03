Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F06400736
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 23:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbhICVBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 17:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350253AbhICVBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB485610FB;
        Fri,  3 Sep 2021 21:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702802;
        bh=yt74DI5KxqTJf8fDLPnmhvWpU44pEJQbweXpnaIqn/w=;
        h=Date:From:To:Subject:From;
        b=E/MNXSC9TgWhYQcC1j5tRoZEJR4XxuBqsaCKgYbbaqzAcN3VFTtrCeq3/mw6Q/iAu
         BLYGwIFHt9kFEUM59lh+qzjNhMortsh7IXaUu+D3gDvP+pZjw+Egtqa0RoatELS0YM
         JvHnrH9F2iW78w2D31NvmdX4Z34r8bOHWuwNJDiw=
Date:   Fri, 03 Sep 2021 14:00:02 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, stable@vger.kernel.org,
        yun.wang@linux.alibaba.com
Subject:  [merged]
 mm-fix-panic-caused-by-__page_handle_poison.patch removed from -mm tree
Message-ID: <20210903210002.7xf8_km-9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix panic caused by __page_handle_poison()
has been removed from the -mm tree.  Its filename was
     mm-fix-panic-caused-by-__page_handle_poison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Wang <yun.wang@linux.alibaba.com>
Subject: mm: fix panic caused by __page_handle_poison()

In commit 510d25c92ec4 ("mm/hwpoison: disable pcp for
page_handle_poison()"), __page_handle_poison() was introduced, and if we
mark:

RET_A = dissolve_free_huge_page();
RET_B = take_page_off_buddy();

then __page_handle_poison was supposed to return TRUE When RET_A == 0 &&
RET_B == TRUE

But since it failed to take care the case when RET_A is -EBUSY or -ENOMEM,
and just return the ret as a bool which actually become TRUE, it break the
original logic.

The following result is a huge page in freelist but was
referenced as poisoned, and lead into the final panic:

  kernel BUG at mm/internal.h:95!
  invalid opcode: 0000 [#1] SMP PTI
  skip...
  RIP: 0010:set_page_refcounted mm/internal.h:95 [inline]
  RIP: 0010:remove_hugetlb_page+0x23c/0x240 mm/hugetlb.c:1371
  skip...
  Call Trace:
   remove_pool_huge_page+0xe4/0x110 mm/hugetlb.c:1892
   return_unused_surplus_pages+0x8d/0x150 mm/hugetlb.c:2272
   hugetlb_acct_memory.part.91+0x524/0x690 mm/hugetlb.c:4017

This patch replaces 'bool' with 'int' to handle RET_A correctly.

Link: https://lkml.kernel.org/r/61782ac6-1e8a-4f6f-35e6-e94fce3b37f5@linux.alibaba.com
Fixes: 510d25c92ec4 ("mm/hwpoison: disable pcp for page_handle_poison()")
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
Cc: <stable@vger.kernel.org>	[5.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-fix-panic-caused-by-__page_handle_poison
+++ a/mm/memory-failure.c
@@ -68,7 +68,7 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool __page_handle_poison(struct page *page)
 {
-	bool ret;
+	int ret;
 
 	zone_pcp_disable(page_zone(page));
 	ret = dissolve_free_huge_page(page);
@@ -76,7 +76,7 @@ static bool __page_handle_poison(struct
 		ret = take_page_off_buddy(page);
 	zone_pcp_enable(page_zone(page));
 
-	return ret;
+	return ret > 0;
 }
 
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
_

Patches currently in -mm which might be from yun.wang@linux.alibaba.com are


