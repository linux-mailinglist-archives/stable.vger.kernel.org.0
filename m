Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2A20DACE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbgF2UAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387548AbgF2TkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924B5248D4;
        Mon, 29 Jun 2020 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444429;
        bh=3/sCQmNiRo2QgM8gU+c241Fiwn/a2hTSPYHc67QFY3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoNh28KngH0i0RoPZgcZmedUXMhh/6DWYkI3pFrLram648GEgyIOvVHR1KxOUk2RP
         fTPQdb4GueUlfUxXkngVtPpFezhLOMYRuoLI7lEt2B5/b4ZJtV+RkW1L2CQaVAosDm
         J6093A2fUfoJUcjEY2mxnFKkyuS1kEJYvXUhZlug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/178] nvme: don't protect ns mutation with ns->head->lock
Date:   Mon, 29 Jun 2020 11:24:12 -0400
Message-Id: <20200629152523.2494198-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit e164471dcf19308d154adb69e7760d8ba426a77f ]

Right now ns->head->lock is protecting namespace mutation
which is wrong and unneeded. Move it to only protect
against head mutations. While we're at it, remove unnecessary
ns->head reference as we already have head pointer.

The problem with this is that the head->lock spans
mpath disk node I/O that may block under some conditions (if
for example the controller is disconnecting or the path
became inaccessible), The locking scheme does not allow any
other path to enable itself, preventing blocked I/O to complete
and forward-progress from there.

This is a preparation patch for the fix in a subsequent patch
where the disk I/O will also be done outside the head->lock.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0f08c15553a64..18f0a05c74b56 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -414,11 +414,10 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 {
 	struct nvme_ns_head *head = ns->head;
 
-	lockdep_assert_held(&ns->head->lock);
-
 	if (!head->disk)
 		return;
 
+	mutex_lock(&head->lock);
 	if (!(head->disk->flags & GENHD_FL_UP))
 		device_add_disk(&head->subsys->dev, head->disk,
 				nvme_ns_id_attr_groups);
@@ -431,9 +430,10 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 			__nvme_find_path(head, node);
 		srcu_read_unlock(&head->srcu, srcu_idx);
 	}
+	mutex_unlock(&head->lock);
 
-	synchronize_srcu(&ns->head->srcu);
-	kblockd_schedule_work(&ns->head->requeue_work);
+	synchronize_srcu(&head->srcu);
+	kblockd_schedule_work(&head->requeue_work);
 }
 
 static int nvme_parse_ana_log(struct nvme_ctrl *ctrl, void *data,
@@ -484,14 +484,12 @@ static inline bool nvme_state_is_live(enum nvme_ana_state state)
 static void nvme_update_ns_ana_state(struct nvme_ana_group_desc *desc,
 		struct nvme_ns *ns)
 {
-	mutex_lock(&ns->head->lock);
 	ns->ana_grpid = le32_to_cpu(desc->grpid);
 	ns->ana_state = desc->state;
 	clear_bit(NVME_NS_ANA_PENDING, &ns->flags);
 
 	if (nvme_state_is_live(ns->ana_state))
 		nvme_mpath_set_live(ns);
-	mutex_unlock(&ns->head->lock);
 }
 
 static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
@@ -670,10 +668,8 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 			nvme_update_ns_ana_state(&desc, ns);
 		}
 	} else {
-		mutex_lock(&ns->head->lock);
 		ns->ana_state = NVME_ANA_OPTIMIZED; 
 		nvme_mpath_set_live(ns);
-		mutex_unlock(&ns->head->lock);
 	}
 
 	if (bdi_cap_stable_pages_required(ns->queue->backing_dev_info)) {
-- 
2.25.1

