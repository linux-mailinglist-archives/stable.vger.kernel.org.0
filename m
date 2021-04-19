Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A3736440A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbhDSNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241573AbhDSNWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C227261246;
        Mon, 19 Apr 2021 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838294;
        bh=BQVHToEoY2kl8WmCRd6jexkuuNMPWppkSr0FTppVsX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q63P8wYEFWdI8XUN5IsYRvdld6gZBMCDOro/JMl2TKH3pcOc+LlkufDnjfQlRRFQR
         pGLL2HTtM70ACrjwAWHK+6QALmUojfJZDQ2nRpURnuXFaMqu8Xw+7M2KIXflepqC3E
         QYTw/51SWd2ovwONyVURg0BIzQjMb2SKVnR4qbDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/73] Revert "scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure"
Date:   Mon, 19 Apr 2021 15:05:52 +0200
Message-Id: <20210419130523.853799528@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 74924e407bf74667b07430f785a104371be097af.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 28 ++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_iocb.c |  6 +-----
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b300e1109582..05a22fb17e52 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1921,13 +1921,33 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 				"%s %d %8phC post fc4 prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->fc4f_nvme = 0;
+			qla24xx_post_prli_work(vha, ea->fcport);
 			return;
 		}
 
-		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		ea->fcport->keep_nport_handle = 0;
-		ea->fcport->logout_on_delete = 1;
-		qlt_schedule_sess_for_deletion(ea->fcport);
+		/* at this point both PRLI NVME & PRLI FCP failed */
+		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt < 3) {
+				ea->fcport->n2n_link_reset_cnt++;
+				/*
+				 * remote port is not sending Plogi. Reset
+				 * link to kick start his state machine
+				 */
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2119,
+				    "%s %d %8phC Unable to reconnect\n",
+				    __func__, __LINE__, ea->fcport->port_name);
+			}
+		} else {
+			/*
+			 * switch connect. login failed. Take connection
+			 * down and allow relogin to retrigger
+			 */
+			ea->fcport->flags &= ~FCF_ASYNC_SENT;
+			ea->fcport->keep_nport_handle = 0;
+			qlt_schedule_sess_for_deletion(ea->fcport);
+		}
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index aed4ce66e6cf..2e272fc858ed 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2773,7 +2773,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
 			break;
-
 		case CS_IOCB_ERROR:
 			switch (fw_status[1]) {
 			case LSC_SCODE_PORTID_USED:
@@ -2844,7 +2843,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				fcport->disc_state = DSC_LOGIN_FAILED;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2857,7 +2855,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			sp->fcport->disc_state = DSC_LOGIN_FAILED;
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2893,12 +2890,11 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		return -ENOMEM;
 	}
 
-	fcport->flags |= FCF_ASYNC_SENT;
-	fcport->disc_state = DSC_LOGIN_PEND;
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-- 
2.30.2



