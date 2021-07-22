Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1393D2813
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhGVPym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231496AbhGVPyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C70D60FDA;
        Thu, 22 Jul 2021 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971711;
        bh=qrwhnCqnbNlsgG5u/FndlL+E3iehi9S7WGotNt8LMSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCvqUh2OGZRbiflFfecVxqgtQ80HgdXLFPVZ+P1OcXCL8/uqy4gjhhkE0AGRPiWPu
         onLzl6dhiUmNvZvGaIY8y1RxAre8v27YF52ZIB4UZxsenKoUavFIbuzObU9hGzHj6/
         DBHFSSVoCgvO3Io0eRTxETd4IVx7NASTjp54UV6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 68/71] ipv6: tcp: drop silly ICMPv6 packet too big messages
Date:   Thu, 22 Jul 2021 18:31:43 +0200
Message-Id: <20210722155620.180013074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit c7bb4b89033b764eb07db4e060548a6311d801ee upstream.

While TCP stack scales reasonably well, there is still one part that
can be used to DDOS it.

IPv6 Packet too big messages have to lookup/insert a new route,
and if abused by attackers, can easily put hosts under high stress,
with many cpus contending on a spinlock while one is stuck in fib6_run_gc()

ip6_protocol_deliver_rcu()
 icmpv6_rcv()
  icmpv6_notify()
   tcp_v6_err()
    tcp_v6_mtu_reduced()
     inet6_csk_update_pmtu()
      ip6_rt_update_pmtu()
       __ip6_rt_update_pmtu()
        ip6_rt_cache_alloc()
         ip6_dst_alloc()
          dst_alloc()
           ip6_dst_gc()
            fib6_run_gc()
             spin_lock_bh() ...

Some of our servers have been hit by malicious ICMPv6 packets
trying to _increase_ the MTU/MSS of TCP flows.

We believe these ICMPv6 packets are a result of a bug in one ISP stack,
since they were blindly sent back for _every_ (small) packet sent to them.

These packets are for one TCP flow:
09:24:36.266491 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.266509 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.316688 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.316704 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.608151 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240

TCP stack can filter some silly requests :

1) MTU below IPV6_MIN_MTU can be filtered early in tcp_v6_err()
2) tcp_v6_mtu_reduced() can drop requests trying to increase current MSS.

This tests happen before the IPv6 routing stack is entered, thus
removing the potential contention and route exhaustion.

Note that IPv6 stack was performing these checks, but too late
(ie : after the route has been added, and after the potential
garbage collect war)

v2: fix typo caught by Martin, thanks !
v3: exports tcp_mtu_to_mss(), caught by David, thanks !

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    1 +
 net/ipv6/tcp_ipv6.c   |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1504,6 +1504,7 @@ int tcp_mtu_to_mss(struct sock *sk, int
 	return __tcp_mtu_to_mss(sk, pmtu) -
 	       (tcp_sk(sk)->tcp_header_len - sizeof(struct tcphdr));
 }
+EXPORT_SYMBOL(tcp_mtu_to_mss);
 
 /* Inverse of above */
 int tcp_mss_to_mtu(struct sock *sk, int mss)
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -343,11 +343,20 @@ failure:
 static void tcp_v6_mtu_reduced(struct sock *sk)
 {
 	struct dst_entry *dst;
+	u32 mtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
+
+	/* Drop requests trying to increase our current mss.
+	 * Check done in __ip6_rt_update_pmtu() is too late.
+	 */
+	if (tcp_mtu_to_mss(sk, mtu) >= tcp_sk(sk)->mss_cache)
+		return;
+
+	dst = inet6_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
 
@@ -428,6 +437,8 @@ static int tcp_v6_err(struct sk_buff *sk
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
+		u32 mtu = ntohl(info);
+
 		/* We are not interested in TCP_LISTEN and open_requests
 		 * (SYN-ACKs send out by Linux are always <576bytes so
 		 * they should go through unfragmented).
@@ -438,7 +449,11 @@ static int tcp_v6_err(struct sk_buff *sk
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		WRITE_ONCE(tp->mtu_info, ntohl(info));
+		if (mtu < IPV6_MIN_MTU)
+			goto out;
+
+		WRITE_ONCE(tp->mtu_info, mtu);
+
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,


