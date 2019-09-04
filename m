Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F2CA8FF1
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388894AbfIDSGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389116AbfIDSGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A281C22CF7;
        Wed,  4 Sep 2019 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620406;
        bh=NOvDY83PqYt4vMD5Kx+g8vHXkGBYxKeYx56Sywp8Rvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRVLXYU06cpPLwUd5ydohQS9Q35NW3YLnIEGKAso7NuX5ZE2NHvefNwzXa2s3dMtk
         VoNROPMiKeXaLWXmpn82+nWSv51rIdqSCNCnGpmRhDHc6tXQbsJUgmA1/90V/SdU6I
         HNtlw4G0P0eeZZ+bLBsO+5CynY6YG0GDrKZ7jgMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Puthukattukaran <james.puthukattukaran@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/93] nvme: fix a possible deadlock when passthru commands sent to a multipath device
Date:   Wed,  4 Sep 2019 19:53:10 +0200
Message-Id: <20190904175303.768594065@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9156daeb1601d69007b7e50efcf89d69d72ec1d ]

When the user issues a command with side effects, we will end up freezing
the namespace request queue when updating disk info (and the same for
the corresponding mpath disk node).

However, we are not freezing the mpath node request queue,
which means that mpath I/O can still come in and block on blk_queue_enter
(called from nvme_ns_head_make_request -> direct_make_request).

This is a deadlock, because blk_queue_enter will block until the inner
namespace request queue is unfroze, but that process is blocked because
the namespace revalidation is trying to update the mpath disk info
and freeze its request queue (which will never complete because
of the I/O that is blocked on blk_queue_enter).

Fix this by freezing all the subsystem nsheads request queues before
executing the passthru command. Given that these commands are infrequent
we should not worry about this temporary I/O freeze to keep things sane.

Here is the matching hang traces:
--
[ 374.465002] INFO: task systemd-udevd:17994 blocked for more than 122 seconds.
[ 374.472975] Not tainted 5.2.0-rc3-mpdebug+ #42
[ 374.478522] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 374.487274] systemd-udevd D 0 17994 1 0x00000000
[ 374.493407] Call Trace:
[ 374.496145] __schedule+0x2ef/0x620
[ 374.500047] schedule+0x38/0xa0
[ 374.503569] blk_queue_enter+0x139/0x220
[ 374.507959] ? remove_wait_queue+0x60/0x60
[ 374.512540] direct_make_request+0x60/0x130
[ 374.517219] nvme_ns_head_make_request+0x11d/0x420 [nvme_core]
[ 374.523740] ? generic_make_request_checks+0x307/0x6f0
[ 374.529484] generic_make_request+0x10d/0x2e0
[ 374.534356] submit_bio+0x75/0x140
[ 374.538163] ? guard_bio_eod+0x32/0xe0
[ 374.542361] submit_bh_wbc+0x171/0x1b0
[ 374.546553] block_read_full_page+0x1ed/0x330
[ 374.551426] ? check_disk_change+0x70/0x70
[ 374.556008] ? scan_shadow_nodes+0x30/0x30
[ 374.560588] blkdev_readpage+0x18/0x20
[ 374.564783] do_read_cache_page+0x301/0x860
[ 374.569463] ? blkdev_writepages+0x10/0x10
[ 374.574037] ? prep_new_page+0x88/0x130
[ 374.578329] ? get_page_from_freelist+0xa2f/0x1280
[ 374.583688] ? __alloc_pages_nodemask+0x179/0x320
[ 374.588947] read_cache_page+0x12/0x20
[ 374.593142] read_dev_sector+0x2d/0xd0
[ 374.597337] read_lba+0x104/0x1f0
[ 374.601046] find_valid_gpt+0xfa/0x720
[ 374.605243] ? string_nocheck+0x58/0x70
[ 374.609534] ? find_valid_gpt+0x720/0x720
[ 374.614016] efi_partition+0x89/0x430
[ 374.618113] ? string+0x48/0x60
[ 374.621632] ? snprintf+0x49/0x70
[ 374.625339] ? find_valid_gpt+0x720/0x720
[ 374.629828] check_partition+0x116/0x210
[ 374.634214] rescan_partitions+0xb6/0x360
[ 374.638699] __blkdev_reread_part+0x64/0x70
[ 374.643377] blkdev_reread_part+0x23/0x40
[ 374.647860] blkdev_ioctl+0x48c/0x990
[ 374.651956] block_ioctl+0x41/0x50
[ 374.655766] do_vfs_ioctl+0xa7/0x600
[ 374.659766] ? locks_lock_inode_wait+0xb1/0x150
[ 374.664832] ksys_ioctl+0x67/0x90
[ 374.668539] __x64_sys_ioctl+0x1a/0x20
[ 374.672732] do_syscall_64+0x5a/0x1c0
[ 374.676828] entry_SYSCALL_64_after_hwframe+0x44/0xa9

[ 374.738474] INFO: task nvmeadm:49141 blocked for more than 123 seconds.
[ 374.745871] Not tainted 5.2.0-rc3-mpdebug+ #42
[ 374.751419] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 374.760170] nvmeadm D 0 49141 36333 0x00004080
[ 374.766301] Call Trace:
[ 374.769038] __schedule+0x2ef/0x620
[ 374.772939] schedule+0x38/0xa0
[ 374.776452] blk_mq_freeze_queue_wait+0x59/0x100
[ 374.781614] ? remove_wait_queue+0x60/0x60
[ 374.786192] blk_mq_freeze_queue+0x1a/0x20
[ 374.790773] nvme_update_disk_info.isra.57+0x5f/0x350 [nvme_core]
[ 374.797582] ? nvme_identify_ns.isra.50+0x71/0xc0 [nvme_core]
[ 374.804006] __nvme_revalidate_disk+0xe5/0x110 [nvme_core]
[ 374.810139] nvme_revalidate_disk+0xa6/0x120 [nvme_core]
[ 374.816078] ? nvme_submit_user_cmd+0x11e/0x320 [nvme_core]
[ 374.822299] nvme_user_cmd+0x264/0x370 [nvme_core]
[ 374.827661] nvme_dev_ioctl+0x112/0x1d0 [nvme_core]
[ 374.833114] do_vfs_ioctl+0xa7/0x600
[ 374.837117] ? __audit_syscall_entry+0xdd/0x130
[ 374.842184] ksys_ioctl+0x67/0x90
[ 374.845891] __x64_sys_ioctl+0x1a/0x20
[ 374.850082] do_syscall_64+0x5a/0x1c0
[ 374.854178] entry_SYSCALL_64_after_hwframe+0x44/0xa9
--

Reported-by: James Puthukattukaran <james.puthukattukaran@oracle.com>
Tested-by: James Puthukattukaran <james.puthukattukaran@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |  5 +++++
 drivers/nvme/host/multipath.c | 30 ++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h      | 12 ++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d838a300ae770..ae0b01059fc6d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1183,6 +1183,9 @@ static u32 nvme_passthru_start(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	 */
 	if (effects & (NVME_CMD_EFFECTS_LBCC | NVME_CMD_EFFECTS_CSE_MASK)) {
 		mutex_lock(&ctrl->scan_lock);
+		mutex_lock(&ctrl->subsys->lock);
+		nvme_mpath_start_freeze(ctrl->subsys);
+		nvme_mpath_wait_freeze(ctrl->subsys);
 		nvme_start_freeze(ctrl);
 		nvme_wait_freeze(ctrl);
 	}
@@ -1213,6 +1216,8 @@ static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects)
 		nvme_update_formats(ctrl);
 	if (effects & (NVME_CMD_EFFECTS_LBCC | NVME_CMD_EFFECTS_CSE_MASK)) {
 		nvme_unfreeze(ctrl);
+		nvme_mpath_unfreeze(ctrl->subsys);
+		mutex_unlock(&ctrl->subsys->lock);
 		mutex_unlock(&ctrl->scan_lock);
 	}
 	if (effects & NVME_CMD_EFFECTS_CCC)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a11e210d173e4..05d6371c7f385 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -20,6 +20,36 @@ module_param(multipath, bool, 0444);
 MODULE_PARM_DESC(multipath,
 	"turn on native support for multiple controllers per subsystem");
 
+void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
+{
+	struct nvme_ns_head *h;
+
+	lockdep_assert_held(&subsys->lock);
+	list_for_each_entry(h, &subsys->nsheads, entry)
+		if (h->disk)
+			blk_mq_unfreeze_queue(h->disk->queue);
+}
+
+void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
+{
+	struct nvme_ns_head *h;
+
+	lockdep_assert_held(&subsys->lock);
+	list_for_each_entry(h, &subsys->nsheads, entry)
+		if (h->disk)
+			blk_mq_freeze_queue_wait(h->disk->queue);
+}
+
+void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
+{
+	struct nvme_ns_head *h;
+
+	lockdep_assert_held(&subsys->lock);
+	list_for_each_entry(h, &subsys->nsheads, entry)
+		if (h->disk)
+			blk_freeze_queue_start(h->disk->queue);
+}
+
 /*
  * If multipathing is enabled we need to always use the subsystem instance
  * number for numbering our devices to avoid conflicts between subsystems that
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d5e29b57eb340..2653e1f4196d5 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -469,6 +469,9 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 	return ctrl->ana_log_buf != NULL;
 }
 
+void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
+void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
+void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
 void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 			struct nvme_ctrl *ctrl, int *flags);
 void nvme_failover_req(struct request *req);
@@ -553,6 +556,15 @@ static inline void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 static inline void nvme_mpath_stop(struct nvme_ctrl *ctrl)
 {
 }
+static inline void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
+{
+}
+static inline void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
+{
+}
+static inline void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
+{
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 #ifdef CONFIG_NVM
-- 
2.20.1



