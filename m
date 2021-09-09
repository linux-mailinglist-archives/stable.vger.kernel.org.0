Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A9405E93
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbhIIVHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348329AbhIIVHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0F061186;
        Thu,  9 Sep 2021 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221574;
        bh=BrhTnCQZZqAriSBlRs5dWYrX3N74pORNtqow3xNuT/k=;
        h=Date:From:To:Subject:From;
        b=vmAsinFf/RJ4OuVFIHKTpJoVoEN1VhWrbJsUOUMnOCu3HuzuXlvkBJg/ga1wdk1Vo
         0WPzuTKBLGIJGntMedgeDSi0iJF6oSfK96WpVh3068/jtYsWJkFLD233z027E+djuO
         wmKqR5p2VX9pagveuuxQi3QqY6CdyLh6/C9WKzCM=
Date:   Thu, 09 Sep 2021 14:06:14 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
 removed from -mm tree
Message-ID: <20210909210614.DvCgJbUR1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype

If it's not prepared to free unref page, the pcp page migratetype is
unset.  Thus We will get rubbish from get_pcppage_migratetype() and might
list_del &page->lru again after it's already deleted from the list leading
to grumble about data corruption.

Link: https://lkml.kernel.org/r/20210902115447.57050-1-linmiaohe@huawei.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype
+++ a/mm/page_alloc.c
@@ -3428,8 +3428,10 @@ void free_unref_page_list(struct list_he
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_to_pfn(page);
-		if (!free_unref_page_prepare(page, pfn, 0))
+		if (!free_unref_page_prepare(page, pfn, 0)) {
 			list_del(&page->lru);
+			continue;
+		}
 
 		/*
 		 * Free isolated pages directly to the allocator, see
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

