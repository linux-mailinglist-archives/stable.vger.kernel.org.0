Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775BE24B6DD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgHTKmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731177AbgHTKQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2272075E;
        Thu, 20 Aug 2020 10:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918594;
        bh=TY8/cOOwKH06Y/se8nJzoffgbJQ37ddRZX3ahYPV7pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq1R0gJT/2IiVV85gZBhE/0o+83IFkTGPQMBiwUe5hWE9q76te2IeHzuhsyvJvBmJ
         ROecg69+xt54gTmKkEn95FxoawzzDDNZYojfk+l3IqLHKxWcPRCAt/jDJdzBgfXe3r
         bYAkJ556SUUTVOKPG4/8+XahpBa0JqoYB2Y6xyKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 227/228] dm cache: remove all obsolete writethrough-specific code
Date:   Thu, 20 Aug 2020 11:23:22 +0200
Message-Id: <20200820091618.849761692@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 9958f1d9a04efb3db19134482b3f4c6897e0e7b8 upstream.

Now that the writethrough code is much simpler there is no need to track
so much state or cascade bio submission (as was done, via
writethrough_endio(), to issue origin then cache IO in series).

As such the obsolete writethrough list and workqueue is also removed.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   82 -------------------------------------------
 1 file changed, 1 insertion(+), 81 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -410,7 +410,6 @@ struct cache {
 	spinlock_t lock;
 	struct list_head deferred_cells;
 	struct bio_list deferred_bios;
-	struct bio_list deferred_writethrough_bios;
 	sector_t migration_threshold;
 	wait_queue_head_t migration_wait;
 	atomic_t nr_allocated_migrations;
@@ -446,7 +445,6 @@ struct cache {
 	struct dm_kcopyd_client *copier;
 	struct workqueue_struct *wq;
 	struct work_struct deferred_bio_worker;
-	struct work_struct deferred_writethrough_worker;
 	struct work_struct migration_worker;
 	struct delayed_work waker;
 	struct dm_bio_prison_v2 *prison;
@@ -491,15 +489,6 @@ struct per_bio_data {
 	struct dm_bio_prison_cell_v2 *cell;
 	struct dm_hook_info hook_info;
 	sector_t len;
-
-	/*
-	 * writethrough fields.  These MUST remain at the end of this
-	 * structure and the 'cache' member must be the first as it
-	 * is used to determine the offset of the writethrough fields.
-	 */
-	struct cache *cache;
-	dm_cblock_t cblock;
-	struct dm_bio_details bio_details;
 };
 
 struct dm_cache_migration {
@@ -538,11 +527,6 @@ static void wake_deferred_bio_worker(str
 	queue_work(cache->wq, &cache->deferred_bio_worker);
 }
 
-static void wake_deferred_writethrough_worker(struct cache *cache)
-{
-	queue_work(cache->wq, &cache->deferred_writethrough_worker);
-}
-
 static void wake_migration_worker(struct cache *cache)
 {
 	if (passthrough_mode(cache))
@@ -619,15 +603,9 @@ static unsigned lock_level(struct bio *b
  * Per bio data
  *--------------------------------------------------------------*/
 
-/*
- * If using writeback, leave out struct per_bio_data's writethrough fields.
- */
-#define PB_DATA_SIZE_WB (offsetof(struct per_bio_data, cache))
-#define PB_DATA_SIZE_WT (sizeof(struct per_bio_data))
-
 static size_t get_per_bio_data_size(struct cache *cache)
 {
-	return writethrough_mode(cache) ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
+	return sizeof(struct per_bio_data);
 }
 
 static struct per_bio_data *get_per_bio_data(struct bio *bio, size_t data_size)
@@ -945,39 +923,6 @@ static void issue_op(struct bio *bio, vo
 	accounted_request(cache, bio);
 }
 
-static void defer_writethrough_bio(struct cache *cache, struct bio *bio)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cache->lock, flags);
-	bio_list_add(&cache->deferred_writethrough_bios, bio);
-	spin_unlock_irqrestore(&cache->lock, flags);
-
-	wake_deferred_writethrough_worker(cache);
-}
-
-static void writethrough_endio(struct bio *bio)
-{
-	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
-
-	dm_unhook_bio(&pb->hook_info, bio);
-
-	if (bio->bi_status) {
-		bio_endio(bio);
-		return;
-	}
-
-	dm_bio_restore(&pb->bio_details, bio);
-	remap_to_cache(pb->cache, bio, pb->cblock);
-
-	/*
-	 * We can't issue this bio directly, since we're in interrupt
-	 * context.  So it gets put on a bio list for processing by the
-	 * worker thread.
-	 */
-	defer_writethrough_bio(pb->cache, bio);
-}
-
 /*
  * When running in writethrough mode we need to send writes to clean blocks
  * to both the cache and origin devices.  Clone the bio and send them in parallel.
@@ -2013,28 +1958,6 @@ static void process_deferred_bios(struct
 		schedule_commit(&cache->committer);
 }
 
-static void process_deferred_writethrough_bios(struct work_struct *ws)
-{
-	struct cache *cache = container_of(ws, struct cache, deferred_writethrough_worker);
-
-	unsigned long flags;
-	struct bio_list bios;
-	struct bio *bio;
-
-	bio_list_init(&bios);
-
-	spin_lock_irqsave(&cache->lock, flags);
-	bio_list_merge(&bios, &cache->deferred_writethrough_bios);
-	bio_list_init(&cache->deferred_writethrough_bios);
-	spin_unlock_irqrestore(&cache->lock, flags);
-
-	/*
-	 * These bios have already been through accounted_begin()
-	 */
-	while ((bio = bio_list_pop(&bios)))
-		generic_make_request(bio);
-}
-
 /*----------------------------------------------------------------
  * Main worker loop
  *--------------------------------------------------------------*/
@@ -2690,7 +2613,6 @@ static int cache_create(struct cache_arg
 	spin_lock_init(&cache->lock);
 	INIT_LIST_HEAD(&cache->deferred_cells);
 	bio_list_init(&cache->deferred_bios);
-	bio_list_init(&cache->deferred_writethrough_bios);
 	atomic_set(&cache->nr_allocated_migrations, 0);
 	atomic_set(&cache->nr_io_migrations, 0);
 	init_waitqueue_head(&cache->migration_wait);
@@ -2729,8 +2651,6 @@ static int cache_create(struct cache_arg
 		goto bad;
 	}
 	INIT_WORK(&cache->deferred_bio_worker, process_deferred_bios);
-	INIT_WORK(&cache->deferred_writethrough_worker,
-		  process_deferred_writethrough_bios);
 	INIT_WORK(&cache->migration_worker, check_migrations);
 	INIT_DELAYED_WORK(&cache->waker, do_waker);
 


