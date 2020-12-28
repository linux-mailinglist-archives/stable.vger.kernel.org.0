Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E82E3EB3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392106AbgL1Obx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504314AbgL1ObT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA5E20739;
        Mon, 28 Dec 2020 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165838;
        bh=3lEToN2D4iYYbTAvqJonSa/zhSxoOtcYdw/vuxNMkYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZAMlIh/lzGLLDwQMSFtXdAroFcW8otHWnoJWUiMwkj9U5mSQfR5Z1PyzmAy5jEZ1
         eRMxxAoZH8znfdixJBXDkqZ4Hn3NBqjGKw2Hg8/eAs4GdbMZyl9vOlFH7RSJwYdfpB
         FlonpOhtqAvNQy6/e3EayM0i9cHD5qw5h6iYB4wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 671/717] scsi: lpfc: Fix scheduling call while in softirq context in lpfc_unreg_rpi
Date:   Mon, 28 Dec 2020 13:51:09 +0100
Message-Id: <20201228125053.128972717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit e7dab164a9aa457f89d4528452bdfc3e15ac98b6 upstream.

The following call trace was seen during HBA reset testing:

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
cases, it introduced this code path, executed when I/O aborts or logouts
are seen, which attempts to allocate memory for a mailbox command to be
issued.  The allocation is GFP_KERNEL, thus it could attempt to sleep.

Fix by creating a work element that performs the event handling for the
remote port. This will have the mailbox commands and other items performed
in the work element, not the irq. A much better method as the "irq" routine
does not stall while performing all this deep handling code.

Ensure that allocation failures are handled and send LOGO on failure.

Additionally, enlarge the mailbox memory pool to reduce the possibility of
additional allocation in this path.

Link: https://lore.kernel.org/r/20201020202719.54726-3-james.smart@broadcom.com
Fixes: 317aeb83c92b ("scsi: lpfc: Add blk_io_poll support for latency improvment")
Cc: <stable@vger.kernel.org> # v5.9+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc.h         |    2 -
 drivers/scsi/lpfc/lpfc_disc.h    |    2 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |   35 +++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    |   46 ++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_mem.c     |    5 +--
 drivers/scsi/lpfc/lpfc_nvme.c    |   18 +++++++---
 drivers/scsi/lpfc/lpfc_sli.c     |   64 +++++++++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli4.h    |    6 +--
 8 files changed, 136 insertions(+), 42 deletions(-)

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
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -552,6 +552,15 @@ lpfc_work_list_done(struct lpfc_hba *phb
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
@@ -4515,6 +4524,8 @@ lpfc_initialize_node(struct lpfc_vport *
 	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
 	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
 	timer_setup(&ndlp->nlp_delayfunc, lpfc_els_retry_delay, 0);
+	INIT_LIST_HEAD(&ndlp->recovery_evt.evt_listp);
+
 	ndlp->nlp_DID = did;
 	ndlp->vport = vport;
 	ndlp->phba = vport->phba;
@@ -5011,6 +5022,29 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
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
@@ -5214,6 +5248,7 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 
 	list_del_init(&ndlp->els_retry_evt.evt_listp);
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
+	list_del_init(&ndlp->recovery_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5958,18 +5958,21 @@ lpfc_sli4_async_grp5_evt(struct lpfc_hba
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
@@ -6001,9 +6004,12 @@ void lpfc_sli4_async_event_proc(struct l
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
@@ -6630,6 +6636,8 @@ lpfc_sli4_driver_resource_setup(struct l
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
 	spin_lock_init(&phba->sli4_hba.nvmet_io_wait_lock);
+	spin_lock_init(&phba->sli4_hba.asynce_list_lock);
+	spin_lock_init(&phba->sli4_hba.els_xri_abrt_list_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -6641,8 +6649,6 @@ lpfc_sli4_driver_resource_setup(struct l
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_queue_event);
 	/* Asynchronous event CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_asynce_work_queue);
-	/* Fast-path XRI aborted CQ Event work queue list */
-	INIT_LIST_HEAD(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue);
 	/* Slow-path XRI aborted CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_els_xri_aborted_work_queue);
 	/* Receive queue CQ Event work queue list */
@@ -10174,26 +10180,28 @@ lpfc_sli4_cq_event_release(struct lpfc_h
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
 
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -46,6 +46,7 @@
 #define LPFC_MEM_POOL_SIZE      64      /* max elem in non-DMA safety pool */
 #define LPFC_DEVICE_DATA_POOL_SIZE 64   /* max elements in device data pool */
 #define LPFC_RRQ_POOL_SIZE	256	/* max elements in non-DMA  pool */
+#define LPFC_MBX_POOL_SIZE	256	/* max elements in MBX non-DMA pool */
 
 int
 lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
@@ -111,8 +112,8 @@ lpfc_mem_alloc(struct lpfc_hba *phba, in
 		pool->current_count++;
 	}
 
-	phba->mbox_mem_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
-							 sizeof(LPFC_MBOXQ_t));
+	phba->mbox_mem_pool = mempool_create_kmalloc_pool(LPFC_MBX_POOL_SIZE,
+							  sizeof(LPFC_MBOXQ_t));
 	if (!phba->mbox_mem_pool)
 		goto fail_free_mbuf_pool;
 
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2280,6 +2280,8 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_v
 	int ret, i, pending = 0;
 	struct lpfc_sli_ring  *pring;
 	struct lpfc_hba  *phba = vport->phba;
+	struct lpfc_sli4_hdw_queue *qp;
+	int abts_scsi, abts_nvme;
 
 	/* Host transport has to clean up and confirm requiring an indefinite
 	 * wait. Print a message if a 10 second wait expires and renew the
@@ -2290,17 +2292,23 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_v
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
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10370,6 +10370,32 @@ lpfc_extra_ring_setup( struct lpfc_hba *
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
@@ -10460,7 +10486,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 	ext_status = axri->parameter & IOERR_PARAM_MASK;
 	if ((bf_get(lpfc_wcqe_xa_status, axri) == IOSTAT_LOCAL_REJECT) &&
 	    ((ext_status == IOERR_SEQUENCE_TIMEOUT) || (ext_status == 0)))
-		lpfc_sli_abts_recover_port(vport, ndlp);
+		lpfc_sli_post_recovery_event(phba, ndlp);
 }
 
 /**
@@ -13068,23 +13094,30 @@ lpfc_sli_intr_handler(int irq, void *dev
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
@@ -13295,9 +13328,13 @@ lpfc_sli4_sp_handle_async_event(struct l
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
 
@@ -13572,17 +13609,20 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struc
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
@@ -1103,8 +1104,7 @@ void lpfc_sli4_async_event_proc(struct l
 void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
-void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
-void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 				struct sli4_wcqe_xri_aborted *axri,
 				struct lpfc_io_buf *lpfc_ncmd);


