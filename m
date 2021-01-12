Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8CF2F30B8
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbhALNK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404644AbhALM6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C610239D3;
        Tue, 12 Jan 2021 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456237;
        bh=PNvCOCoAo5+jSAER09jlgMZlmQEfKisVJhvtTf9R3O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfuN/le5/vlA/DvHpg8tQ3aQa4Bvlf1G2iYBMSKgVQmx+b4ttW8xltECdcWxVh9kR
         VD1WvOimuSVdMwd87PiHdJLrD8uO7Rh/uNBJV7pd+r3p8K6bIxg2NGRplz9QctcSw/
         RHvDblns/xRMa9q5lSNohgZh8UkmG1lTF0WxRG80ckskdGvUFLK+901ZR5AymgWYAl
         IjwtazINfb73QVkPJVfhOorWSWQ0ccweCpuu1isu2q88elPg8xv1zSpod8XJ4PGmuq
         db59yqHEy27zG5LKjDDiBBnyAnnN6Mf7jbPOE6x/zfS86tYmzL/tIppoi6BxvwPnXk
         Evkgpl6vr7KAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 23/28] nvmet-rdma: Fix list_del corruption on queue establishment failure
Date:   Tue, 12 Jan 2021 07:56:39 -0500
Message-Id: <20210112125645.70739-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b5314164479e9..50e2007092bc0 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1351,6 +1351,16 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
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

