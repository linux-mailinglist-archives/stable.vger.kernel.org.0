Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F40EF053
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbfKDVtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbfKDVtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:42 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2864C20B7C;
        Mon,  4 Nov 2019 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904180;
        bh=tkItOplQXZq4NflTC4QNBgcX4H9Ze5cjHBf5bbWXfyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIsnrO6jXHKDQS/3E8bc3iDnRjrw97ATbnPZlr4IC2/PQTsNGTwLnY05+82zHEZRc
         C/3udARpsGkZp+tAx/xz2W/Do31eCp9VbaFHZ0JXcJU0QjVL+t8wjXRy2hfQSUvAGd
         bbM2hdbsuR1/V0En5pVFq+sxLC0xLPULgmW4hH5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/62] dm snapshot: use mutex instead of rw_semaphore
Date:   Mon,  4 Nov 2019 22:44:23 +0100
Message-Id: <20191104211902.123416317@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit ae1093be5a0ef997833e200a0dafb9ed0b1ff4fe ]

The rw_semaphore is acquired for read only in two places, neither is
performance-critical.  So replace it with a mutex -- which is more
efficient.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 84 +++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 2da0b9b213c72..e5b0e13f5c92d 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -48,7 +48,7 @@ struct dm_exception_table {
 };
 
 struct dm_snapshot {
-	struct rw_semaphore lock;
+	struct mutex lock;
 
 	struct dm_dev *origin;
 	struct dm_dev *cow;
@@ -456,9 +456,9 @@ static int __find_snapshots_sharing_cow(struct dm_snapshot *snap,
 		if (!bdev_equal(s->cow->bdev, snap->cow->bdev))
 			continue;
 
-		down_read(&s->lock);
+		mutex_lock(&s->lock);
 		active = s->active;
-		up_read(&s->lock);
+		mutex_unlock(&s->lock);
 
 		if (active) {
 			if (snap_src)
@@ -926,7 +926,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	int r;
 	chunk_t old_chunk = s->first_merging_chunk + s->num_merging_chunks - 1;
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	/*
 	 * Process chunks (and associated exceptions) in reverse order
@@ -941,7 +941,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	b = __release_queued_bios_after_merge(s);
 
 out:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 	if (b)
 		flush_bios(b);
 
@@ -1000,9 +1000,9 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 		if (linear_chunks < 0) {
 			DMERR("Read error in exception store: "
 			      "shutting down merge");
-			down_write(&s->lock);
+			mutex_lock(&s->lock);
 			s->merge_failed = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 		}
 		goto shut;
 	}
@@ -1043,10 +1043,10 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 		previous_count = read_pending_exceptions_done_count();
 	}
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->first_merging_chunk = old_chunk;
 	s->num_merging_chunks = linear_chunks;
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	/* Wait until writes to all 'linear_chunks' drain */
 	for (i = 0; i < linear_chunks; i++)
@@ -1088,10 +1088,10 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 	return;
 
 shut:
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->merge_failed = 1;
 	b = __release_queued_bios_after_merge(s);
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 	error_bios(b);
 
 	merge_shutdown(s);
@@ -1190,7 +1190,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->exception_start_sequence = 0;
 	s->exception_complete_sequence = 0;
 	INIT_LIST_HEAD(&s->out_of_order_list);
-	init_rwsem(&s->lock);
+	mutex_init(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->state_bits = 0;
@@ -1357,9 +1357,9 @@ static void snapshot_dtr(struct dm_target *ti)
 	/* Check whether exception handover must be cancelled */
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest && (s == snap_src)) {
-		down_write(&snap_dest->lock);
+		mutex_lock(&snap_dest->lock);
 		snap_dest->valid = 0;
-		up_write(&snap_dest->lock);
+		mutex_unlock(&snap_dest->lock);
 		DMERR("Cancelling snapshot handover.");
 	}
 	up_read(&_origins_lock);
@@ -1390,6 +1390,8 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_exception_store_destroy(s->store);
 
+	mutex_destroy(&s->lock);
+
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);
@@ -1477,7 +1479,7 @@ static void pending_complete(void *context, int success)
 
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
-		down_write(&s->lock);
+		mutex_lock(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
 		goto out;
@@ -1485,14 +1487,14 @@ static void pending_complete(void *context, int success)
 
 	e = alloc_completed_exception(GFP_NOIO);
 	if (!e) {
-		down_write(&s->lock);
+		mutex_lock(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
 		goto out;
 	}
 	*e = pe->e;
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	if (!s->valid) {
 		free_completed_exception(e);
 		error = 1;
@@ -1517,7 +1519,7 @@ out:
 		full_bio->bi_end_io = pe->full_bio_end_io;
 	increment_pending_exceptions_done_count();
 
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	/* Submit any pending write bios */
 	if (error) {
@@ -1716,7 +1718,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 	/* FIXME: should only take write lock if we need
 	 * to copy an exception */
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
@@ -1739,9 +1741,9 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			pe = alloc_pending_exception(s);
-			down_write(&s->lock);
+			mutex_lock(&s->lock);
 
 			if (!s->valid || s->snapshot_overflowed) {
 				free_pending_exception(pe);
@@ -1776,7 +1778,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		    bio->bi_iter.bi_size ==
 		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			start_full_bio(pe, bio);
 			goto out;
 		}
@@ -1786,7 +1788,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			start_copy(pe);
 			goto out;
 		}
@@ -1796,7 +1798,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 out_unlock:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 out:
 	return r;
 }
@@ -1832,7 +1834,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	/* Full merging snapshots are redirected to the origin */
 	if (!s->valid)
@@ -1863,12 +1865,12 @@ redirect_to_origin:
 	bio->bi_bdev = s->origin->bdev;
 
 	if (bio_data_dir(bio) == WRITE) {
-		up_write(&s->lock);
+		mutex_unlock(&s->lock);
 		return do_origin(s->origin, bio);
 	}
 
 out_unlock:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	return r;
 }
@@ -1899,7 +1901,7 @@ static int snapshot_preresume(struct dm_target *ti)
 	down_read(&_origins_lock);
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		down_read(&snap_src->lock);
+		mutex_lock(&snap_src->lock);
 		if (s == snap_src) {
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
@@ -1909,7 +1911,7 @@ static int snapshot_preresume(struct dm_target *ti)
 			      "source is suspended.");
 			r = -EINVAL;
 		}
-		up_read(&snap_src->lock);
+		mutex_unlock(&snap_src->lock);
 	}
 	up_read(&_origins_lock);
 
@@ -1955,11 +1957,11 @@ static void snapshot_resume(struct dm_target *ti)
 
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		down_write(&snap_src->lock);
-		down_write_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
+		mutex_lock(&snap_src->lock);
+		mutex_lock_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
 		__handover_exceptions(snap_src, snap_dest);
-		up_write(&snap_dest->lock);
-		up_write(&snap_src->lock);
+		mutex_unlock(&snap_dest->lock);
+		mutex_unlock(&snap_src->lock);
 	}
 
 	up_read(&_origins_lock);
@@ -1974,9 +1976,9 @@ static void snapshot_resume(struct dm_target *ti)
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->active = 1;
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 }
 
 static uint32_t get_origin_minimum_chunksize(struct block_device *bdev)
@@ -2016,7 +2018,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 	switch (type) {
 	case STATUSTYPE_INFO:
 
-		down_write(&snap->lock);
+		mutex_lock(&snap->lock);
 
 		if (!snap->valid)
 			DMEMIT("Invalid");
@@ -2041,7 +2043,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("Unknown");
 		}
 
-		up_write(&snap->lock);
+		mutex_unlock(&snap->lock);
 
 		break;
 
@@ -2107,7 +2109,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		if (dm_target_is_snapshot_merge(snap->ti))
 			continue;
 
-		down_write(&snap->lock);
+		mutex_lock(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
 		if (!snap->valid || !snap->active)
@@ -2134,9 +2136,9 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			up_write(&snap->lock);
+			mutex_unlock(&snap->lock);
 			pe = alloc_pending_exception(snap);
-			down_write(&snap->lock);
+			mutex_lock(&snap->lock);
 
 			if (!snap->valid) {
 				free_pending_exception(pe);
@@ -2179,7 +2181,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		}
 
 next_snapshot:
-		up_write(&snap->lock);
+		mutex_unlock(&snap->lock);
 
 		if (pe_to_start_now) {
 			start_copy(pe_to_start_now);
-- 
2.20.1



