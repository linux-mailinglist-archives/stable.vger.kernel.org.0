Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E91240912
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgHJP2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgHJP2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620AF22BF3;
        Mon, 10 Aug 2020 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073318;
        bh=kfezLy7BHksJ+DhKywSCaSISLD3lx0y6THaBhBWV3RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6GbktCPdbCADnBh1sjUApUbH+p4HVSRE5uXH4OkD+2XYOwxbhW3D5EjDdVNPs++B
         iIhUBLJs21FVlQqWWzXAn4cu7D494lCtsDr/tLQNokssSv68IKdun8YGjNMZRNzH/4
         sn4gnGPnLy8I+zHQWunq9L/dYgnW+4YHyWpkyQZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 55/67] vxlan: Ensure FDB dump is performed under RCU
Date:   Mon, 10 Aug 2020 17:21:42 +0200
Message-Id: <20200810151812.213893180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit b5141915b5aec3b29a63db869229e3741ebce258 ]

The commit cited below removed the RCU read-side critical section from
rtnl_fdb_dump() which means that the ndo_fdb_dump() callback is invoked
without RCU protection.

This results in the following warning [1] in the VXLAN driver, which
relied on the callback being invoked from an RCU read-side critical
section.

Fix this by calling rcu_read_lock() in the VXLAN driver, as already done
in the bridge driver.

[1]
WARNING: suspicious RCU usage
5.8.0-rc4-custom-01521-g481007553ce6 #29 Not tainted
-----------------------------
drivers/net/vxlan.c:1379 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by bridge/166:
 #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: netlink_dump+0xea/0x1090

stack backtrace:
CPU: 1 PID: 166 Comm: bridge Not tainted 5.8.0-rc4-custom-01521-g481007553ce6 #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
Call Trace:
 dump_stack+0x100/0x184
 lockdep_rcu_suspicious+0x153/0x15d
 vxlan_fdb_dump+0x51e/0x6d0
 rtnl_fdb_dump+0x4dc/0xad0
 netlink_dump+0x540/0x1090
 __netlink_dump_start+0x695/0x950
 rtnetlink_rcv_msg+0x802/0xbd0
 netlink_rcv_skb+0x17a/0x480
 rtnetlink_rcv+0x22/0x30
 netlink_unicast+0x5ae/0x890
 netlink_sendmsg+0x98a/0xf40
 __sys_sendto+0x279/0x3b0
 __x64_sys_sendto+0xe6/0x1a0
 do_syscall_64+0x54/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fe14fa2ade0
Code: Bad RIP value.
RSP: 002b:00007fff75bb5b88 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00005614b1ba0020 RCX: 00007fe14fa2ade0
RDX: 000000000000011c RSI: 00007fff75bb5b90 RDI: 0000000000000003
RBP: 00007fff75bb5b90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00005614b1b89160
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Fixes: 5e6d24358799 ("bridge: netlink dump interface at par with brctl")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1225,6 +1225,7 @@ static int vxlan_fdb_dump(struct sk_buff
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct vxlan_fdb *f;
 
+		rcu_read_lock();
 		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			struct vxlan_rdst *rd;
 
@@ -1237,12 +1238,15 @@ static int vxlan_fdb_dump(struct sk_buff
 						     cb->nlh->nlmsg_seq,
 						     RTM_NEWNEIGH,
 						     NLM_F_MULTI, rd);
-				if (err < 0)
+				if (err < 0) {
+					rcu_read_unlock();
 					goto out;
+				}
 skip:
 				*idx += 1;
 			}
 		}
+		rcu_read_unlock();
 	}
 out:
 	return err;


