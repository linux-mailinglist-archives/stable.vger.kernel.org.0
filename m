Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E1F6576
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfKJCpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfKJCpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00ECE21848;
        Sun, 10 Nov 2019 02:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353912;
        bh=8rbmtpldHDjAVBllvO0dEMbGabQaK4sSUgB216Vo5Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDQGTOI7N2V3MjxCSrkZnGzHe4Lzhd/Hv5zY1I2Hl7NZU18DxTSVZaIQ59zuHUFcn
         /ei+6pxXceGThKY8ZDGiQHPiHyclJQekVqPgV0cgNQrPLTAXNDsDrFuZeC7H/N9WHs
         kSsMzhmUE2kJ7HijV/5CflYeAnViyEpCn46qD5ZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 176/191] scsi: NCR5380: Check for bus reset
Date:   Sat,  9 Nov 2019 21:39:58 -0500
Message-Id: <20191110024013.29782-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 6b0e87a6aafe12d75c2bea6fc8e49e88b98b3083 ]

The SR_RST bit isn't latched. Hence, detecting a bus reset isn't reliable.
When it is detected, the right thing to do is to drop all connected and
disconnected commands. The code for that is already present so refactor it and
call it when SR_RST is set.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 74 +++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index bce6c990d060a..8ec68dcc0cc4a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -131,6 +131,7 @@
 
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
+static void bus_reset_cleanup(struct Scsi_Host *);
 
 /**
  * initialize_SCp - init the scsi pointer field
@@ -885,7 +886,14 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 			/* Probably Bus Reset */
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-			dsprintk(NDEBUG_INTR, instance, "unknown interrupt\n");
+			if (sr & SR_RST) {
+				/* Certainly Bus Reset */
+				shost_printk(KERN_WARNING, instance,
+					     "bus reset interrupt\n");
+				bus_reset_cleanup(instance);
+			} else {
+				dsprintk(NDEBUG_INTR, instance, "unknown interrupt\n");
+			}
 #ifdef SUN3_SCSI_VME
 			dregs->csr |= CSR_DMA_ENABLE;
 #endif
@@ -2297,31 +2305,12 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 }
 
 
-/**
- * NCR5380_host_reset - reset the SCSI host
- * @cmd: SCSI command undergoing EH
- *
- * Returns SUCCESS
- */
-
-static int NCR5380_host_reset(struct scsi_cmnd *cmd)
+static void bus_reset_cleanup(struct Scsi_Host *instance)
 {
-	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
-	unsigned long flags;
 	struct NCR5380_cmd *ncmd;
 
-	spin_lock_irqsave(&hostdata->lock, flags);
-
-#if (NDEBUG & NDEBUG_ANY)
-	shost_printk(KERN_INFO, instance, __func__);
-#endif
-	NCR5380_dprint(NDEBUG_ANY, instance);
-	NCR5380_dprint_phase(NDEBUG_ANY, instance);
-
-	do_reset(instance);
-
 	/* reset NCR registers */
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2333,14 +2322,6 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	 * commands!
 	 */
 
-	list_for_each_entry(ncmd, &hostdata->unissued, list) {
-		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
-
-		cmd->result = DID_RESET << 16;
-		cmd->scsi_done(cmd);
-	}
-	INIT_LIST_HEAD(&hostdata->unissued);
-
 	if (hostdata->selecting) {
 		hostdata->selecting->result = DID_RESET << 16;
 		complete_cmd(instance, hostdata->selecting);
@@ -2374,6 +2355,41 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
 	maybe_release_dma_irq(instance);
+}
+
+/**
+ * NCR5380_host_reset - reset the SCSI host
+ * @cmd: SCSI command undergoing EH
+ *
+ * Returns SUCCESS
+ */
+
+static int NCR5380_host_reset(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long flags;
+	struct NCR5380_cmd *ncmd;
+
+	spin_lock_irqsave(&hostdata->lock, flags);
+
+#if (NDEBUG & NDEBUG_ANY)
+	shost_printk(KERN_INFO, instance, __func__);
+#endif
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
+
+	list_for_each_entry(ncmd, &hostdata->unissued, list) {
+		struct scsi_cmnd *scmd = NCR5380_to_scmd(ncmd);
+
+		scmd->result = DID_RESET << 16;
+		scmd->scsi_done(scmd);
+	}
+	INIT_LIST_HEAD(&hostdata->unissued);
+
+	do_reset(instance);
+	bus_reset_cleanup(instance);
+
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
-- 
2.20.1

