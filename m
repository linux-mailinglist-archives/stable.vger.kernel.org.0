Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC83C3544E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfFDXcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfFDXWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894EE206C1;
        Tue,  4 Jun 2019 23:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690559;
        bh=elQulafWfojW/No7u26ObtX0sxmbPMgJi2e3bTx+dUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZRCzvtXmEluCLE9l6ZEXALHGhHt8JQ2NREjCWGveuxooS8UGdk2Zuq943KlcCuQL
         E6z+rEVXseCX3nk26hBeNvq3cWxJiPqoICBy6Qn9JvsydKc161PFiUMZoYlTxWJGUq
         Jy/4OI1MhES1dmZQD7g5sFchI+6R4ubyiM498QPs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 15/60] scsi: qla2xxx: Add cleanup for PCI EEH recovery
Date:   Tue,  4 Jun 2019 19:21:25 -0400
Message-Id: <20190604232212.6753-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 5386a4e6c7fecd282d265a24d930a74ba3c5917b ]

During EEH error recovery testing it was discovered that driver's reset()
callback partially frees resources used by driver, leaving some stale
memory.  After reset() is done and when resume() callback in driver uses
old data which results into error leaving adapter disabled due to PCIe
error.

This patch does cleanup for EEH recovery code path and prevents adapter
from getting disabled.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 221 +++++++++++++---------------------
 1 file changed, 82 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 91f576d743fe..d377e50a6c19 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6838,6 +6838,78 @@ qla2x00_release_firmware(void)
 	mutex_unlock(&qla_fw_lock);
 }
 
+static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+	struct qla_qpair *qpair = NULL;
+	struct scsi_qla_host *vp;
+	fc_port_t *fcport;
+	int i;
+	unsigned long flags;
+
+	ha->chip_reset++;
+
+	ha->base_qpair->chip_reset = ha->chip_reset;
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i])
+			ha->queue_pair_map[i]->chip_reset =
+			    ha->base_qpair->chip_reset;
+	}
+
+	/* purge MBox commands */
+	if (atomic_read(&ha->num_pend_mbx_stage3)) {
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		complete(&ha->mbx_intr_comp);
+	}
+
+	i = 0;
+
+	while (atomic_read(&ha->num_pend_mbx_stage3) ||
+	    atomic_read(&ha->num_pend_mbx_stage2) ||
+	    atomic_read(&ha->num_pend_mbx_stage1)) {
+		msleep(20);
+		i++;
+		if (i > 50)
+			break;
+	}
+
+	ha->flags.purge_mbox = 0;
+
+	mutex_lock(&ha->mq_lock);
+	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
+		qpair->online = 0;
+	mutex_unlock(&ha->mq_lock);
+
+	qla2x00_mark_all_devices_lost(vha, 0);
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		atomic_inc(&vp->vref_count);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		qla2x00_mark_all_devices_lost(vp, 0);
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		atomic_dec(&vp->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+	/* Clear all async request states across all VPs. */
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		atomic_inc(&vp->vref_count);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		list_for_each_entry(fcport, &vp->vp_fcports, list)
+			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		atomic_dec(&vp->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+}
+
+
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
@@ -6863,20 +6935,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		ha->flags.eeh_busy = 1;
-		/* For ISP82XX complete any pending mailbox cmd */
-		if (IS_QLA82XX(ha)) {
-			ha->flags.isp82xx_fw_hung = 1;
-			ql_dbg(ql_dbg_aer, vha, 0x9001, "Pci channel io frozen\n");
-			qla82xx_clear_pending_mbx(vha);
-		}
-		qla2x00_free_irqs(vha);
-		pci_disable_device(pdev);
-		/* Return back all IOs */
-		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
-		if (ql2xmqsupport || ql2xnvmeenable) {
-			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
-		}
+		qla_pci_error_cleanup(vha);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		ha->flags.pci_channel_io_perm_failure = 1;
@@ -6930,122 +6989,14 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_RECOVERED;
 }
 
-static uint32_t
-qla82xx_error_recovery(scsi_qla_host_t *base_vha)
-{
-	uint32_t rval = QLA_FUNCTION_FAILED;
-	uint32_t drv_active = 0;
-	struct qla_hw_data *ha = base_vha->hw;
-	int fn;
-	struct pci_dev *other_pdev = NULL;
-
-	ql_dbg(ql_dbg_aer, base_vha, 0x9006,
-	    "Entered %s.\n", __func__);
-
-	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-
-	if (base_vha->flags.online) {
-		/* Abort all outstanding commands,
-		 * so as to be requeued later */
-		qla2x00_abort_isp_cleanup(base_vha);
-	}
-
-
-	fn = PCI_FUNC(ha->pdev->devfn);
-	while (fn > 0) {
-		fn--;
-		ql_dbg(ql_dbg_aer, base_vha, 0x9007,
-		    "Finding pci device at function = 0x%x.\n", fn);
-		other_pdev =
-		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
-		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
-		    fn));
-
-		if (!other_pdev)
-			continue;
-		if (atomic_read(&other_pdev->enable_cnt)) {
-			ql_dbg(ql_dbg_aer, base_vha, 0x9008,
-			    "Found PCI func available and enable at 0x%x.\n",
-			    fn);
-			pci_dev_put(other_pdev);
-			break;
-		}
-		pci_dev_put(other_pdev);
-	}
-
-	if (!fn) {
-		/* Reset owner */
-		ql_dbg(ql_dbg_aer, base_vha, 0x9009,
-		    "This devfn is reset owner = 0x%x.\n",
-		    ha->pdev->devfn);
-		qla82xx_idc_lock(ha);
-
-		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-		    QLA8XXX_DEV_INITIALIZING);
-
-		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION,
-		    QLA82XX_IDC_VERSION);
-
-		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
-		ql_dbg(ql_dbg_aer, base_vha, 0x900a,
-		    "drv_active = 0x%x.\n", drv_active);
-
-		qla82xx_idc_unlock(ha);
-		/* Reset if device is not already reset
-		 * drv_active would be 0 if a reset has already been done
-		 */
-		if (drv_active)
-			rval = qla82xx_start_firmware(base_vha);
-		else
-			rval = QLA_SUCCESS;
-		qla82xx_idc_lock(ha);
-
-		if (rval != QLA_SUCCESS) {
-			ql_log(ql_log_info, base_vha, 0x900b,
-			    "HW State: FAILED.\n");
-			qla82xx_clear_drv_active(ha);
-			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-			    QLA8XXX_DEV_FAILED);
-		} else {
-			ql_log(ql_log_info, base_vha, 0x900c,
-			    "HW State: READY.\n");
-			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-			    QLA8XXX_DEV_READY);
-			qla82xx_idc_unlock(ha);
-			ha->flags.isp82xx_fw_hung = 0;
-			rval = qla82xx_restart_isp(base_vha);
-			qla82xx_idc_lock(ha);
-			/* Clear driver state register */
-			qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
-			qla82xx_set_drv_active(base_vha);
-		}
-		qla82xx_idc_unlock(ha);
-	} else {
-		ql_dbg(ql_dbg_aer, base_vha, 0x900d,
-		    "This devfn is not reset owner = 0x%x.\n",
-		    ha->pdev->devfn);
-		if ((qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
-		    QLA8XXX_DEV_READY)) {
-			ha->flags.isp82xx_fw_hung = 0;
-			rval = qla82xx_restart_isp(base_vha);
-			qla82xx_idc_lock(ha);
-			qla82xx_set_drv_active(base_vha);
-			qla82xx_idc_unlock(ha);
-		}
-	}
-	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-
-	return rval;
-}
-
 static pci_ers_result_t
 qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 {
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
 	struct qla_hw_data *ha = base_vha->hw;
-	struct rsp_que *rsp;
-	int rc, retries = 10;
+	int rc;
+	struct qla_qpair *qpair = NULL;
 
 	ql_dbg(ql_dbg_aer, base_vha, 0x9004,
 	    "Slot Reset.\n");
@@ -7074,24 +7025,16 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		goto exit_slot_reset;
 	}
 
-	rsp = ha->rsp_q_map[0];
-	if (qla2x00_request_irqs(ha, rsp))
-		goto exit_slot_reset;
 
 	if (ha->isp_ops->pci_config(base_vha))
 		goto exit_slot_reset;
 
-	if (IS_QLA82XX(ha)) {
-		if (qla82xx_error_recovery(base_vha) == QLA_SUCCESS) {
-			ret = PCI_ERS_RESULT_RECOVERED;
-			goto exit_slot_reset;
-		} else
-			goto exit_slot_reset;
-	}
-
-	while (ha->flags.mbox_busy && retries--)
-		msleep(1000);
+	mutex_lock(&ha->mq_lock);
+	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
+		qpair->online = 1;
+	mutex_unlock(&ha->mq_lock);
 
+	base_vha->flags.online = 1;
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	if (ha->isp_ops->abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
@@ -7115,13 +7058,13 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900f,
 	    "pci_resume.\n");
 
+	ha->flags.eeh_busy = 0;
+
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, base_vha, 0x9002,
 		    "The device failed to resume I/O from slot/link_reset.\n");
 	}
-
-	ha->flags.eeh_busy = 0;
 }
 
 static void
-- 
2.20.1

