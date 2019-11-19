Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED74A10168D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfKSFy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731555AbfKSFy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37D72084D;
        Tue, 19 Nov 2019 05:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142867;
        bh=yj+ZWD0K3BDcREh8kod2zyytOsWEq5qxaxGRAjFCQuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/bn4QggQjFDegHeOFEqm3SqiqQuzH3ubtJUGtvjkDzB4wVfOktwr4iLtsKAaIkmu
         MpWIoWxr/dif5nhuAZAhqFUmNQXDeiTQ0y8027gfX3WQkLHEMeD0ip8ScQtGLYyuoY
         pAE7zEgvpudBDZApNO8VwKKfpCTxvVds1sVtBBfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 228/239] scsi: NCR5380: Check for bus reset
Date:   Tue, 19 Nov 2019 06:20:28 +0100
Message-Id: <20191119051340.826521599@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a85c5155fcf40..21377ac71168c 100644
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
@@ -2303,31 +2311,12 @@ out:
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
@@ -2339,14 +2328,6 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
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
@@ -2380,6 +2361,41 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 
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



