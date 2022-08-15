Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C5C5947C4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354161AbiHOXnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354333AbiHOXly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C982C67A;
        Mon, 15 Aug 2022 13:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF537B80EAB;
        Mon, 15 Aug 2022 20:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D94AC433D6;
        Mon, 15 Aug 2022 20:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594372;
        bh=D0Kv8H6XorGh+j/hqdaLEAmyfP1fBTiLguzZ5ZJ4gUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srIrpDi+fNk3G3FEavlW5RUAc0v7Y/U9YZzKQhGDdkCnnw1NSUMPE1+X/l9teeArk
         79mgiS/ai7Mb9xjUFG+cAPQcy4UIz2Qk787bdnXRiluMoXf3RTkW8AnBBhnwWMogbU
         c3zJqagIjBCnpLJNQ5Lyp1SFMTav/EWmeSe6xebo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0425/1157] mm: Account dirty folios properly during splits
Date:   Mon, 15 Aug 2022 19:56:21 +0200
Message-Id: <20220815180456.662665693@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 834f288b3769..15965084816d 100644
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
@@ -2440,11 +2441,15 @@ static void __split_huge_page(struct page *page, struct list_head *list,
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



