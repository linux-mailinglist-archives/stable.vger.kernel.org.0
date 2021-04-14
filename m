Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECC35F414
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 14:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351049AbhDNMkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 08:40:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11641 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhDNMkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 08:40:02 -0400
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13ECdVH5018749;
        Wed, 14 Apr 2021 05:39:32 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        varun@chelsio.com, <stable@vger.kernel.org>
Subject: [PATCH] scsi: target: cxgbit: unmap DMA buffer before calling target_execute_cmd()
Date:   Wed, 14 Apr 2021 18:09:09 +0530
Message-Id: <1618403949-3443-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of calling dma_unmap_sg() after completing WRITE I/O,
call dma_unmap_sg() before calling target_execute_cmd() to sync
the DMA buffer.

Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c    | 19 ++++++++++---------
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 21 ++++++++++++++++++---
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index af35251..b044999 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -265,12 +265,13 @@ void cxgbit_unmap_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
 
 	if (ccmd->release) {
-		struct cxgbi_task_tag_info *ttinfo = &ccmd->ttinfo;
-
-		if (ttinfo->sgl) {
+		if (cmd->se_cmd.se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
+			put_page(sg_page(&ccmd->sg));
+		} else {
 			struct cxgbit_sock *csk = conn->context;
 			struct cxgbit_device *cdev = csk->com.cdev;
 			struct cxgbi_ppm *ppm = cdev2ppm(cdev);
+			struct cxgbi_task_tag_info *ttinfo = &ccmd->ttinfo;
 
 			/* Abort the TCP conn if DDP is not complete to
 			 * avoid any possibility of DDP after freeing
@@ -280,14 +281,14 @@ void cxgbit_unmap_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 				     cmd->se_cmd.data_length))
 				cxgbit_abort_conn(csk);
 
+			if (unlikely(ttinfo->sgl)) {
+				dma_unmap_sg(&ppm->pdev->dev, ttinfo->sgl,
+					     ttinfo->nents, DMA_FROM_DEVICE);
+				ttinfo->nents = 0;
+				ttinfo->sgl = NULL;
+			}
 			cxgbi_ppm_ppod_release(ppm, ttinfo->idx);
-
-			dma_unmap_sg(&ppm->pdev->dev, ttinfo->sgl,
-				     ttinfo->nents, DMA_FROM_DEVICE);
-		} else {
-			put_page(sg_page(&ccmd->sg));
 		}
-
 		ccmd->release = false;
 	}
 }
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index b926e1d..282297f 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -997,17 +997,18 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 	struct scatterlist *sg_start;
 	struct iscsi_conn *conn = csk->conn;
 	struct iscsi_cmd *cmd = NULL;
+	struct cxgbit_cmd *ccmd;
+	struct cxgbi_task_tag_info *ttinfo;
 	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
 	struct iscsi_data *hdr = (struct iscsi_data *)pdu_cb->hdr;
 	u32 data_offset = be32_to_cpu(hdr->offset);
-	u32 data_len = pdu_cb->dlen;
+	u32 data_len = ntoh24(hdr->dlength);
 	int rc, sg_nents, sg_off;
 	bool dcrc_err = false;
 
 	if (pdu_cb->flags & PDUCBF_RX_DDP_CMP) {
 		u32 offset = be32_to_cpu(hdr->offset);
 		u32 ddp_data_len;
-		u32 payload_length = ntoh24(hdr->dlength);
 		bool success = false;
 
 		cmd = iscsit_find_cmd_from_itt_or_dump(conn, hdr->itt, 0);
@@ -1022,7 +1023,7 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 		cmd->data_sn = be32_to_cpu(hdr->datasn);
 
 		rc = __iscsit_check_dataout_hdr(conn, (unsigned char *)hdr,
-						cmd, payload_length, &success);
+						cmd, data_len, &success);
 		if (rc < 0)
 			return rc;
 		else if (!success)
@@ -1060,6 +1061,20 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 		cxgbit_skb_copy_to_sg(csk->skb, sg_start, sg_nents, skip);
 	}
 
+	ccmd = iscsit_priv_cmd(cmd);
+	ttinfo = &ccmd->ttinfo;
+
+	if (ccmd->release && ttinfo->sgl &&
+	    (cmd->se_cmd.data_length ==	(cmd->write_data_done + data_len))) {
+		struct cxgbit_device *cdev = csk->com.cdev;
+		struct cxgbi_ppm *ppm = cdev2ppm(cdev);
+
+		dma_unmap_sg(&ppm->pdev->dev, ttinfo->sgl, ttinfo->nents,
+			     DMA_FROM_DEVICE);
+		ttinfo->nents = 0;
+		ttinfo->sgl = NULL;
+	}
+
 check_payload:
 
 	rc = iscsit_check_dataout_payload(cmd, hdr, dcrc_err);
-- 
2.0.2

