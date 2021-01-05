Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B0B2EA2BC
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbhAEBGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbhAEBAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3382F22795;
        Tue,  5 Jan 2021 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808371;
        bh=DOn/dF1JQSKk+Qo6oym2pLOpByqawptwcz/+AmpGngs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnHDtJHlQWE7MKfL1ajDhd0bmAUKehYlbxUdY+nvy17RL0V4Dc3uUcn1+tgcFgfNZ
         zYjED+f/uT7D5SP70WACFiF6yAH6JO3it8RrBfvrrcmpqC9zZzwiR94nDBLLBKBkeL
         8AcaDNCrj/QDZyG7E9E7NoBh8KSVC9qqrQh6hpO281y7x3O2NZthqqV/Dn/zlOsPoD
         qr03+X4+GI2rFoMyeFHLA3JRZbafDTNhyux+NIkzFE68I/PoWCpHSWBKyCVFs0Svfp
         b1IzieVLMy2ZWR4UAh0/RCF5NoFWluyFZyaex6mLhWpMpyleYvjv/Pi+wZtCe1kzlN
         bft+GHzHIbyvQ==
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
Subject: [PATCH AUTOSEL 5.10 10/17] scsi: ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
Date:   Mon,  4 Jan 2021 19:59:08 -0500
Message-Id: <20210105005915.3954208-10-sashal@kernel.org>
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

[ Upstream commit 5ae65383fc7633e0247c31b0c8bf0e6ea63b95a3 ]

This is another step that prepares for the removal of RQF_PREEMPT.

Link: https://lore.kernel.org/r/20201209052951.16136-5-bvanassche@acm.org
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
 drivers/ide/ide-io.c | 2 +-
 drivers/ide/ide-pm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c210ea3bd02fa..4867b67b60d69 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -518,7 +518,7 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
-		    (rq->rq_flags & RQF_PREEMPT) == 0) {
+		    (rq->rq_flags & RQF_PM) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
 			goto plug_device;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 192e6c65d34e7..82ab308f1aafe 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -77,7 +77,7 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PREEMPT);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	ide_req(rq)->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
-- 
2.27.0

