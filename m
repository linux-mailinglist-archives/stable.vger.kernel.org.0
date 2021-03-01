Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA35328607
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhCARCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhCAQz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2BBC64F64;
        Mon,  1 Mar 2021 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616542;
        bh=6zyezWTTjuoD2AKf98TGmXgyShjSqOTOrLzonJpdurA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=id0oUmfNikPJVHbb9GP3gd4MGRMexqpCrjwkYDY7gkm8qM6e+mh66mwDOEnadC0dy
         vWQSoLAT2TMX5BFVgaec6YRwWe1wYOAdmroKqPIpMr+9Z2LNbu94cBoNUQvazdDH4F
         KObx2w6yrPW3+wn6UXG+BCpq5nGESx3SkSaC934A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 011/247] block: dont release queues sysfs lock during switching elevator
Date:   Mon,  1 Mar 2021 17:10:31 +0100
Message-Id: <20210301161032.233407922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit b89f625e28d44552083f43752f62d8621ded0a04 upstream.

cecf5d87ff20 ("block: split .sysfs_lock into two locks") starts to
release & acquire sysfs_lock before registering/un-registering elevator
queue during switching elevator for avoiding potential deadlock from
showing & storing 'queue/iosched' attributes and removing elevator's
kobject.

Turns out there isn't such deadlock because 'q->sysfs_lock' isn't
required in .show & .store of queue/iosched's attributes, and just
elevator's sysfs lock is acquired in elv_iosched_store() and
elv_iosched_show(). So it is safe to hold queue's sysfs lock when
registering/un-registering elevator queue.

The biggest issue is that commit cecf5d87ff20 assumes that concurrent
write on 'queue/scheduler' can't happen. However, this assumption isn't
true, because kernfs_fop_write() only guarantees that concurrent write
aren't called on the same open file, but the write could be from
different open on the file. So we can't release & re-acquire queue's
sysfs lock during switching elevator, otherwise use-after-free on
elevator could be triggered.

Fixes the issue by not releasing queue's sysfs lock during switching
elevator.

Fixes: cecf5d87ff20 ("block: split .sysfs_lock into two locks")
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(jwang: adjust ctx for 4.19)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-sysfs.c |    3 ++-
 block/elevator.c  |   31 +------------------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -933,6 +933,7 @@ int blk_register_queue(struct gendisk *d
 		blk_mq_debugfs_register(q);
 	}
 
+	mutex_lock(&q->sysfs_lock);
 	/*
 	 * The flag of QUEUE_FLAG_REGISTERED isn't set yet, so elevator
 	 * switch won't happen at all.
@@ -940,6 +941,7 @@ int blk_register_queue(struct gendisk *d
 	if (q->request_fn || (q->mq_ops && q->elevator)) {
 		ret = elv_register_queue(q, false);
 		if (ret) {
+			mutex_unlock(&q->sysfs_lock);
 			mutex_unlock(&q->sysfs_dir_lock);
 			kobject_del(&q->kobj);
 			blk_trace_remove_sysfs(dev);
@@ -949,7 +951,6 @@ int blk_register_queue(struct gendisk *d
 		has_elevator = true;
 	}
 
-	mutex_lock(&q->sysfs_lock);
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
 	wbt_enable_default(q);
 	blk_throtl_register_queue(q);
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -856,11 +856,9 @@ int elv_register_queue(struct request_qu
 		if (uevent)
 			kobject_uevent(&e->kobj, KOBJ_ADD);
 
-		mutex_lock(&q->sysfs_lock);
 		e->registered = 1;
 		if (!e->uses_mq && e->type->ops.sq.elevator_registered_fn)
 			e->type->ops.sq.elevator_registered_fn(q);
-		mutex_unlock(&q->sysfs_lock);
 	}
 	return error;
 }
@@ -878,11 +876,9 @@ void elv_unregister_queue(struct request
 		kobject_uevent(&e->kobj, KOBJ_REMOVE);
 		kobject_del(&e->kobj);
 
-		mutex_lock(&q->sysfs_lock);
 		e->registered = 0;
 		/* Re-enable throttling in case elevator disabled it */
 		wbt_enable_default(q);
-		mutex_unlock(&q->sysfs_lock);
 	}
 }
 
@@ -953,32 +949,11 @@ int elevator_switch_mq(struct request_qu
 	lockdep_assert_held(&q->sysfs_lock);
 
 	if (q->elevator) {
-		if (q->elevator->registered) {
-			mutex_unlock(&q->sysfs_lock);
-
-			/*
-			 * Concurrent elevator switch can't happen becasue
-			 * sysfs write is always exclusively on same file.
-			 *
-			 * Also the elevator queue won't be freed after
-			 * sysfs_lock is released becasue kobject_del() in
-			 * blk_unregister_queue() waits for completion of
-			 * .store & .show on its attributes.
-			 */
+		if (q->elevator->registered)
 			elv_unregister_queue(q);
 
-			mutex_lock(&q->sysfs_lock);
-		}
 		ioc_clear_queue(q);
 		elevator_exit(q, q->elevator);
-
-		/*
-		 * sysfs_lock may be dropped, so re-check if queue is
-		 * unregistered. If yes, don't switch to new elevator
-		 * any more
-		 */
-		if (!blk_queue_registered(q))
-			return 0;
 	}
 
 	ret = blk_mq_init_sched(q, new_e);
@@ -986,11 +961,7 @@ int elevator_switch_mq(struct request_qu
 		goto out;
 
 	if (new_e) {
-		mutex_unlock(&q->sysfs_lock);
-
 		ret = elv_register_queue(q, true);
-
-		mutex_lock(&q->sysfs_lock);
 		if (ret) {
 			elevator_exit(q, q->elevator);
 			goto out;


