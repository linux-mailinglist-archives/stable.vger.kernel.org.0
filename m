Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100C5272FC9
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgIUQ7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgIUQk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 093D7238E6;
        Mon, 21 Sep 2020 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706458;
        bh=NTsI6/3R157Sh7DUUpt3smKPSpR1ojLL8/hXlh2Tqow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EonG3OyorzdUyA6Z7UZoy+ZDtUBsKmJQ1hh/sNxB4C172/KCZNbuZgJtq6h5ONg56
         jFK8dQRHHchpPK1nsPFww+Lo/ef35Vdy4c6cf+Kbt5tA9DjWG5j19XTUtCVSnZ5AE0
         IXmvc5frqyfv2NzlMjIJWRHHsJYS1cx+ASRHCUsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 04/49] scsi: qla2xxx: Reduce holding sess_lock to prevent CPU lock-up
Date:   Mon, 21 Sep 2020 18:27:48 +0200
Message-Id: <20200921162034.860203081@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_def.h    |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c     |   18 ++++++++++++------
 drivers/scsi/qla2xxx/qla_init.c   |   33 +++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_os.c     |    3 +--
 drivers/scsi/qla2xxx/qla_target.c |    2 ++
 5 files changed, 33 insertions(+), 25 deletions(-)

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
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4018,11 +4018,10 @@ void qla24xx_async_gnnft_done(scsi_qla_h
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
@@ -4261,12 +4260,13 @@ static void qla2x00_async_gpnft_gnnft_sp
 
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
@@ -4316,6 +4316,8 @@ static int qla24xx_async_gnnft(scsi_qla_
 		vha->scan.scan_flags &= ~SF_SCANNING;
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 		WARN_ON(1);
+		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
 	}
 
@@ -4349,8 +4351,12 @@ static int qla24xx_async_gnnft(scsi_qla_
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
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -800,6 +800,7 @@ qla24xx_async_gnl_sp_done(void *s, int r
 	if (res == QLA_FUNCTION_TIMEOUT)
 		return;
 
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
 	memset(&ea, 0, sizeof(ea));
 	ea.sp = sp;
 	ea.rc = res;
@@ -827,25 +828,24 @@ qla24xx_async_gnl_sp_done(void *s, int r
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
@@ -878,6 +878,8 @@ qla24xx_async_gnl_sp_done(void *s, int r
 		}
 	}
 
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	vha->gnl.sent = 0;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	sp->free(sp);
@@ -897,27 +899,24 @@ int qla24xx_async_gnl(struct scsi_qla_ho
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
@@ -1204,7 +1203,9 @@ void __qla24xx_handle_gpdb_event(scsi_ql
 		vha->fcport_count++;
 		ea->fcport->login_succ = 1;
 
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		qla24xx_sched_upd_fcport(ea->fcport);
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	} else if (ea->fcport->login_succ) {
 		/*
 		 * We have an existing session. A late RSCN delivery
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2719,7 +2719,7 @@ static void qla2x00_iocb_work_fn(struct
 		struct scsi_qla_host, iocb_work);
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	int i = 20;
+	int i = 2;
 	unsigned long flags;
 
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
@@ -4606,7 +4606,6 @@ struct scsi_qla_host *qla2x00_create_hos
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
-	spin_lock_init(&vha->gnl.fcports_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 	init_waitqueue_head(&vha->vref_waitq);
 
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -600,7 +600,9 @@ void qla2x00_async_nack_sp_done(void *s,
 			sp->fcport->login_succ = 1;
 
 			vha->fcport_count++;
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 			qla24xx_sched_upd_fcport(sp->fcport);
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		} else {
 			sp->fcport->login_retry = 0;
 			sp->fcport->disc_state = DSC_LOGIN_COMPLETE;


