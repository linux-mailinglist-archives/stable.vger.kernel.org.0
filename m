Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69103404291
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348976AbhIIBLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhIIBLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032F46113C;
        Thu,  9 Sep 2021 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149812;
        bh=ZUmJTe6KSaUmTIAXi8tzMYANKTDqYyuW8+p0GpblCVY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fZXYl1p6KY6tyXYCde8iJSgM1HDOJzQCHYQG/9cPITbBa/21wfyGoOCJ9NEfIHzl9
         jC2aBWqpcU8wxHcczfXi15WMC+cdwDezG9hMMyY4+cEX4W1Jb3mqqC5tvvJuI4Jhy8
         UsF6tvPgo03AQun+uk66BzkC5JikNt/9Pu40T3lI=
Date:   Wed, 08 Sep 2021 18:10:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 4/8] mm/page_alloc.c: avoid accessing
 uninitialized pcp page migratetype
Message-ID: <20210909011011.ijPe0NI2o%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
