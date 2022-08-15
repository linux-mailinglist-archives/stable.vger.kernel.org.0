Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF805594AA4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352788AbiHPAFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354744AbiHOX7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE0615E68E;
        Mon, 15 Aug 2022 13:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DD04B80EA8;
        Mon, 15 Aug 2022 20:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E59C433C1;
        Mon, 15 Aug 2022 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594862;
        bh=bVL/NtCCzjgKbf12xm9GTWOQwBmjYkR3sth9mTO8qIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQgWKkJ6uq20m9ObiSMIjE7ZHzISqb+R016IX9Tqo5nDYnE0uJK2fscA3l1TCNuJc
         xrI+LhYLf2ZWPczwMWnxWudzOKOZ2C8ZaIBXNSGkW6YX0hcAjYciMinJDzd0A9mJo3
         dTyjYQz0hpO43aNge22nylZI20I4QDID1ufub0Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0581/1157] scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing
Date:   Mon, 15 Aug 2022 19:58:57 +0200
Message-Id: <20220815180502.894352161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 9c40c36e75ffd49952cd4ead0672defc4b4dbdf7 ]

This patch uses GFFID switch command to scan whether remote device is
Target or Initiator mode.  Based on that info, driver will not pass up
Initiator info to authentication application. This helps reduce unnecessary
stress for authentication application to deal with unused connections.

Link: https://lore.kernel.org/r/20220607044627.19563-2-njavali@marvell.com
Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |   2 +
 drivers/scsi/qla2xxx/qla_edif.c |  32 ++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +-
 drivers/scsi/qla2xxx/qla_gs.c   | 118 +++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_iocb.c |   2 +-
 5 files changed, 120 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f25a131fb07e..5f22276927dd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3204,6 +3204,8 @@ struct ct_sns_rsp {
 #define GFF_NVME_OFFSET		23 /* type = 28h */
 		struct {
 			uint8_t fc4_features[128];
+#define FC4_FF_TARGET    BIT_0
+#define FC4_FF_INITIATOR BIT_1
 		} gff_id;
 		struct {
 			uint8_t reserved;
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index cb8145a9ac09..e789f59395ce 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -517,16 +517,28 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
 				break;
 
-			fcport->edif.app_started = 1;
 			fcport->login_retry = vha->hw->login_retry_count;
 
-			/* no activity */
 			fcport->edif.app_stop = 0;
+			fcport->edif.app_sess_online = 0;
+			fcport->edif.app_started = 1;
+
+			if (fcport->scan_state != QLA_FCPORT_FOUND)
+				continue;
+
+			if (fcport->port_type == FCT_UNKNOWN &&
+			    !fcport->fc4_features)
+				rval = qla24xx_async_gffid(vha, fcport, true);
+
+			if (!rval && !(fcport->fc4_features & FC4_FF_TARGET ||
+			    fcport->port_type & (FCT_TARGET|FCT_NVME_TARGET)))
+				continue;
+
+			rval = 0;
 
 			ql_dbg(ql_dbg_edif, vha, 0x911e,
 			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
 			       __func__, fcport->port_name);
-			fcport->edif.app_sess_online = 0;
 			qlt_schedule_sess_for_deletion(fcport);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
@@ -883,6 +895,20 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			app_reply->ports[pcnt].rekey_count =
 				fcport->edif.rekey_cnt;
 
+			if (fcport->scan_state != QLA_FCPORT_FOUND)
+				continue;
+
+			if (fcport->port_type == FCT_UNKNOWN && !fcport->fc4_features)
+				rval = qla24xx_async_gffid(vha, fcport, true);
+
+			if (!rval &&
+			    !(fcport->fc4_features & FC4_FF_TARGET ||
+			      fcport->port_type &
+			      (FCT_TARGET | FCT_NVME_TARGET)))
+				continue;
+
+			rval = 0;
+
 			app_reply->ports[pcnt].remote_type =
 				VND_CMD_RTYPE_UNKNOWN;
 			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dac27b5ff0ac..84b44454c231 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -335,6 +335,7 @@ extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
 extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
 	struct qla_work_evt *e);
 void qla2x00_sp_release(struct kref *kref);
+void qla2x00_els_dcmd2_iocb_timeout(void *data);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -727,7 +728,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gpsc_event(scsi_qla_host_t *, struct event_arg *);
 int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
 void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea);
-int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport);
+int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool);
 int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
 void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
 void qla24xx_async_gnnft_done(scsi_qla_host_t *, srb_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f8005ce65082..574251b2e0ef 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3277,19 +3277,12 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	return rval;
 }
 
-void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea)
-{
-	fc_port_t *fcport = ea->fcport;
-
-	qla24xx_post_gnl_work(vha, fcport);
-}
 
 void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 {
 	struct scsi_qla_host *vha = sp->vha;
 	fc_port_t *fcport = sp->fcport;
 	struct ct_sns_rsp *ct_rsp;
-	struct event_arg ea;
 	uint8_t fc4_scsi_feat;
 	uint8_t fc4_nvme_feat;
 
@@ -3297,10 +3290,10 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 	       "Async done-%s res %x ID %x. %8phC\n",
 	       sp->name, res, fcport->d_id.b24, fcport->port_name);
 
-	fcport->flags &= ~FCF_ASYNC_SENT;
-	ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+	ct_rsp = sp->u.iocb_cmd.u.ctarg.rsp;
 	fc4_scsi_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
 	fc4_nvme_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+	sp->rc = res;
 
 	/*
 	 * FC-GS-7, 5.2.3.12 FC-4 Features - format
@@ -3321,24 +3314,42 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 		}
 	}
 
-	memset(&ea, 0, sizeof(ea));
-	ea.sp = sp;
-	ea.fcport = sp->fcport;
-	ea.rc = res;
+	if (sp->flags & SRB_WAKEUP_ON_COMP) {
+		complete(sp->comp);
+	} else  {
+		if (sp->u.iocb_cmd.u.ctarg.req) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+				sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+				sp->u.iocb_cmd.u.ctarg.req,
+				sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
 
-	qla24xx_handle_gffid_event(vha, &ea);
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		if (sp->u.iocb_cmd.u.ctarg.rsp) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+				sp->u.iocb_cmd.u.ctarg.rsp,
+				sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
+
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		/* we should not be here */
+		dump_stack();
+	}
 }
 
 /* Get FC4 Feature with Nport ID. */
-int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
+int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool wait)
 {
 	int rval = QLA_FUNCTION_FAILED;
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
+	DECLARE_COMPLETION_ONSTACK(comp);
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+	/* this routine does not have handling for no wait */
+	if (!vha->flags.online || !wait)
 		return rval;
 
 	/* ref: INIT */
@@ -3346,43 +3357,86 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!sp)
 		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "gffid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
 			      qla24xx_async_gffid_sp_done);
+	sp->comp = &comp;
+	sp->u.iocb_cmd.timeout = qla2x00_els_dcmd2_iocb_timeout;
+
+	if (wait)
+		sp->flags = SRB_WAKEUP_ON_COMP;
+
+	sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
+	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
+				sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+				&sp->u.iocb_cmd.u.ctarg.req_dma,
+	    GFP_KERNEL);
+	if (!sp->u.iocb_cmd.u.ctarg.req) {
+		ql_log(ql_log_warn, vha, 0xd041,
+		       "%s: Failed to allocate ct_sns request.\n",
+		       __func__);
+		goto done_free_sp;
+	}
+
+	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = sizeof(struct ct_sns_pkt);
+	sp->u.iocb_cmd.u.ctarg.rsp = dma_alloc_coherent(&vha->hw->pdev->dev,
+				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+				&sp->u.iocb_cmd.u.ctarg.rsp_dma,
+	    GFP_KERNEL);
+	if (!sp->u.iocb_cmd.u.ctarg.req) {
+		ql_log(ql_log_warn, vha, 0xd041,
+		       "%s: Failed to allocate ct_sns request.\n",
+		       __func__);
+		goto done_free_sp;
+	}
 
 	/* CT_IU preamble  */
-	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFF_ID_CMD,
-	    GFF_ID_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_req(sp->u.iocb_cmd.u.ctarg.req, GFF_ID_CMD, GFF_ID_RSP_SIZE);
 
 	ct_req->req.gff_id.port_id[0] = fcport->d_id.b.domain;
 	ct_req->req.gff_id.port_id[1] = fcport->d_id.b.area;
 	ct_req->req.gff_id.port_id[2] = fcport->d_id.b.al_pa;
 
-	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
-	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
 	sp->u.iocb_cmd.u.ctarg.req_size = GFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	ql_dbg(ql_dbg_disc, vha, 0x2132,
-	    "Async-%s hdl=%x  %8phC.\n", sp->name,
-	    sp->handle, fcport->port_name);
-
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
+
+	if (rval != QLA_SUCCESS) {
+		rval = QLA_FUNCTION_FAILED;
 		goto done_free_sp;
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0x3074,
+		       "Async-%s hdl=%x portid %06x\n",
+		       sp->name, sp->handle, fcport->d_id.b24);
+	}
+
+	wait_for_completion(sp->comp);
+	rval = sp->rc;
 
-	return rval;
 done_free_sp:
+	if (sp->u.iocb_cmd.u.ctarg.req) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+				  sp->u.iocb_cmd.u.ctarg.req,
+				  sp->u.iocb_cmd.u.ctarg.req_dma);
+		sp->u.iocb_cmd.u.ctarg.req = NULL;
+	}
+
+	if (sp->u.iocb_cmd.u.ctarg.rsp) {
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+				  sp->u.iocb_cmd.u.ctarg.rsp,
+				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
+		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+	}
+
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e0fe9ddb4bd2..46c879923da1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2819,7 +2819,7 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	sp->vha->qla_stats.control_requests++;
 }
 
-static void
+void
 qla2x00_els_dcmd2_iocb_timeout(void *data)
 {
 	srb_t *sp = data;
-- 
2.35.1



