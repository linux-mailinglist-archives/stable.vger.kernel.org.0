Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4250220E82D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391822AbgF2WEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2EB24182;
        Mon, 29 Jun 2020 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443952;
        bh=OZU4AHm2DkxTja+J+YK4vXYb0fvaUQ/Dp2hM+Aq594k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBnbruB/E+3H0PRHbYMfF7nXE6IyeQG925s/KNdho9uO/dghp4CiNQDCaSQ8EmIqI
         7WLEtg74MFvgww9E226pyCet5PLJx2NAQHghrElJmzHMDj4oE/5XPtDnnRMJI2v01x
         zvzNxUXpiiNvgYHicR1YdZcBrzlpV7NzYq5OlSpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 054/265] nvmet: fail outstanding host posted AEN req
Date:   Mon, 29 Jun 2020 11:14:47 -0400
Message-Id: <20200629151818.2493727-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 819f7b88b48fd2bce932cfe3a38bf8fcefbcabe7 ]

In function nvmet_async_event_process() we only process AENs iff
there is an open slot on the ctrl->async_event_cmds[] && aen
event list posted by the target is not empty. This keeps host
posted AEN outstanding if target generated AEN list is empty.
We do cleanup the target generated entries from the aen list in
nvmet_ctrl_free()-> nvmet_async_events_free() but we don't
process AEN posted by the host. This leads to following problem :-

When processing admin sq at the time of nvmet_sq_destroy() holds
an extra percpu reference(atomic value = 1), so in the following code
path after switching to atomic rcu, release function (nvmet_sq_free())
is not getting called which blocks the sq->free_done in
nvmet_sq_destroy() :-

nvmet_sq_destroy()
 percpu_ref_kill_and_confirm()
 - __percpu_ref_switch_mode()
 --  __percpu_ref_switch_to_atomic()
 ---   call_rcu() -> percpu_ref_switch_to_atomic_rcu()
 ----     /* calls switch callback */
 - percpu_ref_put()
 -- percpu_ref_put_many(ref, 1)
 --- else if (unlikely(atomic_long_sub_and_test(nr, &ref->count)))
 ----   ref->release(ref); <---- Not called.

This results in indefinite hang:-

  void nvmet_sq_destroy(struct nvmet_sq *sq)
...
          if (ctrl && ctrl->sqs && ctrl->sqs[0] == sq) {
                  nvmet_async_events_process(ctrl, status);
                  percpu_ref_put(&sq->ref);
          }
          percpu_ref_kill_and_confirm(&sq->ref, nvmet_confirm_sq);
          wait_for_completion(&sq->confirm_done);
          wait_for_completion(&sq->free_done); <-- Hang here

Which breaks the further disconnect sequence. This problem seems to be
introduced after commit 64f5e9cdd711b ("nvmet: fix memory leak when
removing namespaces and controllers concurrently").

This patch processes ctrl->async_event_cmds[] in the admin sq destroy()
context irrespetive of aen_list. Also we get rid of the controller's
aen_list processing in the nvmet_sq_destroy() context and just ignore
ctrl->aen_list.

This results in nvmet_async_events_process() being called from workqueue
context so we adjust the code accordingly.

Fixes: 64f5e9cdd711 ("nvmet: fix memory leak when removing namespaces and controllers concurrently ")
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index ac7ae031ce78d..96deaf3484662 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -129,7 +129,22 @@ static u32 nvmet_async_event_result(struct nvmet_async_event *aen)
 	return aen->event_type | (aen->event_info << 8) | (aen->log_page << 16);
 }
 
-static void nvmet_async_events_process(struct nvmet_ctrl *ctrl, u16 status)
+static void nvmet_async_events_failall(struct nvmet_ctrl *ctrl)
+{
+	u16 status = NVME_SC_INTERNAL | NVME_SC_DNR;
+	struct nvmet_req *req;
+
+	mutex_lock(&ctrl->lock);
+	while (ctrl->nr_async_event_cmds) {
+		req = ctrl->async_event_cmds[--ctrl->nr_async_event_cmds];
+		mutex_unlock(&ctrl->lock);
+		nvmet_req_complete(req, status);
+		mutex_lock(&ctrl->lock);
+	}
+	mutex_unlock(&ctrl->lock);
+}
+
+static void nvmet_async_events_process(struct nvmet_ctrl *ctrl)
 {
 	struct nvmet_async_event *aen;
 	struct nvmet_req *req;
@@ -139,14 +154,13 @@ static void nvmet_async_events_process(struct nvmet_ctrl *ctrl, u16 status)
 		aen = list_first_entry(&ctrl->async_events,
 				       struct nvmet_async_event, entry);
 		req = ctrl->async_event_cmds[--ctrl->nr_async_event_cmds];
-		if (status == 0)
-			nvmet_set_result(req, nvmet_async_event_result(aen));
+		nvmet_set_result(req, nvmet_async_event_result(aen));
 
 		list_del(&aen->entry);
 		kfree(aen);
 
 		mutex_unlock(&ctrl->lock);
-		nvmet_req_complete(req, status);
+		nvmet_req_complete(req, 0);
 		mutex_lock(&ctrl->lock);
 	}
 	mutex_unlock(&ctrl->lock);
@@ -169,7 +183,7 @@ static void nvmet_async_event_work(struct work_struct *work)
 	struct nvmet_ctrl *ctrl =
 		container_of(work, struct nvmet_ctrl, async_event_work);
 
-	nvmet_async_events_process(ctrl, 0);
+	nvmet_async_events_process(ctrl);
 }
 
 void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
@@ -752,7 +766,6 @@ static void nvmet_confirm_sq(struct percpu_ref *ref)
 
 void nvmet_sq_destroy(struct nvmet_sq *sq)
 {
-	u16 status = NVME_SC_INTERNAL | NVME_SC_DNR;
 	struct nvmet_ctrl *ctrl = sq->ctrl;
 
 	/*
@@ -760,7 +773,7 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
 	 * queue doesn't have outstanding requests on it.
 	 */
 	if (ctrl && ctrl->sqs && ctrl->sqs[0] == sq)
-		nvmet_async_events_process(ctrl, status);
+		nvmet_async_events_failall(ctrl);
 	percpu_ref_kill_and_confirm(&sq->ref, nvmet_confirm_sq);
 	wait_for_completion(&sq->confirm_done);
 	wait_for_completion(&sq->free_done);
-- 
2.25.1

