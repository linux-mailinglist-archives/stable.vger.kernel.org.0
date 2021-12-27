Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09917480027
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbhL0PnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42748 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbhL0PlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C608ECE10D2;
        Mon, 27 Dec 2021 15:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94062C36AEA;
        Mon, 27 Dec 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619671;
        bh=Kktrb/nBLJB7/Io8SnLaJUr1CQh8xOcQU7W5HyW5+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEqXVPkgjMdOKpERKkjEbxT+ryxyLjwYmjB7dE41pwCSuAvGeTKRD93+mX+ttsdfP
         T4X3gpZaCCuQ0ZfVDJVOsPcdmAx0rkmBE+sz2irft9Gd9m8m5aPIRWwakL+4iCnl2Y
         h5I/S2kswfm66hGiOLBREac0OzYoH8ZrKrbREprM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/128] ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
Date:   Mon, 27 Dec 2021 16:30:04 +0100
Message-Id: <20211227151332.492032676@linuxfoundation.org>
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

[ Upstream commit ef57c1610dd8fba5031bf71e0db73356190de151 ]

Increase cache locality by moving rx_dst_coookie next to sk->sk_rx_dst

This removes one or two cache line misses in IPv6 early demux (TCP/UDP)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h | 1 -
 include/net/sock.h   | 2 ++
 net/ipv6/tcp_ipv6.c  | 6 +++---
 net/ipv6/udp.c       | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737c..c383630d3f065 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -282,7 +282,6 @@ struct ipv6_pinfo {
 	__be32			rcv_flowinfo;
 
 	__u32			dst_cookie;
-	__u32			rx_dst_cookie;
 
 	struct ipv6_mc_socklist	__rcu *ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
diff --git a/include/net/sock.h b/include/net/sock.h
index 752601265a955..796f859c69dd7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -260,6 +260,7 @@ struct bpf_local_storage;
   *	@sk_wq: sock wait queue and async head
   *	@sk_rx_dst: receive input route used by early demux
   *	@sk_rx_dst_ifindex: ifindex for @sk_rx_dst
+  *	@sk_rx_dst_cookie: cookie for @sk_rx_dst
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
@@ -433,6 +434,7 @@ struct sock {
 #endif
 	struct dst_entry	*sk_rx_dst;
 	int			sk_rx_dst_ifindex;
+	u32			sk_rx_dst_cookie;
 
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c72586ee517ba..42eafe35415d1 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -109,7 +109,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 		sk->sk_rx_dst = dst;
 		sk->sk_rx_dst_ifindex = skb->skb_iif;
-		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1511,7 +1511,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (dst) {
 			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
-					    dst, np->rx_dst_cookie) == NULL) {
+					    dst, sk->sk_rx_dst_cookie) == NULL) {
 				dst_release(dst);
 				sk->sk_rx_dst = NULL;
 			}
@@ -1878,7 +1878,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
 
 			if (dst)
-				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
+				dst = dst_check(dst, sk->sk_rx_dst_cookie);
 			if (dst &&
 			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index be6dc64ece29f..12c12619ee357 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -884,7 +884,7 @@ static void udp6_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	if (udp_sk_rx_dst_set(sk, dst)) {
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
-		inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1073,7 +1073,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 	dst = READ_ONCE(sk->sk_rx_dst);
 
 	if (dst)
-		dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
+		dst = dst_check(dst, sk->sk_rx_dst_cookie);
 	if (dst) {
 		/* set noref for now.
 		 * any place which wants to hold dst has to call
-- 
2.34.1



