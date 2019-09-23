Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B473ABBE7D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391531AbfIWWc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 18:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391372AbfIWWc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 18:32:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF76C2053B;
        Mon, 23 Sep 2019 22:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569277977;
        bh=b4eTJUekrst3p7hpBUQbrXUma+eNJh7NYZ/wU2WJyto=;
        h=Date:From:To:Subject:From;
        b=Hv0vNS/Vogol49WwVUy0Tp+4v/EGN19EB4AUAHEOqMGHWT+GgG3nB1kkNnrW6Oxfa
         Mtz25PgWIW7O5T0S95kUpo2IO0YoME2DhRb7CdhZyarSMGg4moWM4AMvqcwORS4PP+
         EK0Fq1J/KUKXdwAauYHmJFGbCqdwNnxVdaUZ2fZs=
Date:   Mon, 23 Sep 2019 15:32:56 -0700
From:   akpm@linux-foundation.org
To:     agustin@dallalba.com.ar, akpm@linux-foundation.org,
        henrywolfeburns@gmail.com, jwadams@google.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, vitalywool@gmail.com
Subject:  [patch 002/134] Revert "mm/z3fold.c: fix race between
 migration and destruction"
Message-ID: <20190923223256.nBrM9an0F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Vitaly Wool <vitalywool@gmail.com>
Subject: Revert "mm/z3fold.c: fix race between migration and destruction"

With the original commit applied, z3fold_zpool_destroy() may get blocked
on wait_event() for indefinite time.  Revert this commit for the time
being to get rid of this problem since the issue the original commit
addresses is less severe.

Link: http://lkml.kernel.org/r/20190910123142.7a9c8d2de4d0acbc0977c602@gmai=
l.com
Fixes: d776aaa9895eb6eb77 ("mm/z3fold.c: fix race between migration and des=
truction")
Reported-by: Agust=EDn Dall'Alba <agustin@dallalba.com.ar>
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   90 --------------------------------------------------
 1 file changed, 90 deletions(-)

--- a/mm/z3fold.c~revert-mm-z3foldc-fix-race-between-migration-and-destruct=
ion
+++ a/mm/z3fold.c
@@ -41,7 +41,6 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/wait.h>
 #include <linux/zpool.h>
 #include <linux/magic.h>
=20
@@ -146,8 +145,6 @@ struct z3fold_header {
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
  * @inode:	inode for z3fold pseudo filesystem
- * @destroying: bool to stop migration once we start destruction
- * @isolated: int to count the number of pages currently in isolation
  *
  * This structure is allocated at pool creation time and maintains metadata
  * pertaining to a particular z3fold pool.
@@ -166,11 +163,8 @@ struct z3fold_pool {
 	const struct zpool_ops *zpool_ops;
 	struct workqueue_struct *compact_wq;
 	struct workqueue_struct *release_wq;
-	struct wait_queue_head isolate_wait;
 	struct work_struct work;
 	struct inode *inode;
-	bool destroying;
-	int isolated;
 };
=20
 /*
@@ -775,7 +769,6 @@ static struct z3fold_pool *z3fold_create
 		goto out_c;
 	spin_lock_init(&pool->lock);
 	spin_lock_init(&pool->stale_lock);
-	init_waitqueue_head(&pool->isolate_wait);
 	pool->unbuddied =3D __alloc_percpu(sizeof(struct list_head)*NCHUNKS, 2);
 	if (!pool->unbuddied)
 		goto out_pool;
@@ -815,15 +808,6 @@ out:
 	return NULL;
 }
=20
-static bool pool_isolated_are_drained(struct z3fold_pool *pool)
-{
-	bool ret;
-
-	spin_lock(&pool->lock);
-	ret =3D pool->isolated =3D=3D 0;
-	spin_unlock(&pool->lock);
-	return ret;
-}
 /**
  * z3fold_destroy_pool() - destroys an existing z3fold pool
  * @pool:	the z3fold pool to be destroyed
@@ -833,22 +817,6 @@ static bool pool_isolated_are_drained(st
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
-	pool->destroying =3D true;
-	spin_unlock(&pool->lock);
-
-	/*
-	 * We need to ensure that no pages are being migrated while we destroy
-	 * these workqueues, as migration can queue work on either of the
-	 * workqueues.
-	 */
-	wait_event(pool->isolate_wait, !pool_isolated_are_drained(pool));
=20
 	/*
 	 * We need to destroy pool->compact_wq before pool->release_wq,
@@ -1339,28 +1307,6 @@ static u64 z3fold_get_pool_size(struct z
 	return atomic64_read(&pool->pages_nr);
 }
=20
-/*
- * z3fold_dec_isolated() expects to be called while pool->lock is held.
- */
-static void z3fold_dec_isolated(struct z3fold_pool *pool)
-{
-	assert_spin_locked(&pool->lock);
-	VM_BUG_ON(pool->isolated <=3D 0);
-	pool->isolated--;
-
-	/*
-	 * If we have no more isolated pages, we have to see if
-	 * z3fold_destroy_pool() is waiting for a signal.
-	 */
-	if (pool->isolated =3D=3D 0 && waitqueue_active(&pool->isolate_wait))
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
@@ -1387,34 +1333,6 @@ static bool z3fold_page_isolate(struct p
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
@@ -1483,10 +1401,6 @@ static int z3fold_page_migrate(struct ad
=20
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
=20
-	spin_lock(&pool->lock);
-	z3fold_dec_isolated(pool);
-	spin_unlock(&pool->lock);
-
 	page_mapcount_reset(page);
 	put_page(page);
 	return 0;
@@ -1506,14 +1420,10 @@ static void z3fold_page_putback(struct p
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
_
