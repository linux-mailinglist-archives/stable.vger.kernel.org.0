Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F95AFE23
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfIKNzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 09:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbfIKNzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 09:55:40 -0400
Received: from X1 (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFDB206A5;
        Wed, 11 Sep 2019 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568210138;
        bh=4q8Q5S6B4Dwz4GK+zVCfwt5+5CR7fgs73JAOdqBSMAw=;
        h=Date:From:To:Subject:From;
        b=07n1CcpOPbDvbQ20isidsr0V5pg1I378yO9QGXNR5g42+Tp8EN0lsali71lTa7EKN
         mriq6ey9vFM2W5HTfZ7znnRJ8IfStQKRpyIrgoDff3nNEGmqLKUtEcoQCop8h8wo/4
         eLey2wtO0ZEjitJ47qaSGhP95efwZFST1A2P1lFc=
Date:   Wed, 11 Sep 2019 06:55:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        shakeelb@google.com, jwadams@google.com, henrywolfeburns@gmail.com,
        agustin@dallalba.com.ar, vitalywool@gmail.com
Subject:  +
 revert-mm-z3foldc-fix-race-between-migration-and-destruction.patch added to
 -mm tree
Message-ID: <20190911135534.0T9Wu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm/z3fold.c: fix race between migration and destructi=
on"
has been added to the -mm tree.  Its filename is
     revert-mm-z3foldc-fix-race-between-migration-and-destruction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-z3foldc-fix-race-bet=
ween-migration-and-destruction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-z3foldc-fix-race-bet=
ween-migration-and-destruction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
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

Patches currently in -mm which might be from vitalywool@gmail.com are

revert-mm-z3foldc-fix-race-between-migration-and-destruction.patch

