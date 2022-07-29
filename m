Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70585584BD9
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiG2GaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 02:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbiG2G3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 02:29:52 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBA8052F
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 23:29:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LvHFD6N0lz6S1cQ;
        Fri, 29 Jul 2022 14:10:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S5;
        Fri, 29 Jul 2022 14:11:53 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        snitzer@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH stable 5.10 1/3] block: look up holders by bdev
Date:   Fri, 29 Jul 2022 14:23:54 +0800
Message-Id: <20220729062356.1663513-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1fXFW3WFyxGw1rWFW5trb_yoW7GryxpF
        98GFZ5JrW8W3yxWrsrtw47ZrW3Ww48C3WxJa4akr1SgrW7Jrs2vF1ktryDZFyfKrZ7KFZF
        qF17WrWa9F10k3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9m14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqAp5UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 0dbcfe247f22a6d73302dfa691c48b3c14d31c4c upstream.

Invert they way the holder relations are tracked.  This very
slightly reduces the memory overhead for partitioned devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/genhd.c             |  3 +++
 fs/block_dev.c            | 31 +++++++++++++++++++------------
 include/linux/blk_types.h |  3 ---
 include/linux/genhd.h     |  4 +++-
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 796baf761202..2b11a2735285 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1760,6 +1760,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
 	device_initialize(disk_to_dev(disk));
+#ifdef CONFIG_SYSFS
+	INIT_LIST_HEAD(&disk->slave_bdevs);
+#endif
 	return disk;
 
 out_free_part0:
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 29f020c4b2d0..a202c76fcf7f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -823,9 +823,6 @@ static void init_once(void *foo)
 
 	memset(bdev, 0, sizeof(*bdev));
 	mutex_init(&bdev->bd_mutex);
-#ifdef CONFIG_SYSFS
-	INIT_LIST_HEAD(&bdev->bd_holder_disks);
-#endif
 	bdev->bd_bdi = &noop_backing_dev_info;
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
@@ -1188,7 +1185,7 @@ EXPORT_SYMBOL(bd_abort_claiming);
 #ifdef CONFIG_SYSFS
 struct bd_holder_disk {
 	struct list_head	list;
-	struct gendisk		*disk;
+	struct block_device	*bdev;
 	int			refcnt;
 };
 
@@ -1197,8 +1194,8 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
 {
 	struct bd_holder_disk *holder;
 
-	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
-		if (holder->disk == disk)
+	list_for_each_entry(holder, &disk->slave_bdevs, list)
+		if (holder->bdev == bdev)
 			return holder;
 	return NULL;
 }
@@ -1244,9 +1241,13 @@ static void del_symlink(struct kobject *from, struct kobject *to)
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
+	struct block_device *bdev_holder = bdget_disk(disk, 0);
 	int ret = 0;
 
-	mutex_lock(&bdev->bd_mutex);
+	if (WARN_ON_ONCE(!bdev_holder))
+		return -ENOENT;
+
+	mutex_lock(&bdev_holder->bd_mutex);
 
 	WARN_ON_ONCE(!bdev->bd_holder);
 
@@ -1267,7 +1268,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	}
 
 	INIT_LIST_HEAD(&holder->list);
-	holder->disk = disk;
+	holder->bdev = bdev;
 	holder->refcnt = 1;
 
 	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
@@ -1283,7 +1284,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	 */
 	kobject_get(bdev->bd_part->holder_dir);
 
-	list_add(&holder->list, &bdev->bd_holder_disks);
+	list_add(&holder->list, &disk->slave_bdevs);
 	goto out_unlock;
 
 out_del:
@@ -1291,7 +1292,8 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 out_free:
 	kfree(holder);
 out_unlock:
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev_holder->bd_mutex);
+	bdput(bdev_holder);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
@@ -1309,8 +1311,12 @@ EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
+	struct block_device *bdev_holder = bdget_disk(disk, 0);
 
-	mutex_lock(&bdev->bd_mutex);
+	if (WARN_ON_ONCE(!bdev_holder))
+		return;
+
+	mutex_lock(&bdev_holder->bd_mutex);
 
 	holder = bd_find_holder_disk(bdev, disk);
 
@@ -1323,7 +1329,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		kfree(holder);
 	}
 
-	mutex_unlock(&bdev->bd_mutex);
+	mutex_unlock(&bdev_holder->bd_mutex);
+	bdput(bdev_holder);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d9b69bbde5cc..1b84ecb34c18 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -29,9 +29,6 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
-#ifdef CONFIG_SYSFS
-	struct list_head	bd_holder_disks;
-#endif
 	struct block_device *	bd_contains;
 	u8			bd_partno;
 	struct hd_struct *	bd_part;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 03da3f603d30..3e5049a527e6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -195,7 +195,9 @@ struct gendisk {
 #define GD_NEED_PART_SCAN		0
 	struct rw_semaphore lookup_sem;
 	struct kobject *slave_dir;
-
+#ifdef CONFIG_SYSFS
+	struct list_head	slave_bdevs;
+#endif
 	struct timer_rand_state *random;
 	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
-- 
2.31.1

