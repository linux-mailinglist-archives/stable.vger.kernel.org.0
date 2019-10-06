Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9449CCD458
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfJFRYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfJFRYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5559120867;
        Sun,  6 Oct 2019 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382683;
        bh=EZXCOgWMcyDlbQcr4EQRifzZAxCGdL9unuxEcc414Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrE9yWNc5NzsOYrM6MT6ld2xl0kwK4NOAaWmPviTzqmNH+g8tN8g3Fd3Yk+LO9/Z7
         Li2ZjMCxMzM4B9EE1YNyvPL6XGnDXO2ZzxfZlHeH2obtnALRaBkf6mbqipShn2zLbO
         yB5HDQ/g1BZV0gRI7FdbYJBDqYtwzeWSyIfuHTmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 40/47] sch_dsmark: fix potential NULL deref in dsmark_init()
Date:   Sun,  6 Oct 2019 19:21:27 +0200
Message-Id: <20191006172019.001134445@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 474f0813a3002cb299bb73a5a93aa1f537a80ca8 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_dsmark.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -346,6 +346,8 @@ static int dsmark_init(struct Qdisc *sch
 		goto errout;
 
 	err = -EINVAL;
+	if (!tb[TCA_DSMARK_INDICES])
+		goto errout;
 	indices = nla_get_u16(tb[TCA_DSMARK_INDICES]);
 
 	if (hweight32(indices) != 1)


