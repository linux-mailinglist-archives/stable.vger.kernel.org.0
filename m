Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5630A428F61
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbhJKN57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235237AbhJKN4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D446103C;
        Mon, 11 Oct 2021 13:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960403;
        bh=k0cc0XDtPoedpZGti/tFpfW0LBpBeerD0iGtfvhrWBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iajFUkaatzuMAnJy1Vy72vinRgJEop5u7MG9AS3L/yWIt/xa65UdFfByIxdHXUR1y
         Hzk7nqkKe2/vgqH1ZGG0YqUb7sOwRCH1ot163ddzdexWgagQZu95fVymMibrOcEMTM
         CtQz5ADkhc6rkBm8sL4R8XDdMKQBwyskBciiK42A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/83] netlink: annotate data races around nlk->bound
Date:   Mon, 11 Oct 2021 15:46:11 +0200
Message-Id: <20211011134510.155411029@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
index 8434da3c0487..0886267ea81e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -586,7 +586,10 @@ static int netlink_insert(struct sock *sk, u32 portid)
 
 	/* We need to ensure that the socket is hashed and visible. */
 	smp_wmb();
-	nlk_sk(sk)->bound = portid;
+	/* Paired with lockless reads from netlink_bind(),
+	 * netlink_connect() and netlink_sendmsg().
+	 */
+	WRITE_ONCE(nlk_sk(sk)->bound, portid);
 
 err:
 	release_sock(sk);
@@ -1004,7 +1007,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	if (nlk->ngroups < BITS_PER_LONG)
 		groups &= (1UL << nlk->ngroups) - 1;
 
-	bound = nlk->bound;
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	bound = READ_ONCE(nlk->bound);
 	if (bound) {
 		/* Ensure nlk->portid is up-to-date. */
 		smp_rmb();
@@ -1090,8 +1094,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
+	 * Paired with WRITE_ONCE() in netlink_insert().
 	 */
-	if (!nlk->bound)
+	if (!READ_ONCE(nlk->bound))
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
@@ -1880,7 +1885,8 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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



