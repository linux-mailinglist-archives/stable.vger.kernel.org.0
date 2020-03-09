Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C917E9AB
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgCIUFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:05:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49483 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbgCIUFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:05:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CAC3D22008;
        Mon,  9 Mar 2020 16:05:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8P3fIA
        xX9tQfDKkZ3PYT0WClKKZJwMQCJdeGl3eWhcE=; b=k7KeydsRBr7N/+tdI0ziqm
        O5VEo9tMMzOK6KtCaLMcNt70KdAMNJr0FP919a4yuj1cl0Uf92ICYoI2Gp1Q/5vA
        4YF3sYqwR159OkYed8Fl1NPosALNlPpfxxo1I6bQe6ZHms7TDoFIKh0tqcE03DyS
        4tswiYIBTaqFkDuKvpat4IhLpOo950jaF1vFBj9wM3LxkAjcuXwShkO7vLcM7Xfj
        +LFXPF7KvPefLRxhbXOpr2ueBddrv4RH8Y2IAMezTulPFkU8Lt0kI1jBnjKurK0K
        3+m3gjiTDGL8mK85SQGpLB/gZd6yMTdERvCO5lp+T98WwJSUFpo7iFSY1banQ/Wg
        ==
X-ME-Sender: <xms:jqFmXjKNfMl2Bj9dU2Hi7D3N9invHnmfYpGFK3DXlKvfXGarFlJ3GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepud
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jqFmXlqfW3Vht0R-ty2do-4hWC7rplUZGslJu66Vju4f8lhUeTJMZg>
    <xmx:jqFmXh7uFtgxWGzURycD9Qto5bCllYS9ITHNu9d1DPwcZ2IkTj0YLQ>
    <xmx:jqFmXhIDnyDiSxNu0NHVm4D1RXnFKOQvsunW-y04m13O5w2qbF-KUQ>
    <xmx:jqFmXoGmQr69YegPOr5PwOmb0Cfqcg-PlsjVZjXkGEOX2-p_mYKaZA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 668E8306189E;
        Mon,  9 Mar 2020 16:05:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm integrity: fix a deadlock due to offloading to an" failed to apply to 4.14-stable tree
To:     mpatocka@redhat.com, heinzm@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:05:25 +0100
Message-ID: <158378432520624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 53770f0ec5fd417429775ba006bc4abe14002335 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 17 Feb 2020 07:43:03 -0500
Subject: [PATCH] dm integrity: fix a deadlock due to offloading to an
 incorrect workqueue

If we need to perform synchronous I/O in dm_integrity_map_continue(),
we must make sure that we are not in the map function - in order to
avoid the deadlock due to bio queuing in generic_make_request. To
avoid the deadlock, we offload the request to metadata_wq.

However, metadata_wq also processes metadata updates for write requests.
If there are too many requests that get offloaded to metadata_wq at the
beginning of dm_integrity_map_continue, the workqueue metadata_wq
becomes clogged and the system is incapable of processing any metadata
updates.

This causes a deadlock because all the requests that need to do metadata
updates wait for metadata_wq to proceed and metadata_wq waits inside
wait_and_add_new_range until some existing request releases its range
lock (which doesn't happen because the range lock is released after
metadata update).

In order to fix the deadlock, we create a new workqueue offload_wq and
offload requests to it - so that processing of offload_wq is independent
from processing of metadata_wq.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org # v4.12+
Reported-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 166727a47cef..6b6c3e1deaa8 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -212,6 +212,7 @@ struct dm_integrity_c {
 	struct list_head wait_list;
 	wait_queue_head_t endio_wait;
 	struct workqueue_struct *wait_wq;
+	struct workqueue_struct *offload_wq;
 
 	unsigned char commit_seq;
 	commit_id_t commit_ids[N_COMMIT_IDS];
@@ -1439,7 +1440,7 @@ static void dec_in_flight(struct dm_integrity_io *dio)
 			dio->range.logical_sector += dio->range.n_sectors;
 			bio_advance(bio, dio->range.n_sectors << SECTOR_SHIFT);
 			INIT_WORK(&dio->work, integrity_bio_wait);
-			queue_work(ic->wait_wq, &dio->work);
+			queue_work(ic->offload_wq, &dio->work);
 			return;
 		}
 		do_endio_flush(ic, dio);
@@ -1865,7 +1866,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 
 	if (need_sync_io && from_map) {
 		INIT_WORK(&dio->work, integrity_bio_wait);
-		queue_work(ic->metadata_wq, &dio->work);
+		queue_work(ic->offload_wq, &dio->work);
 		return;
 	}
 
@@ -2501,7 +2502,7 @@ static void bitmap_block_work(struct work_struct *w)
 				    dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
 			remove_range(ic, &dio->range);
 			INIT_WORK(&dio->work, integrity_bio_wait);
-			queue_work(ic->wait_wq, &dio->work);
+			queue_work(ic->offload_wq, &dio->work);
 		} else {
 			block_bitmap_op(ic, ic->journal, dio->range.logical_sector,
 					dio->range.n_sectors, BITMAP_OP_SET);
@@ -2524,7 +2525,7 @@ static void bitmap_block_work(struct work_struct *w)
 
 		remove_range(ic, &dio->range);
 		INIT_WORK(&dio->work, integrity_bio_wait);
-		queue_work(ic->wait_wq, &dio->work);
+		queue_work(ic->offload_wq, &dio->work);
 	}
 
 	queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, ic->bitmap_flush_interval);
@@ -3843,6 +3844,14 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	ic->offload_wq = alloc_workqueue("dm-integrity-offload", WQ_MEM_RECLAIM,
+					  METADATA_WORKQUEUE_MAX_ACTIVE);
+	if (!ic->offload_wq) {
+		ti->error = "Cannot allocate workqueue";
+		r = -ENOMEM;
+		goto bad;
+	}
+
 	ic->commit_wq = alloc_workqueue("dm-integrity-commit", WQ_MEM_RECLAIM, 1);
 	if (!ic->commit_wq) {
 		ti->error = "Cannot allocate workqueue";
@@ -4147,6 +4156,8 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)
 		destroy_workqueue(ic->wait_wq);
+	if (ic->offload_wq)
+		destroy_workqueue(ic->offload_wq);
 	if (ic->commit_wq)
 		destroy_workqueue(ic->commit_wq);
 	if (ic->writer_wq)

