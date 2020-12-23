Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032FB2E12DB
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgLWCZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbgLWCZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A62C22525;
        Wed, 23 Dec 2020 02:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690286;
        bh=KUEnrIs0D42/+C4dmqdpOYzNx6TIP+q1Cl9AJKQgwbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbZpYtW+KMJUCO3zKscfmgoSmb/ReicFGvlO2N9dcUXYjlmT2VgGPkjucxGwyGq7F
         bWikXON6PfRchWZmv5cmyAPQCzsdm3TcGkS7L00jKphznVtEWzD5lFhDl4z0bWveLK
         8+rqe8PhOtLhDFkf+cqzowiwBbMk+uU+qnLAoAvtqmBjQAevHhMU2MbpDd1pocWqeT
         cKZeDMn4bTmmpyjtIaCNoJOfCknidgvjHZDpLqZkuyLmk2CVTxhDjWlq1y5cxaXv+L
         W2es4kO/lcN9BgVCfFDcI9Y0/awNtgrjGPfThaDeCK0ScBhtZumoGIYdR2g51HK0KE
         TRddBVwtVqLuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 24/48] scsi: atari_scsi: Fix race condition between .queuecommand and EH
Date:   Tue, 22 Dec 2020 21:23:52 -0500
Message-Id: <20201223022417.2794032-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 27270631c70c2..c689b0e8ce4c9 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -659,11 +659,14 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 
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
index 9dc4b689f94b0..de06ce9f18810 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -411,15 +411,11 @@ static int falcon_get_lock(struct Scsi_Host *instance)
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

