Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6EC3C546E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348832AbhGLH6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348134AbhGLH4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3CC613D9;
        Mon, 12 Jul 2021 07:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076337;
        bh=0xihpmTW37Dpq4DgufJQRFS/DZYpE4Dh38gzeVHj5fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWUKPctpVAS05O3b4IOilbKBfBTI97Y6ghShxeiwebJ9c8K8MKY5I15pi6J4GgzJL
         U51t+0NiSzCI7lSYbfh7oIqe3jdAToXQ0H7ZzgRCCXmEyTHy1AliiK6yB7P2oUxk9k
         PEg9I020m7dk9es0bLQ5UgbdwN1Ai6DcECrvsKnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Aveksis <itayav@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 599/800] RDMA/mlx5: Dont access NULL-cleared mpi pointer
Date:   Mon, 12 Jul 2021 08:10:22 +0200
Message-Id: <20210712061031.071364321@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 4a754d7637026b42b0c9ba5787ad5ee3bc2ff77f ]

The "dev->port[i].mp.mpi" is set to NULL during mlx5_ib_unbind_slave_port()
execution, however that field is needed to add device to unaffiliated list.

Such flow causes to the following kernel panic while unloading mlx5_ib
module in multi-port mode, hence the device should be added to the list
prior to unbind call.

 RPC: Unregistered rdma transport module.
 RPC: Unregistered rdma backchannel transport module.
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: 0002 [#1] SMP NOPTI
 CPU: 4 PID: 1904 Comm: modprobe Not tainted 5.13.0-rc7_for_upstream_min_debug_2021_06_24_12_08 #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:mlx5_ib_cleanup_multiport_master+0x18b/0x2d0 [mlx5_ib]
 Code: 00 04 0f 85 c4 00 00 00 48 89 df e8 ef fa ff ff 48 8b 83 40 0d 00 00 48 8b 15 b9 e8 05 00 4a 8b 44 28 20 48 89 05 ad e8 05 00 <48> c7 00 d0 57 c5 a0 48 89 50 08 48 89 02 39 ab 88 0a 00 00 0f 86
 RSP: 0018:ffff888116ee3df8 EFLAGS: 00010296
 RAX: 0000000000000000 RBX: ffff8881154f6000 RCX: 0000000000000080
 RDX: ffffffffa0c557d0 RSI: ffff88810b69d200 RDI: 000000000002d8a0
 RBP: 0000000000000002 R08: ffff888110780408 R09: 0000000000000000
 R10: ffff88812452e1c0 R11: fffffffffff7e028 R12: 0000000000000000
 R13: 0000000000000080 R14: ffff888102c58000 R15: 0000000000000000
 FS:  00007f884393a740(0000) GS:ffff8882f5a00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 00000001249f6004 CR4: 0000000000370ea0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  mlx5_ib_stage_init_cleanup+0x16/0xd0 [mlx5_ib]
  __mlx5_ib_remove+0x33/0x90 [mlx5_ib]
  mlx5r_remove+0x22/0x30 [mlx5_ib]
  auxiliary_bus_remove+0x18/0x30
  __device_release_driver+0x177/0x220
  driver_detach+0xc4/0x100
  bus_remove_driver+0x58/0xd0
  auxiliary_driver_unregister+0x12/0x20
  mlx5_ib_cleanup+0x13/0x897 [mlx5_ib]
  __x64_sys_delete_module+0x154/0x230
  ? exit_to_user_mode_prepare+0x104/0x140
  do_syscall_64+0x3f/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f8842e095c7
 Code: 73 01 c3 48 8b 0d d9 48 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 48 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffc68f6e758 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
 RAX: ffffffffffffffda RBX: 00005638207929c0 RCX: 00007f8842e095c7
 RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000563820792a28
 RBP: 00005638207929c0 R08: 00007ffc68f6d701 R09: 0000000000000000
 R10: 00007f8842e82880 R11: 0000000000000206 R12: 0000563820792a28
 R13: 0000000000000001 R14: 0000563820792a28 R15: 00007ffc68f6fb40
 Modules linked in: xt_MASQUERADE nf_conntrack_netlink nfnetlink iptable_nat xt_addrtype xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter overlay rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_ipoib ib_cm ib_umad mlx5_ib(-) mlx4_ib ib_uverbs ib_core mlx4_en mlx4_core mlx5_core ptp pps_core [last unloaded: rpcrdma]
 CR2: 0000000000000000
 ---[ end trace a0bb7e20804e9e9b ]---

Fixes: 7ce6095e3bff ("RDMA/mlx5: Don't add slave port to unaffiliated list")
Link: https://lore.kernel.org/r/899ac1b33a995be5ec0e16a4765c4e43c2b1ba5b.1624956444.git.leonro@nvidia.com
Reviewed-by: Itay Aveksis <itayav@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f347515a38d..cca7296b12d0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3325,9 +3325,10 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
 			} else {
 				mlx5_ib_dbg(dev, "unbinding port_num: %u\n",
 					    i + 1);
-				mlx5_ib_unbind_slave_port(dev, dev->port[i].mp.mpi);
 				list_add_tail(&dev->port[i].mp.mpi->list,
 					      &mlx5_ib_unaffiliated_port_list);
+				mlx5_ib_unbind_slave_port(dev,
+							  dev->port[i].mp.mpi);
 			}
 		}
 	}
-- 
2.30.2



