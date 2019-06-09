Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893E13A2C5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 03:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfFIB1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 21:27:18 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59934 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfFIB0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 21:26:44 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id B1D6327868; Sat,  8 Jun 2019 21:26:42 -0400 (EDT)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1560043151.git.fthain@telegraphics.com.au>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection interrupt
Date:   Sun, 09 Jun 2019 11:19:11 +1000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The reselection interrupt gets disabled during selection and must be
re-enabled when hostdata->connected becomes NULL. If it isn't re-enabled
a disconnected command may time-out or the target may wedge the bus while
trying to reselect the host. This can happen after a command is aborted.

Fix this by enabling the reselection interrupt in NCR5380_main() after
calls to NCR5380_select() and NCR5380_information_transfer() return.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.9+
Fixes: 8b00c3d5d40d ("ncr5380: Implement new eh_abort_handler")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index fe0535affc14..08e3ea8159b3 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -709,6 +709,8 @@ static void NCR5380_main(struct work_struct *work)
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		if (!hostdata->connected)
+			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		spin_unlock_irq(&hostdata->lock);
 		if (!done)
 			cond_resched();
@@ -1110,8 +1112,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
-		if (!hostdata->connected)
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
 		goto out;
 	}
@@ -1119,7 +1119,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	if (err < 0) {
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
@@ -1157,7 +1156,6 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		goto out;
 	}
 	if (!hostdata->selecting) {
@@ -1826,9 +1824,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-
 					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
@@ -1860,8 +1855,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 #ifdef SUN3_SCSI_VME
 					dregs->csr |= CSR_DMA_ENABLE;
 #endif
@@ -1964,7 +1957,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
 				msgout = NOP;
-- 
2.21.0

