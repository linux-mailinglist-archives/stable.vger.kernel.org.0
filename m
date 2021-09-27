Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05ED419B1A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhI0RP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237211AbhI0ROS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CEA06120A;
        Mon, 27 Sep 2021 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762596;
        bh=r4sGwmZ+mODVLpYW1XCqU/3WO2LAP1lJhkKO6xSnhv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMJa1tQ44G7LZH3IeA9DLaq6rzvckoxe/vkkNU7LIRVW5vV4OymAZnoDV6V+sQAJl
         7xbKp/TLDPBNd7wbzBtg7M3Ccxv0WOWkmuselkAASO0eYg0npJYJxLmcE+0Y657pXt
         Ek9XEThz2EtdW08Owgp9sh3sgUPmAjXYCFIB7nY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruozhu Li <liruozhu@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/103] nvme-rdma: destroy cm id before destroy qp to avoid use after free
Date:   Mon, 27 Sep 2021 19:02:55 +0200
Message-Id: <20210927170228.637910808@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 9c356be7f016..51f4647ea214 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -655,8 +655,8 @@ static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
 	if (!test_and_clear_bit(NVME_RDMA_Q_ALLOCATED, &queue->flags))
 		return;
 
-	nvme_rdma_destroy_queue_ib(queue);
 	rdma_destroy_id(queue->cm_id);
+	nvme_rdma_destroy_queue_ib(queue);
 	mutex_destroy(&queue->queue_lock);
 }
 
@@ -1823,14 +1823,10 @@ static int nvme_rdma_conn_established(struct nvme_rdma_queue *queue)
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
@@ -1924,14 +1920,10 @@ static int nvme_rdma_route_resolved(struct nvme_rdma_queue *queue)
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
@@ -1962,8 +1954,6 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
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



