Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87281549784
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbiFMPhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 11:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244371AbiFMPgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 11:36:39 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B77F381B9;
        Mon, 13 Jun 2022 06:09:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VGHIVnj_1655125740;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGHIVnj_1655125740)
          by smtp.aliyun-inc.com;
          Mon, 13 Jun 2022 21:09:01 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     akpm@linux-foundation.org, ziy@nvidia.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        guoren@kernel.org, zjb194813@alibaba-inc.com,
        tianhu.hh@alibaba-inc.com,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] mm: page_alloc: validate buddy before check the migratetype
Date:   Mon, 13 Jun 2022 21:08:58 +0800
Message-Id: <20220613130858.3009808-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
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
added buddy check code. But unfortunately, this fix isn't backported to
linux-5.17.y and the former stable branches. The reason is it added wrong
fixes message:
     Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
			   pageblocks with others")
Actually, this issue is involved by commit:
     commit d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")

For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is 512,
but it got buddy PFN 0 for PFN 0x2000:
     0 = 0x2000 ^ (1 << 12)
With the illegal buddy PFN 0, it got an illegal buddy page, which caused
crash in __get_pfnblock_flags_mask().

With the patch, it can avoid the calling of get_pageblock_migratetype() if
it isn't buddy page.

Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
Cc: stable@vger.kernel.org
Reported-by: zjb194813@alibaba-inc.com
Reported-by: tianhu.hh@alibaba-inc.com
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b1caa1c6c887..5b423caa68fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *page,
 
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
+
+			if (!page_is_buddy(page, buddy, order))
+				goto done_merging;
 			buddy_mt = get_pageblock_migratetype(buddy);
 
 			if (migratetype != buddy_mt
-- 
2.17.1

