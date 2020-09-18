Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F8D26F066
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgIRCn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgIRCKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797F4208E4;
        Fri, 18 Sep 2020 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395052;
        bh=4jBG96Bvbg2+e4hfZIH9ZZEJ7247lx0uvfBXxfzDYVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7HEtoNx4/K/8HXUCS1S3WDEwUx6WePNzP9DW/dN74HE+MZvtn0nBEC2DkJT4OUf1
         903JjV0MJ7D9NbszIXcc3h2oRMy9xMpei2eZol0++Sce4RrrxyljQj1AGxqW3L0OrS
         BtIrREQM4JIrDRm9lQ3hFlPWHn8Pj578uhWk6hdc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 140/206] nvmet-rdma: fix double free of rdma queue
Date:   Thu, 17 Sep 2020 22:06:56 -0400
Message-Id: <20200918020802.2065198-140-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

[ Upstream commit 21f9024355e58772ec5d7fc3534aa5e29d72a8b6 ]

In case rdma accept fails at nvmet_rdma_queue_connect(), release work is
scheduled. Later on, a new RDMA CM event may arrive since we didn't
destroy the cm-id and call nvmet_rdma_queue_connect_fail(), which
schedule another release work. This will cause calling
nvmet_rdma_free_queue twice. To fix this we implicitly destroy the cm_id
with non-zero ret code, which guarantees that new rdma_cm events will
not arrive afterwards. Also add a qp pointer to nvmet_rdma_queue
structure, so we can use it when the cm_id pointer is NULL or was
destroyed.

Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Suggested-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 08f997a390d5d..cfd26437aeaea 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -83,6 +83,7 @@ enum nvmet_rdma_queue_state {
 
 struct nvmet_rdma_queue {
 	struct rdma_cm_id	*cm_id;
+	struct ib_qp		*qp;
 	struct nvmet_port	*port;
 	struct ib_cq		*cq;
 	atomic_t		sq_wr_avail;
@@ -471,7 +472,7 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 	if (ndev->srq)
 		ret = ib_post_srq_recv(ndev->srq, &cmd->wr, NULL);
 	else
-		ret = ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, NULL);
+		ret = ib_post_recv(cmd->queue->qp, &cmd->wr, NULL);
 
 	if (unlikely(ret))
 		pr_err("post_recv cmd failed\n");
@@ -510,7 +511,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	atomic_add(1 + rsp->n_rdma, &queue->sq_wr_avail);
 
 	if (rsp->n_rdma) {
-		rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
+		rdma_rw_ctx_destroy(&rsp->rw, queue->qp,
 				queue->cm_id->port_num, rsp->req.sg,
 				rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
 	}
@@ -594,7 +595,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	WARN_ON(rsp->n_rdma <= 0);
 	atomic_add(rsp->n_rdma, &queue->sq_wr_avail);
-	rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
+	rdma_rw_ctx_destroy(&rsp->rw, queue->qp,
 			queue->cm_id->port_num, rsp->req.sg,
 			rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
 	rsp->n_rdma = 0;
@@ -737,7 +738,7 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 	}
 
 	if (nvmet_rdma_need_data_in(rsp)) {
-		if (rdma_rw_ctx_post(&rsp->rw, queue->cm_id->qp,
+		if (rdma_rw_ctx_post(&rsp->rw, queue->qp,
 				queue->cm_id->port_num, &rsp->read_cqe, NULL))
 			nvmet_req_complete(&rsp->req, NVME_SC_DATA_XFER_ERROR);
 	} else {
@@ -1020,6 +1021,7 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 		pr_err("failed to create_qp ret= %d\n", ret);
 		goto err_destroy_cq;
 	}
+	queue->qp = queue->cm_id->qp;
 
 	atomic_set(&queue->sq_wr_avail, qp_attr.cap.max_send_wr);
 
@@ -1048,11 +1050,10 @@ err_destroy_cq:
 
 static void nvmet_rdma_destroy_queue_ib(struct nvmet_rdma_queue *queue)
 {
-	struct ib_qp *qp = queue->cm_id->qp;
-
-	ib_drain_qp(qp);
-	rdma_destroy_id(queue->cm_id);
-	ib_destroy_qp(qp);
+	ib_drain_qp(queue->qp);
+	if (queue->cm_id)
+		rdma_destroy_id(queue->cm_id);
+	ib_destroy_qp(queue->qp);
 	ib_free_cq(queue->cq);
 }
 
@@ -1286,9 +1287,12 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
 	if (ret) {
-		schedule_work(&queue->release_work);
-		/* Destroying rdma_cm id is not needed here */
-		return 0;
+		/*
+		 * Don't destroy the cm_id in free path, as we implicitly
+		 * destroy the cm_id here with non-zero ret code.
+		 */
+		queue->cm_id = NULL;
+		goto free_queue;
 	}
 
 	mutex_lock(&nvmet_rdma_queue_mutex);
@@ -1297,6 +1301,8 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
 	return 0;
 
+free_queue:
+	nvmet_rdma_free_queue(queue);
 put_device:
 	kref_put(&ndev->ref, nvmet_rdma_free_dev);
 
-- 
2.25.1

