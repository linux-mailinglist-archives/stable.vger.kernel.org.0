Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62417F288
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 10:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCJJAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 05:00:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41943 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726389AbgCJJAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 05:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583830822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zPTXuWTXDqyEyqntnOU/PYG5iPPZAjdVv5eLDr2YQTI=;
        b=ZUQsc4Qsp70A5sgVH2ipSag3LMqb7yRqyXPHmsa6KVG3HiRqt6SQnnuHJw90r8mrC8q+8J
        vh1FDRz+3JWQwSBZWliVztWz8bFkRI3KtxuChM5MtbKIs9n4BIR72dyhDxUmD0BFoLbqho
        gVMaIk7riCYkgyUEAiwCmQ5TjkYwaN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-RpVWDuh4Ot6oBqezm4Q8vQ-1; Tue, 10 Mar 2020 05:00:20 -0400
X-MC-Unique: RpVWDuh4Ot6oBqezm4Q8vQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC0CADBA3;
        Tue, 10 Mar 2020 09:00:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 460015D9C5;
        Tue, 10 Mar 2020 09:00:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 02A90GWk008147;
        Tue, 10 Mar 2020 05:00:16 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 02A90GE9008143;
        Tue, 10 Mar 2020 05:00:16 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 10 Mar 2020 05:00:16 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     heinzm@redhat.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: [PATCH v4.14 v4.19] dm integrity: fix a deadlock due to offloading
 to an incorrect workqueue
In-Reply-To: <158378432418151@kroah.com>
Message-ID: <alpine.LRH.2.02.2003100457020.7499@file01.intranet.prod.int.rdu2.redhat.com>
References: <158378432418151@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 9 Mar 2020, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

Here I'm sending the patch for the stable branches 4.14 and 4.19.

Mikulas


------------------ original commit in Linus's tree ------------------

>From 53770f0ec5fd417429775ba006bc4abe14002335 Mon Sep 17 00:00:00 2001
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

---
 drivers/md/dm-integrity.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-stable/drivers/md/dm-integrity.c
===================================================================
--- linux-stable.orig/drivers/md/dm-integrity.c	2020-03-10 09:53:57.000000000 +0100
+++ linux-stable/drivers/md/dm-integrity.c	2020-03-10 09:53:57.000000000 +0100
@@ -197,6 +197,7 @@ struct dm_integrity_c {
 	struct list_head wait_list;
 	wait_queue_head_t endio_wait;
 	struct workqueue_struct *wait_wq;
+	struct workqueue_struct *offload_wq;
 
 	unsigned char commit_seq;
 	commit_id_t commit_ids[N_COMMIT_IDS];
@@ -1236,7 +1237,7 @@ static void dec_in_flight(struct dm_inte
 			dio->range.logical_sector += dio->range.n_sectors;
 			bio_advance(bio, dio->range.n_sectors << SECTOR_SHIFT);
 			INIT_WORK(&dio->work, integrity_bio_wait);
-			queue_work(ic->wait_wq, &dio->work);
+			queue_work(ic->offload_wq, &dio->work);
 			return;
 		}
 		do_endio_flush(ic, dio);
@@ -1656,7 +1657,7 @@ static void dm_integrity_map_continue(st
 
 	if (need_sync_io && from_map) {
 		INIT_WORK(&dio->work, integrity_bio_wait);
-		queue_work(ic->metadata_wq, &dio->work);
+		queue_work(ic->offload_wq, &dio->work);
 		return;
 	}
 
@@ -3310,6 +3311,14 @@ static int dm_integrity_ctr(struct dm_ta
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
@@ -3546,6 +3555,8 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)
 		destroy_workqueue(ic->wait_wq);
+	if (ic->offload_wq)
+		destroy_workqueue(ic->offload_wq);
 	if (ic->commit_wq)
 		destroy_workqueue(ic->commit_wq);
 	if (ic->writer_wq)

