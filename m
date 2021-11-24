Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E9245C269
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbhKXN3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349723AbhKXNXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0635561B24;
        Wed, 24 Nov 2021 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758091;
        bh=YsDpFCsykiUMPjdwjLh16Xje2BkqUoxlNhlUoV/nqwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJpFaVV7YgPZmyotkxndwGbRo299hZUKLCqJw7b/mt0igiEdhGuxni7xjQPip6JbI
         1DoIqSCQEMmrg4YEsEfkg7DDfDBXP3k7Xasnji8wTy6CAu/7+619QhLt07AaLbuslm
         NKq3SBHleyDNASj756hqUfequyjwkQkmPj6llAmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/100] scsi: core: sysfs: Fix hang when device state is set via sysfs
Date:   Wed, 24 Nov 2021 12:58:14 +0100
Message-Id: <20211124115656.749031204@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
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
index 12064ce76777d..16432d42a50aa 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -776,6 +776,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
+	bool rescan_dev = false;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -794,20 +795,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
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



