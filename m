Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB97106519
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfKVFwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbfKVFwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115272071B;
        Fri, 22 Nov 2019 05:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401928;
        bh=KG6ooScHarpxP6/uZ0p1fKUiCMRXaGr7NhSoKbbuXzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szSHzuqWymcR5A0LWClU6i1hforFTJVWo2mSPgnEVVqj1SBPUaX55tcX9gbf8zCiX
         rZEFKmq0uSUVfVA+/lDNYdi2NTJa9VM0cCexN7AcrY7lLPaVHwKayIoEi+wVmGh0B0
         vH5hWD4pn0hTCUzf0ckHvopmVLrE4jhSOVeJ+OpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Lu <aaron.lu@intel.com>, Vlastimil Babka <vbabka@suse.cz>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Pankaj gupta <pagupta@redhat.com>,
        Pawel Staszewski <pstaszewski@itcare.pl>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 155/219] mm/page_alloc.c: use a single function to free page
Date:   Fri, 22 Nov 2019 00:48:07 -0500
Message-Id: <20191122054911.1750-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

