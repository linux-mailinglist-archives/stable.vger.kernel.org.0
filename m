Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8246C26DBB
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfEVToI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfEVT2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A442A20879;
        Wed, 22 May 2019 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553291;
        bh=jZ+X0Yw18m7pNOc9/c4Mc844Bw9q2y3onV4lI9dQdoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2del14ycAXhxXEYHneXxcVm/v9z+0UFrnsFy7peOfWn5cKOAsLVIO8bxLexrcAmS
         M/t//5dIX0p+ukUcMQGJ47J0zslGOMPSFi6Xk3UJR4S35ClEpVkUeKuS8C1kyGVBlv
         cTnKcUkFgx460uwI8UznsEQ4ZZC53+A4egn/35d4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 063/244] nvme-rdma: fix a NULL deref when an admin connect times out
Date:   Wed, 22 May 2019 15:23:29 -0400
Message-Id: <20190522192630.24917-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 1007709d7d06fab09bf2d007657575958676282b ]

If we timeout the admin startup sequence we might not yet have
an I/O tagset allocated which causes the teardown sequence to crash.
Make nvme_tcp_teardown_io_queues safe by not iterating inflight tags
if the tagset wasn't allocated.

Fixes: 4c174e636674 ("nvme-rdma: fix timeout handler")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 0939a4e178fb9..e4f167e35353f 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -880,8 +880,9 @@ static void nvme_rdma_teardown_admin_queue(struct nvme_rdma_ctrl *ctrl,
 {
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
-	blk_mq_tagset_busy_iter(&ctrl->admin_tag_set, nvme_cancel_request,
-			&ctrl->ctrl);
+	if (ctrl->ctrl.admin_tagset)
+		blk_mq_tagset_busy_iter(ctrl->ctrl.admin_tagset,
+			nvme_cancel_request, &ctrl->ctrl);
 	blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_destroy_admin_queue(ctrl, remove);
 }
@@ -892,8 +893,9 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 	if (ctrl->ctrl.queue_count > 1) {
 		nvme_stop_queues(&ctrl->ctrl);
 		nvme_rdma_stop_io_queues(ctrl);
-		blk_mq_tagset_busy_iter(&ctrl->tag_set, nvme_cancel_request,
-				&ctrl->ctrl);
+		if (ctrl->ctrl.tagset)
+			blk_mq_tagset_busy_iter(ctrl->ctrl.tagset,
+				nvme_cancel_request, &ctrl->ctrl);
 		if (remove)
 			nvme_start_queues(&ctrl->ctrl);
 		nvme_rdma_destroy_io_queues(ctrl, remove);
-- 
2.20.1

