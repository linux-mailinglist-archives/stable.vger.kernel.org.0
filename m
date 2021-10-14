Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85542DC56
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhJNO6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhJNO55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9840610D1;
        Thu, 14 Oct 2021 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223352;
        bh=9a2yItoPg24Y+FPodP1DDYJb2d8BLz0F8kICRBTupNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaYoEEiRxISOnR4fYtUFlZ+hfCVOFsQ08KILQq33LZOBVva4McPQbZmsi9lAby2kK
         Q0OvlfHc80bmDzqn9ITNxR//g+aHVT647UVyc26KRkeD1VyLk5/H9RMTq3GgTGj2dD
         a0iTOqA8ZFcnj9QYC4H2rid3TJI2on2zrPOwlYXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/25] netlink: annotate data races around nlk->bound
Date:   Thu, 14 Oct 2021 16:53:46 +0200
Message-Id: <20211014145208.058408685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7707a4d01a648e4c655101a469c956cb11273655 ]

While existing code is correct, KCSAN is reporting
a data-race in netlink_insert / netlink_sendmsg [1]

It is correct to read nlk->bound without a lock, as netlink_autobind()
will acquire all needed locks.

[1]
BUG: KCSAN: data-race in netlink_insert / netlink_sendmsg

write to 0xffff8881031c8b30 of 1 bytes by task 18752 on cpu 0:
 netlink_insert+0x5cc/0x7f0 net/netlink/af_netlink.c:597
 netlink_autobind+0xa9/0x150 net/netlink/af_netlink.c:842
 netlink_sendmsg+0x479/0x7c0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
 __do_sys_sendmsg net/socket.c:2484 [inline]
 __se_sys_sendmsg net/socket.c:2482 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881031c8b30 of 1 bytes by task 18751 on cpu 1:
 netlink_sendmsg+0x270/0x7c0 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 __sys_sendto+0x2a8/0x370 net/socket.c:2019
 __do_sys_sendto net/socket.c:2031 [inline]
 __se_sys_sendto net/socket.c:2027 [inline]
 __x64_sys_sendto+0x74/0x90 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 18751 Comm: syz-executor.0 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: da314c9923fe ("netlink: Replace rhash_portid with bound")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 453b0efdc0d7..1b70de5898c4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -574,7 +574,10 @@ static int netlink_insert(struct sock *sk, u32 portid)
 
 	/* We need to ensure that the socket is hashed and visible. */
 	smp_wmb();
-	nlk_sk(sk)->bound = portid;
+	/* Paired with lockless reads from netlink_bind(),
+	 * netlink_connect() and netlink_sendmsg().
+	 */
+	WRITE_ONCE(nlk_sk(sk)->bound, portid);
 
 err:
 	release_sock(sk);
@@ -993,7 +996,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	else if (nlk->ngroups < 8*sizeof(groups))
 		groups &= (1UL << nlk->ngroups) - 1;
 
-	bound = nlk->bound;
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	bound = READ_ONCE(nlk->bound);
 	if (bound) {
 		/* Ensure nlk->portid is up-to-date. */
 		smp_rmb();
@@ -1073,8 +1077,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
+	 * Paired with WRITE_ONCE() in netlink_insert().
 	 */
-	if (!nlk->bound)
+	if (!READ_ONCE(nlk->bound))
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
@@ -1821,7 +1826,8 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		dst_group = nlk->dst_group;
 	}
 
-	if (!nlk->bound) {
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	if (!READ_ONCE(nlk->bound)) {
 		err = netlink_autobind(sock);
 		if (err)
 			goto out;
-- 
2.33.0



