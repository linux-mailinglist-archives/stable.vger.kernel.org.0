Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C76188181
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCQLDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgCQLDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:03:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7FA20658;
        Tue, 17 Mar 2020 11:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443032;
        bh=lVHUSe2Las6Deqqrd+fEt8BGJ0tFzFGrDD69RV3UeJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6vr8w8NieYSNlIQldQij8t73iBvj7RT4VEBLE/68dgrtSjIriCfRdp0yz5F/sphM
         vIy1LCSetljR+PvdAGLSoFVZUvcRnmp43cFlVCbNOIX2kh9HqUgOnqWMXca2QhcaRh
         /tG2hqGVF5mAU9T/jUzYFULZjGIctlRU1XmLejWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 035/123] net: memcg: fix lockdep splat in inet_csk_accept()
Date:   Tue, 17 Mar 2020 11:54:22 +0100
Message-Id: <20200317103311.496947142@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 06669ea346e476a5339033d77ef175566a40efbb upstream.

Locking newsk while still holding the listener lock triggered
a lockdep splat [1]

We can simply move the memcg code after we release the listener lock,
as this can also help if multiple threads are sharing a common listener.

Also fix a typo while reading socket sk_rmem_alloc.

[1]
WARNING: possible recursive locking detected
5.6.0-rc3-syzkaller #0 Not tainted
--------------------------------------------
syz-executor598/9524 is trying to acquire lock:
ffff88808b5b8b90 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
ffff88808b5b8b90 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x69f/0xd30 net/ipv4/inet_connection_sock.c:492

but task is already holding lock:
ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x8d/0xd30 net/ipv4/inet_connection_sock.c:445

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_INET6);
  lock(sk_lock-AF_INET6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor598/9524:
 #0: ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
 #0: ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x8d/0xd30 net/ipv4/inet_connection_sock.c:445

stack backtrace:
CPU: 0 PID: 9524 Comm: syz-executor598 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2370 [inline]
 check_deadlock kernel/locking/lockdep.c:2411 [inline]
 validate_chain kernel/locking/lockdep.c:2954 [inline]
 __lock_acquire.cold+0x114/0x288 kernel/locking/lockdep.c:3954
 lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
 lock_sock_nested+0xc5/0x110 net/core/sock.c:2947
 lock_sock include/net/sock.h:1541 [inline]
 inet_csk_accept+0x69f/0xd30 net/ipv4/inet_connection_sock.c:492
 inet_accept+0xe9/0x7c0 net/ipv4/af_inet.c:734
 __sys_accept4_file+0x3ac/0x5b0 net/socket.c:1758
 __sys_accept4+0x53/0x90 net/socket.c:1809
 __do_sys_accept4 net/socket.c:1821 [inline]
 __se_sys_accept4 net/socket.c:1818 [inline]
 __x64_sys_accept4+0x93/0xf0 net/socket.c:1818
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4445c9
Code: e8 0c 0d 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc35b37608 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004445c9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000306777 R09: 0000000000306777
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004053d0 R14: 0000000000000000 R15: 0000000000000000

Fixes: d752a4986532 ("net: memcg: late association of sock to memcg")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -483,27 +483,27 @@ struct sock *inet_csk_accept(struct sock
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
 
-	if (mem_cgroup_sockets_enabled) {
+out:
+	release_sock(sk);
+	if (newsk && mem_cgroup_sockets_enabled) {
 		int amt;
 
 		/* atomically get the memory usage, set and charge the
-		 * sk->sk_memcg.
+		 * newsk->sk_memcg.
 		 */
 		lock_sock(newsk);
 
-		/* The sk has not been accepted yet, no need to look at
-		 * sk->sk_wmem_queued.
+		/* The socket has not been accepted yet, no need to look at
+		 * newsk->sk_wmem_queued.
 		 */
 		amt = sk_mem_pages(newsk->sk_forward_alloc +
-				   atomic_read(&sk->sk_rmem_alloc));
+				   atomic_read(&newsk->sk_rmem_alloc));
 		mem_cgroup_sk_alloc(newsk);
 		if (newsk->sk_memcg && amt)
 			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
 
 		release_sock(newsk);
 	}
-out:
-	release_sock(sk);
 	if (req)
 		reqsk_put(req);
 	return newsk;


