Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFECA2B631E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbgKQNfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbgKQNfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B77207BC;
        Tue, 17 Nov 2020 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620107;
        bh=87MFyZmLGNX5mC2LyjovIDRyVbCB6vj/b4jJAZ9NYlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvSqvLBtfJlCRf+ExbnqyVKEYWcxOr70g5WaS9K7hRwm1EBMlcAX6XCsSNg1Vev6Q
         P7SLmN0xlbsJeRCMkEHwoyyIhBAoFD8A/Ef0zDJNXx7NsOUYkegGBeHTeNTGrB1koY
         IaqHvk2VuVbgydW3A4HEhiGdwRM5XdoQdVftArTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 109/255] nvme-tcp: avoid race between time out and tear down
Date:   Tue, 17 Nov 2020 14:04:09 +0100
Message-Id: <20201117122144.260085541@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit d6f66210f4b1aa2f5944f0e34e0f8db44f499f92 ]

Now use teardown_lock to serialize for time out and tear down. This may
cause abnormal: first cancel all request in tear down, then time out may
complete the request again, but the request may already be freed or
restarted.

To avoid race between time out and tear down, in tear down process,
first we quiesce the queue, and then delete the timer and cancel
the time out work for the queue. At the same time we need to delete
teardown_lock.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d6a3e14873542..19f86ea547bbc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -124,7 +124,6 @@ struct nvme_tcp_ctrl {
 	struct sockaddr_storage src_addr;
 	struct nvme_ctrl	ctrl;
 
-	struct mutex		teardown_lock;
 	struct work_struct	err_work;
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
@@ -1886,8 +1885,8 @@ out_free_queue:
 static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 		bool remove)
 {
-	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
 	blk_mq_quiesce_queue(ctrl->admin_q);
+	blk_sync_queue(ctrl->admin_q);
 	nvme_tcp_stop_queue(ctrl, 0);
 	if (ctrl->admin_tagset) {
 		blk_mq_tagset_busy_iter(ctrl->admin_tagset,
@@ -1897,18 +1896,17 @@ static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 	if (remove)
 		blk_mq_unquiesce_queue(ctrl->admin_q);
 	nvme_tcp_destroy_admin_queue(ctrl, remove);
-	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
 }
 
 static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 		bool remove)
 {
-	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
 	if (ctrl->queue_count <= 1)
-		goto out;
+		return;
 	blk_mq_quiesce_queue(ctrl->admin_q);
 	nvme_start_freeze(ctrl);
 	nvme_stop_queues(ctrl);
+	nvme_sync_io_queues(ctrl);
 	nvme_tcp_stop_io_queues(ctrl);
 	if (ctrl->tagset) {
 		blk_mq_tagset_busy_iter(ctrl->tagset,
@@ -1918,8 +1916,6 @@ static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 	if (remove)
 		nvme_start_queues(ctrl);
 	nvme_tcp_destroy_io_queues(ctrl, remove);
-out:
-	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
 }
 
 static void nvme_tcp_reconnect_or_remove(struct nvme_ctrl *ctrl)
@@ -2171,14 +2167,11 @@ static void nvme_tcp_complete_timed_out(struct request *rq)
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 	struct nvme_ctrl *ctrl = &req->queue->ctrl->ctrl;
 
-	/* fence other contexts that may complete the command */
-	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
 	nvme_tcp_stop_queue(ctrl, nvme_tcp_queue_id(req->queue));
 	if (!blk_mq_request_completed(rq)) {
 		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
 		blk_mq_complete_request(rq);
 	}
-	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
 }
 
 static enum blk_eh_timer_return
@@ -2455,7 +2448,6 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 			nvme_tcp_reconnect_ctrl_work);
 	INIT_WORK(&ctrl->err_work, nvme_tcp_error_recovery_work);
 	INIT_WORK(&ctrl->ctrl.reset_work, nvme_reset_ctrl_work);
-	mutex_init(&ctrl->teardown_lock);
 
 	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
 		opts->trsvcid =
-- 
2.27.0



