Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605CC17F8F1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgCJMwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgCJMwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B240C2253D;
        Tue, 10 Mar 2020 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844754;
        bh=XPExVX+NeIUl2R55apBwnico2ulYceEzp7TEklADt1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fv1PY7iyjrwxyAX7HprZg63tEZQobKFL8mLKRMKHRLN8hFHM7TIv3LBc+XWvzMtUk
         wyrMPKiUY25yB+mOmPVIbvnWOvOI34WD9gkJtIS/uTf+8+kU7cudyswEjJ1uI7gnS9
         Gy8+jhuHGODN+JeC7QYTCV7CfdNoQHkb/fVgDYNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 105/168] dm integrity: fix a deadlock due to offloading to an incorrect workqueue
Date:   Tue, 10 Mar 2020 13:39:11 +0100
Message-Id: <20200310123646.003565626@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 53770f0ec5fd417429775ba006bc4abe14002335 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -210,6 +210,7 @@ struct dm_integrity_c {
 	struct list_head wait_list;
 	wait_queue_head_t endio_wait;
 	struct workqueue_struct *wait_wq;
+	struct workqueue_struct *offload_wq;
 
 	unsigned char commit_seq;
 	commit_id_t commit_ids[N_COMMIT_IDS];
@@ -1434,7 +1435,7 @@ static void dec_in_flight(struct dm_inte
 			dio->range.logical_sector += dio->range.n_sectors;
 			bio_advance(bio, dio->range.n_sectors << SECTOR_SHIFT);
 			INIT_WORK(&dio->work, integrity_bio_wait);
-			queue_work(ic->wait_wq, &dio->work);
+			queue_work(ic->offload_wq, &dio->work);
 			return;
 		}
 		do_endio_flush(ic, dio);
@@ -1860,7 +1861,7 @@ static void dm_integrity_map_continue(st
 
 	if (need_sync_io && from_map) {
 		INIT_WORK(&dio->work, integrity_bio_wait);
-		queue_work(ic->metadata_wq, &dio->work);
+		queue_work(ic->offload_wq, &dio->work);
 		return;
 	}
 
@@ -2496,7 +2497,7 @@ static void bitmap_block_work(struct wor
 				    dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
 			remove_range(ic, &dio->range);
 			INIT_WORK(&dio->work, integrity_bio_wait);
-			queue_work(ic->wait_wq, &dio->work);
+			queue_work(ic->offload_wq, &dio->work);
 		} else {
 			block_bitmap_op(ic, ic->journal, dio->range.logical_sector,
 					dio->range.n_sectors, BITMAP_OP_SET);
@@ -2519,7 +2520,7 @@ static void bitmap_block_work(struct wor
 
 		remove_range(ic, &dio->range);
 		INIT_WORK(&dio->work, integrity_bio_wait);
-		queue_work(ic->wait_wq, &dio->work);
+		queue_work(ic->offload_wq, &dio->work);
 	}
 
 	queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, ic->bitmap_flush_interval);
@@ -3825,6 +3826,14 @@ static int dm_integrity_ctr(struct dm_ta
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
@@ -4129,6 +4138,8 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)
 		destroy_workqueue(ic->wait_wq);
+	if (ic->offload_wq)
+		destroy_workqueue(ic->offload_wq);
 	if (ic->commit_wq)
 		destroy_workqueue(ic->commit_wq);
 	if (ic->writer_wq)


