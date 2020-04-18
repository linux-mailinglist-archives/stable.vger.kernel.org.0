Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946F51AED7D
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgDRNwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgDRNs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F6D822251;
        Sat, 18 Apr 2020 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217735;
        bh=Yb0dT5Mf5FCK4nJCMD4GNxe6Lfw8RlG4lpvc3T+67PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUi75cWiTr5AgK+kt5Kfpr1nZiRt46cten2zm11HgswXSKgaoXO1NNh87XC5fPde3
         WENXUBCKMvi46pn/wPpw0zSPZxSo1lbeAXZ34qMB45vRr8XQg/p7x5yYyMG7kxfbPw
         eT+aj/TIZ2EIBzsH4MJNDsYSoo9h8266UPYXpBjM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 32/73] block: fix busy device checking in blk_drop_partitions
Date:   Sat, 18 Apr 2020 09:47:34 -0400
Message-Id: <20200418134815.6519-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d3ef5536274faf89e626276b833be122a16bdb81 ]

bd_super is only set by get_tree_bdev and mount_bdev, and thus not by
other openers like btrfs or the XFS realtime and log devices, as well as
block devices directly opened from user space.  Check bd_openers
instead.

Fixes: 77032ca66f86 ("Return EBUSY from BLKRRPART for mounted whole-dev fs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partition-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 564fae77711df..5f3b2a959aa51 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -468,7 +468,7 @@ int blk_drop_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	if (!disk_part_scan_enabled(disk))
 		return 0;
-	if (bdev->bd_part_count || bdev->bd_super)
+	if (bdev->bd_part_count || bdev->bd_openers)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
 	if (res)
-- 
2.20.1

