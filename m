Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9299A3B60F5
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhF1ObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234680AbhF1OaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 262D361C93;
        Mon, 28 Jun 2021 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890402;
        bh=OJa9x3rF5DAuxqWGRDFjE4Ve4z8rxj7a0u/C6ki5S4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBdKyIahnoRZmhQ2tNzADGgZXszXO8dcDmB38TnretaA9TfLDHrU+zedgXoiAMD5R
         swfhQlsa9ba26L3SA2Uet2keAeqrtFkszrtnHkxzMh/+7mG2Va9bDo/vnVYqthn1Sp
         sGI21heGdtHot1USgcYaWFCFVc2B+b3eFBc1gYWSr+fby2ODqy4/TukevHQlkMVCQv
         FDv8wAXNAp7xZkxt4qmse71uibRLz1I76HCOJtplXP6G3ZrvXxFi17I5VcEmRa5t43
         Zygobmd9kBJkS5Kn9Yy+566IJwJe29EwHea0bP58B59qZQ3NH2hMGdzyXeHBYip46s
         8wJuBaDNrh6Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/101] inet: annotate date races around sk->sk_txhash
Date:   Mon, 28 Jun 2021 10:25:05 -0400
Message-Id: <20210628142607.32218-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 9199ab7ab2da..3c7addf95150 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1900,7 +1900,8 @@ static inline u32 net_tx_rndhash(void)
 
 static inline void sk_set_txhash(struct sock *sk)
 {
-	sk->sk_txhash = net_tx_rndhash();
+	/* This pairs with READ_ONCE() in skb_set_hash_from_sk() */
+	WRITE_ONCE(sk->sk_txhash, net_tx_rndhash());
 }
 
 static inline bool sk_rethink_txhash(struct sock *sk)
@@ -2172,9 +2173,12 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 
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

