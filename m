Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A054E6CB
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378061AbiFPQSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 12:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378117AbiFPQSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 12:18:01 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865562DA85;
        Thu, 16 Jun 2022 09:17:59 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VGamLOw_1655396275;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGamLOw_1655396275)
          by smtp.aliyun-inc.com;
          Fri, 17 Jun 2022 00:17:55 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     akpm@linux-foundation.org, ziy@nvidia.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        guoren@kernel.org
Cc:     huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH 5.17] mm: validate buddy page before using
Date:   Fri, 17 Jun 2022 00:17:46 +0800
Message-Id: <20220616161746.3565225-7-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
can be fixed in a similar way too.

In unset_migratetype_isolate(), we also need the fix, so move page_is_buddy()
from mm/page_alloc.c to mm/internal.h

In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
so it would have pfn_base=512 and mem_map began with 512th PFN when
CONFIG_FLATMEM=y.
But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
less than the pfn_base value. We need page_is_buddy() to verify the buddy to
prevent accessing an invalid buddy.

Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
Cc: stable@vger.kernel.org
Reported-by: zjb194813@alibaba-inc.com
Reported-by: tianhu.hh@alibaba-inc.com
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c     | 37 +++----------------------------------
 mm/page_isolation.c |  3 ++-
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index d80300392a19..dfa80bdfe5c6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -386,6 +386,40 @@ static inline bool is_data_mapping(vm_flags_t flags)
 	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
 }
 
+/*
+ * This function checks whether a page is free && is the buddy
+ * we can coalesce a page and its buddy if
+ * (a) the buddy is not in a hole (check before calling!) &&
+ * (b) the buddy is in the buddy system &&
+ * (c) a page and its buddy have the same order &&
+ * (d) a page and its buddy are in the same zone.
+ *
+ * For recording whether a page is in the buddy system, we set PageBuddy.
+ * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
+ *
+ * For recording page's order, we use page_private(page).
+ */
+static inline bool page_is_buddy(struct page *page, struct page *buddy,
+							unsigned int order)
+{
+	if (!page_is_guard(buddy) && !PageBuddy(buddy))
+		return false;
+
+	if (buddy_order(buddy) != order)
+		return false;
+
+	/*
+	 * zone check is done late to avoid uselessly calculating
+	 * zone/node ids for pages that could never merge.
+	 */
+	if (page_zone_id(page) != page_zone_id(buddy))
+		return false;
+
+	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+	return true;
+}
+
 /* mm/util.c */
 void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_area_struct *prev);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b1caa1c6c887..78ada8dedefb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -886,40 +886,6 @@ static inline void set_buddy_order(struct page *page, unsigned int order)
 	__SetPageBuddy(page);
 }
 
-/*
- * This function checks whether a page is free && is the buddy
- * we can coalesce a page and its buddy if
- * (a) the buddy is not in a hole (check before calling!) &&
- * (b) the buddy is in the buddy system &&
- * (c) a page and its buddy have the same order &&
- * (d) a page and its buddy are in the same zone.
- *
- * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
- *
- * For recording page's order, we use page_private(page).
- */
-static inline bool page_is_buddy(struct page *page, struct page *buddy,
-							unsigned int order)
-{
-	if (!page_is_guard(buddy) && !PageBuddy(buddy))
-		return false;
-
-	if (buddy_order(buddy) != order)
-		return false;
-
-	/*
-	 * zone check is done late to avoid uselessly calculating
-	 * zone/node ids for pages that could never merge.
-	 */
-	if (page_zone_id(page) != page_zone_id(buddy))
-		return false;
-
-	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
-	return true;
-}
-
 #ifdef CONFIG_COMPACTION
 static inline struct capture_control *task_capc(struct zone *zone)
 {
@@ -1129,6 +1095,9 @@ static inline void __free_one_page(struct page *page,
 
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
+
+			if (!page_is_buddy(page, buddy, order))
+				goto done_merging;
 			buddy_mt = get_pageblock_migratetype(buddy);
 
 			if (migratetype != buddy_mt
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f67c4c70f17f..5d14cef812ee 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -93,7 +93,8 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
 
-			if (!is_migrate_isolate_page(buddy)) {
+			if (page_is_buddy(page, buddy, order) &&
+			    !is_migrate_isolate_page(buddy)) {
 				isolated_page = !!__isolate_free_page(page, order);
 				/*
 				 * Isolating a free page in an isolated pageblock
-- 
2.17.1

