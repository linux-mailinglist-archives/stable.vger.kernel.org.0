Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CB33FF6BA
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347966AbhIBV7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347960AbhIBV7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4685D60F12;
        Thu,  2 Sep 2021 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619921;
        bh=Hwr15fGwIvezpliPxy+tuM8+SSJ6UmqrSw1CVEf+YfE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ViBpMlZYxq8UBtRudo1dzt+W+HtG10PIdTMMuemHYpJImvkdEoN9Qy/GNdtsfol72
         xWz+gswND+5KMkqds96FzF9kzEYfu4xLSKqu4PH/VfhwCmiZ0roB60c5Nae8o/w54i
         JJyMEblyab1V3LqjPa3V3q1zVX6TaOxWnral8mSk=
Date:   Thu, 02 Sep 2021 14:58:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci@linux.alibaba.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, yun.wang@linux.alibaba.com
Subject:  [patch 165/212] mm: fix panic caused by
 __page_handle_poison()
Message-ID: <20210902215840.lw0-MrokA%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
