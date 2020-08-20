Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8678C24B283
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgHTJbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgHTJbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B2A206FA;
        Thu, 20 Aug 2020 09:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915879;
        bh=RPonXxDw8piXO1pS58HM6H6oZieXUelp2GcsCDZFJxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5ZN2p9ZeMV7JnpFCBafhceNxfxQzRhrH8xU3VEOHV/R5PO2q5qgLVWs18NCjdfo4
         b86OjtoDrNGNOzx2d4wYLE/Tf+G6xwq4eKeA4yMyAN2Y1oDmd3VMqhk45kn684+UXE
         nOcJ83H7YV4/ANlnP6Vy2d2fFoC9jr384uhdmzi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 167/232] nvme: fix deadlock in disconnect during scan_work and/or ana_work
Date:   Thu, 20 Aug 2020 11:20:18 +0200
Message-Id: <20200820091620.904431053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit ecca390e80561debbfdb4dc96bf94595136889fa ]

A deadlock happens in the following scenario with multipath:
1) scan_work(nvme0) detects a new nsid while nvme0
    is an optimized path to it, path nvme1 happens to be
    inaccessible.

2) Before scan_work is complete nvme0 disconnect is initiated
    nvme_delete_ctrl_sync() sets nvme0 state to NVME_CTRL_DELETING

3) scan_work(1) attempts to submit IO,
    but nvme_path_is_optimized() observes nvme0 is not LIVE.
    Since nvme1 is a possible path IO is requeued and scan_work hangs.

--
Workqueue: nvme-wq nvme_scan_work [nvme_core]
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
--

4) Delete also hangs in flush_work(ctrl->scan_work)
    from nvme_remove_namespaces().

Similiarly a deadlock with ana_work may happen: if ana_work has started
and calls nvme_mpath_set_live and device_add_disk, it will
trigger I/O. When we trigger disconnect I/O will block because
our accessible (optimized) path is disconnecting, but the alternate
path is inaccessible, so I/O blocks. Then disconnect tries to flush
the ana_work and hangs.

[  605.550896] Workqueue: nvme-wq nvme_ana_work [nvme_core]
[  605.552087] Call Trace:
[  605.552683]  __schedule+0x2b9/0x6c0
[  605.553507]  schedule+0x42/0xb0
[  605.554201]  io_schedule+0x16/0x40
[  605.555012]  do_read_cache_page+0x438/0x830
[  605.556925]  read_cache_page+0x12/0x20
[  605.557757]  read_dev_sector+0x27/0xc0
[  605.558587]  amiga_partition+0x4d/0x4c5
[  605.561278]  check_partition+0x154/0x244
[  605.562138]  rescan_partitions+0xae/0x280
[  605.563076]  __blkdev_get+0x40f/0x560
[  605.563830]  blkdev_get+0x3d/0x140
[  605.564500]  __device_add_disk+0x388/0x480
[  605.565316]  device_add_disk+0x13/0x20
[  605.566070]  nvme_mpath_set_live+0x5e/0x130 [nvme_core]
[  605.567114]  nvme_update_ns_ana_state+0x2c/0x30 [nvme_core]
[  605.568197]  nvme_update_ana_state+0xca/0xe0 [nvme_core]
[  605.569360]  nvme_parse_ana_log+0xa1/0x180 [nvme_core]
[  605.571385]  nvme_read_ana_log+0x76/0x100 [nvme_core]
[  605.572376]  nvme_ana_work+0x15/0x20 [nvme_core]
[  605.573330]  process_one_work+0x1db/0x380
[  605.574144]  worker_thread+0x4d/0x400
[  605.574896]  kthread+0x104/0x140
[  605.577205]  ret_from_fork+0x35/0x40
[  605.577955] INFO: task nvme:14044 blocked for more than 120 seconds.
[  605.579239]       Tainted: G           OE     5.3.5-050305-generic #201910071830
[  605.580712] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  605.582320] nvme            D    0 14044  14043 0x00000000
[  605.583424] Call Trace:
[  605.583935]  __schedule+0x2b9/0x6c0
[  605.584625]  schedule+0x42/0xb0
[  605.585290]  schedule_timeout+0x203/0x2f0
[  605.588493]  wait_for_completion+0xb1/0x120
[  605.590066]  __flush_work+0x123/0x1d0
[  605.591758]  __cancel_work_timer+0x10e/0x190
[  605.593542]  cancel_work_sync+0x10/0x20
[  605.594347]  nvme_mpath_stop+0x2f/0x40 [nvme_core]
[  605.595328]  nvme_stop_ctrl+0x12/0x50 [nvme_core]
[  605.596262]  nvme_do_delete_ctrl+0x3f/0x90 [nvme_core]
[  605.597333]  nvme_sysfs_delete+0x5c/0x70 [nvme_core]
[  605.598320]  dev_attr_store+0x17/0x30

Fix this by introducing a new state: NVME_CTRL_DELETE_NOIO, which will
indicate the phase of controller deletion where I/O cannot be allowed
to access the namespace. NVME_CTRL_DELETING still allows mpath I/O to
be issued to the bottom device, and only after we flush the ana_work
and scan_work (after nvme_stop_ctrl and nvme_prep_remove_namespaces)
we change the state to NVME_CTRL_DELETING_NOIO. Also we prevent ana_work
from re-firing by aborting early if we are not LIVE, so we should be safe
here.

In addition, change the transport drivers to follow the updated state
machine.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Reported-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 15 +++++++++++++++
 drivers/nvme/host/fabrics.c   |  2 +-
 drivers/nvme/host/fabrics.h   |  3 ++-
 drivers/nvme/host/fc.c        |  1 +
 drivers/nvme/host/multipath.c | 18 +++++++++++++++---
 drivers/nvme/host/nvme.h      |  1 +
 drivers/nvme/host/rdma.c      | 10 ++++++----
 drivers/nvme/host/tcp.c       | 15 +++++++++------
 8 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4ee2330c603e7..f38548e6d55ec 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -362,6 +362,16 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 			break;
 		}
 		break;
+	case NVME_CTRL_DELETING_NOIO:
+		switch (old_state) {
+		case NVME_CTRL_DELETING:
+		case NVME_CTRL_DEAD:
+			changed = true;
+			/* FALLTHRU */
+		default:
+			break;
+		}
+		break;
 	case NVME_CTRL_DEAD:
 		switch (old_state) {
 		case NVME_CTRL_DELETING:
@@ -399,6 +409,7 @@ static bool nvme_state_terminal(struct nvme_ctrl *ctrl)
 	case NVME_CTRL_CONNECTING:
 		return false;
 	case NVME_CTRL_DELETING:
+	case NVME_CTRL_DELETING_NOIO:
 	case NVME_CTRL_DEAD:
 		return true;
 	default:
@@ -3344,6 +3355,7 @@ static ssize_t nvme_sysfs_show_state(struct device *dev,
 		[NVME_CTRL_RESETTING]	= "resetting",
 		[NVME_CTRL_CONNECTING]	= "connecting",
 		[NVME_CTRL_DELETING]	= "deleting",
+		[NVME_CTRL_DELETING_NOIO]= "deleting (no IO)",
 		[NVME_CTRL_DEAD]	= "dead",
 	};
 
@@ -3911,6 +3923,9 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
 	if (ctrl->state == NVME_CTRL_DEAD)
 		nvme_kill_queues(ctrl);
 
+	/* this is a no-op when called from the controller reset handler */
+	nvme_change_ctrl_state(ctrl, NVME_CTRL_DELETING_NOIO);
+
 	down_write(&ctrl->namespaces_rwsem);
 	list_splice_init(&ctrl->namespaces, &ns_list);
 	up_write(&ctrl->namespaces_rwsem);
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 2a6c8190eeb76..4ec4829d62334 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -547,7 +547,7 @@ static struct nvmf_transport_ops *nvmf_lookup_transport(
 blk_status_t nvmf_fail_nonready_command(struct nvme_ctrl *ctrl,
 		struct request *rq)
 {
-	if (ctrl->state != NVME_CTRL_DELETING &&
+	if (ctrl->state != NVME_CTRL_DELETING_NOIO &&
 	    ctrl->state != NVME_CTRL_DEAD &&
 	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
 		return BLK_STS_RESOURCE;
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a0ec40ab62eeb..a9c1e3b4585ec 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -182,7 +182,8 @@ bool nvmf_ip_options_match(struct nvme_ctrl *ctrl,
 static inline bool nvmf_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 		bool queue_live)
 {
-	if (likely(ctrl->state == NVME_CTRL_LIVE))
+	if (likely(ctrl->state == NVME_CTRL_LIVE ||
+		   ctrl->state == NVME_CTRL_DELETING))
 		return true;
 	return __nvmf_check_ready(ctrl, rq, queue_live);
 }
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index e999a8c4b7e87..549f5b0fb0b4b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -825,6 +825,7 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
 		break;
 
 	case NVME_CTRL_DELETING:
+	case NVME_CTRL_DELETING_NOIO:
 	default:
 		/* no action to take - let it delete */
 		break;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 57d51148e71b6..2672953233434 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -167,9 +167,18 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 
 static bool nvme_path_is_disabled(struct nvme_ns *ns)
 {
-	return ns->ctrl->state != NVME_CTRL_LIVE ||
-		test_bit(NVME_NS_ANA_PENDING, &ns->flags) ||
-		test_bit(NVME_NS_REMOVING, &ns->flags);
+	/*
+	 * We don't treat NVME_CTRL_DELETING as a disabled path as I/O should
+	 * still be able to complete assuming that the controller is connected.
+	 * Otherwise it will fail immediately and return to the requeue list.
+	 */
+	if (ns->ctrl->state != NVME_CTRL_LIVE &&
+	    ns->ctrl->state != NVME_CTRL_DELETING)
+		return true;
+	if (test_bit(NVME_NS_ANA_PENDING, &ns->flags) ||
+	    test_bit(NVME_NS_REMOVING, &ns->flags))
+		return true;
+	return false;
 }
 
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
@@ -574,6 +583,9 @@ static void nvme_ana_work(struct work_struct *work)
 {
 	struct nvme_ctrl *ctrl = container_of(work, struct nvme_ctrl, ana_work);
 
+	if (ctrl->state != NVME_CTRL_LIVE)
+		return;
+
 	nvme_read_ana_log(ctrl);
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 09ffc3246f60e..e268f1d7e1a0f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -186,6 +186,7 @@ enum nvme_ctrl_state {
 	NVME_CTRL_RESETTING,
 	NVME_CTRL_CONNECTING,
 	NVME_CTRL_DELETING,
+	NVME_CTRL_DELETING_NOIO,
 	NVME_CTRL_DEAD,
 };
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index af0cfd25ed7a4..876859cd14e86 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1082,11 +1082,12 @@ static int nvme_rdma_setup_ctrl(struct nvme_rdma_ctrl *ctrl, bool new)
 	changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE);
 	if (!changed) {
 		/*
-		 * state change failure is ok if we're in DELETING state,
+		 * state change failure is ok if we started ctrl delete,
 		 * unless we're during creation of a new controller to
 		 * avoid races with teardown flow.
 		 */
-		WARN_ON_ONCE(ctrl->ctrl.state != NVME_CTRL_DELETING);
+		WARN_ON_ONCE(ctrl->ctrl.state != NVME_CTRL_DELETING &&
+			     ctrl->ctrl.state != NVME_CTRL_DELETING_NOIO);
 		WARN_ON_ONCE(new);
 		ret = -EINVAL;
 		goto destroy_io;
@@ -1139,8 +1140,9 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 	blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
-		/* state change failure is ok if we're in DELETING state */
-		WARN_ON_ONCE(ctrl->ctrl.state != NVME_CTRL_DELETING);
+		/* state change failure is ok if we started ctrl delete */
+		WARN_ON_ONCE(ctrl->ctrl.state != NVME_CTRL_DELETING &&
+			     ctrl->ctrl.state != NVME_CTRL_DELETING_NOIO);
 		return;
 	}
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 83bb329d4113a..a6d2e3330a584 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1929,11 +1929,12 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE)) {
 		/*
-		 * state change failure is ok if we're in DELETING state,
+		 * state change failure is ok if we started ctrl delete,
 		 * unless we're during creation of a new controller to
 		 * avoid races with teardown flow.
 		 */
-		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING);
+		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING &&
+			     ctrl->state != NVME_CTRL_DELETING_NOIO);
 		WARN_ON_ONCE(new);
 		ret = -EINVAL;
 		goto destroy_io;
@@ -1989,8 +1990,9 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	blk_mq_unquiesce_queue(ctrl->admin_q);
 
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING)) {
-		/* state change failure is ok if we're in DELETING state */
-		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING);
+		/* state change failure is ok if we started ctrl delete */
+		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING &&
+			     ctrl->state != NVME_CTRL_DELETING_NOIO);
 		return;
 	}
 
@@ -2025,8 +2027,9 @@ static void nvme_reset_ctrl_work(struct work_struct *work)
 	nvme_tcp_teardown_ctrl(ctrl, false);
 
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING)) {
-		/* state change failure is ok if we're in DELETING state */
-		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING);
+		/* state change failure is ok if we started ctrl delete */
+		WARN_ON_ONCE(ctrl->state != NVME_CTRL_DELETING &&
+			     ctrl->state != NVME_CTRL_DELETING_NOIO);
 		return;
 	}
 
-- 
2.25.1



