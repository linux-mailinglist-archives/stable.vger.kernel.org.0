Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEA914EA8
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfEFOjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfEFOjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F70120449;
        Mon,  6 May 2019 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153578;
        bh=VrITzsTbisGn2C7tt2H6CbV7YDI6yS12z/qYRjbw2Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=164hSrMzYMcHPJ6lsts3GuwpJjivxjLW3r4ruaVY+Ux+3y6iEOr5oWSulLA3jomx0
         OLnaB1vVLMvE6MKGPdFx/D6VZeP4wdRjh9cT1yAvwVDkP/Z7H3fLpfZypqooqOq0kN
         HDeTIJrJpH+eTPZmJn4ltGoA2rhAutxq7PzDYOnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/99] nvme-loop: init nvmet_ctrl fatal_err_work when allocate
Date:   Mon,  6 May 2019 16:31:52 +0200
Message-Id: <20190506143055.646077057@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d11de63f2b519f0a162b834013b6d3a46dbf3886 ]

After commit 4d43d395fe (workqueue: Try to catch flush_work() without
INIT_WORK()), it can cause warning when delete nvme-loop device, trace
like:

[   76.601272] Call Trace:
[   76.601646]  ? del_timer+0x72/0xa0
[   76.602156]  __cancel_work_timer+0x1ae/0x270
[   76.602791]  cancel_work_sync+0x14/0x20
[   76.603407]  nvmet_ctrl_free+0x1b7/0x2f0 [nvmet]
[   76.604091]  ? free_percpu+0x168/0x300
[   76.604652]  nvmet_sq_destroy+0x106/0x240 [nvmet]
[   76.605346]  nvme_loop_destroy_admin_queue+0x30/0x60 [nvme_loop]
[   76.606220]  nvme_loop_shutdown_ctrl+0xc3/0xf0 [nvme_loop]
[   76.607026]  nvme_loop_delete_ctrl_host+0x19/0x30 [nvme_loop]
[   76.607871]  nvme_do_delete_ctrl+0x75/0xb0
[   76.608477]  nvme_sysfs_delete+0x7d/0xc0
[   76.609057]  dev_attr_store+0x24/0x40
[   76.609603]  sysfs_kf_write+0x4c/0x60
[   76.610144]  kernfs_fop_write+0x19a/0x260
[   76.610742]  __vfs_write+0x1c/0x60
[   76.611246]  vfs_write+0xfa/0x280
[   76.611739]  ksys_write+0x6e/0x120
[   76.612238]  __x64_sys_write+0x1e/0x30
[   76.612787]  do_syscall_64+0xbf/0x3a0
[   76.613329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

We fix it by moving fatal_err_work init to nvmet_alloc_ctrl(), which may
more reasonable.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index b5ec96abd048..776b7e9e23b9 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -921,6 +921,15 @@ bool nvmet_host_allowed(struct nvmet_req *req, struct nvmet_subsys *subsys,
 		return __nvmet_host_allowed(subsys, hostnqn);
 }
 
+static void nvmet_fatal_error_handler(struct work_struct *work)
+{
+	struct nvmet_ctrl *ctrl =
+			container_of(work, struct nvmet_ctrl, fatal_err_work);
+
+	pr_err("ctrl %d fatal error occurred!\n", ctrl->cntlid);
+	ctrl->ops->delete_ctrl(ctrl);
+}
+
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		struct nvmet_req *req, u32 kato, struct nvmet_ctrl **ctrlp)
 {
@@ -962,6 +971,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 
 	INIT_WORK(&ctrl->async_event_work, nvmet_async_event_work);
 	INIT_LIST_HEAD(&ctrl->async_events);
+	INIT_WORK(&ctrl->fatal_err_work, nvmet_fatal_error_handler);
 
 	memcpy(ctrl->subsysnqn, subsysnqn, NVMF_NQN_SIZE);
 	memcpy(ctrl->hostnqn, hostnqn, NVMF_NQN_SIZE);
@@ -1076,21 +1086,11 @@ void nvmet_ctrl_put(struct nvmet_ctrl *ctrl)
 	kref_put(&ctrl->ref, nvmet_ctrl_free);
 }
 
-static void nvmet_fatal_error_handler(struct work_struct *work)
-{
-	struct nvmet_ctrl *ctrl =
-			container_of(work, struct nvmet_ctrl, fatal_err_work);
-
-	pr_err("ctrl %d fatal error occurred!\n", ctrl->cntlid);
-	ctrl->ops->delete_ctrl(ctrl);
-}
-
 void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl)
 {
 	mutex_lock(&ctrl->lock);
 	if (!(ctrl->csts & NVME_CSTS_CFS)) {
 		ctrl->csts |= NVME_CSTS_CFS;
-		INIT_WORK(&ctrl->fatal_err_work, nvmet_fatal_error_handler);
 		schedule_work(&ctrl->fatal_err_work);
 	}
 	mutex_unlock(&ctrl->lock);
-- 
2.20.1



