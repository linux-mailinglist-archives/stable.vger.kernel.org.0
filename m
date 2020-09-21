Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35814272D88
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgIUQk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgIUQk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 694592076B;
        Mon, 21 Sep 2020 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706456;
        bh=Iss/emqJiTZlmJ/tbef0Qdttk+fke7GEeJ45jfPrLlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNOKGho6pRDIdh6ICsaS03O1S/a1JmDAJ8+2+sR+2G96JchCT9mVHoLlMtQSCzVG2
         NszThvF0ZDvFDWvWaf7WaKLqeSmW02wRTdHiANEf0HUHT9r1k681vGk/bo608o8KDz
         eBD1HwWqX0tB+G082Ey23hbOJ9pgty5GrFymqWZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 4.19 03/49] scsi: qla2xxx: Move rport registration out of internal work_list
Date:   Mon, 21 Sep 2020 18:27:47 +0200
Message-Id: <20200921162034.815400804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

commit cd4ed6b470f1569692b5d0d295b207f870570829 upstream.

Currently, the rport registration is being called from a single work element
that is used to process QLA internal "work_list".  This work_list is meant for
quick and simple task (ie no sleep).  The Rport registration process sometime
can be delayed by upper layer.  This causes back pressure with the internal
queue where other jobs are unable to move forward.

This patch will schedule the registration process with a new work element
(fc_port.reg_work).  While the RPort is being registered, the current state of
the fcport will not move forward until the registration is done.  If the state
of the fabric has changed, a new field/next_disc_state will record the next
action on whether to 'DELETE' or 'Reverify the session/ADISC'.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_def.h    |    6 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    5 +-
 drivers/scsi/qla2xxx/qla_init.c   |   66 ++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_os.c     |   26 +++++++----
 drivers/scsi/qla2xxx/qla_target.c |   83 ++++++++++++++++++++++++++++++--------
 5 files changed, 147 insertions(+), 39 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2375,11 +2375,13 @@ typedef struct fc_port {
 	unsigned long expires;
 	struct list_head del_list_entry;
 	struct work_struct free_work;
-
+	struct work_struct reg_work;
+	uint64_t jiffies_at_registration;
 	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
 
 	uint16_t tgt_id;
 	uint16_t old_tgt_id;
+	uint16_t sec_since_registration;
 
 	uint8_t fcp_prio;
 
@@ -2412,6 +2414,7 @@ typedef struct fc_port {
 	struct qla_tgt_sess *tgt_session;
 	struct ct_sns_desc ct_desc;
 	enum discovery_state disc_state;
+	enum discovery_state next_disc_state;
 	enum login_state fw_login_state;
 	unsigned long dm_login_expire;
 	unsigned long plogi_nack_done_deadline;
@@ -3222,7 +3225,6 @@ enum qla_work_type {
 	QLA_EVT_GPDB,
 	QLA_EVT_PRLI,
 	QLA_EVT_GPSC,
-	QLA_EVT_UPD_FCPORT,
 	QLA_EVT_GNL,
 	QLA_EVT_NACK,
 	QLA_EVT_RELOGIN,
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -54,7 +54,7 @@ extern void qla2x00_abort_isp_cleanup(sc
 extern void qla2x00_quiesce_io(scsi_qla_host_t *);
 
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
-
+void qla_register_fcport_fn(struct work_struct *);
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
@@ -109,6 +109,7 @@ int qla24xx_post_newsess_work(struct scs
 int qla24xx_fcport_handle_login(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_detect_sfp(scsi_qla_host_t *vha);
 int qla24xx_post_gpdb_work(struct scsi_qla_host *, fc_port_t *, u8);
+
 void qla2x00_async_prlo_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_prlo_work(struct scsi_qla_host *, fc_port_t *,
@@ -208,7 +209,7 @@ extern void qla2x00_disable_board_on_pci
 extern void qla2x00_sp_compl(void *, int);
 extern void qla2xxx_qpair_sp_free_dma(void *);
 extern void qla2xxx_qpair_sp_compl(void *, int);
-extern int qla24xx_post_upd_fcport_work(struct scsi_qla_host *, fc_port_t *);
+extern void qla24xx_sched_upd_fcport(fc_port_t *);
 void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1204,11 +1204,7 @@ void __qla24xx_handle_gpdb_event(scsi_ql
 		vha->fcport_count++;
 		ea->fcport->login_succ = 1;
 
-		ql_dbg(ql_dbg_disc, vha, 0x20d6,
-		    "%s %d %8phC post upd_fcport fcp_cnt %d\n",
-		    __func__, __LINE__,  ea->fcport->port_name,
-		    vha->fcport_count);
-		qla24xx_post_upd_fcport_work(vha, ea->fcport);
+		qla24xx_sched_upd_fcport(ea->fcport);
 	} else if (ea->fcport->login_succ) {
 		/*
 		 * We have an existing session. A late RSCN delivery
@@ -1326,6 +1322,7 @@ int qla24xx_fcport_handle_login(struct s
 {
 	u16 data[2];
 	u64 wwn;
+	u16 sec;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
 	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d retry %d lid %d scan %d\n",
@@ -1457,6 +1454,22 @@ int qla24xx_fcport_handle_login(struct s
 			qla24xx_post_prli_work(vha, fcport);
 		break;
 
+	case DSC_UPD_FCPORT:
+		sec =  jiffies_to_msecs(jiffies -
+		    fcport->jiffies_at_registration)/1000;
+		if (fcport->sec_since_registration < sec && sec &&
+		    !(sec % 60)) {
+			fcport->sec_since_registration = sec;
+			ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+			    "%s %8phC - Slow Rport registration(%d Sec)\n",
+			    __func__, fcport->port_name, sec);
+		}
+
+		if (fcport->next_disc_state != DSC_DELETE_PEND)
+			fcport->next_disc_state = DSC_ADISC;
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		break;
+
 	default:
 		break;
 	}
@@ -1572,8 +1585,10 @@ void qla2x00_fcport_event_handler(scsi_q
 		case RSCN_PORT_ADDR:
 			fcport = qla2x00_find_fcport_by_nportid
 				(vha, &ea->id, 1);
-			if (fcport)
+			if (fcport) {
 				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
 
 			spin_lock_irqsave(&vha->work_lock, flags);
 			if (vha->scan.scan_flags == 0) {
@@ -4741,6 +4756,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vh
 		return NULL;
 	}
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
+	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
 
@@ -5221,13 +5237,15 @@ qla2x00_reg_remote_port(scsi_qla_host_t
 void
 qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
-	fcport->vha = vha;
-
 	if (IS_SW_RESV_ADDR(fcport->d_id))
 		return;
 
+	ql_dbg(ql_dbg_disc, vha, 0x20ef, "%s %8phC\n",
+	    __func__, fcport->port_name);
+
+	fcport->disc_state = DSC_UPD_FCPORT;
+	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
-	fcport->disc_state = DSC_LOGIN_COMPLETE;
 	fcport->deleted = 0;
 	fcport->logout_on_delete = 1;
 	fcport->login_retry = vha->hw->login_retry_count;
@@ -5289,6 +5307,36 @@ qla2x00_update_fcport(scsi_qla_host_t *v
 		}
 	}
 	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+
+	fcport->disc_state = DSC_LOGIN_COMPLETE;
+}
+
+void qla_register_fcport_fn(struct work_struct *work)
+{
+	fc_port_t *fcport = container_of(work, struct fc_port, reg_work);
+	u32 rscn_gen = fcport->rscn_gen;
+	u16 data[2];
+
+	if (IS_SW_RESV_ADDR(fcport->d_id))
+		return;
+
+	qla2x00_update_fcport(fcport->vha, fcport);
+
+	if (rscn_gen != fcport->rscn_gen) {
+		/* RSCN(s) came in while registration */
+		switch (fcport->next_disc_state) {
+		case DSC_DELETE_PEND:
+			qlt_schedule_sess_for_deletion(fcport);
+			break;
+		case DSC_ADISC:
+			data[0] = data[1] = 0;
+			qla2x00_post_async_adisc_work(fcport->vha, fcport,
+			    data);
+			break;
+		default:
+			break;
+		}
+	}
 }
 
 /*
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4792,16 +4792,25 @@ qlafx00_post_aenfx_work(struct scsi_qla_
 	return qla2x00_post_work(vha, e);
 }
 
-int qla24xx_post_upd_fcport_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+void qla24xx_sched_upd_fcport(fc_port_t *fcport)
 {
-	struct qla_work_evt *e;
+	unsigned long flags;
 
-	e = qla2x00_alloc_work(vha, QLA_EVT_UPD_FCPORT);
-	if (!e)
-		return QLA_FUNCTION_FAILED;
+	if (IS_SW_RESV_ADDR(fcport->d_id))
+		return;
 
-	e->u.fcport.fcport = fcport;
-	return qla2x00_post_work(vha, e);
+	spin_lock_irqsave(&fcport->vha->work_lock, flags);
+	if (fcport->disc_state == DSC_UPD_FCPORT) {
+		spin_unlock_irqrestore(&fcport->vha->work_lock, flags);
+		return;
+	}
+	fcport->jiffies_at_registration = jiffies;
+	fcport->sec_since_registration = 0;
+	fcport->next_disc_state = DSC_DELETED;
+	fcport->disc_state = DSC_UPD_FCPORT;
+	spin_unlock_irqrestore(&fcport->vha->work_lock, flags);
+
+	queue_work(system_unbound_wq, &fcport->reg_work);
 }
 
 static
@@ -5057,9 +5066,6 @@ qla2x00_do_work(struct scsi_qla_host *vh
 		case QLA_EVT_GPSC:
 			qla24xx_async_gpsc(vha, e->u.fcport.fcport);
 			break;
-		case QLA_EVT_UPD_FCPORT:
-			qla2x00_update_fcport(vha, e->u.fcport.fcport);
-			break;
 		case QLA_EVT_GNL:
 			qla24xx_async_gnl(vha, e->u.fcport.fcport);
 			break;
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -600,14 +600,7 @@ void qla2x00_async_nack_sp_done(void *s,
 			sp->fcport->login_succ = 1;
 
 			vha->fcport_count++;
-
-			ql_dbg(ql_dbg_disc, vha, 0x20f3,
-			    "%s %d %8phC post upd_fcport fcp_cnt %d\n",
-			    __func__, __LINE__,
-			    sp->fcport->port_name,
-			    vha->fcport_count);
-			sp->fcport->disc_state = DSC_UPD_FCPORT;
-			qla24xx_post_upd_fcport_work(vha, sp->fcport);
+			qla24xx_sched_upd_fcport(sp->fcport);
 		} else {
 			sp->fcport->login_retry = 0;
 			sp->fcport->disc_state = DSC_LOGIN_COMPLETE;
@@ -1227,11 +1220,12 @@ void qlt_schedule_sess_for_deletion(stru
 {
 	struct qla_tgt *tgt = sess->tgt;
 	unsigned long flags;
+	u16 sec;
 
-	if (sess->disc_state == DSC_DELETE_PEND)
+	switch (sess->disc_state) {
+	case DSC_DELETE_PEND:
 		return;
-
-	if (sess->disc_state == DSC_DELETED) {
+	case DSC_DELETED:
 		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
 			wake_up_all(&tgt->waitQ);
 		if (sess->vha->fcport_count == 0)
@@ -1240,6 +1234,24 @@ void qlt_schedule_sess_for_deletion(stru
 		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
 			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
 			return;
+		break;
+	case DSC_UPD_FCPORT:
+		/*
+		 * This port is not done reporting to upper layer.
+		 * let it finish
+		 */
+		sess->next_disc_state = DSC_DELETE_PEND;
+		sec = jiffies_to_msecs(jiffies -
+		    sess->jiffies_at_registration)/1000;
+		if (sess->sec_since_registration < sec && sec && !(sec % 5)) {
+			sess->sec_since_registration = sec;
+			ql_dbg(ql_dbg_disc, sess->vha, 0xffff,
+			    "%s %8phC : Slow Rport registration(%d Sec)\n",
+			    __func__, sess->port_name, sec);
+		}
+		return;
+	default:
+		break;
 	}
 
 	if (sess->deleted == QLA_SESS_DELETED)
@@ -4749,6 +4761,32 @@ static int qlt_handle_login(struct scsi_
 		goto out;
 	}
 
+	if (sess->disc_state == DSC_UPD_FCPORT) {
+		u16 sec;
+
+		/*
+		 * Remote port registration is still going on from
+		 * previous login. Allow it to finish before we
+		 * accept the new login.
+		 */
+		sess->next_disc_state = DSC_DELETE_PEND;
+		sec = jiffies_to_msecs(jiffies -
+		    sess->jiffies_at_registration) / 1000;
+		if (sess->sec_since_registration < sec && sec &&
+		    !(sec % 5)) {
+			sess->sec_since_registration = sec;
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %8phC - Slow Rport registration (%d Sec)\n",
+			    __func__, sess->port_name, sec);
+		}
+
+		if (!conflict_sess)
+			kmem_cache_free(qla_tgt_plogi_cachep, pla);
+
+		qlt_send_term_imm_notif(vha, iocb, 1);
+		goto out;
+	}
+
 	qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
 	sess->d_id = port_id;
 	sess->login_gen++;
@@ -4908,6 +4946,7 @@ static int qlt_24xx_handle_els(struct sc
 
 		if (sess != NULL) {
 			bool delete = false;
+			int sec;
 			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
 			switch (sess->fw_login_state) {
 			case DSC_LS_PLOGI_PEND:
@@ -4920,9 +4959,24 @@ static int qlt_24xx_handle_els(struct sc
 			}
 
 			switch (sess->disc_state) {
+			case DSC_UPD_FCPORT:
+				spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock,
+				    flags);
+
+				sec = jiffies_to_msecs(jiffies -
+				    sess->jiffies_at_registration)/1000;
+				if (sess->sec_since_registration < sec && sec &&
+				    !(sec % 5)) {
+					sess->sec_since_registration = sec;
+					ql_dbg(ql_dbg_disc, sess->vha, 0xffff,
+					    "%s %8phC : Slow Rport registration(%d Sec)\n",
+					    __func__, sess->port_name, sec);
+				}
+				qlt_send_term_imm_notif(vha, iocb, 1);
+				return 0;
+
 			case DSC_LOGIN_PEND:
 			case DSC_GPDB:
-			case DSC_UPD_FCPORT:
 			case DSC_LOGIN_COMPLETE:
 			case DSC_ADISC:
 				delete = false;
@@ -5959,10 +6013,7 @@ static fc_port_t *qlt_get_port_database(
 	case MODE_DUAL:
 		if (newfcport) {
 			if (!IS_IIDMA_CAPABLE(vha->hw) || !vha->hw->flags.gpsc_supported) {
-				ql_dbg(ql_dbg_disc, vha, 0x20fe,
-				   "%s %d %8phC post upd_fcport fcp_cnt %d\n",
-				   __func__, __LINE__, fcport->port_name, vha->fcport_count);
-				qla24xx_post_upd_fcport_work(vha, fcport);
+				qla24xx_sched_upd_fcport(fcport);
 			} else {
 				ql_dbg(ql_dbg_disc, vha, 0x20ff,
 				   "%s %d %8phC post gpsc fcp_cnt %d\n",


