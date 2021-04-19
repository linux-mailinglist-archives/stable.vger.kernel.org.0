Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66636441D
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242196AbhDSNZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241697AbhDSNYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE6561413;
        Mon, 19 Apr 2021 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838347;
        bh=Zok86mvIIs6b1hFOANwu9hHHL3ybmkIcrTTnU/y+klg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdUYd1RL7FUhLtK75wN+xf8vi8GTRMrXgF3IDi8sig2h443AkmlbcIR22Wn1wIGi1
         AbKv/qOFh4p5LQmeqzjgwRJ9mtgTa6x0tSJpucxB4ld1ZrQK4Lzn+KiY8Orx1pvF6T
         HAMthGpseemwMGR06s+ZT+ihfPDtdmRmd0WKMeL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/73] scsi: qla2xxx: Fix fabric scan hang
Date:   Mon, 19 Apr 2021 15:05:59 +0200
Message-Id: <20210419130524.085206558@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit f57a0107359605b29f4ea9afb8ee2e03473b1448 ]

On timeout, SRB pointer was cleared from outstanding command array and
dropped.  It was not allowed to go through the done process and cleanup.
This patch will abort the SRB where FW will return it with an error status
and resume the normal cleanup.

Link: https://lore.kernel.org/r/20191217220617.28084-3-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 34 +++++++++++++++------------
 drivers/scsi/qla2xxx/qla_iocb.c | 41 ++++++++++++++++++++++++++-------
 3 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5a3c47eed645..7aa233771ec8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -256,6 +256,7 @@ extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
+extern int qla24xx_async_abort_cmd(srb_t *, bool);
 
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4f0c2c8414e..643b8ae36cbe 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -50,16 +50,9 @@ qla2x00_sp_timeout(struct timer_list *t)
 {
 	srb_t *sp = from_timer(sp, t, u.iocb_cmd.timer);
 	struct srb_iocb *iocb;
-	struct req_que *req;
-	unsigned long flags;
-	struct qla_hw_data *ha = sp->vha->hw;
 
-	WARN_ON_ONCE(irqs_disabled());
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = sp->qpair->req;
-	req->outstanding_cmds[sp->handle] = NULL;
+	WARN_ON(irqs_disabled());
 	iocb = &sp->u.iocb_cmd;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	iocb->timeout(sp);
 }
 
@@ -153,7 +146,7 @@ static void qla24xx_abort_sp_done(srb_t *sp, int res)
 		sp->free(sp);
 }
 
-static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
+int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
 	struct srb_iocb *abt_iocb;
@@ -253,6 +246,7 @@ qla2x00_async_iocb_timeout(void *data)
 	case SRB_NACK_PRLI:
 	case SRB_NACK_LOGO:
 	case SRB_CTRL_VP:
+	default:
 		rc = qla24xx_async_abort_cmd(sp, false);
 		if (rc) {
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
@@ -269,10 +263,6 @@ qla2x00_async_iocb_timeout(void *data)
 			sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
-	default:
-		WARN_ON_ONCE(true);
-		sp->done(sp, QLA_FUNCTION_TIMEOUT);
-		break;
 	}
 }
 
@@ -1794,9 +1784,23 @@ qla2x00_tmf_iocb_timeout(void *data)
 {
 	srb_t *sp = data;
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
+	int rc, h;
+	unsigned long flags;
 
-	tmf->u.tmf.comp_status = CS_TIMEOUT;
-	complete(&tmf->u.tmf.comp);
+	rc = qla24xx_async_abort_cmd(sp, false);
+	if (rc) {
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		tmf->u.tmf.comp_status = CS_TIMEOUT;
+		tmf->u.tmf.data = QLA_FUNCTION_FAILED;
+		complete(&tmf->u.tmf.comp);
+	}
 }
 
 static void qla2x00_tmf_sp_done(srb_t *sp, int res)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3f43410fab9d..936103604d02 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2537,13 +2537,32 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 	fc_port_t *fcport = sp->fcport;
 	struct scsi_qla_host *vha = sp->vha;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	unsigned long flags = 0;
+	int res, h;
 
 	ql_dbg(ql_dbg_io, vha, 0x3069,
 	    "%s Timeout, hdl=%x, portid=%02x%02x%02x\n",
 	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
 	    fcport->d_id.b.al_pa);
 
-	complete(&lio->u.els_logo.comp);
+	/* Abort the exchange */
+	res = qla24xx_async_abort_cmd(sp, false);
+	if (res) {
+		ql_dbg(ql_dbg_io, vha, 0x3070,
+		    "mbx abort_command failed.\n");
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		complete(&lio->u.els_logo.comp);
+	} else {
+		ql_dbg(ql_dbg_io, vha, 0x3071,
+		    "mbx abort_command success.\n");
+	}
 }
 
 static void qla2x00_els_dcmd_sp_done(srb_t *sp, int res)
@@ -2708,23 +2727,29 @@ qla2x00_els_dcmd2_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct scsi_qla_host *vha = sp->vha;
-	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
-	int res;
+	int res, h;
 
 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3069,
 	    "%s hdl=%x ELS Timeout, %8phC portid=%06x\n",
 	    sp->name, sp->handle, fcport->port_name, fcport->d_id.b24);
 
 	/* Abort the exchange */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	res = ha->isp_ops->abort_command(sp);
+	res = qla24xx_async_abort_cmd(sp, false);
 	ql_dbg(ql_dbg_io, vha, 0x3070,
 	    "mbx abort_command %s\n",
 	    (res == QLA_SUCCESS) ? "successful" : "failed");
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	sp->done(sp, QLA_FUNCTION_TIMEOUT);
+	if (res) {
+		spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
+		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
+			if (sp->qpair->req->outstanding_cmds[h] == sp) {
+				sp->qpair->req->outstanding_cmds[h] = NULL;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
+		sp->done(sp, QLA_FUNCTION_TIMEOUT);
+	}
 }
 
 void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha, struct els_plogi *els_plogi)
-- 
2.30.2



