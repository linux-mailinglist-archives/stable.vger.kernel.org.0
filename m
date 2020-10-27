Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D129BE60
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812887AbgJ0Qqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801540AbgJ0Pmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8F920719;
        Tue, 27 Oct 2020 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813360;
        bh=v1Pe6TGA41rqrWEGk0mxExTJ9wzL4G7FVqnXQgmaDzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvFEe2k2YBYRh1FRn5La1dY6IN5ZkLd9rIr/sg5CIIZa5xuM4cB0Cuhs2qp3Ypw+b
         zLN4j1kIbPFq9gGEOtzVXkq/yq6/kZ1VzIKWqOD17x5Er3M3aRzSxPsHcMH7JqnTM8
         SSudU8qFP/qW1+5wA6LnPLJGtEI8vcfx/qbUS6zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        SeongJae Park <sjpark@amazon.de>,
        Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 508/757] mm/huge_memory: fix split assumption of page size
Date:   Tue, 27 Oct 2020 14:52:38 +0100
Message-Id: <20201027135514.293517457@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

[ Upstream commit 8cce54756806e5777069c46011c5f54f9feac717 ]

File THPs may now be of arbitrary size, and we can't rely on that size
after doing the split so remember the number of pages before we start the
split.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Link: https://lkml.kernel.org/r/20200908195539.25896-6-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dbac774103769..d37e205d3eae7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2335,13 +2335,13 @@ static void unmap_page(struct page *page)
 	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
-static void remap_page(struct page *page)
+static void remap_page(struct page *page, unsigned int nr)
 {
 	int i;
 	if (PageTransHuge(page)) {
 		remove_migration_ptes(page, page, true);
 	} else {
-		for (i = 0; i < HPAGE_PMD_NR; i++)
+		for (i = 0; i < nr; i++)
 			remove_migration_ptes(page + i, page + i, true);
 	}
 }
@@ -2416,6 +2416,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
+	unsigned int nr = thp_nr_pages(head);
 	int i;
 
 	lruvec = mem_cgroup_page_lruvec(head, pgdat);
@@ -2431,7 +2432,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
 
-	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
+	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
 		if (head[i].index >= end) {
@@ -2451,7 +2452,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_NR);
+	split_page_owner(head, nr);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
@@ -2470,9 +2471,9 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 
 	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 
-	remap_page(head);
+	remap_page(head, nr);
 
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
 		if (subpage == page)
 			continue;
@@ -2725,7 +2726,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
-		remap_page(head);
+		remap_page(head, thp_nr_pages(head));
 		ret = -EBUSY;
 	}
 
-- 
2.25.1



