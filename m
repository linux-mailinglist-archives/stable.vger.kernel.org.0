Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1E24B50D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgHTKRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731213AbgHTKRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839CF2078D;
        Thu, 20 Aug 2020 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918621;
        bh=CCvN0bgFwIQE+49m9hrMfGrh0SfGQe5pLOPKwurw+iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEmUytOLTeaJh+Uc6SsbkTQhrfe0Hke7ikYYK8Wg2QbAjllrrSrH4tMm2aynriUs+
         6hhmaRwn2vMlw9BhFaBPkFpo9Vls0X3iKczuAdP5pkrr85K0XsUHjG5XZGJRHnl9UH
         cB8oIAolaFJXNhXupNumTPgCu4KUQiI3DovWJD0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 225/228] dm cache: pass cache structure to mode functions
Date:   Thu, 20 Aug 2020 11:23:20 +0200
Message-Id: <20200820091618.751782490@linuxfoundation.org>
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

commit 8e3c3827776fc93728c0c8d7c7b731226dc6ee23 upstream.

No functional changes, just a bit cleaner than passing cache_features
structure.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -515,19 +515,19 @@ struct dm_cache_migration {
 
 /*----------------------------------------------------------------*/
 
-static bool writethrough_mode(struct cache_features *f)
+static bool writethrough_mode(struct cache *cache)
 {
-	return f->io_mode == CM_IO_WRITETHROUGH;
+	return cache->features.io_mode == CM_IO_WRITETHROUGH;
 }
 
-static bool writeback_mode(struct cache_features *f)
+static bool writeback_mode(struct cache *cache)
 {
-	return f->io_mode == CM_IO_WRITEBACK;
+	return cache->features.io_mode == CM_IO_WRITEBACK;
 }
 
-static inline bool passthrough_mode(struct cache_features *f)
+static inline bool passthrough_mode(struct cache *cache)
 {
-	return unlikely(f->io_mode == CM_IO_PASSTHROUGH);
+	return unlikely(cache->features.io_mode == CM_IO_PASSTHROUGH);
 }
 
 /*----------------------------------------------------------------*/
@@ -544,7 +544,7 @@ static void wake_deferred_writethrough_w
 
 static void wake_migration_worker(struct cache *cache)
 {
-	if (passthrough_mode(&cache->features))
+	if (passthrough_mode(cache))
 		return;
 
 	queue_work(cache->wq, &cache->migration_worker);
@@ -626,7 +626,7 @@ static unsigned lock_level(struct bio *b
 
 static size_t get_per_bio_data_size(struct cache *cache)
 {
-	return writethrough_mode(&cache->features) ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
+	return writethrough_mode(cache) ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
 }
 
 static struct per_bio_data *get_per_bio_data(struct bio *bio, size_t data_size)
@@ -1209,7 +1209,7 @@ static bool bio_writes_complete_block(st
 
 static bool optimisable_bio(struct cache *cache, struct bio *bio, dm_oblock_t block)
 {
-	return writeback_mode(&cache->features) &&
+	return writeback_mode(cache) &&
 		(is_discarded_oblock(cache, block) || bio_writes_complete_block(cache, bio));
 }
 
@@ -1862,7 +1862,7 @@ static int map_bio(struct cache *cache,
 		 * Passthrough always maps to the origin, invalidating any
 		 * cache blocks that are written to.
 		 */
-		if (passthrough_mode(&cache->features)) {
+		if (passthrough_mode(cache)) {
 			if (bio_data_dir(bio) == WRITE) {
 				bio_drop_shared_lock(cache, bio);
 				atomic_inc(&cache->stats.demotion);
@@ -1871,7 +1871,7 @@ static int map_bio(struct cache *cache,
 				remap_to_origin_clear_discard(cache, bio, block);
 
 		} else {
-			if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
+			if (bio_data_dir(bio) == WRITE && writethrough_mode(cache) &&
 			    !is_dirty(cache, cblock)) {
 				remap_to_origin_then_cache(cache, bio, block, cblock);
 				accounted_begin(cache, bio);
@@ -2649,7 +2649,7 @@ static int cache_create(struct cache_arg
 		goto bad;
 	}
 
-	if (passthrough_mode(&cache->features)) {
+	if (passthrough_mode(cache)) {
 		bool all_clean;
 
 		r = dm_cache_metadata_all_clean(cache->cmd, &all_clean);
@@ -3279,13 +3279,13 @@ static void cache_status(struct dm_targe
 		else
 			DMEMIT("1 ");
 
-		if (writethrough_mode(&cache->features))
+		if (writethrough_mode(cache))
 			DMEMIT("writethrough ");
 
-		else if (passthrough_mode(&cache->features))
+		else if (passthrough_mode(cache))
 			DMEMIT("passthrough ");
 
-		else if (writeback_mode(&cache->features))
+		else if (writeback_mode(cache))
 			DMEMIT("writeback ");
 
 		else {
@@ -3451,7 +3451,7 @@ static int process_invalidate_cblocks_me
 	unsigned i;
 	struct cblock_range range;
 
-	if (!passthrough_mode(&cache->features)) {
+	if (!passthrough_mode(cache)) {
 		DMERR("%s: cache has to be in passthrough mode for invalidation",
 		      cache_device_name(cache));
 		return -EPERM;


