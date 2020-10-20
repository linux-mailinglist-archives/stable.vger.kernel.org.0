Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CEB2943DF
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 22:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438469AbgJTU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 16:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438446AbgJTU1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 16:27:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45F5C0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t14so58200pgg.1
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=SozjB7NnqbTUXhgX9ijAa2ZrV6e9DcL7w3Br3jsji00=;
        b=eaNxpGtIXc24xDr7c6hJnd5OxlQ8+PvSDzR1lnd/GMfdVOxZjUQ6IjnBogsZK25tpQ
         sFW1OSaJvEzU2TpM6gYiB1ZeE0S9gdANUMRv0T4UjhoO8pItG0K1qAbW40aCUNgBztN6
         i/kXoNniAns4vnYVkhQ79bPcb0UXcMUdGfDB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=SozjB7NnqbTUXhgX9ijAa2ZrV6e9DcL7w3Br3jsji00=;
        b=ujxVB2AU7KKTfLez5EZnGQHo2ttmuTcGXHp61riSBJNePV+4eBX05IZBYoLxbDNRCS
         YUeWqI4rWVx+m9z7MwpwSFZYTU4KIiyNIXy5psQn8uxB9MbI3HMLaGupSrZVLl/wTFVa
         VcMl1o1GIi5njQNDG9xecrxQbl6TK7WHNv23TcKVSyTng/G88Q0cSC1qj7bcodW7wQ38
         pmYxTrUs2BP1+kvxZWyojFlFWgAl5wsJOC/0kBd3zUMXd1VyQ+0JOXdDil5AEV+YYqiQ
         p4hNzars62AHwFS5pCnLintR0tf58SOtfkDVPSf9ppMFuiUP5l+S7fOUcSx/omOv6KcV
         7IRQ==
X-Gm-Message-State: AOAM5308dg7uXqNnMQD9b3k2ca21J89i+tBAzHAc3dmFTVU4MTEBxlvO
        422swZpiooa3dnIQohXCpBSTXjx77In4Mw==
X-Google-Smtp-Source: ABdhPJzne3P1IcVyFLfKF4dP1bdAHPC27OThdZEuVGZQduC84H7PhiMa5lqrsRI4iAQ3D1MO6hWonA==
X-Received: by 2002:aa7:9048:0:b029:152:883a:9a94 with SMTP id n8-20020aa790480000b0290152883a9a94mr1606942pfo.24.1603225649028;
        Tue, 20 Oct 2020 13:27:29 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm2871404pfp.195.2020.10.20.13.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:27:28 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/9] lpfc: fix scheduling call while in softirq context in lpfc_unreg_rpi
Date:   Tue, 20 Oct 2020 13:27:12 -0700
Message-Id: <20201020202719.54726-3-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000572d6c05b2200f3b"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000572d6c05b2200f3b
Content-Transfer-Encoding: 8bit

The following call trace was seen during hba reset testing:

BUG: scheduling while atomic: swapper/2/0/0x10000100
...
Call Trace:
dump_stack+0x19/0x1b
__schedule_bug+0x64/0x72
__schedule+0x782/0x840
__cond_resched+0x26/0x30
_cond_resched+0x3a/0x50
mempool_alloc+0xa0/0x170
lpfc_unreg_rpi+0x151/0x630 [lpfc]
lpfc_sli_abts_recover_port+0x171/0x190 [lpfc]
lpfc_sli4_abts_err_handler+0xb2/0x1f0 [lpfc]
lpfc_sli4_io_xri_aborted+0x256/0x300 [lpfc]
lpfc_sli4_sp_handle_abort_xri_wcqe.isra.51+0xa3/0x190 [lpfc]
lpfc_sli4_fp_handle_cqe+0x89/0x4d0 [lpfc]
__lpfc_sli4_process_cq+0xdb/0x2e0 [lpfc]
__lpfc_sli4_hba_process_cq+0x41/0x100 [lpfc]
lpfc_cq_poll_hdler+0x1a/0x30 [lpfc]
irq_poll_softirq+0xc7/0x100
__do_softirq+0xf5/0x280
call_softirq+0x1c/0x30
do_softirq+0x65/0xa0
irq_exit+0x105/0x110
do_IRQ+0x56/0xf0
common_interrupt+0x16a/0x16a

With the conversion to blk_io_poll for better interrupt latency in normal
cases, it introduced this code path, executed when io aborts or logouts are
seen, which attempts to allocate memory for a mailbox command to be issued.
The allocation is GFP_KERNEL, thus it could attempt to sleep.

Fix by creating a work element that performs the event handling for the
remote port. This will have the mailbox commands and other items performed
in the work element, not the irq. A much better method as the "irq"
routine does not stall while performing all this deep handling code.

Ensure that allocation failures are handled and send LOGO on failure.

Additionally, enlarged the mailbox memory pool to reduce the possibility
of additional allocation in this path.

Fixes: 	317aeb83c92b ("scsi: lpfc: Add blk_io_poll support for latency improvment")
Cc: <stable@vger.kernel.org> # v5.9+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 +-
 drivers/scsi/lpfc/lpfc_disc.h    |  2 +
 drivers/scsi/lpfc/lpfc_hbadisc.c | 35 +++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    | 46 +++++++++++++----------
 drivers/scsi/lpfc/lpfc_mem.c     |  5 ++-
 drivers/scsi/lpfc/lpfc_nvme.c    | 18 ++++++---
 drivers/scsi/lpfc/lpfc_sli.c     | 64 ++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h    |  6 +--
 8 files changed, 136 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 549adfaa97ce..93e507677bdc 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -753,7 +753,7 @@ struct lpfc_hba {
 #define HBA_SP_QUEUE_EVT	0x8 /* Slow-path qevt posted to worker thread*/
 #define HBA_POST_RECEIVE_BUFFER 0x10 /* Rcv buffers need to be posted */
 #define HBA_PERSISTENT_TOPO	0x20 /* Persistent topology support in hba */
-#define ELS_XRI_ABORT_EVENT	0x40
+#define ELS_XRI_ABORT_EVENT	0x40 /* ELS_XRI abort event was queued */
 #define ASYNC_EVENT		0x80
 #define LINK_DISABLED		0x100 /* Link disabled by user */
 #define FCF_TS_INPROG           0x200 /* FCF table scan in progress */
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 482e4a888dae..1437e44ade80 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -41,6 +41,7 @@ enum lpfc_work_type {
 	LPFC_EVT_DEV_LOSS,
 	LPFC_EVT_FASTPATH_MGMT_EVT,
 	LPFC_EVT_RESET_HBA,
+	LPFC_EVT_RECOVER_PORT
 };
 
 /* structure used to queue event to the discovery tasklet */
@@ -128,6 +129,7 @@ struct lpfc_nodelist {
 	struct lpfc_vport *vport;
 	struct lpfc_work_evt els_retry_evt;
 	struct lpfc_work_evt dev_loss_evt;
+	struct lpfc_work_evt recovery_evt;
 	struct kref     kref;
 	atomic_t cmd_pending;
 	uint32_t cmd_qdepth;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 142a02114479..68563f717adf 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -551,6 +551,15 @@ lpfc_work_list_done(struct lpfc_hba *phba)
 								    fcf_inuse,
 								    nlp_did);
 			break;
+		case LPFC_EVT_RECOVER_PORT:
+			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
+			lpfc_sli_abts_recover_port(ndlp->vport, ndlp);
+			free_evt = 0;
+			/* decrement the node reference count held for
+			 * this queued work
+			 */
+			lpfc_nlp_put(ndlp);
+			break;
 		case LPFC_EVT_ONLINE:
 			if (phba->link_state < LPFC_LINK_DOWN)
 				*(int *) (evtp->evt_arg1) = lpfc_online(phba);
@@ -4487,6 +4496,8 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
 	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
 	timer_setup(&ndlp->nlp_delayfunc, lpfc_els_retry_delay, 0);
+	INIT_LIST_HEAD(&ndlp->recovery_evt.evt_listp);
+
 	ndlp->nlp_DID = did;
 	ndlp->vport = vport;
 	ndlp->phba = vport->phba;
@@ -4984,6 +4995,29 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				mempool_free(mbox, phba->mbox_mem_pool);
 				acc_plogi = 1;
 			}
+		} else {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NODE | LOG_DISCOVERY,
+					 "1444 Failed to allocate mempool "
+					 "unreg_rpi UNREG x%x, "
+					 "DID x%x, flag x%x, "
+					 "ndlp x%px\n",
+					 ndlp->nlp_rpi, ndlp->nlp_DID,
+					 ndlp->nlp_flag, ndlp);
+
+			/* Because mempool_alloc failed, we
+			 * will issue a LOGO here and keep the rpi alive if
+			 * not unloading.
+			 */
+			if (!(vport->load_flag & FC_UNLOADING)) {
+				ndlp->nlp_flag &= ~NLP_UNREG_INP;
+				lpfc_issue_els_logo(vport, ndlp, 0);
+				ndlp->nlp_prev_state = ndlp->nlp_state;
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_NPR_NODE);
+			}
+
+			return 1;
 		}
 		lpfc_no_rpi(phba, ndlp);
 out:
@@ -5187,6 +5221,7 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	list_del_init(&ndlp->els_retry_evt.evt_listp);
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
+	list_del_init(&ndlp->recovery_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ca25e54bb782..40fe889033d4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5958,18 +5958,21 @@ lpfc_sli4_async_grp5_evt(struct lpfc_hba *phba,
 void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
 {
 	struct lpfc_cq_event *cq_event;
+	unsigned long iflags;
 
 	/* First, declare the async event has been handled */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~ASYNC_EVENT;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
 	/* Now, handle all the async events */
+	spin_lock_irqsave(&phba->sli4_hba.asynce_list_lock, iflags);
 	while (!list_empty(&phba->sli4_hba.sp_asynce_work_queue)) {
-		/* Get the first event from the head of the event queue */
-		spin_lock_irq(&phba->hbalock);
 		list_remove_head(&phba->sli4_hba.sp_asynce_work_queue,
 				 cq_event, struct lpfc_cq_event, list);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->sli4_hba.asynce_list_lock,
+				       iflags);
+
 		/* Process the asynchronous event */
 		switch (bf_get(lpfc_trailer_code, &cq_event->cqe.mcqe_cmpl)) {
 		case LPFC_TRAILER_CODE_LINK:
@@ -6001,9 +6004,12 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
 					&cq_event->cqe.mcqe_cmpl));
 			break;
 		}
+
 		/* Free the completion event processed to the free pool */
 		lpfc_sli4_cq_event_release(phba, cq_event);
+		spin_lock_irqsave(&phba->sli4_hba.asynce_list_lock, iflags);
 	}
+	spin_unlock_irqrestore(&phba->sli4_hba.asynce_list_lock, iflags);
 }
 
 /**
@@ -6630,6 +6636,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
 	spin_lock_init(&phba->sli4_hba.nvmet_io_wait_lock);
+	spin_lock_init(&phba->sli4_hba.asynce_list_lock);
+	spin_lock_init(&phba->sli4_hba.els_xri_abrt_list_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -6641,8 +6649,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_queue_event);
 	/* Asynchronous event CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_asynce_work_queue);
-	/* Fast-path XRI aborted CQ Event work queue list */
-	INIT_LIST_HEAD(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue);
 	/* Slow-path XRI aborted CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_els_xri_aborted_work_queue);
 	/* Receive queue CQ Event work queue list */
@@ -10174,26 +10180,28 @@ lpfc_sli4_cq_event_release(struct lpfc_hba *phba,
 static void
 lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
 {
-	LIST_HEAD(cqelist);
-	struct lpfc_cq_event *cqe;
+	LIST_HEAD(cq_event_list);
+	struct lpfc_cq_event *cq_event;
 	unsigned long iflags;
 
 	/* Retrieve all the pending WCQEs from pending WCQE lists */
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	/* Pending FCP XRI abort events */
-	list_splice_init(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue,
-			 &cqelist);
+
 	/* Pending ELS XRI abort events */
+	spin_lock_irqsave(&phba->sli4_hba.els_xri_abrt_list_lock, iflags);
 	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
-			 &cqelist);
+			 &cq_event_list);
+	spin_unlock_irqrestore(&phba->sli4_hba.els_xri_abrt_list_lock, iflags);
+
 	/* Pending asynnc events */
+	spin_lock_irqsave(&phba->sli4_hba.asynce_list_lock, iflags);
 	list_splice_init(&phba->sli4_hba.sp_asynce_work_queue,
-			 &cqelist);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
+			 &cq_event_list);
+	spin_unlock_irqrestore(&phba->sli4_hba.asynce_list_lock, iflags);
 
-	while (!list_empty(&cqelist)) {
-		list_remove_head(&cqelist, cqe, struct lpfc_cq_event, list);
-		lpfc_sli4_cq_event_release(phba, cqe);
+	while (!list_empty(&cq_event_list)) {
+		list_remove_head(&cq_event_list, cq_event,
+				 struct lpfc_cq_event, list);
+		lpfc_sli4_cq_event_release(phba, cq_event);
 	}
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 656f35eb853e..79386e294fb9 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -46,6 +46,7 @@
 #define LPFC_MEM_POOL_SIZE      64      /* max elem in non-DMA safety pool */
 #define LPFC_DEVICE_DATA_POOL_SIZE 64   /* max elements in device data pool */
 #define LPFC_RRQ_POOL_SIZE	256	/* max elements in non-DMA  pool */
+#define LPFC_MBX_POOL_SIZE	256	/* max elements in MBX non-DMA pool */
 
 int
 lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
@@ -111,8 +112,8 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 		pool->current_count++;
 	}
 
-	phba->mbox_mem_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
-							 sizeof(LPFC_MBOXQ_t));
+	phba->mbox_mem_pool = mempool_create_kmalloc_pool(LPFC_MBX_POOL_SIZE,
+							  sizeof(LPFC_MBOXQ_t));
 	if (!phba->mbox_mem_pool)
 		goto fail_free_mbuf_pool;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e5be334d6a11..fc39b4ec7b6a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2280,6 +2280,8 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 	int ret, i, pending = 0;
 	struct lpfc_sli_ring  *pring;
 	struct lpfc_hba  *phba = vport->phba;
+	struct lpfc_sli4_hdw_queue *qp;
+	int abts_scsi, abts_nvme;
 
 	/* Host transport has to clean up and confirm requiring an indefinite
 	 * wait. Print a message if a 10 second wait expires and renew the
@@ -2290,17 +2292,23 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 		ret = wait_for_completion_timeout(lport_unreg_cmp, wait_tmo);
 		if (unlikely(!ret)) {
 			pending = 0;
+			abts_scsi = 0;
+			abts_nvme = 0;
 			for (i = 0; i < phba->cfg_hdw_queue; i++) {
-				pring = phba->sli4_hba.hdwq[i].io_wq->pring;
+				qp = &phba->sli4_hba.hdwq[i];
+				pring = qp->io_wq->pring;
 				if (!pring)
 					continue;
-				if (pring->txcmplq_cnt)
-					pending += pring->txcmplq_cnt;
+				pending += pring->txcmplq_cnt;
+				abts_scsi += qp->abts_scsi_io_bufs;
+				abts_nvme += qp->abts_nvme_io_bufs;
 			}
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6176 Lport x%px Localport x%px wait "
-					 "timed out. Pending %d. Renewing.\n",
-					 lport, vport->localport, pending);
+					 "timed out. Pending %d [%d:%d]. "
+					 "Renewing.\n",
+					 lport, vport->localport, pending,
+					 abts_scsi, abts_nvme);
 			continue;
 		}
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4958bb0f2c97..497b5ca34b14 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10370,6 +10370,32 @@ lpfc_extra_ring_setup( struct lpfc_hba *phba)
 	return 0;
 }
 
+static void
+lpfc_sli_post_recovery_event(struct lpfc_hba *phba,
+			     struct lpfc_nodelist *ndlp)
+{
+	unsigned long iflags;
+	struct lpfc_work_evt  *evtp = &ndlp->recovery_evt;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	if (!list_empty(&evtp->evt_listp)) {
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		return;
+	}
+
+	/* Incrementing the reference count until the queued work is done. */
+	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
+	if (!evtp->evt_arg1) {
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		return;
+	}
+	evtp->evt = LPFC_EVT_RECOVER_PORT;
+	list_add_tail(&evtp->evt_listp, &phba->work_list);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	lpfc_worker_wake_up(phba);
+}
+
 /* lpfc_sli_abts_err_handler - handle a failed ABTS request from an SLI3 port.
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to iocb object.
@@ -10460,7 +10486,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_hba *phba,
 	ext_status = axri->parameter & IOERR_PARAM_MASK;
 	if ((bf_get(lpfc_wcqe_xa_status, axri) == IOSTAT_LOCAL_REJECT) &&
 	    ((ext_status == IOERR_SEQUENCE_TIMEOUT) || (ext_status == 0)))
-		lpfc_sli_abts_recover_port(vport, ndlp);
+		lpfc_sli_post_recovery_event(phba, ndlp);
 }
 
 /**
@@ -13068,23 +13094,30 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
 {
 	struct lpfc_cq_event *cq_event;
+	unsigned long iflags;
 
 	/* First, declare the els xri abort event has been handled */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag &= ~ELS_XRI_ABORT_EVENT;
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
 	/* Now, handle all the els xri abort events */
+	spin_lock_irqsave(&phba->sli4_hba.els_xri_abrt_list_lock, iflags);
 	while (!list_empty(&phba->sli4_hba.sp_els_xri_aborted_work_queue)) {
 		/* Get the first event from the head of the event queue */
-		spin_lock_irq(&phba->hbalock);
 		list_remove_head(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
 				 cq_event, struct lpfc_cq_event, list);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->sli4_hba.els_xri_abrt_list_lock,
+				       iflags);
 		/* Notify aborted XRI for ELS work queue */
 		lpfc_sli4_els_xri_aborted(phba, &cq_event->cqe.wcqe_axri);
+
 		/* Free the event processed back to the free pool */
 		lpfc_sli4_cq_event_release(phba, cq_event);
+		spin_lock_irqsave(&phba->sli4_hba.els_xri_abrt_list_lock,
+				  iflags);
 	}
+	spin_unlock_irqrestore(&phba->sli4_hba.els_xri_abrt_list_lock, iflags);
 }
 
 /**
@@ -13295,9 +13328,13 @@ lpfc_sli4_sp_handle_async_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 	cq_event = lpfc_cq_event_setup(phba, mcqe, sizeof(struct lpfc_mcqe));
 	if (!cq_event)
 		return false;
-	spin_lock_irqsave(&phba->hbalock, iflags);
+
+	spin_lock_irqsave(&phba->sli4_hba.asynce_list_lock, iflags);
 	list_add_tail(&cq_event->list, &phba->sli4_hba.sp_asynce_work_queue);
+	spin_unlock_irqrestore(&phba->sli4_hba.asynce_list_lock, iflags);
+
 	/* Set the async event flag */
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	phba->hba_flag |= ASYNC_EVENT;
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
@@ -13572,17 +13609,20 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		break;
 	case LPFC_NVME_LS: /* NVME LS uses ELS resources */
 	case LPFC_ELS:
-		cq_event = lpfc_cq_event_setup(
-			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
-		if (!cq_event)
-			return false;
+		cq_event = lpfc_cq_event_setup(phba, wcqe, sizeof(*wcqe));
+		if (!cq_event) {
+			workposted = false;
+			break;
+		}
 		cq_event->hdwq = cq->hdwq;
-		spin_lock_irqsave(&phba->hbalock, iflags);
+		spin_lock_irqsave(&phba->sli4_hba.els_xri_abrt_list_lock,
+				  iflags);
 		list_add_tail(&cq_event->list,
 			      &phba->sli4_hba.sp_els_xri_aborted_work_queue);
 		/* Set the els xri abort event flag */
 		phba->hba_flag |= ELS_XRI_ABORT_EVENT;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		spin_unlock_irqrestore(&phba->sli4_hba.els_xri_abrt_list_lock,
+				       iflags);
 		workposted = true;
 		break;
 	default:
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index a966cdeb52ee..100cb1a94811 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -920,8 +920,9 @@ struct lpfc_sli4_hba {
 	struct list_head sp_queue_event;
 	struct list_head sp_cqe_event_pool;
 	struct list_head sp_asynce_work_queue;
-	struct list_head sp_fcp_xri_aborted_work_queue;
+	spinlock_t asynce_list_lock; /* protect sp_asynce_work_queue list */
 	struct list_head sp_els_xri_aborted_work_queue;
+	spinlock_t els_xri_abrt_list_lock; /* protect els_xri_aborted list */
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
 	struct lpfc_sli4_lnk_info lnk_info;
@@ -1103,8 +1104,7 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *);
 void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
-void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
-void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 				struct sli4_wcqe_xri_aborted *axri,
 				struct lpfc_io_buf *lpfc_ncmd);
-- 
2.26.2


--000000000000572d6c05b2200f3b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgbMUohZFFhNTPlJqS
lPmLn8TThYRETiUUaxlYU96TCfkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDIwMjAyNzI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKtQN1jSfnj5eUtovg+FwsPNM9e8tA1Lcgwl
+3QWDUS6LXMQB65UJjuvkJ8MQ2GTG/JmqjcPySw+m6JmcY3VEZIlMGn5kU40DQ9IZorDCG4+nlGh
d5MVuTP3v/WiEDCZXMJ/h7CcKcTKDgs/GQgUixKcmafea5m10vXfiU/wUn4WwltMpplkEtkdz+aP
pqQCo1hTxdj/hKzBgyVTB+d1fn/Y88WPNUJYraTQ6vdkH13ymXnzM6CzbssuUnBGwaEMDJ+/zCN6
vD3iAFD0O2RE3ti3W0TKR5SX7wPba3WnsXT8QYZPlSQZUbn57iEhQSCwZH6BHGA6e0mw8/9AnH6h
zCI=
--000000000000572d6c05b2200f3b--
