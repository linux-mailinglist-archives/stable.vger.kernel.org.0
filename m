Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A905073D2A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404300AbfGXTyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403997AbfGXTyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB0620665;
        Wed, 24 Jul 2019 19:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998051;
        bh=jm7lTZQ3XOFpAE3QuyPcxasLsOKLerZUFhgL1v3gfqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHEuDf+dkD3neaeCeGL1+hcbBi0Cb243MtFCnq/SmS79g9IsrZ2NG98M9UfRYU0JY
         bILu2ayWio+G2kuvqZaEVEB2QYx/faHb5xeAuKykdSv8QzbpKLXLOLoy3Y9o6o8QWE
         Okr4t/sJNbusaQzZ1vFSdcgXAtlR8xLviK/r0Rsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 229/371] scsi: NCR5380: Always re-enable reselection interrupt
Date:   Wed, 24 Jul 2019 21:19:41 +0200
Message-Id: <20190724191741.667269406@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
@@ -710,6 +710,8 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		if (!hostdata->connected)
+			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		spin_unlock_irq(&hostdata->lock);
 		if (!done)
 			cond_resched();
@@ -1111,8 +1113,6 @@ static bool NCR5380_select(struct Scsi_H
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
-		if (!hostdata->connected)
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
 		goto out;
 	}
@@ -1120,7 +1120,6 @@ static bool NCR5380_select(struct Scsi_H
 	if (err < 0) {
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
 		/* Can't touch cmd if it has been reclaimed by the scsi ML */
 		if (!hostdata->selecting)
@@ -1158,7 +1157,6 @@ static bool NCR5380_select(struct Scsi_H
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		goto out;
 	}
 	if (!hostdata->selecting) {
@@ -1827,9 +1825,6 @@ static void NCR5380_information_transfer
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-
 					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
@@ -1861,8 +1856,6 @@ static void NCR5380_information_transfer
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 #ifdef SUN3_SCSI_VME
 					dregs->csr |= CSR_DMA_ENABLE;
 #endif
@@ -1965,7 +1958,6 @@ static void NCR5380_information_transfer
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
 				msgout = NOP;


