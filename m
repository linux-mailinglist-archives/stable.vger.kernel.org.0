Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC54AFA47
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiBISgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbiBISgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5DBC05CB89;
        Wed,  9 Feb 2022 10:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 450ECB82215;
        Wed,  9 Feb 2022 18:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B99BC340E7;
        Wed,  9 Feb 2022 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431757;
        bh=6/MJlN4D+u2Izj5e6pmAQsQyvpaI1DPBFEkO3nYZM6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrS60MNf4hvdZ1VEWXsMkB9P8Gh5Om2lXLYQhCTs+iobOwcJ5DefuPuy2Ionwwmbj
         j4d5eTXzPZ4BxroegTH1PH+W24wqhkrajVLq1gbWfwBlBSff/lL0Ny7Trfz1YLcnZZ
         RkVQF/OFa6rkfFvKgfsQp53xVT4EmaeGxT+31Eg5dAQ9p3bfvHqCyRGl/P3K/pfGaw
         nfadVxP0/nzAlLWfVvzoGXRUsAl7GOyLZQybshFVmeJb/RvyyAolYFPHzbxh3TO+xW
         qlWyEQYOK7gJlsy2soNM6jV8hvaFwyci0SXmZAsWmCa1nZuWhtoJzF6Trn4jv0DaUC
         7+gIx5bL9vCJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 25/42] scsi: pm80xx: Fix double completion for SATA devices
Date:   Wed,  9 Feb 2022 13:32:57 -0500
Message-Id: <20220209183335.46545-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit c26b85ea16365079be8d206b20556a60a0c69ad4 ]

Current code handles completions for SATA devices in mpi_sata_completion()
and mpi_sata_event().

However, at the time when any SATA event happens, for almost all the event
types, the command is still in the target. It is therefore incorrect to
complete the task in sata_event().

There are some events for which we get sata_completions, some need recovery
procedure and others abort. All the tasks must be completed via
sata_completion() path.

Removed the task done related code from sata_events().  For tasks where we
don't get completions, let top layer call abort() to abort the command post
timeout.

Link: https://lore.kernel.org/r/20220124082255.86223-1-Ajish.Koshy@microchip.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Co-developed-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 18 ------------------
 drivers/scsi/pm8001/pm80xx_hwi.c | 26 --------------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 4390c8b9170cd..066290dd57565 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2695,7 +2695,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
 
@@ -2735,8 +2734,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2778,7 +2775,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2864,20 +2860,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 2101fc5761c3c..d37365b2e88ee 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2828,7 +2828,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
 
@@ -2866,8 +2865,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2916,11 +2913,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			spin_unlock_irqrestore(&circularQ->oq_lock,
-					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-			spin_lock_irqsave(&circularQ->oq_lock,
-					circularQ->lock_flags);
 			return;
 		}
 		break;
@@ -3020,24 +3012,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		spin_unlock_irqrestore(&circularQ->oq_lock,
-				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-		spin_lock_irqsave(&circularQ->oq_lock,
-				circularQ->lock_flags);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
-- 
2.34.1

