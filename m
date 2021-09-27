Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D263419CCE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhI0Rc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238699AbhI0RaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A0160F3A;
        Mon, 27 Sep 2021 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763081;
        bh=Ixvjd/g6Oa1T/tgj7QZQCeD2Fi27lJOPX8R02O1CA+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFR4xMFlzsqWfc3WWMWXfCbqVLs7hHXvp4zObLMP8iTNihTUKRj3o1HFMr8YoY9h+
         TOFyL062osMGEKntiOYMcg/D5GJAS2g6qi51mkZGK2824P5Z0NfvXEELVnFl1fMNfZ
         c0BK13ZDMyh2XxDif7XCNFwhbXtWJNP2z9XT3wu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruozhu Li <liruozhu@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/162] nvme-rdma: destroy cm id before destroy qp to avoid use after free
Date:   Mon, 27 Sep 2021 19:02:54 +0200
Message-Id: <20210927170237.862703782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruozhu Li <liruozhu@huawei.com>

[ Upstream commit 9817d763dbe15327b9b3ff4404fa6f27f927e744 ]

We should always destroy cm_id before destroy qp to avoid to get cma
event after qp was destroyed, which may lead to use after free.
In RDMA connection establishment error flow, don't destroy qp in cm
event handler.Just report cm_error to upper level, qp will be destroy
in nvme_rdma_alloc_queue() after destroy cm id.

Signed-off-by: Ruozhu Li <liruozhu@huawei.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a68704e39084..042c594bc57e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -656,8 +656,8 @@ static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
 	if (!test_and_clear_bit(NVME_RDMA_Q_ALLOCATED, &queue->flags))
 		return;
 
-	nvme_rdma_destroy_queue_ib(queue);
 	rdma_destroy_id(queue->cm_id);
+	nvme_rdma_destroy_queue_ib(queue);
 	mutex_destroy(&queue->queue_lock);
 }
 
@@ -1815,14 +1815,10 @@ static int nvme_rdma_conn_established(struct nvme_rdma_queue *queue)
 	for (i = 0; i < queue->queue_size; i++) {
 		ret = nvme_rdma_post_recv(queue, &queue->rsp_ring[i]);
 		if (ret)
-			goto out_destroy_queue_ib;
+			return ret;
 	}
 
 	return 0;
-
-out_destroy_queue_ib:
-	nvme_rdma_destroy_queue_ib(queue);
-	return ret;
 }
 
 static int nvme_rdma_conn_rejected(struct nvme_rdma_queue *queue,
@@ -1916,14 +1912,10 @@ static int nvme_rdma_route_resolved(struct nvme_rdma_queue *queue)
 	if (ret) {
 		dev_err(ctrl->ctrl.device,
 			"rdma_connect_locked failed (%d).\n", ret);
-		goto out_destroy_queue_ib;
+		return ret;
 	}
 
 	return 0;
-
-out_destroy_queue_ib:
-	nvme_rdma_destroy_queue_ib(queue);
-	return ret;
 }
 
 static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
@@ -1954,8 +1946,6 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	case RDMA_CM_EVENT_UNREACHABLE:
-		nvme_rdma_destroy_queue_ib(queue);
-		fallthrough;
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		dev_dbg(queue->ctrl->ctrl.device,
 			"CM error event %d\n", ev->event);
-- 
2.33.0



