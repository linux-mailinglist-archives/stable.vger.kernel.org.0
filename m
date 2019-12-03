Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A631111E81
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfLCWxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbfLCWxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E8C720656;
        Tue,  3 Dec 2019 22:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413626;
        bh=KG6ooScHarpxP6/uZ0p1fKUiCMRXaGr7NhSoKbbuXzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRWP2Qq59Z190qGBEyLpa4ecjV7A83YO1PskE2DjhTxUnInbIwwniG6lXjolo3zCM
         6vGoySEU7dRv97ArwIjwtvgwb3UcL+KVNAWCO4W2ImQ9BcaJpg4R1WWSVHv9AUAlra
         gl3PZPu9+aZSaqMx5REvBL6tWLa2C1fcJAN8jnGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Pankaj gupta <pagupta@redhat.com>,
        Pawel Staszewski <pstaszewski@itcare.pl>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/321] mm/page_alloc.c: use a single function to free page
Date:   Tue,  3 Dec 2019 23:34:25 +0100
Message-Id: <20191203223437.473215664@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

[ Upstream commit 742aa7fb52c56fb3b307e704f93e67b698959cc2 ]

There are multiple places of freeing a page, they all do the same things
so a common function can be used to reduce code duplicate.

It also avoids bug fixed in one function but left in another.

Link: http://lkml.kernel.org/r/20181119134834.17765-3-aaron.lu@intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pankaj gupta <pagupta@redhat.com>
Cc: Pawel Staszewski <pstaszewski@itcare.pl>
Cc: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dcc46d955df2e..74fb5c338e8fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4451,16 +4451,19 @@ unsigned long get_zeroed_page(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(get_zeroed_page);
 
-void __free_pages(struct page *page, unsigned int order)
+static inline void free_the_page(struct page *page, unsigned int order)
 {
-	if (put_page_testzero(page)) {
-		if (order == 0)
-			free_unref_page(page);
-		else
-			__free_pages_ok(page, order);
-	}
+	if (order == 0)		/* Via pcp? */
+		free_unref_page(page);
+	else
+		__free_pages_ok(page, order);
 }
 
+void __free_pages(struct page *page, unsigned int order)
+{
+	if (put_page_testzero(page))
+		free_the_page(page, order);
+}
 EXPORT_SYMBOL(__free_pages);
 
 void free_pages(unsigned long addr, unsigned int order)
@@ -4509,14 +4512,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 {
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
 
-	if (page_ref_sub_and_test(page, count)) {
-		unsigned int order = compound_order(page);
-
-		if (order == 0)
-			free_unref_page(page);
-		else
-			__free_pages_ok(page, order);
-	}
+	if (page_ref_sub_and_test(page, count))
+		free_the_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
@@ -4581,14 +4578,8 @@ void page_frag_free(void *addr)
 {
 	struct page *page = virt_to_head_page(addr);
 
-	if (unlikely(put_page_testzero(page))) {
-		unsigned int order = compound_order(page);
-
-		if (order == 0)		/* Via pcp? */
-			free_unref_page(page);
-		else
-			__free_pages_ok(page, order);
-	}
+	if (unlikely(put_page_testzero(page)))
+		free_the_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(page_frag_free);
 
-- 
2.20.1



