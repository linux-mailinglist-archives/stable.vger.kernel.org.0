Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCB3240939
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgHJPaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgHJPaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2DB620791;
        Mon, 10 Aug 2020 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073416;
        bh=MW7J+hsXgn9nQY2RcNiaq6t9NpgkfUGMv8o3WrLLBRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEQe//z5f/BuDqgm4HpNEj8eAvYAGns5a610y+yPmAWptG1J+YnVSfms5u29WGuTJ
         jz8FqRx+7IrLE8rOfwz7OCbRHxPsjkyFGwVMVy8XKp0YHo0ISCOQaf1Q+DOKxdMcY6
         c5M1eR/KecaPW114IKCsyKSP34aZ2NX9Rn3Q0Ygw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 32/48] ipv4: Silence suspicious RCU usage warning
Date:   Mon, 10 Aug 2020 17:21:54 +0200
Message-Id: <20200810151805.790694863@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 83f3522860f702748143e022f1a546547314c715 ]

fib_trie_unmerge() is called with RTNL held, but not from an RCU
read-side critical section. This leads to the following warning [1] when
the FIB alias list in a leaf is traversed with
hlist_for_each_entry_rcu().

Since the function is always called with RTNL held and since
modification of the list is protected by RTNL, simply use
hlist_for_each_entry() and silence the warning.

[1]
WARNING: suspicious RCU usage
5.8.0-rc4-custom-01520-gc1f937f3f83b #30 Not tainted
-----------------------------
net/ipv4/fib_trie.c:1867 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/164:
 #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0

stack backtrace:
CPU: 0 PID: 164 Comm: ip Not tainted 5.8.0-rc4-custom-01520-gc1f937f3f83b #30
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
Call Trace:
 dump_stack+0x100/0x184
 lockdep_rcu_suspicious+0x153/0x15d
 fib_trie_unmerge+0x608/0xdb0
 fib_unmerge+0x44/0x360
 fib4_rule_configure+0xc8/0xad0
 fib_nl_newrule+0x37a/0x1dd0
 rtnetlink_rcv_msg+0x4f7/0xbd0
 netlink_rcv_skb+0x17a/0x480
 rtnetlink_rcv+0x22/0x30
 netlink_unicast+0x5ae/0x890
 netlink_sendmsg+0x98a/0xf40
 ____sys_sendmsg+0x879/0xa00
 ___sys_sendmsg+0x122/0x190
 __sys_sendmsg+0x103/0x1d0
 __x64_sys_sendmsg+0x7d/0xb0
 do_syscall_64+0x54/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc80a234e97
Code: Bad RIP value.
RSP: 002b:00007ffef8b66798 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc80a234e97
RDX: 0000000000000000 RSI: 00007ffef8b66800 RDI: 0000000000000003
RBP: 000000005f141b1c R08: 0000000000000001 R09: 0000000000000000
R10: 00007fc80a2a8ac0 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007ffef8b67008 R15: 0000556fccb10020

Fixes: 0ddcf43d5d4a ("ipv4: FIB Local/MAIN table collapse")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1749,7 +1749,7 @@ struct fib_table *fib_trie_unmerge(struc
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
 		struct key_vector *local_l = NULL, *local_tp;
 
-		hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
+		hlist_for_each_entry(fa, &l->leaf, fa_list) {
 			struct fib_alias *new_fa;
 
 			if (local_tb->tb_id != fa->tb_id)


