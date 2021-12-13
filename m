Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB14728E4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhLMKP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbhLMKNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:13:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333FBC08EADA;
        Mon, 13 Dec 2021 01:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7FEF0CE0DDE;
        Mon, 13 Dec 2021 09:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23287C34600;
        Mon, 13 Dec 2021 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389272;
        bh=7gKGxZVyFkLdH1VL34tEFEwOk3SC6omJ2B5iji7Dqxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTU4TlcszAPfFf3kSe7iMeLQAR30FnbX+3lhAZX+JnLrAT/Imkbu7R58MgM62XHEG
         Fn4RetpSh8YMaED3zcwCPwqV5EOOKRtHy8pWKU2p2yc0tYGRSvvDe/d1weRjRB4tc5
         DKIzyAHMnk+EpIr/jQ7rRS5rN88PcFiR1viN+H9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 042/171] bonding: make tx_rebalance_counter an atomic
Date:   Mon, 13 Dec 2021 10:29:17 +0100
Message-Id: <20211213092946.483939160@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit dac8e00fb640e9569cdeefd3ce8a75639e5d0711 upstream.

KCSAN reported a data-race [1] around tx_rebalance_counter
which can be accessed from different contexts, without
the protection of a lock/mutex.

[1]
BUG: KCSAN: data-race in bond_alb_init_slave / bond_alb_monitor

write to 0xffff888157e8ca24 of 4 bytes by task 7075 on cpu 0:
 bond_alb_init_slave+0x713/0x860 drivers/net/bonding/bond_alb.c:1613
 bond_enslave+0xd94/0x3010 drivers/net/bonding/bond_main.c:1949
 do_set_master net/core/rtnetlink.c:2521 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3475 [inline]
 rtnl_newlink+0x1298/0x13b0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2491
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5fc/0x6c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x6e1/0x7d0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888157e8ca24 of 4 bytes by task 1082 on cpu 1:
 bond_alb_monitor+0x8f/0xc00 drivers/net/bonding/bond_alb.c:1511
 process_one_work+0x3fc/0x980 kernel/workqueue.c:2298
 worker_thread+0x616/0xa70 kernel/workqueue.c:2445
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x00000001 -> 0x00000064

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1082 Comm: kworker/u4:3 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bond1 bond_alb_monitor

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_alb.c |   14 ++++++++------
 include/net/bond_alb.h         |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1502,14 +1502,14 @@ void bond_alb_monitor(struct work_struct
 	struct slave *slave;
 
 	if (!bond_has_slaves(bond)) {
-		bond_info->tx_rebalance_counter = 0;
+		atomic_set(&bond_info->tx_rebalance_counter, 0);
 		bond_info->lp_counter = 0;
 		goto re_arm;
 	}
 
 	rcu_read_lock();
 
-	bond_info->tx_rebalance_counter++;
+	atomic_inc(&bond_info->tx_rebalance_counter);
 	bond_info->lp_counter++;
 
 	/* send learning packets */
@@ -1531,7 +1531,7 @@ void bond_alb_monitor(struct work_struct
 	}
 
 	/* rebalance tx traffic */
-	if (bond_info->tx_rebalance_counter >= BOND_TLB_REBALANCE_TICKS) {
+	if (atomic_read(&bond_info->tx_rebalance_counter) >= BOND_TLB_REBALANCE_TICKS) {
 		bond_for_each_slave_rcu(bond, slave, iter) {
 			tlb_clear_slave(bond, slave, 1);
 			if (slave == rcu_access_pointer(bond->curr_active_slave)) {
@@ -1541,7 +1541,7 @@ void bond_alb_monitor(struct work_struct
 				bond_info->unbalanced_load = 0;
 			}
 		}
-		bond_info->tx_rebalance_counter = 0;
+		atomic_set(&bond_info->tx_rebalance_counter, 0);
 	}
 
 	if (bond_info->rlb_enabled) {
@@ -1611,7 +1611,8 @@ int bond_alb_init_slave(struct bonding *
 	tlb_init_slave(slave);
 
 	/* order a rebalance ASAP */
-	bond->alb_info.tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
+	atomic_set(&bond->alb_info.tx_rebalance_counter,
+		   BOND_TLB_REBALANCE_TICKS);
 
 	if (bond->alb_info.rlb_enabled)
 		bond->alb_info.rlb_rebalance = 1;
@@ -1648,7 +1649,8 @@ void bond_alb_handle_link_change(struct
 			rlb_clear_slave(bond, slave);
 	} else if (link == BOND_LINK_UP) {
 		/* order a rebalance ASAP */
-		bond_info->tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
+		atomic_set(&bond_info->tx_rebalance_counter,
+			   BOND_TLB_REBALANCE_TICKS);
 		if (bond->alb_info.rlb_enabled) {
 			bond->alb_info.rlb_rebalance = 1;
 			/* If the updelay module parameter is smaller than the
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -126,7 +126,7 @@ struct tlb_slave_info {
 struct alb_bond_info {
 	struct tlb_client_info	*tx_hashtbl; /* Dynamically allocated */
 	u32			unbalanced_load;
-	int			tx_rebalance_counter;
+	atomic_t		tx_rebalance_counter;
 	int			lp_counter;
 	/* -------- rlb parameters -------- */
 	int rlb_enabled;


