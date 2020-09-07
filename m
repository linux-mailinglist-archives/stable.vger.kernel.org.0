Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA725FF76
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgIGQdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgIGQdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C919D21897;
        Mon,  7 Sep 2020 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496380;
        bh=2p/t9dnfb8IB8c8f34rPsMaenMrvGi+vMteKncxt6/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWddUZQlVcQEiFe7k09NLAk+ZzuE0AOAYof4RoWwYnbAdaiLFlv1NSCX/DDxqva3s
         EQA8dM3I+XMPyxQ4170XMMN4RbeuyaeYJjUbex+YwoaDwpJfjKG8v+3m1LK4AJvr9p
         aXERXsl5UjJd/ruhpEGhe5SkqNAN2WD6oOxwIoU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 31/53] nvme-tcp: fix timeout handler
Date:   Mon,  7 Sep 2020 12:31:57 -0400
Message-Id: <20200907163220.1280412-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 236187c4ed195161dfa4237c7beffbba0c5ae45b ]

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

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 56 ++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d1e5b27675b1b..65a3bad778104 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -448,6 +448,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
 		return;
 
+	dev_warn(ctrl->device, "starting error recovery\n");
 	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
@@ -2125,40 +2126,55 @@ static void nvme_tcp_submit_async_event(struct nvme_ctrl *arg)
 	nvme_tcp_queue_request(&ctrl->async_req, true);
 }
 
+static void nvme_tcp_complete_timed_out(struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_ctrl *ctrl = &req->queue->ctrl->ctrl;
+
+	/* fence other contexts that may complete the command */
+	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
+	nvme_tcp_stop_queue(ctrl, nvme_tcp_queue_id(req->queue));
+	if (!blk_mq_request_completed(rq)) {
+		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
+		blk_mq_complete_request(rq);
+	}
+	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
+}
+
 static enum blk_eh_timer_return
 nvme_tcp_timeout(struct request *rq, bool reserved)
 {
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
-	struct nvme_tcp_ctrl *ctrl = req->queue->ctrl;
+	struct nvme_ctrl *ctrl = &req->queue->ctrl->ctrl;
 	struct nvme_tcp_cmd_pdu *pdu = req->pdu;
 
-	/*
-	 * Restart the timer if a controller reset is already scheduled. Any
-	 * timed out commands would be handled before entering the connecting
-	 * state.
-	 */
-	if (ctrl->ctrl.state == NVME_CTRL_RESETTING)
-		return BLK_EH_RESET_TIMER;
-
-	dev_warn(ctrl->ctrl.device,
+	dev_warn(ctrl->device,
 		"queue %d: timeout request %#x type %d\n",
 		nvme_tcp_queue_id(req->queue), rq->tag, pdu->hdr.type);
 
-	if (ctrl->ctrl.state != NVME_CTRL_LIVE) {
+	if (ctrl->state != NVME_CTRL_LIVE) {
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
-		nvme_tcp_teardown_io_queues(&ctrl->ctrl, false);
-		nvme_tcp_teardown_admin_queue(&ctrl->ctrl, false);
+		nvme_tcp_complete_timed_out(rq);
 		return BLK_EH_DONE;
 	}
 
-	dev_warn(ctrl->ctrl.device, "starting error recovery\n");
-	nvme_tcp_error_recovery(&ctrl->ctrl);
-
+	/*
+	 * LIVE state should trigger the normal error recovery which will
+	 * handle completing this request.
+	 */
+	nvme_tcp_error_recovery(ctrl);
 	return BLK_EH_RESET_TIMER;
 }
 
-- 
2.25.1

