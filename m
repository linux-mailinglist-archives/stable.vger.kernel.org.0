Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD823C55D7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348096AbhGLIMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354018AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D8660BD3;
        Mon, 12 Jul 2021 07:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076766;
        bh=VrPXUm0PKzWrgMxxobE5j99PE4NAJHQyapS/YeWsxBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlTJOQTV5Ujk2pAxmVJ6EFvV6DUOY5xymXGQO0yXBn/YVQBThwSxfFuDBxuhkXGBu
         BTCGrYzCkydvaqyqjS2Cw2Ut317R1ETKDvtJlf/ZfiZ6Ro/QjHIsLMXp9xct5Mx0Tj
         eDIPFZiZ05AgWWl0imNxiug7kdK6zZAbdZATyOD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 784/800] scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cmd()
Date:   Mon, 12 Jul 2021 08:13:27 +0200
Message-Id: <20210712061050.256232989@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

commit 6ecdafaec79d4b3388a5b017245f23a0ff9d852d upstream.

Instead of calling dma_unmap_sg() after completing WRITE I/O, call
dma_unmap_sg() before calling target_execute_cmd() to sync the DMA buffer.

Link: https://lore.kernel.org/r/1618403949-3443-1-git-send-email-varun@chelsio.com
Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c    |   19 ++++++++++---------
 drivers/target/iscsi/cxgbit/cxgbit_target.c |   21 ++++++++++++++++++---
 2 files changed, 28 insertions(+), 12 deletions(-)

--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -265,12 +265,13 @@ void cxgbit_unmap_cmd(struct iscsi_conn
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
@@ -280,14 +281,14 @@ void cxgbit_unmap_cmd(struct iscsi_conn
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
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -997,17 +997,18 @@ static int cxgbit_handle_iscsi_dataout(s
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
@@ -1022,7 +1023,7 @@ static int cxgbit_handle_iscsi_dataout(s
 		cmd->data_sn = be32_to_cpu(hdr->datasn);
 
 		rc = __iscsit_check_dataout_hdr(conn, (unsigned char *)hdr,
-						cmd, payload_length, &success);
+						cmd, data_len, &success);
 		if (rc < 0)
 			return rc;
 		else if (!success)
@@ -1060,6 +1061,20 @@ static int cxgbit_handle_iscsi_dataout(s
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


