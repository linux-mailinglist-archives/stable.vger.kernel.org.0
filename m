Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096B8121593
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbfLPSUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfLPSUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641E4207FF;
        Mon, 16 Dec 2019 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520438;
        bh=lGK49QzGsn6Km4EKllpGnP8ptxHvw55hR+s6dVJYePY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iICiR5tcxRvT5gXwZFiOLhJfqfJnEbR/2WCOTCX9tFCS858dn0oyxAz1vjubS7PNW
         uNB5OnrmcSaFHbN85M7HPnurjvwPNDjmbLG8hOhRo+UyVwtwLn2rJzT8NY5CxbvpO5
         jFGoexArmp6dgFSPbi3E7yNDTqCgBSg3Y/0MZMSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/177] scsi: qla2xxx: Fix SRB leak on switch command timeout
Date:   Mon, 16 Dec 2019 18:50:11 +0100
Message-Id: <20191216174848.492793496@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit af2a0c51b1205327f55a7e82e530403ae1d42cbb ]

when GPSC/GPDB switch command fails, driver just returns without doing a
proper cleanup. This patch fixes this memory leak by calling sp->free() in
the error path.

Link: https://lore.kernel.org/r/20191105150657.8092-4-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
 drivers/scsi/qla2xxx/qla_mbx.c  |  4 ----
 drivers/scsi/qla2xxx/qla_mid.c  | 11 ++++-------
 drivers/scsi/qla2xxx/qla_os.c   |  7 ++++++-
 5 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5298ed10059f2..84bb4a0480166 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3005,7 +3005,7 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, int res)
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
 	if (res == QLA_FUNCTION_TIMEOUT)
-		return;
+		goto done;
 
 	if (res == (DID_ERROR << 16)) {
 		/* entry status error */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8c0aae937c1f7..d400b51929a6e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1153,19 +1153,18 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
 	    "Async done-%s res %x, WWPN %8phC mb[1]=%x mb[2]=%x \n",
 	    sp->name, res, fcport->port_name, mb[1], mb[2]);
 
-	if (res == QLA_FUNCTION_TIMEOUT) {
-		dma_pool_free(sp->vha->hw->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
-			sp->u.iocb_cmd.u.mbx.in_dma);
-		return;
-	}
-
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
+	if (res == QLA_FUNCTION_TIMEOUT)
+		goto done;
+
 	memset(&ea, 0, sizeof(ea));
 	ea.fcport = fcport;
 	ea.sp = sp;
 
 	qla24xx_handle_gpdb_event(vha, &ea);
 
+done:
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4a1f21c11758e..4d90cf101f5fc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6287,17 +6287,13 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	case  QLA_SUCCESS:
 		ql_dbg(ql_dbg_mbx, vha, 0x119d, "%s: %s done.\n",
 		    __func__, sp->name);
-		sp->free(sp);
 		break;
 	default:
 		ql_dbg(ql_dbg_mbx, vha, 0x119e, "%s: %s Failed. %x.\n",
 		    __func__, sp->name, rval);
-		sp->free(sp);
 		break;
 	}
 
-	return rval;
-
 done_free_sp:
 	sp->free(sp);
 done:
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 238240984bc15..eabc5127174ed 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -946,7 +946,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
-		goto done;
+		return rval;
 
 	sp->type = SRB_CTRL_VP;
 	sp->name = "ctrl_vp";
@@ -962,7 +962,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 		ql_dbg(ql_dbg_async, vha, 0xffff,
 		    "%s: %s Failed submission. %x.\n",
 		    __func__, sp->name, rval);
-		goto done_free_sp;
+		goto done;
 	}
 
 	ql_dbg(ql_dbg_vport, vha, 0x113f, "%s hndl %x submitted\n",
@@ -980,16 +980,13 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	case QLA_SUCCESS:
 		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s done.\n",
 		    __func__, sp->name);
-		goto done_free_sp;
+		break;
 	default:
 		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s Failed. %x.\n",
 		    __func__, sp->name, rval);
-		goto done_free_sp;
+		break;
 	}
 done:
-	return rval;
-
-done_free_sp:
 	sp->free(sp);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 909c61cbf0fce..23c3927751637 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -986,7 +986,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
 		if (rval == QLA_INTERFACE_ERROR)
-			goto qc24_fail_command;
+			goto qc24_free_sp_fail_command;
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1000,6 +1000,11 @@ qc24_host_busy_free_sp:
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
+qc24_free_sp_fail_command:
+	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
+
 qc24_fail_command:
 	cmd->scsi_done(cmd);
 
-- 
2.20.1



