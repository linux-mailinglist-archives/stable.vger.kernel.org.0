Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB8499387
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385796AbiAXUef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383017AbiAXU0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 698E461510;
        Mon, 24 Jan 2022 20:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D2C340E5;
        Mon, 24 Jan 2022 20:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056001;
        bh=G+qwuuLbSlf7jgq5WEDt1hyhIzP4SVExIwp8dDTF54s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LF8F2sJ/dFO1/eEYcqQunQWlLILW4sRgU4I2boaX4SCe+/MB5k1ShuvYbzxB7RxAq
         TlkYf8wXZ4BcUB1cXRAReNbbpv7Gn0dcey+a4F3wGjArail3IEN0I0U3hgr7J95Umf
         hHqDDxH2iMf5RmiQtR2X6mtARNh5wNw+8WL6kDMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/846] net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
Date:   Mon, 24 Jan 2022 19:37:35 +0100
Message-Id: <20220124184112.576337620@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 885751eb1b01d276e38f57d78c583e4ce006c5ed ]

Creating routes with nexthop objects while in switchdev mode leads to access to
un-allocated memory and trigger bellow call trace due to hitting WARN_ON.
This is caused due to illegal usage of fib_info_nh in TC tunnel FIB event handling to
resolve the FIB device while fib_info built in with nexthop.

Fixed by ignoring attempts to use nexthop objects with routes until support can be
properly added.

WARNING: CPU: 1 PID: 1724 at include/net/nexthop.h:468 mlx5e_tc_tun_fib_event+0x448/0x570 [mlx5_core]
CPU: 1 PID: 1724 Comm: ip Not tainted 5.15.0_for_upstream_min_debug_2021_11_09_02_04 #1
RIP: 0010:mlx5e_tc_tun_fib_event+0x448/0x570 [mlx5_core]
RSP: 0018:ffff8881349f7910 EFLAGS: 00010202
RAX: ffff8881492f1980 RBX: ffff8881349f79e8 RCX: 0000000000000000
RDX: ffff8881349f79e8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8881349f7950 R08: 00000000000000fe R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811e9d0000
R13: ffff88810eb62000 R14: ffff888106710268 R15: 0000000000000018
FS:  00007f1d5ca6e800(0000) GS:ffff88852c880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffedba44ff8 CR3: 0000000129808004 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 atomic_notifier_call_chain+0x42/0x60
 call_fib_notifiers+0x21/0x40
 fib_table_insert+0x479/0x6d0
 ? try_charge_memcg+0x480/0x6d0
 inet_rtm_newroute+0x65/0xb0
 rtnetlink_rcv_msg+0x2af/0x360
 ? page_add_file_rmap+0x13/0x130
 ? do_set_pte+0xcd/0x120
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x4e/0xf0
 netlink_unicast+0x1ee/0x2b0
 netlink_sendmsg+0x22e/0x460
 sock_sendmsg+0x33/0x40
 ____sys_sendmsg+0x1d1/0x1f0
 ___sys_sendmsg+0xab/0xf0
 ? __mod_memcg_lruvec_state+0x40/0x60
 ? __mod_lruvec_page_state+0x95/0xd0
 ? page_add_new_anon_rmap+0x4e/0xf0
 ? __handle_mm_fault+0xec6/0x1470
 __sys_sendmsg+0x51/0x90
 ? internal_get_user_pages_fast+0x480/0xa10
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index ec0163d75dd25..700c463ea3679 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1544,6 +1544,8 @@ mlx5e_init_fib_work_ipv4(struct mlx5e_priv *priv,
 	struct net_device *fib_dev;
 
 	fen_info = container_of(info, struct fib_entry_notifier_info, info);
+	if (fen_info->fi->nh)
+		return NULL;
 	fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 	if (!fib_dev || fib_dev->netdev_ops != &mlx5e_netdev_ops ||
 	    fen_info->dst_len != 32)
-- 
2.34.1



