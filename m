Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2348521FB19
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgGNS6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbgGNS6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94CB22507;
        Tue, 14 Jul 2020 18:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753118;
        bh=EdnW4CLBQnFmAtrJiSFWIfqAi2rXfDL9+rm6fgdqO1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhfqR1o13XRALEGB7RcEGLQF5igya/xd2rCdChz3UrvoD5J0wzzTQbvkp2ZqGRemO
         S3XlLXO62pnctdxUvkQs4iT3L2wguLNVifWC3xyAAjElOspXpZFemvX279G47EAURB
         GntpNPUDW47Lm3aUj8r4f6+6lq0mt3oY+rNLdcJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 096/166] net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
Date:   Tue, 14 Jul 2020 20:44:21 +0200
Message-Id: <20200714184120.444355652@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit f4aebbfb56ed0c186adbeb2799df836da50f78e3 ]

After function reload, CPU mapping used by aRFS RX is broken, leading to
a kernel panic. Fix by moving initialization of rx_cpu_rmap from
netdev_init to netdev_attach. IRQ table is re-allocated on mlx5_load,
but netdev is not re-initialize.

Trace of the panic:
[ 22.055672] general protection fault, probably for non-canonical address 0x785634120000ff1c: 0000 [#1] SMP PTI
[ 22.065010] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.7.0-rc2-for-upstream-perf-2020-04-21_16-34-03-31 #1
[ 22.067967] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[ 22.071174] RIP: 0010:get_rps_cpu+0x267/0x300
[ 22.075692] RSP: 0018:ffffc90000244d60 EFLAGS: 00010202
[ 22.076888] RAX: ffff888459b0e400 RBX: 0000000000000000 RCX:0000000000000007
[ 22.078364] RDX: 0000000000008884 RSI: ffff888467cb5b00 RDI:0000000000000000
[ 22.079815] RBP: 00000000ff342b27 R08: 0000000000000007 R09:0000000000000003
[ 22.081289] R10: ffffffffffffffff R11: 00000000000070cc R12:ffff888454900000
[ 22.082767] R13: ffffc90000e5a950 R14: ffffc90000244dc0 R15:0000000000000007
[ 22.084190] FS: 0000000000000000(0000) GS:ffff88846fc80000(0000)knlGS:0000000000000000
[ 22.086161] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 22.087427] CR2: ffffffffffffffff CR3: 0000000464426003 CR4:0000000000760ee0
[ 22.088888] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
[ 22.090336] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
[ 22.091764] PKRU: 55555554
[ 22.092618] Call Trace:
[ 22.093442] <IRQ>
[ 22.094211] ? kvm_clock_get_cycles+0xd/0x10
[ 22.095272] netif_receive_skb_list_internal+0x258/0x2a0
[ 22.096460] gro_normal_list.part.137+0x19/0x40
[ 22.097547] napi_complete_done+0xc6/0x110
[ 22.098685] mlx5e_napi_poll+0x190/0x670 [mlx5_core]
[ 22.099859] net_rx_action+0x2a0/0x400
[ 22.100848] __do_softirq+0xd8/0x2a8
[ 22.101829] irq_exit+0xa5/0xb0
[ 22.102750] do_IRQ+0x52/0xd0
[ 22.103654] common_interrupt+0xf/0xf
[ 22.104641] </IRQ>

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 02f6b6bd2847c..bc54913c58618 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5119,6 +5119,10 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_flow_steering;
 
+#ifdef CONFIG_MLX5_EN_ARFS
+	priv->netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(priv->mdev);
+#endif
+
 	return 0;
 
 err_destroy_flow_steering:
@@ -5296,10 +5300,6 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	/* netdev init */
 	netif_carrier_off(netdev);
 
-#ifdef CONFIG_MLX5_EN_ARFS
-	netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(mdev);
-#endif
-
 	return 0;
 
 err_free_cpumask:
-- 
2.25.1



