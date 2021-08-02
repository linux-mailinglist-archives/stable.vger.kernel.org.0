Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411FF3DDA1F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhHBOGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhHBOD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56DD861104;
        Mon,  2 Aug 2021 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912646;
        bh=jiVEl3P0brZ/g6ojgB2OANVvi/m6JP3VxXG2oSSt0Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vi+ge7fy4vu/v1fxN7rINKwqBx4M73gUwLVFK6QKYLFEaAlQ2gvW4Q68bL1aUDCgB
         xTcJkH65x/hNyJxbRmvfhxe3uqfrtpzVJA4CBeWnk6kAmsWWLhzylNv6KSpFuyuzpj
         v66ml5/+PLL4ddRvN5Jnk6jPYMu+FJnS7vwcSrfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 086/104] block: delay freeing the gendisk
Date:   Mon,  2 Aug 2021 15:45:23 +0200
Message-Id: <20210802134346.836377326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 340e84573878b2b9d63210482af46883366361b9 ]

blkdev_get_no_open acquires a reference to the block_device through
the block device inode and then tries to acquire a device model
reference to the gendisk.  But at this point the disk migh already
be freed (although the race is free).  Fix this by only freeing the
gendisk from the whole device bdevs ->free_inode callback as well.

Fixes: 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210722075402.983367-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c  | 3 +--
 fs/block_dev.c | 2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index ad7436bd60c1..e8968fd30b2b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1124,10 +1124,9 @@ static void disk_release(struct device *dev)
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
-	bdput(disk->part0);
 	if (disk->queue)
 		blk_put_queue(disk->queue);
-	kfree(disk);
+	bdput(disk->part0);	/* frees the disk */
 }
 struct class block_class = {
 	.name		= "block",
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6cc4d4cfe0c2..e4a80bd4ddf1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -812,6 +812,8 @@ static void bdev_free_inode(struct inode *inode)
 	free_percpu(bdev->bd_stats);
 	kfree(bdev->bd_meta_info);
 
+	if (!bdev_is_partition(bdev))
+		kfree(bdev->bd_disk);
 	kmem_cache_free(bdev_cachep, BDEV_I(inode));
 }
 
-- 
2.30.2



