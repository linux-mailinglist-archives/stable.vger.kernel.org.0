Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DF2EA2BF
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbhAEBGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhAEBAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C80C225AC;
        Tue,  5 Jan 2021 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808369;
        bh=+gGqkzy+8CQx9AUpsQyAbvAkoZxFMkzQtzuM3XQ1zLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xxgdwm+9u5Q2i5kYiTKudV3tCivty9pNX46zuWULXzbfbhUmGfqDIgn22+1QBpLSk
         /qY/MGuKlnfNQYObS98LyS5aQ+A76Kyz1QhgvuioHNJaNDt21xPaZZI7LUOzKcWgoM
         ZYAacF2OO/TANDEAvZ7y+UaKuVLigkRsMwlFELdMkYO11HXl0aNgoZ5jsb5YXt27x3
         fViCbilQ1FFP+P5Fy+5dc6RHNXe3RHlHRhLq1JgwT1Je/gfM9gUUqcgH3DljdIq4+H
         lGUjaUrcS6z63p8izRK4VZgjJet8Jlow0T5TYthra63LCDLTfjYg8mBJU1UPLffhXY
         059cx8OGCDjQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/17] scsi: ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Mon,  4 Jan 2021 19:59:07 -0500
Message-Id: <20210105005915.3954208-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 96d86e6a80a3ab9aff81d12f9f1f2a0da2917d38 ]

RQF_PREEMPT is used for two different purposes in the legacy IDE code:

 1. To mark power management requests.

 2. To mark requests that should preempt another request. An (old)
    explanation of that feature is as follows: "The IDE driver in the Linux
    kernel normally uses a series of busywait delays during its
    initialization. When the driver executes these busywaits, the kernel
    does nothing for the duration of the wait. The time spent in these
    waits could be used for other initialization activities, if they could
    be run concurrently with these waits.

    More specifically, busywait-style delays such as udelay() in module
    init functions inhibit kernel preemption because the Big Kernel Lock is
    held, while yielding APIs such as schedule_timeout() allow
    preemption. This is true because the kernel handles the BKL specially
    and releases and reacquires it across reschedules allowed by the
    current thread.

    This IDE-preempt specification requires that the driver eliminate these
    busywaits and replace them with a mechanism that allows other work to
    proceed while the IDE driver is initializing."

Since I haven't found an implementation of (2), do not set the PREEMPT flag
for sense requests. This patch causes sense requests to be postponed while
a drive is suspended instead of being submitted to ide_queue_rq().

If it would ever be necessary to restore the IDE PREEMPT functionality,
that can be done by introducing a new flag in struct ide_request.

Link: https://lore.kernel.org/r/20201209052951.16136-4-bvanassche@acm.org
Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ide/ide-atapi.c | 1 -
 drivers/ide/ide-io.c    | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2162bc80f09e0..013ad33fbbc81 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -223,7 +223,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1a53c7a752244..c210ea3bd02fa 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -515,11 +515,6 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 * above to return us whatever is in the queue. Since we call
 		 * ide_do_request() ourselves, we end up taking requests while
 		 * the queue is blocked...
-		 * 
-		 * We let requests forced at head of queue with ide-preempt
-		 * though. I hope that doesn't happen too much, hopefully not
-		 * unless the subdriver triggers such a thing in its own PM
-		 * state machine.
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
-- 
2.27.0

