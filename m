Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528A26B68A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgIPAHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgIOO2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C56D2253A;
        Tue, 15 Sep 2020 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179638;
        bh=6b7jyqDgzjf/XlXCPAtkiF64G1ssZErU0QXenjYYtsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgcCs52crxAFPQLn18x0jfhcc9Wn+L8PMYJxu90zTYG16/nzyxR+CcsX6u48gOLip
         XfCKsc7KDPERwgFhdsRMlsoNH744l558LxIS5DcqxEwmfHbIB1pby+x1FFoqiCdvBz
         uyVdX3GE9eaipKv3cNi/j+75VLFWCYtUoMNyRop8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        James Smart <james.smart@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/132] nvme-rdma: fix timeout handler
Date:   Tue, 15 Sep 2020 16:12:40 +0200
Message-Id: <20200915140647.012285235@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
index b164c662fed30..4e73da2c45bb6 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1101,6 +1101,7 @@ static void nvme_rdma_error_recovery(struct nvme_rdma_ctrl *ctrl)
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_RESETTING))
 		return;
 
+	dev_warn(ctrl->ctrl.device, "starting error recovery\n");
 	queue_work(nvme_reset_wq, &ctrl->err_work);
 }
 
@@ -1704,6 +1705,22 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
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
@@ -1714,29 +1731,29 @@ nvme_rdma_timeout(struct request *rq, bool reserved)
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



