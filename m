Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B983F26B43F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIOXU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbgIOOiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93E722464;
        Tue, 15 Sep 2020 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180127;
        bh=K8NWduBVmg9YF1y4rdiDDnwQjVvnRrBoGIGBUbtMHzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EISeML9zmG+zv5EdkuW2NQr71+YIJdIAmPHBJnVSWuTyDcPwPFojcNJpIRjywZIiD
         kASZud7tHMKmk/sljFInzYx4ObvAyViWuuXWUGgWdQkZFAIxNtof1aS9qsMrPEjysU
         W4JAY5KYVsVYa5GZDocVPkVjy+f+ir/tJdbZdudo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 090/177] nvme-rdma: fix timeout handler
Date:   Tue, 15 Sep 2020 16:12:41 +0200
Message-Id: <20200915140657.956665969@linuxfoundation.org>
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

[ Upstream commit 0475a8dcbcee92a5d22e40c9c6353829fc6294b8 ]

When a request times out in a LIVE state, we simply trigger error
recovery and let the error recovery handle the request cancellation,
however when a request times out in a non LIVE state, we make sure to
complete it immediately as it might block controller setup or teardown
and prevent forward progress.

However tearing down the entire set of I/O and admin queues causes
freeze/unfreeze imbalance (q->mq_freeze_depth) because and is really
an overkill to what we actually need, which is to just fence controller
teardown that may be running, stop the queue, and cancel the request if
it is not already completed.

Now that we have the controller teardown_lock, we can safely serialize
request cancellation. This addresses a hang caused by calling extra
queue freeze on controller namespaces, causing unfreeze to not complete
correctly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 49 +++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ffe83d1f576bf..99bf88eb812c5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1159,6 +1159,7 @@ static void nvme_rdma_error_recovery(struct nvme_rdma_ctrl *ctrl)
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_RESETTING))
 		return;
 
+	dev_warn(ctrl->ctrl.device, "starting error recovery\n");
 	queue_work(nvme_reset_wq, &ctrl->err_work);
 }
 
@@ -1925,6 +1926,22 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 	return 0;
 }
 
+static void nvme_rdma_complete_timed_out(struct request *rq)
+{
+	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_rdma_queue *queue = req->queue;
+	struct nvme_rdma_ctrl *ctrl = queue->ctrl;
+
+	/* fence other contexts that may complete the command */
+	mutex_lock(&ctrl->teardown_lock);
+	nvme_rdma_stop_queue(queue);
+	if (!blk_mq_request_completed(rq)) {
+		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
+		blk_mq_complete_request(rq);
+	}
+	mutex_unlock(&ctrl->teardown_lock);
+}
+
 static enum blk_eh_timer_return
 nvme_rdma_timeout(struct request *rq, bool reserved)
 {
@@ -1935,29 +1952,29 @@ nvme_rdma_timeout(struct request *rq, bool reserved)
 	dev_warn(ctrl->ctrl.device, "I/O %d QID %d timeout\n",
 		 rq->tag, nvme_rdma_queue_idx(queue));
 
-	/*
-	 * Restart the timer if a controller reset is already scheduled. Any
-	 * timed out commands would be handled before entering the connecting
-	 * state.
-	 */
-	if (ctrl->ctrl.state == NVME_CTRL_RESETTING)
-		return BLK_EH_RESET_TIMER;
-
 	if (ctrl->ctrl.state != NVME_CTRL_LIVE) {
 		/*
-		 * Teardown immediately if controller times out while starting
-		 * or we are already started error recovery. all outstanding
-		 * requests are completed on shutdown, so we return BLK_EH_DONE.
+		 * If we are resetting, connecting or deleting we should
+		 * complete immediately because we may block controller
+		 * teardown or setup sequence
+		 * - ctrl disable/shutdown fabrics requests
+		 * - connect requests
+		 * - initialization admin requests
+		 * - I/O requests that entered after unquiescing and
+		 *   the controller stopped responding
+		 *
+		 * All other requests should be cancelled by the error
+		 * recovery work, so it's fine that we fail it here.
 		 */
-		flush_work(&ctrl->err_work);
-		nvme_rdma_teardown_io_queues(ctrl, false);
-		nvme_rdma_teardown_admin_queue(ctrl, false);
+		nvme_rdma_complete_timed_out(rq);
 		return BLK_EH_DONE;
 	}
 
-	dev_warn(ctrl->ctrl.device, "starting error recovery\n");
+	/*
+	 * LIVE state should trigger the normal error recovery which will
+	 * handle completing this request.
+	 */
 	nvme_rdma_error_recovery(ctrl);
-
 	return BLK_EH_RESET_TIMER;
 }
 
-- 
2.25.1



