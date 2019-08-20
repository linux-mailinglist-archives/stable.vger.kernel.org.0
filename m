Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FAE96175
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHTNr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbfHTNko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:44 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2393B2339D;
        Tue, 20 Aug 2019 13:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308443;
        bh=niOmxKqKT4rKs6RlnO/vfH9InkN8B0TOy+QCVTz8tyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ywk+IKFFKgvOhajXGaeed0f2sIyhgQctxvnZYGRq3oenn45T1jouSfaqgEeX23YEd
         UPywyU2ZSLKYoAZoHcW6oUsiAV7Swx07EMUd+FUMH8eErJ8Dl9NqfXmxh4nSLJ4Vfl
         P8Jn34RfiO3L7G18XgvqiESURpKGsbW0DxBmuA30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 16/44] nvme: fix controller removal race with scan work
Date:   Tue, 20 Aug 2019 09:40:00 -0400
Message-Id: <20190820134028.10829-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 0157ec8dad3c8fc9bc9790f76e0831ffdaf2e7f0 ]

With multipath enabled, nvme_scan_work() can read from the device
(through nvme_mpath_add_disk()) and hang [1]. However, with fabrics,
once ctrl->state is set to NVME_CTRL_DELETING, the reads will hang
(see nvmf_check_ready()) and the mpath stack device make_request
will block if head->list is not empty. However, when the head->list
consistst of only DELETING/DEAD controllers, we should actually not
block, but rather fail immediately.

In addition, before we go ahead and remove the namespaces, make sure
to clear the current path and kick the requeue list so that the
request will fast fail upon requeuing.

[1]:
--
  INFO: task kworker/u4:3:166 blocked for more than 120 seconds.
        Not tainted 5.2.0-rc6-vmlocalyes-00005-g808c8c2dc0cf #316
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  kworker/u4:3    D    0   166      2 0x80004000
  Workqueue: nvme-wq nvme_scan_work
  Call Trace:
   __schedule+0x851/0x1400
   schedule+0x99/0x210
   io_schedule+0x21/0x70
   do_read_cache_page+0xa57/0x1330
   read_cache_page+0x4a/0x70
   read_dev_sector+0xbf/0x380
   amiga_partition+0xc4/0x1230
   check_partition+0x30f/0x630
   rescan_partitions+0x19a/0x980
   __blkdev_get+0x85a/0x12f0
   blkdev_get+0x2a5/0x790
   __device_add_disk+0xe25/0x1250
   device_add_disk+0x13/0x20
   nvme_mpath_set_live+0x172/0x2b0
   nvme_update_ns_ana_state+0x130/0x180
   nvme_set_ns_ana_state+0x9a/0xb0
   nvme_parse_ana_log+0x1c3/0x4a0
   nvme_mpath_add_disk+0x157/0x290
   nvme_validate_ns+0x1017/0x1bd0
   nvme_scan_work+0x44d/0x6a0
   process_one_work+0x7d7/0x1240
   worker_thread+0x8e/0xff0
   kthread+0x2c3/0x3b0
   ret_from_fork+0x35/0x40

   INFO: task kworker/u4:1:1034 blocked for more than 120 seconds.
        Not tainted 5.2.0-rc6-vmlocalyes-00005-g808c8c2dc0cf #316
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  kworker/u4:1    D    0  1034      2 0x80004000
  Workqueue: nvme-delete-wq nvme_delete_ctrl_work
  Call Trace:
   __schedule+0x851/0x1400
   schedule+0x99/0x210
   schedule_timeout+0x390/0x830
   wait_for_completion+0x1a7/0x310
   __flush_work+0x241/0x5d0
   flush_work+0x10/0x20
   nvme_remove_namespaces+0x85/0x3d0
   nvme_do_delete_ctrl+0xb4/0x1e0
   nvme_delete_ctrl_work+0x15/0x20
   process_one_work+0x7d7/0x1240
   worker_thread+0x8e/0xff0
   kthread+0x2c3/0x3b0
   ret_from_fork+0x35/0x40
--

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |  7 ++++++
 drivers/nvme/host/multipath.c | 46 ++++++++++++++++++++++++++++++-----
 drivers/nvme/host/nvme.h      |  9 +++++--
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 05301b94e2fa0..601509b3251ae 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3529,6 +3529,13 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
 	struct nvme_ns *ns, *next;
 	LIST_HEAD(ns_list);
 
+	/*
+	 * make sure to requeue I/O to all namespaces as these
+	 * might result from the scan itself and must complete
+	 * for the scan_work to make progress
+	 */
+	nvme_mpath_clear_ctrl_paths(ctrl);
+
 	/* prevent racing with ns scanning */
 	flush_work(&ctrl->scan_work);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index dafb9e4aa1237..747c0d4f9ff5b 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -134,18 +134,34 @@ static const char *nvme_ana_state_names[] = {
 	[NVME_ANA_CHANGE]		= "change",
 };
 
-void nvme_mpath_clear_current_path(struct nvme_ns *ns)
+bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
 {
 	struct nvme_ns_head *head = ns->head;
+	bool changed = false;
 	int node;
 
 	if (!head)
-		return;
+		goto out;
 
 	for_each_node(node) {
-		if (ns == rcu_access_pointer(head->current_path[node]))
+		if (ns == rcu_access_pointer(head->current_path[node])) {
 			rcu_assign_pointer(head->current_path[node], NULL);
+			changed = true;
+		}
 	}
+out:
+	return changed;
+}
+
+void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
+{
+	struct nvme_ns *ns;
+
+	mutex_lock(&ctrl->scan_lock);
+	list_for_each_entry(ns, &ctrl->namespaces, list)
+		if (nvme_mpath_clear_current_path(ns))
+			kblockd_schedule_work(&ns->head->requeue_work);
+	mutex_unlock(&ctrl->scan_lock);
 }
 
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
@@ -248,6 +264,24 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
 	return ns;
 }
 
+static bool nvme_available_path(struct nvme_ns_head *head)
+{
+	struct nvme_ns *ns;
+
+	list_for_each_entry_rcu(ns, &head->list, siblings) {
+		switch (ns->ctrl->state) {
+		case NVME_CTRL_LIVE:
+		case NVME_CTRL_RESETTING:
+		case NVME_CTRL_CONNECTING:
+			/* fallthru */
+			return true;
+		default:
+			break;
+		}
+	}
+	return false;
+}
+
 static blk_qc_t nvme_ns_head_make_request(struct request_queue *q,
 		struct bio *bio)
 {
@@ -274,14 +308,14 @@ static blk_qc_t nvme_ns_head_make_request(struct request_queue *q,
 				      disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
 		ret = direct_make_request(bio);
-	} else if (!list_empty_careful(&head->list)) {
-		dev_warn_ratelimited(dev, "no path available - requeuing I/O\n");
+	} else if (nvme_available_path(head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 
 		spin_lock_irq(&head->requeue_lock);
 		bio_list_add(&head->requeue_list, bio);
 		spin_unlock_irq(&head->requeue_lock);
 	} else {
-		dev_warn_ratelimited(dev, "no path - failing I/O\n");
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
 
 		bio->bi_status = BLK_STS_IOERR;
 		bio_endio(bio);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index b8b45822f7be0..81215ca32671a 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -490,7 +490,8 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 int nvme_mpath_init(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
-void nvme_mpath_clear_current_path(struct nvme_ns *ns);
+bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
+void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 
 static inline void nvme_mpath_check_last_path(struct nvme_ns *ns)
@@ -538,7 +539,11 @@ static inline void nvme_mpath_add_disk(struct nvme_ns *ns,
 static inline void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 }
-static inline void nvme_mpath_clear_current_path(struct nvme_ns *ns)
+static inline bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
+{
+	return false;
+}
+static inline void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 {
 }
 static inline void nvme_mpath_check_last_path(struct nvme_ns *ns)
-- 
2.20.1

