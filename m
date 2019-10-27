Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638B2E646E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJ0RWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:22:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47133 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbfJ0RWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:22:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A6B4122131;
        Sun, 27 Oct 2019 13:22:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 13:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+NEqGp
        AMUGnaZJcWFEQWZwuw0XJmJCQMVIuAvC7kdDY=; b=V4Ot8p54/d9VhOePZuveLO
        Rf9eII8ZDPGF/Rk6QTrOgVUqkPChp3brInz8Ow3LZ2mgJ2iumfQC8vQu62oNHy2E
        ldcsT13vJXhEwdCqF9j4FpBxt5I0HhPYlToUNMtIJfUa2fr1fT7Znom9Gp0aagVD
        bzkkCcv8jIPslqAiRKJaTcUOnGcO3cVwynZMlGhDzwbUeMKgAg4qrFKPsxhE7DyH
        CJWuaMuaoKRu/8ulsAdoacA4ksSOfxqKXL2Ek6JLY8+guuzNbWz1dpIaZMhXOi8u
        6Yen1tzwNOtlZ2ENgvbi9j+LmribcDpnGqBCyImGRA6a1lhPfwnQdIyIuz4HWz2w
        ==
X-ME-Sender: <xms:YdK1XbqJKTo-Z9zGECx_woCqksN362ONJStf9G8lAlXTef4gcVGPkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehrvgguhhgrthdrtghomhenucfkphepjeejrdduheekrdehtd
    druddttdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:YdK1XRvT-VoLN-5LVItT_1Y1v3q84Dx_6iBHregKpHgAAjSKzmK81g>
    <xmx:YdK1XRkrimS8eNE_PXFNjVAQrUrnhggWfjkarAMOEnXoQbpB9vdV9w>
    <xmx:YdK1XXGmMB4TrYu8rpW4h7IoeMr3oLGCcReD2iwC_PDPBc-cNah7Vw>
    <xmx:YdK1XVQ5Vms6ZoIyRw4FiE9VI0THWYw3X7JGpDt4m4sMdKkgsMDq-A>
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35A01D6005B;
        Sun, 27 Oct 2019 13:22:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm snapshot: rework COW throttling to fix deadlock" failed to apply to 5.3-stable tree
To:     mpatocka@redhat.com, guru2018@gmail.com, ntsironis@arrikto.com,
        snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 16:37:28 +0100
Message-ID: <157219064719033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b21555786f18cd77f2311ad89074533109ae3ffa Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 2 Oct 2019 06:15:53 -0400
Subject: [PATCH] dm snapshot: rework COW throttling to fix deadlock

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

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index da3bd1794ee0..4fb1a40e68a0 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -18,7 +18,6 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
-#include <linux/semaphore.h>
 
 #include "dm.h"
 
@@ -107,8 +106,8 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
-	/* Maximum number of in-flight COW jobs. */
-	struct semaphore cow_count;
+	unsigned in_progress;
+	struct wait_queue_head in_progress_wait;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
@@ -162,8 +161,8 @@ struct dm_snapshot {
  */
 #define DEFAULT_COW_THRESHOLD 2048
 
-static int cow_threshold = DEFAULT_COW_THRESHOLD;
-module_param_named(snapshot_cow_threshold, cow_threshold, int, 0644);
+static unsigned cow_threshold = DEFAULT_COW_THRESHOLD;
+module_param_named(snapshot_cow_threshold, cow_threshold, uint, 0644);
 MODULE_PARM_DESC(snapshot_cow_threshold, "Maximum number of chunks being copied on write");
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
@@ -1327,7 +1326,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_hash_tables;
 	}
 
-	sema_init(&s->cow_count, (cow_threshold > 0) ? cow_threshold : INT_MAX);
+	init_waitqueue_head(&s->in_progress_wait);
 
 	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(s->kcopyd_client)) {
@@ -1509,17 +1508,54 @@ static void snapshot_dtr(struct dm_target *ti)
 
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
@@ -1537,7 +1573,7 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
-static int do_origin(struct dm_dev *origin, struct bio *bio);
+static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit);
 
 /*
  * Flush a list of buffers.
@@ -1550,7 +1586,7 @@ static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		r = do_origin(s->origin, bio);
+		r = do_origin(s->origin, bio, false);
 		if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 		bio = n;
@@ -1926,6 +1962,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (!s->valid)
 		return DM_MAPIO_KILL;
 
+	if (bio_data_dir(bio) == WRITE) {
+		while (unlikely(!wait_for_in_progress(s, false)))
+			; /* wait_for_in_progress() has slept */
+	}
+
 	down_read(&s->lock);
 	dm_exception_table_lock(&lock);
 
@@ -2122,7 +2163,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 
 	if (bio_data_dir(bio) == WRITE) {
 		up_write(&s->lock);
-		return do_origin(s->origin, bio);
+		return do_origin(s->origin, bio, false);
 	}
 
 out_unlock:
@@ -2497,15 +2538,24 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
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
@@ -2618,7 +2668,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 		dm_accept_partial_bio(bio, available_sectors);
 
 	/* Only tell snapshots if this is a write */
-	return do_origin(o->dev, bio);
+	return do_origin(o->dev, bio, true);
 }
 
 /*

