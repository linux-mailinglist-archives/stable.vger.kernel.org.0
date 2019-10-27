Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4CE6703
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfJ0VRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfJ0VRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:19 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66399205C9;
        Sun, 27 Oct 2019 21:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211037;
        bh=UTMI8rC30fix7yYGNfoLYOjl4RSn/OECqMr1VK0eCic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7amHDas3xEQNHGQHo7CjaKDLcYU/3jbEzIDlzG24TD5to/G01jO4oxI5TUYW00tY
         oGRjhSTsO84ZdcBxKt03EK9V899eQm9PGJqA/lRv/au/E8iUuS8soJtPhAzWJeEXtY
         4fNmoNW5pSgIu+sUxqsCxFK8ONtRdVIUnuNow6v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 011/197] scsi: qla2xxx: Fix N2N link reset
Date:   Sun, 27 Oct 2019 21:58:49 +0100
Message-Id: <20191027203352.288882826@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 7f2a398d59d658818f3d219645164676fbbc88e8 ]

Fix stalled link recovery for N2N with FC-NVMe connection.

Link: https://lore.kernel.org/r/20190912180918.6436-6-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |   3 +-
 drivers/scsi/qla2xxx/qla_init.c | 107 +++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  |  23 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |   4 ++
 4 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bad2b12604f1b..a2922b17b55b0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2338,6 +2338,7 @@ typedef struct fc_port {
 	unsigned int query:1;
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
+	unsigned int n2n_flag:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2388,7 +2389,6 @@ typedef struct fc_port {
 	uint8_t fc4_type;
 	uint8_t	fc4f_nvme;
 	uint8_t scan_state;
-	uint8_t n2n_flag;
 
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
@@ -2979,6 +2979,7 @@ enum scan_flags_t {
 enum fc4type_t {
 	FS_FC4TYPE_FCP	= BIT_0,
 	FS_FC4TYPE_NVME	= BIT_1,
+	FS_FCP_IS_N2N = BIT_7,
 };
 
 struct fab_scan_rp {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3fbe909744a8f..cd74cc9651dea 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -746,12 +746,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			break;
 		default:
 			if ((id.b24 != fcport->d_id.b24 &&
-			    fcport->d_id.b24) ||
+			    fcport->d_id.b24 &&
+			    fcport->loop_id != FC_NO_LOOP_ID) ||
 			    (fcport->loop_id != FC_NO_LOOP_ID &&
 				fcport->loop_id != loop_id)) {
 				ql_dbg(ql_dbg_disc, vha, 0x20e3,
 				    "%s %d %8phC post del sess\n",
 				    __func__, __LINE__, fcport->port_name);
+				if (fcport->n2n_flag)
+					fcport->d_id.b24 = 0;
 				qlt_schedule_sess_for_deletion(fcport);
 				return;
 			}
@@ -759,6 +762,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		}
 
 		fcport->loop_id = loop_id;
+		if (fcport->n2n_flag)
+			fcport->d_id.b24 = id.b24;
 
 		wwn = wwn_to_u64(fcport->port_name);
 		qlt_find_sess_invalidate_other(vha, wwn,
@@ -966,7 +971,7 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 		wwn = wwn_to_u64(e->port_name);
 
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20e8,
-		    "%s %8phC %02x:%02x:%02x state %d/%d lid %x \n",
+		    "%s %8phC %02x:%02x:%02x CLS %x/%x lid %x \n",
 		    __func__, (void *)&wwn, e->port_id[2], e->port_id[1],
 		    e->port_id[0], e->current_login_state, e->last_login_state,
 		    (loop_id & 0x7fff));
@@ -1498,7 +1503,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
 
-	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP &&
+	    !N2N_TOPO(vha->hw)) {
 		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			return 0;
@@ -1569,8 +1575,9 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				qla24xx_post_gpdb_work(vha, fcport, 0);
 			}  else {
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
-				    "%s %d %8phC post NVMe PRLI\n",
-				    __func__, __LINE__, fcport->port_name);
+				    "%s %d %8phC post %s PRLI\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->fc4f_nvme ? "NVME" : "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1924,17 +1931,38 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		if (ea->fcport->n2n_flag) {
+		if (ea->fcport->fc4f_nvme) {
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post fc4 prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->fc4f_nvme = 0;
-			ea->fcport->n2n_flag = 0;
 			qla24xx_post_prli_work(vha, ea->fcport);
+			return;
+		}
+
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
 		}
-		ql_dbg(ql_dbg_disc, vha, 0x2119,
-		    "%s %d %8phC unhandle event of %x\n",
-		    __func__, __LINE__, ea->fcport->port_name, ea->data[0]);
 		break;
 	}
 }
@@ -5078,28 +5106,47 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	unsigned long flags;
 
 	/* Inititae N2N login. */
-	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
-		/* borrowing */
-		u32 *bp, i, sz;
-
-		memset(ha->init_cb, 0, ha->init_cb_size);
-		sz = min_t(int, sizeof(struct els_plogi_payload),
-		    ha->init_cb_size);
-		rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
-		    (void *)ha->init_cb, sz);
-		if (rval == QLA_SUCCESS) {
-			bp = (uint32_t *)ha->init_cb;
-			for (i = 0; i < sz/4 ; i++, bp++)
-				*bp = cpu_to_be32(*bp);
+	if (N2N_TOPO(ha)) {
+		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
+			/* borrowing */
+			u32 *bp, i, sz;
+
+			memset(ha->init_cb, 0, ha->init_cb_size);
+			sz = min_t(int, sizeof(struct els_plogi_payload),
+			    ha->init_cb_size);
+			rval = qla24xx_get_port_login_templ(vha,
+			    ha->init_cb_dma, (void *)ha->init_cb, sz);
+			if (rval == QLA_SUCCESS) {
+				bp = (uint32_t *)ha->init_cb;
+				for (i = 0; i < sz/4 ; i++, bp++)
+					*bp = cpu_to_be32(*bp);
 
-			memcpy(&ha->plogi_els_payld.data, (void *)ha->init_cb,
-			    sizeof(ha->plogi_els_payld.data));
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		} else {
-			ql_dbg(ql_dbg_init, vha, 0x00d1,
-			    "PLOGI ELS param read fail.\n");
+				memcpy(&ha->plogi_els_payld.data,
+				    (void *)ha->init_cb,
+				    sizeof(ha->plogi_els_payld.data));
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			} else {
+				ql_dbg(ql_dbg_init, vha, 0x00d1,
+				    "PLOGI ELS param read fail.\n");
+				goto skip_login;
+			}
+		}
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->n2n_flag) {
+				qla24xx_fcport_handle_login(vha, fcport);
+				return QLA_SUCCESS;
+			}
+		}
+skip_login:
+		spin_lock_irqsave(&vha->work_lock, flags);
+		vha->scan.scan_retry++;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+
+		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
-		return QLA_SUCCESS;
 	}
 
 	found_devs = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 133f5f6270ffa..aadff0124f39f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2257,7 +2257,7 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x105a,
+	ql_dbg(ql_dbg_disc, vha, 0x105a,
 	    "Entered %s.\n", __func__);
 
 	if (IS_CNA_CAPABLE(vha->hw)) {
@@ -3891,14 +3891,23 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		case TOPO_N2N:
 			ha->current_topology = ISP_CFG_N;
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+			list_for_each_entry(fcport, &vha->vp_fcports, list) {
+				fcport->scan_state = QLA_FCPORT_SCAN;
+				fcport->n2n_flag = 0;
+			}
+
 			fcport = qla2x00_find_fcport_by_wwpn(vha,
 			    rptid_entry->u.f1.port_name, 1);
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 			if (fcport) {
 				fcport->plogi_nack_done_deadline = jiffies + HZ;
-				fcport->dm_login_expire = jiffies + 3*HZ;
+				fcport->dm_login_expire = jiffies + 2*HZ;
 				fcport->scan_state = QLA_FCPORT_FOUND;
+				fcport->n2n_flag = 1;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4f_nvme = 1;
+
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
 					set_bit(RELOGIN_NEEDED,
@@ -3932,7 +3941,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				    rptid_entry->u.f1.port_name,
 				    rptid_entry->u.f1.node_name,
 				    NULL,
-				    FC4_TYPE_UNKNOWN);
+				    FS_FCP_IS_N2N);
 			}
 
 			/* if our portname is higher then initiate N2N login */
@@ -4031,6 +4040,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			fcport->scan_state = QLA_FCPORT_SCAN;
+			fcport->n2n_flag = 0;
 		}
 
 		fcport = qla2x00_find_fcport_by_wwpn(vha,
@@ -4040,6 +4050,13 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			fcport->login_retry = vha->hw->login_retry_count;
 			fcport->plogi_nack_done_deadline = jiffies + HZ;
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->n2n_flag = 1;
+			fcport->d_id.b.domain =
+				rptid_entry->u.f2.remote_nport_id[2];
+			fcport->d_id.b.area =
+				rptid_entry->u.f2.remote_nport_id[1];
+			fcport->d_id.b.al_pa =
+				rptid_entry->u.f2.remote_nport_id[0];
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 084e39e415ff5..12d5f50646fba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5050,6 +5050,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
+
+			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N)
+				fcport->n2n_flag = 1;
+
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 				   "%s %8phC mem alloc fail.\n",
-- 
2.20.1



