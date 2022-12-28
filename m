Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB585657CE6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiL1PhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiL1PhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857A91580C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2101161553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC9DC433EF;
        Wed, 28 Dec 2022 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241832;
        bh=lL7VBS0iHKkJfUUElzYBQqkPTuo4og5ASgpq3wqi8/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fo+0/lKkkpRTF1ZuD3HwAE3XJzv50iL4JjF3SynEq/OnfEW+H+3V0l5qDdGUxkHjn
         i3ACkWs5qWhzh5D5AF06rQDQ9DLh7n1vGBZzpMFiTfWrYgtBwkdO3bZBSnA96HS3rH
         VERwdn91SU4/KsHxQ+BSzv8vRPv71ykJEld1bckA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Yu Kuai <yukuai3@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0332/1073] dm: cleanup close_table_device
Date:   Wed, 28 Dec 2022 15:32:00 +0100
Message-Id: <20221228144337.021593822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 7b5865831c1003122f737df5e16adaa583f1a595 ]

Take the list unlink and free into close_table_device so that no half
torn down table_devices exist.  Also remove the check for a NULL bdev
as that can't happen - open_table_device never adds a table_device to
the list that does not have a valid block_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221115141054.1051801-5-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1903afa4618a..620abcef2df5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -774,14 +774,11 @@ static struct table_device *open_table_device(struct mapped_device *md,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
-	if (!td->dm_dev.bdev)
-		return;
-
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
-	td->dm_dev.bdev = NULL;
-	td->dm_dev.dax_dev = NULL;
+	list_del(&td->list);
+	kfree(td);
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
@@ -823,11 +820,8 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	struct table_device *td = container_of(d, struct table_device, dm_dev);
 
 	mutex_lock(&md->table_devices_lock);
-	if (refcount_dec_and_test(&td->count)) {
+	if (refcount_dec_and_test(&td->count))
 		close_table_device(td, md);
-		list_del(&td->list);
-		kfree(td);
-	}
 	mutex_unlock(&md->table_devices_lock);
 }
 
-- 
2.35.1



