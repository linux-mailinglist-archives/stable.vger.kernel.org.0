Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9361D84E8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732209AbgERSAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbgERSAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE9820826;
        Mon, 18 May 2020 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824822;
        bh=KCg1yyOVD4K2OKUGu9sfernH4qKqFq5o9U83i/HgAkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHClFn59kbv8PpAE5Wbq4hIuTFqmknY7veXML4zhfXmORtwrodr5lCRHXAQZtorxW
         p+ZAU0P9fzM/JoeyZSXEtGQ/7ILpTAq7YUVG421NtE1aPSwBO3kDroEIB5bj3zFZxs
         L0uyR5VmbRmAQqebduhsvBe5A4KbEbHlbaC3hzZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 018/194] hv_netvsc: Fix netvsc_start_xmits return type
Date:   Mon, 18 May 2020 19:35:08 +0200
Message-Id: <20200518173533.090744758@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 7fdc66debebc6a7170a37c8c9b0d9585a9788fb4 ]

netvsc_start_xmit is used as a callback function for the ndo_start_xmit
function pointer. ndo_start_xmit's return type is netdev_tx_t but
netvsc_start_xmit's return type is int.

This causes a failure with Control Flow Integrity (CFI), which requires
function pointer prototypes and callback function definitions to match
exactly. When CFI is in enforcing, the kernel panics. When booting a
CFI kernel with WSL 2, the VM is immediately terminated because of this.

The splat when CONFIG_CFI_PERMISSIVE is used:

[    5.916765] CFI failure (target: netvsc_start_xmit+0x0/0x10):
[    5.916771] WARNING: CPU: 8 PID: 0 at kernel/cfi.c:29 __cfi_check_fail+0x2e/0x40
[    5.916772] Modules linked in:
[    5.916774] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 5.7.0-rc3-next-20200424-microsoft-cbl-00001-ged4eb37d2c69-dirty #1
[    5.916776] RIP: 0010:__cfi_check_fail+0x2e/0x40
[    5.916777] Code: 48 c7 c7 70 98 63 a9 48 c7 c6 11 db 47 a9 e8 69 55 59 00 85 c0 75 02 5b c3 48 c7 c7 73 c6 43 a9 48 89 de 31 c0 e8 12 2d f0 ff <0f> 0b 5b c3 00 00 cc cc 00 00 cc cc 00 00 cc cc 00 00 85 f6 74 25
[    5.916778] RSP: 0018:ffffa803c0260b78 EFLAGS: 00010246
[    5.916779] RAX: 712a1af25779e900 RBX: ffffffffa8cf7950 RCX: ffffffffa962cf08
[    5.916779] RDX: ffffffffa9c36b60 RSI: 0000000000000082 RDI: ffffffffa9c36b5c
[    5.916780] RBP: ffff8ffc4779c2c0 R08: 0000000000000001 R09: ffffffffa9c3c300
[    5.916781] R10: 0000000000000151 R11: ffffffffa9c36b60 R12: ffff8ffe39084000
[    5.916782] R13: ffffffffa8cf7950 R14: ffffffffa8d12cb0 R15: ffff8ffe39320140
[    5.916784] FS:  0000000000000000(0000) GS:ffff8ffe3bc00000(0000) knlGS:0000000000000000
[    5.916785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.916786] CR2: 00007ffef5749408 CR3: 00000002f4f5e000 CR4: 0000000000340ea0
[    5.916787] Call Trace:
[    5.916788]  <IRQ>
[    5.916790]  __cfi_check+0x3ab58/0x450e0
[    5.916793]  ? dev_hard_start_xmit+0x11f/0x160
[    5.916795]  ? sch_direct_xmit+0xf2/0x230
[    5.916796]  ? __dev_queue_xmit.llvm.11471227737707190958+0x69d/0x8e0
[    5.916797]  ? neigh_resolve_output+0xdf/0x220
[    5.916799]  ? neigh_connected_output.cfi_jt+0x8/0x8
[    5.916801]  ? ip6_finish_output2+0x398/0x4c0
[    5.916803]  ? nf_nat_ipv6_out+0x10/0xa0
[    5.916804]  ? nf_hook_slow+0x84/0x100
[    5.916807]  ? ip6_input_finish+0x8/0x8
[    5.916807]  ? ip6_output+0x6f/0x110
[    5.916808]  ? __ip6_local_out.cfi_jt+0x8/0x8
[    5.916810]  ? mld_sendpack+0x28e/0x330
[    5.916811]  ? ip_rt_bug+0x8/0x8
[    5.916813]  ? mld_ifc_timer_expire+0x2db/0x400
[    5.916814]  ? neigh_proxy_process+0x8/0x8
[    5.916816]  ? call_timer_fn+0x3d/0xd0
[    5.916817]  ? __run_timers+0x2a9/0x300
[    5.916819]  ? rcu_core_si+0x8/0x8
[    5.916820]  ? run_timer_softirq+0x14/0x30
[    5.916821]  ? __do_softirq+0x154/0x262
[    5.916822]  ? native_x2apic_icr_write+0x8/0x8
[    5.916824]  ? irq_exit+0xba/0xc0
[    5.916825]  ? hv_stimer0_vector_handler+0x99/0xe0
[    5.916826]  ? hv_stimer0_callback_vector+0xf/0x20
[    5.916826]  </IRQ>
[    5.916828]  ? hv_stimer_global_cleanup.cfi_jt+0x8/0x8
[    5.916829]  ? raw_setsockopt+0x8/0x8
[    5.916830]  ? default_idle+0xe/0x10
[    5.916832]  ? do_idle.llvm.10446269078108580492+0xb7/0x130
[    5.916833]  ? raw_setsockopt+0x8/0x8
[    5.916833]  ? cpu_startup_entry+0x15/0x20
[    5.916835]  ? cpu_hotplug_enable.cfi_jt+0x8/0x8
[    5.916836]  ? start_secondary+0x188/0x190
[    5.916837]  ? secondary_startup_64+0xa5/0xb0
[    5.916838] ---[ end trace f2683fa869597ba5 ]---

Avoid this by using the right return type for netvsc_start_xmit.

Fixes: fceaf24a943d8 ("Staging: hv: add the Hyper-V virtual network driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1009
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 2c0a24c606fc7..28a5d46ad5266 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -710,7 +710,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	goto drop;
 }
 
-static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	return netvsc_xmit(skb, ndev, false);
 }
-- 
2.20.1



