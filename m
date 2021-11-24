Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6677945C377
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348191AbhKXNjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348362AbhKXNgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:36:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FE9E61163;
        Wed, 24 Nov 2021 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758506;
        bh=mLLOdVqp9BVzsR5n4S2a89FniUEsr/RLzmlak0Ml2Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Etq5d2IvHcwZOW4Z5cH5t+eK9uH4FL8+GCmu+i7stxO3vgptk90gb/lHJYu8uMX8W
         R6Drsm0dqSKVJ0f5Jd8Rz1xkzwXrEPCSWgzqKsPilmzDyXW7gGfnLyxYG5SKpRre5o
         y0GMVYzqHMURKyde0nJairmo0I/bOtd/dTcnnbTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentine Fatiev <valentinef@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/154] net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()
Date:   Wed, 24 Nov 2021 12:58:08 +0100
Message-Id: <20211124115705.283054594@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentine Fatiev <valentinef@nvidia.com>

[ Upstream commit 76ded29d3fcda4928da8849ffc446ea46871c1c2 ]

Prior to this patch in case mlx5_core_destroy_cq() failed it proceeds
to rest of destroy operations. mlx5_core_destroy_cq() could be called again
by user and cause additional call of mlx5_debug_cq_remove().
cq->dbg was not nullify in previous call and cause the crash.

Fix it by nullify cq->dbg pointer after removal.

Also proceed to destroy operations only if FW return 0
for MLX5_CMD_OP_DESTROY_CQ command.

general protection fault, probably for non-canonical address 0x2000300004058: 0000 [#1] SMP PTI
CPU: 5 PID: 1228 Comm: python Not tainted 5.15.0-rc5_for_upstream_min_debug_2021_10_14_11_06 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:lockref_get+0x1/0x60
Code: 5d e9 53 ff ff ff 48 8d 7f 70 e8 0a 2e 48 00 c7 85 d0 00 00 00 02
00 00 00 c6 45 70 00 fb 5d c3 c3 cc cc cc cc cc cc cc cc 53 <48> 8b 17
48 89 fb 85 d2 75 3d 48 89 d0 bf 64 00 00 00 48 89 c1 48
RSP: 0018:ffff888137dd7a38 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff888107d5f458 RCX: 00000000fffffffe
RDX: 000000000002c2b0 RSI: ffffffff8155e2e0 RDI: 0002000300004058
RBP: ffff888137dd7a88 R08: 0002000300004058 R09: ffff8881144a9f88
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881141d4000
R13: ffff888137dd7c68 R14: ffff888137dd7d58 R15: ffff888137dd7cc0
FS:  00007f4644f2a4c0(0000) GS:ffff8887a2d40000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b4500f4380 CR3: 0000000114f7a003 CR4: 0000000000170ea0
Call Trace:
  simple_recursive_removal+0x33/0x2e0
  ? debugfs_remove+0x60/0x60
  debugfs_remove+0x40/0x60
  mlx5_debug_cq_remove+0x32/0x70 [mlx5_core]
  mlx5_core_destroy_cq+0x41/0x1d0 [mlx5_core]
  devx_obj_cleanup+0x151/0x330 [mlx5_ib]
  ? __pollwait+0xd0/0xd0
  ? xas_load+0x5/0x70
  ? xa_load+0x62/0xa0
  destroy_hw_idr_uobject+0x20/0x80 [ib_uverbs]
  uverbs_destroy_uobject+0x3b/0x360 [ib_uverbs]
  uobj_destroy+0x54/0xa0 [ib_uverbs]
  ib_uverbs_cmd_verbs+0xaf2/0x1160 [ib_uverbs]
  ? uverbs_finalize_object+0xd0/0xd0 [ib_uverbs]
  ib_uverbs_ioctl+0xc4/0x1b0 [ib_uverbs]
  __x64_sys_ioctl+0x3e4/0x8e0

Fixes: 94b960b9deff ("net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path")
Signed-off-by: Valentine Fatiev <valentinef@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c      | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index c74600be570ed..68d7ca17b6f51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -163,13 +163,14 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
 	MLX5_SET(destroy_cq_in, in, uid, cq->uid);
 	err = mlx5_cmd_exec_in(dev, destroy_cq, in);
+	if (err)
+		return err;
 
 	synchronize_irq(cq->irqn);
-
 	mlx5_cq_put(cq);
 	wait_for_completion(&cq->free);
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(mlx5_core_destroy_cq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 07c8d9811bc81..10d195042ab55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -507,6 +507,8 @@ void mlx5_debug_cq_remove(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	if (!mlx5_debugfs_root)
 		return;
 
-	if (cq->dbg)
+	if (cq->dbg) {
 		rem_res_tree(cq->dbg);
+		cq->dbg = NULL;
+	}
 }
-- 
2.33.0



