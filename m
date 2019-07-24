Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059AC73F6D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387878AbfGXT3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387879AbfGXT3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:29:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E6A20659;
        Wed, 24 Jul 2019 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996547;
        bh=GbwFSE9q+957nr1wRPtDoqJZ+6x0B1v5YG3WGdg4DEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Ov05jU9yfvG3uzz8gLqhTj3Z9BTebdePoJaDrOn2UDNT5t6aRukAX1uUm6XvR7Ru
         CDujHTUDC8IvIQ6RWIhhiossCE87oocv5tdvcqB1ZSPpxx0bFlX/vvwd0Pc4V1L+c4
         SQtzugxEILoIWfj5qFuON6JLljqYMWHRmdSnQKk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 136/413] nvme-pci: adjust irq max_vector using num_possible_cpus()
Date:   Wed, 24 Jul 2019 21:17:07 +0200
Message-Id: <20190724191744.767411182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dad77d63903e91a2e97a0c984cabe5d36e91ba60 ]

If the "irq_queues" are greater than num_possible_cpus(),
nvme_calc_irq_sets() can have irq set_size for HCTX_TYPE_DEFAULT greater
than it can be afforded.
2039         affd->set_size[HCTX_TYPE_DEFAULT] = nrirqs - nr_read_queues;

It might cause a WARN() from the irq_build_affinity_masks() like [1]:
220         if (nr_present < numvecs)
221                 WARN_ON(nr_present + nr_others < numvecs);

This patch prevents it from the WARN() by adjusting the max_vector value
from the nvme_setup_irqs().

[1] WARN messages when modprobe nvme write_queues=32 poll_queues=0:
root@target:~/nvme# nproc
8
root@target:~/nvme# modprobe nvme write_queues=32 poll_queues=0
[   17.925326] nvme nvme0: pci function 0000:00:04.0
[   17.940601] WARNING: CPU: 3 PID: 1030 at kernel/irq/affinity.c:221 irq_create_affinity_masks+0x222/0x330
[   17.940602] Modules linked in: nvme nvme_core [last unloaded: nvme]
[   17.940605] CPU: 3 PID: 1030 Comm: kworker/u17:4 Tainted: G        W         5.1.0+ #156
[   17.940605] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   17.940608] Workqueue: nvme-reset-wq nvme_reset_work [nvme]
[   17.940609] RIP: 0010:irq_create_affinity_masks+0x222/0x330
[   17.940611] Code: 4c 8d 4c 24 28 4c 8d 44 24 30 e8 c9 fa ff ff 89 44 24 18 e8 c0 38 fa ff 8b 44 24 18 44 8b 54 24 1c 5a 44 01 d0 41 39 c4 76 02 <0f> 0b 48 89 df 44 01 e5 e8 f1 ce 10 00 48 8b 34 24 44 89 f0 44 01
[   17.940611] RSP: 0018:ffffc90002277c50 EFLAGS: 00010216
[   17.940612] RAX: 0000000000000008 RBX: ffff88807ca48860 RCX: 0000000000000000
[   17.940612] RDX: ffff88807bc03800 RSI: 0000000000000020 RDI: 0000000000000000
[   17.940613] RBP: 0000000000000001 R08: ffffc90002277c78 R09: ffffc90002277c70
[   17.940613] R10: 0000000000000008 R11: 0000000000000001 R12: 0000000000000020
[   17.940614] R13: 0000000000025d08 R14: 0000000000000001 R15: ffff88807bc03800
[   17.940614] FS:  0000000000000000(0000) GS:ffff88807db80000(0000) knlGS:0000000000000000
[   17.940616] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.940617] CR2: 00005635e583f790 CR3: 000000000240a000 CR4: 00000000000006e0
[   17.940617] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.940618] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   17.940618] Call Trace:
[   17.940622]  __pci_enable_msix_range+0x215/0x540
[   17.940623]  ? kernfs_put+0x117/0x160
[   17.940625]  pci_alloc_irq_vectors_affinity+0x74/0x110
[   17.940626]  nvme_reset_work+0xc30/0x1397 [nvme]
[   17.940628]  ? __switch_to_asm+0x34/0x70
[   17.940628]  ? __switch_to_asm+0x40/0x70
[   17.940629]  ? __switch_to_asm+0x34/0x70
[   17.940630]  ? __switch_to_asm+0x40/0x70
[   17.940630]  ? __switch_to_asm+0x34/0x70
[   17.940631]  ? __switch_to_asm+0x40/0x70
[   17.940632]  ? nvme_irq_check+0x30/0x30 [nvme]
[   17.940633]  process_one_work+0x20b/0x3e0
[   17.940634]  worker_thread+0x1f9/0x3d0
[   17.940635]  ? cancel_delayed_work+0xa0/0xa0
[   17.940636]  kthread+0x117/0x120
[   17.940637]  ? kthread_stop+0xf0/0xf0
[   17.940638]  ret_from_fork+0x3a/0x50
[   17.940639] ---[ end trace aca8a131361cd42a ]---
[   17.942124] nvme nvme0: 7/1/0 default/read/poll queues

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 544d095d44e5..f5bc1c30cef5 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2068,6 +2068,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		.priv		= dev,
 	};
 	unsigned int irq_queues, this_p_queues;
+	unsigned int nr_cpus = num_possible_cpus();
 
 	/*
 	 * Poll queues don't need interrupts, but we need at least one IO
@@ -2078,7 +2079,10 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		this_p_queues = nr_io_queues - 1;
 		irq_queues = 1;
 	} else {
-		irq_queues = nr_io_queues - this_p_queues + 1;
+		if (nr_cpus < nr_io_queues - this_p_queues)
+			irq_queues = nr_cpus + 1;
+		else
+			irq_queues = nr_io_queues - this_p_queues + 1;
 	}
 	dev->io_queues[HCTX_TYPE_POLL] = this_p_queues;
 
-- 
2.20.1



