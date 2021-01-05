Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403662EA289
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbhAEBDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbhAEBBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA84422582;
        Tue,  5 Jan 2021 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808405;
        bh=WfWOdvixaL7PMa865MGcKoM8DolWpq728REn/AuPaYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEnKyc97TIUF3oqf49aZAhu0hmuRciHyBAbNU+VJkLVoa8gdG7g3Gw8/cKiJcc5YT
         lPwCgh9WuioAC/uWKRM1Zs5CSKF9nbiWYzuim/9nEOcEofCPI/Emd0VGQlbnl77+ft
         wRmp8ZXx+GIR9uTC2+SsQ2E5OL+MMPQLBwZukZbJ6UR4dnUOX4sgZ8vV7s69Ee4ys9
         NYv//hqOFg8dk90s6QizUw3raRTaPq8Fgb4cKUIZQOJs/MfOj0C3QzCduT39NhfGZd
         5LvhFHJ8LJgm/pzy8tzQLrJBjh/SmTAQJVg6cQcmuwINNYmGmbcooPyzt00tOAV/T/
         v7giLrsi0qoFA==
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
Subject: [PATCH AUTOSEL 4.19 4/8] scsi: ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Mon,  4 Jan 2021 19:59:55 -0500
Message-Id: <20210105005959.3954510-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005959.3954510-1-sashal@kernel.org>
References: <20210105005959.3954510-1-sashal@kernel.org>
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
index 8b2b72b938857..4224c4dd89635 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -213,7 +213,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0d93e0cfbeaf9..4381760846109 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -527,11 +527,6 @@ void do_ide_request(struct request_queue *q)
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

