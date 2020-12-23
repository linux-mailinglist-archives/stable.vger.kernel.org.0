Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692422E1413
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgLWCh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgLWCYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B4C225AC;
        Wed, 23 Dec 2020 02:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690214;
        bh=dZgsKdKXei2Ac27yYfYhOd1u9GRCXYsUH8l0X+/zhv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rr2SH+OxtXm9MlbPXHFNeJ+Cc6xrpUJCxxyB92ZAMZaFdfRZby61QmFVoYtx9pHMk
         M9zugE03OAYTxNBiCLyDkVx5Cf6YfVutJGiKSYGpphfV9S7XVuRPDmojsZKnKtJzdH
         ff0/1RngGyXPCAarWF3MqtDrYBaBAjIL6aaNMXyr59VNa5NXjwbWWpGrjCh3W5ftv4
         qMWuGQbzzl9MNXSTNa/UWMSqOPsy+bip9HWnMKVMLxGCfk4oOe9JLHYkJJjMwx1SiM
         cIEhW4wwSGTcvByZ2zMnO6TJg2eb+JKjRF2RbRk8WQBVSwvdp8YwNthsF99s5GTpEv
         o1zmYF7L1VPFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 33/66] scsi: atari_scsi: Fix race condition between .queuecommand and EH
Date:   Tue, 22 Dec 2020 21:22:19 -0500
Message-Id: <20201223022253.2793452-33-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 03fe6a640a05c5dc04b6bcdddfb981d015e84ed4 ]

It is possible that bus_reset_cleanup() or .eh_abort_handler could be
invoked during NCR5380_queuecommand(). If that takes place before the new
command is enqueued and after the ST-DMA "lock" has been acquired, the
ST-DMA "lock" will be released again. This will result in a lost DMA
interrupt and a command timeout. Fix this by excluding EH and interrupt
handlers while the new command is enqueued.

Link: https://lore.kernel.org/r/af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c    |  9 ++++++---
 drivers/scsi/atari_scsi.c | 10 +++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 79b0b4eece194..d8268abf5a307 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -559,11 +559,14 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 
 	cmd->result = 0;
 
-	if (!NCR5380_acquire_dma_irq(instance))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	spin_lock_irqsave(&hostdata->lock, flags);
 
+	if (!NCR5380_acquire_dma_irq(instance)) {
+		spin_unlock_irqrestore(&hostdata->lock, flags);
+
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	/*
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
 	 * commands are added to the head of the queue since any command will
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 764c46d7333e6..42f11c8815a7f 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -376,15 +376,11 @@ static int falcon_get_lock(struct Scsi_Host *instance)
 	if (IS_A_TT())
 		return 1;
 
-	if (stdma_is_locked_by(scsi_falcon_intr) &&
-	    instance->hostt->can_queue > 1)
+	if (stdma_is_locked_by(scsi_falcon_intr))
 		return 1;
 
-	if (in_interrupt())
-		return stdma_try_lock(scsi_falcon_intr, instance);
-
-	stdma_lock(scsi_falcon_intr, instance);
-	return 1;
+	/* stdma_lock() may sleep which means it can't be used here */
+	return stdma_try_lock(scsi_falcon_intr, instance);
 }
 
 #ifndef MODULE
-- 
2.27.0

