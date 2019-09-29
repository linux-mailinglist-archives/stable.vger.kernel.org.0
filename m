Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB8C14EF
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfI2N7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbfI2N7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04FC21882;
        Sun, 29 Sep 2019 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765556;
        bh=7I/7TJjRXumpUmGCVVswASnOwdjkMxIlJxWCtUuC1XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4nkGdLJhEpqV0Jzqc/GfwKyexri7ahTXIqghQQTEe0n7HRzQdxyNlkqxYSpv+mOc
         jkUdEG07vxG+HXFPNBalfCZT4dGWIw/+Wm2YOOc9mHJMRyThvVSC9OE4wonyYsIMhZ
         RdNXxIPsDiwhmSPKzvj2jcZTDuAculTmOph26yHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/63] scsi: qla2xxx: Remove all rports if fabric scan retry fails
Date:   Sun, 29 Sep 2019 15:54:12 +0200
Message-Id: <20190929135038.875619341@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 9ba1cb25c151de306d64647e545d34af64f30c19 ]

When all fabric scan retries fail, remove all RPorts, DMA resources for the
command. Otherwise we have stale Rports.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 128 +++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 98d936f18b65e..34ff4bbc8de10 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4045,6 +4045,41 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	}
 }
 
+static int qla2x00_post_gnnft_gpnft_done_work(struct scsi_qla_host *vha,
+    srb_t *sp, int cmd)
+{
+	struct qla_work_evt *e;
+
+	if (cmd != QLA_EVT_GPNFT_DONE && cmd != QLA_EVT_GNNFT_DONE)
+		return QLA_PARAMETER_ERROR;
+
+	e = qla2x00_alloc_work(vha, cmd);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.iosb.sp = sp;
+
+	return qla2x00_post_work(vha, e);
+}
+
+static int qla2x00_post_nvme_gpnft_done_work(struct scsi_qla_host *vha,
+    srb_t *sp, int cmd)
+{
+	struct qla_work_evt *e;
+
+	if (cmd != QLA_EVT_GPNFT)
+		return QLA_PARAMETER_ERROR;
+
+	e = qla2x00_alloc_work(vha, cmd);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.gpnft.fc4_type = FC4_TYPE_NVME;
+	e->u.gpnft.sp = sp;
+
+	return qla2x00_post_work(vha, e);
+}
+
 static void qla2x00_find_free_fcp_nvme_slot(struct scsi_qla_host *vha,
 	struct srb *sp)
 {
@@ -4145,22 +4180,36 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 {
 	struct srb *sp = s;
 	struct scsi_qla_host *vha = sp->vha;
-	struct qla_work_evt *e;
 	struct ct_sns_req *ct_req =
 		(struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
 	u16 cmd = be16_to_cpu(ct_req->command);
 	u8 fc4_type = sp->gen2;
 	unsigned long flags;
+	int rc;
 
 	/* gen2 field is holding the fc4type */
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async done-%s res %x FC4Type %x\n",
 	    sp->name, res, sp->gen2);
 
+	sp->rc = res;
 	if (res) {
 		unsigned long flags;
+		const char *name = sp->name;
+
+		/*
+		 * We are in an Interrupt context, queue up this
+		 * sp for GNNFT_DONE work. This will allow all
+		 * the resource to get freed up.
+		 */
+		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
+		    QLA_EVT_GNNFT_DONE);
+		if (rc) {
+			/* Cleanup here to prevent memory leak */
+			qla24xx_sp_unmap(vha, sp);
+			sp->free(sp);
+		}
 
-		sp->free(sp);
 		spin_lock_irqsave(&vha->work_lock, flags);
 		vha->scan.scan_flags &= ~SF_SCANNING;
 		vha->scan.scan_retry++;
@@ -4171,9 +4220,9 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else {
-			ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
-			    "Async done-%s rescan failed on all retries\n",
-			    sp->name);
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "Async done-%s rescan failed on all retries.\n",
+			    name);
 		}
 		return;
 	}
@@ -4188,80 +4237,31 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		vha->scan.scan_flags &= ~SF_SCANNING;
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 
-		e = qla2x00_alloc_work(vha, QLA_EVT_GPNFT);
-		if (!e) {
-			/*
-			 * please ignore kernel warning. Otherwise,
-			 * we have mem leak.
-			 */
-			if (sp->u.iocb_cmd.u.ctarg.req) {
-				dma_free_coherent(&vha->hw->pdev->dev,
-				    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
-				    sp->u.iocb_cmd.u.ctarg.req,
-				    sp->u.iocb_cmd.u.ctarg.req_dma);
-				sp->u.iocb_cmd.u.ctarg.req = NULL;
-			}
-			if (sp->u.iocb_cmd.u.ctarg.rsp) {
-				dma_free_coherent(&vha->hw->pdev->dev,
-				    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
-				    sp->u.iocb_cmd.u.ctarg.rsp,
-				    sp->u.iocb_cmd.u.ctarg.rsp_dma);
-				sp->u.iocb_cmd.u.ctarg.rsp = NULL;
-			}
-
-			ql_dbg(ql_dbg_disc, vha, 0xffff,
-			    "Async done-%s unable to alloc work element\n",
-			    sp->name);
-			sp->free(sp);
+		sp->rc = res;
+		rc = qla2x00_post_nvme_gpnft_done_work(vha, sp, QLA_EVT_GPNFT);
+		if (!rc) {
+			qla24xx_sp_unmap(vha, sp);
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			return;
 		}
-		e->u.gpnft.fc4_type = FC4_TYPE_NVME;
-		sp->rc = res;
-		e->u.gpnft.sp = sp;
-
-		qla2x00_post_work(vha, e);
-		return;
 	}
 
 	if (cmd == GPN_FT_CMD) {
 		del_timer(&sp->u.iocb_cmd.timer);
-		e = qla2x00_alloc_work(vha, QLA_EVT_GPNFT_DONE);
+		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
+		    QLA_EVT_GPNFT_DONE);
 	} else {
-		e = qla2x00_alloc_work(vha, QLA_EVT_GNNFT_DONE);
+		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
+		    QLA_EVT_GNNFT_DONE);
 	}
 
-	if (!e) {
-		/* please ignore kernel warning. Otherwise, we have mem leak. */
-		if (sp->u.iocb_cmd.u.ctarg.req) {
-			dma_free_coherent(&vha->hw->pdev->dev,
-			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
-			    sp->u.iocb_cmd.u.ctarg.req,
-			    sp->u.iocb_cmd.u.ctarg.req_dma);
-			sp->u.iocb_cmd.u.ctarg.req = NULL;
-		}
-		if (sp->u.iocb_cmd.u.ctarg.rsp) {
-			dma_free_coherent(&vha->hw->pdev->dev,
-			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
-			    sp->u.iocb_cmd.u.ctarg.rsp,
-			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
-			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
-		}
-
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-		    "Async done-%s unable to alloc work element\n",
-		    sp->name);
-		sp->free(sp);
+	if (rc) {
+		qla24xx_sp_unmap(vha, sp);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		return;
 	}
-
-	sp->rc = res;
-	e->u.iosb.sp = sp;
-
-	qla2x00_post_work(vha, e);
 }
 
 /*
-- 
2.20.1



