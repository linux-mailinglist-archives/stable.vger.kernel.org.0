Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B7C159A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfI2OBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729496AbfI2OBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC192082F;
        Sun, 29 Sep 2019 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765708;
        bh=/IlfYszVZ1szqZovrcaBcxnJw84xiCvpKaU+6jouhKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyIUfPJb/CAgTpaMQRNOZG7T9snjsXfj1NHkO9KBmL6rmm/tDRqYEuoeOTCjZ5GRR
         JEPTjCazt+4ZRFKctskTJKkMYl29aqTAWg3rduWmxoyBjPAi8jYmTg8IMhBukbINWl
         vPtVlmpRk4Cy8WBDh2eHmU7mZ8xu6xRwitIVCQZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Agust=C3=ADn=20DallAlba?= <agustin@dallalba.com.ar>,
        Vitaly Wool <vitalywool@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 22/45] Revert "mm/z3fold.c: fix race between migration and destruction"
Date:   Sun, 29 Sep 2019 15:55:50 +0200
Message-Id: <20190929135030.759427274@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Wool <vitalywool@gmail.com>

commit 6e73fd25e2c7510b7dfadbaf701f31d4bff9c75b upstream.

With the original commit applied, z3fold_zpool_destroy() may get blocked
on wait_event() for indefinite time.  Revert this commit for the time
being to get rid of this problem since the issue the original commit
addresses is less severe.

Link: http://lkml.kernel.org/r/20190910123142.7a9c8d2de4d0acbc0977c602@gmail.com
Fixes: d776aaa9895eb6eb77 ("mm/z3fold.c: fix race between migration and destruction")
Reported-by: Agustín Dall'Alba <agustin@dallalba.com.ar>
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   90 ------------------------------------------------------------
 1 file changed, 90 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -41,7 +41,6 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/wait.h>
 #include <linux/zpool.h>
 
 /*
@@ -145,8 +144,6 @@ struct z3fold_header {
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
  * @inode:	inode for z3fold pseudo filesystem
- * @destroying: bool to stop migration once we start destruction
- * @isolated: int to count the number of pages currently in isolation
  *
  * This structure is allocated at pool creation time and maintains metadata
  * pertaining to a particular z3fold pool.
@@ -165,11 +162,8 @@ struct z3fold_pool {
 	const struct zpool_ops *zpool_ops;
 	struct workqueue_struct *compact_wq;
 	struct workqueue_struct *release_wq;
-	struct wait_queue_head isolate_wait;
 	struct work_struct work;
 	struct inode *inode;
-	bool destroying;
-	int isolated;
 };
 
 /*
@@ -777,7 +771,6 @@ static struct z3fold_pool *z3fold_create
 		goto out_c;
 	spin_lock_init(&pool->lock);
 	spin_lock_init(&pool->stale_lock);
-	init_waitqueue_head(&pool->isolate_wait);
 	pool->unbuddied = __alloc_percpu(sizeof(struct list_head)*NCHUNKS, 2);
 	if (!pool->unbuddied)
 		goto out_pool;
@@ -817,15 +810,6 @@ out:
 	return NULL;
 }
 
-static bool pool_isolated_are_drained(struct z3fold_pool *pool)
-{
-	bool ret;
-
-	spin_lock(&pool->lock);
-	ret = pool->isolated == 0;
-	spin_unlock(&pool->lock);
-	return ret;
-}
 /**
  * z3fold_destroy_pool() - destroys an existing z3fold pool
  * @pool:	the z3fold pool to be destroyed
@@ -835,22 +819,6 @@ static bool pool_isolated_are_drained(st
 static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
-	/*
-	 * We set pool-> destroying under lock to ensure that
-	 * z3fold_page_isolate() sees any changes to destroying. This way we
-	 * avoid the need for any memory barriers.
-	 */
-
-	spin_lock(&pool->lock);
-	pool->destroying = true;
-	spin_unlock(&pool->lock);
-
-	/*
-	 * We need to ensure that no pages are being migrated while we destroy
-	 * these workqueues, as migration can queue work on either of the
-	 * workqueues.
-	 */
-	wait_event(pool->isolate_wait, !pool_isolated_are_drained(pool));
 
 	/*
 	 * We need to destroy pool->compact_wq before pool->release_wq,
@@ -1341,28 +1309,6 @@ static u64 z3fold_get_pool_size(struct z
 	return atomic64_read(&pool->pages_nr);
 }
 
-/*
- * z3fold_dec_isolated() expects to be called while pool->lock is held.
- */
-static void z3fold_dec_isolated(struct z3fold_pool *pool)
-{
-	assert_spin_locked(&pool->lock);
-	VM_BUG_ON(pool->isolated <= 0);
-	pool->isolated--;
-
-	/*
-	 * If we have no more isolated pages, we have to see if
-	 * z3fold_destroy_pool() is waiting for a signal.
-	 */
-	if (pool->isolated == 0 && waitqueue_active(&pool->isolate_wait))
-		wake_up_all(&pool->isolate_wait);
-}
-
-static void z3fold_inc_isolated(struct z3fold_pool *pool)
-{
-	pool->isolated++;
-}
-
 static bool z3fold_page_isolate(struct page *page, isolate_mode_t mode)
 {
 	struct z3fold_header *zhdr;
@@ -1389,34 +1335,6 @@ static bool z3fold_page_isolate(struct p
 		spin_lock(&pool->lock);
 		if (!list_empty(&page->lru))
 			list_del(&page->lru);
-		/*
-		 * We need to check for destruction while holding pool->lock, as
-		 * otherwise destruction could see 0 isolated pages, and
-		 * proceed.
-		 */
-		if (unlikely(pool->destroying)) {
-			spin_unlock(&pool->lock);
-			/*
-			 * If this page isn't stale, somebody else holds a
-			 * reference to it. Let't drop our refcount so that they
-			 * can call the release logic.
-			 */
-			if (unlikely(kref_put(&zhdr->refcount,
-					      release_z3fold_page_locked))) {
-				/*
-				 * If we get here we have kref problems, so we
-				 * should freak out.
-				 */
-				WARN(1, "Z3fold is experiencing kref problems\n");
-				z3fold_page_unlock(zhdr);
-				return false;
-			}
-			z3fold_page_unlock(zhdr);
-			return false;
-		}
-
-
-		z3fold_inc_isolated(pool);
 		spin_unlock(&pool->lock);
 		z3fold_page_unlock(zhdr);
 		return true;
@@ -1485,10 +1403,6 @@ static int z3fold_page_migrate(struct ad
 
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
-	spin_lock(&pool->lock);
-	z3fold_dec_isolated(pool);
-	spin_unlock(&pool->lock);
-
 	page_mapcount_reset(page);
 	put_page(page);
 	return 0;
@@ -1508,14 +1422,10 @@ static void z3fold_page_putback(struct p
 	INIT_LIST_HEAD(&page->lru);
 	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
 		atomic64_dec(&pool->pages_nr);
-		spin_lock(&pool->lock);
-		z3fold_dec_isolated(pool);
-		spin_unlock(&pool->lock);
 		return;
 	}
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
-	z3fold_dec_isolated(pool);
 	spin_unlock(&pool->lock);
 	z3fold_page_unlock(zhdr);
 }


