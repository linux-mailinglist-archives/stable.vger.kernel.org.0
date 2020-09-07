Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222E32600F0
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbgIGQzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbgIGQeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5100521789;
        Mon,  7 Sep 2020 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496447;
        bh=RhaPA3pQ7SyixbQGjlkGEpmSUuwz4jFNd4JEmU/aJ1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SE4TbfSA189fiwdKL7wdadn22xtIyjz79v9C1UO80FaV9RTF+EnQ+49ZBDOXZcZKV
         p5R0BNAOgnh8rWLgX8AmLtC7iYbaJQdrbjjnhiWu8vQjjCtllBwkL1hFt36vOB0ScL
         Iy9oduxd0pNOZJzfCZcyTk52Uj9vCee/6/JcZK1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 29/43] nvme-pci: cancel nvme device request before disabling
Date:   Mon,  7 Sep 2020 12:33:15 -0400
Message-Id: <20200907163329.1280888-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 7ad92f656bddff4cf8f641e0e3b1acd4eb9644cb ]

This patch addresses an irq free warning and null pointer dereference
error problem when nvme devices got timeout error during initialization.
This problem happens when nvme_timeout() function is called while
nvme_reset_work() is still in execution. This patch fixed the problem by
setting flag of the problematic request to NVME_REQ_CANCELLED before
calling nvme_dev_disable() to make sure __nvme_submit_sync_cmd() returns
an error code and let nvme_submit_sync_cmd() fail gracefully.
The following is console output.

[   62.472097] nvme nvme0: I/O 13 QID 0 timeout, disable controller
[   62.488796] nvme nvme0: could not set timestamp (881)
[   62.494888] ------------[ cut here ]------------
[   62.495142] Trying to free already-free IRQ 11
[   62.495366] WARNING: CPU: 0 PID: 7 at kernel/irq/manage.c:1751 free_irq+0x1f7/0x370
[   62.495742] Modules linked in:
[   62.495902] CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.8.0+ #8
[   62.496206] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-gd9c812dda519-p4
[   62.496772] Workqueue: nvme-reset-wq nvme_reset_work
[   62.497019] RIP: 0010:free_irq+0x1f7/0x370
[   62.497223] Code: e8 ce 49 11 00 48 83 c4 08 4c 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 44 89 f6 48 c70
[   62.498133] RSP: 0000:ffffa96800043d40 EFLAGS: 00010086
[   62.498391] RAX: 0000000000000000 RBX: ffff9b87fc458400 RCX: 0000000000000000
[   62.498741] RDX: 0000000000000001 RSI: 0000000000000096 RDI: ffffffff9693d72c
[   62.499091] RBP: ffff9b87fd4c8f60 R08: ffffa96800043bfd R09: 0000000000000163
[   62.499440] R10: ffffa96800043bf8 R11: ffffa96800043bfd R12: ffff9b87fd4c8e00
[   62.499790] R13: ffff9b87fd4c8ea4 R14: 000000000000000b R15: ffff9b87fd76b000
[   62.500140] FS:  0000000000000000(0000) GS:ffff9b87fdc00000(0000) knlGS:0000000000000000
[   62.500534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.500816] CR2: 0000000000000000 CR3: 000000003aa0a000 CR4: 00000000000006f0
[   62.501165] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   62.501515] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   62.501864] Call Trace:
[   62.501993]  pci_free_irq+0x13/0x20
[   62.502167]  nvme_reset_work+0x5d0/0x12a0
[   62.502369]  ? update_load_avg+0x59/0x580
[   62.502569]  ? ttwu_queue_wakelist+0xa8/0xc0
[   62.502780]  ? try_to_wake_up+0x1a2/0x450
[   62.502979]  process_one_work+0x1d2/0x390
[   62.503179]  worker_thread+0x45/0x3b0
[   62.503361]  ? process_one_work+0x390/0x390
[   62.503568]  kthread+0xf9/0x130
[   62.503726]  ? kthread_park+0x80/0x80
[   62.503911]  ret_from_fork+0x22/0x30
[   62.504090] ---[ end trace de9ed4a70f8d71e2 ]---
[  123.912275] nvme nvme0: I/O 12 QID 0 timeout, disable controller
[  123.914670] nvme nvme0: 1/0/0 default/read/poll queues
[  123.916310] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  123.917469] #PF: supervisor write access in kernel mode
[  123.917725] #PF: error_code(0x0002) - not-present page
[  123.917976] PGD 0 P4D 0
[  123.918109] Oops: 0002 [#1] SMP PTI
[  123.918283] CPU: 0 PID: 7 Comm: kworker/u4:0 Tainted: G        W         5.8.0+ #8
[  123.918650] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-gd9c812dda519-p4
[  123.919219] Workqueue: nvme-reset-wq nvme_reset_work
[  123.919469] RIP: 0010:__blk_mq_alloc_map_and_request+0x21/0x80
[  123.919757] Code: 66 0f 1f 84 00 00 00 00 00 41 55 41 54 55 48 63 ee 53 48 8b 47 68 89 ee 48 89 fb 8b4
[  123.920657] RSP: 0000:ffffa96800043d40 EFLAGS: 00010286
[  123.920912] RAX: ffff9b87fc4fee40 RBX: ffff9b87fc8cb008 RCX: 0000000000000000
[  123.921258] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9b87fc618000
[  123.921602] RBP: 0000000000000000 R08: ffff9b87fdc2c4a0 R09: ffff9b87fc616000
[  123.921949] R10: 0000000000000000 R11: ffff9b87fffd1500 R12: 0000000000000000
[  123.922295] R13: 0000000000000000 R14: ffff9b87fc8cb200 R15: ffff9b87fc8cb000
[  123.922641] FS:  0000000000000000(0000) GS:ffff9b87fdc00000(0000) knlGS:0000000000000000
[  123.923032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  123.923312] CR2: 0000000000000000 CR3: 000000003aa0a000 CR4: 00000000000006f0
[  123.923660] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  123.924007] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  123.924353] Call Trace:
[  123.924479]  blk_mq_alloc_tag_set+0x137/0x2a0
[  123.924694]  nvme_reset_work+0xed6/0x12a0
[  123.924898]  process_one_work+0x1d2/0x390
[  123.925099]  worker_thread+0x45/0x3b0
[  123.925280]  ? process_one_work+0x390/0x390
[  123.925486]  kthread+0xf9/0x130
[  123.925642]  ? kthread_park+0x80/0x80
[  123.925825]  ret_from_fork+0x22/0x30
[  123.926004] Modules linked in:
[  123.926158] CR2: 0000000000000000
[  123.926322] ---[ end trace de9ed4a70f8d71e3 ]---
[  123.926549] RIP: 0010:__blk_mq_alloc_map_and_request+0x21/0x80
[  123.926832] Code: 66 0f 1f 84 00 00 00 00 00 41 55 41 54 55 48 63 ee 53 48 8b 47 68 89 ee 48 89 fb 8b4
[  123.927734] RSP: 0000:ffffa96800043d40 EFLAGS: 00010286
[  123.927989] RAX: ffff9b87fc4fee40 RBX: ffff9b87fc8cb008 RCX: 0000000000000000
[  123.928336] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9b87fc618000
[  123.928679] RBP: 0000000000000000 R08: ffff9b87fdc2c4a0 R09: ffff9b87fc616000
[  123.929025] R10: 0000000000000000 R11: ffff9b87fffd1500 R12: 0000000000000000
[  123.929370] R13: 0000000000000000 R14: ffff9b87fc8cb200 R15: ffff9b87fc8cb000
[  123.929715] FS:  0000000000000000(0000) GS:ffff9b87fdc00000(0000) knlGS:0000000000000000
[  123.930106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  123.930384] CR2: 0000000000000000 CR3: 000000003aa0a000 CR4: 00000000000006f0
[  123.930731] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  123.931077] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Co-developed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 100da11ce98cb..a91433bdf5de4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1274,8 +1274,8 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		dev_warn_ratelimited(dev->ctrl.device,
 			 "I/O %d QID %d timeout, disable controller\n",
 			 req->tag, nvmeq->qid);
-		nvme_dev_disable(dev, true);
 		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
+		nvme_dev_disable(dev, true);
 		return BLK_EH_DONE;
 	case NVME_CTRL_RESETTING:
 		return BLK_EH_RESET_TIMER;
@@ -1292,10 +1292,10 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, reset controller\n",
 			 req->tag, nvmeq->qid);
+		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 		nvme_dev_disable(dev, false);
 		nvme_reset_ctrl(&dev->ctrl);
 
-		nvme_req(req)->flags |= NVME_REQ_CANCELLED;
 		return BLK_EH_DONE;
 	}
 
-- 
2.25.1

