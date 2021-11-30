Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0213B463754
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242812AbhK3OxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57272 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhK3OwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F005CE1A46;
        Tue, 30 Nov 2021 14:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65562C53FCF;
        Tue, 30 Nov 2021 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283738;
        bh=nKYKdxgJTC2Ep/gpwJoreZGZj8wgXv74T6oIsOS8idM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqP0N1Jlv/P0nkd46Rfmf6XaxMJF0OFgT8/jn6qv3UIsLUQ1vAoWyQaFoqIAkZlw6
         wiwdt+tctG4/GN5E1lAzPAOsyhyS78NaW4rSFly267v0/sSyr2GYhdinQj/1cz2ox5
         YmsYkMn2aPMpgsmmYY7agfGStMT2T6b078oAoT+qLndRXPUKzVhaBNf4NqG4RI/Xy1
         zqdZl6B5HUhSY/KOR9yUPQE9Hys2hEVq0NobuZpw9/tCBclCqF/de7q5Nh0qSbjZLo
         xSOUDbojTNK9nRRgFB6zVy46aimq7f90Z4GDBuR2UlDOgUNprGbc8eL1HsLYJyJG9k
         KlelGIpjuaxcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 43/68] nvme-tcp: validate R2T PDU in nvme_tcp_handle_r2t()
Date:   Tue, 30 Nov 2021 09:46:39 -0500
Message-Id: <20211130144707.944580-43-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 1d3ef9c3a39e04be31155c27ebf80342350c3abf ]

If maxh2cdata < r2t_length then driver will form multiple
H2CData PDUs, validate R2T PDU in nvme_tcp_handle_r2t() to
reuse nvme_tcp_setup_h2c_data_pdu().

Also set req->state to NVME_TCP_SEND_H2C_PDU in
nvme_tcp_setup_h2c_data_pdu().

Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 55 ++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4ae562d30d2b9..da733749192c6 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -572,7 +572,7 @@ static int nvme_tcp_handle_comp(struct nvme_tcp_queue *queue,
 	return ret;
 }
 
-static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
+static void nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 		struct nvme_tcp_r2t_pdu *pdu)
 {
 	struct nvme_tcp_data_pdu *data = req->pdu;
@@ -581,32 +581,11 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	u8 ddgst = nvme_tcp_ddgst_len(queue);
 
+	req->state = NVME_TCP_SEND_H2C_PDU;
+	req->offset = 0;
 	req->pdu_len = le32_to_cpu(pdu->r2t_length);
 	req->pdu_sent = 0;
 
-	if (unlikely(!req->pdu_len)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d r2t len is %u, probably a bug...\n",
-			rq->tag, req->pdu_len);
-		return -EPROTO;
-	}
-
-	if (unlikely(req->data_sent + req->pdu_len > req->data_len)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d r2t len %u exceeded data len %u (%zu sent)\n",
-			rq->tag, req->pdu_len, req->data_len,
-			req->data_sent);
-		return -EPROTO;
-	}
-
-	if (unlikely(le32_to_cpu(pdu->r2t_offset) < req->data_sent)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d unexpected r2t offset %u (expected %zu)\n",
-			rq->tag, le32_to_cpu(pdu->r2t_offset),
-			req->data_sent);
-		return -EPROTO;
-	}
-
 	memset(data, 0, sizeof(*data));
 	data->hdr.type = nvme_tcp_h2c_data;
 	data->hdr.flags = NVME_TCP_F_DATA_LAST;
@@ -622,7 +601,6 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	data->command_id = nvme_cid(rq);
 	data->data_offset = pdu->r2t_offset;
 	data->data_length = cpu_to_le32(req->pdu_len);
-	return 0;
 }
 
 static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
@@ -630,7 +608,7 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 {
 	struct nvme_tcp_request *req;
 	struct request *rq;
-	int ret;
+	u32 r2t_length = le32_to_cpu(pdu->r2t_length);
 
 	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
@@ -641,13 +619,28 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
-	ret = nvme_tcp_setup_h2c_data_pdu(req, pdu);
-	if (unlikely(ret))
-		return ret;
+	if (unlikely(!r2t_length)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d r2t len is %u, probably a bug...\n",
+			rq->tag, r2t_length);
+		return -EPROTO;
+	}
 
-	req->state = NVME_TCP_SEND_H2C_PDU;
-	req->offset = 0;
+	if (unlikely(req->data_sent + r2t_length > req->data_len)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d r2t len %u exceeded data len %u (%zu sent)\n",
+			rq->tag, r2t_length, req->data_len, req->data_sent);
+		return -EPROTO;
+	}
+
+	if (unlikely(le32_to_cpu(pdu->r2t_offset) < req->data_sent)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t offset %u (expected %zu)\n",
+			rq->tag, le32_to_cpu(pdu->r2t_offset), req->data_sent);
+		return -EPROTO;
+	}
 
+	nvme_tcp_setup_h2c_data_pdu(req, pdu);
 	nvme_tcp_queue_request(req, false, true);
 
 	return 0;
-- 
2.33.0

