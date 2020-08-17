Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8DD247037
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390263AbgHQSFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388493AbgHQQJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0D120825;
        Mon, 17 Aug 2020 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680548;
        bh=HtrwECE9RRqIGPmEeU67tmgCIP0aX5OUWwsFcsKoSl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8Tj9BkxSH5Vsf9D+QanTK7Q7K8NexG7Wq6TJl4o43BGs6kBOG/IWEStlsar31y8T
         U13upg7S/TMmaJVaWM2gl2n7AsuVIiOQvun/i7czPy+2UKSCs80l2aOuqZCTtlLP9Y
         TvhyBr0X0Tw33VXI0L2k6qCV47rf7ICv3DSceBbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/270] net/mlx5: Delete extra dump stack that gives nothing
Date:   Mon, 17 Aug 2020 17:16:41 +0200
Message-Id: <20200817143805.744794248@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 6c4e9bcfb48933d533ff975e152757991556294a ]

The WARN_*() macros are intended to catch impossible situations
from the SW point of view. They gave a little in case HW<->SW interface
is out-of-sync.

Such out-of-sync scenario can be due to SW errors that are not part
of this flow or because some HW errors, where dump stack won't help
either.

This specific WARN_ON() is useless because mlx5_core code is prepared
to handle such situations and will unfold everything correctly while
providing enough information to the users to understand why FS is not
working.

WARNING: CPU: 0 PID: 3222 at drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825 connect_fts_in_prio.isra.20+0x1dd/0x260 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 3222 Comm: syz-executor861 Not tainted 5.5.0-rc6+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack linux/lib/dump_stack.c:77 [inline]
 dump_stack+0x94/0xce linux/lib/dump_stack.c:118
 panic+0x234/0x56f linux/kernel/panic.c:221
 __warn+0x1cc/0x1e1 linux/kernel/panic.c:582
 report_bug+0x200/0x310 linux/lib/bug.c:195
 fixup_bug.part.11+0x32/0x80 linux/arch/x86/kernel/traps.c:174
 fixup_bug linux/arch/x86/kernel/traps.c:273 [inline]
 do_error_trap+0xd3/0x100 linux/arch/x86/kernel/traps.c:267
 do_invalid_op+0x31/0x40 linux/arch/x86/kernel/traps.c:286
 invalid_op+0x1e/0x30 linux/arch/x86/entry/entry_64.S:1027
RIP: 0010:connect_fts_in_prio.isra.20+0x1dd/0x260
linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825
Code: 00 00 48 c7 c2 60 8c 31 84 48 c7 c6 00 81 31 84 48 8b 38 e8 3c a8
cb ff 41 83 fd 01 8b 04 24 0f 8e 29 ff ff ff e8 83 7b bc fe <0f> 0b 8b
04 24 e9 1a ff ff ff 89 04 24 e8 c1 20 e0 fe 8b 04 24 eb
RSP: 0018:ffffc90004bb7858 EFLAGS: 00010293
RAX: ffff88805de98e80 RBX: 0000000000000c96 RCX: ffffffff827a853d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffff52000976efa
RBP: 0000000000000007 R08: ffffed100da060e3 R09: ffffed100da060e3
R10: 0000000000000001 R11: ffffed100da060e2 R12: dffffc0000000000
R13: 0000000000000002 R14: ffff8880683a1a10 R15: ffffed100d07bc1c
 connect_prev_fts linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:844 [inline]
 connect_flow_table linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:975 [inline]
 __mlx5_create_flow_table+0x8f8/0x1710 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1064
 mlx5_create_flow_table linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1094 [inline]
 mlx5_create_auto_grouped_flow_table+0xe1/0x210 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1136
 _get_prio linux/drivers/infiniband/hw/mlx5/main.c:3286 [inline]
 get_flow_table+0x2ea/0x760 linux/drivers/infiniband/hw/mlx5/main.c:3376
 mlx5_ib_create_flow+0x331/0x11c0 linux/drivers/infiniband/hw/mlx5/main.c:3896
 ib_uverbs_ex_create_flow+0x13e8/0x1b40 linux/drivers/infiniband/core/uverbs_cmd.c:3311
 ib_uverbs_write+0xaa5/0xdf0 linux/drivers/infiniband/core/uverbs_main.c:769
 __vfs_write+0x7c/0x100 linux/fs/read_write.c:494
 vfs_write+0x168/0x4a0 linux/fs/read_write.c:558
 ksys_write+0xc8/0x200 linux/fs/read_write.c:611
 do_syscall_64+0x9c/0x390 linux/arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a059
Code: 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcc17564c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fcc17564ca0 RCX: 000000000045a059
RDX: 0000000000000030 RSI: 00000000200003c0 RDI: 0000000000000005
RBP: 0000000000000007 R08: 0000000000000002 R09: 0000000000003131
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e636c
R13: 0000000000000000 R14: 00000000006e6360 R15: 00007ffdcbdaf6a0
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..

Fixes: f90edfd279f3 ("net/mlx5_core: Connect flow tables")
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 86e6bbb574829..b66e5b6eecd99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -809,18 +809,15 @@ static int connect_fts_in_prio(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_root_namespace *root = find_root(&prio->node);
 	struct mlx5_flow_table *iter;
-	int i = 0;
 	int err;
 
 	fs_for_each_ft(iter, prio) {
-		i++;
 		err = root->cmds->modify_flow_table(root, iter, ft);
 		if (err) {
-			mlx5_core_warn(dev, "Failed to modify flow table %d\n",
-				       iter->id);
+			mlx5_core_err(dev,
+				      "Failed to modify flow table id %d, type %d, err %d\n",
+				      iter->id, iter->type, err);
 			/* The driver is out of sync with the FW */
-			if (i > 1)
-				WARN_ON(true);
 			return err;
 		}
 	}
-- 
2.25.1



