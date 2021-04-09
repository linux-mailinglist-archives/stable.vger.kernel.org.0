Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE5B359B08
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDIKHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234049AbhDIKEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2EB661207;
        Fri,  9 Apr 2021 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962462;
        bh=uhswwfjgQNA9mV8C+NtZaLC4WwSRw7Ksp8xEIYMKfBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cimjm5IZUqfGiO7Hc3qcLstIRHGWpjHkRIXN8ly0a2j3Oc7D98e2ZAvOJaIUY0vNq
         iXt2/YPLHsMI7tymYDdHeDNmM4QHr5uqaS24Lqp1c4hBApsm7zXL+vXpWgB9C82ikr
         AAOtmjRYJNwi5dKKXTokAKftYGRJEj3lB4ZH8RMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 24/45] block: clear GD_NEED_PART_SCAN later in bdev_disk_changed
Date:   Fri,  9 Apr 2021 11:53:50 +0200
Message-Id: <20210409095306.194485279@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 5116784039f0421e9a619023cfba3e302c3d9adc ]

The GD_NEED_PART_SCAN is set by bdev_check_media_change to initiate
a partition scan while removing a block device. It should be cleared
after blk_drop_paritions because blk_drop_paritions could return
-EBUSY and then the consequence __blkdev_get has no chance to do
delete_partition if GD_NEED_PART_SCAN already cleared.

It causes some problems on some card readers. Ex. Realtek card
reader 0bda:0328 and 0bda:0158. The device node of the partition
will not disappear after the memory card removed. Thus the user
applications can not update the device mapping correctly.

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1920874
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210323085219.24428-1-chris.chiu@canonical.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c33151020bcd..85500e2400cf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1240,13 +1240,13 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
-	clear_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
-
 rescan:
 	ret = blk_drop_partitions(bdev);
 	if (ret)
 		return ret;
 
+	clear_bit(GD_NEED_PART_SCAN, &disk->state);
+
 	/*
 	 * Historically we only set the capacity to zero for devices that
 	 * support partitions (independ of actually having partitions created).
-- 
2.30.2



