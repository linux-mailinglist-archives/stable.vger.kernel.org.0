Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1854B5B710F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiIMOjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiIMOhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:37:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1486B8FC;
        Tue, 13 Sep 2022 07:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2864614A3;
        Tue, 13 Sep 2022 14:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D4C433C1;
        Tue, 13 Sep 2022 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078832;
        bh=edoBU3kqkr78K833epVPUQ0zlOLhFwcAFAwLdPTlNp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyEbCY0MMYtuga+aypy62FY5qJmp4AQxxWNpiEeKcsx388hor/AIOBZda/B2a1Ie8
         4g/M+UdVQ5lWUCJlVNwxuW9q79/E1x32J7Gz1yVhPHbwsaC7uSH2CQfs3xTbj63GiD
         wpX51U4jK3EjHtRmncRlYZ3VGyqnpZZAH8cEY24A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/121] rxrpc: Fix ICMP/ICMP6 error handling
Date:   Tue, 13 Sep 2022 16:04:24 +0200
Message-Id: <20220913140400.509651549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit ac56a0b48da86fd1b4389632fb7c4c8a5d86eefa ]

Because rxrpc pretends to be a tunnel on top of a UDP/UDP6 socket, allowing
it to siphon off UDP packets early in the handling of received UDP packets
thereby avoiding the packet going through the UDP receive queue, it doesn't
get ICMP packets through the UDP ->sk_error_report() callback.  In fact, it
doesn't appear that there's any usable option for getting hold of ICMP
packets.

Fix this by adding a new UDP encap hook to distribute error messages for
UDP tunnels.  If the hook is set, then the tunnel driver will be able to
see ICMP packets.  The hook provides the offset into the packet of the UDP
header of the original packet that caused the notification.

An alternative would be to call the ->error_handler() hook - but that
requires that the skbuff be cloned (as ip_icmp_error() or ipv6_cmp_error()
do, though isn't really necessary or desirable in rxrpc's case is we want
to parse them there and then, not queue them).

Changes
=======
ver #3)
 - Fixed an uninitialised variable.

ver #2)
 - Fixed some missing CONFIG_AF_RXRPC_IPV6 conditionals.

Fixes: 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h        |   1 +
 include/net/udp_tunnel.h   |   4 +
 net/ipv4/udp.c             |   2 +
 net/ipv4/udp_tunnel_core.c |   1 +
 net/ipv6/udp.c             |   5 +-
 net/rxrpc/ar-internal.h    |   1 +
 net/rxrpc/local_object.c   |   1 +
 net/rxrpc/peer_event.c     | 293 ++++++++++++++++++++++++++++++++-----
 8 files changed, 270 insertions(+), 38 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index ae66dadd85434..0727276e7538c 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -75,6 +75,7 @@ struct udp_sock {
 	 * For encapsulation sockets.
 	 */
 	int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
+	void (*encap_err_rcv)(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 	int (*encap_err_lookup)(struct sock *sk, struct sk_buff *skb);
 	void (*encap_destroy)(struct sock *sk);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index afc7ce713657b..72394f441dad8 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -67,6 +67,9 @@ static inline int udp_sock_create(struct net *net,
 typedef int (*udp_tunnel_encap_rcv_t)(struct sock *sk, struct sk_buff *skb);
 typedef int (*udp_tunnel_encap_err_lookup_t)(struct sock *sk,
 					     struct sk_buff *skb);
+typedef void (*udp_tunnel_encap_err_rcv_t)(struct sock *sk,
+					   struct sk_buff *skb,
+					   unsigned int udp_offset);
 typedef void (*udp_tunnel_encap_destroy_t)(struct sock *sk);
 typedef struct sk_buff *(*udp_tunnel_gro_receive_t)(struct sock *sk,
 						    struct list_head *head,
@@ -80,6 +83,7 @@ struct udp_tunnel_sock_cfg {
 	__u8  encap_type;
 	udp_tunnel_encap_rcv_t encap_rcv;
 	udp_tunnel_encap_err_lookup_t encap_err_lookup;
+	udp_tunnel_encap_err_rcv_t encap_err_rcv;
 	udp_tunnel_encap_destroy_t encap_destroy;
 	udp_tunnel_gro_receive_t gro_receive;
 	udp_tunnel_gro_complete_t gro_complete;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index efef7ba44e1d6..75d1977ecc07e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -781,6 +781,8 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	 */
 	if (tunnel) {
 		/* ...not for tunnels though: we don't have a sending socket */
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, iph->ihl << 2);
 		goto out;
 	}
 	if (!inet->recverr) {
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index b97e3635acf50..46101fd67a477 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -75,6 +75,7 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 
 	udp_sk(sk)->encap_type = cfg->encap_type;
 	udp_sk(sk)->encap_rcv = cfg->encap_rcv;
+	udp_sk(sk)->encap_err_rcv = cfg->encap_err_rcv;
 	udp_sk(sk)->encap_err_lookup = cfg->encap_err_lookup;
 	udp_sk(sk)->encap_destroy = cfg->encap_destroy;
 	udp_sk(sk)->gro_receive = cfg->gro_receive;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4a9afdbd5f292..07726a51a3f09 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -614,8 +614,11 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	/* Tunnels don't have an application socket: don't pass errors back */
-	if (tunnel)
+	if (tunnel) {
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, offset);
 		goto out;
+	}
 
 	if (!np->recverr) {
 		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f2d593e27b64f..f2e3fb77a02d3 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -990,6 +990,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 void rxrpc_error_report(struct sock *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 6a1611b0e3037..ef43fe8bdd2ff 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -137,6 +137,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 
 	tuncfg.encap_type = UDP_ENCAP_RXRPC;
 	tuncfg.encap_rcv = rxrpc_input_packet;
+	tuncfg.encap_err_rcv = rxrpc_encap_err_rcv;
 	tuncfg.sk_user_data = local;
 	setup_udp_tunnel_sock(net, local->socket, &tuncfg);
 
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index be032850ae8ca..32561e9567fe3 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -16,22 +16,105 @@
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <net/ip.h>
+#include <net/icmp.h>
 #include "ar-internal.h"
 
+static void rxrpc_adjust_mtu(struct rxrpc_peer *, unsigned int);
 static void rxrpc_store_error(struct rxrpc_peer *, struct sock_exterr_skb *);
 static void rxrpc_distribute_error(struct rxrpc_peer *, int,
 				   enum rxrpc_call_completion);
 
 /*
- * Find the peer associated with an ICMP packet.
+ * Find the peer associated with an ICMPv4 packet.
  */
 static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
-						     const struct sk_buff *skb,
+						     struct sk_buff *skb,
+						     unsigned int udp_offset,
+						     unsigned int *info,
 						     struct sockaddr_rxrpc *srx)
 {
-	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct iphdr *ip, *ip0 = ip_hdr(skb);
+	struct icmphdr *icmp = icmp_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
 
-	_enter("");
+	_enter("%u,%u,%u", ip0->protocol, icmp->type, icmp->code);
+
+	switch (icmp->type) {
+	case ICMP_DEST_UNREACH:
+		*info = ntohs(icmp->un.frag.mtu);
+		fallthrough;
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		ip = (struct iphdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
+	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
+	 * versa?
+	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case AF_INET6:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+#endif
+
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+/*
+ * Find the peer associated with an ICMPv6 packet.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
+						      struct sk_buff *skb,
+						      unsigned int udp_offset,
+						      unsigned int *info,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct icmp6hdr *icmp = icmp6_hdr(skb);
+	struct ipv6hdr *ip, *ip0 = ipv6_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
+
+	_enter("%u,%u,%u", ip0->nexthdr, icmp->icmp6_type, icmp->icmp6_code);
+
+	switch (icmp->icmp6_type) {
+	case ICMPV6_DEST_UNREACH:
+		*info = ntohl(icmp->icmp6_mtu);
+		fallthrough;
+	case ICMPV6_PKT_TOOBIG:
+	case ICMPV6_TIME_EXCEED:
+	case ICMPV6_PARAMPROB:
+		ip = (struct ipv6hdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
 
 	memset(srx, 0, sizeof(*srx));
 	srx->transport_type = local->srx.transport_type;
@@ -41,6 +124,165 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
 	 * versa?
 	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		_net("Rx ICMP6 on v4 sock");
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr,
+		       &ip->daddr.s6_addr32[3], sizeof(struct in_addr));
+		break;
+	case AF_INET6:
+		_net("Rx ICMP6");
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin6.sin6_addr, &ip->daddr,
+		       sizeof(struct in6_addr));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+#endif /* CONFIG_AF_RXRPC_IPV6 */
+
+/*
+ * Handle an error received on the local endpoint as a tunnel.
+ */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
+			 unsigned int udp_offset)
+{
+	struct sock_extended_err ee;
+	struct sockaddr_rxrpc srx;
+	struct rxrpc_local *local;
+	struct rxrpc_peer *peer;
+	unsigned int info = 0;
+	int err;
+	u8 version = ip_hdr(skb)->version;
+	u8 type = icmp_hdr(skb)->type;
+	u8 code = icmp_hdr(skb)->code;
+
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	rxrpc_new_skb(skb, rxrpc_skb_received);
+
+	switch (ip_hdr(skb)->version) {
+	case IPVERSION:
+		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, udp_offset,
+						  &info, &srx);
+		break;
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, udp_offset,
+						   &info, &srx);
+		break;
+#endif
+	default:
+		rcu_read_unlock();
+		return;
+	}
+
+	if (peer && !rxrpc_get_peer_maybe(peer))
+		peer = NULL;
+	if (!peer) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memset(&ee, 0, sizeof(ee));
+
+	switch (version) {
+	case IPVERSION:
+		switch (type) {
+		case ICMP_DEST_UNREACH:
+			switch (code) {
+			case ICMP_FRAG_NEEDED:
+				rxrpc_adjust_mtu(peer, info);
+				rcu_read_unlock();
+				rxrpc_put_peer(peer);
+				return;
+			default:
+				break;
+			}
+
+			err = EHOSTUNREACH;
+			if (code <= NR_ICMP_UNREACH) {
+				/* Might want to do something different with
+				 * non-fatal errors
+				 */
+				//harderr = icmp_err_convert[code].fatal;
+				err = icmp_err_convert[code].errno;
+			}
+			break;
+
+		case ICMP_TIME_EXCEEDED:
+			err = EHOSTUNREACH;
+			break;
+		default:
+			err = EPROTO;
+			break;
+		}
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		switch (type) {
+		case ICMPV6_PKT_TOOBIG:
+			rxrpc_adjust_mtu(peer, info);
+			rcu_read_unlock();
+			rxrpc_put_peer(peer);
+			return;
+		}
+
+		icmpv6_err_convert(type, code, &err);
+
+		if (err == EACCES)
+			err = EHOSTUNREACH;
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP6;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+#endif
+	}
+
+	trace_rxrpc_rx_icmp(peer, &ee, &srx);
+
+	rxrpc_distribute_error(peer, err, RXRPC_CALL_NETWORK_ERROR);
+	rcu_read_unlock();
+	rxrpc_put_peer(peer);
+}
+
+/*
+ * Find the peer associated with a local error.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
+						      const struct sk_buff *skb,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+
+	_enter("");
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
 	switch (srx->transport.family) {
 	case AF_INET:
 		srx->transport_len = sizeof(srx->transport.sin);
@@ -104,10 +346,8 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 /*
  * Handle an MTU/fragmentation problem.
  */
-static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, struct sock_exterr_skb *serr)
+static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 {
-	u32 mtu = serr->ee.ee_info;
-
 	_net("Rx ICMP Fragmentation Needed (%d)", mtu);
 
 	/* wind down the local interface MTU */
@@ -148,7 +388,7 @@ void rxrpc_error_report(struct sock *sk)
 	struct sock_exterr_skb *serr;
 	struct sockaddr_rxrpc srx;
 	struct rxrpc_local *local;
-	struct rxrpc_peer *peer;
+	struct rxrpc_peer *peer = NULL;
 	struct sk_buff *skb;
 
 	rcu_read_lock();
@@ -172,41 +412,20 @@ void rxrpc_error_report(struct sock *sk)
 	}
 	rxrpc_new_skb(skb, rxrpc_skb_received);
 	serr = SKB_EXT_ERR(skb);
-	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
-		_leave("UDP empty message");
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		return;
-	}
 
-	peer = rxrpc_lookup_peer_icmp_rcu(local, skb, &srx);
-	if (peer && !rxrpc_get_peer_maybe(peer))
-		peer = NULL;
-	if (!peer) {
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		_leave(" [no peer]");
-		return;
-	}
-
-	trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
-
-	if ((serr->ee.ee_origin == SO_EE_ORIGIN_ICMP &&
-	     serr->ee.ee_type == ICMP_DEST_UNREACH &&
-	     serr->ee.ee_code == ICMP_FRAG_NEEDED)) {
-		rxrpc_adjust_mtu(peer, serr);
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		rxrpc_put_peer(peer);
-		_leave(" [MTU update]");
-		return;
+	if (serr->ee.ee_origin == SO_EE_ORIGIN_LOCAL) {
+		peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
+		if (peer && !rxrpc_get_peer_maybe(peer))
+			peer = NULL;
+		if (peer) {
+			trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
+			rxrpc_store_error(peer, serr);
+		}
 	}
 
-	rxrpc_store_error(peer, serr);
 	rcu_read_unlock();
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	rxrpc_put_peer(peer);
-
 	_leave("");
 }
 
-- 
2.35.1



