Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98999D854
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfHZVbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbfHZVbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81DC02186A;
        Mon, 26 Aug 2019 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855091;
        bh=42U3BkvLnP+uZmnKxLb/RI0w8BLDjbgI2SbWCu7gjQw=;
        h=Date:From:To:Subject:From;
        b=FxEYqF50IubGQ5dSUsLYr7wqz+AQV7SISgPNe9UnFoP3CRyus3LYtVXU45QGJOoq2
         Mlw0mIm3cfCf6FNGb3ZQZCan2sCxRAUAyiGhUfNEjmPKdB3/HRBU2gvLN2eWaMzaGD
         WeGTJnVTaAZYAYY72QIHXTBHyywnNCrPWoIIKGW0=
Date:   Mon, 26 Aug 2019 14:31:31 -0700
From:   akpm@linux-foundation.org
To:     henryburns@google.com, henrywolfeburns@gmail.com,
        jwadams@google.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vitalywool@gmail.com
Subject:  [merged]
 mm-z3foldc-fix-race-between-migration-and-destruction.patch removed from
 -mm tree
Message-ID: <20190826213131.HN4KmPBdD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: fix race between migration and destruction
has been removed from the -mm tree.  Its filename was
     mm-z3foldc-fix-race-between-migration-and-destruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: fix race between migration and destruction

In z3fold_destroy_pool() we call destroy_workqueue(&pool->compact_wq). 
However, we have no guarantee that migration isn't happening in the
background at that time.

Migration directly calls queue_work_on(pool->compact_wq), if destruction
wins that race we are using a destroyed workqueue.

Link: http://lkml.kernel.org/r/20190809213828.202833-1-henryburns@google.com
Signed-off-by: Henry Burns <henryburns@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

--- a/mm/z3fold.c~mm-z3foldc-fix-race-between-migration-and-destruction
+++ a/mm/z3fold.c
@@ -41,6 +41,7 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 #include <linux/zpool.h>
 #include <linux/magic.h>
 
@@ -145,6 +146,8 @@ struct z3fold_header {
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
  * @inode:	inode for z3fold pseudo filesystem
+ * @destroying: bool to stop migration once we start destruction
+ * @isolated: int to count the number of pages currently in isolation
  *
  * This structure is allocated at pool creation time and maintains metadata
  * pertaining to a particular z3fold pool.
@@ -163,8 +166,11 @@ struct z3fold_pool {
 	const struct zpool_ops *zpool_ops;
 	struct workqueue_struct *compact_wq;
 	struct workqueue_struct *release_wq;
+	struct wait_queue_head isolate_wait;
 	struct work_struct work;
 	struct inode *inode;
+	bool destroying;
+	int isolated;
 };
 
 /*
@@ -769,6 +775,7 @@ static struct z3fold_pool *z3fold_create
 		goto out_c;
 	spin_lock_init(&pool->lock);
 	spin_lock_init(&pool->stale_lock);
+	init_waitqueue_head(&pool->isolate_wait);
 	pool->unbuddied = __alloc_percpu(sizeof(struct list_head)*NCHUNKS, 2);
 	if (!pool->unbuddied)
 		goto out_pool;
@@ -808,6 +815,15 @@ out:
 	return NULL;
 }
 
+static bool pool_isolated_are_drained(struct z3fold_pool *pool)
+{
+	bool ret;
+
+	spin_lock(&pool->lock);
+	ret = pool->isolated == 0;
+	spin_unlock(&pool->lock);
+	return ret;
+}
 /**
  * z3fold_destroy_pool() - destroys an existing z3fold pool
  * @pool:	the z3fold pool to be destroyed
@@ -817,6 +833,22 @@ out:
 static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
+	/*
+	 * We set pool-> destroying under lock to ensure that
+	 * z3fold_page_isolate() sees any changes to destroying. This way we
+	 * avoid the need for any memory barriers.
+	 */
+
+	spin_lock(&pool->lock);
+	pool->destroying = true;
+	spin_unlock(&pool->lock);
+
+	/*
+	 * We need to ensure that no pages are being migrated while we destroy
+	 * these workqueues, as migration can queue work on either of the
+	 * workqueues.
+	 */
+	wait_event(pool->isolate_wait, !pool_isolated_are_drained(pool));
 
 	/*
 	 * We need to destroy pool->compact_wq before pool->release_wq,
@@ -1307,6 +1339,28 @@ static u64 z3fold_get_pool_size(struct z
 	return atomic64_read(&pool->pages_nr);
 }
 
+/*
+ * z3fold_dec_isolated() expects to be called while pool->lock is held.
+ */
+static void z3fold_dec_isolated(struct z3fold_pool *pool)
+{
+	assert_spin_locked(&pool->lock);
+	VM_BUG_ON(pool->isolated <= 0);
+	pool->isolated--;
+
+	/*
+	 * If we have no more isolated pages, we have to see if
+	 * z3fold_destroy_pool() is waiting for a signal.
+	 */
+	if (pool->isolated == 0 && waitqueue_active(&pool->isolate_wait))
+		wake_up_all(&pool->isolate_wait);
+}
+
+static void z3fold_inc_isolated(struct z3fold_pool *pool)
+{
+	pool->isolated++;
+}
+
 static bool z3fold_page_isolate(struct page *page, isolate_mode_t mode)
 {
 	struct z3fold_header *zhdr;
@@ -1333,6 +1387,33 @@ static bool z3fold_page_isolate(struct p
 		spin_lock(&pool->lock);
 		if (!list_empty(&page->lru))
 			list_del(&page->lru);
+		/*
+		 * We need to check for destruction while holding pool->lock, as
+		 * otherwise destruction could see 0 isolated pages, and
+		 * proceed.
+		 */
+		if (unlikely(pool->destroying)) {
+			spin_unlock(&pool->lock);
+			/*
+			 * If this page isn't stale, somebody else holds a
+			 * reference to it. Let't drop our refcount so that they
+			 * can call the release logic.
+			 */
+			if (unlikely(kref_put(&zhdr->refcount,
+					      release_z3fold_page_locked))) {
+				/*
+				 * If we get here we have kref problems, so we
+				 * should freak out.
+				 */
+				WARN(1, "Z3fold is experiencing kref problems\n");
+				return false;
+			}
+			z3fold_page_unlock(zhdr);
+			return false;
+		}
+
+
+		z3fold_inc_isolated(pool);
 		spin_unlock(&pool->lock);
 		z3fold_page_unlock(zhdr);
 		return true;
@@ -1401,6 +1482,10 @@ static int z3fold_page_migrate(struct ad
 
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
+	spin_lock(&pool->lock);
+	z3fold_dec_isolated(pool);
+	spin_unlock(&pool->lock);
+
 	page_mapcount_reset(page);
 	put_page(page);
 	return 0;
@@ -1420,10 +1505,14 @@ static void z3fold_page_putback(struct p
 	INIT_LIST_HEAD(&page->lru);
 	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
 		atomic64_dec(&pool->pages_nr);
+		spin_lock(&pool->lock);
+		z3fold_dec_isolated(pool);
+		spin_unlock(&pool->lock);
 		return;
 	}
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
+	z3fold_dec_isolated(pool);
 	spin_unlock(&pool->lock);
 	z3fold_page_unlock(zhdr);
 }
_

Patches currently in -mm which might be from henryburns@google.com are


