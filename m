Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04894FC99A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbiDLAsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243097AbiDLAri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65B917AB7;
        Mon, 11 Apr 2022 17:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F20FD617E7;
        Tue, 12 Apr 2022 00:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE6AC385AA;
        Tue, 12 Apr 2022 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724321;
        bh=RuKRKUWZR17o3oVN55WDM2lVdxnAlzeuS6V/qwnUGlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jlq4eDkKMvuQZbwHLNfNeK51iBeCZgNRx7EHGV+kqqiUfaSdP7uEMGwx93zqq6F68
         PBj2xr7ZEIw2V8mofIu/ZMUMBev9uZmx1BcKJ06EwVgwiZepGmDDYyNkgsC8OfnTR7
         Z9yXI3fKFNK309jgNAD3giSGNIBnxV59ac/W91ksq1RZQJJU0c6Vc60M2L8cwKxJzL
         B55acfzBk7jAAGE2TKIfRIyc0HvvZzKWtWDGZ2KdhMmpzWnn+DhGA3f56Glx38Q0cP
         vJSaHsDYO406Qnqo6yIqs74xWEsWOujuXvvF+nenQFwsubUmVWmREAp+13MSbcM+jm
         5VDb8UBqzB+qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 19/49] scsi: lpfc: Fix unload hang after back to back PCI EEH faults
Date:   Mon, 11 Apr 2022 20:43:37 -0400
Message-Id: <20220412004411.349427-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit a4691038b4071ff0d9ae486d8822a2c0d41d5796 ]

When injecting EEH errors the port is getting hung up waiting on the node
list to empty, message number 0233. The driver is stuck at this point and
also can't unload. The driver makes transport remoteport delete calls which
try to abort I/O's, but the EEH daemon has already called the driver to
detach and the detachment has set the global FC_UNLOADING flag.  There are
several code paths that will avoid I/O cleanup if the FC_UNLOADING flag is
set, resulting in transports waiting for I/O while the driver is waiting on
transports to clean up.

Additionally, during study of the list, a locking issue was found in
lpfc_sli_abort_iocb_ring that could corrupt the list.

A special case was added to the lpfc_cleanup() routine to call
lpfc_sli_flush_rings() if the driver is FC_UNLOADING and if the pci-slot
is offline (e.g. EEH).

The SLI4 part of lpfc_sli_abort_iocb_ring() is changed to use the
ring_lock.  Also added code to cancel the I/Os if the pci-slot is offline
and added checks and returns for the FC_UNLOADING and HBA_IOQ_FLUSH flags
to prevent trying to send an I/O that we cannot handle.

Link: https://lore.kernel.org/r/20220317032737.45308-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_init.c    | 26 +++++++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c    | 16 ++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 50 ++++++++++++++++++++++----------
 4 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e10371611ef8..0cba306de0db 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5416,6 +5416,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				mempool_free(mbox, phba->mbox_mem_pool);
 				acc_plogi = 1;
+				lpfc_nlp_put(ndlp);
 			}
 		} else {
 			lpfc_printf_vlog(vport, KERN_INFO,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fe9a04b2df3e..c8c049cf8d96 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -95,6 +95,7 @@ static void lpfc_sli4_oas_verify(struct lpfc_hba *phba);
 static uint16_t lpfc_find_cpu_handle(struct lpfc_hba *, uint16_t, int);
 static void lpfc_setup_bg(struct lpfc_hba *, struct Scsi_Host *);
 static int lpfc_sli4_cgn_parm_chg_evt(struct lpfc_hba *);
+static void lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
@@ -1995,6 +1996,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 	if (pci_channel_offline(phba->pcidev)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3166 pci channel is offline\n");
+		lpfc_sli_flush_io_rings(phba);
 		return;
 	}
 
@@ -2983,6 +2985,22 @@ lpfc_cleanup(struct lpfc_vport *vport)
 					NLP_EVT_DEVICE_RM);
 	}
 
+	/* This is a special case flush to return all
+	 * IOs before entering this loop. There are
+	 * two points in the code where a flush is
+	 * avoided if the FC_UNLOADING flag is set.
+	 * one is in the multipool destroy,
+	 * (this prevents a crash) and the other is
+	 * in the nvme abort handler, ( also prevents
+	 * a crash). Both of these exceptions are
+	 * cases where the slot is still accessible.
+	 * The flush here is only when the pci slot
+	 * is offline.
+	 */
+	if (vport->load_flag & FC_UNLOADING &&
+	    pci_channel_offline(phba->pcidev))
+		lpfc_sli_flush_io_rings(vport->phba);
+
 	/* At this point, ALL ndlp's should be gone
 	 * because of the previous NLP_EVT_DEVICE_RM.
 	 * Lets wait for this to happen, if needed.
@@ -2995,7 +3013,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						&vport->fc_nodes, nlp_listp) {
 				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
+						 LOG_DISCOVERY,
 						 "0282 did:x%x ndlp:x%px "
 						 "refcnt:%d xflags x%x nflag x%x\n",
 						 ndlp->nlp_DID, (void *)ndlp,
@@ -13371,8 +13389,9 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	/* Abort all iocbs associated with the hba */
 	lpfc_sli_hba_iocb_abort(phba);
 
-	/* Wait for completion of device XRI exchange busy */
-	lpfc_sli4_xri_exchange_busy_wait(phba);
+	if (!pci_channel_offline(phba->pcidev))
+		/* Wait for completion of device XRI exchange busy */
+		lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
 	if (phba->pport)
@@ -14276,6 +14295,7 @@ lpfc_sli_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 			"2711 PCI channel permanent disable for failure\n");
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
+	lpfc_sli4_prep_dev_for_reset(phba);
 
 	/* stop all timers */
 	lpfc_stop_hba_timers(phba);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8983f6440858..df73abb59407 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -93,6 +93,11 @@ lpfc_nvme_create_queue(struct nvme_fc_local_port *pnvme_lport,
 
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
+
+	if (!vport || vport->load_flag & FC_UNLOADING ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
+		return -ENODEV;
+
 	qhandle = kzalloc(sizeof(struct lpfc_nvme_qhandle), GFP_KERNEL);
 	if (qhandle == NULL)
 		return -ENOMEM;
@@ -267,7 +272,8 @@ lpfc_nvme_handle_lsreq(struct lpfc_hba *phba,
 		return -EINVAL;
 
 	remoteport = lpfc_rport->remoteport;
-	if (!vport->localport)
+	if (!vport->localport ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -EINVAL;
 
 	lport = vport->localport->private;
@@ -559,6 +565,8 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 ndlp->nlp_DID, ntype, nstate);
 		return -ENODEV;
 	}
+	if (vport->phba->hba_flag & HBA_IOQ_FLUSH)
+		return -ENODEV;
 
 	if (!vport->phba->sli4_hba.nvmels_wq)
 		return -ENOMEM;
@@ -662,7 +670,8 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 		return -EINVAL;
 
 	vport = lport->vport;
-	if (vport->load_flag & FC_UNLOADING)
+	if (vport->load_flag & FC_UNLOADING ||
+	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -ENODEV;
 
 	atomic_inc(&lport->fc4NvmeLsRequests);
@@ -1515,7 +1524,8 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 
 	phba = vport->phba;
 
-	if (unlikely(vport->load_flag & FC_UNLOADING)) {
+	if ((unlikely(vport->load_flag & FC_UNLOADING)) ||
+	    phba->hba_flag & HBA_IOQ_FLUSH) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6124 Fail IO, Driver unload\n");
 		atomic_inc(&lport->xmt_fcp_err);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 661ed0999f1c..b64c5f157ce9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4472,42 +4472,62 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 void
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	LIST_HEAD(completions);
+	LIST_HEAD(tx_completions);
+	LIST_HEAD(txcmplq_completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
+	int offline;
 
 	if (pring->ringno == LPFC_ELS_RING) {
 		lpfc_fabric_abort_hba(phba);
 	}
+	offline = pci_channel_offline(phba->pcidev);
 
 	/* Error everything on txq and txcmplq
 	 * First do the txq.
 	 */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		spin_lock_irq(&pring->ring_lock);
-		list_splice_init(&pring->txq, &completions);
+		list_splice_init(&pring->txq, &tx_completions);
 		pring->txq_cnt = 0;
-		spin_unlock_irq(&pring->ring_lock);
 
-		spin_lock_irq(&phba->hbalock);
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
-		spin_unlock_irq(&phba->hbalock);
+		if (offline) {
+			list_splice_init(&pring->txcmplq,
+					 &txcmplq_completions);
+		} else {
+			/* Next issue ABTS for everything on the txcmplq */
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list)
+				lpfc_sli_issue_abort_iotag(phba, pring,
+							   iocb, NULL);
+		}
+		spin_unlock_irq(&pring->ring_lock);
 	} else {
 		spin_lock_irq(&phba->hbalock);
-		list_splice_init(&pring->txq, &completions);
+		list_splice_init(&pring->txq, &tx_completions);
 		pring->txq_cnt = 0;
 
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
+		if (offline) {
+			list_splice_init(&pring->txcmplq, &txcmplq_completions);
+		} else {
+			/* Next issue ABTS for everything on the txcmplq */
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list)
+				lpfc_sli_issue_abort_iotag(phba, pring,
+							   iocb, NULL);
+		}
 		spin_unlock_irq(&phba->hbalock);
 	}
-	/* Make sure HBA is alive */
-	lpfc_issue_hb_tmo(phba);
 
+	if (offline) {
+		/* Cancel all the IOCBs from the completions list */
+		lpfc_sli_cancel_iocbs(phba, &txcmplq_completions,
+				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
+	} else {
+		/* Make sure HBA is alive */
+		lpfc_issue_hb_tmo(phba);
+	}
 	/* Cancel all the IOCBs from the completions list */
-	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+	lpfc_sli_cancel_iocbs(phba, &tx_completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
 }
 
-- 
2.35.1

