Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E13030DAFE
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhBCNVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBCNVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:46 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46B6C06178A
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:29 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m1so5210376wml.2
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=btoceab6WAOABNrL1783NZ55mEzW4Zi4OKe5C+Dv/o0=;
        b=ZD+O/Kr25sNbmDLwe+A6aC9qIDBFhASh7W17pI+dCoLs8tD2qdIEwVO9Y3kHBSCTHS
         vajQyxJ7+bbdgQI9bBRjDyKlM2J0jYq9Kglt5sd9aSCYoyaMUxSW1aephs+Ww/vl9Ovi
         oghu798TMb6YdS0IDGsJpFl84z1WXhgWz9sJDbESdN3W1FRYbEzti/wGrswBxt/AZ4SN
         P8KdtX/MtfD3dOrujqxCIQO6HBLo8PUjYi+ivdOJ7QURB8UYp6U51Ljq+N+ZOKBJSh3K
         ejdd1jVLmuZkEO2H/ORdnCJml/13YxbthCD8jdzz8uhow0FYgw8yqhDi1I542/VEMMUV
         qNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btoceab6WAOABNrL1783NZ55mEzW4Zi4OKe5C+Dv/o0=;
        b=GEl12BTq8WpyyZwFoHXMe3Qrm5lAYJyTM3GqpO/bNVC1gS2H3NxAcakYUsl8ZMEiur
         AOP3tN0jz3S4yVJFIIi/TgSwtLAnYTeOXqzxpy98gWHVs9LZQNV/twwDrIwuvRIQqWZr
         NlhazZg+UBBtJXUuT0v3eh4LyudYuNfUKFUme9lnQkvsyI/qnUPi/14GId0wrKVn5Gux
         h4MXBV2bqI2Shx0OaXv7J8HBgkPfcQSvVnnOo3lBw5Bkagjo3+EfCNAJzjzn1NoMyCYp
         M+9bZMYuK0eY9n08Yc2py2z+OZK4EhcpXiE9ATJw5tnXc0WNtL8LvcdKsBjWQvJMhjSV
         uOCQ==
X-Gm-Message-State: AOAM533QoOzkRFQP7JVrQqFPpWu27wl5Bx7qSVX7RZD55YwhcInEJeBl
        O4hQT3iSU8ilp6BRn/+SblykyQ==
X-Google-Smtp-Source: ABdhPJw8fKrR2EHttWaHVKOwx9L1BN0cvoi6CEvWWcjvAKbBdZkx3cXkar3N8omfaEefvwaWpFAtOA==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr2877635wmj.61.1612358428462;
        Wed, 03 Feb 2021 05:20:28 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:28 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 5/8] block: split .sysfs_lock into two locks
Date:   Wed,  3 Feb 2021 14:20:19 +0100
Message-Id: <20210203132022.92406-6-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

The kernfs built-in lock of 'kn->count' is held in sysfs .show/.store
path. Meantime, inside block's .show/.store callback, q->sysfs_lock is
required.

However, when mq & iosched kobjects are removed via
blk_mq_unregister_dev() & elv_unregister_queue(), q->sysfs_lock is held
too. This way causes AB-BA lock because the kernfs built-in lock of
'kn-count' is required inside kobject_del() too, see the lockdep warning[1].

On the other hand, it isn't necessary to acquire q->sysfs_lock for
both blk_mq_unregister_dev() & elv_unregister_queue() because
clearing REGISTERED flag prevents storing to 'queue/scheduler'
from being happened. Also sysfs write(store) is exclusive, so no
necessary to hold the lock for elv_unregister_queue() when it is
called in switching elevator path.

So split .sysfs_lock into two: one is still named as .sysfs_lock for
covering sync .store, the other one is named as .sysfs_dir_lock
for covering kobjects and related status change.

sysfs itself can handle the race between add/remove kobjects and
showing/storing attributes under kobjects. For switching scheduler
via storing to 'queue/scheduler', we use the queue flag of
QUEUE_FLAG_REGISTERED with .sysfs_lock for avoiding the race, then
we can avoid to hold .sysfs_lock during removing/adding kobjects.

[1]  lockdep warning
    ======================================================
    WARNING: possible circular locking dependency detected
    5.3.0-rc3-00044-g73277fc75ea0 #1380 Not tainted
    ------------------------------------------------------
    rmmod/777 is trying to acquire lock:
    00000000ac50e981 (kn->count#202){++++}, at: kernfs_remove_by_name_ns+0x59/0x72

    but task is already holding lock:
    00000000fb16ae21 (&q->sysfs_lock){+.+.}, at: blk_unregister_queue+0x78/0x10b

    which lock already depends on the new lock.

    the existing dependency chain (in reverse order) is:

    -> #1 (&q->sysfs_lock){+.+.}:
           __lock_acquire+0x95f/0xa2f
           lock_acquire+0x1b4/0x1e8
           __mutex_lock+0x14a/0xa9b
           blk_mq_hw_sysfs_show+0x63/0xb6
           sysfs_kf_seq_show+0x11f/0x196
           seq_read+0x2cd/0x5f2
           vfs_read+0xc7/0x18c
           ksys_read+0xc4/0x13e
           do_syscall_64+0xa7/0x295
           entry_SYSCALL_64_after_hwframe+0x49/0xbe

    -> #0 (kn->count#202){++++}:
           check_prev_add+0x5d2/0xc45
           validate_chain+0xed3/0xf94
           __lock_acquire+0x95f/0xa2f
           lock_acquire+0x1b4/0x1e8
           __kernfs_remove+0x237/0x40b
           kernfs_remove_by_name_ns+0x59/0x72
           remove_files+0x61/0x96
           sysfs_remove_group+0x81/0xa4
           sysfs_remove_groups+0x3b/0x44
           kobject_del+0x44/0x94
           blk_mq_unregister_dev+0x83/0xdd
           blk_unregister_queue+0xa0/0x10b
           del_gendisk+0x259/0x3fa
           null_del_dev+0x8b/0x1c3 [null_blk]
           null_exit+0x5c/0x95 [null_blk]
           __se_sys_delete_module+0x204/0x337
           do_syscall_64+0xa7/0x295
           entry_SYSCALL_64_after_hwframe+0x49/0xbe

    other info that might help us debug this:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(&q->sysfs_lock);
                                   lock(kn->count#202);
                                   lock(&q->sysfs_lock);
      lock(kn->count#202);

     *** DEADLOCK ***

    2 locks held by rmmod/777:
     #0: 00000000e69bd9de (&lock){+.+.}, at: null_exit+0x2e/0x95 [null_blk]
     #1: 00000000fb16ae21 (&q->sysfs_lock){+.+.}, at: blk_unregister_queue+0x78/0x10b

    stack backtrace:
    CPU: 0 PID: 777 Comm: rmmod Not tainted 5.3.0-rc3-00044-g73277fc75ea0 #1380
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ?-20180724_192412-buildhw-07.phx4
    Call Trace:
     dump_stack+0x9a/0xe6
     check_noncircular+0x207/0x251
     ? print_circular_bug+0x32a/0x32a
     ? find_usage_backwards+0x84/0xb0
     check_prev_add+0x5d2/0xc45
     validate_chain+0xed3/0xf94
     ? check_prev_add+0xc45/0xc45
     ? mark_lock+0x11b/0x804
     ? check_usage_forwards+0x1ca/0x1ca
     __lock_acquire+0x95f/0xa2f
     lock_acquire+0x1b4/0x1e8
     ? kernfs_remove_by_name_ns+0x59/0x72
     __kernfs_remove+0x237/0x40b
     ? kernfs_remove_by_name_ns+0x59/0x72
     ? kernfs_next_descendant_post+0x7d/0x7d
     ? strlen+0x10/0x23
     ? strcmp+0x22/0x44
     kernfs_remove_by_name_ns+0x59/0x72
     remove_files+0x61/0x96
     sysfs_remove_group+0x81/0xa4
     sysfs_remove_groups+0x3b/0x44
     kobject_del+0x44/0x94
     blk_mq_unregister_dev+0x83/0xdd
     blk_unregister_queue+0xa0/0x10b
     del_gendisk+0x259/0x3fa
     ? disk_events_poll_msecs_store+0x12b/0x12b
     ? check_flags+0x1ea/0x204
     ? mark_held_locks+0x1f/0x7a
     null_del_dev+0x8b/0x1c3 [null_blk]
     null_exit+0x5c/0x95 [null_blk]
     __se_sys_delete_module+0x204/0x337
     ? free_module+0x39f/0x39f
     ? blkcg_maybe_throttle_current+0x8a/0x718
     ? rwlock_bug+0x62/0x62
     ? __blkcg_punt_bio_submit+0xd0/0xd0
     ? trace_hardirqs_on_thunk+0x1a/0x20
     ? mark_held_locks+0x1f/0x7a
     ? do_syscall_64+0x4c/0x295
     do_syscall_64+0xa7/0x295
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7fb696cdbe6b
    Code: 73 01 c3 48 8b 0d 1d 20 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 008
    RSP: 002b:00007ffec9588788 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
    RAX: ffffffffffffffda RBX: 0000559e589137c0 RCX: 00007fb696cdbe6b
    RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000559e58913828
    RBP: 0000000000000000 R08: 00007ffec9587701 R09: 0000000000000000
    R10: 00007fb696d4eae0 R11: 0000000000000206 R12: 00007ffec95889b0
    R13: 00007ffec95896b3 R14: 0000559e58913260 R15: 0000559e589137c0

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(jwang:cherry picked from commit cecf5d87ff2035127bb5a9ee054d0023a4a7cad3,
adjust ctx for 4,19)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-core.c       |  1 +
 block/blk-mq-sysfs.c   | 12 ++++-----
 block/blk-sysfs.c      | 44 +++++++++++++++++++------------
 block/blk.h            |  2 +-
 block/elevator.c       | 59 +++++++++++++++++++++++++++++++++++-------
 include/linux/blkdev.h |  1 +
 6 files changed, 86 insertions(+), 33 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ce3710404544..80f3e729fdd4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1059,6 +1059,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 	mutex_init(&q->blk_trace_mutex);
 #endif
 	mutex_init(&q->sysfs_lock);
+	mutex_init(&q->sysfs_dir_lock);
 	spin_lock_init(&q->__queue_lock);
 
 	if (!q->mq_ops)
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 5006a0d00990..5e4b7ed1e897 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -264,7 +264,7 @@ void blk_mq_unregister_dev(struct device *dev, struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	lockdep_assert_held(&q->sysfs_lock);
+	lockdep_assert_held(&q->sysfs_dir_lock);
 
 	queue_for_each_hw_ctx(q, hctx, i)
 		blk_mq_unregister_hctx(hctx);
@@ -312,7 +312,7 @@ int __blk_mq_register_dev(struct device *dev, struct request_queue *q)
 	int ret, i;
 
 	WARN_ON_ONCE(!q->kobj.parent);
-	lockdep_assert_held(&q->sysfs_lock);
+	lockdep_assert_held(&q->sysfs_dir_lock);
 
 	ret = kobject_add(&q->mq_kobj, kobject_get(&dev->kobj), "%s", "mq");
 	if (ret < 0)
@@ -358,7 +358,7 @@ void blk_mq_sysfs_unregister(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	mutex_lock(&q->sysfs_lock);
+	mutex_lock(&q->sysfs_dir_lock);
 	if (!q->mq_sysfs_init_done)
 		goto unlock;
 
@@ -366,7 +366,7 @@ void blk_mq_sysfs_unregister(struct request_queue *q)
 		blk_mq_unregister_hctx(hctx);
 
 unlock:
-	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
 }
 
 int blk_mq_sysfs_register(struct request_queue *q)
@@ -374,7 +374,7 @@ int blk_mq_sysfs_register(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i, ret = 0;
 
-	mutex_lock(&q->sysfs_lock);
+	mutex_lock(&q->sysfs_dir_lock);
 	if (!q->mq_sysfs_init_done)
 		goto unlock;
 
@@ -385,7 +385,7 @@ int blk_mq_sysfs_register(struct request_queue *q)
 	}
 
 unlock:
-	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
 
 	return ret;
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0a7636d24563..b2208b69f04a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -892,6 +892,7 @@ int blk_register_queue(struct gendisk *disk)
 	int ret;
 	struct device *dev = disk_to_dev(disk);
 	struct request_queue *q = disk->queue;
+	bool has_elevator = false;
 
 	if (WARN_ON(!q))
 		return -ENXIO;
@@ -899,7 +900,6 @@ int blk_register_queue(struct gendisk *disk)
 	WARN_ONCE(blk_queue_registered(q),
 		  "%s is registering an already registered queue\n",
 		  kobject_name(&dev->kobj));
-	queue_flag_set_unlocked(QUEUE_FLAG_REGISTERED, q);
 
 	/*
 	 * SCSI probing may synchronously create and destroy a lot of
@@ -920,8 +920,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (ret)
 		return ret;
 
-	/* Prevent changes through sysfs until registration is completed. */
-	mutex_lock(&q->sysfs_lock);
+	mutex_lock(&q->sysfs_dir_lock);
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
 	if (ret < 0) {
@@ -934,26 +933,36 @@ int blk_register_queue(struct gendisk *disk)
 		blk_mq_debugfs_register(q);
 	}
 
-	kobject_uevent(&q->kobj, KOBJ_ADD);
-
-	wbt_enable_default(q);
-
-	blk_throtl_register_queue(q);
-
+	/*
+	 * The flag of QUEUE_FLAG_REGISTERED isn't set yet, so elevator
+	 * switch won't happen at all.
+	 */
 	if (q->request_fn || (q->mq_ops && q->elevator)) {
-		ret = elv_register_queue(q);
+		ret = elv_register_queue(q, false);
 		if (ret) {
-			mutex_unlock(&q->sysfs_lock);
-			kobject_uevent(&q->kobj, KOBJ_REMOVE);
+			mutex_unlock(&q->sysfs_dir_lock);
 			kobject_del(&q->kobj);
 			blk_trace_remove_sysfs(dev);
 			kobject_put(&dev->kobj);
 			return ret;
 		}
+		has_elevator = true;
 	}
+
+	mutex_lock(&q->sysfs_lock);
+	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
+	wbt_enable_default(q);
+	blk_throtl_register_queue(q);
+
+	/* Now everything is ready and send out KOBJ_ADD uevent */
+	kobject_uevent(&q->kobj, KOBJ_ADD);
+	if (has_elevator)
+		kobject_uevent(&q->elevator->kobj, KOBJ_ADD);
+	mutex_unlock(&q->sysfs_lock);
+
 	ret = 0;
 unlock:
-	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_register_queue);
@@ -968,6 +977,7 @@ EXPORT_SYMBOL_GPL(blk_register_queue);
 void blk_unregister_queue(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
+	bool has_elevator;
 
 	if (WARN_ON(!q))
 		return;
@@ -982,25 +992,27 @@ void blk_unregister_queue(struct gendisk *disk)
 	 * concurrent elv_iosched_store() calls.
 	 */
 	mutex_lock(&q->sysfs_lock);
-
 	blk_queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
+	has_elevator = !!q->elevator;
+	mutex_unlock(&q->sysfs_lock);
 
+	mutex_lock(&q->sysfs_dir_lock);
 	/*
 	 * Remove the sysfs attributes before unregistering the queue data
 	 * structures that can be modified through sysfs.
 	 */
 	if (q->mq_ops)
 		blk_mq_unregister_dev(disk_to_dev(disk), q);
-	mutex_unlock(&q->sysfs_lock);
 
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
 	mutex_lock(&q->sysfs_lock);
-	if (q->request_fn || (q->mq_ops && q->elevator))
+	if (q->request_fn || has_elevator)
 		elv_unregister_queue(q);
 	mutex_unlock(&q->sysfs_lock);
+	mutex_unlock(&q->sysfs_dir_lock);
 
 	kobject_put(&disk_to_dev(disk)->kobj);
 }
diff --git a/block/blk.h b/block/blk.h
index 1a5b67b57e6b..ae87e2a5f2bd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -244,7 +244,7 @@ int elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
 void elevator_exit(struct request_queue *, struct elevator_queue *);
-int elv_register_queue(struct request_queue *q);
+int elv_register_queue(struct request_queue *q, bool uevent);
 void elv_unregister_queue(struct request_queue *q);
 
 struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
diff --git a/block/elevator.c b/block/elevator.c
index 9bffe4558929..2ff0859e8b35 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -833,13 +833,16 @@ static struct kobj_type elv_ktype = {
 	.release	= elevator_release,
 };
 
-int elv_register_queue(struct request_queue *q)
+/*
+ * elv_register_queue is called from either blk_register_queue or
+ * elevator_switch, elevator switch is prevented from being happen
+ * in the two paths, so it is safe to not hold q->sysfs_lock.
+ */
+int elv_register_queue(struct request_queue *q, bool uevent)
 {
 	struct elevator_queue *e = q->elevator;
 	int error;
 
-	lockdep_assert_held(&q->sysfs_lock);
-
 	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
 	if (!error) {
 		struct elv_fs_entry *attr = e->type->elevator_attrs;
@@ -850,26 +853,36 @@ int elv_register_queue(struct request_queue *q)
 				attr++;
 			}
 		}
-		kobject_uevent(&e->kobj, KOBJ_ADD);
+		if (uevent)
+			kobject_uevent(&e->kobj, KOBJ_ADD);
+
+		mutex_lock(&q->sysfs_lock);
 		e->registered = 1;
 		if (!e->uses_mq && e->type->ops.sq.elevator_registered_fn)
 			e->type->ops.sq.elevator_registered_fn(q);
+		mutex_unlock(&q->sysfs_lock);
 	}
 	return error;
 }
 
+/*
+ * elv_unregister_queue is called from either blk_unregister_queue or
+ * elevator_switch, elevator switch is prevented from being happen
+ * in the two paths, so it is safe to not hold q->sysfs_lock.
+ */
 void elv_unregister_queue(struct request_queue *q)
 {
-	lockdep_assert_held(&q->sysfs_lock);
-
 	if (q) {
 		struct elevator_queue *e = q->elevator;
 
 		kobject_uevent(&e->kobj, KOBJ_REMOVE);
 		kobject_del(&e->kobj);
+
+		mutex_lock(&q->sysfs_lock);
 		e->registered = 0;
 		/* Re-enable throttling in case elevator disabled it */
 		wbt_enable_default(q);
+		mutex_unlock(&q->sysfs_lock);
 	}
 }
 
@@ -940,10 +953,32 @@ int elevator_switch_mq(struct request_queue *q,
 	lockdep_assert_held(&q->sysfs_lock);
 
 	if (q->elevator) {
-		if (q->elevator->registered)
+		if (q->elevator->registered) {
+			mutex_unlock(&q->sysfs_lock);
+
+			/*
+			 * Concurrent elevator switch can't happen becasue
+			 * sysfs write is always exclusively on same file.
+			 *
+			 * Also the elevator queue won't be freed after
+			 * sysfs_lock is released becasue kobject_del() in
+			 * blk_unregister_queue() waits for completion of
+			 * .store & .show on its attributes.
+			 */
 			elv_unregister_queue(q);
+
+			mutex_lock(&q->sysfs_lock);
+		}
 		ioc_clear_queue(q);
 		elevator_exit(q, q->elevator);
+
+		/*
+		 * sysfs_lock may be dropped, so re-check if queue is
+		 * unregistered. If yes, don't switch to new elevator
+		 * any more
+		 */
+		if (!blk_queue_registered(q))
+			return 0;
 	}
 
 	ret = blk_mq_init_sched(q, new_e);
@@ -951,7 +986,11 @@ int elevator_switch_mq(struct request_queue *q,
 		goto out;
 
 	if (new_e) {
-		ret = elv_register_queue(q);
+		mutex_unlock(&q->sysfs_lock);
+
+		ret = elv_register_queue(q, true);
+
+		mutex_lock(&q->sysfs_lock);
 		if (ret) {
 			elevator_exit(q, q->elevator);
 			goto out;
@@ -1047,7 +1086,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	if (err)
 		goto fail_init;
 
-	err = elv_register_queue(q);
+	err = elv_register_queue(q, true);
 	if (err)
 		goto fail_register;
 
@@ -1067,7 +1106,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	/* switch failed, restore and re-register old elevator */
 	if (old) {
 		q->elevator = old;
-		elv_register_queue(q);
+		elv_register_queue(q, true);
 		blk_queue_bypass_end(q);
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3a2b34c2c82b..209ba8e7bd31 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -637,6 +637,7 @@ struct request_queue {
 	struct delayed_work	requeue_work;
 
 	struct mutex		sysfs_lock;
+	struct mutex		sysfs_dir_lock;
 
 	int			bypass_depth;
 	atomic_t		mq_freeze_depth;
-- 
2.25.1

