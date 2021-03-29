Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C0234DABB
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhC2WX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232255AbhC2WWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F18619A7;
        Mon, 29 Mar 2021 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056570;
        bh=dvqJDRbD2yEG3C1IfWVltxL+m6zIpiSLZWbf/J7c7gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LakA5mRguLe8BNkbP4hpSTXXoJWIVK/vZb9wigtyfV3hvpIJ5dNhirlUcQETIQsZ8
         5sMlNMeEhUgSvahXfGytssscHoFmtEju7XWZ5rgViz/BuhYebZzA0e2sikwpjpb9bu
         9dBzPzzqQrrBSB4J1ZMLcH82TlQnoAGPAO11oyHZBOJgbUAzfAU9HAfra/usX62vTQ
         IDLzTMwlLbvIpWJVPKgewoDCW+Ay2/K7ph4okL1+6PzbBzBzmy763W+7IupNPmM0/i
         7CdujkskCfkg4Ev9p3FZyh012oTnOsMqPvaquPEeVkZ4pGGw2HG+QrUI+izvWKkiGz
         KDxQXHMZBmZFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chris.chiu@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/33] block: clear GD_NEED_PART_SCAN later in bdev_disk_changed
Date:   Mon, 29 Mar 2021 18:22:11 -0400
Message-Id: <20210329222222.2382987-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fe201b757baa..6516051807b8 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1404,13 +1404,13 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
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
2.30.1

