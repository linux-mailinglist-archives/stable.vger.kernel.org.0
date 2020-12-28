Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD07C2E4065
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436591AbgL1Ov6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502048AbgL1OS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C7AB22583;
        Mon, 28 Dec 2020 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165097;
        bh=XQEDDdIn3ERgUhr4RYvv7iAKLr6RTXrb39PdQgx4G5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBipS9EXNReQMG4aLHaL1bBeY8meJDcCQolC6uU2EolVV8V6pz5mYcX2A60I+tUK6
         XtwNvRRlYSRXGjRGLjx5wgJt5mKZ2IDySiauJrVPYSSzxp2ucZVAhuPmeYY9gSwVTv
         jElaHRuYbNl0jurST0+ICBUF1ZDm6g1kufrC4wTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/717] scsi: qla2xxx: Fix N2N and NVMe connect retry failure
Date:   Mon, 28 Dec 2020 13:46:18 +0100
Message-Id: <20201228125039.208128029@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 07a5f69248e3486e387c40af64793466371c7d91 ]

FC-NVMe target discovery failed when initiator wwpn < target wwpn in an N2N
(Direct Attach) config, where the driver was stuck on FCP PRLI mode and
failed to retry with NVMe PRLI.

Link: https://lore.kernel.org/r/20201202132312.19966-10-njavali@marvell.com
Fixes: 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port support”)
Fixes: 983f127603fa ("scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure”)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 71 ++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  |  3 --
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 898c70b8ebbf6..52e8b555bd1dc 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1268,9 +1268,10 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 		lio->u.logio.flags |= SRB_LOGIN_NVME_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x211b,
-	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d %s.\n",
+	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d fc4type %x priority %x %s.\n",
 	    fcport->port_name, sp->handle, fcport->loop_id, fcport->d_id.b24,
-	    fcport->login_retry, NVME_TARGET(vha->hw, fcport) ? "nvme" : "fc");
+	    fcport->login_retry, fcport->fc4_type, vha->hw->fc4_type_priority,
+	    NVME_TARGET(vha->hw, fcport) ? "nvme" : "fcp");
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -1932,26 +1933,58 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		/*
-		 * Retry PRLI with other FC-4 type if failure occurred on dual
-		 * FCP/NVMe port
-		 */
-		if (NVME_FCP_TARGET(ea->fcport)) {
-			ql_dbg(ql_dbg_disc, vha, 0x2118,
-				"%s %d %8phC post %s prli\n",
-				__func__, __LINE__, ea->fcport->port_name,
-				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
-				"NVMe" : "FCP");
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+		ql_dbg(ql_dbg_disc, vha, 0x2118,
+		       "%s %d %8phC priority %s, fc4type %x\n",
+		       __func__, __LINE__, ea->fcport->port_name,
+		       vha->hw->fc4_type_priority == FC4_PRIORITY_FCP ?
+		       "FCP" : "NVMe", ea->fcport->fc4_type);
+
+		if (N2N_TOPO(vha->hw)) {
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME) {
 				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-			else
+				ea->fcport->fc4_type |= FS_FC4TYPE_FCP;
+			} else {
 				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
-		}
+				ea->fcport->fc4_type |= FS_FC4TYPE_NVME;
+			}
 
-		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		ea->fcport->keep_nport_handle = 0;
-		ea->fcport->logout_on_delete = 1;
-		qlt_schedule_sess_for_deletion(ea->fcport);
+			if (ea->fcport->n2n_link_reset_cnt < 3) {
+				ea->fcport->n2n_link_reset_cnt++;
+				vha->relogin_jif = jiffies + 2 * HZ;
+				/*
+				 * PRLI failed. Reset link to kick start
+				 * state machine
+				 */
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2119,
+				       "%s %d %8phC Unable to reconnect\n",
+				       __func__, __LINE__,
+				       ea->fcport->port_name);
+			}
+		} else {
+			/*
+			 * switch connect. login failed. Take connection down
+			 * and allow relogin to retrigger
+			 */
+			if (NVME_FCP_TARGET(ea->fcport)) {
+				ql_dbg(ql_dbg_disc, vha, 0x2118,
+				       "%s %d %8phC post %s prli\n",
+				       __func__, __LINE__,
+				       ea->fcport->port_name,
+				       (ea->fcport->fc4_type & FS_FC4TYPE_NVME)
+				       ? "NVMe" : "FCP");
+				if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+					ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+				else
+					ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
+			}
+
+			ea->fcport->flags &= ~FCF_ASYNC_SENT;
+			ea->fcport->keep_nport_handle = 0;
+			ea->fcport->logout_on_delete = 1;
+			qlt_schedule_sess_for_deletion(ea->fcport);
+		}
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bef871a890281..d6325fb2ef73b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3998,9 +3998,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
-				fcport->fc4_type = FS_FC4TYPE_FCP;
-				if (vha->flags.nvme_enabled)
-					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				if (wwn_to_u64(vha->port_name) >
 				    wwn_to_u64(fcport->port_name)) {
-- 
2.27.0



