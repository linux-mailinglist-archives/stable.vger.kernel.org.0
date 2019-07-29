Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559C179683
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403886AbfG2Twg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403919AbfG2Twg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:52:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465ED2054F;
        Mon, 29 Jul 2019 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429954;
        bh=+AqUrKWdD/ay7yu36QErOkU0etcy6dGyv1wPIewcWHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSanJTWhBT3JU6JoEO8CRA87v+iEB7T6Vkdmlerr9MhiH5OPRynzYi7J8FSM/bYDY
         Jd7rrQ5yB7ACT7yoi3nsHGrAEZRcLoTjT6Gcnm5W59xNnqFH/tkik5rZxivouBgABX
         88VHGaodejcsFwpe0zXJUO5AOK7JvuMglBqXkYkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Minwoo Im <minwoo.im.dev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 148/215] nvme: fix NULL deref for fabrics options
Date:   Mon, 29 Jul 2019 21:22:24 +0200
Message-Id: <20190729190805.379549208@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7d30c81b80ea9b0812d27030a46a5bf4c4e328f5 ]

git://git.infradead.org/nvme.git nvme-5.3 branch now causes the
following NULL deref oops.  Check the ctrl->opts first before the deref.

[   16.337581] BUG: kernel NULL pointer dereference, address: 0000000000000056
[   16.338551] #PF: supervisor read access in kernel mode
[   16.338551] #PF: error_code(0x0000) - not-present page
[   16.338551] PGD 0 P4D 0
[   16.338551] Oops: 0000 [#1] SMP PTI
[   16.338551] CPU: 2 PID: 1035 Comm: kworker/u16:5 Not tainted 5.2.0-rc6+ #1
[   16.338551] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
[   16.338551] Workqueue: nvme-wq nvme_scan_work [nvme_core]
[   16.338551] RIP: 0010:nvme_validate_ns+0xc9/0x7e0 [nvme_core]
[   16.338551] Code: c0 49 89 c5 0f 84 00 07 00 00 48 8b 7b 58 e8 be 48 39 c1 48 3d 00 f0 ff ff 49 89 45 18 0f 87 a4 06 00 00 48 8b 93 70 0a 00 00 <80> 7a 56 00 74 0c 48 8b 40 68 83 48 3c 08 49 8b 45 18 48 89 c6 bf
[   16.338551] RSP: 0018:ffffc900024c7d10 EFLAGS: 00010283
[   16.338551] RAX: ffff888135a30720 RBX: ffff88813a4fd1f8 RCX: 0000000000000007
[   16.338551] RDX: 0000000000000000 RSI: ffffffff8256dd38 RDI: ffff888135a30720
[   16.338551] RBP: 0000000000000001 R08: 0000000000000007 R09: ffff88813aa6a840
[   16.338551] R10: 0000000000000001 R11: 000000000002d060 R12: ffff88813a4fd1f8
[   16.338551] R13: ffff88813a77f800 R14: ffff88813aa35180 R15: 0000000000000001
[   16.338551] FS:  0000000000000000(0000) GS:ffff88813ba80000(0000) knlGS:0000000000000000
[   16.338551] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.338551] CR2: 0000000000000056 CR3: 000000000240a002 CR4: 0000000000360ee0
[   16.338551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.338551] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   16.338551] Call Trace:
[   16.338551]  nvme_scan_work+0x2c0/0x340 [nvme_core]
[   16.338551]  ? __switch_to_asm+0x40/0x70
[   16.338551]  ? _raw_spin_unlock_irqrestore+0x18/0x30
[   16.338551]  ? try_to_wake_up+0x408/0x450
[   16.338551]  process_one_work+0x20b/0x3e0
[   16.338551]  worker_thread+0x1f9/0x3d0
[   16.338551]  ? cancel_delayed_work+0xa0/0xa0
[   16.338551]  kthread+0x117/0x120
[   16.338551]  ? kthread_stop+0xf0/0xf0
[   16.338551]  ret_from_fork+0x3a/0x50
[   16.338551] Modules linked in: nvme nvme_core
[   16.338551] CR2: 0000000000000056
[   16.338551] ---[ end trace b9bf761a93e62d84 ]---
[   16.338551] RIP: 0010:nvme_validate_ns+0xc9/0x7e0 [nvme_core]
[   16.338551] Code: c0 49 89 c5 0f 84 00 07 00 00 48 8b 7b 58 e8 be 48 39 c1 48 3d 00 f0 ff ff 49 89 45 18 0f 87 a4 06 00 00 48 8b 93 70 0a 00 00 <80> 7a 56 00 74 0c 48 8b 40 68 83 48 3c 08 49 8b 45 18 48 89 c6 bf
[   16.338551] RSP: 0018:ffffc900024c7d10 EFLAGS: 00010283
[   16.338551] RAX: ffff888135a30720 RBX: ffff88813a4fd1f8 RCX: 0000000000000007
[   16.338551] RDX: 0000000000000000 RSI: ffffffff8256dd38 RDI: ffff888135a30720
[   16.338551] RBP: 0000000000000001 R08: 0000000000000007 R09: ffff88813aa6a840
[   16.338551] R10: 0000000000000001 R11: 000000000002d060 R12: ffff88813a4fd1f8
[   16.338551] R13: ffff88813a77f800 R14: ffff88813aa35180 R15: 0000000000000001
[   16.338551] FS:  0000000000000000(0000) GS:ffff88813ba80000(0000) knlGS:0000000000000000
[   16.338551] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.338551] CR2: 0000000000000056 CR3: 000000000240a002 CR4: 0000000000360ee0
[   16.338551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.338551] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 958f2a0f8121 ("nvme-tcp: set the STABLE_WRITES flag when data digests are enabled")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 215bef904b7b..4a1d2ab4d161 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3257,7 +3257,7 @@ static int nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 		goto out_free_ns;
 	}
 
-	if (ctrl->opts->data_digest)
+	if (ctrl->opts && ctrl->opts->data_digest)
 		ns->queue->backing_dev_info->capabilities
 			|= BDI_CAP_STABLE_WRITES;
 
-- 
2.20.1



