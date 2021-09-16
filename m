Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4D040E8B4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356119AbhIPRpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355674AbhIPRl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A096563267;
        Thu, 16 Sep 2021 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811239;
        bh=EObLiataOvbQcj55DmyNT+KFM8W4ZbUPxC/+b6lQ3eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl5sRdD8n98VuDDsumBh5Z0vLe1Zef2FDlxELa7kVKDJ+Zi+Y9RCV9ZXSyn6OIFay
         u+30B+/HzyOlPMQlD77V9oNvWkC377xkMJ8asK+QSAaY7MPxyMqsnCnbg0XD+LVW+X
         zCOLrNRuBabFhaOIH5PZS7x1/UFWWRxNw2NwI30A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 408/432] mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype
Date:   Thu, 16 Sep 2021 18:02:37 +0200
Message-Id: <20210916155824.677773169@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 053cfda102306a3394012f9fe2594811c34925e4 upstream.

If it's not prepared to free unref page, the pcp page migratetype is
unset.  Thus we will get rubbish from get_pcppage_migratetype() and
might list_del(&page->lru) again after it's already deleted from the list
leading to grumble about data corruption.

Link: https://lkml.kernel.org/r/20210902115447.57050-1-linmiaohe@huawei.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3445,8 +3445,10 @@ void free_unref_page_list(struct list_he
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


