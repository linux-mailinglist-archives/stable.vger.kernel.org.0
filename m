Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7937C9F8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhELQXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232990AbhELQNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70986619AC;
        Wed, 12 May 2021 15:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834103;
        bh=/2PZ05TWR4TOZ3n/k6GflWD5+nE/eKQ7UrY67WWXQHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PO3WTS0AeQxieq3xv8WRz7l7io4P/sr/uXaR0dbuDylmFHyFApGagzVDKrQJF55S3
         sosjrWnjJqoK6YgfT5bAtBl2LMbJOcr9sbPz81mSeE2WxSZWV7n9Z4CKUP7ewDNUf5
         rHOHnQv50rFfvcFYRgY1kW9+0wVoYdF8vO/MuFXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elad Grupi <elad.grupi@dell.com>,
        Hou Pu <houpu.main@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 375/601] nvmet-tcp: fix a segmentation fault during io parsing error
Date:   Wed, 12 May 2021 16:47:32 +0200
Message-Id: <20210512144840.146393428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elad Grupi <elad.grupi@dell.com>

[ Upstream commit bdaf13279192c60b2b1fc99badef53b494fec055 ]

In case there is an io that contains inline data and it goes to
parsing error flow, command response will free command and iov
before clearing the data on the socket buffer.
This will delay the command response until receive flow is completed.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Elad Grupi <elad.grupi@dell.com>
Signed-off-by: Hou Pu <houpu.main@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 218fd766dc74..d958b5da9b88 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -525,11 +525,36 @@ static void nvmet_tcp_queue_response(struct nvmet_req *req)
 	struct nvmet_tcp_cmd *cmd =
 		container_of(req, struct nvmet_tcp_cmd, req);
 	struct nvmet_tcp_queue	*queue = cmd->queue;
+	struct nvme_sgl_desc *sgl;
+	u32 len;
+
+	if (unlikely(cmd == queue->cmd)) {
+		sgl = &cmd->req.cmd->common.dptr.sgl;
+		len = le32_to_cpu(sgl->length);
+
+		/*
+		 * Wait for inline data before processing the response.
+		 * Avoid using helpers, this might happen before
+		 * nvmet_req_init is completed.
+		 */
+		if (queue->rcv_state == NVMET_TCP_RECV_PDU &&
+		    len && len < cmd->req.port->inline_data_size &&
+		    nvme_is_write(cmd->req.cmd))
+			return;
+	}
 
 	llist_add(&cmd->lentry, &queue->resp_list);
 	queue_work_on(queue_cpu(queue), nvmet_tcp_wq, &cmd->queue->io_work);
 }
 
+static void nvmet_tcp_execute_request(struct nvmet_tcp_cmd *cmd)
+{
+	if (unlikely(cmd->flags & NVMET_TCP_F_INIT_FAILED))
+		nvmet_tcp_queue_response(&cmd->req);
+	else
+		cmd->req.execute(&cmd->req);
+}
+
 static int nvmet_try_send_data_pdu(struct nvmet_tcp_cmd *cmd)
 {
 	u8 hdgst = nvmet_tcp_hdgst_len(cmd->queue);
@@ -961,7 +986,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 			le32_to_cpu(req->cmd->common.dptr.sgl.length));
 
 		nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
-		return -EAGAIN;
+		return 0;
 	}
 
 	ret = nvmet_tcp_map_data(queue->cmd);
@@ -1104,10 +1129,8 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 		return 0;
 	}
 
-	if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED) &&
-	    cmd->rbytes_done == cmd->req.transfer_len) {
-		cmd->req.execute(&cmd->req);
-	}
+	if (cmd->rbytes_done == cmd->req.transfer_len)
+		nvmet_tcp_execute_request(cmd);
 
 	nvmet_prepare_receive_pdu(queue);
 	return 0;
@@ -1144,9 +1167,9 @@ static int nvmet_tcp_try_recv_ddgst(struct nvmet_tcp_queue *queue)
 		goto out;
 	}
 
-	if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED) &&
-	    cmd->rbytes_done == cmd->req.transfer_len)
-		cmd->req.execute(&cmd->req);
+	if (cmd->rbytes_done == cmd->req.transfer_len)
+		nvmet_tcp_execute_request(cmd);
+
 	ret = 0;
 out:
 	nvmet_prepare_receive_pdu(queue);
-- 
2.30.2



