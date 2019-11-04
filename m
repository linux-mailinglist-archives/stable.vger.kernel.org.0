Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56878EF059
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbfKDVuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387590AbfKDVuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:50:03 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51E6217F4;
        Mon,  4 Nov 2019 21:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904202;
        bh=dFJ9J0sls9xYbRtaMHJDsnxWSXWHVAFr2FWvnRleKCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdTYyakxHzin/awug+mxu8QWohETsyuPZFe4MA14QutDFHne6xN25d4HTk1XohmwH
         F9yt9vNycGqr3NoMd8Yv8YVY4WN1H5ZZqYOreAw0bYsiDfg5wZiy4rWEPTa2x1qQRA
         cAdAasDSHb6VmQlSMViTo3owe1ztsKLyi6eJ1LLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guruswamy Basavaiah <guru2018@gmail.com>,
        Nikos Tsironis <ntsironis@arrikto.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/62] dm snapshot: rework COW throttling to fix deadlock
Date:   Mon,  4 Nov 2019 22:44:25 +0100
Message-Id: <20191104211903.714156948@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b21555786f18cd77f2311ad89074533109ae3ffa ]

Commit 721b1d98fb517a ("dm snapshot: Fix excessive memory usage and
workqueue stalls") introduced a semaphore to limit the maximum number of
in-flight kcopyd (COW) jobs.

The implementation of this throttling mechanism is prone to a deadlock:

1. One or more threads write to the origin device causing COW, which is
   performed by kcopyd.

2. At some point some of these threads might reach the s->cow_count
   semaphore limit and block in down(&s->cow_count), holding a read lock
   on _origins_lock.

3. Someone tries to acquire a write lock on _origins_lock, e.g.,
   snapshot_ctr(), which blocks because the threads at step (2) already
   hold a read lock on it.

4. A COW operation completes and kcopyd runs dm-snapshot's completion
   callback, which ends up calling pending_complete().
   pending_complete() tries to resubmit any deferred origin bios. This
   requires acquiring a read lock on _origins_lock, which blocks.

   This happens because the read-write semaphore implementation gives
   priority to writers, meaning that as soon as a writer tries to enter
   the critical section, no readers will be allowed in, until all
   writers have completed their work.

   So, pending_complete() waits for the writer at step (3) to acquire
   and release the lock. This writer waits for the readers at step (2)
   to release the read lock and those readers wait for
   pending_complete() (the kcopyd thread) to signal the s->cow_count
   semaphore: DEADLOCK.

The above was thoroughly analyzed and documented by Nikos Tsironis as
part of his initial proposal for fixing this deadlock, see:
https://www.redhat.com/archives/dm-devel/2019-October/msg00001.html

Fix this deadlock by reworking COW throttling so that it waits without
holding any locks. Add a variable 'in_progress' that counts how many
kcopyd jobs are running. A function wait_for_in_progress() will sleep if
'in_progress' is over the limit. It drops _origins_lock in order to
avoid the deadlock.

Reported-by: Guruswamy Basavaiah <guru2018@gmail.com>
Reported-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
Tested-by: Nikos Tsironis <ntsironis@arrikto.com>
Fixes: 721b1d98fb51 ("dm snapshot: Fix excessive memory usage and workqueue stalls")
Cc: stable@vger.kernel.org # v5.0+
Depends-on: 4a3f111a73a8c ("dm snapshot: introduce account_start_copy() and account_end_copy()")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 80 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ef51ab8a5dcb2..cf2f44e500e24 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -19,7 +19,6 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
-#include <linux/semaphore.h>
 
 #include "dm.h"
 
@@ -106,8 +105,8 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
-	/* Maximum number of in-flight COW jobs. */
-	struct semaphore cow_count;
+	unsigned in_progress;
+	wait_queue_head_t in_progress_wait;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
@@ -158,8 +157,8 @@ struct dm_snapshot {
  */
 #define DEFAULT_COW_THRESHOLD 2048
 
-static int cow_threshold = DEFAULT_COW_THRESHOLD;
-module_param_named(snapshot_cow_threshold, cow_threshold, int, 0644);
+static unsigned cow_threshold = DEFAULT_COW_THRESHOLD;
+module_param_named(snapshot_cow_threshold, cow_threshold, uint, 0644);
 MODULE_PARM_DESC(snapshot_cow_threshold, "Maximum number of chunks being copied on write");
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
@@ -1206,7 +1205,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_hash_tables;
 	}
 
-	sema_init(&s->cow_count, (cow_threshold > 0) ? cow_threshold : INT_MAX);
+	init_waitqueue_head(&s->in_progress_wait);
 
 	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(s->kcopyd_client)) {
@@ -1396,17 +1395,54 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_put_device(ti, s->origin);
 
+	WARN_ON(s->in_progress);
+
 	kfree(s);
 }
 
 static void account_start_copy(struct dm_snapshot *s)
 {
-	down(&s->cow_count);
+	spin_lock(&s->in_progress_wait.lock);
+	s->in_progress++;
+	spin_unlock(&s->in_progress_wait.lock);
 }
 
 static void account_end_copy(struct dm_snapshot *s)
 {
-	up(&s->cow_count);
+	spin_lock(&s->in_progress_wait.lock);
+	BUG_ON(!s->in_progress);
+	s->in_progress--;
+	if (likely(s->in_progress <= cow_threshold) &&
+	    unlikely(waitqueue_active(&s->in_progress_wait)))
+		wake_up_locked(&s->in_progress_wait);
+	spin_unlock(&s->in_progress_wait.lock);
+}
+
+static bool wait_for_in_progress(struct dm_snapshot *s, bool unlock_origins)
+{
+	if (unlikely(s->in_progress > cow_threshold)) {
+		spin_lock(&s->in_progress_wait.lock);
+		if (likely(s->in_progress > cow_threshold)) {
+			/*
+			 * NOTE: this throttle doesn't account for whether
+			 * the caller is servicing an IO that will trigger a COW
+			 * so excess throttling may result for chunks not required
+			 * to be COW'd.  But if cow_threshold was reached, extra
+			 * throttling is unlikely to negatively impact performance.
+			 */
+			DECLARE_WAITQUEUE(wait, current);
+			__add_wait_queue(&s->in_progress_wait, &wait);
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			spin_unlock(&s->in_progress_wait.lock);
+			if (unlock_origins)
+				up_read(&_origins_lock);
+			io_schedule();
+			remove_wait_queue(&s->in_progress_wait, &wait);
+			return false;
+		}
+		spin_unlock(&s->in_progress_wait.lock);
+	}
+	return true;
 }
 
 /*
@@ -1424,7 +1460,7 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
-static int do_origin(struct dm_dev *origin, struct bio *bio);
+static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit);
 
 /*
  * Flush a list of buffers.
@@ -1437,7 +1473,7 @@ static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		r = do_origin(s->origin, bio);
+		r = do_origin(s->origin, bio, false);
 		if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 		bio = n;
@@ -1726,8 +1762,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (!s->valid)
 		return -EIO;
 
-	/* FIXME: should only take write lock if we need
-	 * to copy an exception */
+	if (bio_data_dir(bio) == WRITE) {
+		while (unlikely(!wait_for_in_progress(s, false)))
+			; /* wait_for_in_progress() has slept */
+	}
+
 	mutex_lock(&s->lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
@@ -1876,7 +1915,7 @@ redirect_to_origin:
 
 	if (bio_data_dir(bio) == WRITE) {
 		mutex_unlock(&s->lock);
-		return do_origin(s->origin, bio);
+		return do_origin(s->origin, bio, false);
 	}
 
 out_unlock:
@@ -2212,15 +2251,24 @@ next_snapshot:
 /*
  * Called on a write from the origin driver.
  */
-static int do_origin(struct dm_dev *origin, struct bio *bio)
+static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit)
 {
 	struct origin *o;
 	int r = DM_MAPIO_REMAPPED;
 
+again:
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
-	if (o)
+	if (o) {
+		if (limit) {
+			struct dm_snapshot *s;
+			list_for_each_entry(s, &o->snapshots, list)
+				if (unlikely(!wait_for_in_progress(s, true)))
+					goto again;
+		}
+
 		r = __origin_write(&o->snapshots, bio->bi_iter.bi_sector, bio);
+	}
 	up_read(&_origins_lock);
 
 	return r;
@@ -2333,7 +2381,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 		dm_accept_partial_bio(bio, available_sectors);
 
 	/* Only tell snapshots if this is a write */
-	return do_origin(o->dev, bio);
+	return do_origin(o->dev, bio, true);
 }
 
 static long origin_direct_access(struct dm_target *ti, sector_t sector,
-- 
2.20.1



