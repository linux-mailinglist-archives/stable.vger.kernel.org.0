Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1B829BF70
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815043AbgJ0RBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793848AbgJ0PIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84ED206F4;
        Tue, 27 Oct 2020 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811317;
        bh=5jCtHAcjd+jm313XkBzYCjDV1uusugtGR1ZgP1w0ha0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s58LVTIDJkhCgTI+zaSrn1alPWlG5GQHC9ZOBdfhzlunuXuMfzolVVHoRmli3lV43
         vgNhMK9jE0mAlfKbCD3b714SHqhvew3mUN0lGB3185716jLaZs+lqF5BvmjkBKZd4K
         B4lrpGpebuCo8icaLpcRdhkQLZWKB5O6AiYwEeY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        SeongJae Park <sjpark@amazon.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 419/633] mm/page_owner: change split_page_owner to take a count
Date:   Tue, 27 Oct 2020 14:52:42 +0100
Message-Id: <20201027135542.377935994@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 8fb156c9ee2db94f7127c930c89917634a1a9f56 ]

The implementation of split_page_owner() prefers a count rather than the
old order of the page.  When we support a variable size THP, we won't
have the order at this point, but we will have the number of pages.
So change the interface to what the caller and callee would prefer.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Link: https://lkml.kernel.org/r/20200908195539.25896-4-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/page_owner.h | 6 +++---
 mm/huge_memory.c           | 2 +-
 mm/page_alloc.c            | 2 +-
 mm/page_owner.c            | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index 8679ccd722e89..3468794f83d23 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_owner_ops;
 extern void __reset_page_owner(struct page *page, unsigned int order);
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int order);
+extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct page *page,
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, unsigned int order)
+static inline void split_page_owner(struct page *page, unsigned int nr)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, nr);
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 74300e337c3c7..358403422104b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2449,7 +2449,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_ORDER);
+	split_page_owner(head, HPAGE_PMD_NR);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 802f00540a3d2..8cc774340d490 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3213,7 +3213,7 @@ void split_page(struct page *page, unsigned int order)
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order);
+	split_page_owner(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 3604615094235..4ca3051a10358 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -204,7 +204,7 @@ void __set_page_owner_migrate_reason(struct page *page, int reason)
 	page_owner->last_migrate_reason = reason;
 }
 
-void __split_page_owner(struct page *page, unsigned int order)
+void __split_page_owner(struct page *page, unsigned int nr)
 {
 	int i;
 	struct page_ext *page_ext = lookup_page_ext(page);
@@ -213,7 +213,7 @@ void __split_page_owner(struct page *page, unsigned int order)
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < (1 << order); i++) {
+	for (i = 0; i < nr; i++) {
 		page_owner = get_page_owner(page_ext);
 		page_owner->order = 0;
 		page_ext = page_ext_next(page_ext);
-- 
2.25.1



