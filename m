Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63881F2F18
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgFIAre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgFHXLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34CD208C3;
        Mon,  8 Jun 2020 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657879;
        bh=das6OhBdoFhqMjLDChJE4xhaVUrZDwDw2noq6aBnmqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWxslYiKKuysdJI3DRFU/1/DPVWlOapTXLsjzOjT8QsK/c/Zm8KksVWnePQhjnSh+
         yRyva7P8Sn8WwY9hp7mGBVgABNBYAPLI83uhMJOETY1h4Vgwixgxu8Scn4wFuGcWl3
         UjEWhNOlJrsPD6miQEqB9GcPz5e9cbvwhVqIhBig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weiping Zhang <zhangweiping@didiglobal.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 236/274] nvme-pci: make sure write/poll_queues less or equal then cpu count
Date:   Mon,  8 Jun 2020 19:05:29 -0400
Message-Id: <20200608230607.3361041-236-sashal@kernel.org>
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

From: Weiping Zhang <zhangweiping@didiglobal.com>

[ Upstream commit 9c9e76d5792b121f10c3b8ddbb639617e49197f7 ]

Check module parameter write/poll_queues before using it to catch
too large values.

Reproducer:

modprobe -r nvme
modprobe nvme write_queues=`nproc`
echo $((`nproc`+1)) > /sys/module/nvme/parameters/write_queues
echo 1 > /sys/block/nvme0n1/device/reset_controller

[  657.069000] ------------[ cut here ]------------
[  657.069022] WARNING: CPU: 10 PID: 1163 at kernel/irq/affinity.c:390 irq_create_affinity_masks+0x47c/0x4a0
[  657.069056]  dm_region_hash dm_log dm_mod
[  657.069059] CPU: 10 PID: 1163 Comm: kworker/u193:9 Kdump: loaded Tainted: G        W         5.6.0+ #8
[  657.069060] Hardware name: Inspur SA5212M5/YZMB-00882-104, BIOS 4.0.9 08/27/2019
[  657.069064] Workqueue: nvme-reset-wq nvme_reset_work [nvme]
[  657.069066] RIP: 0010:irq_create_affinity_masks+0x47c/0x4a0
[  657.069067] Code: fe ff ff 48 c7 c0 b0 89 14 95 48 89 46 20 e9 e9 fb ff ff 31 c0 e9 90 fc ff ff 0f 0b 48 c7 44 24 08 00 00 00 00 e9 e9 fc ff ff <0f> 0b e9 87 fe ff ff 48 8b 7c 24 28 e8 33 a0 80 00 e9 b6 fc ff ff
[  657.069068] RSP: 0018:ffffb505ce1ffc78 EFLAGS: 00010202
[  657.069069] RAX: 0000000000000060 RBX: ffff9b97921fe5c0 RCX: 0000000000000000
[  657.069069] RDX: ffff9b67bad80000 RSI: 00000000ffffffa0 RDI: 0000000000000000
[  657.069070] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9b97921fe718
[  657.069070] R10: ffff9b97921fe710 R11: 0000000000000001 R12: 0000000000000064
[  657.069070] R13: 0000000000000060 R14: 0000000000000000 R15: 0000000000000001
[  657.069071] FS:  0000000000000000(0000) GS:ffff9b67c0880000(0000) knlGS:0000000000000000
[  657.069072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  657.069072] CR2: 0000559eac6fc238 CR3: 000000057860a002 CR4: 00000000007606e0
[  657.069073] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  657.069073] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  657.069073] PKRU: 55555554
[  657.069074] Call Trace:
[  657.069080]  __pci_enable_msix_range+0x233/0x5a0
[  657.069085]  ? kernfs_put+0xec/0x190
[  657.069086]  pci_alloc_irq_vectors_affinity+0xbb/0x130
[  657.069089]  nvme_reset_work+0x6e6/0xeab [nvme]
[  657.069093]  ? __switch_to_asm+0x34/0x70
[  657.069094]  ? __switch_to_asm+0x40/0x70
[  657.069095]  ? nvme_irq_check+0x30/0x30 [nvme]
[  657.069098]  process_one_work+0x1a7/0x370
[  657.069101]  worker_thread+0x1c9/0x380
[  657.069102]  ? max_active_store+0x80/0x80
[  657.069103]  kthread+0x112/0x130
[  657.069104]  ? __kthread_parkme+0x70/0x70
[  657.069105]  ret_from_fork+0x35/0x40
[  657.069106] ---[ end trace f4f06b7d24513d06 ]---
[  657.077110] nvme nvme0: 95/1/0 default/read/poll queues

Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index dcf597fbafad..076bdd90c922 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -68,14 +68,30 @@ static int io_queue_depth = 1024;
 module_param_cb(io_queue_depth, &io_queue_depth_ops, &io_queue_depth, 0644);
 MODULE_PARM_DESC(io_queue_depth, "set io queue depth, should >= 2");
 
+static int io_queue_count_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned int n;
+	int ret;
+
+	ret = kstrtouint(val, 10, &n);
+	if (ret != 0 || n > num_possible_cpus())
+		return -EINVAL;
+	return param_set_uint(val, kp);
+}
+
+static const struct kernel_param_ops io_queue_count_ops = {
+	.set = io_queue_count_set,
+	.get = param_get_uint,
+};
+
 static unsigned int write_queues;
-module_param(write_queues, uint, 0644);
+module_param_cb(write_queues, &io_queue_count_ops, &write_queues, 0644);
 MODULE_PARM_DESC(write_queues,
 	"Number of queues to use for writes. If not set, reads and writes "
 	"will share a queue set.");
 
 static unsigned int poll_queues;
-module_param(poll_queues, uint, 0644);
+module_param_cb(poll_queues, &io_queue_count_ops, &poll_queues, 0644);
 MODULE_PARM_DESC(poll_queues, "Number of queues to use for polled IO.");
 
 struct nvme_dev;
@@ -3140,8 +3156,6 @@ static int __init nvme_init(void)
 	BUILD_BUG_ON(sizeof(struct nvme_delete_queue) != 64);
 	BUILD_BUG_ON(IRQ_AFFINITY_MAX_SETS < 2);
 
-	write_queues = min(write_queues, num_possible_cpus());
-	poll_queues = min(poll_queues, num_possible_cpus());
 	return pci_register_driver(&nvme_driver);
 }
 
-- 
2.25.1

