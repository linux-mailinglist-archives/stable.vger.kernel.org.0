Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E255FE66F7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfJ0VQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbfJ0VQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:50 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895B621726;
        Sun, 27 Oct 2019 21:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211009;
        bh=OTjw6Fx7Rjm7MPM6SXQSae15WjISv8x9DLpcgCTBjnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+PjCz9P3fq7l1Yk2ZRhedwvS29KEtBboCXTVKOjN7/hAeO0D+Fc3MGBiBAoCbQMz
         GBuYNpMBhgtuPqoOXsiVQ6bu/MsKNI/FU77/rC+RuZ7QL1YzqgMvWwO0xUGDptXWxR
         V9btoU37TSFgv63o9+STFhOutCYKHyaNa8JRRHaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 78/93] dm cache: fix bugs when a GFP_NOWAIT allocation fails
Date:   Sun, 27 Oct 2019 22:01:30 +0100
Message-Id: <20191027203311.950155787@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 13bd677a472d534bf100bab2713efc3f9e3f5978 upstream.

GFP_NOWAIT allocation can fail anytime - it doesn't wait for memory being
available and it fails if the mempool is exhausted and there is not enough
memory.

If we go down this path:
  map_bio -> mg_start -> alloc_migration -> mempool_alloc(GFP_NOWAIT)
we can see that map_bio() doesn't check the return value of mg_start(),
and the bio is leaked.

If we go down this path:
  map_bio -> mg_start -> mg_lock_writes -> alloc_prison_cell ->
  dm_bio_prison_alloc_cell_v2 -> mempool_alloc(GFP_NOWAIT) ->
  mg_lock_writes -> mg_complete
the bio is ended with an error - it is unacceptable because it could
cause filesystem corruption if the machine ran out of memory
temporarily.

Change GFP_NOWAIT to GFP_NOIO, so that the mempool code will properly
wait until memory becomes available. mempool_alloc with GFP_NOIO can't
fail, so remove the code paths that deal with allocation failure.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -541,7 +541,7 @@ static void wake_migration_worker(struct
 
 static struct dm_bio_prison_cell_v2 *alloc_prison_cell(struct cache *cache)
 {
-	return dm_bio_prison_alloc_cell_v2(cache->prison, GFP_NOWAIT);
+	return dm_bio_prison_alloc_cell_v2(cache->prison, GFP_NOIO);
 }
 
 static void free_prison_cell(struct cache *cache, struct dm_bio_prison_cell_v2 *cell)
@@ -553,9 +553,7 @@ static struct dm_cache_migration *alloc_
 {
 	struct dm_cache_migration *mg;
 
-	mg = mempool_alloc(&cache->migration_pool, GFP_NOWAIT);
-	if (!mg)
-		return NULL;
+	mg = mempool_alloc(&cache->migration_pool, GFP_NOIO);
 
 	memset(mg, 0, sizeof(*mg));
 
@@ -663,10 +661,6 @@ static bool bio_detain_shared(struct cac
 	struct dm_bio_prison_cell_v2 *cell_prealloc, *cell;
 
 	cell_prealloc = alloc_prison_cell(cache); /* FIXME: allow wait if calling from worker */
-	if (!cell_prealloc) {
-		defer_bio(cache, bio);
-		return false;
-	}
 
 	build_key(oblock, end, &key);
 	r = dm_cell_get_v2(cache->prison, &key, lock_level(bio), bio, cell_prealloc, &cell);
@@ -1492,11 +1486,6 @@ static int mg_lock_writes(struct dm_cach
 	struct dm_bio_prison_cell_v2 *prealloc;
 
 	prealloc = alloc_prison_cell(cache);
-	if (!prealloc) {
-		DMERR_LIMIT("%s: alloc_prison_cell failed", cache_device_name(cache));
-		mg_complete(mg, false);
-		return -ENOMEM;
-	}
 
 	/*
 	 * Prevent writes to the block, but allow reads to continue.
@@ -1534,11 +1523,6 @@ static int mg_start(struct cache *cache,
 	}
 
 	mg = alloc_migration(cache);
-	if (!mg) {
-		policy_complete_background_work(cache->policy, op, false);
-		background_work_end(cache);
-		return -ENOMEM;
-	}
 
 	mg->op = op;
 	mg->overwrite_bio = bio;
@@ -1627,10 +1611,6 @@ static int invalidate_lock(struct dm_cac
 	struct dm_bio_prison_cell_v2 *prealloc;
 
 	prealloc = alloc_prison_cell(cache);
-	if (!prealloc) {
-		invalidate_complete(mg, false);
-		return -ENOMEM;
-	}
 
 	build_key(mg->invalidate_oblock, oblock_succ(mg->invalidate_oblock), &key);
 	r = dm_cell_lock_v2(cache->prison, &key,
@@ -1668,10 +1648,6 @@ static int invalidate_start(struct cache
 		return -EPERM;
 
 	mg = alloc_migration(cache);
-	if (!mg) {
-		background_work_end(cache);
-		return -ENOMEM;
-	}
 
 	mg->overwrite_bio = bio;
 	mg->invalidate_cblock = cblock;


