Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B005F99B4
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiJJHP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiJJHOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:14:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F05D114;
        Mon, 10 Oct 2022 00:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BFDAB80E58;
        Mon, 10 Oct 2022 07:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11DAC433C1;
        Mon, 10 Oct 2022 07:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385715;
        bh=mOlq6Ifp+O6v6R8w/JZuh4mD7gxCpH3JY+wP9MDj4SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v09TqpK3OtKyAADTQUM1Tw3OY/Qc0mEJiV1M+VLWlE+OxFfJ2E8ttfs53794u8j67
         05KnJOF4eGQzNdhMC6dPAKrpap00LR06TZM/IJA9IOoss7ZBcnjeRdMIh0x0lZ3moA
         VCDdaFX59mSdT8h0QmSPB7Jf9+KiUGHMstnRok5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/37] net/mlx5: Disable irq when locking lag_lock
Date:   Mon, 10 Oct 2022 09:05:53 +0200
Message-Id: <20221010070332.175581195@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 8e93f29422ffe968d7161f91acdf0d47f5323727 ]

The lag_lock is taken from both process and softirq contexts which results
lockdep warning[0] about potential deadlock. However, just disabling
softirqs by using *_bh spinlock API is not enough since it will cause
warning in some contexts where the lock is obtained with hard irqs
disabled. To fix the issue save current irq state, disable them before
obtaining the lock an re-enable irqs from saved state after releasing it.

[0]:

[Sun Aug  7 13:12:29 2022] ================================
[Sun Aug  7 13:12:29 2022] WARNING: inconsistent lock state
[Sun Aug  7 13:12:29 2022] 5.19.0_for_upstream_debug_2022_08_04_16_06 #1 Not tainted
[Sun Aug  7 13:12:29 2022] --------------------------------
[Sun Aug  7 13:12:29 2022] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[Sun Aug  7 13:12:29 2022] swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
[Sun Aug  7 13:12:29 2022] ffffffffa06dc0d8 (lag_lock){+.?.}-{2:2}, at: mlx5_lag_is_shared_fdb+0x1f/0x120 [mlx5_core]
[Sun Aug  7 13:12:29 2022] {SOFTIRQ-ON-W} state was registered at:
[Sun Aug  7 13:12:29 2022]   lock_acquire+0x1c1/0x550
[Sun Aug  7 13:12:29 2022]   _raw_spin_lock+0x2c/0x40
[Sun Aug  7 13:12:29 2022]   mlx5_lag_add_netdev+0x13b/0x480 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   mlx5e_nic_enable+0x114/0x470 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   mlx5e_attach_netdev+0x30e/0x6a0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   mlx5e_resume+0x105/0x160 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   mlx5e_probe+0xac3/0x14f0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   auxiliary_bus_probe+0x9d/0xe0
[Sun Aug  7 13:12:29 2022]   really_probe+0x1e0/0xaa0
[Sun Aug  7 13:12:29 2022]   __driver_probe_device+0x219/0x480
[Sun Aug  7 13:12:29 2022]   driver_probe_device+0x49/0x130
[Sun Aug  7 13:12:29 2022]   __driver_attach+0x1e4/0x4d0
[Sun Aug  7 13:12:29 2022]   bus_for_each_dev+0x11e/0x1a0
[Sun Aug  7 13:12:29 2022]   bus_add_driver+0x3f4/0x5a0
[Sun Aug  7 13:12:29 2022]   driver_register+0x20f/0x390
[Sun Aug  7 13:12:29 2022]   __auxiliary_driver_register+0x14e/0x260
[Sun Aug  7 13:12:29 2022]   mlx5e_init+0x38/0x90 [mlx5_core]
[Sun Aug  7 13:12:29 2022]   vhost_iotlb_itree_augment_rotate+0xcb/0x180 [vhost_iotlb]
[Sun Aug  7 13:12:29 2022]   do_one_initcall+0xc4/0x400
[Sun Aug  7 13:12:29 2022]   do_init_module+0x18a/0x620
[Sun Aug  7 13:12:29 2022]   load_module+0x563a/0x7040
[Sun Aug  7 13:12:29 2022]   __do_sys_finit_module+0x122/0x1d0
[Sun Aug  7 13:12:29 2022]   do_syscall_64+0x3d/0x90
[Sun Aug  7 13:12:29 2022]   entry_SYSCALL_64_after_hwframe+0x46/0xb0
[Sun Aug  7 13:12:29 2022] irq event stamp: 3596508
[Sun Aug  7 13:12:29 2022] hardirqs last  enabled at (3596508): [<ffffffff813687c2>] __local_bh_enable_ip+0xa2/0x100
[Sun Aug  7 13:12:29 2022] hardirqs last disabled at (3596507): [<ffffffff813687da>] __local_bh_enable_ip+0xba/0x100
[Sun Aug  7 13:12:29 2022] softirqs last  enabled at (3596488): [<ffffffff81368a2a>] irq_exit_rcu+0x11a/0x170
[Sun Aug  7 13:12:29 2022] softirqs last disabled at (3596495): [<ffffffff81368a2a>] irq_exit_rcu+0x11a/0x170
[Sun Aug  7 13:12:29 2022]
                           other info that might help us debug this:
[Sun Aug  7 13:12:29 2022]  Possible unsafe locking scenario:

[Sun Aug  7 13:12:29 2022]        CPU0
[Sun Aug  7 13:12:29 2022]        ----
[Sun Aug  7 13:12:29 2022]   lock(lag_lock);
[Sun Aug  7 13:12:29 2022]   <Interrupt>
[Sun Aug  7 13:12:29 2022]     lock(lag_lock);
[Sun Aug  7 13:12:29 2022]
                            *** DEADLOCK ***

[Sun Aug  7 13:12:29 2022] 4 locks held by swapper/0/0:
[Sun Aug  7 13:12:29 2022]  #0: ffffffff84643260 (rcu_read_lock){....}-{1:2}, at: mlx5e_napi_poll+0x43/0x20a0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  #1: ffffffff84643260 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb_list_internal+0x2d7/0xd60
[Sun Aug  7 13:12:29 2022]  #2: ffff888144a18b58 (&br->hash_lock){+.-.}-{2:2}, at: br_fdb_update+0x301/0x570
[Sun Aug  7 13:12:29 2022]  #3: ffffffff84643260 (rcu_read_lock){....}-{1:2}, at: atomic_notifier_call_chain+0x5/0x1d0
[Sun Aug  7 13:12:29 2022]
                           stack backtrace:
[Sun Aug  7 13:12:29 2022] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0_for_upstream_debug_2022_08_04_16_06 #1
[Sun Aug  7 13:12:29 2022] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[Sun Aug  7 13:12:29 2022] Call Trace:
[Sun Aug  7 13:12:29 2022]  <IRQ>
[Sun Aug  7 13:12:29 2022]  dump_stack_lvl+0x57/0x7d
[Sun Aug  7 13:12:29 2022]  mark_lock.part.0.cold+0x5f/0x92
[Sun Aug  7 13:12:29 2022]  ? lock_chain_count+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? unwind_next_frame+0x1c4/0x1b50
[Sun Aug  7 13:12:29 2022]  ? secondary_startup_64_no_verify+0xcd/0xdb
[Sun Aug  7 13:12:29 2022]  ? mlx5e_napi_poll+0x4e9/0x20a0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? mlx5e_napi_poll+0x4e9/0x20a0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? stack_access_ok+0x1d0/0x1d0
[Sun Aug  7 13:12:29 2022]  ? start_kernel+0x3a7/0x3c5
[Sun Aug  7 13:12:29 2022]  __lock_acquire+0x1260/0x6720
[Sun Aug  7 13:12:29 2022]  ? lock_chain_count+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? lock_chain_count+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? register_lock_class+0x1880/0x1880
[Sun Aug  7 13:12:29 2022]  ? mark_lock.part.0+0xed/0x3060
[Sun Aug  7 13:12:29 2022]  ? stack_trace_save+0x91/0xc0
[Sun Aug  7 13:12:29 2022]  lock_acquire+0x1c1/0x550
[Sun Aug  7 13:12:29 2022]  ? mlx5_lag_is_shared_fdb+0x1f/0x120 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[Sun Aug  7 13:12:29 2022]  ? __lock_acquire+0xd6f/0x6720
[Sun Aug  7 13:12:29 2022]  _raw_spin_lock+0x2c/0x40
[Sun Aug  7 13:12:29 2022]  ? mlx5_lag_is_shared_fdb+0x1f/0x120 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  mlx5_lag_is_shared_fdb+0x1f/0x120 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  mlx5_esw_bridge_rep_vport_num_vhca_id_get+0x1a0/0x600 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? mlx5_esw_bridge_update_work+0x90/0x90 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? lock_acquire+0x1c1/0x550
[Sun Aug  7 13:12:29 2022]  mlx5_esw_bridge_switchdev_event+0x185/0x8f0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? mlx5_esw_bridge_port_obj_attr_set+0x3e0/0x3e0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? check_chain_key+0x24a/0x580
[Sun Aug  7 13:12:29 2022]  atomic_notifier_call_chain+0xd7/0x1d0
[Sun Aug  7 13:12:29 2022]  br_switchdev_fdb_notify+0xea/0x100
[Sun Aug  7 13:12:29 2022]  ? br_switchdev_set_port_flag+0x310/0x310
[Sun Aug  7 13:12:29 2022]  fdb_notify+0x11b/0x150
[Sun Aug  7 13:12:29 2022]  br_fdb_update+0x34c/0x570
[Sun Aug  7 13:12:29 2022]  ? lock_chain_count+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? br_fdb_add_local+0x50/0x50
[Sun Aug  7 13:12:29 2022]  ? br_allowed_ingress+0x5f/0x1070
[Sun Aug  7 13:12:29 2022]  ? check_chain_key+0x24a/0x580
[Sun Aug  7 13:12:29 2022]  br_handle_frame_finish+0x786/0x18e0
[Sun Aug  7 13:12:29 2022]  ? check_chain_key+0x24a/0x580
[Sun Aug  7 13:12:29 2022]  ? br_handle_local_finish+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? __lock_acquire+0xd6f/0x6720
[Sun Aug  7 13:12:29 2022]  ? sctp_inet_bind_verify+0x4d/0x190
[Sun Aug  7 13:12:29 2022]  ? xlog_unpack_data+0x2e0/0x310
[Sun Aug  7 13:12:29 2022]  ? br_handle_local_finish+0x20/0x20
[Sun Aug  7 13:12:29 2022]  br_nf_hook_thresh+0x227/0x380 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? setup_pre_routing+0x460/0x460 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? br_handle_local_finish+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? br_nf_pre_routing_ipv6+0x48b/0x69c [br_netfilter]
[Sun Aug  7 13:12:29 2022]  br_nf_pre_routing_finish_ipv6+0x5c2/0xbf0 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? br_handle_local_finish+0x20/0x20
[Sun Aug  7 13:12:29 2022]  br_nf_pre_routing_ipv6+0x4c6/0x69c [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? br_validate_ipv6+0x9e0/0x9e0 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? br_nf_forward_arp+0xb70/0xb70 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  ? br_nf_pre_routing+0xacf/0x1160 [br_netfilter]
[Sun Aug  7 13:12:29 2022]  br_handle_frame+0x8a9/0x1270
[Sun Aug  7 13:12:29 2022]  ? br_handle_frame_finish+0x18e0/0x18e0
[Sun Aug  7 13:12:29 2022]  ? register_lock_class+0x1880/0x1880
[Sun Aug  7 13:12:29 2022]  ? br_handle_local_finish+0x20/0x20
[Sun Aug  7 13:12:29 2022]  ? bond_handle_frame+0xf9/0xac0 [bonding]
[Sun Aug  7 13:12:29 2022]  ? br_handle_frame_finish+0x18e0/0x18e0
[Sun Aug  7 13:12:29 2022]  __netif_receive_skb_core+0x7c0/0x2c70
[Sun Aug  7 13:12:29 2022]  ? check_chain_key+0x24a/0x580
[Sun Aug  7 13:12:29 2022]  ? generic_xdp_tx+0x5b0/0x5b0
[Sun Aug  7 13:12:29 2022]  ? __lock_acquire+0xd6f/0x6720
[Sun Aug  7 13:12:29 2022]  ? register_lock_class+0x1880/0x1880
[Sun Aug  7 13:12:29 2022]  ? check_chain_key+0x24a/0x580
[Sun Aug  7 13:12:29 2022]  __netif_receive_skb_list_core+0x2d7/0x8a0
[Sun Aug  7 13:12:29 2022]  ? lock_acquire+0x1c1/0x550
[Sun Aug  7 13:12:29 2022]  ? process_backlog+0x960/0x960
[Sun Aug  7 13:12:29 2022]  ? lockdep_hardirqs_on_prepare+0x129/0x400
[Sun Aug  7 13:12:29 2022]  ? kvm_clock_get_cycles+0x14/0x20
[Sun Aug  7 13:12:29 2022]  netif_receive_skb_list_internal+0x5f4/0xd60
[Sun Aug  7 13:12:29 2022]  ? do_xdp_generic+0x150/0x150
[Sun Aug  7 13:12:29 2022]  ? mlx5e_poll_rx_cq+0xf6b/0x2960 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? mlx5e_poll_ico_cq+0x3d/0x1590 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  napi_complete_done+0x188/0x710
[Sun Aug  7 13:12:29 2022]  mlx5e_napi_poll+0x4e9/0x20a0 [mlx5_core]
[Sun Aug  7 13:12:29 2022]  ? __queue_work+0x53c/0xeb0
[Sun Aug  7 13:12:29 2022]  __napi_poll+0x9f/0x540
[Sun Aug  7 13:12:29 2022]  net_rx_action+0x420/0xb70
[Sun Aug  7 13:12:29 2022]  ? napi_threaded_poll+0x470/0x470
[Sun Aug  7 13:12:29 2022]  ? __common_interrupt+0x79/0x1a0
[Sun Aug  7 13:12:29 2022]  __do_softirq+0x271/0x92c
[Sun Aug  7 13:12:29 2022]  irq_exit_rcu+0x11a/0x170
[Sun Aug  7 13:12:29 2022]  common_interrupt+0x7d/0xa0
[Sun Aug  7 13:12:29 2022]  </IRQ>
[Sun Aug  7 13:12:29 2022]  <TASK>
[Sun Aug  7 13:12:29 2022]  asm_common_interrupt+0x22/0x40
[Sun Aug  7 13:12:29 2022] RIP: 0010:default_idle+0x42/0x60
[Sun Aug  7 13:12:29 2022] Code: c1 83 e0 07 48 c1 e9 03 83 c0 03 0f b6 14 11 38 d0 7c 04 84 d2 75 14 8b 05 6b f1 22 02 85 c0 7e 07 0f 00 2d 80 3b 4a 00 fb f4 <c3> 48 c7 c7 e0 07 7e 85 e8 21 bd 40 fe eb de 66 66 2e 0f 1f 84 00
[Sun Aug  7 13:12:29 2022] RSP: 0018:ffffffff84407e18 EFLAGS: 00000242
[Sun Aug  7 13:12:29 2022] RAX: 0000000000000001 RBX: ffffffff84ec4a68 RCX: 1ffffffff0afc0fc
[Sun Aug  7 13:12:29 2022] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffffffff835b1fac
[Sun Aug  7 13:12:29 2022] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8884d2c44ac3
[Sun Aug  7 13:12:29 2022] R10: ffffed109a588958 R11: 00000000ffffffff R12: 0000000000000000
[Sun Aug  7 13:12:29 2022] R13: ffffffff84efac20 R14: 0000000000000000 R15: dffffc0000000000
[Sun Aug  7 13:12:29 2022]  ? default_idle_call+0xcc/0x460
[Sun Aug  7 13:12:29 2022]  default_idle_call+0xec/0x460
[Sun Aug  7 13:12:29 2022]  do_idle+0x394/0x450
[Sun Aug  7 13:12:29 2022]  ? arch_cpu_idle_exit+0x40/0x40
[Sun Aug  7 13:12:29 2022]  cpu_startup_entry+0x19/0x20
[Sun Aug  7 13:12:29 2022]  rest_init+0x156/0x250
[Sun Aug  7 13:12:29 2022]  arch_call_rest_init+0xf/0x15
[Sun Aug  7 13:12:29 2022]  start_kernel+0x3a7/0x3c5
[Sun Aug  7 13:12:29 2022]  secondary_startup_64_no_verify+0xcd/0xdb
[Sun Aug  7 13:12:29 2022]  </TASK>

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 55 +++++++++++--------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 0fbb239559f3..5f8b7f3735b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -691,30 +691,32 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 				 struct net_device *netdev)
 {
 	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
+	unsigned long flags;
 
 	if (fn >= MLX5_MAX_PORTS)
 		return;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev->pf[fn].netdev = netdev;
 	ldev->tracker.netdev_state[fn].link_up = 0;
 	ldev->tracker.netdev_state[fn].tx_enabled = 0;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 }
 
 static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
 				    struct net_device *netdev)
 {
+	unsigned long flags;
 	int i;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	for (i = 0; i < MLX5_MAX_PORTS; i++) {
 		if (ldev->pf[i].netdev == netdev) {
 			ldev->pf[i].netdev = NULL;
 			break;
 		}
 	}
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 }
 
 static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
@@ -855,12 +857,13 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_roce(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -869,12 +872,13 @@ EXPORT_SYMBOL(mlx5_lag_is_roce);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_active(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -883,13 +887,14 @@ EXPORT_SYMBOL(mlx5_lag_is_active);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res = ldev && __mlx5_lag_is_active(ldev) &&
 		dev == ldev->pf[MLX5_LAG_P1].dev;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -898,12 +903,13 @@ EXPORT_SYMBOL(mlx5_lag_is_master);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_sriov(ldev);
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -912,12 +918,13 @@ EXPORT_SYMBOL(mlx5_lag_is_sriov);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	bool res;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	res = ldev && __mlx5_lag_is_sriov(ldev) && ldev->shared_fdb;
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return res;
 }
@@ -965,8 +972,9 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 {
 	struct net_device *ndev = NULL;
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
@@ -983,7 +991,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 		dev_hold(ndev);
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	return ndev;
 }
@@ -993,9 +1001,10 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 			   struct net_device *slave)
 {
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	u8 port = 0;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
 		goto unlock;
@@ -1008,7 +1017,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 	port = ldev->v2p_map[port];
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 	return port;
 }
 EXPORT_SYMBOL(mlx5_lag_get_slave_port);
@@ -1017,8 +1026,9 @@ struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_dev *peer_dev = NULL;
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		goto unlock;
@@ -1028,7 +1038,7 @@ struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
 			   ldev->pf[MLX5_LAG_P1].dev;
 
 unlock:
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 	return peer_dev;
 }
 EXPORT_SYMBOL(mlx5_lag_get_peer_mdev);
@@ -1041,6 +1051,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	int outlen = MLX5_ST_SZ_BYTES(query_cong_statistics_out);
 	struct mlx5_core_dev *mdev[MLX5_MAX_PORTS];
 	struct mlx5_lag *ldev;
+	unsigned long flags;
 	int num_ports;
 	int ret, i, j;
 	void *out;
@@ -1051,7 +1062,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 
 	memset(values, 0, sizeof(*values) * num_counters);
 
-	spin_lock(&lag_lock);
+	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (ldev && __mlx5_lag_is_active(ldev)) {
 		num_ports = MLX5_MAX_PORTS;
@@ -1061,7 +1072,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 		num_ports = 1;
 		mdev[MLX5_LAG_P1] = dev;
 	}
-	spin_unlock(&lag_lock);
+	spin_unlock_irqrestore(&lag_lock, flags);
 
 	for (i = 0; i < num_ports; ++i) {
 		u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = {};
-- 
2.35.1



