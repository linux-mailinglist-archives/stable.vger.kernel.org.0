Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AACE3B602E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhF1OWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhF1OV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBCAC619AD;
        Mon, 28 Jun 2021 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889965;
        bh=ZoSsaSq1T+7h8UdsZgbU8DVrmhz2qOrgauk/ZZVfKtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuYG7LplsMViU4uHYHnJQN0oeZyN3McUbd+I2+30GnPeBuSMga5iny4h2aeySu+4q
         H0iQAkC2FOVaWv3dxKSY3PewvTWUSRWB4F/uxE9KNt47oNL/u3kfuqBh6wpiwqO5fi
         lQ3AnNp3zAVAWzpL3/ReyGznpmoXPV6c8q8bD6QtKYPBanL0FiYQR/rVmN5/a+fl8s
         QCiDd1biCR/3fwJ9TMSvMCFQRRECthahnpJRzwgY9ymlZq0UYpBfPqdHyPlicpBTBN
         kyRJ+dXDstQp3H6uczAbhp2gROTVGog4CdKrrHP+PWXx+k/hRIkYyLAHINXS4VXYyC
         nUKtcJFJ04mYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 066/110] scsi: sd: Call sd_revalidate_disk() for ioctl(BLKRRPART)
Date:   Mon, 28 Jun 2021 10:17:44 -0400
Message-Id: <20210628141828.31757-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d1b7f92035c6fb42529ada531e2cbf3534544c82 ]

While the disk state has nothing to do with partitions, BLKRRPART is used
to force a full revalidate after things like a disk format for historical
reasons. Restore that behavior.

Link: https://lore.kernel.org/r/20210617115504.1732350-1-hch@lst.de
Fixes: 471bd0af544b ("sd: use bdev_check_media_change")
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed0b1bb99f08..a0356f3707b8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1387,6 +1387,22 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	}
 }
 
+static bool sd_need_revalidate(struct block_device *bdev,
+		struct scsi_disk *sdkp)
+{
+	if (sdkp->device->removable || sdkp->write_prot) {
+		if (bdev_check_media_change(bdev))
+			return true;
+	}
+
+	/*
+	 * Force a full rescan after ioctl(BLKRRPART).  While the disk state has
+	 * nothing to do with partitions, BLKRRPART is used to force a full
+	 * revalidate after things like a format for historical reasons.
+	 */
+	return test_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@bdev: Block device of the scsi disk to open
@@ -1423,10 +1439,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	if (sdev->removable || sdkp->write_prot) {
-		if (bdev_check_media_change(bdev))
-			sd_revalidate_disk(bdev->bd_disk);
-	}
+	if (sd_need_revalidate(bdev, sdkp))
+		sd_revalidate_disk(bdev->bd_disk);
 
 	/*
 	 * If the drive is empty, just let the open fail.
-- 
2.30.2

