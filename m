Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF335593F32
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiHOVYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiHOVWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0292AE68D4;
        Mon, 15 Aug 2022 12:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 188B760BB7;
        Mon, 15 Aug 2022 19:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0789FC433D6;
        Mon, 15 Aug 2022 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591340;
        bh=0SYm1VVHnhtjkTsyruKuYLbCCiFCcr39+3jSY7b7QZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De0rs9zQ0SuETDgbIkSkjRKWZ/nG+NeTKwkBBrvPMd5R/mQvK5UCxOj/xp5d/EqSy
         1zgjPN7ky9QMG3kOy2/Omo+RGjKkB/2hOMIHm+MQn00I+iAqun3jcmMKCJ637oXtQK
         cPqmQy3y7JpiXrPQUqLVRYpuqh3fPlgnU9TdTcXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0549/1095] scsi: qla2xxx: edif: Wait for app to ack on sess down
Date:   Mon, 15 Aug 2022 19:59:08 +0200
Message-Id: <20220815180452.266487763@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit df648afa39da9c4d3af99c6c03dc3e9c7dfa99b0 ]

On session deletion, wait for app to acknowledge before moving on. This
allows both app and driver to stay in sync. In addition, this gives a
chance for authentication app to do any type of cleanup before moving on.

Link: https://lore.kernel.org/r/20220607044627.19563-4-njavali@marvell.com
Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 +-
 drivers/scsi/qla2xxx/qla_edif.c   | 66 +++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_init.c   |  4 --
 drivers/scsi/qla2xxx/qla_target.c | 35 ++++++++--------
 4 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5f22276927dd..c2b92a6fef90 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2626,7 +2626,6 @@ typedef struct fc_port {
 	struct {
 		uint32_t	enable:1;	/* device is edif enabled/req'd */
 		uint32_t	app_stop:2;
-		uint32_t	app_started:1;
 		uint32_t	aes_gmac:1;
 		uint32_t	app_sess_online:1;
 		uint32_t	tx_sa_set:1;
@@ -2637,6 +2636,7 @@ typedef struct fc_port {
 		uint32_t	rx_rekey_cnt;
 		uint64_t	tx_bytes;
 		uint64_t	rx_bytes;
+		uint8_t		sess_down_acked;
 		uint8_t		auth_state;
 		uint16_t	authok:1;
 		uint16_t	rekey_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 0978551f85f5..034c43a8bb9b 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -257,14 +257,8 @@ qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id)
 
 	f = NULL;
 	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
-		if ((f->flags & FCF_FCSP_DEVICE)) {
-			ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x2058,
-			    "Found secure fcport - nn %8phN pn %8phN portid=0x%x, 0x%x.\n",
-			    f->node_name, f->port_name,
-			    f->d_id.b24, id->b24);
-			if (f->d_id.b24 == id->b24)
-				return f;
-		}
+		if (f->d_id.b24 == id->b24)
+			return f;
 	}
 	return NULL;
 }
@@ -526,7 +520,6 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			fcport->edif.app_stop = 0;
 			fcport->edif.app_sess_online = 0;
-			fcport->edif.app_started = 1;
 
 			if (fcport->scan_state != QLA_FCPORT_FOUND)
 				continue;
@@ -628,9 +621,6 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			fcport->send_els_logo = 1;
 			qlt_schedule_sess_for_deletion(fcport);
-
-			/* qla_edif_flush_sa_ctl_lists(fcport); */
-			fcport->edif.app_started = 0;
 		}
 	}
 
@@ -1048,6 +1038,40 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	return rval;
 }
 
+static int32_t
+qla_edif_ack(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	struct fc_port *fcport;
+	struct aen_complete_cmd ack;
+	struct fc_bsg_reply     *bsg_reply = bsg_job->reply;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			  bsg_job->request_payload.sg_cnt, &ack, sizeof(ack));
+
+	ql_dbg(ql_dbg_edif, vha, 0x70cf,
+	       "%s: %06x event_code %x\n",
+	       __func__, ack.port_id.b24, ack.event_code);
+
+	fcport = qla2x00_find_fcport_by_pid(vha, &ack.port_id);
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	if (!fcport) {
+		ql_dbg(ql_dbg_edif, vha, 0x70cf,
+		       "%s: unable to find fcport %06x \n",
+		       __func__, ack.port_id.b24);
+		return 0;
+	}
+
+	switch (ack.event_code) {
+	case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+		fcport->edif.sess_down_acked = 1;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 int32_t
 qla_edif_app_mgmt(struct bsg_job *bsg_job)
 {
@@ -1110,6 +1134,9 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	case QL_VND_SC_GET_STATS:
 		rval = qla_edif_app_getstats(vha, bsg_job);
 		break;
+	case QL_VND_SC_AEN_COMPLETE:
+		rval = qla_edif_ack(vha, bsg_job);
+		break;
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
 		    __func__,
@@ -3513,14 +3540,29 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 {
+	u16 cnt = 0;
+
 	if (sess->edif.app_sess_online && DBELL_ACTIVE(vha)) {
 		ql_dbg(ql_dbg_disc, vha, 0xf09c,
 			"%s: sess %8phN send port_offline event\n",
 			__func__, sess->port_name);
 		sess->edif.app_sess_online = 0;
+		sess->edif.sess_down_acked = 0;
 		qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SESSION_SHUTDOWN,
 		    sess->d_id.b24, 0, sess);
 		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
+
+		while (!READ_ONCE(sess->edif.sess_down_acked) &&
+		       !test_bit(VPORT_DELETE, &vha->dpc_flags)) {
+			msleep(100);
+			cnt++;
+			if (cnt > 100)
+				break;
+		}
+		sess->edif.sess_down_acked = 0;
+		ql_dbg(ql_dbg_disc, vha, 0xf09c,
+		       "%s: sess %8phN port_offline event completed\n",
+		       __func__, sess->port_name);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c0f76021c47..5f077f9217e5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1480,7 +1480,6 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 				ql_dbg(ql_dbg_disc, vha, 0x20ef,
 				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
 				    __func__, __LINE__, fcport->port_name);
-				fcport->edif.app_started = 1;
 				fcport->edif.app_sess_online = 1;
 
 				qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED,
@@ -5275,9 +5274,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_LIST_HEAD(&fcport->edif.tx_sa_list);
 	INIT_LIST_HEAD(&fcport->edif.rx_sa_list);
 
-	if (vha->e_dbell.db_flags == EDB_ACTIVE)
-		fcport->edif.app_started = 1;
-
 	spin_lock_init(&fcport->edif.indx_list_lock);
 	INIT_LIST_HEAD(&fcport->edif.edif_indx_list);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6dfcfd8e7337..34b85c80233f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -988,22 +988,6 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
-		if (ha->flags.edif_enabled &&
-		    (!own || own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
-			sess->edif.authok = 0;
-			if (!ha->flags.host_shutting_down) {
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-					"%s wwpn %8phC calling qla2x00_release_all_sadb\n",
-					__func__, sess->port_name);
-				qla2x00_release_all_sadb(vha, sess);
-			} else {
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-					"%s bypassing release_all_sadb\n",
-					__func__);
-			}
-			qla_edif_clear_appdata(vha, sess);
-			qla_edif_sess_down(vha, sess);
-		}
 		qla2x00_mark_device_lost(vha, sess, 0);
 
 		if (sess->send_els_logo) {
@@ -1049,6 +1033,25 @@ void qlt_free_session_done(struct work_struct *work)
 			sess->nvme_flag |= NVME_FLAG_DELETING;
 			qla_nvme_unregister_remote_port(sess);
 		}
+
+		if (ha->flags.edif_enabled &&
+		    (!own || (own &&
+			      own->iocb.u.isp24.status_subcode == ELS_PLOGI))) {
+			sess->edif.authok = 0;
+			if (!ha->flags.host_shutting_down) {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+				       "%s wwpn %8phC calling qla2x00_release_all_sadb\n",
+				       __func__, sess->port_name);
+				qla2x00_release_all_sadb(vha, sess);
+			} else {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+				       "%s bypassing release_all_sadb\n",
+				       __func__);
+			}
+
+			qla_edif_clear_appdata(vha, sess);
+			qla_edif_sess_down(vha, sess);
+		}
 	}
 
 	/*
-- 
2.35.1



