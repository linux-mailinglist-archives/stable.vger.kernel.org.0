Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5AE1D8054
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgERRi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgERRi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 819852088E;
        Mon, 18 May 2020 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823536;
        bh=CIiBJb42S876a2czSAIfERN6Bj9wuc+r+jF8XajKrFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4CQW+GbpIlGwjvRTw4Utz3j93Ezi5WMcWlOsnbl7CxyBLj/g80u9JBJw9hGPN/09
         AR5FegF1hglQXIsheSydbDNhUnD6H3vI4VjenuPf1TOnxvredjmUi8OqmpzhDPNYtm
         /tA1NyqHrCuqO63G/3+wtFEd0hQqlqvtJ4jKv8oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 22/86] net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
Date:   Mon, 18 May 2020 19:35:53 +0200
Message-Id: <20200518173454.956381951@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
[bwh: Backported to 4.4:
 - Drop changes in lwt_bpf.c, mlx5, and rxe
 - Adjust filename, context, indentation]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c |    6 +++---
 drivers/net/geneve.c           |    4 +++-
 drivers/net/vxlan.c            |   10 ++++------
 include/net/addrconf.h         |    6 ++++--
 net/ipv6/addrconf_core.c       |   11 ++++++-----
 net/ipv6/af_inet6.c            |    2 +-
 net/mpls/af_mpls.c             |    7 +++----
 net/tipc/udp_media.c           |    9 ++++++---
 8 files changed, 30 insertions(+), 25 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -293,9 +293,9 @@ static int addr6_resolve(struct sockaddr
 	fl6.saddr = src_in->sin6_addr;
 	fl6.flowi6_oif = addr->bound_dev_if;
 
-	ret = ipv6_stub->ipv6_dst_lookup(addr->net, NULL, &dst, &fl6);
-	if (ret < 0)
-		goto put;
+	dst = ipv6_stub->ipv6_dst_lookup_flow(addr->net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
 
 	if (ipv6_addr_any(&fl6.saddr)) {
 		ret = ipv6_dev_get_saddr(addr->net, ip6_dst_idev(dst)->dev,
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -781,7 +781,9 @@ static struct dst_entry *geneve_get_v6_d
 		fl6->daddr = geneve->remote.sin6.sin6_addr;
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
@@ -1864,7 +1864,6 @@ static struct dst_entry *vxlan6_get_rout
 {
 	struct dst_entry *ndst;
 	struct flowi6 fl6;
-	int err;
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_oif = oif;
@@ -1873,11 +1872,10 @@ static struct dst_entry *vxlan6_get_rout
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 
-	err = ipv6_stub->ipv6_dst_lookup(vxlan->net,
-					 vxlan->vn6_sock->sock->sk,
-					 &ndst, &fl6);
-	if (err < 0)
-		return ERR_PTR(err);
+	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, vxlan->vn6_sock->sock->sk,
+					       &fl6, NULL);
+	if (unlikely(IS_ERR(ndst)))
+		return ERR_PTR(-ENETUNREACH);
 
 	*saddr = fl6.saddr;
 	return ndst;
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -192,8 +192,10 @@ struct ipv6_stub {
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
@@ -107,15 +107,16 @@ int inet6addr_notifier_call_chain(unsign
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
 
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -841,7 +841,7 @@ static struct pernet_operations inet6_ne
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
@@ -470,16 +470,15 @@ static struct net_device *inet6_fib_look
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
@@ -200,10 +200,13 @@ static int tipc_udp_send_msg(struct net
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
 		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb,
 					   ndst->dev, &src->ipv6,


