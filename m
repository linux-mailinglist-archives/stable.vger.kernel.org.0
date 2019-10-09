Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6BD1588
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbfJIRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732055AbfJIRX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:59 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19C8D2196E;
        Wed,  9 Oct 2019 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641839;
        bh=RbW/Ro+spT/qRFap2ebndlzW46XRVhfTR2zROlgJvMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHx6dJXcJnUUsqfca649/TIeMri90G8CJvBxXZgjqYi9PAi/10mzYYn3jio9Qs3f5
         XBcvsAlbLRD/XCCl6sadMqZUJef2j8h9IQXKiiICGC1Etcc2LVl5/a7qZj+iSN+nK1
         vctu9gfoWK6+Xz8Me1iKp4lr0qpxD7gmtHUG7xB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 21/68] nvme-rdma: Fix max_hw_sectors calculation
Date:   Wed,  9 Oct 2019 13:05:00 -0400
Message-Id: <20191009170547.32204-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit ff13c1b87c97275b82b2af99044b4abf6861b28f ]

By default, the NVMe/RDMA driver should support max io_size of 1MiB (or
upto the maximum supported size by the HCA). Currently, one will see that
/sys/class/block/<bdev>/queue/max_hw_sectors_kb is 1020 instead of 1024.

A non power of 2 value can cause performance degradation due to
unnecessary splitting of IO requests and unoptimized allocation units.

The number of pages per MR has been fixed here, so there is no longer any
need to reduce max_sectors by 1.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 1a6449bc547b9..cc1956349a2af 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -427,7 +427,7 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 static int nvme_rdma_get_max_fr_pages(struct ib_device *ibdev)
 {
 	return min_t(u32, NVME_RDMA_MAX_SEGMENTS,
-		     ibdev->attrs.max_fast_reg_page_list_len);
+		     ibdev->attrs.max_fast_reg_page_list_len - 1);
 }
 
 static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
@@ -437,7 +437,7 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	const int cq_factor = send_wr_factor + 1;	/* + RECV */
 	int comp_vector, idx = nvme_rdma_queue_idx(queue);
 	enum ib_poll_context poll_ctx;
-	int ret;
+	int ret, pages_per_mr;
 
 	queue->device = nvme_rdma_find_get_device(queue->cm_id);
 	if (!queue->device) {
@@ -479,10 +479,16 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 		goto out_destroy_qp;
 	}
 
+	/*
+	 * Currently we don't use SG_GAPS MR's so if the first entry is
+	 * misaligned we'll end up using two entries for a single data page,
+	 * so one additional entry is required.
+	 */
+	pages_per_mr = nvme_rdma_get_max_fr_pages(ibdev) + 1;
 	ret = ib_mr_pool_init(queue->qp, &queue->qp->rdma_mrs,
 			      queue->queue_size,
 			      IB_MR_TYPE_MEM_REG,
-			      nvme_rdma_get_max_fr_pages(ibdev), 0);
+			      pages_per_mr, 0);
 	if (ret) {
 		dev_err(queue->ctrl->ctrl.device,
 			"failed to initialize MR pool sized %d for QID %d\n",
@@ -824,8 +830,8 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	if (error)
 		goto out_stop_queue;
 
-	ctrl->ctrl.max_hw_sectors =
-		(ctrl->max_fr_pages - 1) << (ilog2(SZ_4K) - 9);
+	ctrl->ctrl.max_segments = ctrl->max_fr_pages;
+	ctrl->ctrl.max_hw_sectors = ctrl->max_fr_pages << (ilog2(SZ_4K) - 9);
 
 	error = nvme_init_identify(&ctrl->ctrl);
 	if (error)
-- 
2.20.1

