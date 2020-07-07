Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499D22171AB
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgGGPXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbgGGPXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10D820663;
        Tue,  7 Jul 2020 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135424;
        bh=8NeVvOOFeq3pFZ5ep9RRhP0iSBWjjq3+f1Qo8BlJLKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eihmh2DylG1B45wkXyXniJTJB4/qg3jwjn76J6h7ezSmiHbiCHx4nKctCs7pk/7cT
         mDQh4KUUWON9XEl7TbGXigK7tQSVdUJJAGEBfktKiWtSbqOa0HFDX1YgkYIzcgp27+
         HEku+GkqYk6EGIim8heonp/GB0ll7KLUQkQLSLLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 036/112] nvme-multipath: fix deadlock between ana_work and scan_work
Date:   Tue,  7 Jul 2020 17:16:41 +0200
Message-Id: <20200707145802.707380220@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit 489dd102a2c7c94d783a35f9412eb085b8da1aa4 ]

When scan_work calls nvme_mpath_add_disk() this holds ana_lock
and invokes nvme_parse_ana_log(), which may issue IO
in device_add_disk() and hang waiting for an accessible path.
While nvme_mpath_set_live() only called when nvme_state_is_live(),
a transition may cause NVME_SC_ANA_TRANSITION and requeue the IO.

In order to recover and complete the IO ana_work on the same ctrl
should be able to update the path state and remove NVME_NS_ANA_PENDING.

The deadlock occurs because scan_work keeps holding ana_lock,
so ana_work hangs [1].

Fix:
Now nvme_mpath_add_disk() uses nvme_parse_ana_log() to obtain a copy
of the ANA group desc, and then calls nvme_update_ns_ana_state() without
holding ana_lock.

[1]:
kernel: Workqueue: nvme-wq nvme_scan_work [nvme_core]
kernel: Call Trace:
kernel:  __schedule+0x2b9/0x6c0
kernel:  schedule+0x42/0xb0
kernel:  io_schedule+0x16/0x40
kernel:  do_read_cache_page+0x438/0x830
kernel:  read_cache_page+0x12/0x20
kernel:  read_dev_sector+0x27/0xc0
kernel:  read_lba+0xc1/0x220
kernel:  efi_partition+0x1e6/0x708
kernel:  check_partition+0x154/0x244
kernel:  rescan_partitions+0xae/0x280
kernel:  __blkdev_get+0x40f/0x560
kernel:  blkdev_get+0x3d/0x140
kernel:  __device_add_disk+0x388/0x480
kernel:  device_add_disk+0x13/0x20
kernel:  nvme_mpath_set_live+0x119/0x140 [nvme_core]
kernel:  nvme_update_ns_ana_state+0x5c/0x60 [nvme_core]
kernel:  nvme_set_ns_ana_state+0x1e/0x30 [nvme_core]
kernel:  nvme_parse_ana_log+0xa1/0x180 [nvme_core]
kernel:  nvme_mpath_add_disk+0x47/0x90 [nvme_core]
kernel:  nvme_validate_ns+0x396/0x940 [nvme_core]
kernel:  nvme_scan_work+0x24f/0x380 [nvme_core]
kernel:  process_one_work+0x1db/0x380
kernel:  worker_thread+0x249/0x400
kernel:  kthread+0x104/0x140

kernel: Workqueue: nvme-wq nvme_ana_work [nvme_core]
kernel: Call Trace:
kernel:  __schedule+0x2b9/0x6c0
kernel:  schedule+0x42/0xb0
kernel:  schedule_preempt_disabled+0xe/0x10
kernel:  __mutex_lock.isra.0+0x182/0x4f0
kernel:  ? __switch_to_asm+0x34/0x70
kernel:  ? select_task_rq_fair+0x1aa/0x5c0
kernel:  ? kvm_sched_clock_read+0x11/0x20
kernel:  ? sched_clock+0x9/0x10
kernel:  __mutex_lock_slowpath+0x13/0x20
kernel:  mutex_lock+0x2e/0x40
kernel:  nvme_read_ana_log+0x3a/0x100 [nvme_core]
kernel:  nvme_ana_work+0x15/0x20 [nvme_core]
kernel:  process_one_work+0x1db/0x380
kernel:  worker_thread+0x4d/0x400
kernel:  kthread+0x104/0x140
kernel:  ? process_one_work+0x380/0x380
kernel:  ? kthread_park+0x80/0x80
kernel:  ret_from_fork+0x35/0x40

Fixes: 0d0b660f214d ("nvme: add ANA support")
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 91a8b1ce5a3a2..f4287d8550a9f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -639,26 +639,34 @@ static ssize_t ana_state_show(struct device *dev, struct device_attribute *attr,
 }
 DEVICE_ATTR_RO(ana_state);
 
-static int nvme_set_ns_ana_state(struct nvme_ctrl *ctrl,
+static int nvme_lookup_ana_group_desc(struct nvme_ctrl *ctrl,
 		struct nvme_ana_group_desc *desc, void *data)
 {
-	struct nvme_ns *ns = data;
+	struct nvme_ana_group_desc *dst = data;
 
-	if (ns->ana_grpid == le32_to_cpu(desc->grpid)) {
-		nvme_update_ns_ana_state(desc, ns);
-		return -ENXIO; /* just break out of the loop */
-	}
+	if (desc->grpid != dst->grpid)
+		return 0;
 
-	return 0;
+	*dst = *desc;
+	return -ENXIO; /* just break out of the loop */
 }
 
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 {
 	if (nvme_ctrl_use_ana(ns->ctrl)) {
+		struct nvme_ana_group_desc desc = {
+			.grpid = id->anagrpid,
+			.state = 0,
+		};
+
 		mutex_lock(&ns->ctrl->ana_lock);
 		ns->ana_grpid = le32_to_cpu(id->anagrpid);
-		nvme_parse_ana_log(ns->ctrl, ns, nvme_set_ns_ana_state);
+		nvme_parse_ana_log(ns->ctrl, &desc, nvme_lookup_ana_group_desc);
 		mutex_unlock(&ns->ctrl->ana_lock);
+		if (desc.state) {
+			/* found the group desc: update */
+			nvme_update_ns_ana_state(&desc, ns);
+		}
 	} else {
 		ns->ana_state = NVME_ANA_OPTIMIZED; 
 		nvme_mpath_set_live(ns);
-- 
2.25.1



