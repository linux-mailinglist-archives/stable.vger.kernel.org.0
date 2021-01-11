Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11702F13E5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbhAKNQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbhAKNQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB3822795;
        Mon, 11 Jan 2021 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370939;
        bh=G2sxkvCfLDdOyIMFmJjYKroAT2N4YT0KNRZ2Oo0vYyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etdnjmHsbqb4bWtTwoWZOlI6OXG9ofW+RXHwUtDTiy2ubxLtKxZrHIHOZ9Ur7KBFx
         XRzLDtdSZteoZGZ97Bomp305r7HHTYD4p3t63W2kh/sNBTJ+FQHWY0B9sNtZfN55wc
         esX1awilm5khkOzFDOPIIA6mf3r4BwKxGaWNsdD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 5.10 071/145] scsi: block: Do not accept any requests while suspended
Date:   Mon, 11 Jan 2021 14:01:35 +0100
Message-Id: <20210111130051.946884154@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 52abca64fd9410ea6c9a3a74eab25663b403d7da ]

blk_queue_enter() accepts BLK_MQ_REQ_PM requests independent of the runtime
power management state. Now that SCSI domain validation no longer depends
on this behavior, modify the behavior of blk_queue_enter() as follows:

   - Do not accept any requests while suspended.

   - Only process power management requests while suspending or resuming.

Submitting BLK_MQ_REQ_PM requests to a device that is runtime suspended
causes runtime-suspended devices not to resume as they should. The request
which should cause a runtime resume instead gets issued directly, without
resuming the device first. Of course the device can't handle it properly,
the I/O fails, and the device remains suspended.

The problem is fixed by checking that the queue's runtime-PM status isn't
RPM_SUSPENDED before allowing a request to be issued, and queuing a
runtime-resume request if it is.  In particular, the inline
blk_pm_request_resume() routine is renamed blk_pm_resume_queue() and the
code is unified by merging the surrounding checks into the routine.  If the
queue isn't set up for runtime PM, or there currently is no restriction on
allowed requests, the request is allowed.  Likewise if the BLK_MQ_REQ_PM
flag is set and the status isn't RPM_SUSPENDED.  Otherwise a runtime resume
is queued and the request is blocked until conditions are more suitable.

[ bvanassche: modified commit message and removed Cc: stable because
  without the previous patches from this series this patch would break
  parallel SCSI domain validation + introduced queue_rpm_status() ]

Link: https://lore.kernel.org/r/20201209052951.16136-9-bvanassche@acm.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       |  7 ++++---
 block/blk-pm.h         | 14 +++++++++-----
 include/linux/blkdev.h | 12 ++++++++++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a00bce9f46d88..2d53e2ff48ff8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -18,6 +18,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/blk-pm.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -440,7 +441,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && queue_rpm_status(q) != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -465,8 +467,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 		wait_event(q->mq_freeze_wq,
 			   (!q->mq_freeze_depth &&
-			    (pm || (blk_pm_request_resume(q),
-				    !blk_queue_pm_only(q)))) ||
+			    blk_pm_resume_queue(pm, q)) ||
 			   blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
diff --git a/block/blk-pm.h b/block/blk-pm.h
index ea5507d23e759..a2283cc9f716d 100644
--- a/block/blk-pm.h
+++ b/block/blk-pm.h
@@ -6,11 +6,14 @@
 #include <linux/pm_runtime.h>
 
 #ifdef CONFIG_PM
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
-	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-		       q->rpm_status == RPM_SUSPENDING))
-		pm_request_resume(q->dev);
+	if (!q->dev || !blk_queue_pm_only(q))
+		return 1;	/* Nothing to do */
+	if (pm && q->rpm_status != RPM_SUSPENDED)
+		return 1;	/* Request allowed */
+	pm_request_resume(q->dev);
+	return 0;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
@@ -44,8 +47,9 @@ static inline void blk_pm_put_request(struct request *rq)
 		--rq->q->nr_pending;
 }
 #else
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
+	return 1;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a6e33d382429..542471b76f410 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -692,6 +692,18 @@ static inline bool queue_is_mq(struct request_queue *q)
 	return q->mq_ops;
 }
 
+#ifdef CONFIG_PM
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return q->rpm_status;
+}
+#else
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return RPM_ACTIVE;
+}
+#endif
+
 static inline enum blk_zoned_model
 blk_queue_zoned_model(struct request_queue *q)
 {
-- 
2.27.0



