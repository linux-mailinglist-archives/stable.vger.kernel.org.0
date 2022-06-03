Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D77753CFE5
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbiFCR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345900AbiFCR4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F1456C32;
        Fri,  3 Jun 2022 10:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A67B82430;
        Fri,  3 Jun 2022 17:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B47C385A9;
        Fri,  3 Jun 2022 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278835;
        bh=GKoL9+gfFzoAe2lfmV6JssBgfwtDzDbaPLiAC/jmV64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S03tAMEQSnDo9cCQvGdARwrEaY/yMJyeiRmgcxCAgRuCZ+3uWu02qawg6HPhL+BeG
         VBT9miLY0njkXCvxgA6fj2ScESfYBCV0FxO94KCERVU+73Yw+tCaEkUOaSuZmkWfjm
         0+/c4ZpcwqSCGJ6MTS98cRnkALT+zEctHk6OYNCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.17 42/75] zsmalloc: fix races between asynchronous zspage free and page migration
Date:   Fri,  3 Jun 2022 19:43:26 +0200
Message-Id: <20220603173822.939787051@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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
@@ -1718,11 +1718,40 @@ static enum fullness_group putback_zspag
  */
 static void lock_zspage(struct zspage *zspage)
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
 
 static int zs_init_fs_context(struct fs_context *fc)


