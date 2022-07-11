Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2B956FCB7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiGKJrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiGKJql (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:46:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5ADAA835;
        Mon, 11 Jul 2022 02:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31A78B80E6D;
        Mon, 11 Jul 2022 09:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC1CC34115;
        Mon, 11 Jul 2022 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531368;
        bh=98xabKMvFokdJSYWZLW9SiiH3AuKJZ1xJ1jKU4viRX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCiKSR7LSM4dvh6LQRGOsMRnLxYNp1kGbULlH+sxFqpF85bHAP2+tGEv6D5VGAU4x
         i3Ya/fG8cUKE2jSMH+F+FvQe+PWhnQSaQVabjHMtsZjMVoM1T55ZQzi/JYU4koq4rk
         kRtpQA8PSWSTg8nNeHA+rmU+KR2t0Zk022XRORaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/230] scsi: qla2xxx: Move heartbeat handling from DPC thread to workqueue
Date:   Mon, 11 Jul 2022 11:05:35 +0200
Message-Id: <20220711090606.317951304@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

[ Upstream commit 3a4e1f3b3a3c733de3b82b9b522e54803e1165ae ]

DPC thread gets restricted due to a no-op mailbox, which is a blocking call
and has a high execution frequency. To free up the DPC thread we move no-op
handling to the workqueue. Also, modified qla_do_heartbeat() to send no-op
MBC if we don’t have any active interrupts, but there are still I/Os
outstanding with firmware.

Link: https://lore.kernel.org/r/20210908164622.19240-9-njavali@marvell.com
Fixes: d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 +-
 drivers/scsi/qla2xxx/qla_init.c |  2 +
 drivers/scsi/qla2xxx/qla_os.c   | 78 +++++++++++++++------------------
 3 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2ea35e47ea44..0589ab8e6467 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3759,6 +3759,7 @@ struct qla_qpair {
 	struct qla_fw_resources fwres ____cacheline_aligned;
 	u32	cmd_cnt;
 	u32	cmd_completion_cnt;
+	u32	prev_completion_cnt;
 };
 
 /* Place holder for FW buffer parameters */
@@ -4618,6 +4619,7 @@ struct qla_hw_data {
 	struct qla_chip_state_84xx *cs84xx;
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
+	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
 
 	/* FCP_CMND priority support */
@@ -4719,7 +4721,6 @@ struct qla_hw_data {
 
 	struct qla_hw_data_stat stat;
 	pci_error_state_t pci_error_state;
-	u64 prev_cmd_cnt;
 	struct dma_pool *purex_dma_pool;
 	struct btree_head32 host_map;
 
@@ -4865,7 +4866,6 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
 #define VPORT_DELETE		34
-#define HEARTBEAT_CHK		38
 
 #define PROCESS_PUREX_IOCB	63
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index af8df5a800c6..c3ba2995209b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7096,12 +7096,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	ha->chip_reset++;
 	ha->base_qpair->chip_reset = ha->chip_reset;
 	ha->base_qpair->cmd_cnt = ha->base_qpair->cmd_completion_cnt = 0;
+	ha->base_qpair->prev_completion_cnt = 0;
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i]) {
 			ha->queue_pair_map[i]->chip_reset =
 				ha->base_qpair->chip_reset;
 			ha->queue_pair_map[i]->cmd_cnt =
 			    ha->queue_pair_map[i]->cmd_completion_cnt = 0;
+			ha->base_qpair->prev_completion_cnt = 0;
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 77c0bf06f162..b224326bacee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2779,6 +2779,16 @@ qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
+static void qla_heartbeat_work_fn(struct work_struct *work)
+{
+	struct qla_hw_data *ha = container_of(work,
+		struct qla_hw_data, heartbeat_work);
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+
+	if (!ha->flags.mbox_busy && base_vha->flags.init_done)
+		qla_no_op_mb(base_vha);
+}
+
 static void qla2x00_iocb_work_fn(struct work_struct *work)
 {
 	struct scsi_qla_host *vha = container_of(work,
@@ -3217,6 +3227,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->transportt, sht->vendor_id);
 
 	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+	INIT_WORK(&ha->heartbeat_work, qla_heartbeat_work_fn);
 
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
@@ -7103,17 +7114,6 @@ qla2x00_do_dpc(void *data)
 			qla2x00_lip_reset(base_vha);
 		}
 
-		if (test_bit(HEARTBEAT_CHK, &base_vha->dpc_flags)) {
-			/*
-			 * if there is a mb in progress then that's
-			 * enough of a check to see if fw is still ticking.
-			 */
-			if (!ha->flags.mbox_busy && base_vha->flags.init_done)
-				qla_no_op_mb(base_vha);
-
-			clear_bit(HEARTBEAT_CHK, &base_vha->dpc_flags);
-		}
-
 		ha->dpc_active = 0;
 end_loop:
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -7172,57 +7172,51 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
 
 static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 {
-	u64 cmd_cnt, prev_cmd_cnt;
-	bool do_hb = false;
 	struct qla_hw_data *ha = vha->hw;
-	int i;
+	u32 cmpl_cnt;
+	u16 i;
+	bool do_heartbeat = false;
 
-	/* if cmds are still pending down in fw, then do hb */
-	if (ha->base_qpair->cmd_cnt != ha->base_qpair->cmd_completion_cnt) {
-		do_hb = true;
+	/*
+	 * Allow do_heartbeat only if we don’t have any active interrupts,
+	 * but there are still IOs outstanding with firmware.
+	 */
+	cmpl_cnt = ha->base_qpair->cmd_completion_cnt;
+	if (cmpl_cnt == ha->base_qpair->prev_completion_cnt &&
+	    cmpl_cnt != ha->base_qpair->cmd_cnt) {
+		do_heartbeat = true;
 		goto skip;
 	}
+	ha->base_qpair->prev_completion_cnt = cmpl_cnt;
 
 	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i] &&
-		    ha->queue_pair_map[i]->cmd_cnt !=
-		    ha->queue_pair_map[i]->cmd_completion_cnt) {
-			do_hb = true;
-			break;
+		if (ha->queue_pair_map[i]) {
+			cmpl_cnt = ha->queue_pair_map[i]->cmd_completion_cnt;
+			if (cmpl_cnt == ha->queue_pair_map[i]->prev_completion_cnt &&
+			    cmpl_cnt != ha->queue_pair_map[i]->cmd_cnt) {
+				do_heartbeat = true;
+				break;
+			}
+			ha->queue_pair_map[i]->prev_completion_cnt = cmpl_cnt;
 		}
 	}
 
 skip:
-	prev_cmd_cnt = ha->prev_cmd_cnt;
-	cmd_cnt = ha->base_qpair->cmd_cnt;
-	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i])
-			cmd_cnt += ha->queue_pair_map[i]->cmd_cnt;
-	}
-	ha->prev_cmd_cnt = cmd_cnt;
-
-	if (!do_hb && ((cmd_cnt - prev_cmd_cnt) > 50))
-		/*
-		 * IOs are completing before periodic hb check.
-		 * IOs seems to be running, do hb for sanity check.
-		 */
-		do_hb = true;
-
-	return do_hb;
+	return do_heartbeat;
 }
 
 static void qla_heart_beat(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	if (vha->vp_idx)
 		return;
 
 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
 		return;
 
-	if (qla_do_heartbeat(vha)) {
-		set_bit(HEARTBEAT_CHK, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
-	}
+	if (qla_do_heartbeat(vha))
+		queue_work(ha->wq, &ha->heartbeat_work);
 }
 
 /**************************************************************************
-- 
2.35.1



