Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7601D8635
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgERRsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgERRsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD0020674;
        Mon, 18 May 2020 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824124;
        bh=wr5dUKOjBE5WDyW1f619MDASjdnkV8pA2c7QAk6Vhus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVlGQ+gzDlzGFXaHkkfqQKf3wdPMTnhcMCICjj9dimWyUu6VMRQOZUrQNAl0a9fup
         ph1MduRx61JR5Gb92w6NoFeTss6az1uHrjLLFr15CMMumoWFINGOBBeAvoBCZ8ktL4
         4X1+VJqmWvbqA9ZUwlE0OqvoPAEiivFcGR0Sgaas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 038/114] net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
Date:   Mon, 18 May 2020 19:36:10 +0200
Message-Id: <20200518173510.466974574@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 6c8991f41546c3c472503dff1ea9daaddf9331c2 upstream.

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
[bwh: Backported to 4.14:
 - Drop change in lwt_bpf.c
 - Delete now-unused "ret" in mlx5e_route_lookup_ipv6()
 - Initialise "out_dev" in mlx5e_create_encap_header_ipv6() to avoid
   introducing a spurious "may be used uninitialised" warning
 - Adjust filenames, context, indentation]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c                  |    7 +++----
 drivers/infiniband/sw/rxe/rxe_net.c             |    8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   11 +++++------
 drivers/net/geneve.c                            |    4 +++-
 drivers/net/vxlan.c                             |    8 +++-----
 include/net/addrconf.h                          |    6 ++++--
 net/ipv6/addrconf_core.c                        |   11 ++++++-----
 net/ipv6/af_inet6.c                             |    2 +-
 net/mpls/af_mpls.c                              |    7 +++----
 net/tipc/udp_media.c                            |    9 ++++++---
 10 files changed, 39 insertions(+), 34 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -450,16 +450,15 @@ static int addr6_resolve(struct sockaddr
 	struct flowi6 fl6;
 	struct dst_entry *dst;
 	struct rt6_info *rt;
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
 
 	rt = (struct rt6_info *)dst;
 	if (ipv6_addr_any(&src_in->sin6_addr)) {
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -154,10 +154,12 @@ static struct dst_entry *rxe_find_route6
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
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1550,12 +1550,11 @@ static int mlx5e_route_lookup_ipv6(struc
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	int ret;
 
-	ret = ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
-					 fl6);
-	if (ret < 0)
-		return ret;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, fl6,
+					      NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	*out_ttl = ip6_dst_hoplimit(dst);
 
@@ -1754,7 +1753,7 @@ static int mlx5e_create_encap_header_ipv
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	int ipv6_encap_size = ETH_HLEN + sizeof(struct ipv6hdr) + VXLAN_HLEN;
 	struct ip_tunnel_key *tun_key = &e->tun_info.key;
-	struct net_device *out_dev;
+	struct net_device *out_dev = NULL;
 	struct neighbour *n = NULL;
 	struct flowi6 fl6 = {};
 	char *encap_header;
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -796,7 +796,9 @@ static struct dst_entry *geneve_get_v6_d
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
@@ -1962,7 +1962,6 @@ static struct dst_entry *vxlan6_get_rout
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct dst_entry *ndst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!sock6)
 		return ERR_PTR(-EIO);
@@ -1985,10 +1984,9 @@ static struct dst_entry *vxlan6_get_rout
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
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -223,8 +223,10 @@ struct ipv6_stub {
 				 const struct in6_addr *addr);
 	int (*ipv6_sock_mc_drop)(struct sock *sk, int ifindex,
 				 const struct in6_addr *addr);
-	int (*ipv6_dst_lookup)(struct net *net, struct sock *sk,
-			       struct dst_entry **dst, struct flowi6 *fl6);
+	struct dst_entry *(*ipv6_dst_lookup_flow)(struct net *net,
+						  const struct sock *sk,
+						  struct flowi6 *fl6,
+						  const struct in6_addr *final_dst);
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -126,15 +126,16 @@ int inet6addr_validator_notifier_call_ch
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
 
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
-	.ipv6_dst_lookup = eafnosupport_ipv6_dst_lookup,
+	.ipv6_dst_lookup_flow = eafnosupport_ipv6_dst_lookup_flow,
 };
 EXPORT_SYMBOL_GPL(ipv6_stub);
 
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -874,7 +874,7 @@ static struct pernet_operations inet6_ne
 static const struct ipv6_stub ipv6_stub_impl = {
 	.ipv6_sock_mc_join = ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop = ipv6_sock_mc_drop,
-	.ipv6_dst_lookup = ip6_dst_lookup,
+	.ipv6_dst_lookup_flow = ip6_dst_lookup_flow,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
 	.nd_tbl	= &nd_tbl,
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -587,16 +587,15 @@ static struct net_device *inet6_fib_look
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
@@ -187,10 +187,13 @@ static int tipc_udp_xmit(struct net *net
 			.saddr = src->ipv6,
 			.flowi6_proto = IPPROTO_UDP
 		};
-		err = ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk, &ndst,
-						 &fl6);
-		if (err)
+		ndst = ipv6_stub->ipv6_dst_lookup_flow(net,
+						       ub->ubsock->sk,
+						       &fl6, NULL);
+		if (IS_ERR(ndst)) {
+			err = PTR_ERR(ndst);
 			goto tx_error;
+		}
 		ttl = ip6_dst_hoplimit(ndst);
 		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
 					   &src->ipv6, &dst->ipv6, 0, ttl, 0,


