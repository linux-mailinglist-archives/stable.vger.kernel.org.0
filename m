Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB252E153D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgLWCsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729560AbgLWCWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77169229C5;
        Wed, 23 Dec 2020 02:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690111;
        bh=A//1FcQ0hG5Dy2GXj2HyetJnjQgebC+vhG8uDwqR5DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYUIzaVsBx09aXkzAMDCOjg2ZyZQxXYvSCiIrVFiwR1qG8LodVWC0u68i32tf1fqH
         Jig3zc0LSj/XVMroI/ovx9NBgYUK3DpZxeJSfLMgkxtujVB3zqJrL4R63yLwclAD72
         gx8nU66oa1W3SU6uwE8xKOZaH/Vjpj+K8V41iv1OGJFm+I14l8BgrrDpHpm1YBHYcI
         rNoTwEC+pqCGc5tDHZjsb49cNHqxJl5RRWeRowdR56udJd19VLibMCAoICiqLjXacj
         r2SE1cjtEtigILFto06HbbwD8n6yRAeIpMnSULel8c5CUChELfql33I/UUjH7ow0cC
         2iseFbASpHvsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/87] scsi: atari_scsi: Fix race condition between .queuecommand and EH
Date:   Tue, 22 Dec 2020 21:20:15 -0500
Message-Id: <20201223022103.2792705-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 95a3e3bf2b431..7907694013fc1 100644
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

