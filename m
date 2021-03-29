Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AFD34DB72
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhC2W2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhC2W0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 18:26:11 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3A7C061762;
        Mon, 29 Mar 2021 15:26:10 -0700 (PDT)
Received: by sf.home (Postfix, from userid 1000)
        id E848C5A22061; Mon, 29 Mar 2021 23:26:04 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>, stable@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v3] mm: page_alloc: ignore init_on_free=1 for debug_pagealloc=1
Date:   Mon, 29 Mar 2021 23:25:54 +0100
Message-Id: <20210329222555.3077928-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <ea46d903-d201-5781-1f3c-f8d7fea5070e@suse.cz>
References: <ea46d903-d201-5781-1f3c-f8d7fea5070e@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On !ARCH_SUPPORTS_DEBUG_PAGEALLOC (like ia64) debug_pagealloc=1
implies page_poison=on:

    if (page_poisoning_enabled() ||
         (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
          debug_pagealloc_enabled()))
            static_branch_enable(&_page_poisoning_enabled);

page_poison=on needs to override init_on_free=1.

Before the change it did not work as expected for the following case:
- have PAGE_POISONING=y
- have page_poison unset
- have !ARCH_SUPPORTS_DEBUG_PAGEALLOC arch (like ia64)
- have init_on_free=1
- have debug_pagealloc=1

That way we get both keys enabled:
- static_branch_enable(&init_on_free);
- static_branch_enable(&_page_poisoning_enabled);

which leads to poisoned pages returned for __GFP_ZERO pages.

After the change we execute only:
- static_branch_enable(&_page_poisoning_enabled);
and ignore init_on_free=1.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 8db26a3d4735 ("mm, page_poison: use static key more efficiently")
Cc: <stable@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
CC: David Hildenbrand <david@redhat.com>
CC: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lkml.org/lkml/2021/3/26/443

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
Change since v2:
- Added 'Fixes:' and 'CC: stable@' suggested by Vlastimil and David
- Renamed local variable to 'page_poisoning_requested' for
  consistency suggested by David
- Simplified initialization of page_poisoning_requested suggested
  by David
- Added 'Acked-by: Vlastimil'

 mm/page_alloc.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cfc72873961d..4bb3cdfc47f8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -764,32 +764,36 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  */
 void init_mem_debugging_and_hardening(void)
 {
+	bool page_poisoning_requested = false;
+
+#ifdef CONFIG_PAGE_POISONING
+	/*
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
+	 */
+	if (page_poisoning_enabled() ||
+	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+	      debug_pagealloc_enabled())) {
+		static_branch_enable(&_page_poisoning_enabled);
+		page_poisoning_requested = true;
+	}
+#endif
+
 	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_alloc\n");
 		else
 			static_branch_enable(&init_on_alloc);
 	}
 	if (_init_on_free_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_free\n");
 		else
 			static_branch_enable(&init_on_free);
 	}
 
-#ifdef CONFIG_PAGE_POISONING
-	/*
-	 * Page poisoning is debug page alloc for some arches. If
-	 * either of those options are enabled, enable poisoning.
-	 */
-	if (page_poisoning_enabled() ||
-	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
-	      debug_pagealloc_enabled()))
-		static_branch_enable(&_page_poisoning_enabled);
-#endif
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;
-- 
2.31.1

