Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC82600E5
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgIGQzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbgIGQeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D7521D6C;
        Mon,  7 Sep 2020 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496443;
        bh=B5OVwQIeyAi5G22VgL14NsKOtn8vzMmMXrRIxMXsPJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHXZ38Bm31GbtvClWP2y+GCI+ew6AZjHTpEow8F7JBZolZflZ8lxQIN2u54+10V/7
         D3Jo1OEp5rX/FMNxpphCcqmos+mYPS/aRJcnbSWiuzYbrAKXWMzfM78beKkrqm4iss
         sacYcnfiS6EWdBiWN8LQiI6GtmBsVn4VmtH26LKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 26/43] nvme-rdma: serialize controller teardown sequences
Date:   Mon,  7 Sep 2020 12:33:12 -0400
Message-Id: <20200907163329.1280888-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d0336545e1fe0..b164c662fed30 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -110,6 +110,7 @@ struct nvme_rdma_ctrl {
 	struct sockaddr_storage src_addr;
 
 	struct nvme_ctrl	ctrl;
+	struct mutex		teardown_lock;
 	bool			use_inline_data;
 	u32			io_queues[HCTX_MAX_TYPES];
 };
@@ -920,6 +921,7 @@ static int nvme_rdma_configure_io_queues(struct nvme_rdma_ctrl *ctrl, bool new)
 static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&ctrl->teardown_lock);
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
 	if (ctrl->ctrl.admin_tagset) {
@@ -930,11 +932,13 @@ static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
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
@@ -948,6 +952,7 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 			nvme_start_queues(&ctrl->ctrl);
 		nvme_rdma_destroy_io_queues(ctrl, remove);
 	}
+	mutex_unlock(&ctrl->teardown_lock);
 }
 
 static void nvme_rdma_free_ctrl(struct nvme_ctrl *nctrl)
@@ -1988,6 +1993,7 @@ static struct nvme_ctrl *nvme_rdma_create_ctrl(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	ctrl->ctrl.opts = opts;
 	INIT_LIST_HEAD(&ctrl->list);
+	mutex_init(&ctrl->teardown_lock);
 
 	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
 		opts->trsvcid =
-- 
2.25.1

