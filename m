Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0B593785
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245001AbiHOTHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343582AbiHOTGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5812DD;
        Mon, 15 Aug 2022 11:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55FFFCE1263;
        Mon, 15 Aug 2022 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4396DC433D6;
        Mon, 15 Aug 2022 18:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588513;
        bh=vpR8qTRcA4MkElrs8I2tta6kS+EFC94wwfhoVNxAppY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSC1GEaOcs9AciEP863pTUj6lIg06pT63EH2Cmxu6+n3vHYGDsjIV5UbRzlcsq2t8
         X21mbyZpYIOqcwmrAGgtmbKK52a0EZcURD0iJSapB3XsOTUAovuDfJxr90wMZaY2z9
         hjAMpWtDSXp88PxiJIiGE8Q7ebteoTHm3bFVSGaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/779] scsi: qla2xxx: edif: Fix inconsistent check of db_flags
Date:   Mon, 15 Aug 2022 20:00:41 +0200
Message-Id: <20220815180354.241161666@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 36f468bfe98c7de7916ab3391ee5dd6fd2549979 ]

db_flags field is a bit field. Replace value check with bit flag check.

Link: https://lore.kernel.org/r/20211026115412.27691-12-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c   | 26 +++++++++++++-------------
 drivers/scsi/qla2xxx/qla_edif.h   |  7 +++++--
 drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++-------
 drivers/scsi/qla2xxx/qla_iocb.c   |  3 +--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 4be876dd9f6b..bdcc38bd955a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -218,7 +218,7 @@ fc_port_t *fcport)
 		    "%s edif not enabled\n", __func__);
 		goto done;
 	}
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
 		goto done;
@@ -482,9 +482,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=%x app_start_flags %x\n",
 	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* mark doorbell as active since an app is now present */
-		vha->e_dbell.db_flags = EDB_ACTIVE;
+		vha->e_dbell.db_flags |= EDB_ACTIVE;
 	} else {
 		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
 		     __func__);
@@ -1306,7 +1306,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		goto done;
 	}
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_log(ql_log_warn, vha, 0x70a1, "App not started\n");
 		rval = -EIO;
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
@@ -1813,7 +1813,7 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
 void
 qla_edb_init(scsi_qla_host_t *vha)
 {
-	if (vha->e_dbell.db_flags == EDB_ACTIVE) {
+	if (DBELL_ACTIVE(vha)) {
 		/* list already init'd - error */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "edif db already initialized, cannot reinit\n");
@@ -1856,7 +1856,7 @@ static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
 	port_id_t sid;
 	LIST_HEAD(edb_list);
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		       "%s doorbell not enabled\n", __func__);
@@ -1908,7 +1908,7 @@ qla_edb_stop(scsi_qla_host_t *vha)
 	unsigned long flags;
 	struct edb_node *node, *q;
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
@@ -1959,7 +1959,7 @@ qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
 {
 	unsigned long		flags;
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
@@ -1990,7 +1990,7 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
 		return;
 	}
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		if (fcport)
 			fcport->edif.auth_state = dbtype;
 		/* doorbell list not enabled */
@@ -2085,7 +2085,7 @@ qla_edif_timer(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!vha->vp_idx && N2N_TOPO(ha) && ha->flags.n2n_fw_acc_sec) {
-		if (vha->e_dbell.db_flags != EDB_ACTIVE &&
+		if (DBELL_INACTIVE(vha) &&
 		    ha->edif_post_stop_cnt_down) {
 			ha->edif_post_stop_cnt_down--;
 
@@ -2123,7 +2123,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 	sz = 256;
 
 	/* stop new threads from waiting if we're not init'd */
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
 		    "%s error - edif db not enabled\n", __func__);
 		return 0;
@@ -2480,7 +2480,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
 
-	if (host->e_dbell.db_flags != EDB_ACTIVE ||
+	if (DBELL_INACTIVE(vha) ||
 	    (fcport && EDIF_SESSION_DOWN(fcport))) {
 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
 		    __func__, host->e_dbell.db_flags,
@@ -3506,7 +3506,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 {
-	if (sess->edif.app_sess_online && vha->e_dbell.db_flags & EDB_ACTIVE) {
+	if (sess->edif.app_sess_online && DBELL_ACTIVE(vha)) {
 		ql_dbg(ql_dbg_disc, vha, 0xf09c,
 			"%s: sess %8phN send port_offline event\n",
 			__func__, sess->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 2517005fb08c..a965ca8e47ce 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -41,9 +41,12 @@ struct pur_core {
 };
 
 enum db_flags_t {
-	EDB_ACTIVE = 0x1,
+	EDB_ACTIVE = BIT_0,
 };
 
+#define DBELL_ACTIVE(_v) (_v->e_dbell.db_flags & EDB_ACTIVE)
+#define DBELL_INACTIVE(_v) (!(_v->e_dbell.db_flags & EDB_ACTIVE))
+
 struct edif_dbell {
 	enum db_flags_t		db_flags;
 	spinlock_t		db_lock;
@@ -134,7 +137,7 @@ struct enode {
 	 !_s->edif.app_sess_online))
 
 #define EDIF_NEGOTIATION_PENDING(_fcport) \
-	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
+	(DBELL_ACTIVE(_fcport->vha) && \
 	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
 
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 09ddaa8cb653..2bed5050bcaf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -341,7 +341,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
 	} else {
 		if (vha->hw->flags.edif_enabled &&
-		    vha->e_dbell.db_flags & EDB_ACTIVE) {
+		    DBELL_ACTIVE(vha)) {
 			lio->u.logio.flags |=
 				(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
 			ql_dbg(ql_dbg_disc, vha, 0x2072,
@@ -881,7 +881,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				break;
 			case DSC_LS_PLOGI_COMP:
 				if (vha->hw->flags.edif_enabled &&
-				    vha->e_dbell.db_flags & EDB_ACTIVE) {
+				    DBELL_ACTIVE(vha)) {
 					/* check to see if App support secure or not */
 					qla24xx_post_gpdb_work(vha, fcport, 0);
 					break;
@@ -1477,7 +1477,7 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
 			    fcport->d_id.b24);
 
-			if (vha->e_dbell.db_flags ==  EDB_ACTIVE) {
+			if (DBELL_ACTIVE(vha)) {
 				ql_dbg(ql_dbg_disc, vha, 0x20ef,
 				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
 				    __func__, __LINE__, fcport->port_name);
@@ -1826,7 +1826,7 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 				return;
 			}
 
-			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE) {
+			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port
 				 * may use RSCN to trigger initiator to
@@ -4266,7 +4266,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 		 * fw shal not send PRLI after PLOGI Acc
 		 */
 		if (ha->flags.edif_enabled &&
-		    vha->e_dbell.db_flags & EDB_ACTIVE) {
+		    DBELL_ACTIVE(vha)) {
 			ha->fw_options[3] |= BIT_15;
 			ha->flags.n2n_fw_acc_sec = 1;
 		} else {
@@ -5424,8 +5424,7 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			 * use link up to wake up app to get ready for
 			 * authentication.
 			 */
-			if (ha->flags.edif_enabled &&
-			    !(vha->e_dbell.db_flags & EDB_ACTIVE))
+			if (ha->flags.edif_enabled && DBELL_INACTIVE(vha))
 				qla2x00_post_aen_work(vha, FCH_EVT_LINKUP,
 						      ha->link_data_rate);
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7ff2d9c84bde..46c879923da1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3065,8 +3065,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->u.els_plogi.els_cmd = els_opcode;
 	elsio->u.els_plogi.els_plogi_pyld->opcode = els_opcode;
 
-	if (els_opcode == ELS_DCMD_PLOGI && vha->hw->flags.edif_enabled &&
-	    vha->e_dbell.db_flags & EDB_ACTIVE) {
+	if (els_opcode == ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
 		struct fc_els_flogi *p = ptr;
 
 		p->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_SEC);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ae5eaa4a9283..7ab3c9e4d478 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4815,7 +4815,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 	}
 
 	if (vha->hw->flags.edif_enabled) {
-		if (!(vha->e_dbell.db_flags & EDB_ACTIVE)) {
+		if (DBELL_INACTIVE(vha)) {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 			       "%s %d Term INOT due to app not started lid=%d, NportID %06X ",
 			       __func__, __LINE__, loop_id, port_id.b24);
-- 
2.35.1



