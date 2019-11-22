Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27373107032
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfKVKpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfKVKpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE2620718;
        Fri, 22 Nov 2019 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419513;
        bh=G6zvpt+DJmKU1FZM1LJkiwHRd+NsLNlOnyjrZk1GsLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNNk8ef1HusK69C/qEOnYD3RWahv0fILsDLpdc/oicu26xze9ySYTeOaI+tM2u/BG
         SIYHOaz7FHuQRka9KDN+4/vi14Dn48ELmBO7CfzsmZ8qm8ROlcqKvAJWr6UlpUKqhP
         iupjxyNU8Rw4LKCMPv+cgcyOqOirtBYtLt2asC6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 137/222] scsi: NCR5380: Dont clear busy flag when abort fails
Date:   Fri, 22 Nov 2019 11:27:57 +0100
Message-Id: <20191122100912.781673396@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 45ddc1b24806cc8f1a09f23dd4e7b6e4a8ae36e1 ]

When NCR5380_abort() returns FAILED, the driver forgets that the target is
still busy. Hence, further commands may be sent to the target, which may fail
during selection and produce the error message, "reselection after won
arbitration?". Prevent this by leaving the busy flag set when NCR5380_abort()
fails.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 15c0fff7519be..a4856eeac26f6 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -626,8 +626,6 @@ static void complete_cmd(struct Scsi_Host *instance,
 		hostdata->sensing = NULL;
 	}
 
-	hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
-
 	cmd->scsi_done(cmd);
 }
 
@@ -1799,6 +1797,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				cmd->result = DID_ERROR << 16;
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
+				hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1881,6 +1880,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					         cmd, scmd_id(cmd), cmd->device->lun);
 
 					hostdata->connected = NULL;
+					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
 					cmd->result &= ~0xffff;
 					cmd->result |= cmd->SCp.Status;
@@ -2040,6 +2040,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
+					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
@@ -2194,13 +2195,16 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		dsprintk(NDEBUG_RESELECTION | NDEBUG_QUEUES, instance,
 		         "reselect: removed %p from disconnected queue\n", tmp);
 	} else {
+		int target = ffs(target_mask) - 1;
+
 		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
 		             target_mask, lun);
 		/*
 		 * Since we have an established nexus that we can't do anything
 		 * with, we must abort it.
 		 */
-		do_abort(instance);
+		if (do_abort(instance) == 0)
+			hostdata->busy[target] &= ~(1 << lun);
 		return;
 	}
 
@@ -2368,8 +2372,10 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 out:
 	if (result == FAILED)
 		dsprintk(NDEBUG_ABORT, instance, "abort: failed to abort %p\n", cmd);
-	else
+	else {
+		hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 		dsprintk(NDEBUG_ABORT, instance, "abort: successfully aborted %p\n", cmd);
+	}
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
 	maybe_release_dma_irq(instance);
-- 
2.20.1



