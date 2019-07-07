Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F83616A1
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfGGTlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57858 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006kW-B1; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005g2-5Z; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "syzbot" <syzkaller@googlegroups.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.980227516@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 119/129] l2tp: fix infoleak in l2tp_ip6_recvmsg()
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

commit 163d1c3d6f17556ed3c340d3789ea93be95d6c28 upstream.

Back in 2013 Hannes took care of most of such leaks in commit
bceaa90240b6 ("inet: prevent leakage of uninitialized memory to user in recv syscalls")

But the bug in l2tp_ip6_recvmsg() has not been fixed.

syzbot report :

BUG: KMSAN: kernel-infoleak in _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
CPU: 1 PID: 10996 Comm: syz-executor362 Not tainted 5.0.0+ #11
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x173/0x1d0 lib/dump_stack.c:113
 kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:600
 kmsan_internal_check_memory+0x9f4/0xb10 mm/kmsan/kmsan.c:694
 kmsan_copy_to_user+0xab/0xc0 mm/kmsan/kmsan_hooks.c:601
 _copy_to_user+0x16b/0x1f0 lib/usercopy.c:32
 copy_to_user include/linux/uaccess.h:174 [inline]
 move_addr_to_user+0x311/0x570 net/socket.c:227
 ___sys_recvmsg+0xb65/0x1310 net/socket.c:2283
 do_recvmmsg+0x646/0x10c0 net/socket.c:2390
 __sys_recvmmsg net/socket.c:2469 [inline]
 __do_sys_recvmmsg net/socket.c:2492 [inline]
 __se_sys_recvmmsg+0x1d1/0x350 net/socket.c:2485
 __x64_sys_recvmmsg+0x62/0x80 net/socket.c:2485
 do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x445819
Code: e8 6c b6 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f64453eddb8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000006dac28 RCX: 0000000000445819
RDX: 0000000000000005 RSI: 0000000020002f80 RDI: 0000000000000003
RBP: 00000000006dac20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dac2c
R13: 00007ffeba8f87af R14: 00007f64453ee9c0 R15: 20c49ba5e353f7cf

Local variable description: ----addr@___sys_recvmsg
Variable was created at:
 ___sys_recvmsg+0xf6/0x1310 net/socket.c:2244
 do_recvmmsg+0x646/0x10c0 net/socket.c:2390

Bytes 0-31 of 32 are uninitialized
Memory access of size 32 starts at ffff8880ae62fbb0
Data copied to user address 0000000020000000

Fixes: a32e0eec7042 ("l2tp: introduce L2TPv3 IP encapsulation support for IPv6")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ip6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -664,9 +664,6 @@ static int l2tp_ip6_recvmsg(struct kiocb
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*lsa);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
@@ -696,6 +693,7 @@ static int l2tp_ip6_recvmsg(struct kiocb
 		lsa->l2tp_conn_id = 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id = IP6CB(skb)->iif;
+		*addr_len = sizeof(*lsa);
 	}
 
 	if (np->rxopt.all)

