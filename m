Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121BF4D8448
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbiCNMWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243419AbiCNMUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9BC54682;
        Mon, 14 Mar 2022 05:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479EF60929;
        Mon, 14 Mar 2022 12:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220B8C340E9;
        Mon, 14 Mar 2022 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260158;
        bh=Mn3ZAXXYN0wlzr5sfyvgH04MeEhFmhRzBo14BQTdZW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9JgANKFsnQz0FQyr3p5K6hMHNiYAu1qQA+D5AH/AhfzACMtCDNdppAlyZXQR+COA
         qRFFO0INib+WltKFVObJmmjWzUSa2ISzrjp5SfnO7tgWegGxkqEFRGDj/WpV6IeIc3
         uHo4NRHl6rhcS3cDiuzA6ppbuKBORnWhhIyFC7ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 074/121] nvme-tcp: send H2CData PDUs based on MAXH2CDATA
Date:   Mon, 14 Mar 2022 12:54:17 +0100
Message-Id: <20220314112746.187726367@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit c2700d2886a87f83f31e0a301de1d2350b52c79b ]

As per NVMe/TCP specification (revision 1.0a, section 3.6.2.3)
Maximum Host to Controller Data length (MAXH2CDATA): Specifies the
maximum number of PDU-Data bytes per H2CData PDU in bytes. This value
is a multiple of dwords and should be no less than 4,096.

Current code sets H2CData PDU data_length to r2t_length,
it does not check MAXH2CDATA value. Fix this by setting H2CData PDU
data_length to min(req->h2cdata_left, queue->maxh2cdata).

Also validate MAXH2CDATA value returned by target in ICResp PDU,
if it is not a multiple of dword or if it is less than 4096 return
-EINVAL from nvme_tcp_init_connection().

Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c  | 63 +++++++++++++++++++++++++++++++---------
 include/linux/nvme-tcp.h |  1 +
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 891a36d02e7c..65e00c64a588 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -44,6 +44,8 @@ struct nvme_tcp_request {
 	u32			data_len;
 	u32			pdu_len;
 	u32			pdu_sent;
+	u32			h2cdata_left;
+	u32			h2cdata_offset;
 	u16			ttag;
 	__le16			status;
 	struct list_head	entry;
@@ -95,6 +97,7 @@ struct nvme_tcp_queue {
 	struct nvme_tcp_request *request;
 
 	int			queue_size;
+	u32			maxh2cdata;
 	size_t			cmnd_capsule_len;
 	struct nvme_tcp_ctrl	*ctrl;
 	unsigned long		flags;
@@ -572,23 +575,26 @@ static int nvme_tcp_handle_comp(struct nvme_tcp_queue *queue,
 	return ret;
 }
 
-static void nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
-		struct nvme_tcp_r2t_pdu *pdu)
+static void nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_data_pdu *data = req->pdu;
 	struct nvme_tcp_queue *queue = req->queue;
 	struct request *rq = blk_mq_rq_from_pdu(req);
+	u32 h2cdata_sent = req->pdu_len;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	u8 ddgst = nvme_tcp_ddgst_len(queue);
 
 	req->state = NVME_TCP_SEND_H2C_PDU;
 	req->offset = 0;
-	req->pdu_len = le32_to_cpu(pdu->r2t_length);
+	req->pdu_len = min(req->h2cdata_left, queue->maxh2cdata);
 	req->pdu_sent = 0;
+	req->h2cdata_left -= req->pdu_len;
+	req->h2cdata_offset += h2cdata_sent;
 
 	memset(data, 0, sizeof(*data));
 	data->hdr.type = nvme_tcp_h2c_data;
-	data->hdr.flags = NVME_TCP_F_DATA_LAST;
+	if (!req->h2cdata_left)
+		data->hdr.flags = NVME_TCP_F_DATA_LAST;
 	if (queue->hdr_digest)
 		data->hdr.flags |= NVME_TCP_F_HDGST;
 	if (queue->data_digest)
@@ -597,9 +603,9 @@ static void nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	data->hdr.pdo = data->hdr.hlen + hdgst;
 	data->hdr.plen =
 		cpu_to_le32(data->hdr.hlen + hdgst + req->pdu_len + ddgst);
-	data->ttag = pdu->ttag;
+	data->ttag = req->ttag;
 	data->command_id = nvme_cid(rq);
-	data->data_offset = pdu->r2t_offset;
+	data->data_offset = cpu_to_le32(req->h2cdata_offset);
 	data->data_length = cpu_to_le32(req->pdu_len);
 }
 
@@ -609,6 +615,7 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	struct nvme_tcp_request *req;
 	struct request *rq;
 	u32 r2t_length = le32_to_cpu(pdu->r2t_length);
+	u32 r2t_offset = le32_to_cpu(pdu->r2t_offset);
 
 	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
@@ -633,14 +640,19 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 		return -EPROTO;
 	}
 
-	if (unlikely(le32_to_cpu(pdu->r2t_offset) < req->data_sent)) {
+	if (unlikely(r2t_offset < req->data_sent)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d unexpected r2t offset %u (expected %zu)\n",
-			rq->tag, le32_to_cpu(pdu->r2t_offset), req->data_sent);
+			rq->tag, r2t_offset, req->data_sent);
 		return -EPROTO;
 	}
 
-	nvme_tcp_setup_h2c_data_pdu(req, pdu);
+	req->pdu_len = 0;
+	req->h2cdata_left = r2t_length;
+	req->h2cdata_offset = r2t_offset;
+	req->ttag = pdu->ttag;
+
+	nvme_tcp_setup_h2c_data_pdu(req);
 	nvme_tcp_queue_request(req, false, true);
 
 	return 0;
@@ -928,6 +940,7 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	int req_data_len = req->data_len;
+	u32 h2cdata_left = req->h2cdata_left;
 
 	while (true) {
 		struct page *page = nvme_tcp_req_cur_page(req);
@@ -972,7 +985,10 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 				req->state = NVME_TCP_SEND_DDGST;
 				req->offset = 0;
 			} else {
-				nvme_tcp_done_send_req(queue);
+				if (h2cdata_left)
+					nvme_tcp_setup_h2c_data_pdu(req);
+				else
+					nvme_tcp_done_send_req(queue);
 			}
 			return 1;
 		}
@@ -1030,9 +1046,14 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
-	ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
-			offset_in_page(pdu) + req->offset, len,
-			MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST);
+	if (!req->h2cdata_left)
+		ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
+				offset_in_page(pdu) + req->offset, len,
+				MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST);
+	else
+		ret = sock_no_sendpage(queue->sock, virt_to_page(pdu),
+				offset_in_page(pdu) + req->offset, len,
+				MSG_DONTWAIT | MSG_MORE);
 	if (unlikely(ret <= 0))
 		return ret;
 
@@ -1052,6 +1073,7 @@ static int nvme_tcp_try_send_ddgst(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	size_t offset = req->offset;
+	u32 h2cdata_left = req->h2cdata_left;
 	int ret;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
@@ -1069,7 +1091,10 @@ static int nvme_tcp_try_send_ddgst(struct nvme_tcp_request *req)
 		return ret;
 
 	if (offset + ret == NVME_TCP_DIGEST_LENGTH) {
-		nvme_tcp_done_send_req(queue);
+		if (h2cdata_left)
+			nvme_tcp_setup_h2c_data_pdu(req);
+		else
+			nvme_tcp_done_send_req(queue);
 		return 1;
 	}
 
@@ -1261,6 +1286,7 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 	struct msghdr msg = {};
 	struct kvec iov;
 	bool ctrl_hdgst, ctrl_ddgst;
+	u32 maxh2cdata;
 	int ret;
 
 	icreq = kzalloc(sizeof(*icreq), GFP_KERNEL);
@@ -1344,6 +1370,14 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 		goto free_icresp;
 	}
 
+	maxh2cdata = le32_to_cpu(icresp->maxdata);
+	if ((maxh2cdata % 4) || (maxh2cdata < NVME_TCP_MIN_MAXH2CDATA)) {
+		pr_err("queue %d: invalid maxh2cdata returned %u\n",
+		       nvme_tcp_queue_id(queue), maxh2cdata);
+		goto free_icresp;
+	}
+	queue->maxh2cdata = maxh2cdata;
+
 	ret = 0;
 free_icresp:
 	kfree(icresp);
@@ -2329,6 +2363,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	req->data_sent = 0;
 	req->pdu_len = 0;
 	req->pdu_sent = 0;
+	req->h2cdata_left = 0;
 	req->data_len = blk_rq_nr_phys_segments(rq) ?
 				blk_rq_payload_bytes(rq) : 0;
 	req->curr_bio = rq->bio;
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 959e0bd9a913..75470159a194 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -12,6 +12,7 @@
 #define NVME_TCP_DISC_PORT	8009
 #define NVME_TCP_ADMIN_CCSZ	SZ_8K
 #define NVME_TCP_DIGEST_LENGTH	4
+#define NVME_TCP_MIN_MAXH2CDATA 4096
 
 enum nvme_tcp_pfv {
 	NVME_TCP_PFV_1_0 = 0x0,
-- 
2.34.1



