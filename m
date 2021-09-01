Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37B63FDB20
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343716AbhIAMiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343733AbhIAMga (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AFBD6109E;
        Wed,  1 Sep 2021 12:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499625;
        bh=uFoGyHp9snzNt123frTbdjiDX9s2ycIlpFAozepiU4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXE2oEbuxTEiYVQBsusQXLHFVE8cQlOKxras3Ohin8MJC76hHRKRhHDkQoyBiQfZA
         eAuHt8EVIqdu5OSy5dc28RHvYWuUOnGMzZ6SHyvXXzEkNBdKpi+No6z2ht0YQazREs
         +Z3xBthuy9ixH7HH8CE0z0FtDMvmEIfx6iyN5hqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Li Jinlin <lijinlin3@huawei.com>,
        Qiu Laibin <qiulaibin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 022/103] scsi: core: Fix hang of freezing queue between blocking and running device
Date:   Wed,  1 Sep 2021 14:27:32 +0200
Message-Id: <20210901122301.275002938@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jinlin <lijinlin3@huawei.com>

commit 02c6dcd543f8f051973ee18bfbc4dc3bd595c558 upstream.

We found a hang, the steps to reproduce  are as follows:

  1. blocking device via scsi_device_set_state()

  2. dd if=/dev/sda of=/mnt/t.log bs=1M count=10

  3. echo none > /sys/block/sda/queue/scheduler

  4. echo "running" >/sys/block/sda/device/state

Step 3 and 4 should complete after step 4, but they hang.

  CPU#0               CPU#1                CPU#2
  ---------------     ----------------     ----------------
                                           Step 1: blocking device

                                           Step 2: dd xxxx
                                                  ^^^^^^ get request
                                                         q_usage_counter++

                      Step 3: switching scheculer
                      elv_iosched_store
                        elevator_switch
                          blk_mq_freeze_queue
                            blk_freeze_queue
                              > blk_freeze_queue_start
                                ^^^^^^ mq_freeze_depth++

                              > blk_mq_run_hw_queues
                                ^^^^^^ can't run queue when dev blocked

                              > blk_mq_freeze_queue_wait
                                ^^^^^^ Hang here!!!
                                       wait q_usage_counter==0

  Step 4: running device
  store_state_field
    scsi_rescan_device
      scsi_attach_vpd
        scsi_vpd_inquiry
          __scsi_execute
            blk_get_request
              blk_mq_alloc_request
                blk_queue_enter
                ^^^^^^ Hang here!!!
                       wait mq_freeze_depth==0

    blk_mq_run_hw_queues
    ^^^^^^ dispatch IO, q_usage_counter will reduce to zero

                            blk_mq_unfreeze_queue
                            ^^^^^ mq_freeze_depth--

To fix this, we need to run queue before rescanning device when the device
state changes to SDEV_RUNNING.

Link: https://lore.kernel.org/r/20210824025921.3277629-1-lijinlin3@huawei.com
Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Signed-off-by: Qiu Laibin <qiulaibin@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_sysfs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -808,12 +808,15 @@ store_state_field(struct device *dev, st
 	ret = scsi_device_set_state(sdev, state);
 	/*
 	 * If the device state changes to SDEV_RUNNING, we need to
-	 * rescan the device to revalidate it, and run the queue to
-	 * avoid I/O hang.
+	 * run the queue to avoid I/O hang, and rescan the device
+	 * to revalidate it. Running the queue first is necessary
+	 * because another thread may be waiting inside
+	 * blk_mq_freeze_queue_wait() and because that call may be
+	 * waiting for pending I/O to finish.
 	 */
 	if (ret == 0 && state == SDEV_RUNNING) {
-		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+		scsi_rescan_device(dev);
 	}
 	mutex_unlock(&sdev->state_mutex);
 


