Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEBD27C83F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgI2MAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730581AbgI2Lky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333972074A;
        Tue, 29 Sep 2020 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379642;
        bh=X1fbTCMHDUEOMtauXEHeNTfiD+8wCfxilNJnslZzrcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPBcPTD9vhi/bXpbj8/pHY8sQ59kap7rppDhG4z6/jKq7VlnthyQZXMdfoeh/sUhA
         jTMpVoP+an2LjOoaGfXuskJi+YwlHhACIYzjNaR3tl1ZLfLNcCtDN8H5iDhPdWZKyO
         nLXyo31FWaScK7NhSP8poL/MEKwnddwGbwGNWpPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/388] nvmet-rdma: fix double free of rdma queue
Date:   Tue, 29 Sep 2020 12:59:15 +0200
Message-Id: <20200929110021.321900782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 36d906a7f70d3..b5314164479e9 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -75,6 +75,7 @@ enum nvmet_rdma_queue_state {
 
 struct nvmet_rdma_queue {
 	struct rdma_cm_id	*cm_id;
+	struct ib_qp		*qp;
 	struct nvmet_port	*port;
 	struct ib_cq		*cq;
 	atomic_t		sq_wr_avail;
@@ -464,7 +465,7 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 	if (ndev->srq)
 		ret = ib_post_srq_recv(ndev->srq, &cmd->wr, NULL);
 	else
-		ret = ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, NULL);
+		ret = ib_post_recv(cmd->queue->qp, &cmd->wr, NULL);
 
 	if (unlikely(ret))
 		pr_err("post_recv cmd failed\n");
@@ -503,7 +504,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	atomic_add(1 + rsp->n_rdma, &queue->sq_wr_avail);
 
 	if (rsp->n_rdma) {
-		rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
+		rdma_rw_ctx_destroy(&rsp->rw, queue->qp,
 				queue->cm_id->port_num, rsp->req.sg,
 				rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
 	}
@@ -587,7 +588,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	WARN_ON(rsp->n_rdma <= 0);
 	atomic_add(rsp->n_rdma, &queue->sq_wr_avail);
-	rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
+	rdma_rw_ctx_destroy(&rsp->rw, queue->qp,
 			queue->cm_id->port_num, rsp->req.sg,
 			rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
 	rsp->n_rdma = 0;
@@ -742,7 +743,7 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 	}
 
 	if (nvmet_rdma_need_data_in(rsp)) {
-		if (rdma_rw_ctx_post(&rsp->rw, queue->cm_id->qp,
+		if (rdma_rw_ctx_post(&rsp->rw, queue->qp,
 				queue->cm_id->port_num, &rsp->read_cqe, NULL))
 			nvmet_req_complete(&rsp->req, NVME_SC_DATA_XFER_ERROR);
 	} else {
@@ -1025,6 +1026,7 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 		pr_err("failed to create_qp ret= %d\n", ret);
 		goto err_destroy_cq;
 	}
+	queue->qp = queue->cm_id->qp;
 
 	atomic_set(&queue->sq_wr_avail, qp_attr.cap.max_send_wr);
 
@@ -1053,11 +1055,10 @@ err_destroy_cq:
 
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
 
@@ -1291,9 +1292,12 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
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
@@ -1302,6 +1306,8 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
 	return 0;
 
+free_queue:
+	nvmet_rdma_free_queue(queue);
 put_device:
 	kref_put(&ndev->ref, nvmet_rdma_free_dev);
 
-- 
2.25.1



