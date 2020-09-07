Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845FE26017B
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgIGRGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbgIGQdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B07DA21919;
        Mon,  7 Sep 2020 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496379;
        bh=v1HrhUB5Bh/hZ+mDpG2XsSC2WgHqy40+3yG7tfKwR/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZHJrjLgrmxWNIDbx1po+vwGOHjGPIH1UMRufHQ5dFjgKGCG7oojm2b9dgt1USKaB
         u5MuMfWUI8NELCgs2rgAXi8yuR60U/VTpVyIJ6iEynv4eF+KOLGDzNe8aXCtxusY9S
         0UCFmGu7sLm/Tx9xFbEPAjNONRSwyx6Qw2A0wlUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 30/53] nvme-tcp: serialize controller teardown sequences
Date:   Mon,  7 Sep 2020 12:31:56 -0400
Message-Id: <20200907163220.1280412-30-sashal@kernel.org>
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

[ Upstream commit d4d61470ae48838f49e668503e840e1520b97162 ]

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

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a6d2e3330a584..d1e5b27675b1b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -122,6 +122,7 @@ struct nvme_tcp_ctrl {
 	struct sockaddr_storage src_addr;
 	struct nvme_ctrl	ctrl;
 
+	struct mutex		teardown_lock;
 	struct work_struct	err_work;
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
@@ -1497,7 +1498,6 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 
 	if (!test_and_clear_bit(NVME_TCP_Q_LIVE, &queue->flags))
 		return;
-
 	__nvme_tcp_stop_queue(queue);
 }
 
@@ -1845,6 +1845,7 @@ static int nvme_tcp_configure_admin_queue(struct nvme_ctrl *ctrl, bool new)
 static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
 	blk_mq_quiesce_queue(ctrl->admin_q);
 	nvme_tcp_stop_queue(ctrl, 0);
 	if (ctrl->admin_tagset) {
@@ -1855,13 +1856,16 @@ static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 	if (remove)
 		blk_mq_unquiesce_queue(ctrl->admin_q);
 	nvme_tcp_destroy_admin_queue(ctrl, remove);
+	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
 }
 
 static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 		bool remove)
 {
+	mutex_lock(&to_tcp_ctrl(ctrl)->teardown_lock);
 	if (ctrl->queue_count <= 1)
-		return;
+		goto out;
+	blk_mq_quiesce_queue(ctrl->admin_q);
 	nvme_start_freeze(ctrl);
 	nvme_stop_queues(ctrl);
 	nvme_tcp_stop_io_queues(ctrl);
@@ -1873,6 +1877,8 @@ static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
 	if (remove)
 		nvme_start_queues(ctrl);
 	nvme_tcp_destroy_io_queues(ctrl, remove);
+out:
+	mutex_unlock(&to_tcp_ctrl(ctrl)->teardown_lock);
 }
 
 static void nvme_tcp_reconnect_or_remove(struct nvme_ctrl *ctrl)
@@ -2384,6 +2390,7 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 			nvme_tcp_reconnect_ctrl_work);
 	INIT_WORK(&ctrl->err_work, nvme_tcp_error_recovery_work);
 	INIT_WORK(&ctrl->ctrl.reset_work, nvme_reset_ctrl_work);
+	mutex_init(&ctrl->teardown_lock);
 
 	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
 		opts->trsvcid =
-- 
2.25.1

