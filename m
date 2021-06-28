Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFEF3B611F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhF1Ocn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhF1Oam (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB2361CC8;
        Mon, 28 Jun 2021 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890420;
        bh=6I0DsTk/Xh4iQ6sYHzAovpIdEDkO9rNngvr9DRZZToU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVeIE4SGbk/BsrUR2xZ0v17zQ5hUF4udyFBP/R2w54opzNQfsiWPZtd/rpXewZ0w3
         qbD11pOZOkZ7WnsfxW63bRS8nWkW9kUEwyihIaavkv9OOAXn0antJvzGyaCLXHoNiP
         AlMxwQgRZfQGh8bDfRJm6Si3dY8gNtfm1nYHn30Xks/5VJF4cd+LhJbhYHK7bVCtIP
         yWyAwBCbZ2K2TJWOofA+SHD2xpH+pW1VVNsLBlPmfwpJwf323CzzlX1eOANGbqWAPT
         i+nYtPDUscRdeSuvMyFTWeO0ZAdAKu1AOyRJ6aJDCk/nz2UK7IlpkieYlWxAS79clg
         wRsSyAv1w5Jsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/101] scsi: sd: Call sd_revalidate_disk() for ioctl(BLKRRPART)
Date:   Mon, 28 Jun 2021 10:25:27 -0400
Message-Id: <20210628142607.32218-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 20a6564f87d9..01f87bcab3dd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1389,6 +1389,22 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
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
@@ -1425,10 +1441,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
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

