Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82DB409428
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245199AbhIMO2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345461AbhIMO0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE19A61B56;
        Mon, 13 Sep 2021 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540941;
        bh=lmrD3OpzI0AC422F28H0oRKZg8SjaZlpeBLU6Bzz8LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1toKJGLWopdFgd13A1vFEHJVPuO0TIHSSlRDxd6lQ8Qy5+l3CnauqAbjG4pIL3l6N
         Z5bm3f8iF7Gj1nP1/ntxpphGfAVIvIe88czNJ3IwCr4SiHy3SGubCTg7dNSV9ryvw+
         DYIKCF1tm4YGUoJro1oJuAwEspBZnXe2KQJB8mXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0fe7752e52337864d29b@syzkaller.appspotmail.com,
        Hou Tao <houtao1@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 065/334] nbd: do del_gendisk() asynchronously for NBD_DESTROY_ON_DISCONNECT
Date:   Mon, 13 Sep 2021 15:11:59 +0200
Message-Id: <20210913131115.608842538@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 68c9417b193d0d174b0ada013602272177e61303 ]

Now open_mutex is used to synchronize partition operations (e.g,
blk_drop_partitions() and blkdev_reread_part()), however it makes
nbd driver broken, because nbd may call del_gendisk() in nbd_release()
or nbd_genl_disconnect() if NBD_CFLAG_DESTROY_ON_DISCONNECT is enabled,
and deadlock occurs, as shown below:

// AB-BA dead-lock
nbd_genl_disconnect            blkdev_open
  nbd_disconnect_and_put
                                 lock bd_mutex
  // last ref
  nbd_put
    lock nbd_index_mutex
      del_gendisk
                                   nbd_open
                                     try lock nbd_index_mutex
        try lock bd_mutex

 or

// AA dead-lock
nbd_release
  lock bd_mutex
    nbd_put
      try lock bd_mutex

Instead of fixing block layer (e.g, introduce another lock), fixing
the nbd driver to call del_gendisk() in a kworker when
NBD_DESTROY_ON_DISCONNECT is enabled. When NBD_DESTROY_ON_DISCONNECT
is disabled, nbd device will always be destroy through module removal,
and there is no risky of deadlock.

To ensure the reuse of nbd index succeeds, moving the calling of
idr_remove() after del_gendisk(), so if the reused index is not found
in nbd_index_idr, the old disk must have been deleted. And reusing
the existing destroy_complete mechanism to ensure nbd_genl_connect()
will wait for the completion of del_gendisk().

Also adding a new workqueue for nbd removal, so nbd_cleanup()
can ensure all removals complete before exits.

Reported-by: syzbot+0fe7752e52337864d29b@syzkaller.appspotmail.com
Fixes: c76f48eb5c08 ("block: take bd_mutex around delete_partitions in del_gendisk")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210811124428.2368491-2-hch@lst.de
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 70 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index acf3f85bf3c7..7ed888e99f09 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -49,6 +49,7 @@
 
 static DEFINE_IDR(nbd_index_idr);
 static DEFINE_MUTEX(nbd_index_mutex);
+static struct workqueue_struct *nbd_del_wq;
 static int nbd_total_devices = 0;
 
 struct nbd_sock {
@@ -113,6 +114,7 @@ struct nbd_device {
 	struct mutex config_lock;
 	struct gendisk *disk;
 	struct workqueue_struct *recv_workq;
+	struct work_struct remove_work;
 
 	struct list_head list;
 	struct task_struct *task_recv;
@@ -233,7 +235,7 @@ static const struct device_attribute backend_attr = {
 	.show = backend_show,
 };
 
-static void nbd_dev_remove(struct nbd_device *nbd)
+static void nbd_del_disk(struct nbd_device *nbd)
 {
 	struct gendisk *disk = nbd->disk;
 
@@ -242,24 +244,60 @@ static void nbd_dev_remove(struct nbd_device *nbd)
 		blk_cleanup_disk(disk);
 		blk_mq_free_tag_set(&nbd->tag_set);
 	}
+}
 
+/*
+ * Place this in the last just before the nbd is freed to
+ * make sure that the disk and the related kobject are also
+ * totally removed to avoid duplicate creation of the same
+ * one.
+ */
+static void nbd_notify_destroy_completion(struct nbd_device *nbd)
+{
+	if (test_bit(NBD_DESTROY_ON_DISCONNECT, &nbd->flags) &&
+	    nbd->destroy_complete)
+		complete(nbd->destroy_complete);
+}
+
+static void nbd_dev_remove_work(struct work_struct *work)
+{
+	struct nbd_device *nbd =
+		container_of(work, struct nbd_device, remove_work);
+
+	nbd_del_disk(nbd);
+
+	mutex_lock(&nbd_index_mutex);
 	/*
-	 * Place this in the last just before the nbd is freed to
-	 * make sure that the disk and the related kobject are also
-	 * totally removed to avoid duplicate creation of the same
-	 * one.
+	 * Remove from idr after del_gendisk() completes,
+	 * so if the same id is reused, the following
+	 * add_disk() will succeed.
 	 */
-	if (test_bit(NBD_DESTROY_ON_DISCONNECT, &nbd->flags) && nbd->destroy_complete)
-		complete(nbd->destroy_complete);
+	idr_remove(&nbd_index_idr, nbd->index);
+
+	nbd_notify_destroy_completion(nbd);
+	mutex_unlock(&nbd_index_mutex);
 
 	kfree(nbd);
 }
 
+static void nbd_dev_remove(struct nbd_device *nbd)
+{
+	/* Call del_gendisk() asynchrounously to prevent deadlock */
+	if (test_bit(NBD_DESTROY_ON_DISCONNECT, &nbd->flags)) {
+		queue_work(nbd_del_wq, &nbd->remove_work);
+		return;
+	}
+
+	nbd_del_disk(nbd);
+	idr_remove(&nbd_index_idr, nbd->index);
+	nbd_notify_destroy_completion(nbd);
+	kfree(nbd);
+}
+
 static void nbd_put(struct nbd_device *nbd)
 {
 	if (refcount_dec_and_mutex_lock(&nbd->refs,
 					&nbd_index_mutex)) {
-		idr_remove(&nbd_index_idr, nbd->index);
 		nbd_dev_remove(nbd);
 		mutex_unlock(&nbd_index_mutex);
 	}
@@ -1685,6 +1723,7 @@ static int nbd_dev_add(int index)
 	nbd->tag_set.flags = BLK_MQ_F_SHOULD_MERGE |
 		BLK_MQ_F_BLOCKING;
 	nbd->tag_set.driver_data = nbd;
+	INIT_WORK(&nbd->remove_work, nbd_dev_remove_work);
 	nbd->destroy_complete = NULL;
 	nbd->backend = NULL;
 
@@ -2426,7 +2465,14 @@ static int __init nbd_init(void)
 	if (register_blkdev(NBD_MAJOR, "nbd"))
 		return -EIO;
 
+	nbd_del_wq = alloc_workqueue("nbd-del", WQ_UNBOUND, 0);
+	if (!nbd_del_wq) {
+		unregister_blkdev(NBD_MAJOR, "nbd");
+		return -ENOMEM;
+	}
+
 	if (genl_register_family(&nbd_genl_family)) {
+		destroy_workqueue(nbd_del_wq);
 		unregister_blkdev(NBD_MAJOR, "nbd");
 		return -EINVAL;
 	}
@@ -2444,7 +2490,10 @@ static int nbd_exit_cb(int id, void *ptr, void *data)
 	struct list_head *list = (struct list_head *)data;
 	struct nbd_device *nbd = ptr;
 
-	list_add_tail(&nbd->list, list);
+	/* Skip nbd that is being removed asynchronously */
+	if (refcount_read(&nbd->refs))
+		list_add_tail(&nbd->list, list);
+
 	return 0;
 }
 
@@ -2467,6 +2516,9 @@ static void __exit nbd_cleanup(void)
 		nbd_put(nbd);
 	}
 
+	/* Also wait for nbd_dev_remove_work() completes */
+	destroy_workqueue(nbd_del_wq);
+
 	idr_destroy(&nbd_index_idr);
 	genl_unregister_family(&nbd_genl_family);
 	unregister_blkdev(NBD_MAJOR, "nbd");
-- 
2.30.2



