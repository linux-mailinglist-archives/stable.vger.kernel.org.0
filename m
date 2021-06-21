Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD23AEFCC
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhFUQmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233532AbhFUQkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898FC6143D;
        Mon, 21 Jun 2021 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293022;
        bh=G+ABexRqB8Gj3u7waGSX2Xh2ttsG8xD0jmnZPDeAGOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16SWMBx2/afl+wSbELoCiDYz0VGqIbHDpCQ/d4ugudv0yVRt4gmt3grc/kiKqQKPM
         Bf9H1Zc778U1VMsJsiJdgj9tzuzWkIzapxhnmERbO7HHNd72fvs+PjNrREyAZScYeJ
         yX5WCO7Qw/1OhSvpwxMVnDSDUR6NWfbdcLwTeyqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 070/178] net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock
Date:   Mon, 21 Jun 2021 18:14:44 +0200
Message-Id: <20210621154924.924304099@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a494bd642d9120648b06bb7d28ce6d05f55a7819 ]

While unix_may_send(sk, osk) is called while osk is locked, it appears
unix_release_sock() can overwrite unix_peer() after this lock has been
released, making KCSAN unhappy.

Changing unix_release_sock() to access/change unix_peer()
before lock is released should fix this issue.

BUG: KCSAN: data-race in unix_dgram_sendmsg / unix_release_sock

write to 0xffff88810465a338 of 8 bytes by task 20852 on cpu 1:
 unix_release_sock+0x4ed/0x6e0 net/unix/af_unix.c:558
 unix_release+0x2f/0x50 net/unix/af_unix.c:859
 __sock_release net/socket.c:599 [inline]
 sock_close+0x6c/0x150 net/socket.c:1258
 __fput+0x25b/0x4e0 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x156/0x190 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:302
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88810465a338 of 8 bytes by task 20888 on cpu 0:
 unix_may_send net/unix/af_unix.c:189 [inline]
 unix_dgram_sendmsg+0x923/0x1610 net/unix/af_unix.c:1712
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff888167905400 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 20888 Comm: syz-executor.0 Not tainted 5.13.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..5d1192ceb139 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -535,12 +535,14 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	u->path.mnt = NULL;
 	state = sk->sk_state;
 	sk->sk_state = TCP_CLOSE;
+
+	skpair = unix_peer(sk);
+	unix_peer(sk) = NULL;
+
 	unix_state_unlock(sk);
 
 	wake_up_interruptible_all(&u->peer_wait);
 
-	skpair = unix_peer(sk);
-
 	if (skpair != NULL) {
 		if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) {
 			unix_state_lock(skpair);
@@ -555,7 +557,6 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 		unix_dgram_peer_wake_disconnect(sk, skpair);
 		sock_put(skpair); /* It may now die */
-		unix_peer(sk) = NULL;
 	}
 
 	/* Try to flush out this socket. Throw out buffers at least */
-- 
2.30.2



