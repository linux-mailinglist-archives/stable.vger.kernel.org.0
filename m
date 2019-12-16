Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020501214BE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfLPSOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731210AbfLPSOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BB12166E;
        Mon, 16 Dec 2019 18:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520062;
        bh=QfDHfWJZkXCjKhON+mLCDIfuWvS7L2nVq4tV89VaVls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVF1Ntn905yZqOfDpettQERRvzUlrqzReCv3TTE2K8Ys7aIqZug1egHzLfOfY38T0
         CCDzrYrBUzB9HFdoMZHg/dtM+rpPWdpQUS9YQJjZNzxGsNC7WEkdRylOypjhyW+nGK
         lPjrG02hc5Euq//9WUKvtNhVkq0bI2PxKCnah/rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 160/180] scsi: qla2xxx: Fix double scsi_done for abort path
Date:   Mon, 16 Dec 2019 18:50:00 +0100
Message-Id: <20191216174846.135572642@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit f45bca8c5052e8c59bab64ee90c44441678b9a52 ]

Current code assumes abort will remove the original command from the active
list where scsi_done will not be called. Instead, the eh_abort thread will
do the scsi_done. That is not the case.  Instead, we have a double
scsi_done calls triggering use after free.

Abort will tell FW to release the command from FW possesion. The original
command will return to ULP with error in its normal fashion via scsi_done.
eh_abort path would wait for the original command completion before
returning.  eh_abort path will not perform the scsi_done call.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Link: https://lore.kernel.org/r/20191105150657.8092-6-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |   5 +-
 drivers/scsi/qla2xxx/qla_isr.c  |   5 ++
 drivers/scsi/qla2xxx/qla_nvme.c |   4 +-
 drivers/scsi/qla2xxx/qla_os.c   | 118 +++++++++++++++++---------------
 4 files changed, 74 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ea1728fe2c768..29af738ca203e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -531,13 +531,16 @@ typedef struct srb {
 	 */
 	uint8_t cmd_type;
 	uint8_t pad[3];
-	atomic_t ref_count;
 	struct kref cmd_kref;	/* need to migrate ref_count over to this */
 	void *priv;
 	wait_queue_head_t nvme_ls_waitq;
 	struct fc_port *fcport;
 	struct scsi_qla_host *vha;
 	unsigned int start_timer:1;
+	unsigned int abort:1;
+	unsigned int aborted:1;
+	unsigned int completed:1;
+
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f7458d74ae3d2..9e32a90d4d773 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2473,6 +2473,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	if (sp->abort)
+		sp->aborted = 1;
+	else
+		sp->completed = 1;
+
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
 		ql_dbg(ql_dbg_io, vha, 0x3015,
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 963094b3c3007..672da9b838e52 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -227,8 +227,8 @@ static void qla_nvme_abort_work(struct work_struct *work)
 
 	if (ha->flags.host_shutting_down) {
 		ql_log(ql_log_info, sp->fcport->vha, 0xffff,
-		    "%s Calling done on sp: %p, type: 0x%x, sp->ref_count: 0x%x\n",
-		    __func__, sp, sp->type, atomic_read(&sp->ref_count));
+		    "%s Calling done on sp: %p, type: 0x%x\n",
+		    __func__, sp, sp->type);
 		sp->done(sp, 0);
 		goto out;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3aa2dd43945bf..ac2977bdc3595 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -716,11 +716,6 @@ qla2x00_sp_compl(void *ptr, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	if (WARN_ON_ONCE(atomic_read(&sp->ref_count) == 0))
-		return;
-
-	atomic_dec(&sp->ref_count);
-
 	sp->free(sp);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
@@ -820,11 +815,6 @@ qla2xxx_qpair_sp_compl(void *ptr, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	if (WARN_ON_ONCE(atomic_read(&sp->ref_count) == 0))
-		return;
-
-	atomic_dec(&sp->ref_count);
-
 	sp->free(sp);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
@@ -928,7 +918,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-	atomic_set(&sp->ref_count, 1);
+
 	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2x00_sp_free_dma;
 	sp->done = qla2x00_sp_compl;
@@ -1010,11 +1000,9 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
-	atomic_set(&sp->ref_count, 1);
 	CMD_SP(cmd) = (void *)sp;
 	sp->free = qla2xxx_qpair_sp_free_dma;
 	sp->done = qla2xxx_qpair_sp_compl;
-	sp->qpair = qpair;
 
 	rval = ha->isp_ops->start_scsi_mq(sp);
 	if (rval != QLA_SUCCESS) {
@@ -1207,16 +1195,6 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
 	return return_status;
 }
 
-static int
-sp_get(struct srb *sp)
-{
-	if (!refcount_inc_not_zero((refcount_t *)&sp->ref_count))
-		/* kref get fail */
-		return ENXIO;
-	else
-		return 0;
-}
-
 #define ISP_REG_DISCONNECT 0xffffffffU
 /**************************************************************************
 * qla2x00_isp_reg_stat
@@ -1272,6 +1250,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	uint64_t lun;
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
+	uint32_t ratov_j;
+	struct qla_qpair *qpair;
+	unsigned long flags;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1284,11 +1265,27 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return ret;
 
 	sp = scsi_cmd_priv(cmd);
+	qpair = sp->qpair;
 
-	/* Return if the command has already finished. */
-	if (sp_get(sp))
+	if ((sp->fcport && sp->fcport->deleted) || !qpair)
 		return SUCCESS;
 
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+	if (sp->completed) {
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+		return SUCCESS;
+	}
+
+	if (sp->abort || sp->aborted) {
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+		return FAILED;
+	}
+
+	sp->abort = 1;
+	sp->comp = &comp;
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
@@ -1296,47 +1293,37 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p handle=%x\n",
 	    vha->host_no, id, lun, sp, cmd, sp->handle);
 
+	/*
+	 * Abort will release the original Command/sp from FW. Let the
+	 * original command call scsi_done. In return, he will wakeup
+	 * this sleeping thread.
+	 */
 	rval = ha->isp_ops->abort_command(sp);
+
 	ql_dbg(ql_dbg_taskm, vha, 0x8003,
 	       "Abort command mbx cmd=%p, rval=%x.\n", cmd, rval);
 
+	/* Wait for the command completion. */
+	ratov_j = ha->r_a_tov/10 * 4 * 1000;
+	ratov_j = msecs_to_jiffies(ratov_j);
 	switch (rval) {
 	case QLA_SUCCESS:
-		/*
-		 * The command has been aborted. That means that the firmware
-		 * won't report a completion.
-		 */
-		sp->done(sp, DID_ABORT << 16);
-		ret = SUCCESS;
-		break;
-	case QLA_FUNCTION_PARAMETER_ERROR: {
-		/* Wait for the command completion. */
-		uint32_t ratov = ha->r_a_tov/10;
-		uint32_t ratov_j = msecs_to_jiffies(4 * ratov * 1000);
-
-		WARN_ON_ONCE(sp->comp);
-		sp->comp = &comp;
 		if (!wait_for_completion_timeout(&comp, ratov_j)) {
 			ql_dbg(ql_dbg_taskm, vha, 0xffff,
 			    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
-			    __func__, ha->r_a_tov);
+			    __func__, ha->r_a_tov/10);
 			ret = FAILED;
 		} else {
 			ret = SUCCESS;
 		}
 		break;
-	}
 	default:
-		/*
-		 * Either abort failed or abort and completion raced. Let
-		 * the SCSI core retry the abort in the former case.
-		 */
 		ret = FAILED;
 		break;
 	}
 
 	sp->comp = NULL;
-	atomic_dec(&sp->ref_count);
+
 	ql_log(ql_log_info, vha, 0x801c,
 	    "Abort command issued nexus=%ld:%d:%llu -- %x.\n",
 	    vha->host_no, id, lun, ret);
@@ -1719,32 +1706,53 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	scsi_qla_host_t *vha = qp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
+	bool ret_cmd;
+	uint32_t ratov_j;
 
-	if (sp_get(sp))
+	if (qla2x00_chip_is_down(vha)) {
+		sp->done(sp, res);
 		return;
+	}
 
 	if (sp->type == SRB_NVME_CMD || sp->type == SRB_NVME_LS ||
 	    (sp->type == SRB_SCSI_CMD && !ha->flags.eeh_busy &&
 	     !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
 	     !qla2x00_isp_reg_stat(ha))) {
+		if (sp->comp) {
+			sp->done(sp, res);
+			return;
+		}
+
 		sp->comp = &comp;
+		sp->abort =  1;
 		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
-		rval = ha->isp_ops->abort_command(sp);
 
+		rval = ha->isp_ops->abort_command(sp);
+		/* Wait for command completion. */
+		ret_cmd = false;
+		ratov_j = ha->r_a_tov/10 * 4 * 1000;
+		ratov_j = msecs_to_jiffies(ratov_j);
 		switch (rval) {
 		case QLA_SUCCESS:
-			sp->done(sp, res);
+			if (wait_for_completion_timeout(&comp, ratov_j)) {
+				ql_dbg(ql_dbg_taskm, vha, 0xffff,
+				    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
+				    __func__, ha->r_a_tov/10);
+				ret_cmd = true;
+			}
+			/* else FW return SP to driver */
 			break;
-		case QLA_FUNCTION_PARAMETER_ERROR:
-			wait_for_completion(&comp);
+		default:
+			ret_cmd = true;
 			break;
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		sp->comp = NULL;
+		if (ret_cmd && (!sp->completed || !sp->aborted))
+			sp->done(sp, res);
+	} else {
+		sp->done(sp, res);
 	}
-
-	atomic_dec(&sp->ref_count);
 }
 
 static void
@@ -1766,7 +1774,6 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
-			req->outstanding_cmds[cnt] = NULL;
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);
@@ -1788,6 +1795,7 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 			default:
 				break;
 			}
+			req->outstanding_cmds[cnt] = NULL;
 		}
 	}
 	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
-- 
2.20.1



