Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4AA65835A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiL1QrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiL1Qqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:46:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFD71DF2A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:41:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7186D61572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D40EC433F0;
        Wed, 28 Dec 2022 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245692;
        bh=BeRSr4PLDEpFsA4u6szMv6EwUzw9Jz1w+YzQ6SVkTzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0P4clbWpkau1gmolFl72HgD2SY8HzH2RzRrVgpl1XNTi39eax3wAkfcTv8kaUTAr0
         T0KSUMo2qg+ea7+jTNqz35v9luZWfrnYRmLyHW9xlLdgnulZZ47FHFbmX9K2B8N2xo
         i1VGVvbUgqFXAXvK0AhDe/ytiBG8RKPAs9ds8EBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0906/1146] block: untangle request_queue refcounting from sysfs
Date:   Wed, 28 Dec 2022 15:40:45 +0100
Message-Id: <20221228144354.827935251@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2bd85221a625b316114bafaab527770b607095d3 ]

The kobject embedded into the request_queue is used for the queue
directory in sysfs, but that is a child of the gendisks directory and is
intimately tied to it.  Move this kobject to the gendisk and use a
refcount_t in the request_queue for the actual request_queue refcounting
that is completely unrelated to the device model.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c         | 42 ++++++++++++++++----
 block/blk-crypto-sysfs.c |  4 +-
 block/blk-ia-ranges.c    |  3 +-
 block/blk-sysfs.c        | 86 +++++++++++-----------------------------
 block/blk.h              |  4 --
 block/bsg.c              | 11 +++--
 block/elevator.c         |  2 +-
 include/linux/blkdev.h   |  6 +--
 8 files changed, 71 insertions(+), 87 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9d6a947024ea..7de1bb16e9a7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -59,12 +59,12 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_split);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_insert);
 
-DEFINE_IDA(blk_queue_ida);
+static DEFINE_IDA(blk_queue_ida);
 
 /*
  * For queue allocation
  */
-struct kmem_cache *blk_requestq_cachep;
+static struct kmem_cache *blk_requestq_cachep;
 
 /*
  * Controlling structure to kblockd
@@ -252,19 +252,46 @@ void blk_clear_pm_only(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_clear_pm_only);
 
+static void blk_free_queue_rcu(struct rcu_head *rcu_head)
+{
+	kmem_cache_free(blk_requestq_cachep,
+			container_of(rcu_head, struct request_queue, rcu_head));
+}
+
+static void blk_free_queue(struct request_queue *q)
+{
+	might_sleep();
+
+	percpu_ref_exit(&q->q_usage_counter);
+
+	if (q->poll_stat)
+		blk_stat_remove_callback(q, q->poll_cb);
+	blk_stat_free_callback(q->poll_cb);
+
+	blk_free_queue_stats(q->stats);
+	kfree(q->poll_stat);
+
+	if (queue_is_mq(q))
+		blk_mq_release(q);
+
+	ida_free(&blk_queue_ida, q->id);
+	call_rcu(&q->rcu_head, blk_free_queue_rcu);
+}
+
 /**
  * blk_put_queue - decrement the request_queue refcount
  * @q: the request_queue structure to decrement the refcount for
  *
- * Decrements the refcount of the request_queue kobject. When this reaches 0
- * we'll have blk_release_queue() called.
+ * Decrements the refcount of the request_queue and free it when the refcount
+ * reaches 0.
  *
  * Context: Any context, but the last reference must not be dropped from
  *          atomic context.
  */
 void blk_put_queue(struct request_queue *q)
 {
-	kobject_put(&q->kobj);
+	if (refcount_dec_and_test(&q->refs))
+		blk_free_queue(q);
 }
 EXPORT_SYMBOL(blk_put_queue);
 
@@ -399,8 +426,7 @@ struct request_queue *blk_alloc_queue(int node_id)
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
 	INIT_LIST_HEAD(&q->icq_list);
 
-	kobject_init(&q->kobj, &blk_queue_ktype);
-
+	refcount_set(&q->refs, 1);
 	mutex_init(&q->debugfs_mutex);
 	mutex_init(&q->sysfs_lock);
 	mutex_init(&q->sysfs_dir_lock);
@@ -444,7 +470,7 @@ bool blk_get_queue(struct request_queue *q)
 {
 	if (unlikely(blk_queue_dying(q)))
 		return false;
-	kobject_get(&q->kobj);
+	refcount_inc(&q->refs);
 	return true;
 }
 EXPORT_SYMBOL(blk_get_queue);
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
index e05f145cd797..55268edc0625 100644
--- a/block/blk-crypto-sysfs.c
+++ b/block/blk-crypto-sysfs.c
@@ -140,8 +140,8 @@ int blk_crypto_sysfs_register(struct gendisk *disk)
 		return -ENOMEM;
 	obj->profile = q->crypto_profile;
 
-	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
-				   "crypto");
+	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype,
+				   &disk->queue_kobj, "crypto");
 	if (err) {
 		kobject_put(&obj->kobj);
 		return err;
diff --git a/block/blk-ia-ranges.c b/block/blk-ia-ranges.c
index 2bd1d311033b..2141931ddd37 100644
--- a/block/blk-ia-ranges.c
+++ b/block/blk-ia-ranges.c
@@ -123,7 +123,8 @@ int disk_register_independent_access_ranges(struct gendisk *disk)
 	 */
 	WARN_ON(iars->sysfs_registered);
 	ret = kobject_init_and_add(&iars->kobj, &blk_ia_ranges_ktype,
-				   &q->kobj, "%s", "independent_access_ranges");
+				   &disk->queue_kobj, "%s",
+				   "independent_access_ranges");
 	if (ret) {
 		disk->ia_ranges = NULL;
 		kobject_put(&iars->kobj);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1631ba2f7259..35e854bb6e0c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -680,8 +680,8 @@ static struct attribute *queue_attrs[] = {
 static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 				int n)
 {
-	struct request_queue *q =
-		container_of(kobj, struct request_queue, kobj);
+	struct gendisk *disk = container_of(kobj, struct gendisk, queue_kobj);
+	struct request_queue *q = disk->queue;
 
 	if (attr == &queue_io_timeout_entry.attr &&
 		(!q->mq_ops || !q->mq_ops->timeout))
@@ -707,8 +707,8 @@ static ssize_t
 queue_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
 	struct queue_sysfs_entry *entry = to_queue(attr);
-	struct request_queue *q =
-		container_of(kobj, struct request_queue, kobj);
+	struct gendisk *disk = container_of(kobj, struct gendisk, queue_kobj);
+	struct request_queue *q = disk->queue;
 	ssize_t res;
 
 	if (!entry->show)
@@ -724,63 +724,19 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 		    const char *page, size_t length)
 {
 	struct queue_sysfs_entry *entry = to_queue(attr);
-	struct request_queue *q;
+	struct gendisk *disk = container_of(kobj, struct gendisk, queue_kobj);
+	struct request_queue *q = disk->queue;
 	ssize_t res;
 
 	if (!entry->store)
 		return -EIO;
 
-	q = container_of(kobj, struct request_queue, kobj);
 	mutex_lock(&q->sysfs_lock);
 	res = entry->store(q, page, length);
 	mutex_unlock(&q->sysfs_lock);
 	return res;
 }
 
-static void blk_free_queue_rcu(struct rcu_head *rcu_head)
-{
-	kmem_cache_free(blk_requestq_cachep,
-			container_of(rcu_head, struct request_queue, rcu_head));
-}
-
-/**
- * blk_release_queue - releases all allocated resources of the request_queue
- * @kobj: pointer to a kobject, whose container is a request_queue
- *
- * This function releases all allocated resources of the request queue.
- *
- * The struct request_queue refcount is incremented with blk_get_queue() and
- * decremented with blk_put_queue(). Once the refcount reaches 0 this function
- * is called.
- *
- * Drivers exist which depend on the release of the request_queue to be
- * synchronous, it should not be deferred.
- *
- * Context: can sleep
- */
-static void blk_release_queue(struct kobject *kobj)
-{
-	struct request_queue *q =
-		container_of(kobj, struct request_queue, kobj);
-
-	might_sleep();
-
-	percpu_ref_exit(&q->q_usage_counter);
-
-	if (q->poll_stat)
-		blk_stat_remove_callback(q, q->poll_cb);
-	blk_stat_free_callback(q->poll_cb);
-
-	blk_free_queue_stats(q->stats);
-	kfree(q->poll_stat);
-
-	if (queue_is_mq(q))
-		blk_mq_release(q);
-
-	ida_free(&blk_queue_ida, q->id);
-	call_rcu(&q->rcu_head, blk_free_queue_rcu);
-}
-
 static const struct sysfs_ops queue_sysfs_ops = {
 	.show	= queue_attr_show,
 	.store	= queue_attr_store,
@@ -791,10 +747,15 @@ static const struct attribute_group *blk_queue_attr_groups[] = {
 	NULL
 };
 
-struct kobj_type blk_queue_ktype = {
+static void blk_queue_release(struct kobject *kobj)
+{
+	/* nothing to do here, all data is associated with the parent gendisk */
+}
+
+static struct kobj_type blk_queue_ktype = {
 	.default_groups = blk_queue_attr_groups,
 	.sysfs_ops	= &queue_sysfs_ops,
-	.release	= blk_release_queue,
+	.release	= blk_queue_release,
 };
 
 static void blk_debugfs_remove(struct gendisk *disk)
@@ -820,20 +781,20 @@ int blk_register_queue(struct gendisk *disk)
 	int ret;
 
 	mutex_lock(&q->sysfs_dir_lock);
-	ret = kobject_add(&q->kobj, &disk_to_dev(disk)->kobj, "queue");
+	kobject_init(&disk->queue_kobj, &blk_queue_ktype);
+	ret = kobject_add(&disk->queue_kobj, &disk_to_dev(disk)->kobj, "queue");
 	if (ret < 0)
-		goto out_unlock_dir;
+		goto out_put_queue_kobj;
 
 	if (queue_is_mq(q)) {
 		ret = blk_mq_sysfs_register(disk);
 		if (ret)
-			goto out_del_queue_kobj;
+			goto out_put_queue_kobj;
 	}
 	mutex_lock(&q->sysfs_lock);
 
 	mutex_lock(&q->debugfs_mutex);
-	q->debugfs_dir = debugfs_create_dir(kobject_name(q->kobj.parent),
-					    blk_debugfs_root);
+	q->debugfs_dir = debugfs_create_dir(disk->disk_name, blk_debugfs_root);
 	if (queue_is_mq(q))
 		blk_mq_debugfs_register(q);
 	mutex_unlock(&q->debugfs_mutex);
@@ -857,7 +818,7 @@ int blk_register_queue(struct gendisk *disk)
 	blk_throtl_register(disk);
 
 	/* Now everything is ready and send out KOBJ_ADD uevent */
-	kobject_uevent(&q->kobj, KOBJ_ADD);
+	kobject_uevent(&disk->queue_kobj, KOBJ_ADD);
 	if (q->elevator)
 		kobject_uevent(&q->elevator->kobj, KOBJ_ADD);
 	mutex_unlock(&q->sysfs_lock);
@@ -886,9 +847,8 @@ int blk_register_queue(struct gendisk *disk)
 out_debugfs_remove:
 	blk_debugfs_remove(disk);
 	mutex_unlock(&q->sysfs_lock);
-out_del_queue_kobj:
-	kobject_del(&q->kobj);
-out_unlock_dir:
+out_put_queue_kobj:
+	kobject_put(&disk->queue_kobj);
 	mutex_unlock(&q->sysfs_dir_lock);
 	return ret;
 }
@@ -935,8 +895,8 @@ void blk_unregister_queue(struct gendisk *disk)
 	mutex_unlock(&q->sysfs_lock);
 
 	/* Now that we've deleted all child objects, we can delete the queue. */
-	kobject_uevent(&q->kobj, KOBJ_REMOVE);
-	kobject_del(&q->kobj);
+	kobject_uevent(&disk->queue_kobj, KOBJ_REMOVE);
+	kobject_del(&disk->queue_kobj);
 	mutex_unlock(&q->sysfs_dir_lock);
 
 	blk_debugfs_remove(disk);
diff --git a/block/blk.h b/block/blk.h
index 4849a2efa4c5..55c06221a9d4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -26,10 +26,6 @@ struct blk_flush_queue {
 	spinlock_t		mq_flush_lock;
 };
 
-extern struct kmem_cache *blk_requestq_cachep;
-extern struct kobj_type blk_queue_ktype;
-extern struct ida blk_queue_ida;
-
 bool is_flush_rq(struct request *req);
 
 struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
diff --git a/block/bsg.c b/block/bsg.c
index 2ab1351eb082..8eba57b9bb46 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -175,8 +175,10 @@ static void bsg_device_release(struct device *dev)
 
 void bsg_unregister_queue(struct bsg_device *bd)
 {
-	if (bd->queue->kobj.sd)
-		sysfs_remove_link(&bd->queue->kobj, "bsg");
+	struct gendisk *disk = bd->queue->disk;
+
+	if (disk && disk->queue_kobj.sd)
+		sysfs_remove_link(&disk->queue_kobj, "bsg");
 	cdev_device_del(&bd->cdev, &bd->device);
 	put_device(&bd->device);
 }
@@ -216,8 +218,9 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	if (ret)
 		goto out_put_device;
 
-	if (q->kobj.sd) {
-		ret = sysfs_create_link(&q->kobj, &bd->device.kobj, "bsg");
+	if (q->disk && q->disk->queue_kobj.sd) {
+		ret = sysfs_create_link(&q->disk->queue_kobj, &bd->device.kobj,
+					"bsg");
 		if (ret)
 			goto out_device_del;
 	}
diff --git a/block/elevator.c b/block/elevator.c
index bd71f0fc4e4b..ac096f494911 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -499,7 +499,7 @@ int elv_register_queue(struct request_queue *q, bool uevent)
 
 	lockdep_assert_held(&q->sysfs_lock);
 
-	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
+	error = kobject_add(&e->kobj, &q->disk->queue_kobj, "iosched");
 	if (!error) {
 		struct elv_fs_entry *attr = e->type->elevator_attrs;
 		if (attr) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 36c286d22fb2..17dc59c5aa90 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -155,6 +155,7 @@ struct gendisk {
 	unsigned open_partitions;	/* number of open partitions */
 
 	struct backing_dev_info	*bdi;
+	struct kobject queue_kobj;	/* the queue/ directory */
 	struct kobject *slave_dir;
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 	struct list_head slave_bdevs;
@@ -437,10 +438,7 @@ struct request_queue {
 
 	struct gendisk		*disk;
 
-	/*
-	 * queue kobject
-	 */
-	struct kobject kobj;
+	refcount_t		refs;
 
 	/*
 	 * mq queue kobject
-- 
2.35.1



