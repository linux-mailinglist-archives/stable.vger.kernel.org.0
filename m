Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FDF1C448C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgEDSIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730356AbgEDSH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F7D20746;
        Mon,  4 May 2020 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615678;
        bh=A/KwIkfCHO9neoGRo9r344d9FnbHefnZXfGVEmTxLs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMS6kQSGQsVCR6pZYSZfWoWhtxJoTa5pMm4SkAFOzd1XCgnwevkLKhSTRuXuZunCF
         qz4zK4HPEEkgoZ8sENExLAO7358DlIDvx3bK+j/VxkMCGTpd+nBr7mQEp3dA0C5lRV
         9ocTmRBFJDaXBiNHyLBxqOzhfr840l9trlrwjkRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.6 44/73] RDMA/uverbs: Fix a race with disassociate and exit_mmap()
Date:   Mon,  4 May 2020 19:57:47 +0200
Message-Id: <20200504165508.702817893@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 39c011a538272589b9eb02ff1228af528522a22c upstream.

If uverbs_user_mmap_disassociate() is called while the mmap is
concurrently doing exit_mmap then the ordering of the
rdma_user_mmap_entry_put() is not reliable.

The put must be done before uvers_user_mmap_disassociate() returns,
otherwise there can be a use after free on the ucontext, and a left over
entry in the xarray. If the put is not done here then it is done during
rdma_umap_close() later.

Add the missing put to the error exit path.

  WARNING: CPU: 7 PID: 7111 at drivers/infiniband/core/rdma_core.c:810 uverbs_destroy_ufile_hw+0x2a5/0x340 [ib_uverbs]
  Modules linked in: bonding ipip tunnel4 geneve ip6_udp_tunnel udp_tunnel ip6_gre ip6_tunnel tunnel6 ip_gre ip_tunnel gre mlx5_ib mlx5_core mlxfw pci_hyperv_intf act_ct nf_flow_table ptp pps_core rdma_ucm ib_uverbs ib_ipoib ib_umad 8021q garp mrp openvswitch nsh nf_conncount nfsv3 nfs_acl xt_MASQUERADE nf_conntrack_netlink nfnetlink iptable_nat xt_addrtype iptable_filter xt_conntrack br_netfilter bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache overlay rpcrdma ib_isert iscsi_target_mod ib_iser kvm_intel ib_srpt iTCO_wdt target_core_mod iTCO_vendor_support kvm ib_srp nf_nat irqbypass crc32_pclmul crc32c_intel nf_conntrack rfkill nf_defrag_ipv6 virtio_net nf_defrag_ipv4 pcspkr ghash_clmulni_intel i2c_i801 net_failover failover i2c_core lpc_ich mfd_core rdma_cm ib_cm iw_cm button ib_core sunrpc sch_fq_codel ip_tables serio_raw [last unloaded: tunnel4]
  CPU: 7 PID: 7111 Comm: python3 Tainted: G        W         5.6.0-rc6-for-upstream-dbg-2020-03-21_06-41-26-18 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:uverbs_destroy_ufile_hw+0x2a5/0x340 [ib_uverbs]
  Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 74 49 8b 84 24 08 01 00 00 48 85 c0 0f 84 13 ff ff ff 48 89 ef ff d0 e9 09 ff ff ff <0f> 0b e9 77 ff ff ff e8 0f d8 fa e0 e9 c5 fd ff ff e8 05 d8 fa e0
  RSP: 0018:ffff88840e0779a0 EFLAGS: 00010286
  RAX: dffffc0000000000 RBX: ffff8882a7721c00 RCX: 0000000000000000
  RDX: 1ffff11054ee469f RSI: ffffffff8446d7e0 RDI: ffff8882a77234f8
  RBP: ffff8882a7723400 R08: ffffed1085c0112c R09: 0000000000000001
  R10: 0000000000000001 R11: ffffed1085c0112b R12: ffff888403c30000
  R13: 0000000000000002 R14: ffff8882a7721cb0 R15: ffff8882a7721cd0
  FS:  00007f2046089700(0000) GS:ffff88842de00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f7cfe9a6e20 CR3: 000000040b8ac006 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   ib_uverbs_remove_one+0x273/0x480 [ib_uverbs]
   ? up_write+0x15c/0x4a0
   remove_client_context+0xa6/0xf0 [ib_core]
   disable_device+0x12d/0x200 [ib_core]
   ? remove_client_context+0xf0/0xf0 [ib_core]
   ? mnt_get_count+0x1d0/0x1d0
   __ib_unregister_device+0x79/0x150 [ib_core]
   ib_unregister_device+0x21/0x30 [ib_core]
   __mlx5_ib_remove+0x91/0x110 [mlx5_ib]
   ? __mlx5_ib_remove+0x110/0x110 [mlx5_ib]
   mlx5_remove_device+0x241/0x310 [mlx5_core]
   mlx5_unregister_device+0x4d/0x1e0 [mlx5_core]
   mlx5_unload_one+0xc0/0x260 [mlx5_core]
   remove_one+0x5c/0x160 [mlx5_core]
   pci_device_remove+0xef/0x2a0
   ? pcibios_free_irq+0x10/0x10
   device_release_driver_internal+0x1d8/0x470
   unbind_store+0x152/0x200
   ? sysfs_kf_write+0x3b/0x180
   ? sysfs_file_ops+0x160/0x160
   kernfs_fop_write+0x284/0x460
   ? __sb_start_write+0x243/0x3a0
   vfs_write+0x197/0x4a0
   ksys_write+0x156/0x1e0
   ? __x64_sys_read+0xb0/0xb0
   ? do_syscall_64+0x73/0x1330
   ? do_syscall_64+0x73/0x1330
   do_syscall_64+0xe7/0x1330
   ? down_write_nested+0x3e0/0x3e0
   ? syscall_return_slowpath+0x970/0x970
   ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
   ? lockdep_hardirqs_off+0x1de/0x2d0
   ? trace_hardirqs_off_thunk+0x1a/0x1c
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f20a3ff0cdb
  Code: 53 48 89 d5 48 89 f3 48 83 ec 18 48 89 7c 24 08 e8 5a fd ff ff 48 89 ea 41 89 c0 48 89 de 48 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 90 fd ff ff 48
  RSP: 002b:00007f2046087040 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007f2038016df0 RCX: 00007f20a3ff0cdb
  RDX: 000000000000000d RSI: 00007f2038016df0 RDI: 0000000000000018
  RBP: 000000000000000d R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000100 R11: 0000000000000293 R12: 00007f2046e29630
  R13: 00007f20280035a0 R14: 0000000000000018 R15: 00007f2038016df0

Fixes: c043ff2cfb7f ("RDMA: Connect between the mmap entry and the umap_priv structure")
Link: https://lore.kernel.org/r/20200413132136.930388-1-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -820,6 +820,10 @@ void uverbs_user_mmap_disassociate(struc
 			ret = mmget_not_zero(mm);
 			if (!ret) {
 				list_del_init(&priv->list);
+				if (priv->entry) {
+					rdma_user_mmap_entry_put(priv->entry);
+					priv->entry = NULL;
+				}
 				mm = NULL;
 				continue;
 			}


