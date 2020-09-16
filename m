Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18FA26BDBC
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIPHOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:14:37 -0400
Received: from smtpbgau1.qq.com ([54.206.16.166]:40257 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgIPHOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 03:14:36 -0400
X-QQ-mid: bizesmtp13t1600240447t8ize7eq
Received: from localhost.localdomain (unknown [116.128.244.169])
        by esmtp6.qq.com (ESMTP) with 
        id ; Wed, 16 Sep 2020 15:14:07 +0800 (CST)
X-QQ-SSF: 01400000002000S0Z000000A0000000
X-QQ-FEAT: JCKEBi+PwsChoyw60kbgeqBH6aeTTUjqigKyb+0C7nQmAQ3MucRMHRZktmltS
        Pymv8j8gAOnYJsVIPwHRvIVB3g7GlFHO6gCaC2pmbO7+Amwf1d73jDJnW1O9i0UI7PmYKj7
        oIsamDguU/HW5ocYNKt3bebwEkVnBv1fWYFWswbyeSua2xubQ53r9cw90hXSNu3ddZ5An5L
        UzUuE0kwB2R7jkNHq23dB4dXsgOuKYj2YRldhwf/sNyBacEbythnbn8eyLLfoITz0PKb09K
        YOWtWgmeZQYrr5RcSdNX9oNOKFkl9mjzRSi1SHDaR8cucr39gCJc1zd7VTYFLpn/VhzbplW
        jHCTnZG6v6OzBDwnuuX22n9Mw/fnIx9VNF9Xggy
X-QQ-GoodBg: 2
From:   Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
To:     stable@vger.kernel.org
Cc:     himanshu.madhani@oracle.com, gregkh@linuxfoundation.org,
        liuzhengyuan@kylinos.cn
Subject: [PATCH 4.19 3/3] scsi: qla2xxx: Reduce holding sess_lock to prevent CPU lock-up
Date:   Wed, 16 Sep 2020 15:13:49 +0800
Message-Id: <20200916071349.5816-3-liuzhengyuan@tj.kylinos.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200916071349.5816-1-liuzhengyuan@tj.kylinos.cn>
References: <20200916071349.5816-1-liuzhengyuan@tj.kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:tj.kylinos.cn:qybgforeign:qybgforeign7
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

commit 0aca77843e2803bf4fab1598b7891c56c16be979 upstream.

- Reduce sess_lock holding to prevent CPU Lock up. sess_lock was held across
  fc_port registration and deletion.  These calls can be blocked by upper
  layer. Sess_lock is also being accessed by interrupt thread.

- Reduce number of loops in processing work_list to prevent kernel complaint
  of CPU lockup or holding sess_lock.

Reported-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Tested-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Fixes: 9ba1cb25c151 ("scsi: qla2xxx: Remove all rports if fabric scan retry fails")
Link: https://lore.kernel.org/linux-scsi/D01377DD-2E86-427B-BA0C-8D7649E37870@oracle.com/T/#t
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 +-
 drivers/scsi/qla2xxx/qla_gs.c     | 18 +++++++++++------
 drivers/scsi/qla2xxx/qla_init.c   | 33 ++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_os.c     |  3 +--
 drivers/scsi/qla2xxx/qla_target.c |  2 ++
 5 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 16dd59bcd60a..47835d26a973 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -262,8 +262,8 @@ struct name_list_extended {
 	struct get_name_list_extended *l;
 	dma_addr_t		ldma;
 	struct list_head	fcports;
-	spinlock_t		fcports_lock;
 	u32			size;
+	u8			sent;
 };
 /*
  * Timeout timer counts in seconds
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 01cd977eb55e..c3195d4c25e5 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4018,11 +4018,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			if ((qla_dual_mode_enabled(vha) ||
 				qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
-				qla2x00_mark_device_lost(vha, fcport,
-				    ql2xplogiabsentdevice, 0);
+				if (fcport->loop_id != FC_NO_LOOP_ID) {
+					if (fcport->flags & FCF_FCP2_DEVICE)
+						fcport->logout_on_delete = 0;
 
-				if (fcport->loop_id != FC_NO_LOOP_ID &&
-				    (fcport->flags & FCF_FCP2_DEVICE) == 0) {
 					ql_dbg(ql_dbg_disc, vha, 0x20f0,
 					    "%s %d %8phC post del sess\n",
 					    __func__, __LINE__,
@@ -4261,12 +4260,13 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 
 		sp->rc = res;
 		rc = qla2x00_post_nvme_gpnft_done_work(vha, sp, QLA_EVT_GPNFT);
-		if (!rc) {
+		if (rc) {
 			qla24xx_sp_unmap(vha, sp);
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			return;
 		}
+		return;
 	}
 
 	if (cmd == GPN_FT_CMD) {
@@ -4316,6 +4316,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 		vha->scan.scan_flags &= ~SF_SCANNING;
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 		WARN_ON(1);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
 	}
 
@@ -4349,8 +4351,12 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
 
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
+		spin_lock_irqsave(&vha->work_lock, flags);
+		vha->scan.scan_flags &= ~SF_SCANNING;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
 		goto done_free_sp;
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4460c841d14b..2ebf4e4e0234 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -800,6 +800,7 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 	if (res == QLA_FUNCTION_TIMEOUT)
 		return;
 
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
 	memset(&ea, 0, sizeof(ea));
 	ea.sp = sp;
 	ea.rc = res;
@@ -827,25 +828,24 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 		    (loop_id & 0x7fff));
 	}
 
-	spin_lock_irqsave(&vha->gnl.fcports_lock, flags);
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 
 	INIT_LIST_HEAD(&h);
 	fcport = tf = NULL;
 	if (!list_empty(&vha->gnl.fcports))
 		list_splice_init(&vha->gnl.fcports, &h);
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
 		list_del_init(&fcport->gnl_entry);
-		spin_lock(&vha->hw->tgt.sess_lock);
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
-		spin_unlock(&vha->hw->tgt.sess_lock);
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		ea.fcport = fcport;
 
 		qla2x00_fcport_event_handler(vha, &ea);
 	}
-	spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
 
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	/* create new fcport if fw has knowledge of new sessions */
 	for (i = 0; i < n; i++) {
 		port_id_t id;
@@ -878,6 +878,8 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 		}
 	}
 
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	vha->gnl.sent = 0;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	sp->free(sp);
@@ -897,27 +899,24 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
 
-	spin_lock_irqsave(&vha->gnl.fcports_lock, flags);
-	if (!list_empty(&fcport->gnl_entry)) {
-		spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
-		rval = QLA_SUCCESS;
-		goto done;
-	}
-
-	spin_lock(&vha->hw->tgt.sess_lock);
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GNL;
 	fcport->last_rscn_gen = fcport->rscn_gen;
 	fcport->last_login_gen = fcport->login_gen;
-	spin_unlock(&vha->hw->tgt.sess_lock);
 
 	list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports);
-	spin_unlock_irqrestore(&vha->gnl.fcports_lock, flags);
+	if (vha->gnl.sent) {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+		return QLA_SUCCESS;
+	}
+	vha->gnl.sent = 1;
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_MB_IOCB;
 	sp->name = "gnlist";
 	sp->gen1 = fcport->rscn_gen;
@@ -1204,7 +1203,9 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		vha->fcport_count++;
 		ea->fcport->login_succ = 1;
 
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		qla24xx_sched_upd_fcport(ea->fcport);
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	} else if (ea->fcport->login_succ) {
 		/*
 		 * We have an existing session. A late RSCN delivery
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 102c6b9f31ae..83ef790afb5d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2719,7 +2719,7 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 		struct scsi_qla_host, iocb_work);
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	int i = 20;
+	int i = 2;
 	unsigned long flags;
 
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
@@ -4606,7 +4606,6 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
-	spin_lock_init(&vha->gnl.fcports_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 	init_waitqueue_head(&vha->vref_waitq);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7b14204c79dd..29b79e85fa7f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -600,7 +600,9 @@ void qla2x00_async_nack_sp_done(void *s, int res)
 			sp->fcport->login_succ = 1;
 
 			vha->fcport_count++;
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 			qla24xx_sched_upd_fcport(sp->fcport);
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		} else {
 			sp->fcport->login_retry = 0;
 			sp->fcport->disc_state = DSC_LOGIN_COMPLETE;
-- 
2.20.1



