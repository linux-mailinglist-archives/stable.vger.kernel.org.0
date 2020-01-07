Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DD9133145
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgAGU7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgAGU7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CABB4214D8;
        Tue,  7 Jan 2020 20:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430756;
        bh=7h6wTwiJ2begePAr4ik0cVNuBQz3xLHltNZ7KwOMq7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBBGQO5g7VabpPSj9qwHhRkCzXdcShWYXKDxZJAk88UvsPtWmZvYJJ6CBo49JdR3c
         WkVrTqQjNG/gmjeE7bh9UoJgi3JYwJDpJCaPwhqOJ1/Dt1FXQm6/1CGgr1gXF4JXli
         DReUF09noRZyzsjvHMoR7lVuB4wW1QG79ZcvIRso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Ido Kalir <idok@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/191] RDMA/counter: Prevent auto-binding a QP which are not tracked with res
Date:   Tue,  7 Jan 2020 21:52:47 +0100
Message-Id: <20200107205335.511134640@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit 33df2f1929df4a1cb13303e344fbf8a75f0dc41f ]

Some QPs (e.g. XRC QP) are not tracked in kernel, in this case they have
an invalid res and should not be bound to any dynamically-allocated
counter in auto mode.

This fixes below call trace:
BUG: kernel NULL pointer dereference, address: 0000000000000390
PGD 80000001a7233067 P4D 80000001a7233067 PUD 1a7215067 PMD 0
Oops: 0000 [#1] SMP PTI
CPU: 2 PID: 24822 Comm: ibv_xsrq_pingpo Not tainted 5.4.0-rc5+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
RIP: 0010:rdma_counter_bind_qp_auto+0x142/0x270 [ib_core]
Code: e1 48 85 c0 48 89 c2 0f 84 bc 00 00 00 49 8b 06 48 39 42 48 75 d6 40 3a aa 90 00 00 00 75 cd 49 8b 86 00 01 00 00 48 8b 4a 28 <8b> 80 90 03 00 00 39 81 90 03 00 00 75 b4 85 c0 74 b0 48 8b 04 24
RSP: 0018:ffffc900003f39c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88820020ec00 RSI: 0000000000000004 RDI: ffffffffffffffc0
RBP: 0000000000000001 R08: ffff888224149ff0 R09: ffffc900003f3968
R10: ffffffffffffffff R11: ffff8882249c5848 R12: ffffffffffffffff
R13: ffff88821d5aca50 R14: ffff8881f7690800 R15: ffff8881ff890000
FS:  00007fe53a3e1740(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000390 CR3: 00000001a7292006 CR4: 00000000003606a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 _ib_modify_qp+0x3a4/0x3f0 [ib_core]
 ? lookup_get_idr_uobject.part.8+0x23/0x40 [ib_uverbs]
 modify_qp+0x322/0x3e0 [ib_uverbs]
 ib_uverbs_modify_qp+0x43/0x70 [ib_uverbs]
 ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xb1/0xf0 [ib_uverbs]
 ib_uverbs_run_method+0x6be/0x760 [ib_uverbs]
 ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x18d/0x3a0 [ib_uverbs]
 ? get_acl+0x1a/0x120
 ? __alloc_pages_nodemask+0x15d/0x2c0
 ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
 do_vfs_ioctl+0xa5/0x610
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x48/0x110
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 99fa331dc862 ("RDMA/counter: Add "auto" configuration mode support")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20191212091214.315005-2-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 680ad27f497d..023478107f0e 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -282,6 +282,9 @@ int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
 	struct rdma_counter *counter;
 	int ret;
 
+	if (!qp->res.valid)
+		return 0;
+
 	if (!rdma_is_port_valid(dev, port))
 		return -EINVAL;
 
-- 
2.20.1



