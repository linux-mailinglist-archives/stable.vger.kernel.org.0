Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B5E6820
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbfJ0VZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbfJ0VZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:07 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F10F2064A;
        Sun, 27 Oct 2019 21:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211506;
        bh=geCA7WKbHfFDzbjT2Ap1pwSwpmUYXwdqOX48VBY2FyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCz0NW3wq/xfKv5GsGGPzk/p3uqjFeEbwxHrPnR9G7Hykx0kSIFFn8dL9cuQr8R8S
         1dcDrUuDDIlZNJbMfmNon7tqk58s0QzjqbgJ/7eRxqNeTKOhtHbPdeBv+EEA7M/QbM
         IHJ5L+ztlI37gESWpOKkbu5V7zkdjzQuybCky584=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.3 173/197] dm cache: fix bugs when a GFP_NOWAIT allocation fails
Date:   Sun, 27 Oct 2019 22:01:31 +0100
Message-Id: <20191027203404.309364288@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -542,7 +542,7 @@ static void wake_migration_worker(struct
 
 static struct dm_bio_prison_cell_v2 *alloc_prison_cell(struct cache *cache)
 {
-	return dm_bio_prison_alloc_cell_v2(cache->prison, GFP_NOWAIT);
+	return dm_bio_prison_alloc_cell_v2(cache->prison, GFP_NOIO);
 }
 
 static void free_prison_cell(struct cache *cache, struct dm_bio_prison_cell_v2 *cell)
@@ -554,9 +554,7 @@ static struct dm_cache_migration *alloc_
 {
 	struct dm_cache_migration *mg;
 
-	mg = mempool_alloc(&cache->migration_pool, GFP_NOWAIT);
-	if (!mg)
-		return NULL;
+	mg = mempool_alloc(&cache->migration_pool, GFP_NOIO);
 
 	memset(mg, 0, sizeof(*mg));
 
@@ -664,10 +662,6 @@ static bool bio_detain_shared(struct cac
 	struct dm_bio_prison_cell_v2 *cell_prealloc, *cell;
 
 	cell_prealloc = alloc_prison_cell(cache); /* FIXME: allow wait if calling from worker */
-	if (!cell_prealloc) {
-		defer_bio(cache, bio);
-		return false;
-	}
 
 	build_key(oblock, end, &key);
 	r = dm_cell_get_v2(cache->prison, &key, lock_level(bio), bio, cell_prealloc, &cell);
@@ -1493,11 +1487,6 @@ static int mg_lock_writes(struct dm_cach
 	struct dm_bio_prison_cell_v2 *prealloc;
 
 	prealloc = alloc_prison_cell(cache);
-	if (!prealloc) {
-		DMERR_LIMIT("%s: alloc_prison_cell failed", cache_device_name(cache));
-		mg_complete(mg, false);
-		return -ENOMEM;
-	}
 
 	/*
 	 * Prevent writes to the block, but allow reads to continue.
@@ -1535,11 +1524,6 @@ static int mg_start(struct cache *cache,
 	}
 
 	mg = alloc_migration(cache);
-	if (!mg) {
-		policy_complete_background_work(cache->policy, op, false);
-		background_work_end(cache);
-		return -ENOMEM;
-	}
 
 	mg->op = op;
 	mg->overwrite_bio = bio;
@@ -1628,10 +1612,6 @@ static int invalidate_lock(struct dm_cac
 	struct dm_bio_prison_cell_v2 *prealloc;
 
 	prealloc = alloc_prison_cell(cache);
-	if (!prealloc) {
-		invalidate_complete(mg, false);
-		return -ENOMEM;
-	}
 
 	build_key(mg->invalidate_oblock, oblock_succ(mg->invalidate_oblock), &key);
 	r = dm_cell_lock_v2(cache->prison, &key,
@@ -1669,10 +1649,6 @@ static int invalidate_start(struct cache
 		return -EPERM;
 
 	mg = alloc_migration(cache);
-	if (!mg) {
-		background_work_end(cache);
-		return -ENOMEM;
-	}
 
 	mg->overwrite_bio = bio;
 	mg->invalidate_cblock = cblock;


