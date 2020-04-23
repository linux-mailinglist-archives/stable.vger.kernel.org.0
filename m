Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C215F1B67D5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgDWXKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50464 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728017AbgDWXGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvg-0004tp-9K; Fri, 24 Apr 2020 00:06:48 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvb-00E71I-Ta; Fri, 24 Apr 2020 00:06:43 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Xiumei Mu" <xmu@redhat.com>,
        "Sabrina Dubroca" <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:07:23 +0100
Message-ID: <lsq.1587683028.441134062@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 216/245] net: ipv6_stub: use ip6_dst_lookup_flow
 instead of ip6_dst_lookup
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Only vxlan uses this operation
 - Neither ip6_dst_lookup() nor ip6_dst_lookup_flow() takes a struct net
   pointer argument here
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1929,7 +1929,8 @@ static void vxlan_xmit_one(struct sk_buf
 		fl6.saddr = vxlan->saddr.sin6.sin6_addr;
 		fl6.flowi6_proto = IPPROTO_UDP;
 
-		if (ipv6_stub->ipv6_dst_lookup(sk, &ndst, &fl6)) {
+		ndst = ipv6_stub->ipv6_dst_lookup_flow(sk, &fl6, NULL);
+		if (unlikely(IS_ERR(ndst))) {
 			netdev_dbg(dev, "no route to %pI6\n",
 				   &dst->sin6.sin6_addr);
 			dev->stats.tx_carrier_errors++;
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -156,8 +156,9 @@ struct ipv6_stub {
 				 const struct in6_addr *addr);
 	int (*ipv6_sock_mc_drop)(struct sock *sk, int ifindex,
 				 const struct in6_addr *addr);
-	int (*ipv6_dst_lookup)(struct sock *sk, struct dst_entry **dst,
-				struct flowi6 *fl6);
+	struct dst_entry *(*ipv6_dst_lookup_flow)(struct sock *sk,
+						  struct flowi6 *fl6,
+						  const struct in6_addr *final_dst);
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, struct neighbour *neigh,
 			      const struct in6_addr *daddr,
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -820,7 +820,7 @@ static struct pernet_operations inet6_ne
 static const struct ipv6_stub ipv6_stub_impl = {
 	.ipv6_sock_mc_join = ipv6_sock_mc_join,
 	.ipv6_sock_mc_drop = ipv6_sock_mc_drop,
-	.ipv6_dst_lookup = ip6_dst_lookup,
+	.ipv6_dst_lookup_flow = ip6_dst_lookup_flow,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
 	.nd_tbl	= &nd_tbl,

