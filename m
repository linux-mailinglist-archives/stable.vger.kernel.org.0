Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489FB1D810C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgERRoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729726AbgERRoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3026C20715;
        Mon, 18 May 2020 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823860;
        bh=z4VU8kZfgaAY/sQD3A7JBrR2gw+RMEPrXDn2WBLaPU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3ADsBwpcdr45vhyfFs5x0+CkSRnyd1mrybk06B9UIP0XlQmsf1iNdByhtah9+mfY
         5/LzXzacjpDaQl2pWEssopLXquyV5Etli1e7426fo+L35BGxp1devBA0Xm7G4/qp4g
         X2K8WNc4ah0rA33c3L/Tw7sTu+L4NqIx2TB2qsbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/90] net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
Date:   Mon, 18 May 2020 19:36:06 +0200
Message-Id: <20200518173456.947009565@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
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
[bwh: Backported to 4.9:
 - Drop changes in lwt_bpf.c and mlx5
 - Initialise "dst" in drivers/infiniband/core/addr.c:addr_resolve()
   to avoid introducing a spurious "may be used uninitialised" warning
 - Adjust filename, context, indentation]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c      |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_net.c |  8 +++++---
 drivers/net/geneve.c                |  4 +++-
 drivers/net/vxlan.c                 | 10 ++++------
 include/net/addrconf.h              |  6 ++++--
 net/ipv6/addrconf_core.c            | 11 ++++++-----
 net/ipv6/af_inet6.c                 |  2 +-
 net/mpls/af_mpls.c                  |  7 +++----
 net/tipc/udp_media.c                |  9 ++++++---
 9 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f7d23c1081dc4..68eed45b86003 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -453,16 +453,15 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
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
@@ -552,6 +551,7 @@ static int addr_resolve(struct sockaddr *src_in,
 		const struct sockaddr_in6 *dst_in6 =
 			(const struct sockaddr_in6 *)dst_in;
 
+		dst = NULL;
 		ret = addr6_resolve((struct sockaddr_in6 *)src_in,
 				    dst_in6, addr,
 				    &dst);
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index f4f3942ebbd13..d19e003e8381e 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -182,10 +182,12 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,
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
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 92ad43e53c722..35d8c636de123 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -835,7 +835,9 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 			return dst;
 	}
 
-	if (ipv6_stub->ipv6_dst_lookup(geneve->net, gs6->sock->sk, &dst, fl6)) {
+	dst = ipv6_stub->ipv6_dst_lookup_flow(geneve->net, gs6->sock->sk, fl6,
+					      NULL);
+	if (IS_ERR(dst)) {
 		netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index bc4542d9a08d3..58ddb6c904185 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1881,7 +1881,6 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct dst_entry *ndst;
 	struct flowi6 fl6;
-	int err;
 
 	if (!sock6)
 		return ERR_PTR(-EIO);
@@ -1902,11 +1901,10 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	err = ipv6_stub->ipv6_dst_lookup(vxlan->net,
-					 sock6->sock->sk,
-					 &ndst, &fl6);
-	if (err < 0)
-		return ERR_PTR(err);
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, sock6->sock->sk,
+					       &fl6, NULL);
+	if (unlikely(IS_ERR(ndst)))
+		return ERR_PTR(-ENETUNREACH);
 
 	*saddr = fl6.saddr;
 	if (use_cache)
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index b8ee8a113e324..019b06c035a84 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -206,8 +206,10 @@ struct ipv6_stub {
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
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index bfa941fc11650..129324b36fb60 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -107,15 +107,16 @@ int inet6addr_notifier_call_chain(unsigned long val, void *v)
 }
 EXPORT_SYMBOL(inet6addr_notifier_call_chain);
 
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
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2e91637c9d491..c6746aaf7fbfb 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -860,7 +860,7 @@ static struct pernet_operations inet6_net_ops = {
 static const struct ipv6_stub ipv6_stub_impl = {
 	.ipv6_sock_mc_join = ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop = ipv6_sock_mc_drop,
-	.ipv6_dst_lookup = ip6_dst_lookup,
+	.ipv6_dst_lookup_flow = ip6_dst_lookup_flow,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
 	.nd_tbl	= &nd_tbl,
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index ffab94d61e1da..eab9c1d70856b 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -497,16 +497,15 @@ static struct net_device *inet6_fib_lookup_dev(struct net *net,
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
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 05033ab05b8f3..c6ff3de1de37b 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -187,10 +187,13 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
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
-- 
2.20.1



