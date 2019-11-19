Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F0710142D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKSFbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfKSFbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB949222A2;
        Tue, 19 Nov 2019 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141463;
        bh=zuLtBxqoShOEKBcibThSP4Me7FHzULUBCV1I9HlOyVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlHDa1k7gZmgqbrUwrVJQuxAdCoVZB5+Kv4NVpB6xCZjuYnuDfs/P2ttN/PFQXYJU
         XBXfo7wo0U9+zWgNSPI1pwo9ufuKZ+jEl1dd7N7iwM/9S8KMpTSrb/pebPp+T+dEBC
         m9vdZKIINuJhaVatfu8tHOfmrKZKtOZRjMr4p4Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/422] scsi: qla2xxx: Use correct qpair for ABTS/CMD
Date:   Tue, 19 Nov 2019 06:16:05 +0100
Message-Id: <20191119051409.307913859@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 49cecca7dd49e2950ed6d973acfa84e7c8c7a480 ]

On Abort of initiator scsi command, the abort needs to follow the same qpair
as the the scsi command to prevent out of order processing.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++----------
 drivers/scsi/qla2xxx/qla_iocb.c | 12 +++++++-----
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bee9cfb291529..e5ecef94aebdb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1772,18 +1772,18 @@ int
 qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 {
 	scsi_qla_host_t *vha = cmd_sp->vha;
-	fc_port_t *fcport = cmd_sp->fcport;
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 
-	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	sp = qla2xxx_get_qpair_sp(cmd_sp->qpair, cmd_sp->fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
+	sp->qpair = cmd_sp->qpair;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
@@ -1792,18 +1792,13 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
 
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
-
-	if (vha->flags.qpairs_available && cmd_sp->qpair)
-		abt_iocb->u.abt.req_que_no =
-		    cpu_to_le16(cmd_sp->qpair->req->id);
-	else
-		abt_iocb->u.abt.req_que_no = cpu_to_le16(vha->req->id);
+	abt_iocb->u.abt.req_que_no = cpu_to_le16(cmd_sp->qpair->req->id);
 
 	sp->done = qla24xx_abort_sp_done;
 
 	ql_dbg(ql_dbg_async, vha, 0x507c,
-	    "Abort command issued - hdl=%x, target_id=%x\n",
-	    cmd_sp->handle, fcport->tgt_id);
+	    "Abort command issued - hdl=%x, type=%x\n",
+	    cmd_sp->handle, cmd_sp->type);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 119927220299e..c699bbb8485bb 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3297,19 +3297,21 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 {
 	struct srb_iocb *aio = &sp->u.iocb_cmd;
 	scsi_qla_host_t *vha = sp->vha;
-	struct req_que *req = vha->req;
+	struct req_que *req = sp->qpair->req;
 
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
 	abt_iocb->entry_type = ABORT_IOCB_TYPE;
 	abt_iocb->entry_count = 1;
 	abt_iocb->handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
-	abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	if (sp->fcport) {
+		abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
+		abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
+		abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+	}
 	abt_iocb->handle_to_abort =
 	    cpu_to_le32(MAKE_HANDLE(aio->u.abt.req_que_no,
 				    aio->u.abt.cmd_hndl));
-	abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
-	abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
-	abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
 	abt_iocb->vp_index = vha->vp_idx;
 	abt_iocb->req_que_no = cpu_to_le16(aio->u.abt.req_que_no);
 	/* Send the command to the firmware */
-- 
2.20.1



