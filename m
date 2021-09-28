Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140CF41A819
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhI1GBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239414AbhI1F7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D2F61355;
        Tue, 28 Sep 2021 05:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808619;
        bh=LaPhhaG2mgWAOD536dC8UsWFYqdgZk4J9qczTJSWNj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuO04GjDdn0vHHNmptxobbCERSwYBxwfR+YjRA7pFnZs81sm60hd6izlDa5WrD+Hf
         WpNGp2h6kBMViCrVQFRdmbWs2RaWR/8BU1Sp9u0bxu1317ObJ+C9E16MdntxJYsig8
         iZGyS4ZwbjX1Lo8JgzmYRzc7vRm+TSx1Vsg9le0DssUDveAeHP9gUpkWFyC5POFrg3
         tsq22d4hzq8yT9J74Hwh8PQLag7XbZEVtX7/nWwCjJLX6nKWPnY+cuzip34UwbGtQD
         MteVUvD7mP0Wuunq4mP+KsU60+lzmbgdS287mKY9c0FIZ4XFSrntp8H4Yw7Z7Y+rV4
         C4DjI4FIfElCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        kbusch@kernel.org, axboe@fb.com, Christoph@vger.kernel.org,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 18/23] nvme-fc: avoid race between time out and tear down
Date:   Tue, 28 Sep 2021 01:56:39 -0400
Message-Id: <20210928055645.172544-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e5445dae29d25d7b03e0a10d3d4277a1d0c8119b ]

To avoid race between time out and tear down, in tear down process,
first we quiesce the queue, and then delete the timer and cancel
the time out work for the queue.

This patch merges the admin and io sync ops into the queue teardown logic
as shown in the RDMA patch 3017013dcc "nvme-rdma: avoid race between time
out and tear down". There is no teardown_lock in nvme-fc.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Tested-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 86c6862e71a1..906cab35afe7 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2486,6 +2486,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 */
 	if (ctrl->ctrl.queue_count > 1) {
 		nvme_stop_queues(&ctrl->ctrl);
+		nvme_sync_io_queues(&ctrl->ctrl);
 		blk_mq_tagset_busy_iter(&ctrl->tag_set,
 				nvme_fc_terminate_exchange, &ctrl->ctrl);
 		blk_mq_tagset_wait_completed_request(&ctrl->tag_set);
@@ -2509,6 +2510,7 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 	 * clean up the admin queue. Same thing as above.
 	 */
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
+	blk_sync_queue(ctrl->ctrl.admin_q);
 	blk_mq_tagset_busy_iter(&ctrl->admin_tag_set,
 				nvme_fc_terminate_exchange, &ctrl->ctrl);
 	blk_mq_tagset_wait_completed_request(&ctrl->admin_tag_set);
-- 
2.33.0

