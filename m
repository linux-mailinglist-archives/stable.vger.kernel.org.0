Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8F31220CD
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLQA6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34880 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfLQAvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003L6-O4; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005UV-PL; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>
Date:   Tue, 17 Dec 2019 00:46:14 +0000
Message-ID: <lsq.1576543535.132377422@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 040/136] sch_dsmark: fix potential NULL deref in
 dsmark_init()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 474f0813a3002cb299bb73a5a93aa1f537a80ca8 upstream.

Make sure TCA_DSMARK_INDICES was provided by the user.

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8799 Comm: syz-executor235 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u16 include/net/netlink.h:1501 [inline]
RIP: 0010:dsmark_init net/sched/sch_dsmark.c:364 [inline]
RIP: 0010:dsmark_init+0x193/0x640 net/sched/sch_dsmark.c:339
Code: 85 db 58 0f 88 7d 03 00 00 e8 e9 1a ac fb 48 8b 9d 70 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 ca
RSP: 0018:ffff88809426f3b8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff85c6eb09
RDX: 0000000000000000 RSI: ffffffff85c6eb17 RDI: 0000000000000004
RBP: ffff88809426f4b0 R08: ffff88808c4085c0 R09: ffffed1015d26159
R10: ffffed1015d26158 R11: ffff8880ae930ac7 R12: ffff8880a7e96940
R13: dffffc0000000000 R14: ffff88809426f8c0 R15: 0000000000000000
FS:  0000000001292880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000008ca1b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 qdisc_create+0x4ee/0x1210 net/sched/sch_api.c:1237
 tc_modify_qdisc+0x524/0x1c50 net/sched/sch_api.c:1653
 rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5223
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x803/0x920 net/socket.c:2311
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
 __do_sys_sendmsg net/socket.c:2365 [inline]
 __se_sys_sendmsg net/socket.c:2363 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
 do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440369

Fixes: 758cc43c6d73 ("[PKT_SCHED]: Fix dsmark to apply changes consistent")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_dsmark.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -359,6 +359,8 @@ static int dsmark_init(struct Qdisc *sch
 		goto errout;
 
 	err = -EINVAL;
+	if (!tb[TCA_DSMARK_INDICES])
+		goto errout;
 	indices = nla_get_u16(tb[TCA_DSMARK_INDICES]);
 
 	if (hweight32(indices) != 1)

