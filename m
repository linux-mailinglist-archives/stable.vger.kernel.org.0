Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3DD3B6006
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhF1OVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhF1OV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B635661C79;
        Mon, 28 Jun 2021 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889944;
        bh=TFsLptV+Gk/46Iv+9WR3cQkcgg/VYlaSV+xb4rG/ulE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8g4SrVYPjtcozDAlbHDpRNpz2Dwpnk4PYbpHq7NLl8vdKzXeWJiz0J56dU8b+zfS
         P8bLrPSNqCTQfSFeD8lZMq5f5sEGoYILov8eKyFInFXQfvNmb25iZejhEFQYDupuNv
         DsZBMz5a7jOLSOiJmDTwSr7W2nHrDlzYQQ0ymLjLwMAP7lWtPaSHEsKPpnynbkm0iK
         mTpu6b0yUyRVxPzBvhNj5z9AoTX1e8ofGx9Z4ksBhO72rEyhVmMEX2kHrQQIXIsDjm
         Ja+hwCV6CIulFCtkrwiesDli3swEM8AETAyJzWlKT1U+fNxMtIzCNxX9EB8YplPO91
         hAJZdta/Oqq+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 040/110] inet: annotate date races around sk->sk_txhash
Date:   Mon, 28 Jun 2021 10:17:18 -0400
Message-Id: <20210628141828.31757-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b71eaed8c04f72a919a9c44e83e4ee254e69e7f3 ]

UDP sendmsg() path can be lockless, it is possible for another
thread to re-connect an change sk->sk_txhash under us.

There is no serious impact, but we can use READ_ONCE()/WRITE_ONCE()
pair to document the race.

BUG: KCSAN: data-race in __ip4_datagram_connect / skb_set_owner_w

write to 0xffff88813397920c of 4 bytes by task 30997 on cpu 1:
 sk_set_txhash include/net/sock.h:1937 [inline]
 __ip4_datagram_connect+0x69e/0x710 net/ipv4/datagram.c:75
 __ip6_datagram_connect+0x551/0x840 net/ipv6/datagram.c:189
 ip6_datagram_connect+0x2a/0x40 net/ipv6/datagram.c:272
 inet_dgram_connect+0xfd/0x180 net/ipv4/af_inet.c:580
 __sys_connect_file net/socket.c:1837 [inline]
 __sys_connect+0x245/0x280 net/socket.c:1854
 __do_sys_connect net/socket.c:1864 [inline]
 __se_sys_connect net/socket.c:1861 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1861
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88813397920c of 4 bytes by task 31039 on cpu 0:
 skb_set_hash_from_sk include/net/sock.h:2211 [inline]
 skb_set_owner_w+0x118/0x220 net/core/sock.c:2101
 sock_alloc_send_pskb+0x452/0x4e0 net/core/sock.c:2359
 sock_alloc_send_skb+0x2d/0x40 net/core/sock.c:2373
 __ip6_append_data+0x1743/0x21a0 net/ipv6/ip6_output.c:1621
 ip6_make_skb+0x258/0x420 net/ipv6/ip6_output.c:1983
 udpv6_sendmsg+0x160a/0x16b0 net/ipv6/udp.c:1527
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:642
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

value changed: 0xbca3c43d -> 0xfdb309e0

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 31039 Comm: syz-executor.2 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b98c80a7c7ae..b9bdeca1d784 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1928,7 +1928,8 @@ static inline u32 net_tx_rndhash(void)
 
 static inline void sk_set_txhash(struct sock *sk)
 {
-	sk->sk_txhash = net_tx_rndhash();
+	/* This pairs with READ_ONCE() in skb_set_hash_from_sk() */
+	WRITE_ONCE(sk->sk_txhash, net_tx_rndhash());
 }
 
 static inline bool sk_rethink_txhash(struct sock *sk)
@@ -2200,9 +2201,12 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 
 static inline void skb_set_hash_from_sk(struct sk_buff *skb, struct sock *sk)
 {
-	if (sk->sk_txhash) {
+	/* This pairs with WRITE_ONCE() in sk_set_txhash() */
+	u32 txhash = READ_ONCE(sk->sk_txhash);
+
+	if (txhash) {
 		skb->l4_hash = 1;
-		skb->hash = sk->sk_txhash;
+		skb->hash = txhash;
 	}
 }
 
-- 
2.30.2

