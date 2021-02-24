Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E04323DA2
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhBXNOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235764AbhBXNGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:06:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B64B64F8B;
        Wed, 24 Feb 2021 12:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171256;
        bh=vOaq+XCE08cfBU4HxzIJMSbb7MRGJapuX0It14Owib8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bM9KxqRA6z2m0ZU2EeSassWWuusTb9tgBUXiQsRknFSg+4GZSTGitCmSfehsvpR2W
         lLODVM9gRaoE40szPo3RIHg535Bec30yHNkMud2BdTYRoNy33JuXh2bHXbkfhPV3u5
         J7P0r4fROgDlODpSsiFP4i2J4gR1NPDIubMj9g7DR+TGte22cL/KeWIjKtbjW5vcr9
         +bsgSTVlM9Uwu/k9XsztyBBXru6H3C92mDLrnhpmqC+YsKz7SaANMy5yKg36mOrq3l
         jSE8ydG0CkMWObtn1gw+a+DD+eWQ1pLNl0V3QKolUvzf0qbRtZ7BAfM6KEp+TbX1Si
         jkcwfqrn/Fd+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Leng <lengchao@huawei.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 27/40] nvme-rdma: add clean action for failed reconnection
Date:   Wed, 24 Feb 2021 07:53:27 -0500
Message-Id: <20210224125340.483162-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 958dc1d32c80566f58d18f05ef1f05bd32d172c1 ]

A crash happens when inject failed reconnection.
If reconnect failed after start io queues, the queues will be unquiesced
and new requests continue to be delivered. Reconnection error handling
process directly free queues without cancel suspend requests. The
suppend request will time out, and then crash due to use the queue
after free.

Add sync queues and cancel suppend requests for reconnection error
handling.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 8a62c2fe5a5ec..da60300104322 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -835,12 +835,16 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 
 	error = nvme_init_identify(&ctrl->ctrl);
 	if (error)
-		goto out_stop_queue;
+		goto out_quiesce_queue;
 
 	return 0;
 
+out_quiesce_queue:
+	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
+	blk_sync_queue(ctrl->ctrl.admin_q);
 out_stop_queue:
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
+	nvme_cancel_admin_tagset(&ctrl->ctrl);
 out_cleanup_queue:
 	if (new)
 		blk_cleanup_queue(ctrl->ctrl.admin_q);
@@ -917,8 +921,10 @@ static int nvme_rdma_configure_io_queues(struct nvme_rdma_ctrl *ctrl, bool new)
 
 out_wait_freeze_timed_out:
 	nvme_stop_queues(&ctrl->ctrl);
+	nvme_sync_io_queues(&ctrl->ctrl);
 	nvme_rdma_stop_io_queues(ctrl);
 out_cleanup_connect_q:
+	nvme_cancel_tagset(&ctrl->ctrl);
 	if (new)
 		blk_cleanup_queue(ctrl->ctrl.connect_q);
 out_free_tag_set:
@@ -1054,10 +1060,18 @@ static int nvme_rdma_setup_ctrl(struct nvme_rdma_ctrl *ctrl, bool new)
 	return 0;
 
 destroy_io:
-	if (ctrl->ctrl.queue_count > 1)
+	if (ctrl->ctrl.queue_count > 1) {
+		nvme_stop_queues(&ctrl->ctrl);
+		nvme_sync_io_queues(&ctrl->ctrl);
+		nvme_rdma_stop_io_queues(ctrl);
+		nvme_cancel_tagset(&ctrl->ctrl);
 		nvme_rdma_destroy_io_queues(ctrl, new);
+	}
 destroy_admin:
+	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
+	blk_sync_queue(ctrl->ctrl.admin_q);
 	nvme_rdma_stop_queue(&ctrl->queues[0]);
+	nvme_cancel_admin_tagset(&ctrl->ctrl);
 	nvme_rdma_destroy_admin_queue(ctrl, new);
 	return ret;
 }
-- 
2.27.0

