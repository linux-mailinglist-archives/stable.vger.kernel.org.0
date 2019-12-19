Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C5F126BAD
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbfLSSz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730659AbfLSSz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9757524682;
        Thu, 19 Dec 2019 18:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781726;
        bh=lUqApjf+6hAiusOv9XTNAd7bgdeXjYng9q51mOsCGOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLEvlbR6gmMP0QP3gh7ogW8BFSGVWalDwQRamWNA0OgOKAAAeGjY7Tl9XIzqYonTa
         UMykVLBrYFAZpBqiXUhzg67pbjveeWTr/3sc24yoRGl2Rg4bQS5RJPmwJ1QLrdb58c
         zh89mzebFVYchQ3aQ9sMl0tNitHzVeeWh1RGy/00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 55/80] dm clone: Flush destination device before committing metadata
Date:   Thu, 19 Dec 2019 19:34:47 +0100
Message-Id: <20191219183129.010437125@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 8b3fd1f53af3591d5624ab9df718369b14d09ed1 upstream.

dm-clone maintains an on-disk bitmap which records which regions are
valid in the destination device, i.e., which regions have already been
hydrated, or have been written to directly, via user I/O.

Setting a bit in the on-disk bitmap meas the corresponding region is
valid in the destination device and we redirect all I/O regarding it to
the destination device.

Suppose the destination device has a volatile write-back cache and the
following sequence of events occur:

1. A region gets hydrated, either through the background hydration or
   because it was written to directly, via user I/O.

2. The commit timeout expires and we commit the metadata, marking that
   region as valid in the destination device.

3. The system crashes and the destination device's cache has not been
   flushed, meaning the region's data are lost.

The next time we read that region we read it from the destination
device, since the metadata have been successfully committed, but the
data are lost due to the crash, so we read garbage instead of the old
data.

This has several implications:

1. In case of background hydration or of writes with size smaller than
   the region size (which means we first copy the whole region and then
   issue the smaller write), we corrupt data that the user never
   touched.

2. In case of writes with size equal to the device's logical block size,
   we fail to provide atomic sector writes. When the system recovers the
   user will read garbage from the sector instead of the old data or the
   new data.

3. In case of writes without the FUA flag set, after the system
   recovers, the written sectors will contain garbage instead of a
   random mix of sectors containing either old data or new data, thus we
   fail again to provide atomic sector writes.

4. Even when the user flushes the dm-clone device, because we first
   commit the metadata and then pass down the flush, the same risk for
   corruption exists (if the system crashes after the metadata have been
   committed but before the flush is passed down).

The only case which is unaffected is that of writes with size equal to
the region size and with the FUA flag set. But, because FUA writes
trigger metadata commits, this case can trigger the corruption
indirectly.

To solve this and avoid the potential data corruption we flush the
destination device **before** committing the metadata.

This ensures that any freshly hydrated regions, for which we commit the
metadata, are properly written to non-volatile storage and won't be lost
in case of a crash.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-clone-target.c |   46 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -86,6 +86,12 @@ struct clone {
 
 	struct dm_clone_metadata *cmd;
 
+	/*
+	 * bio used to flush the destination device, before committing the
+	 * metadata.
+	 */
+	struct bio flush_bio;
+
 	/* Region hydration hash table */
 	struct hash_table_bucket *ht;
 
@@ -1106,10 +1112,13 @@ static bool need_commit_due_to_time(stru
 /*
  * A non-zero return indicates read-only or fail mode.
  */
-static int commit_metadata(struct clone *clone)
+static int commit_metadata(struct clone *clone, bool *dest_dev_flushed)
 {
 	int r = 0;
 
+	if (dest_dev_flushed)
+		*dest_dev_flushed = false;
+
 	mutex_lock(&clone->commit_lock);
 
 	if (!dm_clone_changed_this_transaction(clone->cmd))
@@ -1126,6 +1135,19 @@ static int commit_metadata(struct clone
 		goto out;
 	}
 
+	bio_reset(&clone->flush_bio);
+	bio_set_dev(&clone->flush_bio, clone->dest_dev->bdev);
+	clone->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	r = submit_bio_wait(&clone->flush_bio);
+	if (unlikely(r)) {
+		__metadata_operation_failed(clone, "flush destination device", r);
+		goto out;
+	}
+
+	if (dest_dev_flushed)
+		*dest_dev_flushed = true;
+
 	r = dm_clone_metadata_commit(clone->cmd);
 	if (unlikely(r)) {
 		__metadata_operation_failed(clone, "dm_clone_metadata_commit", r);
@@ -1199,6 +1221,7 @@ static void process_deferred_flush_bios(
 {
 	struct bio *bio;
 	unsigned long flags;
+	bool dest_dev_flushed;
 	struct bio_list bios = BIO_EMPTY_LIST;
 	struct bio_list bio_completions = BIO_EMPTY_LIST;
 
@@ -1218,7 +1241,7 @@ static void process_deferred_flush_bios(
 	    !(dm_clone_changed_this_transaction(clone->cmd) && need_commit_due_to_time(clone)))
 		return;
 
-	if (commit_metadata(clone)) {
+	if (commit_metadata(clone, &dest_dev_flushed)) {
 		bio_list_merge(&bios, &bio_completions);
 
 		while ((bio = bio_list_pop(&bios)))
@@ -1232,8 +1255,17 @@ static void process_deferred_flush_bios(
 	while ((bio = bio_list_pop(&bio_completions)))
 		bio_endio(bio);
 
-	while ((bio = bio_list_pop(&bios)))
-		generic_make_request(bio);
+	while ((bio = bio_list_pop(&bios))) {
+		if ((bio->bi_opf & REQ_PREFLUSH) && dest_dev_flushed) {
+			/* We just flushed the destination device as part of
+			 * the metadata commit, so there is no reason to send
+			 * another flush.
+			 */
+			bio_endio(bio);
+		} else {
+			generic_make_request(bio);
+		}
+	}
 }
 
 static void do_worker(struct work_struct *work)
@@ -1405,7 +1437,7 @@ static void clone_status(struct dm_targe
 
 		/* Commit to ensure statistics aren't out-of-date */
 		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
-			(void) commit_metadata(clone);
+			(void) commit_metadata(clone, NULL);
 
 		r = dm_clone_get_free_metadata_block_count(clone->cmd, &nr_free_metadata_blocks);
 
@@ -1839,6 +1871,7 @@ static int clone_ctr(struct dm_target *t
 	bio_list_init(&clone->deferred_flush_completions);
 	clone->hydration_offset = 0;
 	atomic_set(&clone->hydrations_in_flight, 0);
+	bio_init(&clone->flush_bio, NULL, 0);
 
 	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
 	if (!clone->wq) {
@@ -1912,6 +1945,7 @@ static void clone_dtr(struct dm_target *
 	struct clone *clone = ti->private;
 
 	mutex_destroy(&clone->commit_lock);
+	bio_uninit(&clone->flush_bio);
 
 	for (i = 0; i < clone->nr_ctr_args; i++)
 		kfree(clone->ctr_args[i]);
@@ -1966,7 +2000,7 @@ static void clone_postsuspend(struct dm_
 	wait_event(clone->hydration_stopped, !atomic_read(&clone->hydrations_in_flight));
 	flush_workqueue(clone->wq);
 
-	(void) commit_metadata(clone);
+	(void) commit_metadata(clone, NULL);
 }
 
 static void clone_resume(struct dm_target *ti)


