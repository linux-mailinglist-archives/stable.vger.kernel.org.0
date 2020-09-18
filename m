Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846E426F1AF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgIRCxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgIRCHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0477238E6;
        Fri, 18 Sep 2020 02:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394870;
        bh=TNuMXUSu/bR+ysoAQH0qwvA50BIrQ55XDiwSOXypyXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFxrlI+wV/C7MbIrZd+7H7o7ltiTlaE8Z1s43kNDYpZFD9oD2H0gpbItgof1iJGd8
         zhXZNHI8m5G9nmSQY6VQxxt0uOYhtSj7PA2BkxNnNHybJszsWPQlRMb9cF//yg8QHZ
         Jmj6LksbZC629E55tGcGY7Sj8vEwUg0yWtjLr01g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 322/330] scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
Date:   Thu, 17 Sep 2020 22:01:02 -0400
Message-Id: <20200918020110.2063155-322-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/scsi/qla2xxx/qla_init.c | 28 ++++------------------------
 drivers/scsi/qla2xxx/qla_iocb.c |  6 +++++-
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2f2e059f4575e..62d2ee825c97a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1911,33 +1911,13 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 				"%s %d %8phC post fc4 prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->fc4f_nvme = 0;
-			qla24xx_post_prli_work(vha, ea->fcport);
 			return;
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
index 2e272fc858ed1..aed4ce66e6cf9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2773,6 +2773,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
 			break;
+
 		case CS_IOCB_ERROR:
 			switch (fw_status[1]) {
 			case LSC_SCODE_PORTID_USED:
@@ -2843,6 +2844,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
+				fcport->disc_state = DSC_LOGIN_FAILED;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2855,6 +2857,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			sp->fcport->disc_state = DSC_LOGIN_FAILED;
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2890,11 +2893,12 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
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
2.25.1

