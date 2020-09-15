Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D403326B442
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgIOXU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbgIOOiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 520F023C92;
        Tue, 15 Sep 2020 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180124;
        bh=VKBuCisHlskwOgkpWdnHwiTcBl55VZPIQLyXLbigodk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8+2vCpGmZEFYxPqLsmeCTReCe4K60sU4QAzjuycL4ePnCKE5EPllN5EUct0nyUBb
         RO7BP5GrYzZuu2uS17ibM7R0rG3qiF2XFucz9CVUDXoImphFOdg6wtwo4RYm+nhn/4
         y3dW9wNj0f3DRCK55WQXlwJiNkMzskeOWjfKxN6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 089/177] nvme-rdma: serialize controller teardown sequences
Date:   Tue, 15 Sep 2020 16:12:40 +0200
Message-Id: <20200915140657.908205503@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
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
index 876859cd14e86..ffe83d1f576bf 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -121,6 +121,7 @@ struct nvme_rdma_ctrl {
 	struct sockaddr_storage src_addr;
 
 	struct nvme_ctrl	ctrl;
+	struct mutex		teardown_lock;
 	bool			use_inline_data;
 	u32			io_queues[HCTX_MAX_TYPES];
 };
@@ -971,6 +972,7 @@ out_free_io_queues:
 static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&ctrl->teardown_lock);
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
 	if (ctrl->ctrl.admin_tagset) {
@@ -981,11 +983,13 @@ static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	if (remove)
 		blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_destroy_admin_queue(ctrl, remove);
+	mutex_unlock(&ctrl->teardown_lock);
 }
 
 static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&ctrl->teardown_lock);
 	if (ctrl->ctrl.queue_count > 1) {
 		nvme_start_freeze(&ctrl->ctrl);
 		nvme_stop_queues(&ctrl->ctrl);
@@ -999,6 +1003,7 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 			nvme_start_queues(&ctrl->ctrl);
 		nvme_rdma_destroy_io_queues(ctrl, remove);
 	}
+	mutex_unlock(&ctrl->teardown_lock);
 }
 
 static void nvme_rdma_free_ctrl(struct nvme_ctrl *nctrl)
@@ -2252,6 +2257,7 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	ctrl->ctrl.opts = opts;
 	INIT_LIST_HEAD(&ctrl->list);
+	mutex_init(&ctrl->teardown_lock);
 
 	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
 		opts->trsvcid =
-- 
2.25.1



