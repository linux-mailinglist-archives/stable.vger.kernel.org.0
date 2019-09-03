Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB1A6E51
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbfICQZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbfICQZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0485923717;
        Tue,  3 Sep 2019 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527928;
        bh=ebni2Q/ND9c27z/FRRPtQ6XbVmW0cE2YmgCn70MAkkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVbRpHGI1/6Nts9d2y+iYuRvfT+4n55028mT7D2TMxuAYR6qVt1zCxd7pfYtjoiHr
         J9W9IEeCrXC7/u3Qdoc7RXnzCGcBhh2lOrzp84HvgjaEMfwCLV2ftrcu8skuQQYDAW
         sPtqBWlCNMauj1MzDGI4BqDM/JQV05Xkk3eqwWjU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giridhar Malavali <giridhar.malavali@cavium.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/167] scsi: qla2xxx: Move log messages before issuing command to firmware
Date:   Tue,  3 Sep 2019 12:22:36 -0400
Message-Id: <20190903162519.7136-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@cavium.com>

[ Upstream commit 9fe278f44b4bc06cc61e33b2af65f87d507d13d0 ]

There is a probability that the SRB structure might have been released by the
time the debug log message dereferences it.  This patch moved the log messages
before the command is issued to the firmware to prevent unknown behavior and
kernel crash

Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 15 ++++++-----
 drivers/scsi/qla2xxx/qla_init.c | 48 +++++++++++++++++----------------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 1f1a05a90d3d7..fc08e46a93ca9 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3360,15 +3360,15 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla24xx_async_gpsc_sp_done;
 
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
 	ql_dbg(ql_dbg_disc, vha, 0x205e,
 	    "Async-%s %8phC hdl=%x loopid=%x portid=%02x%02x%02x.\n",
 	    sp->name, fcport->port_name, sp->handle,
 	    fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
 	return rval;
 
 done_free_sp:
@@ -3729,13 +3729,14 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_gpnid_sp_done;
 
+	ql_dbg(ql_dbg_disc, vha, 0x2067,
+	    "Async-%s hdl=%x ID %3phC.\n", sp->name,
+	    sp->handle, ct_req->req.port_id.port_id);
+
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 
-	ql_dbg(ql_dbg_disc, vha, 0x2067,
-	    "Async-%s hdl=%x ID %3phC.\n", sp->name,
-	    sp->handle, ct_req->req.port_id.port_id);
 	return rval;
 
 done_free_sp:
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ddce32fe0513a..39a8f4a671aaa 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -247,6 +247,12 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	}
 
+	ql_dbg(ql_dbg_disc, vha, 0x2072,
+	    "Async-login - %8phC hdl=%x, loopid=%x portid=%02x%02x%02x "
+		"retries=%d.\n", fcport->port_name, sp->handle, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
+	    fcport->login_retry);
+
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		fcport->flags |= FCF_LOGIN_NEEDED;
@@ -254,11 +260,6 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		goto done_free_sp;
 	}
 
-	ql_dbg(ql_dbg_disc, vha, 0x2072,
-	    "Async-login - %8phC hdl=%x, loopid=%x portid=%02x%02x%02x "
-		"retries=%d.\n", fcport->port_name, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
-	    fcport->login_retry);
 	return rval;
 
 done_free_sp:
@@ -303,15 +304,16 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	sp->done = qla2x00_async_logout_sp_done;
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 		fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		fcport->port_name);
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
 	return rval;
 
 done_free_sp:
@@ -489,13 +491,15 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	sp->done = qla2x00_async_adisc_sp_done;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x206f,
 	    "Async-adisc - hdl=%x loopid=%x portid=%06x %8phC.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b24, fcport->port_name);
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
 	return rval;
 
 done_free_sp:
@@ -1161,14 +1165,13 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 
 	sp->done = qla24xx_async_gpdb_sp_done;
 
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
 	ql_dbg(ql_dbg_disc, vha, 0x20dc,
 	    "Async-%s %8phC hndl %x opt %x\n",
 	    sp->name, fcport->port_name, sp->handle, opt);
 
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
 	return rval;
 
 done_free_sp:
@@ -1698,15 +1701,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	tm_iocb->u.tmf.data = tag;
 	sp->done = qla2x00_tmf_sp_done;
 
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
 	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
 	wait_for_completion(&tm_iocb->u.tmf.comp);
 
 	rval = tm_iocb->u.tmf.data;
@@ -1790,14 +1792,14 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 
 	sp->done = qla24xx_abort_sp_done;
 
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-
 	ql_dbg(ql_dbg_async, vha, 0x507c,
 	    "Abort command issued - hdl=%x, target_id=%x\n",
 	    cmd_sp->handle, fcport->tgt_id);
 
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
 	if (wait) {
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
-- 
2.20.1

