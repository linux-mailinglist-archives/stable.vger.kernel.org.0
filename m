Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701C22FA31E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbhAROb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390715AbhARLoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A85E822D5B;
        Mon, 18 Jan 2021 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970220;
        bh=EjGNnS50natGBkIa2TTFogr5F7Cron9uqr8pY0Zl1LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHUFD1XRZ3FxfYrkdMlnPvGtWfv9FcpCgxu8aa0bTGcKPGZLVMh6514GGIDu8KUPF
         gvEebyAEmwqOyyHndMpG87H6xiphVxfOksj0jPrKGMNI0k7hOjTVzsifnSaxlcqO8W
         GA9uF5sWEH/6mba/30NUOU8EoJjops7rZkHpF7sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/152] nvmet-rdma: Fix list_del corruption on queue establishment failure
Date:   Mon, 18 Jan 2021 12:34:22 +0100
Message-Id: <20210118113356.931095223@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit 9ceb7863537748c67fa43ac4f2f565819bbd36e4 ]

When a queue is in NVMET_RDMA_Q_CONNECTING state, it may has some
requests at rsp_wait_list. In case a disconnect occurs at this
state, no one will empty this list and will return the requests to
free_rsps list. Normally nvmet_rdma_queue_established() free those
requests after moving the queue to NVMET_RDMA_Q_LIVE state, but in
this case __nvmet_rdma_queue_disconnect() is called before. The
crash happens at nvmet_rdma_free_rsps() when calling
list_del(&rsp->free_list), because the request exists only at
the wait list. To fix the issue, simply clear rsp_wait_list when
destroying the queue.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 5c1e7cb7fe0de..bdfc22eb2a10f 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1641,6 +1641,16 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 	spin_lock_irqsave(&queue->state_lock, flags);
 	switch (queue->state) {
 	case NVMET_RDMA_Q_CONNECTING:
+		while (!list_empty(&queue->rsp_wait_list)) {
+			struct nvmet_rdma_rsp *rsp;
+
+			rsp = list_first_entry(&queue->rsp_wait_list,
+					       struct nvmet_rdma_rsp,
+					       wait_list);
+			list_del(&rsp->wait_list);
+			nvmet_rdma_put_rsp(rsp);
+		}
+		fallthrough;
 	case NVMET_RDMA_Q_LIVE:
 		queue->state = NVMET_RDMA_Q_DISCONNECTING;
 		disconnect = true;
-- 
2.27.0



