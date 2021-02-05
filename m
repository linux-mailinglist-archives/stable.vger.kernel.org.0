Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B005310EED
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhBEP7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhBEP4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:56:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6EC6500E;
        Fri,  5 Feb 2021 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534242;
        bh=Ixe1IrcUEoJM1p5rTzlKBeGcxGEEU9dOYQvJdnCib4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKk/bdA/ZQ3BiwnCGvYdC9iUmLNXrpbrn96IPfWCWGcFtBKIDL6XLrYGy+PrLD6RZ
         qvPK0JkRqstHMu4HexvlwA9OmZo/OtzVBaDDl20k9/n2BmGeD6/H0RRPTGwDpvoxVl
         4wNhd+ITnBqX2bzqg9mVsjShAA85glK87Dgznr9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/57] nvme-rdma: avoid request double completion for concurrent nvme_rdma_timeout
Date:   Fri,  5 Feb 2021 15:07:06 +0100
Message-Id: <20210205140657.694285324@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 7674073b2ed35ac951a49c425dec6b39d5a57140 ]

A crash happens when inject completing request long time(nearly 30s).
Each name space has a request queue, when inject completing request long
time, multi request queues may have time out requests at the same time,
nvme_rdma_timeout will execute concurrently. Multi requests in different
request queues may be queued in the same rdma queue, multi
nvme_rdma_timeout may call nvme_rdma_stop_queue at the same time.
The first nvme_rdma_timeout will clear NVME_RDMA_Q_LIVE and continue
stopping the rdma queue(drain qp), but the others check NVME_RDMA_Q_LIVE
is already cleared, and then directly complete the requests, complete
request before the qp is fully drained may lead to a use-after-free
condition.

Add a multex lock to serialize nvme_rdma_stop_queue.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Tested-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 65e3d0ef36e1a..493ed7ba86ed2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -97,6 +97,7 @@ struct nvme_rdma_queue {
 	struct completion	cm_done;
 	bool			pi_support;
 	int			cq_size;
+	struct mutex		queue_lock;
 };
 
 struct nvme_rdma_ctrl {
@@ -579,6 +580,7 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 	int ret;
 
 	queue = &ctrl->queues[idx];
+	mutex_init(&queue->queue_lock);
 	queue->ctrl = ctrl;
 	if (idx && ctrl->ctrl.max_integrity_segments)
 		queue->pi_support = true;
@@ -598,7 +600,8 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 	if (IS_ERR(queue->cm_id)) {
 		dev_info(ctrl->ctrl.device,
 			"failed to create CM ID: %ld\n", PTR_ERR(queue->cm_id));
-		return PTR_ERR(queue->cm_id);
+		ret = PTR_ERR(queue->cm_id);
+		goto out_destroy_mutex;
 	}
 
 	if (ctrl->ctrl.opts->mask & NVMF_OPT_HOST_TRADDR)
@@ -628,6 +631,8 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 out_destroy_cm_id:
 	rdma_destroy_id(queue->cm_id);
 	nvme_rdma_destroy_queue_ib(queue);
+out_destroy_mutex:
+	mutex_destroy(&queue->queue_lock);
 	return ret;
 }
 
@@ -639,9 +644,10 @@ static void __nvme_rdma_stop_queue(struct nvme_rdma_queue *queue)
 
 static void nvme_rdma_stop_queue(struct nvme_rdma_queue *queue)
 {
-	if (!test_and_clear_bit(NVME_RDMA_Q_LIVE, &queue->flags))
-		return;
-	__nvme_rdma_stop_queue(queue);
+	mutex_lock(&queue->queue_lock);
+	if (test_and_clear_bit(NVME_RDMA_Q_LIVE, &queue->flags))
+		__nvme_rdma_stop_queue(queue);
+	mutex_unlock(&queue->queue_lock);
 }
 
 static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
@@ -651,6 +657,7 @@ static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
 
 	nvme_rdma_destroy_queue_ib(queue);
 	rdma_destroy_id(queue->cm_id);
+	mutex_destroy(&queue->queue_lock);
 }
 
 static void nvme_rdma_free_io_queues(struct nvme_rdma_ctrl *ctrl)
-- 
2.27.0



