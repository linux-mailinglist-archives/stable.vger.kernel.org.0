Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA5C584BDA
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiG2GaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 02:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiG2G3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 02:29:54 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AE480F65
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 23:29:26 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LvHFF56hJz6S29f;
        Fri, 29 Jul 2022 14:10:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S7;
        Fri, 29 Jul 2022 14:11:54 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        snitzer@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH stable 5.10 3/3] dm: delay registering the gendisk
Date:   Fri, 29 Jul 2022 14:23:56 +0800
Message-Id: <20220729062356.1663513-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryxCw43Wr1fZryUZryxKrg_yoW5JF43pw
        sxW390vrWrGr4qvw4DXa1UZFy3tws5t34fZr1fCw1F934Fkr90v3W2kFy8ZFW5JFZ7XFsx
        JFWDtrWkC3W8tr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9m14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd8n5UUUUU=
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

commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8 upstream.

device mapper is currently the only outlier that tries to call
register_disk after add_disk, leading to fairly inconsistent state
of these block layer data structures.  Instead change device-mapper
to just register the gendisk later now that the holder mechanism
can cope with that.

Note that this introduces a user visible change: the dm kobject is
now only visible after the initial table has been loaded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab0e2338e47e..85efe2f1995f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1795,7 +1795,12 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
-		del_gendisk(md->disk);
+		if (dm_get_md_type(md) != DM_TYPE_NONE) {
+			dm_sysfs_exit(md);
+			del_gendisk(md->disk);
+		} else {
+			md->disk->queue = NULL;
+		}
 		put_disk(md->disk);
 	}
 
@@ -1900,7 +1905,6 @@ static struct mapped_device *alloc_dev(int minor)
 		}
 	}
 
-	add_disk_no_queue_reg(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
@@ -2098,19 +2102,12 @@ static struct dm_table *__unbind(struct mapped_device *md)
  */
 int dm_create(int minor, struct mapped_device **result)
 {
-	int r;
 	struct mapped_device *md;
 
 	md = alloc_dev(minor);
 	if (!md)
 		return -ENXIO;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		free_dev(md);
-		return r;
-	}
-
 	*result = md;
 	return 0;
 }
@@ -2188,8 +2185,14 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		return r;
 	}
 	dm_table_set_restrictions(t, md->queue, &limits);
-	blk_register_queue(md->disk);
 
+	add_disk(md->disk);
+	r = dm_sysfs_init(md);
+	if (r) {
+		del_gendisk(md->disk);
+		return r;
+	}
+	md->type = type;
 	return 0;
 }
 
@@ -2295,7 +2298,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
 		       dm_device_name(md), atomic_read(&md->holders));
 
-	dm_sysfs_exit(md);
 	dm_table_destroy(__unbind(md));
 	free_dev(md);
 }
-- 
2.31.1

