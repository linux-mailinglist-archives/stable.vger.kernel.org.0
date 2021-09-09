Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6554051DB
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352558AbhIIMjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353804AbhIIMe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B6D61B60;
        Thu,  9 Sep 2021 11:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188424;
        bh=hraAZUaUstvGfsDdP1DapaZvNGEzFa/sM4IgVGUNtHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXEDkxhtwC8bySx4TvnxDaI7xUOrSRm/WEf5W0F08rGlrwzXYonEWrIpZ9wOQWqPM
         v962Bt7v6pcvG9Vr1GjkrGKvvCamewoxGewe2WYhqe7hhggoq1SDRaKw+OKWJfCrMr
         G3wqiZaOk0hlzYTc5BFMWr9RAQCtMDeRuaJobaLVm45vg05DyNSlwN2MQVpQP5QjNr
         X9AtJQh9zqryyvxbZlbhibG8DDIoIB7jGT4plpZQ1EgQSUGHuKBCjPHhQOzYItIY4X
         73vDwjxBi7ZJfenprpWADDUvcCn/G2TLjbYngOcMVPCI4xV91AKSc0hlVRQtJIKbZl
         hsthMUBeCC3pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 113/176] nvme: code command_id with a genctr for use-after-free validation
Date:   Thu,  9 Sep 2021 07:50:15 -0400
Message-Id: <20210909115118.146181-113-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit e7006de6c23803799be000a5dcce4d916a36541a ]

We cannot detect a (perhaps buggy) controller that is sending us
a completion for a request that was already completed (for example
sending a completion twice), this phenomenon was seen in the wild
a few times.

So to protect against this, we use the upper 4 msbits of the nvme sqe
command_id to use as a 4-bit generation counter and verify it matches
the existing request generation that is incrementing on every execution.

The 16-bit command_id structure now is constructed by:
| xxxx | xxxxxxxxxxxx |
  gen    request tag

This means that we are giving up some possible queue depth as 12 bits
allow for a maximum queue depth of 4095 instead of 65536, however we
never create such long queues anyways so no real harm done.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Acked-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c   |  3 ++-
 drivers/nvme/host/nvme.h   | 47 +++++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/pci.c    |  2 +-
 drivers/nvme/host/rdma.c   |  4 ++--
 drivers/nvme/host/tcp.c    | 26 ++++++++++-----------
 drivers/nvme/target/loop.c |  4 ++--
 6 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ff5a16b17133..5a9b2f1b1418 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -878,7 +878,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		return BLK_STS_IOERR;
 	}
 
-	cmd->common.command_id = req->tag;
+	nvme_req(req)->genctr++;
+	cmd->common.command_id = nvme_cid(req);
 	trace_nvme_setup_cmd(req, cmd);
 	return ret;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 3cb3c82061d7..8c735c55c15b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -153,6 +153,7 @@ enum nvme_quirks {
 struct nvme_request {
 	struct nvme_command	*cmd;
 	union nvme_result	result;
+	u8			genctr;
 	u8			retries;
 	u8			flags;
 	u16			status;
@@ -469,6 +470,49 @@ struct nvme_ctrl_ops {
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
+/*
+ * nvme command_id is constructed as such:
+ * | xxxx | xxxxxxxxxxxx |
+ *   gen    request tag
+ */
+#define nvme_genctr_mask(gen)			(gen & 0xf)
+#define nvme_cid_install_genctr(gen)		(nvme_genctr_mask(gen) << 12)
+#define nvme_genctr_from_cid(cid)		((cid & 0xf000) >> 12)
+#define nvme_tag_from_cid(cid)			(cid & 0xfff)
+
+static inline u16 nvme_cid(struct request *rq)
+{
+	return nvme_cid_install_genctr(nvme_req(rq)->genctr) | rq->tag;
+}
+
+static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
+		u16 command_id)
+{
+	u8 genctr = nvme_genctr_from_cid(command_id);
+	u16 tag = nvme_tag_from_cid(command_id);
+	struct request *rq;
+
+	rq = blk_mq_tag_to_rq(tags, tag);
+	if (unlikely(!rq)) {
+		pr_err("could not locate request for tag %#x\n",
+			tag);
+		return NULL;
+	}
+	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
+		dev_err(nvme_req(rq)->ctrl->device,
+			"request %#x genctr mismatch (got %#x expected %#x)\n",
+			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
+		return NULL;
+	}
+	return rq;
+}
+
+static inline struct request *nvme_cid_to_rq(struct blk_mq_tags *tags,
+                u16 command_id)
+{
+	return blk_mq_tag_to_rq(tags, nvme_tag_from_cid(command_id));
+}
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 void nvme_fault_inject_init(struct nvme_fault_inject *fault_inj,
 			    const char *dev_name);
@@ -566,7 +610,8 @@ static inline void nvme_put_ctrl(struct nvme_ctrl *ctrl)
 
 static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
 {
-	return !qid && command_id >= NVME_AQ_BLK_MQ_DEPTH;
+	return !qid &&
+		nvme_tag_from_cid(command_id) >= NVME_AQ_BLK_MQ_DEPTH;
 }
 
 void nvme_complete_rq(struct request *req);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index fb48a88d1acb..09767a805492 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1012,7 +1012,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 		return;
 	}
 
-	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), command_id);
+	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
 		dev_warn(nvmeq->dev->ctrl.device,
 			"invalid id %d completed on queue %d\n",
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index e6d58402b829..3d225d7fa896 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1738,10 +1738,10 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	struct request *rq;
 	struct nvme_rdma_request *req;
 
-	rq = blk_mq_tag_to_rq(nvme_rdma_tagset(queue), cqe->command_id);
+	rq = nvme_find_rq(nvme_rdma_tagset(queue), cqe->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"tag 0x%x on QP %#x not found\n",
+			"got bad command_id %#x on QP %#x\n",
 			cqe->command_id, queue->qp->qp_num);
 		nvme_rdma_error_recovery(queue->ctrl);
 		return;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index ab03da094db7..f0dae80c2e8d 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -484,11 +484,11 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 {
 	struct request *rq;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), cqe->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag 0x%x not found\n",
-			nvme_tcp_queue_id(queue), cqe->command_id);
+			"got bad cqe.command_id %#x on queue %d\n",
+			cqe->command_id, nvme_tcp_queue_id(queue));
 		nvme_tcp_error_recovery(&queue->ctrl->ctrl);
 		return -EINVAL;
 	}
@@ -505,11 +505,11 @@ static int nvme_tcp_handle_c2h_data(struct nvme_tcp_queue *queue,
 {
 	struct request *rq;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
+			"got bad c2hdata.command_id %#x on queue %d\n",
+			pdu->command_id, nvme_tcp_queue_id(queue));
 		return -ENOENT;
 	}
 
@@ -603,7 +603,7 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	data->hdr.plen =
 		cpu_to_le32(data->hdr.hlen + hdgst + req->pdu_len + ddgst);
 	data->ttag = pdu->ttag;
-	data->command_id = rq->tag;
+	data->command_id = nvme_cid(rq);
 	data->data_offset = cpu_to_le32(req->data_sent);
 	data->data_length = cpu_to_le32(req->pdu_len);
 	return 0;
@@ -616,11 +616,11 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	struct request *rq;
 	int ret;
 
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
+			"got bad r2t.command_id %#x on queue %d\n",
+			pdu->command_id, nvme_tcp_queue_id(queue));
 		return -ENOENT;
 	}
 	req = blk_mq_rq_to_pdu(rq);
@@ -700,7 +700,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 {
 	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 	struct request *rq =
-		blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 	while (true) {
@@ -793,8 +793,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	}
 
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
-						pdu->command_id);
+		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
+					pdu->command_id);
 
 		nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
 		queue->nr_cqe++;
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 16d71cc5a50e..ff3258c3eb8b 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -107,10 +107,10 @@ static void nvme_loop_queue_response(struct nvmet_req *req)
 	} else {
 		struct request *rq;
 
-		rq = blk_mq_tag_to_rq(nvme_loop_tagset(queue), cqe->command_id);
+		rq = nvme_find_rq(nvme_loop_tagset(queue), cqe->command_id);
 		if (!rq) {
 			dev_err(queue->ctrl->ctrl.device,
-				"tag 0x%x on queue %d not found\n",
+				"got bad command_id %#x on queue %d\n",
 				cqe->command_id, nvme_loop_queue_idx(queue));
 			return;
 		}
-- 
2.30.2

