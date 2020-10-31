Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2FA2A16A7
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgJaLpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgJaLpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A904205F4;
        Sat, 31 Oct 2020 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144713;
        bh=2tfMvhXpFmjd06G1YBGK71CothIhsmnTcXT4doaxfBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pxlre/7teyD9iEXvUo6KFjy59OxK98gMKE964xf3kaeKSDydqewbJCxdYteOVhWMQ
         zKJoD1egvJl0JLcyff+EzOo6FSPGRlJZNJeZOBm/LEZRMMnVGm4slCSiHL6rNCmjCX
         B2YvV3fdVIgspxxW7wBpxd0L8UYeBkAO0XMigR0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 51/74] net: protect tcf_block_unbind with block lock
Date:   Sat, 31 Oct 2020 12:36:33 +0100
Message-Id: <20201031113502.483863987@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d6535dca28859d8d9ef80894eb287b2ac35a32e8 ]

The tcf_block_unbind() expects that the caller will take block->cb_lock
before calling it, however the code took RTNL lock and dropped cb_lock
instead. This causes to the following kernel panic.

 WARNING: CPU: 1 PID: 13524 at net/sched/cls_api.c:1488 tcf_block_unbind+0x2db/0x420
 Modules linked in: mlx5_ib mlx5_core mlxfw ptp pps_core act_mirred act_tunnel_key cls_flower vxlan ip6_udp_tunnel udp_tunnel dummy sch_ingress openvswitch nsh xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad ib_ipoib rdma_cm iw_cm ib_cm ib_uverbs ib_core overlay [last unloaded: mlxfw]
 CPU: 1 PID: 13524 Comm: test-ecmp-add-v Tainted: G        W         5.9.0+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:tcf_block_unbind+0x2db/0x420
 Code: ff 48 83 c4 40 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8d bc 24 30 01 00 00 be ff ff ff ff e8 7d 7f 70 00 85 c0 0f 85 7b fd ff ff <0f> 0b e9 74 fd ff ff 48 c7 c7 dc 6a 24 84 e8 02 ec fe fe e9 55 fd
 RSP: 0018:ffff888117d17968 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88812f713c00 RCX: 1ffffffff0848d5b
 RDX: 0000000000000001 RSI: ffff88814fbc8130 RDI: ffff888107f2b878
 RBP: 1ffff11022fa2f3f R08: 0000000000000000 R09: ffffffff84115a87
 R10: fffffbfff0822b50 R11: ffff888107f2b898 R12: ffff88814fbc8000
 R13: ffff88812f713c10 R14: ffff888117d17a38 R15: ffff88814fbc80c0
 FS:  00007f6593d36740(0000) GS:ffff8882a4f00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005607a00758f8 CR3: 0000000131aea006 CR4: 0000000000170ea0
 Call Trace:
  tc_block_indr_cleanup+0x3e0/0x5a0
  ? tcf_block_unbind+0x420/0x420
  ? __mutex_unlock_slowpath+0xe7/0x610
  flow_indr_dev_unregister+0x5e2/0x930
  ? mlx5e_restore_tunnel+0xdf0/0xdf0 [mlx5_core]
  ? mlx5e_restore_tunnel+0xdf0/0xdf0 [mlx5_core]
  ? flow_indr_block_cb_alloc+0x3c0/0x3c0
  ? mlx5_db_free+0x37c/0x4b0 [mlx5_core]
  mlx5e_cleanup_rep_tx+0x8b/0xc0 [mlx5_core]
  mlx5e_detach_netdev+0xe5/0x120 [mlx5_core]
  mlx5e_vport_rep_unload+0x155/0x260 [mlx5_core]
  esw_offloads_disable+0x227/0x2b0 [mlx5_core]
  mlx5_eswitch_disable_locked.cold+0x38e/0x699 [mlx5_core]
  mlx5_eswitch_disable+0x94/0xf0 [mlx5_core]
  mlx5_device_disable_sriov+0x183/0x1f0 [mlx5_core]
  mlx5_core_sriov_configure+0xfd/0x230 [mlx5_core]
  sriov_numvfs_store+0x261/0x2f0
  ? sriov_drivers_autoprobe_store+0x110/0x110
  ? sysfs_file_ops+0x170/0x170
  ? sysfs_file_ops+0x117/0x170
  ? sysfs_file_ops+0x170/0x170
  kernfs_fop_write+0x1ff/0x3f0
  ? rcu_read_lock_any_held+0x6e/0x90
  vfs_write+0x1f3/0x620
  ksys_write+0xf9/0x1d0
  ? __x64_sys_read+0xb0/0xb0
  ? lockdep_hardirqs_on_prepare+0x273/0x3f0
  ? syscall_enter_from_user_mode+0x1d/0x50
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

<...>

 ---[ end trace bfdd028ada702879 ]---

Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20201026123327.1141066-1-leon@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -652,12 +652,12 @@ static void tc_block_indr_cleanup(struct
 			       block_cb->indr.binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
+	rtnl_lock();
 	down_write(&block->cb_lock);
 	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
-	up_write(&block->cb_lock);
-	rtnl_lock();
 	tcf_block_unbind(block, &bo);
+	up_write(&block->cb_lock);
 	rtnl_unlock();
 }
 


