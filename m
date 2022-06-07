Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40C5541B36
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381313AbiFGVm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381454AbiFGVko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812062332CC;
        Tue,  7 Jun 2022 12:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4CF1B823AE;
        Tue,  7 Jun 2022 19:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA27C385A2;
        Tue,  7 Jun 2022 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628816;
        bh=7B96NCyCY60ye0SkM8jPVgARvQMd8SFvkOC/kaQfVcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAb9mQrc8d4Wt+r0pDxhQWH/Nekjt8P9bVUU8RgXHoHrJ4uvrc0x/9BTgrdeazxcK
         tBantCGt853jdGvlLdBaeodrqfzyWvkEir8ZvqKB866844+D50vt1f5RoMkZ5MfUg9
         SXu/lbxbUAfUov1WlAICTYNaq1DjERSpzw8jmmh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 467/879] net: annotate races around sk->sk_bound_dev_if
Date:   Tue,  7 Jun 2022 18:59:45 +0200
Message-Id: <20220607165016.433231259@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4c971d2f3548e4f11b1460ac048f5307e4b39fdb ]

UDP sendmsg() is lockless, and reads sk->sk_bound_dev_if while
this field can be changed by another thread.

Adds minimal annotations to avoid KCSAN splats for UDP.
Following patches will add more annotations to potential lockless readers.

BUG: KCSAN: data-race in __ip6_datagram_connect / udpv6_sendmsg

write to 0xffff888136d47a94 of 4 bytes by task 7681 on cpu 0:
 __ip6_datagram_connect+0x6e2/0x930 net/ipv6/datagram.c:221
 ip6_datagram_connect+0x2a/0x40 net/ipv6/datagram.c:272
 inet_dgram_connect+0x107/0x190 net/ipv4/af_inet.c:576
 __sys_connect_file net/socket.c:1900 [inline]
 __sys_connect+0x197/0x1b0 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x50 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888136d47a94 of 4 bytes by task 7670 on cpu 1:
 udpv6_sendmsg+0xc60/0x16e0 net/ipv6/udp.c:1436
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:652
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x50 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0xffffff9b

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7670 Comm: syz-executor.3 Tainted: G        W         5.18.0-rc1-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

I chose to not add Fixes: tag because race has minor consequences
and stable teams busy enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h    |  2 +-
 include/net/sock.h  |  5 +++--
 net/ipv6/datagram.c |  6 +++---
 net/ipv6/udp.c      | 11 ++++++-----
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 0161137914cf..26fffda78cca 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -94,7 +94,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 
 	ipcm->sockc.mark = inet->sk.sk_mark;
 	ipcm->sockc.tsflags = inet->sk.sk_tsflags;
-	ipcm->oif = inet->sk.sk_bound_dev_if;
+	ipcm->oif = READ_ONCE(inet->sk.sk_bound_dev_if);
 	ipcm->addr = inet->inet_saddr;
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..3c4fb8f03fd9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2866,13 +2866,14 @@ static inline void sk_pacing_shift_update(struct sock *sk, int val)
  */
 static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 	int mdif;
 
-	if (!sk->sk_bound_dev_if || sk->sk_bound_dev_if == dif)
+	if (!bound_dev_if || bound_dev_if == dif)
 		return true;
 
 	mdif = l3mdev_master_ifindex_by_index(sock_net(sk), dif);
-	if (mdif && mdif == sk->sk_bound_dev_if)
+	if (mdif && mdif == bound_dev_if)
 		return true;
 
 	return false;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f66310a88..0324e2685016 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -218,11 +218,11 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 				err = -EINVAL;
 				goto out;
 			}
-			sk->sk_bound_dev_if = usin->sin6_scope_id;
+			WRITE_ONCE(sk->sk_bound_dev_if, usin->sin6_scope_id);
 		}
 
 		if (!sk->sk_bound_dev_if && (addr_type & IPV6_ADDR_MULTICAST))
-			sk->sk_bound_dev_if = np->mcast_oif;
+			WRITE_ONCE(sk->sk_bound_dev_if, np->mcast_oif);
 
 		/* Connect to link-local address requires an interface */
 		if (!sk->sk_bound_dev_if) {
@@ -798,7 +798,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 			if (src_idx) {
 				if (fl6->flowi6_oif &&
 				    src_idx != fl6->flowi6_oif &&
-				    (sk->sk_bound_dev_if != fl6->flowi6_oif ||
+				    (READ_ONCE(sk->sk_bound_dev_if) != fl6->flowi6_oif ||
 				     !sk_dev_equal_l3scope(sk, src_idx)))
 					return -EINVAL;
 				fl6->flowi6_oif = src_idx;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7f0fa9bd9ffe..a535c3f2e4af 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -105,7 +105,7 @@ static int compute_score(struct sock *sk, struct net *net,
 			 const struct in6_addr *daddr, unsigned short hnum,
 			 int dif, int sdif)
 {
-	int score;
+	int bound_dev_if, score;
 	struct inet_sock *inet;
 	bool dev_match;
 
@@ -132,10 +132,11 @@ static int compute_score(struct sock *sk, struct net *net,
 		score++;
 	}
 
-	dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	dev_match = udp_sk_bound_dev_eq(net, bound_dev_if, dif, sdif);
 	if (!dev_match)
 		return -1;
-	if (sk->sk_bound_dev_if)
+	if (bound_dev_if)
 		score++;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
@@ -789,7 +790,7 @@ static bool __udp_v6_is_mcast_sock(struct net *net, struct sock *sk,
 	    (inet->inet_dport && inet->inet_dport != rmt_port) ||
 	    (!ipv6_addr_any(&sk->sk_v6_daddr) &&
 		    !ipv6_addr_equal(&sk->sk_v6_daddr, rmt_addr)) ||
-	    !udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif) ||
+	    !udp_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif, sdif) ||
 	    (!ipv6_addr_any(&sk->sk_v6_rcv_saddr) &&
 		    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, loc_addr)))
 		return false;
@@ -1433,7 +1434,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	if (!fl6->flowi6_oif)
-		fl6->flowi6_oif = sk->sk_bound_dev_if;
+		fl6->flowi6_oif = READ_ONCE(sk->sk_bound_dev_if);
 
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
-- 
2.35.1



