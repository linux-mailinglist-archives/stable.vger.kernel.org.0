Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E110176C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfKSFnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbfKSFnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9741721939;
        Tue, 19 Nov 2019 05:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142203;
        bh=RTN9fRlW3hdSlWehYKYMeAfRyZpS7tmEpqOc3F+6y0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaRe8XJdmL/XnPCYHk8RCK8NFHtToz7DjEoMW8hStZkVjWOzb3EY1Rl3z2YGKrgVR
         f3nsephPhrcRXfZUZ1+hne7vGJ9QH79brzMYYbPRFo8F8OHTXJXZVhygKmnhd3XxDs
         6Uu2Oc+6mQ3XC9v1aogEhf5wEAY2VQ4LXBPe5FgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 400/422] scsi: NCR5380: Have NCR5380_select() return a bool
Date:   Tue, 19 Nov 2019 06:19:57 +0100
Message-Id: <20191119051425.063628516@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit dad8261e643849ea134c7cd5c8e794e31d93b9eb ]

The return value is taken to mean "retry" or "don't retry". Change it to bool
to improve readability. Fix related comments. No functional change.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 46 +++++++++++++++++++-----------------------
 drivers/scsi/NCR5380.h |  2 +-
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d0bbb20518048..d600d3e94ba4a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -904,20 +904,16 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-/*
- * Function : int NCR5380_select(struct Scsi_Host *instance,
- * struct scsi_cmnd *cmd)
- *
- * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- * including ARBITRATION, SELECTION, and initial message out for
- * IDENTIFY and queue messages.
+/**
+ * NCR5380_select - attempt arbitration and selection for a given command
+ * @instance: the Scsi_Host instance
+ * @cmd: the scsi_cmnd to execute
  *
- * Inputs : instance - instantiation of the 5380 driver on which this
- * target lives, cmd - SCSI command to execute.
+ * This routine establishes an I_T_L nexus for a SCSI command. This involves
+ * ARBITRATION, SELECTION and MESSAGE OUT phases and an IDENTIFY message.
  *
- * Returns cmd if selection failed but should be retried,
- * NULL if selection failed and should not be retried, or
- * NULL if selection succeeded (hostdata->connected == cmd).
+ * Returns true if the operation should be retried.
+ * Returns false if it should not be retried.
  *
  * Side effects :
  * If bus busy, arbitration failed, etc, NCR5380_select() will exit
@@ -925,16 +921,15 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
  * SELECT_ENABLE will be set appropriately, the NCR5380
  * will cease to drive any SCSI bus signals.
  *
- * If successful : I_T_L or I_T_L_Q nexus will be established,
- * instance->connected will be set to cmd.
+ * If successful : the I_T_L nexus will be established, and
+ * hostdata->connected will be set to cmd.
  * SELECT interrupt will be disabled.
  *
  * If failed (no target) : cmd->scsi_done() will be called, and the
  * cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
-                                        struct scsi_cmnd *cmd)
+static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
@@ -942,6 +937,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	unsigned char *data;
 	int len;
 	int err;
+	bool ret = true;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -950,7 +946,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	/*
 	 * Arbitration and selection phases are slow and involve dropping the
 	 * lock, so we have to watch out for EH. An exception handler may
-	 * change 'selecting' to NULL. This function will then return NULL
+	 * change 'selecting' to NULL. This function will then return false
 	 * so that the caller will forget about 'cmd'. (During information
 	 * transfer phases, EH may change 'connected' to NULL.)
 	 */
@@ -986,7 +982,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		/* Command was aborted */
 		NCR5380_write(MODE_REG, MR_BASE);
-		return NULL;
+		return false;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
@@ -1035,7 +1031,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	if (!hostdata->selecting) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
@@ -1118,13 +1114,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
-			return NULL;
+			return false;
 
 		cmd->result = DID_BAD_TARGET << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance,
 			"target did not respond within 250ms\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1156,7 +1152,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	}
 	if (!hostdata->selecting) {
 		do_abort(instance);
-		return NULL;
+		return false;
 	}
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
@@ -1172,7 +1168,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 		cmd->result = DID_ERROR << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
-		cmd = NULL;
+		ret = false;
 		goto out;
 	}
 
@@ -1187,13 +1183,13 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 	initialize_SCp(cmd);
 
-	cmd = NULL;
+	ret = false;
 
 out:
 	if (!hostdata->selecting)
 		return NULL;
 	hostdata->selecting = NULL;
-	return cmd;
+	return ret;
 }
 
 /*
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 8a6d002e67894..5935fd6d1a058 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -275,7 +275,7 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
+static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
-- 
2.20.1



