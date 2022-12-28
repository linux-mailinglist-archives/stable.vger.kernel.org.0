Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2866657D76
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiL1Pnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiL1Pnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF1D1707E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81C7ECE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719ADC433D2;
        Wed, 28 Dec 2022 15:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242206;
        bh=8v+EMNxtKi4gzOckFgmgHMjxyI2PGf6ODKXnpVuuKe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+1Bd0cAC87r1TYlRsfOd/dW4/r2GpekE464dISzpR4DzyhGagAReHbjNlQPyr3wz
         a8boRSL5/uE+nr0dD2Q89SzDATw6WI+2uCTqsVVdk+TqmBhz4iGSVArAkB2c9hOzBV
         5TVvYDJtJv4bFby/0lxawS9Xi45BA7j9Tx9z/V98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Yu Kuai <yukuai3@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0341/1146] dm: cleanup open_table_device
Date:   Wed, 28 Dec 2022 15:31:20 +0100
Message-Id: <20221228144339.419409011@linuxfoundation.org>
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

[ Upstream commit b9a785d2dc6567b2fd9fc60057a6a945a276927a ]

Move all the logic for allocation the table_device and linking it into
the list into the open_table_device.  This keeps the code tidy and
ensures that the table_devices only exist in fully initialized state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221115141054.1051801-4-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 56 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 95a1ee3d314e..739996499f4d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -732,28 +732,41 @@ static char *_dm_claim_ptr = "I belong to device-mapper";
 /*
  * Open a table device so we can use it as a map destination.
  */
-static int open_table_device(struct table_device *td, dev_t dev,
-			     struct mapped_device *md)
+static struct table_device *open_table_device(struct mapped_device *md,
+		dev_t dev, fmode_t mode)
 {
+	struct table_device *td;
 	struct block_device *bdev;
 	u64 part_off;
 	int r;
 
-	BUG_ON(td->dm_dev.bdev);
+	td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
+	if (!td)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&td->count, 1);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	bdev = blkdev_get_by_dev(dev, mode | FMODE_EXCL, _dm_claim_ptr);
+	if (IS_ERR(bdev)) {
+		r = PTR_ERR(bdev);
+		goto out_free_td;
+	}
 
 	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
-	}
+	if (r)
+		goto out_blkdev_put;
 
+	td->dm_dev.mode = mode;
 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off, NULL, NULL);
-	return 0;
+	format_dev_t(td->dm_dev.name, dev);
+	list_add(&td->list, &md->table_devices);
+	return td;
+
+out_blkdev_put:
+	blkdev_put(bdev, mode | FMODE_EXCL);
+out_free_td:
+	kfree(td);
+	return ERR_PTR(r);
 }
 
 /*
@@ -786,31 +799,16 @@ static struct table_device *find_table_device(struct list_head *l, dev_t dev,
 int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 			struct dm_dev **result)
 {
-	int r;
 	struct table_device *td;
 
 	mutex_lock(&md->table_devices_lock);
 	td = find_table_device(&md->table_devices, dev, mode);
 	if (!td) {
-		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
-		if (!td) {
-			mutex_unlock(&md->table_devices_lock);
-			return -ENOMEM;
-		}
-
-		td->dm_dev.mode = mode;
-		td->dm_dev.bdev = NULL;
-
-		if ((r = open_table_device(td, dev, md))) {
+		td = open_table_device(md, dev, mode);
+		if (IS_ERR(td)) {
 			mutex_unlock(&md->table_devices_lock);
-			kfree(td);
-			return r;
+			return PTR_ERR(td);
 		}
-
-		format_dev_t(td->dm_dev.name, dev);
-
-		refcount_set(&td->count, 1);
-		list_add(&td->list, &md->table_devices);
 	} else {
 		refcount_inc(&td->count);
 	}
-- 
2.35.1



