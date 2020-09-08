Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5B8261C9E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgIHTXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731092AbgIHQBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EE8E23E21;
        Tue,  8 Sep 2020 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579466;
        bh=1VUBi6fqR7yZIoBA187luCNz/xF8VTAhf9Sv8APOTzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oY9hhu4VtqkC/1hzc5b2CmP1DKl9jiNm5QWpz3gpEVc5AfYCaq8EMYNvXtVItsgk
         aLpsc4mn3cB0x2CuUExY80QdBbJD6t3ZOO0nTSLZnJHpLyD4cvyTK3sDgVe/4//kh0
         pV1BODINiZtwLNgLUNusysG0fW3etDz4ovzLC2Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6448f3c229bc52b82f69@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 090/186] block: fix locking in bdev_del_partition
Date:   Tue,  8 Sep 2020 17:23:52 +0200
Message-Id: <20200908152246.007784365@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 08fc1ab6d748ab1a690fd483f41e2938984ce353 ]

We need to hold the whole device bd_mutex to protect against
other thread concurrently deleting out partition before we get
to it, and thus causing a use after free.

Fixes: cddae808aeb7 ("block: pass a hd_struct to delete_partition")
Reported-by: syzbot+6448f3c229bc52b82f69@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 78951e33b2d7c..534e11285a8d4 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -524,19 +524,20 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 int bdev_del_partition(struct block_device *bdev, int partno)
 {
 	struct block_device *bdevp;
-	struct hd_struct *part;
-	int ret = 0;
-
-	part = disk_get_part(bdev->bd_disk, partno);
-	if (!part)
-		return -ENXIO;
+	struct hd_struct *part = NULL;
+	int ret;
 
-	ret = -ENOMEM;
-	bdevp = bdget(part_devt(part));
+	bdevp = bdget_disk(bdev->bd_disk, partno);
 	if (!bdevp)
-		goto out_put_part;
+		return -ENOMEM;
 
 	mutex_lock(&bdevp->bd_mutex);
+	mutex_lock_nested(&bdev->bd_mutex, 1);
+
+	ret = -ENXIO;
+	part = disk_get_part(bdev->bd_disk, partno);
+	if (!part)
+		goto out_unlock;
 
 	ret = -EBUSY;
 	if (bdevp->bd_openers)
@@ -545,16 +546,14 @@ int bdev_del_partition(struct block_device *bdev, int partno)
 	sync_blockdev(bdevp);
 	invalidate_bdev(bdevp);
 
-	mutex_lock_nested(&bdev->bd_mutex, 1);
 	delete_partition(bdev->bd_disk, part);
-	mutex_unlock(&bdev->bd_mutex);
-
 	ret = 0;
 out_unlock:
+	mutex_unlock(&bdev->bd_mutex);
 	mutex_unlock(&bdevp->bd_mutex);
 	bdput(bdevp);
-out_put_part:
-	disk_put_part(part);
+	if (part)
+		disk_put_part(part);
 	return ret;
 }
 
-- 
2.25.1



