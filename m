Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4B2594093
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbiHOVJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347877AbiHOVHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EE052DC5;
        Mon, 15 Aug 2022 12:16:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD0F7B810A3;
        Mon, 15 Aug 2022 19:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06969C433C1;
        Mon, 15 Aug 2022 19:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590977;
        bh=FSlNSLhvpoyiw9eFcM5g7ayib14ZGARLfiKQGyQtPDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or5MVeNaDHLyvahTYk8jm3RKn0dOmZQelv7FqKEFWutWN8u9f6dWlu8MqM54L0NWZ
         33gSvLUil5nQnQLiaFJwzaM1FyQkRfxjVHqoHKq79T4QMYe/MmwDraOnk0MtcqFuby
         RpjxVS5skLWAjh1PcySzkhB7VQFVDIv+O3bHe2Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0401/1095] mm: Account dirty folios properly during splits
Date:   Mon, 15 Aug 2022 19:56:40 +0200
Message-Id: <20220815180446.282386990@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit fb5c2029f8221e904e604938171c4a8ef169aadb ]

If the last folio in a file is split as a result of truncation,
we simply clear the dirty bits for the pages we're discarding.
That causes NR_FILE_DIRTY (among other counters) to be thrown off
and eventually Linux will hang in balance_dirty_pages_ratelimited()

Reported-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b7d0697b1f26..e0c1cf3168d7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -18,6 +18,7 @@
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
 #include <linux/swapops.h>
+#include <linux/backing-dev.h>
 #include <linux/dax.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
@@ -2389,11 +2390,15 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond EOF: drop them from page cache */
 		if (head[i].index >= end) {
-			ClearPageDirty(head + i);
-			__delete_from_page_cache(head + i, NULL);
+			struct folio *tail = page_folio(head + i);
+
 			if (shmem_mapping(head->mapping))
 				shmem_uncharge(head->mapping->host, 1);
-			put_page(head + i);
+			else if (folio_test_clear_dirty(tail))
+				folio_account_cleaned(tail,
+					inode_to_wb(folio->mapping->host));
+			__filemap_remove_folio(tail, NULL);
+			folio_put(tail);
 		} else if (!PageAnon(page)) {
 			__xa_store(&head->mapping->i_pages, head[i].index,
 					head + i, 0);
-- 
2.35.1



