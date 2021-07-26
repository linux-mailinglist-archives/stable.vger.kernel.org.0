Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB23D5E43
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhGZPGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235962AbhGZPGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F72A60F6E;
        Mon, 26 Jul 2021 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314397;
        bh=b6n+PlAf17eiL4aspDzeqfCt/otp91D5d3QthAesodI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1m9fGcc+B7/7pIzR5Rz5YH7pB/tvUn8LxKPdW+O89/McORgeg65Wfi6subj+2Wimh
         hF4kYyP0+027Z/xc6yjjPjuSZr7Ia9M/WEPH7PxPFQK1TjqL4kVhBzgrJh7whHYBMh
         RUSBfYG4FSLvAuE80b2gnLScyDKtTE0FYm1aPfUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 33/82] tcp: annotate data races around tp->mtu_info
Date:   Mon, 26 Jul 2021 17:38:33 +0200
Message-Id: <20210726153829.240751610@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
@@ -285,7 +285,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
-	mtu = tcp_sk(sk)->mtu_info;
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -453,7 +453,7 @@ void tcp_v4_err(struct sk_buff *icmp_skb
 			if (sk->sk_state == TCP_LISTEN)
 				goto out;
 
-			tp->mtu_info = info;
+			WRITE_ONCE(tp->mtu_info, info);
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
 			} else {
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -323,7 +323,7 @@ static void tcp_v6_mtu_reduced(struct so
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, tcp_sk(sk)->mtu_info);
+	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
 	if (!dst)
 		return;
 
@@ -412,7 +412,7 @@ static void tcp_v6_err(struct sk_buff *s
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		tp->mtu_info = ntohl(info);
+		WRITE_ONCE(tp->mtu_info, ntohl(info));
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,


