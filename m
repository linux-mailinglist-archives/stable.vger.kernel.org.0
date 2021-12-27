Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E59480077
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbhL0Pqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbhL0Pma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E61C0698D3;
        Mon, 27 Dec 2021 07:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A41F0CE1070;
        Mon, 27 Dec 2021 15:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F6C36AE7;
        Mon, 27 Dec 2021 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619668;
        bh=lHBJ7PdbtynogHca8DMwqknhAqoTT0kYksLJHktF1eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEU3lCxKUwIRbbyyk6BGS4CSn2fh4bncv5uCmLGII1WlRok3sRFOofJdCDIHJAr4E
         YkNYw28/NuuABYWh6mRvrbfwcn1YOmzYOjRL/Z/Mk0pcfemAI/ukrQ+vYKw3UjC/OR
         ki4UwfoZx574L64FUbYr/YF4CJHyrFwlhaoqz4nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/128] tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
Date:   Mon, 27 Dec 2021 16:30:03 +0100
Message-Id: <20211227151332.459752751@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0c0a5ef809f9150e9229e7b13e43183b681b7a39 ]

Increase cache locality by moving rx_dst_ifindex next to sk->sk_rx_dst

This is part of an effort to reduce cache line misses in TCP fast path.

This removes one cache line miss in early demux.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_sock.h | 3 +--
 include/net/sock.h      | 3 +++
 net/ipv4/tcp_ipv4.c     | 6 +++---
 net/ipv6/tcp_ipv6.c     | 6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 89163ef8cf4be..9e1111f5915bd 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -207,11 +207,10 @@ struct inet_sock {
 	__be32			inet_saddr;
 	__s16			uc_ttl;
 	__u16			cmsg_flags;
+	struct ip_options_rcu __rcu	*inet_opt;
 	__be16			inet_sport;
 	__u16			inet_id;
 
-	struct ip_options_rcu __rcu	*inet_opt;
-	int			rx_dst_ifindex;
 	__u8			tos;
 	__u8			min_ttl;
 	__u8			mc_ttl;
diff --git a/include/net/sock.h b/include/net/sock.h
index 7ac5075f9c18a..752601265a955 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -259,6 +259,7 @@ struct bpf_local_storage;
   *	@sk_rcvbuf: size of receive buffer in bytes
   *	@sk_wq: sock wait queue and async head
   *	@sk_rx_dst: receive input route used by early demux
+  *	@sk_rx_dst_ifindex: ifindex for @sk_rx_dst
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
@@ -431,6 +432,8 @@ struct sock {
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
 	struct dst_entry	*sk_rx_dst;
+	int			sk_rx_dst_ifindex;
+
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
 	int			sk_sndbuf;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b8ce65dfc067..f6838eec6ef73 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1703,7 +1703,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    !INDIRECT_CALL_1(dst->ops->check, ipv4_dst_check,
 					     dst, 0)) {
 				dst_release(dst);
@@ -1788,7 +1788,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 			if (dst)
 				dst = dst_check(dst, 0);
 			if (dst &&
-			    inet_sk(sk)->rx_dst_ifindex == skb->skb_iif)
+			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
@@ -2201,7 +2201,7 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 	if (dst && dst_hold_safe(dst)) {
 		sk->sk_rx_dst = dst;
-		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
+		sk->sk_rx_dst_ifindex = skb->skb_iif;
 	}
 }
 EXPORT_SYMBOL(inet_sk_rx_dst_set);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b03dd02c9f13c..c72586ee517ba 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -108,7 +108,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
 		sk->sk_rx_dst = dst;
-		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
+		sk->sk_rx_dst_ifindex = skb->skb_iif;
 		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
@@ -1509,7 +1509,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
 					    dst, np->rx_dst_cookie) == NULL) {
 				dst_release(dst);
@@ -1880,7 +1880,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 			if (dst)
 				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
 			if (dst &&
-			    inet_sk(sk)->rx_dst_ifindex == skb->skb_iif)
+			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
-- 
2.34.1



