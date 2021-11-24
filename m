Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCDB45C373
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347590AbhKXNjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346320AbhKXNgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F680611AF;
        Wed, 24 Nov 2021 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758518;
        bh=ZyEfVXiD0YuhTbG011kQo0t6KO16+1j7rHVOFD9fFWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFy7j7VWCkoe2m/bEdP4u6h3vXGv0zE/Q2VL3vL9DIO4XdpRuLwxs14snJWkuoPtf
         ugUeJWI4Cc1JHM9sFA2mhPMsYKXnphdaLoT+mL2MrW6w2FxDbWxOZTIKrMHHR43UYs
         BxCeND3iedxFiEItijJHmCJ6+7/y7ORqbcaz09dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/154] scsi: core: sysfs: Fix hang when device state is set via sysfs
Date:   Wed, 24 Nov 2021 12:58:12 +0100
Message-Id: <20211124115705.403864662@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 4edd8cd4e86dd3047e5294bbefcc0a08f66a430f ]

This fixes a regression added with:

commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
offlinining device")

The problem is that after iSCSI recovery, iscsid will call into the kernel
to set the dev's state to running, and with that patch we now call
scsi_rescan_device() with the state_mutex held. If the SCSI error handler
thread is just starting to test the device in scsi_send_eh_cmnd() then it's
going to try to grab the state_mutex.

We are then stuck, because when scsi_rescan_device() tries to send its I/O
scsi_queue_rq() calls -> scsi_host_queue_ready() -> scsi_host_in_recovery()
which will return true (the host state is still in recovery) and I/O will
just be requeued. scsi_send_eh_cmnd() will then never be able to grab the
state_mutex to finish error handling.

To prevent the deadlock move the rescan-related code to after we drop the
state_mutex.

This also adds a check for if we are already in the running state. This
prevents extra scans and helps the iscsid case where if the transport class
has already onlined the device during its recovery process then we don't
need userspace to do it again plus possibly block that daemon.

Link: https://lore.kernel.org/r/20211105221048.6541-3-michael.christie@oracle.com
Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: lijinlin <lijinlin3@huawei.com>
Cc: Wu Bo <wubo40@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1378bb1a7371c..8de67679a8782 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -796,6 +796,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
+	bool rescan_dev = false;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -814,20 +815,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
-	ret = scsi_device_set_state(sdev, state);
-	/*
-	 * If the device state changes to SDEV_RUNNING, we need to
-	 * run the queue to avoid I/O hang, and rescan the device
-	 * to revalidate it. Running the queue first is necessary
-	 * because another thread may be waiting inside
-	 * blk_mq_freeze_queue_wait() and because that call may be
-	 * waiting for pending I/O to finish.
-	 */
-	if (ret == 0 && state == SDEV_RUNNING) {
+	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
+		ret = count;
+	} else {
+		ret = scsi_device_set_state(sdev, state);
+		if (ret == 0 && state == SDEV_RUNNING)
+			rescan_dev = true;
+	}
+	mutex_unlock(&sdev->state_mutex);
+
+	if (rescan_dev) {
+		/*
+		 * If the device state changes to SDEV_RUNNING, we need to
+		 * run the queue to avoid I/O hang, and rescan the device
+		 * to revalidate it. Running the queue first is necessary
+		 * because another thread may be waiting inside
+		 * blk_mq_freeze_queue_wait() and because that call may be
+		 * waiting for pending I/O to finish.
+		 */
 		blk_mq_run_hw_queues(sdev->request_queue, true);
 		scsi_rescan_device(dev);
 	}
-	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
 }
-- 
2.33.0



