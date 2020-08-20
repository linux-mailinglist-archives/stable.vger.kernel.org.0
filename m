Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0924B6D7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgHTKmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgHTKQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F52922B43;
        Thu, 20 Aug 2020 10:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918592;
        bh=yj64/f6KMzmdL0D/Mpp854/Qw3KqLXwTwQSrjmwQjaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX6yY0PsLkOaHexnJe7Us51Cs9l2U+92iFNaQcpfUGuWYaoq+f15lUVUFtNG/1T3Q
         SFEzuyOvNnVHb1TO3sS0ZIwALOw50RZYqxcuG8eP4eZT3BHWeCgbVu3r5OxgWKrwBu
         4C+b3F7eJmavImH1GoPLSh2iN5tZM4YVua1Kq0mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 226/228] dm cache: submit writethrough writes in parallel to origin and cache
Date:   Thu, 20 Aug 2020 11:23:21 +0200
Message-Id: <20200820091618.800636670@linuxfoundation.org>
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

commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9 upstream.

Discontinue issuing writethrough write IO in series to the origin and
then cache.

Use bio_clone_fast() to create a new origin clone bio that will be
mapped to the origin device and then bio_chain() it to the bio that gets
remapped to the cache device.  The origin clone bio does _not_ have a
copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
be called.

The cache bio (parent bio) will not complete until the origin bio has
completed -- this fulfills bio_clone_fast()'s requirements as well as
the requirement to not complete the original IO until the write IO has
completed to both the origin and cache device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   54 +++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 17 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -450,6 +450,7 @@ struct cache {
 	struct work_struct migration_worker;
 	struct delayed_work waker;
 	struct dm_bio_prison_v2 *prison;
+	struct bio_set *bs;
 
 	mempool_t *migration_pool;
 
@@ -868,16 +869,23 @@ static void check_if_tick_bio_needed(str
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
-static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
-					  dm_oblock_t oblock)
+static void __remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
+					    dm_oblock_t oblock, bool bio_has_pbd)
 {
-	// FIXME: this is called way too much.
-	check_if_tick_bio_needed(cache, bio);
+	if (bio_has_pbd)
+		check_if_tick_bio_needed(cache, bio);
 	remap_to_origin(cache, bio);
 	if (bio_data_dir(bio) == WRITE)
 		clear_discard(cache, oblock_to_dblock(cache, oblock));
 }
 
+static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
+					  dm_oblock_t oblock)
+{
+	// FIXME: check_if_tick_bio_needed() is called way too much through this interface
+	__remap_to_origin_clear_discard(cache, bio, oblock, true);
+}
+
 static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
 				 dm_oblock_t oblock, dm_cblock_t cblock)
 {
@@ -971,23 +979,25 @@ static void writethrough_endio(struct bi
 }
 
 /*
- * FIXME: send in parallel, huge latency as is.
  * When running in writethrough mode we need to send writes to clean blocks
- * to both the cache and origin devices.  In future we'd like to clone the
- * bio and send them in parallel, but for now we're doing them in
- * series as this is easier.
+ * to both the cache and origin devices.  Clone the bio and send them in parallel.
  */
-static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
-				       dm_oblock_t oblock, dm_cblock_t cblock)
+static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
+				      dm_oblock_t oblock, dm_cblock_t cblock)
 {
-	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
+	struct bio *origin_bio = bio_clone_fast(bio, GFP_NOIO, cache->bs);
+
+	BUG_ON(!origin_bio);
 
-	pb->cache = cache;
-	pb->cblock = cblock;
-	dm_hook_bio(&pb->hook_info, bio, writethrough_endio, NULL);
-	dm_bio_record(&pb->bio_details, bio);
+	bio_chain(origin_bio, bio);
+	/*
+	 * Passing false to __remap_to_origin_clear_discard() skips
+	 * all code that might use per_bio_data (since clone doesn't have it)
+	 */
+	__remap_to_origin_clear_discard(cache, origin_bio, oblock, false);
+	submit_bio(origin_bio);
 
-	remap_to_origin_clear_discard(pb->cache, bio, oblock);
+	remap_to_cache(cache, bio, cblock);
 }
 
 /*----------------------------------------------------------------
@@ -1873,7 +1883,7 @@ static int map_bio(struct cache *cache,
 		} else {
 			if (bio_data_dir(bio) == WRITE && writethrough_mode(cache) &&
 			    !is_dirty(cache, cblock)) {
-				remap_to_origin_then_cache(cache, bio, block, cblock);
+				remap_to_origin_and_cache(cache, bio, block, cblock);
 				accounted_begin(cache, bio);
 			} else
 				remap_to_cache_dirty(cache, bio, block, cblock);
@@ -2132,6 +2142,9 @@ static void destroy(struct cache *cache)
 		kfree(cache->ctr_args[i]);
 	kfree(cache->ctr_args);
 
+	if (cache->bs)
+		bioset_free(cache->bs);
+
 	kfree(cache);
 }
 
@@ -2589,6 +2602,13 @@ static int cache_create(struct cache_arg
 	cache->features = ca->features;
 	ti->per_io_data_size = get_per_bio_data_size(cache);
 
+	if (writethrough_mode(cache)) {
+		/* Create bioset for writethrough bios issued to origin */
+		cache->bs = bioset_create(BIO_POOL_SIZE, 0, 0);
+		if (!cache->bs)
+			goto bad;
+	}
+
 	cache->callbacks.congested_fn = cache_is_congested;
 	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
 


