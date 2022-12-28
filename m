Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F334657D80
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiL1PoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiL1PoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39C317433
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832D86155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D13C433D2;
        Wed, 28 Dec 2022 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242232;
        bh=xBH2Ta0JdDm2ZQTTHy4fWztn5V5aVxdqhRoeLP1CPI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1L6S/bG8gE7gDteK6QwDnkvXxT8AEKzY/qDjtum2UeV/IFhG9IRFGeN4opzUMXFU
         MquqIzTHWZpqi0tqsIVPOtx7xTA3O9PQqnS2Iwb4GkzwFgnJfsRT64KMNa3SytZKdb
         lwAmGieEKHxUYHEfoG74z443wuMAnuIxT0ihaKyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0344/1146] dm: track per-add_disk holder relations in DM
Date:   Wed, 28 Dec 2022 15:31:23 +0100
Message-Id: <20221228144339.503706784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1a581b72169968f4154b5793828f3bc28b258b35 ]

dm is a bit special in that it opens the underlying devices.  Commit
89f871af1b26 ("dm: delay registering the gendisk") tried to accommodate
that by allowing to add the holder to the list before add_gendisk and
then just add them to sysfs once add_disk is called.  But that leads to
really odd lifetime problems and error handling problems as we can't
know the state of the kobjects and don't unwind properly.  To fix this
switch to just registering all existing table_devices with the holder
code right after add_disk, and remove them before calling del_gendisk.

Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221115141054.1051801-7-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f10ac680cef4..e30c2d2bc9c7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -751,9 +751,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		goto out_free_td;
 	}
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r)
-		goto out_blkdev_put;
+	/*
+	 * We can be called before the dm disk is added.  In that case we can't
+	 * register the holder relation here.  It will be done once add_disk was
+	 * called.
+	 */
+	if (md->disk->slave_dir) {
+		r = bd_link_disk_holder(bdev, md->disk);
+		if (r)
+			goto out_blkdev_put;
+	}
 
 	td->dm_dev.mode = mode;
 	td->dm_dev.bdev = bdev;
@@ -774,7 +781,8 @@ static struct table_device *open_table_device(struct mapped_device *md,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
-	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
+	if (md->disk->slave_dir)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
 	list_del(&td->list);
@@ -1964,7 +1972,13 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
+			struct table_device *td;
+
 			dm_sysfs_exit(md);
+			list_for_each_entry(td, &md->table_devices, list) {
+				bd_unlink_disk_holder(td->dm_dev.bdev,
+						      md->disk);
+			}
 
 			/*
 			 * Hold lock to make sure del_gendisk() won't concurrent
@@ -2304,6 +2318,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
 	struct queue_limits limits;
+	struct table_device *td;
 	int r;
 
 	switch (type) {
@@ -2342,16 +2357,30 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		mutex_lock(&md->table_devices_lock);
-		del_gendisk(md->disk);
-		mutex_unlock(&md->table_devices_lock);
-		return r;
+	/*
+	 * Register the holder relationship for devices added before the disk
+	 * was live.
+	 */
+	list_for_each_entry(td, &md->table_devices, list) {
+		r = bd_link_disk_holder(td->dm_dev.bdev, md->disk);
+		if (r)
+			goto out_undo_holders;
 	}
 
+	r = dm_sysfs_init(md);
+	if (r)
+		goto out_undo_holders;
+
 	md->type = type;
 	return 0;
+
+out_undo_holders:
+	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
+	mutex_lock(&md->table_devices_lock);
+	del_gendisk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
-- 
2.35.1



