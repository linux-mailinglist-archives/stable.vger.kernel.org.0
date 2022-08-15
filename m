Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C7C59409F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbiHOV2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347122AbiHOVZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:25:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453AAE8306;
        Mon, 15 Aug 2022 12:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33569B81122;
        Mon, 15 Aug 2022 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77522C433D6;
        Mon, 15 Aug 2022 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591352;
        bh=RhgteyQS3kvuldvAL+apW68+vLiEfEaTsyeIwJ3D7A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfXM19tu/9VXd6gveeuSybEKEa9EiF2q730wpQf2iNehykIqI4B2cMNGgVhdJNYDL
         2tmHdozJb4gykwGZiVxjMaTItYWgoeZiBNI5TYtyF1t91IRLUrx+oOFHTBC7X+BD0d
         wqppzFmZVlUMea6GW++/ogXT6m3hj7krmebZMvHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0553/1095] scsi: qla2xxx: edif: Add retry for ELS passthrough
Date:   Mon, 15 Aug 2022 19:59:12 +0200
Message-Id: <20220815180452.437587008@linuxfoundation.org>
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

[ Upstream commit 0b3f3143d473b489a7aa0779c43bcdb344bd3014 ]

Relating to EDIF, when sending IKE message, updating key or deleting key,
driver can encounter IOCB queue full. Add additional retries to reduce
higher level recovery.

Link: https://lore.kernel.org/r/20220607044627.19563-8-njavali@marvell.com
Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 52 +++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c   |  2 +-
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 166647d4ab27..ce893ddb13df 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1468,6 +1468,8 @@ qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
 
 #define QLA_SA_UPDATE_FLAGS_RX_KEY      0x0
 #define QLA_SA_UPDATE_FLAGS_TX_KEY      0x2
+#define EDIF_MSLEEP_INTERVAL 100
+#define EDIF_RETRY_COUNT  50
 
 int
 qla24xx_sadb_update(struct bsg_job *bsg_job)
@@ -1480,7 +1482,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	struct edif_list_entry *edif_entry = NULL;
 	int			found = 0;
 	int			rval = 0;
-	int result = 0;
+	int result = 0, cnt;
 	struct qla_sa_update_frame sa_frame;
 	struct srb_iocb *iocb_cmd;
 	port_id_t portid;
@@ -1721,11 +1723,23 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	sp->done = qla2x00_bsg_job_done;
 	iocb_cmd = &sp->u.iocb_cmd;
 	iocb_cmd->u.sa_update.sa_frame  = sa_frame;
-
+	cnt = 0;
+retry:
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS) {
+	switch (rval) {
+	case QLA_SUCCESS:
+		break;
+	case EAGAIN:
+		msleep(EDIF_MSLEEP_INTERVAL);
+		cnt++;
+		if (cnt < EDIF_RETRY_COUNT)
+			goto retry;
+
+		fallthrough;
+	default:
 		ql_log(ql_dbg_edif, vha, 0x70e3,
-		    "qla2x00_start_sp failed=%d.\n", rval);
+		       "%s qla2x00_start_sp failed=%d.\n",
+		       __func__, rval);
 
 		qla2x00_rel_sp(sp);
 		rval = -EIO;
@@ -2399,7 +2413,6 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	rval = qla2x00_start_sp(sp);
 
 	if (rval != QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
 		goto done_free_sp;
 	}
 
@@ -3531,7 +3544,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	fc_port_t *fcport = NULL;
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
-	int rval =  (DID_ERROR << 16);
+	int rval =  (DID_ERROR << 16), cnt;
 	port_id_t d_id;
 	struct qla_bsg_auth_els_request *p =
 	    (struct qla_bsg_auth_els_request *)bsg_job->request;
@@ -3626,17 +3639,26 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	sp->free = qla2x00_bsg_sp_free;
 	sp->done = qla2x00_bsg_job_done;
 
+	cnt = 0;
+retry:
 	rval = qla2x00_start_sp(sp);
-
-	ql_dbg(ql_dbg_edif, vha, 0x700a,
-	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
-	    __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
-	    p->e.extra_rx_xchg_address, p->e.extra_control_flags,
-	    sp->handle, sp->remap.req.len, bsg_job);
-
-	if (rval != QLA_SUCCESS) {
+	switch (rval) {
+	case QLA_SUCCESS:
+		ql_dbg(ql_dbg_edif, vha, 0x700a,
+		       "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
+		       __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
+		       p->e.extra_rx_xchg_address, p->e.extra_control_flags,
+		       sp->handle, sp->remap.req.len, bsg_job);
+		break;
+	case EAGAIN:
+		msleep(EDIF_MSLEEP_INTERVAL);
+		cnt++;
+		if (cnt < EDIF_RETRY_COUNT)
+			goto retry;
+		fallthrough;
+	default:
 		ql_log(ql_log_warn, vha, 0x700e,
-		    "qla2x00_start_sp failed = %d\n", rval);
+		    "%s qla2x00_start_sp failed = %d\n", __func__, rval);
 		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
 		rval = -EIO;
 		goto done_free_remap_rsp;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 762229d495a8..3c68dad00d04 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5473,7 +5473,7 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			    e->u.fcport.fcport, false);
 			break;
 		case QLA_EVT_SA_REPLACE:
-			qla24xx_issue_sa_replace_iocb(vha, e);
+			rc = qla24xx_issue_sa_replace_iocb(vha, e);
 			break;
 		}
 
-- 
2.35.1



