Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3540D1F2F17
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgFIAre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFHXLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEAD920890;
        Mon,  8 Jun 2020 23:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657880;
        bh=rkbbiQCs8BHaHAQU5zfRpAxLE0KUC9UftSsS8I2Mpe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efOhbxNz2KTF7Q2wV3/g9wSdumlDXPJOtY81+KL+jko7+nhjymMvUNzkFKM0tUIFU
         op1y1bgDJkIwEwZ2331oChz3VhGYSS50IUYVZTkPy1JG04DfPQ1G/lqBQ5b6PTlSob
         Mv+3CYnKLMWtvSBvigQjwSZOjIUbMibXmx8IBdPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        David Milburn <dmilburn@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 237/274] nvmet: fix memory leak when removing namespaces and controllers concurrently
Date:   Mon,  8 Jun 2020 19:05:30 -0400
Message-Id: <20200608230607.3361041-237-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 64f5e9cdd711b030b05062c17b2ecfbce890cf4c ]

When removing a namespace, we add an NS_CHANGE async event, however if
the controller admin queue is removed after the event was added but not
yet processed, we won't free the aens, resulting in the below memory
leak [1].

Fix that by moving nvmet_async_event_free to the final controller
release after it is detached from subsys->ctrls ensuring no async
events are added, and modify it to simply remove all pending aens.

--
$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff888c1af2c000 (size 32):
  comm "nvmetcli", pid 5164, jiffies 4295220864 (age 6829.924s)
  hex dump (first 32 bytes):
    28 01 82 3b 8b 88 ff ff 28 01 82 3b 8b 88 ff ff  (..;....(..;....
    02 00 04 65 76 65 6e 74 5f 66 69 6c 65 00 00 00  ...event_file...
  backtrace:
    [<00000000217ae580>] nvmet_add_async_event+0x57/0x290 [nvmet]
    [<0000000012aa2ea9>] nvmet_ns_changed+0x206/0x300 [nvmet]
    [<00000000bb3fd52e>] nvmet_ns_disable+0x367/0x4f0 [nvmet]
    [<00000000e91ca9ec>] nvmet_ns_free+0x15/0x180 [nvmet]
    [<00000000a15deb52>] config_item_release+0xf1/0x1c0
    [<000000007e148432>] configfs_rmdir+0x555/0x7c0
    [<00000000f4506ea6>] vfs_rmdir+0x142/0x3c0
    [<0000000000acaaf0>] do_rmdir+0x2b2/0x340
    [<0000000034d1aa52>] do_syscall_64+0xa5/0x4d0
    [<00000000211f13bc>] entry_SYSCALL_64_after_hwframe+0x6a/0xdf

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Reported-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index b685f99d56a1..aa5ca222c6f5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -157,14 +157,12 @@ static void nvmet_async_events_process(struct nvmet_ctrl *ctrl, u16 status)
 
 static void nvmet_async_events_free(struct nvmet_ctrl *ctrl)
 {
-	struct nvmet_req *req;
+	struct nvmet_async_event *aen, *tmp;
 
 	mutex_lock(&ctrl->lock);
-	while (ctrl->nr_async_event_cmds) {
-		req = ctrl->async_event_cmds[--ctrl->nr_async_event_cmds];
-		mutex_unlock(&ctrl->lock);
-		nvmet_req_complete(req, NVME_SC_INTERNAL | NVME_SC_DNR);
-		mutex_lock(&ctrl->lock);
+	list_for_each_entry_safe(aen, tmp, &ctrl->async_events, entry) {
+		list_del(&aen->entry);
+		kfree(aen);
 	}
 	mutex_unlock(&ctrl->lock);
 }
@@ -764,10 +762,8 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
 	 * If this is the admin queue, complete all AERs so that our
 	 * queue doesn't have outstanding requests on it.
 	 */
-	if (ctrl && ctrl->sqs && ctrl->sqs[0] == sq) {
+	if (ctrl && ctrl->sqs && ctrl->sqs[0] == sq)
 		nvmet_async_events_process(ctrl, status);
-		nvmet_async_events_free(ctrl);
-	}
 	percpu_ref_kill_and_confirm(&sq->ref, nvmet_confirm_sq);
 	wait_for_completion(&sq->confirm_done);
 	wait_for_completion(&sq->free_done);
@@ -1357,6 +1353,7 @@ static void nvmet_ctrl_free(struct kref *ref)
 
 	ida_simple_remove(&cntlid_ida, ctrl->cntlid);
 
+	nvmet_async_events_free(ctrl);
 	kfree(ctrl->sqs);
 	kfree(ctrl->cqs);
 	kfree(ctrl->changed_ns_list);
-- 
2.25.1

