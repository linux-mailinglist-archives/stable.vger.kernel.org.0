Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E8453CE69
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344656AbiFCRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344855AbiFCRly (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E5D5372C;
        Fri,  3 Jun 2022 10:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4051361AFB;
        Fri,  3 Jun 2022 17:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CBC385B8;
        Fri,  3 Jun 2022 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278070;
        bh=IsxHG8ttFcdvmopn3+fk/7LmtauGr8BOoVZrHnUy7wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3mzKnY+ztin/AOrTwBympWhCzrlqLZ2KKcDizVRqfOxGLjwyviJT8+kGenaxrBKq
         apBt3Pbqes/LAasnstEdJxgCDlniXo7BjN9wIaektf63RrhDyPLmD/bIl8SSuIr91x
         qriFIF7ZcRAtM/4RFC6oZ+Osm4J7r+ixk3ctJCOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 15/23] zsmalloc: fix races between asynchronous zspage free and page migration
Date:   Fri,  3 Jun 2022 19:39:42 +0200
Message-Id: <20220603173814.827592240@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
References: <20220603173814.362515009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

commit 2505a981114dcb715f8977b8433f7540854851d8 upstream.

The asynchronous zspage free worker tries to lock a zspage's entire page
list without defending against page migration.  Since pages which haven't
yet been locked can concurrently migrate off the zspage page list while
lock_zspage() churns away, lock_zspage() can suffer from a few different
lethal races.

It can lock a page which no longer belongs to the zspage and unsafely
dereference page_private(), it can unsafely dereference a torn pointer to
the next page (since there's a data race), and it can observe a spurious
NULL pointer to the next page and thus not lock all of the zspage's pages
(since a single page migration will reconstruct the entire page list, and
create_page_chain() unconditionally zeroes out each list pointer in the
process).

Fix the races by using migrate_read_lock() in lock_zspage() to synchronize
with page migration.

Link: https://lkml.kernel.org/r/20220509024703.243847-1-sultan@kerneltoast.com
Fixes: 77ff465799c602 ("zsmalloc: zs_page_migrate: skip unnecessary loops but not return -EBUSY if zspage is not inuse")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -952,11 +952,40 @@ static void reset_page(struct page *page
  */
 void lock_zspage(struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct page *curr_page, *page;
 
-	do {
-		lock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+	/*
+	 * Pages we haven't locked yet can be migrated off the list while we're
+	 * trying to lock them, so we need to be careful and only attempt to
+	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * may no longer belong to the zspage. This means that we may wait for
+	 * the wrong page to unlock, so we must take a reference to the page
+	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 */
+	while (1) {
+		migrate_read_lock(zspage);
+		page = get_first_page(zspage);
+		if (trylock_page(page))
+			break;
+		get_page(page);
+		migrate_read_unlock(zspage);
+		wait_on_page_locked(page);
+		put_page(page);
+	}
+
+	curr_page = page;
+	while ((page = get_next_page(curr_page))) {
+		if (trylock_page(page)) {
+			curr_page = page;
+		} else {
+			get_page(page);
+			migrate_read_unlock(zspage);
+			wait_on_page_locked(page);
+			put_page(page);
+			migrate_read_lock(zspage);
+		}
+	}
+	migrate_read_unlock(zspage);
 }
 
 int trylock_zspage(struct zspage *zspage)


