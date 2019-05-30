Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1DD2F135
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfE3ELN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730831AbfE3DQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1621245AB;
        Thu, 30 May 2019 03:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186209;
        bh=8gmFneApekN9ZlPFMyd/kTDJxaFoNP2uENTznQ+zkHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3yPOEH9BnFzT0GpN2YNJJs5jXwoTwL75jEed8yr7kc4s83AlgoLP6lOXJJxkAC7X
         QbUOxhposcFeAp0dvzpCFSOkXTinKA7qxCWxUEztgc75Sw+R35UV1TvHA6psEK47UP
         2C3MqBW3u+HS8r+3RwoIwrGgui7CG4RLeIdVW/ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/276] nvme-rdma: fix a NULL deref when an admin connect times out
Date:   Wed, 29 May 2019 20:04:18 -0700
Message-Id: <20190530030532.361035251@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



