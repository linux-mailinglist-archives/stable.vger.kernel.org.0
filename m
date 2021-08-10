Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4653E5D46
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242732AbhHJOS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242737AbhHJOQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D18610CC;
        Tue, 10 Aug 2021 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604976;
        bh=krB2uaUzBWhsBBI6sxpfHjcS0F3AYuSsDoqq+LlL+HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhC3c7/V4UlWBL9ebODSd+4XwrC4tb4otIoP4V3gUf31sR3JOUN+63yoC4zcw5P7K
         M8PZeKEqJ5ZgynPQrvRYRm5CSPyEnwYjLjmP5xD46wzEuynTgTUBlh3Ha/rYcJu6dr
         drsoa+XYrZ4RaaJYS+AkecJDHh9QGBUdF7+xkCPCud+5WS/jWgkSpe7yT6WPC9wNip
         ffuyEsb5fLTBRyh1fq77/f8p5o1whgnvxV7iZWfhnnJzoO0XKGJ0T0fxDwtYq76n1U
         N/nPvxR01PFm1poGHkGEm5M2psj6tKecWKq9J7k59sSxZ+LuR8nKaEqu7NF2uTvFNu
         OgDOUNUw5sD+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     lijinlin <lijinlin3@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/13] scsi: core: Fix capacity set to zero after offlinining device
Date:   Tue, 10 Aug 2021 10:16:00 -0400
Message-Id: <20210810141606.3117932-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141606.3117932-1-sashal@kernel.org>
References: <20210810141606.3117932-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lijinlin <lijinlin3@huawei.com>

[ Upstream commit f0f82e2476f6adb9c7a0135cfab8091456990c99 ]

After adding physical volumes to a volume group through vgextend, the
kernel will rescan the partitions. This in turn will cause the device
capacity to be queried.

If the device status is set to offline through sysfs at this time, READ
CAPACITY command will return a result which the host byte is
DID_NO_CONNECT, and the capacity of the device will be set to zero in
read_capacity_error(). After setting device status back to running, the
capacity of the device will remain stuck at zero.

Fix this issue by rescanning device when the device state changes to
SDEV_RUNNING.

Link: https://lore.kernel.org/r/20210727034455.1494960-1-lijinlin3@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: lijinlin <lijinlin3@huawei.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6d7362e7367e..11592ec7b23e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -787,11 +787,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, state);
 	/*
-	 * If the device state changes to SDEV_RUNNING, we need to run
-	 * the queue to avoid I/O hang.
+	 * If the device state changes to SDEV_RUNNING, we need to
+	 * rescan the device to revalidate it, and run the queue to
+	 * avoid I/O hang.
 	 */
-	if (ret == 0 && state == SDEV_RUNNING)
+	if (ret == 0 && state == SDEV_RUNNING) {
+		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+	}
 	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
-- 
2.30.2

