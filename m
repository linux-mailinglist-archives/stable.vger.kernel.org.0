Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30C1E6053
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbgE1L4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388630AbgE1L4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72119212CC;
        Thu, 28 May 2020 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666967;
        bh=iEDnrsz6xY98L2zR/1m+vsa68l86wv7afRh44H+XURc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHRvASaAjuR+Nb7gSwldh4/ZxkYxODyQJHUxlHOqY4f0sNRSfZS5LbLSzQDu3CHYk
         ZJz43yfocmveZ+hU9fkbmmvMkZ2FCjKwE95Qcq2KHW//0hOi1gaWNBWooTcvlCLnGb
         mvHdR6Yx/hE4Kb33UTbG6N55DLcDHYABPl10G8F0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 05/47] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Thu, 28 May 2020 07:55:18 -0400
Message-Id: <20200528115600.1405808-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 05d18ae1cc8a0308b12f37b4ab94afce3535fac9 ]

During system resume, scsi_resume_device() decreases a request queue's
pm_only counter if the scsi device was quiesced before. But after that, if
the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is still
held (non-zero). Current SCSI resume hook only sets the RPM status of the
scsi_device and its request queue to RPM_ACTIVE, but leaves the pm_only
counter unchanged. This may make the request queue's pm_only counter remain
non-zero after resume hook returns, hence those who are waiting on the
mq_freeze_wq would never be woken up. Fix this by calling
blk_post_runtime_resume() if a sdev's RPM status was RPM_SUSPENDED.

(struct request_queue)0xFFFFFF815B69E938
	pm_only = (counter = 2),
	rpm_status = 0,
	dev = 0xFFFFFF815B0511A0,

((struct device)0xFFFFFF815B0511A0)).power
	is_suspended = FALSE,
	runtime_status = RPM_ACTIVE,

(struct scsi_device)0xffffff815b051000
	request_queue = 0xFFFFFF815B69E938,
	sdev_state = SDEV_RUNNING,
	quiesced_by = 0x0,

B::v.f_/task_0xFFFFFF810C246940
-000|__switch_to(prev = 0xFFFFFF810C246940, next = 0xFFFFFF80A49357C0)
-001|context_switch(inline)
-001|__schedule(?)
-002|schedule()
-003|blk_queue_enter(q = 0xFFFFFF815B69E938, flags = 0)
-004|generic_make_request(?)
-005|submit_bio(bio = 0xFFFFFF80A8195B80)

Link: https://lore.kernel.org/r/1588740936-28846-1-git-send-email-cang@codeaurora.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_pm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea37ecb..5f0ad8b32e3a 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -80,6 +80,10 @@ static int scsi_dev_type_resume(struct device *dev,
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
+		bool was_runtime_suspended;
+
+		was_runtime_suspended = pm_runtime_suspended(dev);
+
 		pm_runtime_disable(dev);
 		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -93,8 +97,10 @@ static int scsi_dev_type_resume(struct device *dev,
 		 */
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
+			if (was_runtime_suspended)
+				blk_post_runtime_resume(sdev->request_queue, 0);
+			else
+				blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
-- 
2.25.1

