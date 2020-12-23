Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82AF2E164F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgLWCSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgLWCSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2493D23159;
        Wed, 23 Dec 2020 02:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689828;
        bh=bUi5pNUlgRGTgdMmqZXGZ8yVikp365KGVDm2i1OTsIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQy308CLwJojUy7p/1B08Zn1cPvfnWAF0BiSq0xRulVJYT/bwFmY3MR7nRq/Pxkzo
         D9Nc2gWLCC+G8b3xDfg+ySbHf5NC+rVhb8hGUpIqKiTsKM8Y8reZa4T19aWk4lw5AU
         t9SRZUu5akIzQ/ZxXaklOKKx2ve4dSgx8LdOh76Z/fFrlHRMIsgVQd982iyPbJwQcI
         yuwXRasfZOnE+zzrCU6dnfqj2CIIM9y3C6RD2zkCTf4NaP8qyFMGOqEHIJri/LikSk
         18rcOsf+rKoxh6japmojWWeDHFMaoA/GX/t09Cb934cn6OsP3YFzUSBuy2rZfOTWp5
         Ai4L7k4CHzlPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 031/217] scsi: pm80xx: Make running_req atomic
Date:   Tue, 22 Dec 2020 21:13:20 -0500
Message-Id: <20201223021626.2790791-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 597d7a096a972..9e9a546da9590 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1587,7 +1587,7 @@ void pm8001_work_fn(struct work_struct *work)
 		ts->stat = SAS_QUEUE_FULL;
 		pm8001_dev = ccb->device;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		spin_lock_irqsave(&t->task_state_lock, flags1);
 		t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 		t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
@@ -1942,7 +1942,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			sas_ssp_task_response(pm8001_ha->dev, t, iu);
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1958,7 +1958,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2172,7 +2172,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2487,7 +2487,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					pm8001_printk("response to large\n"));
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2495,7 +2495,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
@@ -2506,19 +2506,23 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
@@ -2526,6 +2530,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2534,6 +2540,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2541,6 +2549,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2548,6 +2558,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2587,6 +2599,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2610,48 +2624,64 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
@@ -2672,6 +2702,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("  IO_DS_IN_RECOVERY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2693,6 +2725,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_DEVIO_DBG(pm8001_ha,
@@ -2700,6 +2734,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	spin_lock_irqsave(&t->task_state_lock, flags);
@@ -2776,7 +2812,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2976,7 +3012,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2984,7 +3020,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
@@ -2992,7 +3028,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3cf3e58b69799..fb471ad3720a7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -412,7 +412,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
 		pm8001_ha->devices[i].id = i;
 		pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
-		pm8001_ha->devices[i].running_req = 0;
+		atomic_set(&pm8001_ha->devices[i].running_req, 0);
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
 	/* Initialize tags */
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 9889bab7d31c1..d6e0bc5886989 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -456,9 +456,11 @@ static int pm8001_task_exec(struct sas_task *task,
 		ccb->device = pm8001_dev;
 		switch (task_proto) {
 		case SAS_PROTOCOL_SMP:
+			atomic_inc(&pm8001_dev->running_req);
 			rc = pm8001_task_prep_smp(pm8001_ha, ccb);
 			break;
 		case SAS_PROTOCOL_SSP:
+			atomic_inc(&pm8001_dev->running_req);
 			if (is_tmf)
 				rc = pm8001_task_prep_ssp_tm(pm8001_ha,
 					ccb, tmf);
@@ -467,6 +469,7 @@ static int pm8001_task_exec(struct sas_task *task,
 			break;
 		case SAS_PROTOCOL_SATA:
 		case SAS_PROTOCOL_STP:
+			atomic_inc(&pm8001_dev->running_req);
 			rc = pm8001_task_prep_ata(pm8001_ha, ccb);
 			break;
 		default:
@@ -479,13 +482,13 @@ static int pm8001_task_exec(struct sas_task *task,
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
@@ -886,11 +889,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
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
@@ -968,7 +971,7 @@ void pm8001_open_reject_retry(
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		spin_lock_irqsave(&task->task_state_lock, flags1);
 		task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 		task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 95663e1380833..091574721ea19 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -293,7 +293,7 @@ struct pm8001_device {
 	struct completion	*dcompletion;
 	struct completion	*setds_completion;
 	u32			device_id;
-	u32			running_req;
+	atomic_t		running_req;
 };
 
 struct pm8001_prd_imt {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5fe50e0effcd5..1ba93fb76093b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1960,13 +1960,15 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
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
@@ -1977,13 +1979,15 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
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
@@ -1992,6 +1996,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_OPEN_REJECT;
 		/* Force the midlayer to retry */
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1999,6 +2005,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_INVALID_SSP_RSP_FRAME:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2006,6 +2014,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2013,6 +2023,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2020,6 +2032,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2027,6 +2041,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 	case IO_XFER_OPEN_RETRY_BACKOFF_THRESHOLD_REACHED:
@@ -2050,6 +2066,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -2057,6 +2075,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2064,6 +2084,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2071,18 +2093,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
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
@@ -2090,18 +2118,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
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
@@ -2118,18 +2152,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
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
@@ -2137,6 +2177,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_DEVIO_DBG(pm8001_ha,
@@ -2144,6 +2186,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	PM8001_IO_DBG(pm8001_ha,
@@ -2203,7 +2247,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2528,7 +2572,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					pm8001_printk("response too large\n"));
 		}
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2536,7 +2580,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
@@ -2547,19 +2591,23 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
@@ -2567,6 +2615,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -2574,6 +2624,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2581,6 +2633,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2588,6 +2642,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 	case IO_XFER_OPEN_RETRY_BACKOFF_THRESHOLD_REACHED:
@@ -2631,6 +2687,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
@@ -2653,48 +2711,64 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
@@ -2715,6 +2789,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("IO_DS_IN_RECOVERY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
 		PM8001_IO_DBG(pm8001_ha,
@@ -2736,6 +2812,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
 		PM8001_DEVIO_DBG(pm8001_ha,
@@ -2743,6 +2821,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
+		if (pm8001_dev)
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
 	spin_lock_irqsave(&t->task_state_lock, flags);
@@ -2820,7 +2900,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
@@ -3040,7 +3120,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
 			PM8001_IO_DBG(pm8001_ha,
 				pm8001_printk("DIRECT RESPONSE Length:%d\n",
@@ -3063,7 +3143,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
@@ -3071,7 +3151,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
 		if (pm8001_dev)
-			pm8001_dev->running_req--;
+			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
@@ -4809,6 +4889,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 							flags);
 				pm8001_ccb_task_free_done(pm8001_ha, task,
 								ccb, tag);
+				atomic_dec(&pm8001_ha_dev->running_req);
 				return 0;
 			}
 		}
-- 
2.27.0

