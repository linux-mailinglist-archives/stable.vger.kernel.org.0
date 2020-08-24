Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D9124FA70
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgHXIfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgHXIfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677A8206F0;
        Mon, 24 Aug 2020 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258145;
        bh=H4PJW85OSbOIF1DQ4hnrfqyHQL20ozcmuZlOID6RNzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpuQrlMTk43qtgwAWeRKtEXYVv+189LwW771Xe31sCVnq1wmAA//iF7bSQ2lkp5jD
         wEv6+vLZ+bDPU58CWu3Bw6OPsVTUVOiKcFdWA0I+MHT4c9+Wht0oHsL8oegc+jN4OA
         BV/Ko8VWOcPIc0bHYT7ZBmsvctQNPUitu32SUalE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 084/148] can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()
Date:   Mon, 24 Aug 2020 10:29:42 +0200
Message-Id: <20200824082418.078240784@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38ba8b9241f5848a49b80fddac9ab5f4692e434e ]

syzbot found that at least 2 bytes of kernel information
were leaked during getsockname() on AF_CAN CAN_J1939 socket.

Since struct sockaddr_can has in fact two holes, simply
clear the whole area before filling it with useful data.

BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
CPU: 0 PID: 8466 Comm: syz-executor511 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
 instrument_copy_to_user include/linux/instrumented.h:91 [inline]
 _copy_to_user+0x18e/0x260 lib/usercopy.c:39
 copy_to_user include/linux/uaccess.h:186 [inline]
 move_addr_to_user+0x3de/0x670 net/socket.c:237
 __sys_getsockname+0x407/0x5e0 net/socket.c:1909
 __do_sys_getsockname net/socket.c:1920 [inline]
 __se_sys_getsockname+0x91/0xb0 net/socket.c:1917
 __x64_sys_getsockname+0x4a/0x70 net/socket.c:1917
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440219
Code: Bad RIP value.
RSP: 002b:00007ffe5ee150c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000033
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440219
RDX: 0000000020000240 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000

Local variable ----address@__sys_getsockname created at:
 __sys_getsockname+0x91/0x5e0 net/socket.c:1894
 __sys_getsockname+0x91/0x5e0 net/socket.c:1894

Bytes 2-3 of 24 are uninitialized
Memory access of size 24 starts at ffff8880ba2c7de8
Data copied to user address 0000000020000100

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: linux-can@vger.kernel.org
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200813161834.4021638-1-edumazet@google.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 11d566c70a944..1b7dc1a8547f3 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -561,6 +561,11 @@ static int j1939_sk_connect(struct socket *sock, struct sockaddr *uaddr,
 static void j1939_sk_sock2sockaddr_can(struct sockaddr_can *addr,
 				       const struct j1939_sock *jsk, int peer)
 {
+	/* There are two holes (2 bytes and 3 bytes) to clear to avoid
+	 * leaking kernel information to user space.
+	 */
+	memset(addr, 0, J1939_MIN_NAMELEN);
+
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = jsk->ifindex;
 	addr->can_addr.j1939.pgn = jsk->addr.pgn;
-- 
2.25.1



