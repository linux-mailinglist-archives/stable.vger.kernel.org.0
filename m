Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D148E3D2A3B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhGVQKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234220AbhGVQI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A82161DC7;
        Thu, 22 Jul 2021 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972524;
        bh=ThXlEs92FBXVCti8cyyCvp0sAcHbzL4TpZlBG5kLZms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/m3on6pubRkUoawjeqS67icGX1DoSAvpP4ij57nNIFEcEG/WiO0zaCTqjKvBy0XK
         T5ipBbtXeH49Wu+39Vnyyzt/cfN7m/PJ9EPkVdkQ7+mEvYGRSgOYadcKq+vhat//rQ
         9Vy9+xj8jzUVXQIWEoP6QNpcNABaiwWKYMc9gXpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 144/156] tcp: annotate data races around tp->mtu_info
Date:   Thu, 22 Jul 2021 18:31:59 +0200
Message-Id: <20210722155633.000585204@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 561022acb1ce62e50f7a8258687a21b84282a4cb upstream.

While tp->mtu_info is read while socket is owned, the write
sides happen from err handlers (tcp_v[46]_mtu_reduced)
which only own the socket spinlock.

Fixes: 563d34d05786 ("tcp: dont drop MTU reduction indications")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 net/ipv6/tcp_ipv6.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -342,7 +342,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
-	mtu = tcp_sk(sk)->mtu_info;
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -546,7 +546,7 @@ int tcp_v4_err(struct sk_buff *skb, u32
 			if (sk->sk_state == TCP_LISTEN)
 				goto out;
 
-			tp->mtu_info = info;
+			WRITE_ONCE(tp->mtu_info, info);
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
 			} else {
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -352,7 +352,7 @@ static void tcp_v6_mtu_reduced(struct so
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, tcp_sk(sk)->mtu_info);
+	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
 	if (!dst)
 		return;
 
@@ -443,7 +443,7 @@ static int tcp_v6_err(struct sk_buff *sk
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		tp->mtu_info = ntohl(info);
+		WRITE_ONCE(tp->mtu_info, ntohl(info));
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,


