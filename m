Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252FA12166C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbfLPS3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731060AbfLPSOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 746F421775;
        Mon, 16 Dec 2019 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520049;
        bh=dHp+0izUy3gUt9Z11uqVhXbKnF9n8E0PvImkKYAJD0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7bXluZmjPbJewGQrhX9MuURjX465otivkbYcT54hDiy17l1GgWgh3gy9Y7mV1j1J
         0rg4grba4/l9N27W3JzyZyVnT6dmZdN/icH/Jyq9z8OFgCGIAkEgQV0/TWu7RxHJdE
         bM6o2K71nJNpQ0dwETePKqosL0XVQ9OU2WTkcqXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 159/180] scsi: qla2xxx: Fix a race condition between aborting and completing a SCSI command
Date:   Mon, 16 Dec 2019 18:49:59 +0100
Message-Id: <20191216174845.839026411@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 85cffefa09e448906a6f0bc20f422d75a18675bd ]

Instead of allocating a struct srb dynamically from inside .queuecommand(),
set qla2xxx_driver_template.cmd_size such that struct scsi_cmnd and struct
srb are contiguous. Do not call QLA_QPAIR_MARK_BUSY() /
QLA_QPAIR_MARK_NOT_BUSY() for SRBs associated with SCSI commands. That is
safe because scsi_remove_host() is called before queue pairs are deleted
and scsi_remove_host() waits for all outstanding SCSI commands to finish.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c  | 45 ++++++----------------------------
 2 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0eb1d5a790b26..ea1728fe2c768 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -562,7 +562,6 @@ typedef struct srb {
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
-#define SET_CMD_SP(sp, cmd) (sp->u.scmd.cmd = cmd)
 #define GET_CMD_CTX_SP(sp) (sp->u.scmd.ctx)
 
 #define GET_CMD_SENSE_LEN(sp) \
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 484045e4d194f..3aa2dd43945bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -727,7 +727,6 @@ qla2x00_sp_compl(void *ptr, int res)
 	cmd->scsi_done(cmd);
 	if (comp)
 		complete(comp);
-	qla2x00_rel_sp(sp);
 }
 
 void
@@ -832,7 +831,6 @@ qla2xxx_qpair_sp_compl(void *ptr, int res)
 	cmd->scsi_done(cmd);
 	if (comp)
 		complete(comp);
-	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
 static int
@@ -925,9 +923,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	else
 		goto qc24_target_busy;
 
-	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto qc24_host_busy;
+	sp = scsi_cmd_priv(cmd);
+	qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
@@ -948,9 +945,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 qc24_host_busy_free_sp:
 	sp->free(sp);
 
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
@@ -1011,9 +1005,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	else
 		goto qc24_target_busy;
 
-	sp = qla2xxx_get_qpair_sp(vha, qpair, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto qc24_host_busy;
+	sp = scsi_cmd_priv(cmd);
+	qla2xxx_init_sp(sp, vha, qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
@@ -1037,9 +1030,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 qc24_host_busy_free_sp:
 	sp->free(sp);
 
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
@@ -1280,10 +1270,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	int ret;
 	unsigned int id;
 	uint64_t lun;
-	unsigned long flags;
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_qpair *qpair;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1295,29 +1283,11 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (ret != 0)
 		return ret;
 
-	sp = (srb_t *) CMD_SP(cmd);
-	if (!sp)
-		return SUCCESS;
+	sp = scsi_cmd_priv(cmd);
 
-	qpair = sp->qpair;
-	if (!qpair)
-		return SUCCESS;
-
-	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	if (sp->type != SRB_SCSI_CMD || GET_CMD_SP(sp) != cmd) {
-		/* there's a chance an interrupt could clear
-		   the ptr as part of done & free */
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return SUCCESS;
-	}
-
-	/* Get a reference to the sp and drop the lock. */
-	if (sp_get(sp)){
-		/* ref_count is already 0 */
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+	/* Return if the command has already finished. */
+	if (sp_get(sp))
 		return SUCCESS;
-	}
-	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -7197,6 +7167,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.supported_mode		= MODE_INITIATOR,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(srb_t),
 };
 
 static const struct pci_error_handlers qla2xxx_err_handler = {
-- 
2.20.1



