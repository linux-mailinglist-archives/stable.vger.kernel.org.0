Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA736441B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbhDSNZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240531AbhDSNXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD1461410;
        Mon, 19 Apr 2021 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838339;
        bh=mrN6450j1DcZd/ehag09LAIRDS7woaKBLxGCQc7bEI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke3OSC2l0SAkCXDIIqg3Xw4VTBu/PCTW2lEfGsLkvtaeohxEJKuE+0FVfPcqWhHD+
         Zvfwn3GJxo3Fu/7y3ZtVpHl3sDQzIdL1oOssrPtAmxZTag/rI3Nad2QmiEdB3C6d5s
         m7j/qQgjqMo+wg4U9HcbfemyYZFohBsBHi7o0EBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/73] scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
Date:   Mon, 19 Apr 2021 15:05:56 +0200
Message-Id: <20210419130523.985867844@linuxfoundation.org>
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

[ Upstream commit 983f127603fac650fa34ee69db363e4615eaf9e7 ]

Current code will send PRLI with FC-NVMe bit set for the targets which
support only FCP. This may result into issue with targets which do not
understand NVMe and will go into a strange state. This patch would restart
the login process by going back to PLOGI state. The PLOGI state will force
the target to respond to correct PRLI request.

Fixes: c76ae845ea836 ("scsi: qla2xxx: Add error handling for PLOGI ELS passthrough")
Cc: stable@vger.kernel.org # 5.4
Link: https://lore.kernel.org/r/20191105150657.8092-2-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 37 +++++++--------------------------
 drivers/scsi/qla2xxx/qla_iocb.c |  6 +++++-
 2 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 633317651138..5d2d0c287469 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1911,42 +1911,21 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * FCP/NVMe port
 		 */
 		if (NVME_FCP_TARGET(ea->fcport)) {
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-			else
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post %s prli\n",
 				__func__, __LINE__, ea->fcport->port_name,
 				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
 				"NVMe" : "FCP");
-			qla24xx_post_prli_work(vha, ea->fcport);
-			break;
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+			else
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 		}
 
-		/* at this point both PRLI NVME & PRLI FCP failed */
-		if (N2N_TOPO(vha->hw)) {
-			if (ea->fcport->n2n_link_reset_cnt < 3) {
-				ea->fcport->n2n_link_reset_cnt++;
-				/*
-				 * remote port is not sending Plogi. Reset
-				 * link to kick start his state machine
-				 */
-				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
-			} else {
-				ql_log(ql_log_warn, vha, 0x2119,
-				    "%s %d %8phC Unable to reconnect\n",
-				    __func__, __LINE__, ea->fcport->port_name);
-			}
-		} else {
-			/*
-			 * switch connect. login failed. Take connection
-			 * down and allow relogin to retrigger
-			 */
-			ea->fcport->flags &= ~FCF_ASYNC_SENT;
-			ea->fcport->keep_nport_handle = 0;
-			qlt_schedule_sess_for_deletion(ea->fcport);
-		}
+		ea->fcport->flags &= ~FCF_ASYNC_SENT;
+		ea->fcport->keep_nport_handle = 0;
+		ea->fcport->logout_on_delete = 1;
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c0720c8e2f6d..53ccbd6b71ed 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2772,6 +2772,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			ea.rc = res;
 			qla_handle_els_plogi_done(vha, &ea);
 			break;
+
 		case CS_IOCB_ERROR:
 			switch (fw_status[1]) {
 			case LSC_SCODE_PORTID_USED:
@@ -2842,6 +2843,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
+				fcport->disc_state = DSC_LOGIN_FAILED;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2854,6 +2856,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			sp->fcport->disc_state = DSC_LOGIN_FAILED;
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2889,11 +2892,12 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		return -ENOMEM;
 	}
 
+	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-- 
2.30.2



