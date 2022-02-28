Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6895D4C75A7
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiB1Rz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiB1Rx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B84B0EA7;
        Mon, 28 Feb 2022 09:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F39F61594;
        Mon, 28 Feb 2022 17:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77854C340E7;
        Mon, 28 Feb 2022 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070099;
        bh=Deh0yLei9Fa2GBCl8z4iR3R8y7VFqMX0cIU0TwjK5y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7si+thT/5vZi5VEgFcXgsu1ktpET3FESKIsIjq7/pPx4m7Vl/fhyB8OBDKyYI4Wk
         YGvb1OJlNxMnyVlFzHOdpFUhUVNce2Asd9UiWlv68HV/vNlfRZmvY3gg7UQnKiXjHQ
         cuW1+6U14y++ufovMfFRuAMnM0jnalJQ2AetZWso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/139] net-timestamp: convert sk->sk_tskey to atomic_t
Date:   Mon, 28 Feb 2022 18:24:22 +0100
Message-Id: <20220228172356.894201067@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a1cdec57e03a1352e92fbbe7974039dda4efcec0 ]

UDP sendmsg() can be lockless, this is causing all kinds
of data races.

This patch converts sk->sk_tskey to remove one of these races.

BUG: KCSAN: data-race in __ip_append_data / __ip_append_data

read to 0xffff8881035d4b6c of 4 bytes by task 8877 on cpu 1:
 __ip_append_data+0x1c1/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881035d4b6c of 4 bytes by task 8880 on cpu 0:
 __ip_append_data+0x1d8/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000054d -> 0x0000054e

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 8880 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00167-gdcb85f85fa6f-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h        | 4 ++--
 net/can/j1939/transport.c | 2 +-
 net/core/skbuff.c         | 2 +-
 net/core/sock.c           | 4 ++--
 net/ipv4/ip_output.c      | 2 +-
 net/ipv6/ip6_output.c     | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dfb92f91d5be5..7d49196a3880e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -506,7 +506,7 @@ struct sock {
 	u16			sk_tsflags;
 	int			sk_bind_phc;
 	u8			sk_shutdown;
-	u32			sk_tskey;
+	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
 
 	u8			sk_clockid;
@@ -2598,7 +2598,7 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		__sock_tx_timestamp(tsflags, tx_flags);
 		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
 		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
-			*tskey = sk->sk_tskey++;
+			*tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a271688780a2c..307ee1174a6e2 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2006,7 +2006,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		/* set the end-packet for broadcast */
 		session->pkt.last = session->pkt.total;
 
-	skcb->tskey = session->sk->sk_tskey++;
+	skcb->tskey = atomic_inc_return(&session->sk->sk_tskey) - 1;
 	session->tskey = skcb->tskey;
 
 	return session;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bb4dce8fd0405..449a96e358ad5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4844,7 +4844,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
 		if (sk->sk_protocol == IPPROTO_TCP &&
 		    sk->sk_type == SOCK_STREAM)
-			serr->ee.ee_data -= sk->sk_tskey;
+			serr->ee.ee_data -= atomic_read(&sk->sk_tskey);
 	}
 
 	err = sock_queue_err_skb(sk, skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index 6ea317f84edd2..deaed1b206823 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -866,9 +866,9 @@ int sock_set_timestamping(struct sock *sk, int optname,
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			sk->sk_tskey = tcp_sk(sk)->snd_una;
+			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
-			sk->sk_tskey = 0;
+			atomic_set(&sk->sk_tskey, 0);
 		}
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a4d2eb691cbc1..131066d0319a2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -992,7 +992,7 @@ static int __ip_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4e83e2a5068..22bf8fb617165 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1465,7 +1465,7 @@ static int __ip6_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
-- 
2.34.1



