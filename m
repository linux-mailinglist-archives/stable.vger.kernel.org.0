Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208483F0717
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhHROv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbhHROv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 10:51:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A2CC0613CF;
        Wed, 18 Aug 2021 07:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HOaj1CFejRIbwr2VFBMVbAvfMNsHrt4NdWstS9REF68=; b=Aj5fAFbydfz0/Deokqjb2WKKvL
        9YgEpwirvN4vz+VVeLVYe23oHc+w3OD+50HYqyyWjBSf7iouxmuWbvFtQUOksyAQbRf3GQsYwI0fD
        Gkdb6EqLK4tUW9Y9qXZ8nsqQ+kROmbMRd4BF376wW0tNKUY/v1AdzGV+xAATONOavvXaMQBEhSpWU
        q+5Q6YYli5SYBbRf/c0gIVn9dWbV55vUuNmbYXe7DLur5a6YxvEuqdFaQXdZE5N19L8jwrR/c+TCr
        t6WzqdpE8IAwNdlfGycTco8Ks+2Dtg3lfWzR+NhqRbN89vKz3cZyHF6MZpI92hAhurJ0WfN2oq03Q
        a/khoIrA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGMst-003wkf-Th; Wed, 18 Aug 2021 14:49:51 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org
Subject: [PATCH] mm: Remove bogus VM_BUG_ON
Date:   Wed, 18 Aug 2021 15:49:32 +0100
Message-Id: <20210818144932.940640-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is not safe to check page->index without holding the page lock.
It can be changed if the page is moved between the swap cache and the
page cache for a shmem file, for example.  There is a VM_BUG_ON below
which checks page->index is correct after taking the page lock.

Cc: stable@vger.kernel.org
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d1458ecf2f51..34de0b14aaa9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2033,17 +2033,16 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))
 				goto put;
 			if (page->mapping != mapping || PageWriteback(page))
 				goto unlock;
 			VM_BUG_ON_PAGE(!thp_contains(page, xas.xa_index),
 					page);
-- 
2.30.2

