Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC57103F70
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfKTPny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52884 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731000AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004bT-1H; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Ie-07; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 20 Nov 2019 15:37:50 +0000
Message-ID: <lsq.1574264230.887661069@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 40/83] net/packet: fix race in tpacket_snd()
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 32d3182cd2cd29b2e7e04df7b0db350fbe11289f upstream.

packet_sendmsg() checks tx_ring.pg_vec to decide
if it must call tpacket_snd().

Problem is that the check is lockless, meaning another thread
can issue a concurrent setsockopt(PACKET_TX_RING ) to flip
tx_ring.pg_vec back to NULL.

Given that tpacket_snd() grabs pg_vec_lock mutex, we can
perform the check again to solve the race.

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 11429 Comm: syz-executor394 Not tainted 5.3.0-rc4+ #101
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:packet_lookup_frame+0x8d/0x270 net/packet/af_packet.c:474
Code: c1 ee 03 f7 73 0c 80 3c 0e 00 0f 85 cb 01 00 00 48 8b 0b 89 c0 4c 8d 24 c1 48 b8 00 00 00 00 00 fc ff df 4c 89 e1 48 c1 e9 03 <80> 3c 01 00 0f 85 94 01 00 00 48 8d 7b 10 4d 8b 3c 24 48 b8 00 00
RSP: 0018:ffff88809f82f7b8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8880a45c7030 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffff110148b8e06 RDI: ffff8880a45c703c
RBP: ffff88809f82f7e8 R08: ffff888087aea200 R09: fffffbfff134ae50
R10: fffffbfff134ae4f R11: ffffffff89a5727f R12: 0000000000000000
R13: 0000000000000001 R14: ffff8880a45c6ac0 R15: 0000000000000000
FS:  00007fa04716f700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa04716edb8 CR3: 0000000091eb4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 packet_current_frame net/packet/af_packet.c:487 [inline]
 tpacket_snd net/packet/af_packet.c:2667 [inline]
 packet_sendmsg+0x590/0x6250 net/packet/af_packet.c:2975
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2286,6 +2286,13 @@ static int tpacket_snd(struct packet_soc
 
 	mutex_lock(&po->pg_vec_lock);
 
+	/* packet_sendmsg() check on tx_ring.pg_vec was lockless,
+	 * we need to confirm it under protection of pg_vec_lock.
+	 */
+	if (unlikely(!po->tx_ring.pg_vec)) {
+		err = -EBUSY;
+		goto out;
+	}
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;

