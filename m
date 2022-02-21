Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBA4BE0AE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349009AbiBUJXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349708AbiBUJVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781F226AE7;
        Mon, 21 Feb 2022 01:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F666097C;
        Mon, 21 Feb 2022 09:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A1C340E9;
        Mon, 21 Feb 2022 09:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434526;
        bh=NXXxP9eJead7yDJFS3AsMRmxaxYo6g74u2L3g/6E63U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VOM2byqSbcin1vbJ8FpwTJBlEsF4Wovxce1KnOcmWBkS2pn13F7T4ZraK5KSPohU
         YjYPSIbGowoNpbIw7kw+p9yNP9gxWg1huWwS7J+doZRvToUMZhjD1e2ePasjFgOrSC
         cIXOchCsoaytEmp6sh8bOBTiCSHHCxCUsDJ7XC2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/196] scsi: pm80xx: Fix double completion for SATA devices
Date:   Mon, 21 Feb 2022 09:47:50 +0100
Message-Id: <20220221084932.210631590@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 880e1f356defc..5e6b23da4157c 100644
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
index ed13e0e044b74..2cd100c062aba 100644
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



