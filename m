Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31731A8F03
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbfIDSBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388169AbfIDSBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:01:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6657B2339E;
        Wed,  4 Sep 2019 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620078;
        bh=1BmdQJ0kzi7aYIylG4+zh19lG7DQ1yOqgW53au7+m40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4PwQSpHoXif+FaYvOzjjSAs3H8ETJyxbH8tDcKDAMIGqLRvJIPhHgwWqlVHwPXOn
         N/CXMxRNLB8N4SiBiRm3oVgEncxpvYOfciNCJhzCvPd6a1ldDF167DRBBSx7/72igF
         SDjJ5CuF9VGS9FYijWWSJ8HPxY5TBY2tm2RDRlcI=
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 64/83] mm/zsmalloc.c: fix race condition in zs_destroy_pool
Date:   Wed,  4 Sep 2019 19:53:56 +0200
Message-Id: <20190904175309.258095111@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 701d678599d0c1623aaf4139c03eea260a75b027 ]

In zs_destroy_pool() we call flush_work(&pool->free_work).  However, we
have no guarantee that migration isn't happening in the background at
that time.

Since migration can't directly free pages, it relies on free_work being
scheduled to free the pages.  But there's nothing preventing an
in-progress migrate from queuing the work *after*
zs_unregister_migration() has called flush_work().  Which would mean
pages still pointing at the inode when we free it.

Since we know at destroy time all objects should be free, no new
migrations can come in (since zs_page_isolate() fails for fully-free
zspages).  This means it is sufficient to track a "# isolated zspages"
count by class, and have the destroy logic ensure all such pages have
drained before proceeding.  Keeping that state under the class spinlock
keeps the logic straightforward.

In this case a memory leak could lead to an eventual crash if compaction
hits the leaked page.  This crash would only occur if people are
changing their zswap backend at runtime (which eventually starts
destruction).

Link: http://lkml.kernel.org/r/20190809181751.219326-2-henryburns@google.com
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zsmalloc.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f624cc2d91d98..ad8a34bd15ca7 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -52,6 +52,7 @@
 #include <linux/zpool.h>
 #include <linux/mount.h>
 #include <linux/migrate.h>
+#include <linux/wait.h>
 #include <linux/pagemap.h>
 
 #define ZSPAGE_MAGIC	0x58
@@ -265,6 +266,10 @@ struct zs_pool {
 #ifdef CONFIG_COMPACTION
 	struct inode *inode;
 	struct work_struct free_work;
+	/* A wait queue for when migration races with async_free_zspage() */
+	wait_queue_head_t migration_wait;
+	atomic_long_t isolated_pages;
+	bool destroying;
 #endif
 };
 
@@ -1951,6 +1956,19 @@ static void putback_zspage_deferred(struct zs_pool *pool,
 
 }
 
+static inline void zs_pool_dec_isolated(struct zs_pool *pool)
+{
+	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
+	atomic_long_dec(&pool->isolated_pages);
+	/*
+	 * There's no possibility of racing, since wait_for_isolated_drain()
+	 * checks the isolated count under &class->lock after enqueuing
+	 * on migration_wait.
+	 */
+	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
+		wake_up_all(&pool->migration_wait);
+}
+
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct page *newpage, struct page *oldpage)
 {
@@ -2020,6 +2038,7 @@ bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 	 */
 	if (!list_empty(&zspage->list) && !is_zspage_isolated(zspage)) {
 		get_zspage_mapping(zspage, &class_idx, &fullness);
+		atomic_long_inc(&pool->isolated_pages);
 		remove_zspage(class, zspage, fullness);
 	}
 
@@ -2108,8 +2127,16 @@ int zs_page_migrate(struct address_space *mapping, struct page *newpage,
 	 * Page migration is done so let's putback isolated zspage to
 	 * the list if @page is final isolated subpage in the zspage.
 	 */
-	if (!is_zspage_isolated(zspage))
+	if (!is_zspage_isolated(zspage)) {
+		/*
+		 * We cannot race with zs_destroy_pool() here because we wait
+		 * for isolation to hit zero before we start destroying.
+		 * Also, we ensure that everyone can see pool->destroying before
+		 * we start waiting.
+		 */
 		putback_zspage_deferred(pool, class, zspage);
+		zs_pool_dec_isolated(pool);
+	}
 
 	reset_page(page);
 	put_page(page);
@@ -2161,8 +2188,8 @@ void zs_page_putback(struct page *page)
 		 * so let's defer.
 		 */
 		putback_zspage_deferred(pool, class, zspage);
+		zs_pool_dec_isolated(pool);
 	}
-
 	spin_unlock(&class->lock);
 }
 
@@ -2185,8 +2212,36 @@ static int zs_register_migration(struct zs_pool *pool)
 	return 0;
 }
 
+static bool pool_isolated_are_drained(struct zs_pool *pool)
+{
+	return atomic_long_read(&pool->isolated_pages) == 0;
+}
+
+/* Function for resolving migration */
+static void wait_for_isolated_drain(struct zs_pool *pool)
+{
+
+	/*
+	 * We're in the process of destroying the pool, so there are no
+	 * active allocations. zs_page_isolate() fails for completely free
+	 * zspages, so we need only wait for the zs_pool's isolated
+	 * count to hit zero.
+	 */
+	wait_event(pool->migration_wait,
+		   pool_isolated_are_drained(pool));
+}
+
 static void zs_unregister_migration(struct zs_pool *pool)
 {
+	pool->destroying = true;
+	/*
+	 * We need a memory barrier here to ensure global visibility of
+	 * pool->destroying. Thus pool->isolated pages will either be 0 in which
+	 * case we don't care, or it will be > 0 and pool->destroying will
+	 * ensure that we wake up once isolation hits 0.
+	 */
+	smp_mb();
+	wait_for_isolated_drain(pool); /* This can block */
 	flush_work(&pool->free_work);
 	iput(pool->inode);
 }
@@ -2433,6 +2488,8 @@ struct zs_pool *zs_create_pool(const char *name)
 	if (!pool->name)
 		goto err;
 
+	init_waitqueue_head(&pool->migration_wait);
+
 	if (create_cache(pool))
 		goto err;
 
-- 
2.20.1



