Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA02E166B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgLWCTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgLWCTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4EFC2222D;
        Wed, 23 Dec 2020 02:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689908;
        bh=6DLSlA0kd1A4W8gpwIZBpWDNUVNfIJH2BZmCKbY3Lk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvcSKIFP38tbz7bbYHsuNTX35C0yw71u84/Sk0kEPSMbsFbzFXxqWrjIJJCi/zcLU
         zRz83KG4jyXQj+dYvvMIFLSoprE5W56TlA8FfwubvEkMHE0g/aQThSmgkr+oc8H84h
         x/zFFEp+gM3zVOvjxDwEG/6rzwoLqxhSQViL7zSTeNEEQYjUqrQk93lgdhZwEMDmsC
         j5cDgP1ASFuSsCNUm7c+z+mdJac7ZyrivSFBxmZ9P3Ri/C7T0blel6Em8uC94Pszv3
         6Jztf3KaiMjRr+3dblOYyvs3SSPZAEQIyyGQ6cteh4OqBdNO6vh6PKrGPURFJUXvB5
         NFDbuu1Sb1/mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 011/130] scsi: pm80xx: Make running_req atomic
Date:   Tue, 22 Dec 2020 21:16:14 -0500
Message-Id: <20201223021813.2791612-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

[ Upstream commit 4a2efd4b89fcaa6e9a7b4ce49a441afaacba00ea ]

Incorrect value of the running_req was causing the driver unload to be
stuck during the SAS lldd_dev_gone notification handling.  During SATA I/O
completion, for some error status values, the driver schedules the event
handler and running_req is decremented from that.  However, there are some
other error status values (like IO_DS_IN_RECOVERY,
IO_XFER_ERR_LAST_PIO_DATAIN_CRC_ERR) where the I/O has already been
completed by fw/driver so running_req is not decremented.

Also during NCQ error handling, driver itself will initiate READ_LOG_EXT
and ABORT_ALL. When libsas/libata initiate READ_LOG_EXT (0x2F), driver
increments running_req. This will be completed by the driver in
pm80xx_chip_sata_req(), but running_req was not decremented.

Link: https://lore.kernel.org/r/20201102165528.26510-3-Viswas.G@microchip.com.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |  58 +++++++++++++----
 drivers/scsi/pm8001/pm8001_init.c |   2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  11 ++--
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 101 +++++++++++++++++++++++++++---
 5 files changed, 147 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 68a8217032d0f..f8e11f672d1e2 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1558,7 +1558,7 @@ void pm8001_work_fn(struct work_struct *work)
 		ts->stat = SAS_QUEUE_FULL;
 		pm8001_dev = ccb->device;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		spin_lock_irqsave(&t->task_state_lock, flags1);
 		t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 		t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
@@ -1905,7 +1905,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			sas_ssp_task_response(pm8001_ha->dev, t, iu);
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1921,7 +1921,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2135,7 +2135,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2444,7 +2444,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					pm8001_printk("response to large\n"));
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2452,7 +2452,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
@@ -2463,19 +2463,23 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual =  param;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_NO_DEVICE\n"));
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2483,6 +2487,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2491,6 +2497,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2498,6 +2506,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2505,6 +2515,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2544,6 +2556,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2567,48 +2581,64 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_DMA\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_SATA_LINK_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_SATA_LINK_TIMEOUT\n"));
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_PORT_IN_RESET\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2629,6 +2659,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("  IO_DS_IN_RECOVERY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2650,6 +2682,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2657,6 +2691,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	spin_lock_irqsave(&t->task_state_lock, flags);
@@ -2733,7 +2769,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2929,7 +2965,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2937,7 +2973,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
@@ -2945,7 +2981,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3374f553c617a..1fa9d68255686 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -368,7 +368,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
 		pm8001_ha->devices[i].id = i;
 		pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
-		pm8001_ha->devices[i].running_req = 0;
+		atomic_set(&pm8001_ha->devices[i].running_req, 0);
 	}
 	pm8001_ha->ccb_info = pm8001_ha->memoryMap.region[CCB_MEM].virt_ptr;
 	for (i = 0; i < PM8001_MAX_CCB; i++) {
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 36f5bab09f73e..4d3015d49c872 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -454,9 +454,11 @@ static int pm8001_task_exec(struct sas_task *task,
 		ccb->device = pm8001_dev;
 		switch (t->task_proto) {
 		case SAS_PROTOCOL_SMP:
+			atomic_inc(&pm8001_dev->running_req);
 			rc = pm8001_task_prep_smp(pm8001_ha, ccb);
 			break;
 		case SAS_PROTOCOL_SSP:
+			atomic_inc(&pm8001_dev->running_req);
 			if (is_tmf)
 				rc = pm8001_task_prep_ssp_tm(pm8001_ha,
 					ccb, tmf);
@@ -465,6 +467,7 @@ static int pm8001_task_exec(struct sas_task *task,
 			break;
 		case SAS_PROTOCOL_SATA:
 		case SAS_PROTOCOL_STP:
+			atomic_inc(&pm8001_dev->running_req);
 			rc = pm8001_task_prep_ata(pm8001_ha, ccb);
 			break;
 		default:
@@ -478,13 +481,13 @@ static int pm8001_task_exec(struct sas_task *task,
 		if (rc) {
 			PM8001_IO_DBG(pm8001_ha,
 				pm8001_printk("rc is %x\n", rc));
+			atomic_dec(&pm8001_dev->running_req);
 			goto err_out_tag;
 		}
 		/* TODO: select normal or high priority */
 		spin_lock(&t->task_state_lock);
 		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
 		spin_unlock(&t->task_state_lock);
-		pm8001_dev->running_req++;
 	} while (0);
 	rc = 0;
 	goto out_done;
@@ -884,11 +887,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		PM8001_DISC_DBG(pm8001_ha,
 			pm8001_printk("found dev[%d:%x] is gone.\n",
 			pm8001_dev->device_id, pm8001_dev->dev_type));
-		if (pm8001_dev->running_req) {
+		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 				dev, 1, 0);
-			while (pm8001_dev->running_req)
+			while (atomic_read(&pm8001_dev->running_req))
 				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
@@ -966,7 +969,7 @@ void pm8001_open_reject_retry(
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		spin_lock_irqsave(&task->task_state_lock, flags1);
 		task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 		task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ff17c6aff63dc..161a12f884ad3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -279,7 +279,7 @@ struct pm8001_device {
 	struct completion	*dcompletion;
 	struct completion	*setds_completion;
 	u32			device_id;
-	u32			running_req;
+	atomic_t		running_req;
 };
 
 struct pm8001_prd_imt {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 161bf4760eac7..8756bbf2c3896 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1593,13 +1593,15 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			sas_ssp_task_response(pm8001_ha->dev, t, iu);
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_ABORTED IOMB Tag\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_UNDERFLOW:
 		/* SSP Completion with error */
@@ -1610,13 +1612,15 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_NO_DEVICE\n"));
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1625,6 +1629,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_OPEN_REJECT;
 		/* Force the midlayer to retry */
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1632,6 +1638,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_INVALID_SSP_RSP_FRAME:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1639,6 +1647,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1646,6 +1656,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1653,6 +1665,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1660,6 +1674,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 	case IO_XFER_OPEN_RETRY_BACKOFF_THRESHOLD_REACHED:
@@ -1683,6 +1699,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -1690,6 +1708,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1697,6 +1717,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1704,18 +1726,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
 		PM8001_IO_DBG(pm8001_ha,
 		pm8001_printk("IO_XFER_ERROR_DMA\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1723,18 +1751,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_PORT_IN_RESET\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1751,18 +1785,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			pm8001_printk("IO_DS_IN_RECOVERY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_TM_TAG_NOT_FOUND:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_TM_TAG_NOT_FOUND\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_SSP_EXT_IU_ZERO_LEN_ERROR:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_SSP_EXT_IU_ZERO_LEN_ERROR\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1770,6 +1810,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1777,6 +1819,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	PM8001_IO_DBG(pm8001_ha,
@@ -1836,7 +1880,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2155,7 +2199,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					pm8001_printk("response to large\n"));
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2163,7 +2207,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
@@ -2174,19 +2218,23 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_NO_DEVICE\n"));
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2194,6 +2242,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -2201,6 +2251,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2208,6 +2260,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2215,6 +2269,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 	case IO_XFER_OPEN_RETRY_BACKOFF_THRESHOLD_REACHED:
@@ -2258,6 +2314,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -2280,48 +2338,64 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_DMA\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_SATA_LINK_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_SATA_LINK_TIMEOUT\n"));
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_PORT_IN_RESET\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2342,6 +2416,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("IO_DS_IN_RECOVERY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2363,6 +2439,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2370,6 +2448,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	spin_lock_irqsave(&t->task_state_lock, flags);
@@ -2447,7 +2527,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2664,7 +2744,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
 			PM8001_IO_DBG(pm8001_ha,
 				pm8001_printk("DIRECT RESPONSE Length:%d\n",
@@ -2687,7 +2767,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
@@ -2695,7 +2775,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
@@ -4437,6 +4517,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 							flags);
 				pm8001_ccb_task_free_done(pm8001_ha, task,
 								ccb, tag);
+				atomic_dec(&pm8001_ha_dev->running_req);
 				return 0;
 			}
 		}
-- 
2.27.0

