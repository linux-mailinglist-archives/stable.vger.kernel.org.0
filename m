Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F936441A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbhDSNZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241658AbhDSNYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5C161411;
        Mon, 19 Apr 2021 13:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838342;
        bh=Lr+7vCVm2nolPwewpCJ/NxUoWB68KZB45k7hg7CWAls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jwsvf9cNjOk8TPpGrZTyl0SJWdjB8Iib0SygfTBbPN+OiXVvfxk3lfpWPP9HgI8Wd
         Davv7zJULA+SSXxWu519GaVzKQKDzTdMvd3YCrwvyIb6ecHXlyHeEmKXx2UD4YprjX
         6FA8iGWwPx5TbdGyu6jT0JV/t31A6RkUpazuR2R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Sundar <ssundar@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/73] scsi: qla2xxx: Add a shadow variable to hold disc_state history of fcport
Date:   Mon, 19 Apr 2021 15:05:57 +0200
Message-Id: <20210419130524.017612685@linuxfoundation.org>
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

From: Shyam Sundar <ssundar@marvell.com>

[ Upstream commit 27258a5771446f9c7edc929ecb76fe2c12c29d97 ]

This patch adds a shadow variable to hold disc_state history for the fcport
and prints state transition when the logging is enabled.

Link: https://lore.kernel.org/r/20191217220617.28084-4-hmadhani@marvell.com
Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_def.h    | 14 ++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     |  2 +-
 drivers/scsi/qla2xxx/qla_init.c   | 29 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_inline.h | 24 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  7 ++++---
 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 11 ++++++-----
 9 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7bbff91f8883..88a56e8480f7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -18,7 +18,7 @@
  * | Device Discovery             |       0x2134       | 0x210e-0x2116  |
  * |				  | 		       | 0x211a         |
  * |                              |                    | 0x211c-0x2128  |
- * |                              |                    | 0x212a-0x2130  |
+ * |                              |                    | 0x212a-0x2134  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 894c2716b7ce..5e940543eaa1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2464,6 +2464,7 @@ typedef struct fc_port {
 	struct qla_tgt_sess *tgt_session;
 	struct ct_sns_desc ct_desc;
 	enum discovery_state disc_state;
+	atomic_t shadow_disc_state;
 	enum discovery_state next_disc_state;
 	enum login_state fw_login_state;
 	unsigned long dm_login_expire;
@@ -2508,6 +2509,19 @@ struct event_arg {
 
 extern const char *const port_state_str[5];
 
+static const char * const port_dstate_str[] = {
+	"DELETED",
+	"GNN_ID",
+	"GNL",
+	"LOGIN_PEND",
+	"LOGIN_FAILED",
+	"GPDB",
+	"UPD_FCPORT",
+	"LOGIN_COMPLETE",
+	"ADISC",
+	"DELETE_PEND"
+};
+
 /*
  * FC port flags.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5b163ad85c34..5a3c47eed645 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -80,6 +80,7 @@ extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
 int qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e);
 extern void *qla2x00_alloc_iocbs_ready(struct qla_qpair *, srb_t *);
 extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
+extern int qla24xx_async_abort_cmd(srb_t *, bool);
 
 extern void qla2x00_set_fcport_state(fc_port_t *fcport, int state);
 extern fc_port_t *
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ae13aabf280b..d9b5ea77fde9 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4290,7 +4290,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
-	fcport->disc_state = DSC_GNN_ID;
+	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5d2d0c287469..0aac1eb1e013 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -337,10 +337,10 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (!sp)
 		goto done;
 
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->logout_completed = 0;
 
-	fcport->disc_state = DSC_LOGIN_PEND;
 	sp->type = SRB_LOGIN_CMD;
 	sp->name = "login";
 	sp->gen1 = fcport->rscn_gen;
@@ -544,7 +544,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
-	fcport->disc_state = DSC_LOGIN_PEND;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	return qla2x00_post_work(vha, e);
 }
 
@@ -847,7 +847,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				 * with GNL. Push disc_state back to DELETED
 				 * so GNL can go out again
 				 */
-				fcport->disc_state = DSC_DELETED;
+				qla2x00_set_fcport_disc_state(fcport,
+				    DSC_DELETED);
 				break;
 			case DSC_LS_PRLI_COMP:
 				if ((e->prli_svc_param_word_3[0] & BIT_4) == 0)
@@ -923,7 +924,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			qla24xx_fcport_handle_login(vha, fcport);
 			break;
 		case ISP_CFG_N:
-			fcport->disc_state = DSC_DELETED;
+			qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
 			if (time_after_eq(jiffies, fcport->dm_login_expire)) {
 				if (fcport->n2n_link_reset_cnt < 2) {
 					fcport->n2n_link_reset_cnt++;
@@ -1093,7 +1094,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	fcport->flags |= FCF_ASYNC_SENT;
-	fcport->disc_state = DSC_GNL;
+	qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 	fcport->last_rscn_gen = fcport->rscn_gen;
 	fcport->last_login_gen = fcport->login_gen;
 
@@ -1316,12 +1317,12 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 		return rval;
 	}
 
-	fcport->disc_state = DSC_GPDB;
-
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	qla2x00_set_fcport_disc_state(fcport, DSC_GPDB);
+
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_MB_IOCB;
 	sp->name = "gpdb";
@@ -1400,7 +1401,7 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x20d6,
 		    "%s %d %8phC session revalidate success\n",
 		    __func__, __LINE__, ea->fcport->port_name);
-		ea->fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_COMPLETE);
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
@@ -1454,7 +1455,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		/* Set discovery state back to GNL to Relogin attempt */
 		if (qla_dual_mode_enabled(vha) ||
 		    qla_ini_mode_enabled(vha)) {
-			fcport->disc_state = DSC_GNL;
+			qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		}
 		return;
@@ -2013,7 +2014,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
 
 		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		ea->fcport->disc_state = DSC_LOGIN_FAILED;
+		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_FAILED);
 		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
@@ -5393,7 +5394,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	ql_dbg(ql_dbg_disc, vha, 0x20ef, "%s %8phC\n",
 	    __func__, fcport->port_name);
 
-	fcport->disc_state = DSC_UPD_FCPORT;
+	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 	fcport->deleted = 0;
@@ -5413,7 +5414,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
-		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		return;
 	}
@@ -5458,7 +5459,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		}
 	}
 
-	fcport->disc_state = DSC_LOGIN_COMPLETE;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 }
 
 void qla_register_fcport_fn(struct work_struct *work)
@@ -5867,7 +5868,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 		if (NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
-				fcport->disc_state = DSC_GNL;
+				qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 				vha->fcport_count--;
 				fcport->login_succ = 0;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index af91e567a38d..477b0b8a5f4b 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -105,6 +105,30 @@ qla2x00_clean_dsd_pool(struct qla_hw_data *ha, struct crc_context *ctx)
 	INIT_LIST_HEAD(&ctx->dsd_list);
 }
 
+static inline void
+qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
+{
+	int old_val;
+	uint8_t shiftbits, mask;
+
+	/* This will have to change when the max no. of states > 16 */
+	shiftbits = 4;
+	mask = (1 << shiftbits) - 1;
+
+	fcport->disc_state = state;
+	while (1) {
+		old_val = atomic_read(&fcport->shadow_disc_state);
+		if (old_val == atomic_cmpxchg(&fcport->shadow_disc_state,
+		    old_val, (old_val << shiftbits) | state)) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
+			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
+			    fcport->port_name, port_dstate_str[old_val & mask],
+			    port_dstate_str[state], fcport->d_id.b24);
+			return;
+		}
+	}
+}
+
 static inline int
 qla2x00_hba_err_chk_enabled(srb_t *sp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 53ccbd6b71ed..3f43410fab9d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2843,7 +2843,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				fcport->disc_state = DSC_LOGIN_FAILED;
+				qla2x00_set_fcport_disc_state(fcport,
+				    DSC_LOGIN_FAILED);
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2856,7 +2857,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			sp->fcport->disc_state = DSC_LOGIN_FAILED;
+			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2893,7 +2894,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
-	fcport->disc_state = DSC_LOGIN_PEND;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 899dfb445710..af8306a9777f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5014,7 +5014,7 @@ void qla24xx_sched_upd_fcport(fc_port_t *fcport)
 	fcport->jiffies_at_registration = jiffies;
 	fcport->sec_since_registration = 0;
 	fcport->next_disc_state = DSC_DELETED;
-	fcport->disc_state = DSC_UPD_FCPORT;
+	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	spin_unlock_irqrestore(&fcport->vha->work_lock, flags);
 
 	queue_work(system_unbound_wq, &fcport->reg_work);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5dbdae1f65af..594dfbeee376 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -596,7 +596,8 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		} else {
 			sp->fcport->login_retry = 0;
-			sp->fcport->disc_state = DSC_LOGIN_COMPLETE;
+			qla2x00_set_fcport_disc_state(sp->fcport,
+			    DSC_LOGIN_COMPLETE);
 			sp->fcport->deleted = 0;
 			sp->fcport->logout_on_delete = 1;
 		}
@@ -1056,7 +1057,7 @@ void qlt_free_session_done(struct work_struct *work)
 			tgt->sess_count--;
 	}
 
-	sess->disc_state = DSC_DELETED;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETED);
 	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
 	sess->deleted = QLA_SESS_DELETED;
 
@@ -1166,7 +1167,7 @@ void qlt_unreg_sess(struct fc_port *sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-	sess->disc_state = DSC_DELETE_PEND;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
 
@@ -1267,7 +1268,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
-	sess->disc_state = DSC_DELETE_PEND;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 
 	qla24xx_chk_fcp_state(sess);
 
@@ -6060,7 +6061,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		if (!IS_SW_RESV_ADDR(fcport->d_id))
 		   vha->fcport_count++;
 		fcport->login_gen++;
-		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 		fcport->login_succ = 1;
 		newfcport = 1;
 	}
-- 
2.30.2



