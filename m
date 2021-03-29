Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19E34CAEC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhC2IlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhC2IkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E6461879;
        Mon, 29 Mar 2021 08:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007204;
        bh=pv+Mqy/Q/cWIHzluPiCL+4RTrZeEi277F4dqWh/aakc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVSgue/jfNSzYsx5sgBQINRVFN6yN2Klov4YQ369QNovzM4iAkX4K0Qcz8XAUYOXX
         6EhL7hZ9b8XasTmEPdWYc3b8vZ1F94+J8rCbkYUaIOKToEfJMtaST3A1qDJTxXHaO2
         2MsUqZzdCCCWQAU6pr1ft3D82a007QJ+T3DISSSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 236/254] scsi: Revert "qla2xxx: Make sure that aborted commands are freed"
Date:   Mon, 29 Mar 2021 09:59:12 +0200
Message-Id: <20210329075640.840512138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 39c0c8553bfb5a3d108aa47f1256076d507605e3 ]

Calling vha->hw->tgt.tgt_ops->free_cmd() from qlt_xmit_response() is wrong
since the command for which a response is sent must remain valid until the
SCSI target core calls .release_cmd(). It has been observed that the
following scenario triggers a kernel crash:

 - qlt_xmit_response() calls qlt_check_reserve_free_req()

 - qlt_check_reserve_free_req() returns -EAGAIN

 - qlt_xmit_response() calls vha->hw->tgt.tgt_ops->free_cmd(cmd)

 - transport_handle_queue_full() tries to retransmit the response

Fix this crash by reverting the patch that introduced it.

Link: https://lore.kernel.org/r/20210320232359.941-2-bvanassche@acm.org
Fixes: 0dcec41acb85 ("scsi: qla2xxx: Make sure that aborted commands are freed")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 ----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0d09480b66cd..17f541030f5b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3223,8 +3223,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
@@ -3235,8 +3234,9 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
-	if (unlikely(res != 0))
-		goto free;
+	if (unlikely(res != 0)) {
+		return res;
+	}
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
@@ -3256,8 +3256,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3360,8 +3359,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-free:
-	vha->hw->tgt.tgt_ops->free_cmd(cmd);
 	return res;
 }
 EXPORT_SYMBOL(qlt_xmit_response);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b55fc768a2a7..8b4890cdd4ca 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -644,7 +644,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -657,7 +656,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 
@@ -685,7 +683,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	if (cmd->aborted) {
@@ -699,7 +696,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
 		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
 		    cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 	cmd->bufflen = se_cmd->data_length;
-- 
2.30.1



