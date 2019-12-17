Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B9123715
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfLQUSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728457AbfLQUQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:16:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BF724676;
        Tue, 17 Dec 2019 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613808;
        bh=PJiEPMx8lGF7s4HdtS1jYrTzVzqBn9e36Kna/nilcdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxB4TKPD5/dMCPQ6pXsseKAzS/xBdaZxp8nz4+ggLylLRsGpyHwk59pSYmDT63SWI
         gSYJU1iLQ+fY05O8jp+OJdb0l3j3tbQUl0mHv2S9iVrOCTI7gQuVr1LVOb7j2QW546
         bC16a/E98IuTp1XpKi289MDhvl5oUEl8MqbheIDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 15/25] net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
Date:   Tue, 17 Dec 2019 21:16:14 +0100
Message-Id: <20191217200909.340275241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 6c8991f41546c3c472503dff1ea9daaddf9331c2 ]

ipv6_stub uses the ip6_dst_lookup function to allow other modules to
perform IPv6 lookups. However, this function skips the XFRM layer
entirely.

All users of ipv6_stub->ip6_dst_lookup use ip_route_output_flow (via the
ip_route_output_key and ip_route_output helpers) for their IPv4 lookups,
which calls xfrm_lookup_route(). This patch fixes this inconsistent
behavior by switching the stub to ip6_dst_lookup_flow, which also calls
xfrm_lookup_route().

This requires some changes in all the callers, as these two functions
take different arguments and have different return types.

Fixes: 5f81bd2e5d80 ("ipv6: export a stub for IPv6 symbols used by vxlan")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c                      |    7 +++----
 drivers/infiniband/sw/rxe/rxe_net.c                 |    8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |    8 ++++----
 drivers/net/geneve.c                                |    4 +++-
 drivers/net/vxlan.c                                 |    8 +++-----
 include/net/ipv6_stubs.h                            |    6 ++++--
 net/core/lwt_bpf.c                                  |    4 +---
 net/ipv6/addrconf_core.c                            |   11 ++++++-----
 net/ipv6/af_inet6.c                                 |    2 +-
 net/mpls/af_mpls.c                                  |    7 +++----
 net/tipc/udp_media.c                                |    9 ++++++---
 11 files changed, 39 insertions(+), 35 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -421,16 +421,15 @@ static int addr6_resolve(struct sockaddr
 				(const struct sockaddr_in6 *)dst_sock;
 	struct flowi6 fl6;
 	struct dst_entry *dst;
-	int ret;
 
 	memset(&fl6, 0, sizeof fl6);
 	fl6.daddr = dst_in->sin6_addr;
 	fl6.saddr = src_in->sin6_addr;
 	fl6.flowi6_oif = addr->bound_dev_if;
 
-	ret = ipv6_stub->ipv6_dst_lookup(addr->net, NULL, &dst, &fl6);
-	if (ret < 0)
-		return ret;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(addr->net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	if (ipv6_addr_any(&src_in->sin6_addr))
 		src_in->sin6_addr = fl6.saddr;
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -117,10 +117,12 @@ static struct dst_entry *rxe_find_route6
 	memcpy(&fl6.daddr, daddr, sizeof(*daddr));
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	if (unlikely(ipv6_stub->ipv6_dst_lookup(sock_net(recv_sockets.sk6->sk),
-						recv_sockets.sk6->sk, &ndst, &fl6))) {
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(recv_sockets.sk6->sk),
+					       recv_sockets.sk6->sk, &fl6,
+					       NULL);
+	if (unlikely(IS_ERR(ndst))) {
 		pr_err_ratelimited("no route to %pI6\n", daddr);
-		goto put;
+		return NULL;
 	}
 
 	if (unlikely(ndst->error)) {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -137,10 +137,10 @@ static int mlx5e_route_lookup_ipv6(struc
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	int ret;
 
-	ret = ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
-					 fl6);
-	if (ret < 0)
-		return ret;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, fl6,
+					      NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	if (!(*out_ttl))
 		*out_ttl = ip6_dst_hoplimit(dst);
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -853,7 +853,9 @@ static struct dst_entry *geneve_get_v6_d
 		if (dst)
 			return dst;
 	}
-	if (ipv6_stub->ipv6_dst_lookup(geneve->net, gs6->sock->sk, &dst, fl6)) {
+	dst = ipv6_stub->ipv6_dst_lookup_flow(geneve->net, gs6->sock->sk, fl6,
+					      NULL);
+	if (IS_ERR(dst)) {
 		netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2276,7 +2276,6 @@ static struct dst_entry *vxlan6_get_rout
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct dst_entry *ndst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!sock6)
 		return ERR_PTR(-EIO);
@@ -2299,10 +2298,9 @@ static struct dst_entry *vxlan6_get_rout
 	fl6.fl6_dport = dport;
 	fl6.fl6_sport = sport;
 
-	err = ipv6_stub->ipv6_dst_lookup(vxlan->net,
-					 sock6->sock->sk,
-					 &ndst, &fl6);
-	if (unlikely(err < 0)) {
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, sock6->sock->sk,
+					       &fl6, NULL);
+	if (unlikely(IS_ERR(ndst))) {
 		netdev_dbg(dev, "no route to %pI6\n", daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -24,8 +24,10 @@ struct ipv6_stub {
 				 const struct in6_addr *addr);
 	int (*ipv6_sock_mc_drop)(struct sock *sk, int ifindex,
 				 const struct in6_addr *addr);
-	int (*ipv6_dst_lookup)(struct net *net, struct sock *sk,
-			       struct dst_entry **dst, struct flowi6 *fl6);
+	struct dst_entry *(*ipv6_dst_lookup_flow)(struct net *net,
+						  const struct sock *sk,
+						  struct flowi6 *fl6,
+						  const struct in6_addr *final_dst);
 	int (*ipv6_route_input)(struct sk_buff *skb);
 
 	struct fib6_table *(*fib6_get_table)(struct net *net, u32 id);
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -230,9 +230,7 @@ static int bpf_lwt_xmit_reroute(struct s
 		fl6.daddr = iph6->daddr;
 		fl6.saddr = iph6->saddr;
 
-		err = ipv6_stub->ipv6_dst_lookup(net, skb->sk, &dst, &fl6);
-		if (unlikely(err))
-			goto err;
+		dst = ipv6_stub->ipv6_dst_lookup_flow(net, skb->sk, &fl6, NULL);
 		if (IS_ERR(dst)) {
 			err = PTR_ERR(dst);
 			goto err;
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -128,11 +128,12 @@ int inet6addr_validator_notifier_call_ch
 }
 EXPORT_SYMBOL(inet6addr_validator_notifier_call_chain);
 
-static int eafnosupport_ipv6_dst_lookup(struct net *net, struct sock *u1,
-					struct dst_entry **u2,
-					struct flowi6 *u3)
+static struct dst_entry *eafnosupport_ipv6_dst_lookup_flow(struct net *net,
+							   const struct sock *sk,
+							   struct flowi6 *fl6,
+							   const struct in6_addr *final_dst)
 {
-	return -EAFNOSUPPORT;
+	return ERR_PTR(-EAFNOSUPPORT);
 }
 
 static int eafnosupport_ipv6_route_input(struct sk_buff *skb)
@@ -189,7 +190,7 @@ static int eafnosupport_ip6_del_rt(struc
 }
 
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
-	.ipv6_dst_lookup   = eafnosupport_ipv6_dst_lookup,
+	.ipv6_dst_lookup_flow = eafnosupport_ipv6_dst_lookup_flow,
 	.ipv6_route_input  = eafnosupport_ipv6_route_input,
 	.fib6_get_table    = eafnosupport_fib6_get_table,
 	.fib6_table_lookup = eafnosupport_fib6_table_lookup,
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -946,7 +946,7 @@ static int ipv6_route_input(struct sk_bu
 static const struct ipv6_stub ipv6_stub_impl = {
 	.ipv6_sock_mc_join = ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop = ipv6_sock_mc_drop,
-	.ipv6_dst_lookup   = ip6_dst_lookup,
+	.ipv6_dst_lookup_flow = ip6_dst_lookup_flow,
 	.ipv6_route_input  = ipv6_route_input,
 	.fib6_get_table	   = fib6_get_table,
 	.fib6_table_lookup = fib6_table_lookup,
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -617,16 +617,15 @@ static struct net_device *inet6_fib_look
 	struct net_device *dev;
 	struct dst_entry *dst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!ipv6_stub)
 		return ERR_PTR(-EAFNOSUPPORT);
 
 	memset(&fl6, 0, sizeof(fl6));
 	memcpy(&fl6.daddr, addr, sizeof(struct in6_addr));
-	err = ipv6_stub->ipv6_dst_lookup(net, NULL, &dst, &fl6);
-	if (err)
-		return ERR_PTR(err);
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return ERR_CAST(dst);
 
 	dev = dst->dev;
 	dev_hold(dev);
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -195,10 +195,13 @@ static int tipc_udp_xmit(struct net *net
 				.saddr = src->ipv6,
 				.flowi6_proto = IPPROTO_UDP
 			};
-			err = ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk,
-							 &ndst, &fl6);
-			if (err)
+			ndst = ipv6_stub->ipv6_dst_lookup_flow(net,
+							       ub->ubsock->sk,
+							       &fl6, NULL);
+			if (IS_ERR(ndst)) {
+				err = PTR_ERR(ndst);
 				goto tx_error;
+			}
 			dst_cache_set_ip6(cache, ndst, &fl6.saddr);
 		}
 		ttl = ip6_dst_hoplimit(ndst);


