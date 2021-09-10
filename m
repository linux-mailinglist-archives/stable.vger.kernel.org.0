Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376D1406230
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbhIJAo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhIJAUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8E9610E9;
        Fri, 10 Sep 2021 00:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233184;
        bh=XyH2l67V36Il5T/GuHJW1uKzhlCEXhp/Ee6URnRKdz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMrcpC087kudkf1OtJ7IoJhrdKk9cBVVF4zSQW3kG6/7I+zjPlMOd8bQ/EBTUAoQT
         5QA/dJ/eExfxjsH2MLxg33PvbBlzvthV8ToL2YIFYzKNBCVjwP4PXeaNcNXgxhWNeD
         PUBN6gIEtIGvCzfP6qNx8yHBACc4U+3mcJwP3axwjswgDnXOPSMf+y1LCLA8TrW0oG
         8i6QMoagR1OAq7BVx3NDzxqLy7UccpXtmoaycEYc+m4/qEtau5L2pMtWXc30vJTI3Y
         Xi3sSNZXTm8t4AfQJLG0l0o11USQDhXar6L5dW/qNs0LJGYxhkSXPWt0SDHWT1ZDnz
         bpPXwwL0/hGUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 59/88] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
Date:   Thu,  9 Sep 2021 20:17:51 -0400
Message-Id: <20210910001820.174272-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 9b5ac8ab4e8bf5636d1d425aee68ddf45af12057 ]

Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if the
length is zero. So go back to requesting all the sense data, as it was
before patch "scsi: ufs: Request sense data asynchronously". That is
simpler than creating and maintaining a quirk for affected devices.

Link: https://lore.kernel.org/r/20210824114150.2105-1-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1f0980a70e3f..dcd1eeb2b0e0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7787,7 +7787,8 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
 {
 	if (error != BLK_STS_OK)
-		pr_err("%s: REQUEST SENSE failed (%d)", __func__, error);
+		pr_err("%s: REQUEST SENSE failed (%d)\n", __func__, error);
+	kfree(rq->end_io_data);
 	blk_put_request(rq);
 }
 
@@ -7795,16 +7796,30 @@ static int
 ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 {
 	/*
-	 * From SPC-6: the REQUEST SENSE command with any allocation length
-	 * clears the sense data.
+	 * Some UFS devices clear unit attention condition only if the sense
+	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
 	 */
-	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
+	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
 	struct scsi_request *rq;
 	struct request *req;
+	char *buffer;
+	int ret;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
+			      /*flags=*/BLK_MQ_REQ_PM);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
+		goto out_free;
+	}
+
+	ret = blk_rq_map_kern(sdev->request_queue, req,
+			      buffer, UFS_SENSE_SIZE, GFP_NOIO);
+	if (ret)
+		goto out_put;
 
 	rq = scsi_req(req);
 	rq->cmd_len = ARRAY_SIZE(cmd);
@@ -7812,10 +7827,17 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	rq->retries = 3;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->end_io_data = buffer;
 
 	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
 			      ufshcd_request_sense_done);
 	return 0;
+
+out_put:
+	blk_put_request(req);
+out_free:
+	kfree(buffer);
+	return ret;
 }
 
 static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
-- 
2.30.2

