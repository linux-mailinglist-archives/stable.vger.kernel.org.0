Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A796168C
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfGGTkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58042 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727671AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006ji-I8; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0005er-4p; Sun, 07 Jul 2019 20:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Arvid Brodin" <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.974782229@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 106/129] net/hsr: fix possible crash in add_timer()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 1e027960edfaa6a43f9ca31081729b716598112b upstream.

syzbot found another add_timer() issue, this time in net/hsr [1]

Let's use mod_timer() which is safe.

[1]
kernel BUG at kernel/time/timer.c:1136!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15909 Comm: syz-executor.3 Not tainted 5.0.0+ #97
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
kobject: 'loop2' (00000000f5629718): kobject_uevent_env
RIP: 0010:add_timer kernel/time/timer.c:1136 [inline]
RIP: 0010:add_timer+0x654/0xbe0 kernel/time/timer.c:1134
Code: 0f 94 c5 31 ff 44 89 ee e8 09 61 0f 00 45 84 ed 0f 84 77 fd ff ff e8 bb 5f 0f 00 e8 07 10 a0 ff e9 68 fd ff ff e8 ac 5f 0f 00 <0f> 0b e8 a5 5f 0f 00 0f 0b e8 9e 5f 0f 00 4c 89 b5 58 ff ff ff e9
RSP: 0018:ffff8880656eeca0 EFLAGS: 00010246
kobject: 'loop2' (00000000f5629718): fill_kobj_path: path = '/devices/virtual/block/loop2'
RAX: 0000000000040000 RBX: 1ffff1100caddd9a RCX: ffffc9000c436000
RDX: 0000000000040000 RSI: ffffffff816056c4 RDI: ffff88806a2f6cc8
RBP: ffff8880656eed58 R08: ffff888067f4a300 R09: ffff888067f4abc8
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88806a2f6cc0
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff8880656eed30
FS:  00007fc2019bf700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000738000 CR3: 0000000067e8e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hsr_check_announce net/hsr/hsr_device.c:99 [inline]
 hsr_check_carrier_and_operstate+0x567/0x6f0 net/hsr/hsr_device.c:120
 hsr_netdev_notify+0x297/0xa00 net/hsr/hsr_main.c:51
 notifier_call_chain+0xc7/0x240 kernel/notifier.c:93
 __raw_notifier_call_chain kernel/notifier.c:394 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:401
 call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1739
 call_netdevice_notifiers_extack net/core/dev.c:1751 [inline]
 call_netdevice_notifiers net/core/dev.c:1765 [inline]
 dev_open net/core/dev.c:1436 [inline]
 dev_open+0x143/0x160 net/core/dev.c:1424
 team_port_add drivers/net/team/team.c:1203 [inline]
 team_add_slave+0xa07/0x15d0 drivers/net/team/team.c:1933
 do_set_master net/core/rtnetlink.c:2358 [inline]
 do_set_master+0x1d4/0x230 net/core/rtnetlink.c:2332
 do_setlink+0x966/0x3510 net/core/rtnetlink.c:2493
 rtnl_setlink+0x271/0x3b0 net/core/rtnetlink.c:2747
 rtnetlink_rcv_msg+0x465/0xb00 net/core/rtnetlink.c:5192
 netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2485
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5210
 netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
 netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1336
 netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1925
 sock_sendmsg_nosec net/socket.c:622 [inline]
 sock_sendmsg+0xdd/0x130 net/socket.c:632
 sock_write_iter+0x27c/0x3e0 net/socket.c:923
 call_write_iter include/linux/fs.h:1869 [inline]
 do_iter_readv_writev+0x5e0/0x8e0 fs/read_write.c:680
 do_iter_write fs/read_write.c:956 [inline]
 do_iter_write+0x184/0x610 fs/read_write.c:937
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1001
 do_writev+0xf6/0x290 fs/read_write.c:1036
 __do_sys_writev fs/read_write.c:1109 [inline]
 __se_sys_writev fs/read_write.c:1106 [inline]
 __x64_sys_writev+0x75/0xb0 fs/read_write.c:1106
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457f29
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc2019bec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457f29
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc2019bf6d4
R13: 00000000004c4a60 R14: 00000000004dd218 R15: 00000000ffffffff

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/hsr/hsr_device.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -78,9 +78,8 @@ void hsr_check_announce(struct net_devic
 	if ((hsr_dev->operstate == IF_OPER_UP) && (old_operstate != IF_OPER_UP)) {
 		/* Went up */
 		hsr_priv->announce_count = 0;
-		hsr_priv->announce_timer.expires = jiffies +
-				msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
-		add_timer(&hsr_priv->announce_timer);
+		mod_timer(&hsr_priv->announce_timer,
+			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
 	}
 
 	if ((hsr_dev->operstate != IF_OPER_UP) && (old_operstate == IF_OPER_UP))
@@ -361,6 +360,7 @@ out:
 static void hsr_announce(unsigned long data)
 {
 	struct hsr_priv *hsr_priv;
+	unsigned long interval;
 
 	hsr_priv = (struct hsr_priv *) data;
 
@@ -372,14 +372,12 @@ static void hsr_announce(unsigned long d
 	}
 
 	if (hsr_priv->announce_count < 3)
-		hsr_priv->announce_timer.expires = jiffies +
-				msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
+		interval = msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
 	else
-		hsr_priv->announce_timer.expires = jiffies +
-				msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
+		interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
 
 	if (is_admin_up(hsr_priv->dev))
-		add_timer(&hsr_priv->announce_timer);
+		mod_timer(&hsr_priv->announce_timer, jiffies + interval);
 }
 
 

