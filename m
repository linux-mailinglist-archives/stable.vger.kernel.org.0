Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4470E6AEA04
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCGRaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjCGR3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:29:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F05A17F8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE9DB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24908C433EF;
        Tue,  7 Mar 2023 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209886;
        bh=AbEeA01qbxzdWPn/EBGuK9l6ZaGwh92c0yEaAmbRI4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx4LicSPSMWX/L0pwAUPtwcB84ox2xWS2Vq/A9GS1CApd5qVZxjSs3JlrBgT8DfIW
         iU+bsC8GFmknJLbPwZxKB/ztb3rk9h0KJ8nlIKEQTxb/I5J+uk5/M/IplbAX1iTBfy
         qY0vhCAbDtxfasSPoqNY47Am5NU6raRouRkL9pkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0356/1001] scsi: qla2xxx: Fix exchange oversubscription
Date:   Tue,  7 Mar 2023 17:52:08 +0100
Message-Id: <20230307170036.885086611@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 41e5afe51f75f2858f5563145348f6c26d307b8f ]

In large environment, it is possible to experience command timeout and
escalation of path recovery. Currently the driver does not track the number
of exchanges/commands sent to FW. If there is a delay for commands at the
head of the queue, then this will create back pressure for commands at the
back of the queue.

Check for exchange availability before command submission.

Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  6 +++-
 drivers/scsi/qla2xxx/qla_edif.c   |  7 +++--
 drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++++
 drivers/scsi/qla2xxx/qla_inline.h | 52 +++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c    |  3 +-
 drivers/scsi/qla2xxx/qla_nvme.c   | 15 ++++++++-
 7 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a26a373be9da3..cd4eb11b07079 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -660,7 +660,7 @@ enum {
 
 struct iocb_resource {
 	u8 res_type;
-	u8 pad;
+	u8  exch_cnt;
 	u16 iocb_cnt;
 };
 
@@ -3721,6 +3721,10 @@ struct qla_fw_resources {
 	u16 iocbs_limit;
 	u16 iocbs_qp_limit;
 	u16 iocbs_used;
+	u16 exch_total;
+	u16 exch_limit;
+	u16 exch_used;
+	u16 pad;
 };
 
 #define QLA_IOCB_PCT_LIMIT 95
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index e4240aae5f9e3..53186a1459629 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2989,9 +2989,10 @@ qla28xx_start_scsi_edif(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -3185,7 +3186,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
 		sp->u.scmd.ct6_ctx = NULL;
 	}
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8d9ecabb1aac1..fd27fb5114796 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -128,12 +128,14 @@ static void qla24xx_abort_iocb_timeout(void *data)
 		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			cmdsp_found = 1;
+			qla_put_fw_resources(qpair, &sp->cmd_sp->iores);
 		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			sp_found = 1;
+			qla_put_fw_resources(qpair, &sp->iores);
 			break;
 		}
 	}
@@ -2000,6 +2002,7 @@ qla2x00_tmf_iocb_timeout(void *data)
 		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
 			if (sp->qpair->req->outstanding_cmds[h] == sp) {
 				sp->qpair->req->outstanding_cmds[h] = NULL;
+				qla_put_fw_resources(sp->qpair, &sp->iores);
 				break;
 			}
 		}
@@ -3943,6 +3946,12 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 	ha->base_qpair->fwres.iocbs_limit = limit;
 	ha->base_qpair->fwres.iocbs_qp_limit = limit / num_qps;
 	ha->base_qpair->fwres.iocbs_used = 0;
+
+	ha->base_qpair->fwres.exch_total = ha->orig_fw_xcb_count;
+	ha->base_qpair->fwres.exch_limit = (ha->orig_fw_xcb_count *
+					    QLA_IOCB_PCT_LIMIT) / 100;
+	ha->base_qpair->fwres.exch_used  = 0;
+
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i])  {
 			ha->queue_pair_map[i]->fwres.iocbs_total =
@@ -3951,6 +3960,10 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =
 				limit / num_qps;
 			ha->queue_pair_map[i]->fwres.iocbs_used = 0;
+			ha->queue_pair_map[i]->fwres.exch_total = ha->orig_fw_xcb_count;
+			ha->queue_pair_map[i]->fwres.exch_limit =
+				(ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
+			ha->queue_pair_map[i]->fwres.exch_used = 0;
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5185dc5daf80d..2d5a275d8b000 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -380,13 +380,16 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 
 enum {
 	RESOURCE_NONE,
-	RESOURCE_INI,
+	RESOURCE_IOCB  = BIT_0,
+	RESOURCE_EXCH = BIT_1,  /* exchange */
+	RESOURCE_FORCE = BIT_2,
 };
 
 static inline int
-qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
 	u16 iocbs_used, i;
+	u16 exch_used;
 	struct qla_hw_data *ha = qp->vha->hw;
 
 	if (!ql2xenforce_iocb_limit) {
@@ -394,10 +397,7 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 		return 0;
 	}
 
-	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < qp->fwres.iocbs_qp_limit) {
-		qp->fwres.iocbs_used += iores->iocb_cnt;
-		return 0;
-	} else {
+	if ((iores->iocb_cnt + qp->fwres.iocbs_used) >= qp->fwres.iocbs_qp_limit) {
 		/* no need to acquire qpair lock. It's just rough calculation */
 		iocbs_used = ha->base_qpair->fwres.iocbs_used;
 		for (i = 0; i < ha->max_qpairs; i++) {
@@ -405,30 +405,48 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
 		}
 
-		if ((iores->iocb_cnt + iocbs_used) < qp->fwres.iocbs_limit) {
-			qp->fwres.iocbs_used += iores->iocb_cnt;
-			return 0;
-		} else {
+		if ((iores->iocb_cnt + iocbs_used) >= qp->fwres.iocbs_limit) {
+			iores->res_type = RESOURCE_NONE;
+			return -ENOSPC;
+		}
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		exch_used = ha->base_qpair->fwres.exch_used;
+		for (i = 0; i < ha->max_qpairs; i++) {
+			if (ha->queue_pair_map[i])
+				exch_used += ha->queue_pair_map[i]->fwres.exch_used;
+		}
+
+		if ((exch_used + iores->exch_cnt) >= qp->fwres.exch_limit) {
 			iores->res_type = RESOURCE_NONE;
 			return -ENOSPC;
 		}
 	}
+	qp->fwres.iocbs_used += iores->iocb_cnt;
+	qp->fwres.exch_used += iores->exch_cnt;
+	return 0;
 }
 
 static inline void
-qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
-	switch (iores->res_type) {
-	case RESOURCE_NONE:
-		break;
-	default:
+	if (iores->res_type & RESOURCE_IOCB) {
 		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
 			qp->fwres.iocbs_used -= iores->iocb_cnt;
 		} else {
-			// should not happen
+			/* should not happen */
 			qp->fwres.iocbs_used = 0;
 		}
-		break;
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		if (qp->fwres.exch_used >= iores->exch_cnt) {
+			qp->fwres.exch_used -= iores->exch_cnt;
+		} else {
+			/* should not happen */
+			qp->fwres.exch_used = 0;
+		}
 	}
 	iores->res_type = RESOURCE_NONE;
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ce4e1fe7441..399ec8da2d73c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1589,9 +1589,10 @@ qla24xx_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1678,7 +1679,7 @@ qla24xx_start_scsi(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1793,9 +1794,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1883,7 +1885,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1952,9 +1954,10 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2041,7 +2044,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -2171,9 +2174,10 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2260,7 +2264,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e19fde304e5c6..42d3d2de3d31f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3197,7 +3197,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		return;
 	}
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
@@ -3618,7 +3618,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
-			qla_put_iocbs(sp->qpair, &sp->iores);
 			sp->done(sp, res);
 			return 0;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 02fdeb0d31ec4..582d88dd59abe 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -445,13 +445,24 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		goto queuing_error;
 	}
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_fw_resources(sp->qpair, &sp->iores)) {
+		rval = -EBUSY;
+		goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		if (IS_SHADOW_REG_CAPABLE(ha)) {
 			cnt = *req->out_ptr;
 		} else {
 			cnt = rd_reg_dword_relaxed(req->req_q_out);
-			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt)) {
+				rval = -EBUSY;
 				goto queuing_error;
+			}
 		}
 
 		if (req->ring_index < cnt)
@@ -600,6 +611,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		qla24xx_process_response_queue(vha, rsp);
 
 queuing_error:
+	if (rval)
+		qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return rval;
-- 
2.39.2



