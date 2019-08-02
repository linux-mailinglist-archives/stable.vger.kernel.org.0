Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327527F406
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391232AbfHBJnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391954AbfHBJnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D7BB20679;
        Fri,  2 Aug 2019 09:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738994;
        bh=BNjn9YxPzNl3/wZkvHFhI70VUuK9qv3cMeiVmH51GzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pqyKB1DVj7qjNAL/+YtHdHnY0/0sXUy73SfPiYSXokzqspe41klEg7Cw2qcJRjLF
         yujfK1zC/PWPanqqlUF9uqHxzs+RjOBFoMrOEx2eJRjED10dvjrWUBMfogFHleIi+c
         eyGZ9YyAcQhryTL8mN/Q9IQjY/hw2/dlXCRhfDzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 076/223] scsi: NCR5380: Always re-enable reselection interrupt
Date:   Fri,  2 Aug 2019 11:35:01 +0200
Message-Id: <20190802092243.758580816@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 57f31326518e98ee4cabf9a04efe00ed57c54147 upstream.

The reselection interrupt gets disabled during selection and must be
re-enabled when hostdata->connected becomes NULL. If it isn't re-enabled a
disconnected command may time-out or the target may wedge the bus while
trying to reselect the host. This can happen after a command is aborted.

Fix this by enabling the reselection interrupt in NCR5380_main() after
calls to NCR5380_select() and NCR5380_information_transfer() return.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.9+
Fixes: 8b00c3d5d40d ("ncr5380: Implement new eh_abort_handler")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/NCR5380.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -813,6 +813,8 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		if (!hostdata->connected)
+			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		spin_unlock_irq(&hostdata->lock);
 		if (!done)
 			cond_resched();
@@ -1208,8 +1210,6 @@ static struct scsi_cmnd *NCR5380_select(
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
-		if (!hostdata->connected)
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
 		goto out;
 	}
@@ -1217,7 +1217,6 @@ static struct scsi_cmnd *NCR5380_select(
 	if (err < 0) {
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
@@ -1255,7 +1254,6 @@ static struct scsi_cmnd *NCR5380_select(
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		goto out;
 	}
 	if (!hostdata->selecting) {
@@ -1906,9 +1904,6 @@ static void NCR5380_information_transfer
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-
 					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
@@ -1940,8 +1935,6 @@ static void NCR5380_information_transfer
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 #ifdef SUN3_SCSI_VME
 					dregs->csr |= CSR_DMA_ENABLE;
 #endif
@@ -2049,7 +2042,6 @@ static void NCR5380_information_transfer
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
 				msgout = NOP;


