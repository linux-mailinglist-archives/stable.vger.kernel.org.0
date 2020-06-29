Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7372620D92C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgF2TpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbgF2Tkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78D3248CF;
        Mon, 29 Jun 2020 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444427;
        bh=dwI23tYRJr8NZdszrh7dwuA5rCvVT6FR0p9deqTAc1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIJuwKqmKKCnCriytMkJ9fl8GWMJBuHcnEsCQ0wzHBd3+RKXIelTA7iOhMjVjxnYM
         4fXrS8pucqoUS5AMzinzcDEGa0PoqE4/g/tjrzMBVM455ptdSdi4ys+UeeRRbHG602
         hezalGaKawinUt21u0hNmLA8Kj3xlOup3rzfxwK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/178] nvme: fix possible deadlock when I/O is blocked
Date:   Mon, 29 Jun 2020 11:24:10 -0400
Message-Id: <20200629152523.2494198-106-sashal@kernel.org>
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

[ Upstream commit 3b4b19721ec652ad2c4fe51dfbe5124212b5f581 ]

Revert fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
in nvme_validate_ns")

When adding a new namespace to the head disk (via nvme_mpath_set_live)
we will see partition scan which triggers I/O on the mpath device node.
This process will usually be triggered from the scan_work which holds
the scan_lock. If I/O blocks (if we got ana change currently have only
available paths but none are accessible) this can deadlock on the head
disk bd_mutex as both partition scan I/O takes it, and head disk revalidation
takes it to check for resize (also triggered from scan_work on a different
path). See trace [1].

The mpath disk revalidation was originally added to detect online disk
size change, but this is no longer needed since commit cb224c3af4df
("nvme: Convert to use set_capacity_revalidate_and_notify") which already
updates resize info without unnecessarily revalidating the disk (the
mpath disk doesn't even implement .revalidate_disk fop).

[1]:
--
kernel: INFO: task kworker/u65:9:494 blocked for more than 241 seconds.
kernel:       Tainted: G           OE     5.3.5-050305-generic #201910071830
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: kworker/u65:9   D    0   494      2 0x80004000
kernel: Workqueue: nvme-wq nvme_scan_work [nvme_core]
kernel: Call Trace:
kernel:  __schedule+0x2b9/0x6c0
kernel:  schedule+0x42/0xb0
kernel:  schedule_preempt_disabled+0xe/0x10
kernel:  __mutex_lock.isra.0+0x182/0x4f0
kernel:  __mutex_lock_slowpath+0x13/0x20
kernel:  mutex_lock+0x2e/0x40
kernel:  revalidate_disk+0x63/0xa0
kernel:  __nvme_revalidate_disk+0xfe/0x110 [nvme_core]
kernel:  nvme_revalidate_disk+0xa4/0x160 [nvme_core]
kernel:  ? evict+0x14c/0x1b0
kernel:  revalidate_disk+0x2b/0xa0
kernel:  nvme_validate_ns+0x49/0x940 [nvme_core]
kernel:  ? blk_mq_free_request+0xd2/0x100
kernel:  ? __nvme_submit_sync_cmd+0xbe/0x1e0 [nvme_core]
kernel:  nvme_scan_work+0x24f/0x380 [nvme_core]
kernel:  process_one_work+0x1db/0x380
kernel:  worker_thread+0x249/0x400
kernel:  kthread+0x104/0x140
kernel:  ? process_one_work+0x380/0x380
kernel:  ? kthread_park+0x80/0x80
kernel:  ret_from_fork+0x1f/0x40
...
kernel: INFO: task kworker/u65:1:2630 blocked for more than 241 seconds.
kernel:       Tainted: G           OE     5.3.5-050305-generic #201910071830
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: kworker/u65:1   D    0  2630      2 0x80004000
kernel: Workqueue: nvme-wq nvme_scan_work [nvme_core]
kernel: Call Trace:
kernel:  __schedule+0x2b9/0x6c0
kernel:  schedule+0x42/0xb0
kernel:  io_schedule+0x16/0x40
kernel:  do_read_cache_page+0x438/0x830
kernel:  ? __switch_to_asm+0x34/0x70
kernel:  ? file_fdatawait_range+0x30/0x30
kernel:  read_cache_page+0x12/0x20
kernel:  read_dev_sector+0x27/0xc0
kernel:  read_lba+0xc1/0x220
kernel:  ? kmem_cache_alloc_trace+0x19c/0x230
kernel:  efi_partition+0x1e6/0x708
kernel:  ? vsnprintf+0x39e/0x4e0
kernel:  ? snprintf+0x49/0x60
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
kernel:  ? nvme_update_ns_ana_state+0x60/0x60 [nvme_core]
kernel:  nvme_mpath_add_disk+0x47/0x90 [nvme_core]
kernel:  nvme_validate_ns+0x396/0x940 [nvme_core]
kernel:  ? blk_mq_free_request+0xd2/0x100
kernel:  nvme_scan_work+0x24f/0x380 [nvme_core]
kernel:  process_one_work+0x1db/0x380
kernel:  worker_thread+0x249/0x400
kernel:  kthread+0x104/0x140
kernel:  ? process_one_work+0x380/0x380
kernel:  ? kthread_park+0x80/0x80
kernel:  ret_from_fork+0x1f/0x40
--

Fixes: fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
in nvme_validate_ns")
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d4b388793f40d..c44c00b9e1d85 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1870,7 +1870,6 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
-		revalidate_disk(ns->head->disk);
 	}
 #endif
 }
-- 
2.25.1

