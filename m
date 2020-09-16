Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC02E26B4E5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgIOXdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgIOOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 774F8222E9;
        Tue, 15 Sep 2020 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179981;
        bh=qijB1yiqv0TChRqJhGWK0a81FKD9rh0lJdNbYvxuCuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woiaySVdK8hMteIf5P59crCQliWbnOdl1SXqUm9UTLK48MFiwGeW9Qas3WdQ/TiCl
         cFRqiyYo0UN7MfzPvQTBRnguh8lsmBsddPQl4QjQHynOHO5CNiPxJ+L0RkoRWkE+9D
         /0MXPiBS7/Eve72FMv01bF2W8Z+OwaL90NXwNMjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rust <srust@blockbridge.com>,
        Doug Dumitru <doug@dumitru.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 054/177] IB/isert: Fix unaligned immediate-data handling
Date:   Tue, 15 Sep 2020 16:12:05 +0200
Message-Id: <20200915140656.223173789@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 0b089c1ef7047652b13b4cdfdb1e0e7dbdb8c9ab ]

Currently we allocate rx buffers in a single contiguous buffers for
headers (iser and iscsi) and data trailer. This means that most likely the
data starting offset is aligned to 76 bytes (size of both headers).

This worked fine for years, but at some point this broke, resulting in
data corruptions in isert when a command comes with immediate data and the
underlying backend device assumes 512 bytes buffer alignment.

We assume a hard-requirement for all direct I/O buffers to be 512 bytes
aligned. To fix this, we should avoid passing unaligned buffers for I/O.

Instead, we allocate our recv buffers with some extra space such that we
can have the data portion align to 512 byte boundary. This also means that
we cannot reference headers or data using structure but rather
accessors (as they may move based on alignment). Also, get rid of the
wrong __packed annotation from iser_rx_desc as this has only harmful
effects (not aligned to anything).

This affects the rx descriptors for iscsi login and data plane.

Fixes: 3d75ca0adef4 ("block: introduce multi-page bvec helpers")
Link: https://lore.kernel.org/r/20200904195039.31687-1-sagi@grimberg.me
Reported-by: Stephen Rust <srust@blockbridge.com>
Tested-by: Doug Dumitru <doug@dumitru.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 93 +++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h | 41 ++++++++---
 2 files changed, 78 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b7df38ee8ae05..49ca8727e3fa3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -183,15 +183,15 @@ isert_alloc_rx_descriptors(struct isert_conn *isert_conn)
 	rx_desc = isert_conn->rx_descs;
 
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
-		dma_addr = ib_dma_map_single(ib_dev, (void *)rx_desc,
-					ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+		dma_addr = ib_dma_map_single(ib_dev, rx_desc->buf,
+					ISER_RX_SIZE, DMA_FROM_DEVICE);
 		if (ib_dma_mapping_error(ib_dev, dma_addr))
 			goto dma_map_fail;
 
 		rx_desc->dma_addr = dma_addr;
 
 		rx_sg = &rx_desc->rx_sg;
-		rx_sg->addr = rx_desc->dma_addr;
+		rx_sg->addr = rx_desc->dma_addr + isert_get_hdr_offset(rx_desc);
 		rx_sg->length = ISER_RX_PAYLOAD_SIZE;
 		rx_sg->lkey = device->pd->local_dma_lkey;
 		rx_desc->rx_cqe.done = isert_recv_done;
@@ -203,7 +203,7 @@ dma_map_fail:
 	rx_desc = isert_conn->rx_descs;
 	for (j = 0; j < i; j++, rx_desc++) {
 		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+				    ISER_RX_SIZE, DMA_FROM_DEVICE);
 	}
 	kfree(isert_conn->rx_descs);
 	isert_conn->rx_descs = NULL;
@@ -224,7 +224,7 @@ isert_free_rx_descriptors(struct isert_conn *isert_conn)
 	rx_desc = isert_conn->rx_descs;
 	for (i = 0; i < ISERT_QP_MAX_RECV_DTOS; i++, rx_desc++)  {
 		ib_dma_unmap_single(ib_dev, rx_desc->dma_addr,
-				    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+				    ISER_RX_SIZE, DMA_FROM_DEVICE);
 	}
 
 	kfree(isert_conn->rx_descs);
@@ -409,10 +409,9 @@ isert_free_login_buf(struct isert_conn *isert_conn)
 			    ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
 	kfree(isert_conn->login_rsp_buf);
 
-	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISER_RX_PAYLOAD_SIZE,
-			    DMA_FROM_DEVICE);
-	kfree(isert_conn->login_req_buf);
+	ib_dma_unmap_single(ib_dev, isert_conn->login_desc->dma_addr,
+			    ISER_RX_SIZE, DMA_FROM_DEVICE);
+	kfree(isert_conn->login_desc);
 }
 
 static int
@@ -421,25 +420,25 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 {
 	int ret;
 
-	isert_conn->login_req_buf = kzalloc(sizeof(*isert_conn->login_req_buf),
+	isert_conn->login_desc = kzalloc(sizeof(*isert_conn->login_desc),
 			GFP_KERNEL);
-	if (!isert_conn->login_req_buf)
+	if (!isert_conn->login_desc)
 		return -ENOMEM;
 
-	isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
-				isert_conn->login_req_buf,
-				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
+	isert_conn->login_desc->dma_addr = ib_dma_map_single(ib_dev,
+				isert_conn->login_desc->buf,
+				ISER_RX_SIZE, DMA_FROM_DEVICE);
+	ret = ib_dma_mapping_error(ib_dev, isert_conn->login_desc->dma_addr);
 	if (ret) {
-		isert_err("login_req_dma mapping error: %d\n", ret);
-		isert_conn->login_req_dma = 0;
-		goto out_free_login_req_buf;
+		isert_err("login_desc dma mapping error: %d\n", ret);
+		isert_conn->login_desc->dma_addr = 0;
+		goto out_free_login_desc;
 	}
 
 	isert_conn->login_rsp_buf = kzalloc(ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
 	if (!isert_conn->login_rsp_buf) {
 		ret = -ENOMEM;
-		goto out_unmap_login_req_buf;
+		goto out_unmap_login_desc;
 	}
 
 	isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
@@ -456,11 +455,11 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 
 out_free_login_rsp_buf:
 	kfree(isert_conn->login_rsp_buf);
-out_unmap_login_req_buf:
-	ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
-			    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
-out_free_login_req_buf:
-	kfree(isert_conn->login_req_buf);
+out_unmap_login_desc:
+	ib_dma_unmap_single(ib_dev, isert_conn->login_desc->dma_addr,
+			    ISER_RX_SIZE, DMA_FROM_DEVICE);
+out_free_login_desc:
+	kfree(isert_conn->login_desc);
 	return ret;
 }
 
@@ -579,7 +578,7 @@ isert_connect_release(struct isert_conn *isert_conn)
 		ib_destroy_qp(isert_conn->qp);
 	}
 
-	if (isert_conn->login_req_buf)
+	if (isert_conn->login_desc)
 		isert_free_login_buf(isert_conn);
 
 	isert_device_put(device);
@@ -965,17 +964,18 @@ isert_login_post_recv(struct isert_conn *isert_conn)
 	int ret;
 
 	memset(&sge, 0, sizeof(struct ib_sge));
-	sge.addr = isert_conn->login_req_dma;
+	sge.addr = isert_conn->login_desc->dma_addr +
+		isert_get_hdr_offset(isert_conn->login_desc);
 	sge.length = ISER_RX_PAYLOAD_SIZE;
 	sge.lkey = isert_conn->device->pd->local_dma_lkey;
 
 	isert_dbg("Setup sge: addr: %llx length: %d 0x%08x\n",
 		sge.addr, sge.length, sge.lkey);
 
-	isert_conn->login_req_buf->rx_cqe.done = isert_login_recv_done;
+	isert_conn->login_desc->rx_cqe.done = isert_login_recv_done;
 
 	memset(&rx_wr, 0, sizeof(struct ib_recv_wr));
-	rx_wr.wr_cqe = &isert_conn->login_req_buf->rx_cqe;
+	rx_wr.wr_cqe = &isert_conn->login_desc->rx_cqe;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 
@@ -1052,7 +1052,7 @@ post_send:
 static void
 isert_rx_login_req(struct isert_conn *isert_conn)
 {
-	struct iser_rx_desc *rx_desc = isert_conn->login_req_buf;
+	struct iser_rx_desc *rx_desc = isert_conn->login_desc;
 	int rx_buflen = isert_conn->login_req_len;
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_login *login = conn->conn_login;
@@ -1064,7 +1064,7 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 
 	if (login->first_request) {
 		struct iscsi_login_req *login_req =
-			(struct iscsi_login_req *)&rx_desc->iscsi_header;
+			(struct iscsi_login_req *)isert_get_iscsi_hdr(rx_desc);
 		/*
 		 * Setup the initial iscsi_login values from the leading
 		 * login request PDU.
@@ -1083,13 +1083,13 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 		login->tsih		= be16_to_cpu(login_req->tsih);
 	}
 
-	memcpy(&login->req[0], (void *)&rx_desc->iscsi_header, ISCSI_HDR_LEN);
+	memcpy(&login->req[0], isert_get_iscsi_hdr(rx_desc), ISCSI_HDR_LEN);
 
 	size = min(rx_buflen, MAX_KEY_VALUE_PAIRS);
 	isert_dbg("Using login payload size: %d, rx_buflen: %d "
 		  "MAX_KEY_VALUE_PAIRS: %d\n", size, rx_buflen,
 		  MAX_KEY_VALUE_PAIRS);
-	memcpy(login->req_buf, &rx_desc->data[0], size);
+	memcpy(login->req_buf, isert_get_data(rx_desc), size);
 
 	if (login->first_request) {
 		complete(&isert_conn->login_comp);
@@ -1154,14 +1154,15 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 	if (imm_data_len != data_len) {
 		sg_nents = max(1UL, DIV_ROUND_UP(imm_data_len, PAGE_SIZE));
 		sg_copy_from_buffer(cmd->se_cmd.t_data_sg, sg_nents,
-				    &rx_desc->data[0], imm_data_len);
+				    isert_get_data(rx_desc), imm_data_len);
 		isert_dbg("Copy Immediate sg_nents: %u imm_data_len: %d\n",
 			  sg_nents, imm_data_len);
 	} else {
 		sg_init_table(&isert_cmd->sg, 1);
 		cmd->se_cmd.t_data_sg = &isert_cmd->sg;
 		cmd->se_cmd.t_data_nents = 1;
-		sg_set_buf(&isert_cmd->sg, &rx_desc->data[0], imm_data_len);
+		sg_set_buf(&isert_cmd->sg, isert_get_data(rx_desc),
+				imm_data_len);
 		isert_dbg("Transfer Immediate imm_data_len: %d\n",
 			  imm_data_len);
 	}
@@ -1230,9 +1231,9 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
-		  sg_nents, &rx_desc->data[0], unsol_data_len);
+		  sg_nents, isert_get_data(rx_desc), unsol_data_len);
 
-	sg_copy_from_buffer(sg_start, sg_nents, &rx_desc->data[0],
+	sg_copy_from_buffer(sg_start, sg_nents, isert_get_data(rx_desc),
 			    unsol_data_len);
 
 	rc = iscsit_check_dataout_payload(cmd, hdr, false);
@@ -1291,7 +1292,7 @@ isert_handle_text_cmd(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd
 	}
 	cmd->text_in_ptr = text_in;
 
-	memcpy(cmd->text_in_ptr, &rx_desc->data[0], payload_length);
+	memcpy(cmd->text_in_ptr, isert_get_data(rx_desc), payload_length);
 
 	return iscsit_process_text_cmd(conn, cmd, hdr);
 }
@@ -1301,7 +1302,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 		uint32_t read_stag, uint64_t read_va,
 		uint32_t write_stag, uint64_t write_va)
 {
-	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
+	struct iscsi_hdr *hdr = isert_get_iscsi_hdr(rx_desc);
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_cmd *cmd;
 	struct isert_cmd *isert_cmd;
@@ -1399,8 +1400,8 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iser_rx_desc *rx_desc = cqe_to_rx_desc(wc->wr_cqe);
-	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
-	struct iser_ctrl *iser_ctrl = &rx_desc->iser_header;
+	struct iscsi_hdr *hdr = isert_get_iscsi_hdr(rx_desc);
+	struct iser_ctrl *iser_ctrl = isert_get_iser_hdr(rx_desc);
 	uint64_t read_va = 0, write_va = 0;
 	uint32_t read_stag = 0, write_stag = 0;
 
@@ -1414,7 +1415,7 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	rx_desc->in_use = true;
 
 	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
 	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
 		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
@@ -1449,7 +1450,7 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			read_stag, read_va, write_stag, write_va);
 
 	ib_dma_sync_single_for_device(ib_dev, rx_desc->dma_addr,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+			ISER_RX_SIZE, DMA_FROM_DEVICE);
 }
 
 static void
@@ -1463,8 +1464,8 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_req_dma,
-			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_desc->dma_addr,
+			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
 	isert_conn->login_req_len = wc->byte_len - ISER_HEADERS_LEN;
 
@@ -1479,8 +1480,8 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	complete(&isert_conn->login_req_comp);
 	mutex_unlock(&isert_conn->mutex);
 
-	ib_dma_sync_single_for_device(ib_dev, isert_conn->login_req_dma,
-				ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
+	ib_dma_sync_single_for_device(ib_dev, isert_conn->login_desc->dma_addr,
+				ISER_RX_SIZE, DMA_FROM_DEVICE);
 }
 
 static void
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 3b296bac4f603..d267a6d60d87d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -59,9 +59,11 @@
 				ISERT_MAX_TX_MISC_PDUS	+ \
 				ISERT_MAX_RX_MISC_PDUS)
 
-#define ISER_RX_PAD_SIZE	(ISCSI_DEF_MAX_RECV_SEG_LEN + 4096 - \
-		(ISER_RX_PAYLOAD_SIZE + sizeof(u64) + sizeof(struct ib_sge) + \
-		 sizeof(struct ib_cqe) + sizeof(bool)))
+/*
+ * RX size is default of 8k plus headers, but data needs to align to
+ * 512 boundary, so use 1024 to have the extra space for alignment.
+ */
+#define ISER_RX_SIZE		(ISCSI_DEF_MAX_RECV_SEG_LEN + 1024)
 
 #define ISCSI_ISER_SG_TABLESIZE		256
 
@@ -80,21 +82,41 @@ enum iser_conn_state {
 };
 
 struct iser_rx_desc {
-	struct iser_ctrl iser_header;
-	struct iscsi_hdr iscsi_header;
-	char		data[ISCSI_DEF_MAX_RECV_SEG_LEN];
+	char		buf[ISER_RX_SIZE];
 	u64		dma_addr;
 	struct ib_sge	rx_sg;
 	struct ib_cqe	rx_cqe;
 	bool		in_use;
-	char		pad[ISER_RX_PAD_SIZE];
-} __packed;
+};
 
 static inline struct iser_rx_desc *cqe_to_rx_desc(struct ib_cqe *cqe)
 {
 	return container_of(cqe, struct iser_rx_desc, rx_cqe);
 }
 
+static void *isert_get_iser_hdr(struct iser_rx_desc *desc)
+{
+	return PTR_ALIGN(desc->buf + ISER_HEADERS_LEN, 512) - ISER_HEADERS_LEN;
+}
+
+static size_t isert_get_hdr_offset(struct iser_rx_desc *desc)
+{
+	return isert_get_iser_hdr(desc) - (void *)desc->buf;
+}
+
+static void *isert_get_iscsi_hdr(struct iser_rx_desc *desc)
+{
+	return isert_get_iser_hdr(desc) + sizeof(struct iser_ctrl);
+}
+
+static void *isert_get_data(struct iser_rx_desc *desc)
+{
+	void *data = isert_get_iser_hdr(desc) + ISER_HEADERS_LEN;
+
+	WARN_ON((uintptr_t)data & 511);
+	return data;
+}
+
 struct iser_tx_desc {
 	struct iser_ctrl iser_header;
 	struct iscsi_hdr iscsi_header;
@@ -141,9 +163,8 @@ struct isert_conn {
 	u32			responder_resources;
 	u32			initiator_depth;
 	bool			pi_support;
-	struct iser_rx_desc	*login_req_buf;
+	struct iser_rx_desc	*login_desc;
 	char			*login_rsp_buf;
-	u64			login_req_dma;
 	int			login_req_len;
 	u64			login_rsp_dma;
 	struct iser_rx_desc	*rx_descs;
-- 
2.25.1



