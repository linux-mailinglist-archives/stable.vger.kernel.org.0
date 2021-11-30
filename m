Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57904463786
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242839AbhK3OyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242805AbhK3OxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA48FC0613FE;
        Tue, 30 Nov 2021 06:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9118EB817FA;
        Tue, 30 Nov 2021 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69441C53FC1;
        Tue, 30 Nov 2021 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283721;
        bh=ulE/ml8MDwvJiy9A3ZP+AfxT1W13k+6jFHrs5x1pOWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTvYZLpcddVbLJV3gdDCoMjNeHtAnsIe6e1xqMLo5JFB6ViHpTnscJwH1xr048iXs
         Kjq9xsaq2toFizQLB4OmV7bFsDSmhMBXdGackVpuJcdxN/K2NWp9py6OeHPcV3ADFz
         Put6YU9D8vL52owOqIAdVXMmMYDwpqcGrxYAOzwZ2LYQPYEPPK3zpb+zK4a0tgGm69
         +oPb6zb2osP2HjR79h9mGb1DRyYJHm/BQxRDwJ9QT4Tlmt0zBy9iyHCslXSuPejzIT
         Gq8rGDfJvJkFlaNDx/VJUDcDBSXv2hWVKSLXKlEji08PTCNvYnYbTOxd9iRT61TJ6O
         HZyUMh3ACjoNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        czhong@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/68] block: avoid to touch unloaded module instance when opening bdev
Date:   Tue, 30 Nov 2021 09:46:28 -0500
Message-Id: <20211130144707.944580-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit efcf5932230b9472cfdbe01c858726f29ac5ec7d ]

disk->fops->owner is grabbed in blkdev_get_no_open() after the disk
kobject refcount is increased. This way can't make sure that
disk->fops->owner is still alive since del_gendisk() still can move
on if the kobject refcount of disk is grabbed by open() and
disk->fops->open() isn't called yet.

Fixes the issue by moving try_module_get() into blkdev_get_by_dev()
with ->open_mutex() held, then we can drain the in-progress open()
in del_gendisk(). Meantime new open() won't succeed because disk
becomes not alive.

This way is reasonable because blkdev_get_no_open() needn't to touch
disk->fops or defined callbacks.

Cc: Christoph Hellwig <hch@lst.de>
Cc: czhong@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211111020343.316126-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 485a258b0ab37..e52af269004bc 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -750,8 +750,7 @@ struct block_device *blkdev_get_no_open(dev_t dev)
 
 	if (!bdev)
 		return NULL;
-	if ((bdev->bd_disk->flags & GENHD_FL_HIDDEN) ||
-	    !try_module_get(bdev->bd_disk->fops->owner)) {
+	if ((bdev->bd_disk->flags & GENHD_FL_HIDDEN)) {
 		put_device(&bdev->bd_device);
 		return NULL;
 	}
@@ -761,7 +760,6 @@ struct block_device *blkdev_get_no_open(dev_t dev)
 
 void blkdev_put_no_open(struct block_device *bdev)
 {
-	module_put(bdev->bd_disk->fops->owner);
 	put_device(&bdev->bd_device);
 }
 
@@ -817,12 +815,14 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 	ret = -ENXIO;
 	if (!disk_live(disk))
 		goto abort_claiming;
+	if (!try_module_get(disk->fops->owner))
+		goto abort_claiming;
 	if (bdev_is_partition(bdev))
 		ret = blkdev_get_part(bdev, mode);
 	else
 		ret = blkdev_get_whole(bdev, mode);
 	if (ret)
-		goto abort_claiming;
+		goto put_module;
 	if (mode & FMODE_EXCL) {
 		bd_finish_claiming(bdev, holder);
 
@@ -844,7 +844,8 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 	if (unblock_events)
 		disk_unblock_events(disk);
 	return bdev;
-
+put_module:
+	module_put(disk->fops->owner);
 abort_claiming:
 	if (mode & FMODE_EXCL)
 		bd_abort_claiming(bdev, holder);
@@ -953,6 +954,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
 		blkdev_put_whole(bdev, mode);
 	mutex_unlock(&disk->open_mutex);
 
+	module_put(disk->fops->owner);
 	blkdev_put_no_open(bdev);
 }
 EXPORT_SYMBOL(blkdev_put);
-- 
2.33.0

