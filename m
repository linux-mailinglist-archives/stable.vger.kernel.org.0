Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610EC2E9A64
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbhADQJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbhADQBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CFF22507;
        Mon,  4 Jan 2021 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776053;
        bh=5Gfu3L59rdjO9CtMPxwCNS4CHfJnT5MFmlDci/a6xLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfCIgcHTpJ4wSGixuzPFMWMYR99CbGulGpAi0RtXE2P5vf7ab4GADcqWEnKDGI49T
         Oc+w976iItxxmtHwjr+nBo2DwP4oKSNpISHD4fD6dOr0DL8Aeo/MQTdD8XLj9JkwuH
         bAmBEqn3M5EcXVykufFd0enP/0Ri3vmxtMEsO82Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 18/47] scsi: block: Fix a race in the runtime power management code
Date:   Mon,  4 Jan 2021 16:57:17 +0100
Message-Id: <20210104155706.618488635@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit fa4d0f1992a96f6d7c988ef423e3127e613f6ac9 upstream.

With the current implementation the following race can happen:

 * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
   blk_mq_unfreeze_queue().

 * blk_queue_enter() calls blk_queue_pm_only() and that function returns
   true.

 * blk_queue_enter() calls blk_pm_request_resume() and that function does
   not call pm_request_resume() because the queue runtime status is
   RPM_ACTIVE.

 * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.

Fix this race by changing the queue runtime status into RPM_SUSPENDING
before switching q_usage_counter to atomic mode.

Link: https://lore.kernel.org/r/20201209052951.16136-2-bvanassche@acm.org
Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Co-developed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-pm.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/block/blk-pm.c
+++ b/block/blk-pm.c
@@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct reque
 
 	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
 
+	spin_lock_irq(&q->queue_lock);
+	q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(&q->queue_lock);
+
 	/*
 	 * Increase the pm_only counter before checking whether any
 	 * non-PM blk_queue_enter() calls are in progress to avoid that any
@@ -89,15 +93,14 @@ int blk_pre_runtime_suspend(struct reque
 	/* Switch q_usage_counter back to per-cpu mode. */
 	blk_mq_unfreeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
-	if (ret < 0)
+	if (ret < 0) {
+		spin_lock_irq(&q->queue_lock);
+		q->rpm_status = RPM_ACTIVE;
 		pm_runtime_mark_last_busy(q->dev);
-	else
-		q->rpm_status = RPM_SUSPENDING;
-	spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&q->queue_lock);
 
-	if (ret)
 		blk_clear_pm_only(q);
+	}
 
 	return ret;
 }


