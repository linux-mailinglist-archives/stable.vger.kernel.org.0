Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D244130DB00
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhBCNVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhBCNVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:47 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF45C06178C
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:31 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q7so24229029wre.13
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Q85vcvTRwqOQln7ONod8UaPXYEVKrd8O7nB76luOHM=;
        b=VSq/Tq18U/g3RagnsHbxoGrjQ8RXYNWfZd088OHvmvNTjj0C1OQzv2cg/hVjaMZhgI
         kzmPE3oYHs4sCpo8uXlqnO/+jtSFWZH7NVXZ7TaKuZa07s64d5dQ1akwp/eWK/RvVADk
         VVMuO+Ck8G9o0CjYv4hTsBvIQoxhVXI92NajpyqmPSlKg4cCyY/pOqXSIYLFxve1S5to
         +0vHk5YTf2YML+u+pFYYIeQGTW53bi4HD1cJRzYD3JoAH2Hj5Pb3OoJznSSjab1w7KNZ
         1NZN2ilKxixJieb0ohM3Er5vy7HtD0MmnuHVrdDBHFz2xNZwEVOSNRJdsgQWv0b42xi4
         YHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Q85vcvTRwqOQln7ONod8UaPXYEVKrd8O7nB76luOHM=;
        b=dRisQ7+EaX1TTs/u2J7frl4029eMS7FlHWZ09BRhc25eEI6uN/U1lHtGaUCiTIYAnb
         vyZlu57inb46H34oPl6jRaYF4vJfdzqgkU5PP1w/eN0GH+ZAsrrDL9RH5/yk2vaNquaP
         wS2ghx96BhIARaj7gyt28iTSftZYe6n6NlngojvYbypEFtuhepPr5SV7x95R0yuAAPno
         PPXmjhIbRC/PbajiaEQc1A5izW1jRFnm6v6kA6l3XJUtkmm5wVdNCtzLPvHanyZ07hc6
         KBewUosmSjWtgshtEsevSgu2goTBq/FSCIAPaKVbPjQxBRN9j8zcb+xdP3Dh0FPc7tjV
         Gkfg==
X-Gm-Message-State: AOAM532LMg/PpVY8HFr7MH23YZJ4fCjByY5HAokaotT34c/b6NrwTNEA
        xxz6W1vffp2e/EW25NK+vQOgQqMe7DpapA==
X-Google-Smtp-Source: ABdhPJzalN3t5nMp4frtKnib2fiQWkX/JacxAxKNJO/UWKT+gUZWvw+by6KGDUFpR8xfpLgP7XEJeA==
X-Received: by 2002:a5d:4046:: with SMTP id w6mr3425430wrp.369.1612358430535;
        Wed, 03 Feb 2021 05:20:30 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:30 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 7/8] block: don't release queue's sysfs lock during switching elevator
Date:   Wed,  3 Feb 2021 14:20:21 +0100
Message-Id: <20210203132022.92406-8-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
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

