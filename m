Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603EC9D85E
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfHZVbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfHZVbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC2721883;
        Mon, 26 Aug 2019 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855111;
        bh=u6TDwDgNismUC3fELtlJ6zQ22iHX6c/WYKNgsJFmSzY=;
        h=Date:From:To:Subject:From;
        b=hVj/E1oDuSDnHyrmT7Yh0pI4xdY3JwgpN8MQwmHHtPUZJrisUrN+xiPU3ROKr5xDq
         W7DW2TeVeNlj6iWJHHAlApJqihaMh5MpxGP1i4xzlynOwfI/LVTm3LwKVLb19bCXEM
         fqqTtjl+UjBAKrXKAd5aoYDaOwIQcPJsK81zAjoU=
Date:   Mon, 26 Aug 2019 14:31:51 -0700
From:   akpm@linux-foundation.org
To:     henryburns@google.com, henrywolfeburns@gmail.com,
        jwadams@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-zsmallocc-migration-can-leave-pages-in-zs_empty-indefinitely.patch
 removed from -mm tree
Message-ID: <20190826213151.6OOoUaHqE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-migration-can-leave-pages-in-zs_empty-indefinitely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely

In zs_page_migrate() we call putback_zspage() after we have finished
migrating all pages in this zspage.  However, the return value is ignored.
If a zs_free() races in between zs_page_isolate() and zs_page_migrate(),
freeing the last object in the zspage, putback_zspage() will leave the
page in ZS_EMPTY for potentially an unbounded amount of time.

To fix this, we need to do the same thing as zs_page_putback() does:
schedule free_work to occur.  To avoid duplicated code, move the sequence
to a new putback_zspage_deferred() function which both zs_page_migrate()
and zs_page_putback() call.

Link: http://lkml.kernel.org/r/20190809181751.219326-1-henryburns@google.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-migration-can-leave-pages-in-zs_empty-indefinitely
+++ a/mm/zsmalloc.c
@@ -1862,6 +1862,18 @@ static void dec_zspage_isolation(struct
 	zspage->isolated--;
 }
 
+static void putback_zspage_deferred(struct zs_pool *pool,
+				    struct size_class *class,
+				    struct zspage *zspage)
+{
+	enum fullness_group fg;
+
+	fg = putback_zspage(class, zspage);
+	if (fg == ZS_EMPTY)
+		schedule_work(&pool->free_work);
+
+}
+
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct page *newpage, struct page *oldpage)
 {
@@ -2031,7 +2043,7 @@ static int zs_page_migrate(struct addres
 	 * the list if @page is final isolated subpage in the zspage.
 	 */
 	if (!is_zspage_isolated(zspage))
-		putback_zspage(class, zspage);
+		putback_zspage_deferred(pool, class, zspage);
 
 	reset_page(page);
 	put_page(page);
@@ -2077,14 +2089,13 @@ static void zs_page_putback(struct page
 	spin_lock(&class->lock);
 	dec_zspage_isolation(zspage);
 	if (!is_zspage_isolated(zspage)) {
-		fg = putback_zspage(class, zspage);
 		/*
 		 * Due to page_lock, we cannot free zspage immediately
 		 * so let's defer.
 		 */
-		if (fg == ZS_EMPTY)
-			schedule_work(&pool->free_work);
+		putback_zspage_deferred(pool, class, zspage);
 	}
+
 	spin_unlock(&class->lock);
 }
 
_

Patches currently in -mm which might be from henryburns@google.com are


