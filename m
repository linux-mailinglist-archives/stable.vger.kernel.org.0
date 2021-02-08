Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245E2313672
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhBHPLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhBHPGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:06:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02B3C0617A9
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id df22so18529713edb.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Q85vcvTRwqOQln7ONod8UaPXYEVKrd8O7nB76luOHM=;
        b=fJnjrshE9XOztNM7o5MKTyN34XuNo2MVg9amiPnz60l10Pis9nb1AZqsELg8T72LjA
         2/xNl9fYpZa5UKHXCdR5SfET58rtBUh0TAbutqsulVg7ghQ98XxnfFWIXCTo6gx41Hpl
         G1d5ggeF4zmkzYm2Z6sQ1w4IhCdR/L5fzdRrh30oHFh9wdfncklQihbwH73/KSta/99T
         MOOTPOv8iLAjJJYt4yvZfUt7FSDOC348+RB3REcUobrXdDypMl4xcYicWtjI4YssmQdE
         Z9Ub5GRXEnUiu35d61y2u3WzG8BSOwK1GEdpfjzH2tLvVVXyJHbT8el9dtIurFjfn0tn
         q6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Q85vcvTRwqOQln7ONod8UaPXYEVKrd8O7nB76luOHM=;
        b=Zu4unOmN8a291ZOdSByDcnIwd0yxAEP/UMUQuno/VLNh2rujzeH+fhGw1BorFdwEuf
         DrV1ZZvL4uP3M7UT4zocKo/tdHcH0jGOSSB1bY0uGjNYFSLKRsxbDsd3KeUPbg1+EGl2
         gjag7okKgbCjY51Up4GIHtP8R9iJjWwXltc0X1IRKeKDa6ftxBFSVCIXX0AbdUzjZtrg
         Z7L/GSBkVaU0h7ROj4NRJqDWjHPO29kI6ALRt71TY1jn2wJDcffs5VLsl9MQFRrZ/vaJ
         6134xQpBelWdHLvu5ryCKV4fmgw7UOdBQ1b66CKStBVEhl7kMoYdWT9a2255jKvpqMMe
         /W7w==
X-Gm-Message-State: AOAM531WwYUdvxavQKh04UXIx0hGZEmKMV06RmqIoG/HoHIDZUCZ2PrU
        XvcbIofZkz+RGe6M0bqmyHr9DA==
X-Google-Smtp-Source: ABdhPJyutxBZatPDwyoL9fU6mFQTvRlpS2QgLdffNFRcXx7U6CX+THfaQG4e3ndPsohc/+uTVI5jUQ==
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr17469805edd.52.1612796674336;
        Mon, 08 Feb 2021 07:04:34 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:34 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [stable-4.19 Resend 7/7] block: don't release queue's sysfs lock during switching elevator
Date:   Mon,  8 Feb 2021 16:04:26 +0100
Message-Id: <20210208150426.62755-8-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

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
(jwang:cherry picked from commit b89f625e28d44552083f43752f62d8621ded0a04
adjust ctx for 4.19)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-sysfs.c |  3 ++-
 block/elevator.c  | 31 +------------------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 899987152701..07494deb1a26 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -933,6 +933,7 @@ int blk_register_queue(struct gendisk *disk)
 		blk_mq_debugfs_register(q);
 	}
 
+	mutex_lock(&q->sysfs_lock);
 	/*
 	 * The flag of QUEUE_FLAG_REGISTERED isn't set yet, so elevator
 	 * switch won't happen at all.
@@ -940,6 +941,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (q->request_fn || (q->mq_ops && q->elevator)) {
 		ret = elv_register_queue(q, false);
 		if (ret) {
+			mutex_unlock(&q->sysfs_lock);
 			mutex_unlock(&q->sysfs_dir_lock);
 			kobject_del(&q->kobj);
 			blk_trace_remove_sysfs(dev);
@@ -949,7 +951,6 @@ int blk_register_queue(struct gendisk *disk)
 		has_elevator = true;
 	}
 
-	mutex_lock(&q->sysfs_lock);
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
 	wbt_enable_default(q);
 	blk_throtl_register_queue(q);
diff --git a/block/elevator.c b/block/elevator.c
index 2ff0859e8b35..5b51bc5fad9f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -856,11 +856,9 @@ int elv_register_queue(struct request_queue *q, bool uevent)
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
@@ -878,11 +876,9 @@ void elv_unregister_queue(struct request_queue *q)
 		kobject_uevent(&e->kobj, KOBJ_REMOVE);
 		kobject_del(&e->kobj);
 
-		mutex_lock(&q->sysfs_lock);
 		e->registered = 0;
 		/* Re-enable throttling in case elevator disabled it */
 		wbt_enable_default(q);
-		mutex_unlock(&q->sysfs_lock);
 	}
 }
 
@@ -953,32 +949,11 @@ int elevator_switch_mq(struct request_queue *q,
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
@@ -986,11 +961,7 @@ int elevator_switch_mq(struct request_queue *q,
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
-- 
2.25.1

