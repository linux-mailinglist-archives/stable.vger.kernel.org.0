Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E2226B71B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgIPARW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbgIOOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EFA22276;
        Tue, 15 Sep 2020 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179461;
        bh=O89Fn4tItlJ7HtW9Wnv3TR96ZERayPNj8C8t8ed4kNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0WCa8eCjKr6Wf+e7Gw0cuKAk974jT5DzAaseDzqxH+KJnQxh9wSRhxQHnAqhp12/
         HpIybTMtTcN/1BW2LcYXPigz6NbQqaR6cI2KQ7y5IFsHeQxl4nIDeSAZQVUWh2Hbxo
         eaCCNbgTFh5tpYuzEQ/ADZDCFoAZMrC4eAP3Y368=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/78] nvme-rdma: serialize controller teardown sequences
Date:   Tue, 15 Sep 2020 16:12:54 +0200
Message-Id: <20200915140635.042369627@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 5110f40241d08334375eb0495f174b1d2c07657e ]

In the timeout handler we may need to complete a request because the
request that timed out may be an I/O that is a part of a serial sequence
of controller teardown or initialization. In order to complete the
request, we need to fence any other context that may compete with us
and complete the request that is timing out.

In this case, we could have a potential double completion in case
a hard-irq or a different competing context triggered error recovery
and is running inflight request cancellation concurrently with the
timeout handler.

Protect using a ctrl teardown_lock to serialize contexts that may
complete a cancelled request due to error recovery or a reset.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f393a6193252e..7e2cdb17c26d8 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -118,6 +118,7 @@ struct nvme_rdma_ctrl {
 	struct sockaddr_storage src_addr;
 
 	struct nvme_ctrl	ctrl;
+	struct mutex		teardown_lock;
 	bool			use_inline_data;
 };
 
@@ -880,6 +881,7 @@ out_free_io_queues:
 static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&ctrl->teardown_lock);
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
 	if (ctrl->ctrl.admin_tagset)
@@ -887,11 +889,13 @@ static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 			nvme_cancel_request, &ctrl->ctrl);
 	blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_destroy_admin_queue(ctrl, remove);
+	mutex_unlock(&ctrl->teardown_lock);
 }
 
 static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&ctrl->teardown_lock);
 	if (ctrl->ctrl.queue_count > 1) {
 		nvme_stop_queues(&ctrl->ctrl);
 		nvme_rdma_stop_io_queues(ctrl);
@@ -902,6 +906,7 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 			nvme_start_queues(&ctrl->ctrl);
 		nvme_rdma_destroy_io_queues(ctrl, remove);
 	}
+	mutex_unlock(&ctrl->teardown_lock);
 }
 
 static void nvme_rdma_stop_ctrl(struct nvme_ctrl *nctrl)
@@ -1955,6 +1960,7 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	ctrl->ctrl.opts = opts;
 	INIT_LIST_HEAD(&ctrl->list);
+	mutex_init(&ctrl->teardown_lock);
 
 	if (opts->mask & NVMF_OPT_TRSVCID)
 		port = opts->trsvcid;
-- 
2.25.1



