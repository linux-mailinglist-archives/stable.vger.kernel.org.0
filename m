Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828619E0EC
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbfH0IHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732787AbfH0IHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD5C206BA;
        Tue, 27 Aug 2019 08:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893223;
        bh=98BKHUssZiAvVoIeeamna4LlHN+bPH8+OD69xuUHJas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QP0nT7FvUtd6Wr7HAjiT4GotardjNx4gV6iGH6HKxA5ZO9LWWCAcBEqZUOHuvaKV
         gkOstcWffDcKeTVBVTSMuoUqA8ZfGxgExIi4zjmKgwLXpcKiZL/SPMu2aRa5XB7eNi
         cnmUJ+d9xpUAw5UMZ+jzz78JQtgOxEjXcdspuC1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Burns <henryburns@google.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 151/162] mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely
Date:   Tue, 27 Aug 2019 09:51:19 +0200
Message-Id: <20190827072744.020727711@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Burns <henryburns@google.com>

commit 1a87aa03597efa9641e92875b883c94c7f872ccb upstream.

In zs_page_migrate() we call putback_zspage() after we have finished
migrating all pages in this zspage.  However, the return value is
ignored.  If a zs_free() races in between zs_page_isolate() and
zs_page_migrate(), freeing the last object in the zspage,
putback_zspage() will leave the page in ZS_EMPTY for potentially an
unbounded amount of time.

To fix this, we need to do the same thing as zs_page_putback() does:
schedule free_work to occur.

To avoid duplicated code, move the sequence to a new
putback_zspage_deferred() function which both zs_page_migrate() and
zs_page_putback() call.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/zsmalloc.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1882,6 +1882,18 @@ static void dec_zspage_isolation(struct
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
@@ -2051,7 +2063,7 @@ static int zs_page_migrate(struct addres
 	 * the list if @page is final isolated subpage in the zspage.
 	 */
 	if (!is_zspage_isolated(zspage))
-		putback_zspage(class, zspage);
+		putback_zspage_deferred(pool, class, zspage);
 
 	reset_page(page);
 	put_page(page);
@@ -2097,14 +2109,13 @@ static void zs_page_putback(struct page
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
 


