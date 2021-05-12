Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB837CAA1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241869AbhELQbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240913AbhELQZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD94161DA2;
        Wed, 12 May 2021 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834530;
        bh=21D9EouhYMPVN19Tfg3MwP9cAd41TDYdW1xJM1bUCLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuqAB18yHBnO4obiOA5+y4gJ2z6hLcPqkIuOjlVqI+ihUpsk8cjgBZp73iuBC74gb
         dRS1JF/nrZ3KWX1O6n9InNPCQfogdrItDzsX6Pdjt5rdFvmZ01Kb3S9ZrwDvPDzciR
         LvYPxfBEYlaJZjYHw117fyS5Sk6WdObofr/hOYdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 581/601] net: bridge: mcast: fix broken length + header check for MRDv6 Adv.
Date:   Wed, 12 May 2021 16:50:58 +0200
Message-Id: <20210512144846.982620557@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit 99014088156cd78867d19514a0bc771c4b86b93b ]

The IPv6 Multicast Router Advertisements parsing has the following two
issues:

For one thing, ICMPv6 MRD Advertisements are smaller than ICMPv6 MLD
messages (ICMPv6 MRD Adv.: 8 bytes vs. ICMPv6 MLDv1/2: >= 24 bytes,
assuming MLDv2 Reports with at least one multicast address entry).
When ipv6_mc_check_mld_msg() tries to parse an Multicast Router
Advertisement its MLD length check will fail - and it will wrongly
return -EINVAL, even if we have a valid MRD Advertisement. With the
returned -EINVAL the bridge code will assume a broken packet and will
wrongly discard it, potentially leading to multicast packet loss towards
multicast routers.

The second issue is the MRD header parsing in
br_ip6_multicast_mrd_rcv(): It wrongly checks for an ICMPv6 header
immediately after the IPv6 header (IPv6 next header type). However
according to RFC4286, section 2 all MRD messages contain a Router Alert
option (just like MLD). So instead there is an IPv6 Hop-by-Hop option
for the Router Alert between the IPv6 and ICMPv6 header, again leading
to the bridge wrongly discarding Multicast Router Advertisements.

To fix these two issues, introduce a new return value -ENODATA to
ipv6_mc_check_mld() to indicate a valid ICMPv6 packet with a hop-by-hop
option which is not an MLD but potentially an MRD packet. This also
simplifies further parsing in the bridge code, as ipv6_mc_check_mld()
already fully checks the ICMPv6 header and hop-by-hop option.

These issues were found and fixed with the help of the mrdisc tool
(https://github.com/troglobit/mrdisc).

Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h    |  1 -
 net/bridge/br_multicast.c | 33 ++++++++-------------------------
 net/ipv6/mcast_snoop.c    | 12 +++++++-----
 3 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 18f783dcd55f..78ea3e332688 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -233,7 +233,6 @@ void ipv6_mc_unmap(struct inet6_dev *idev);
 void ipv6_mc_remap(struct inet6_dev *idev);
 void ipv6_mc_init_dev(struct inet6_dev *idev);
 void ipv6_mc_destroy_dev(struct inet6_dev *idev);
-int ipv6_mc_check_icmpv6(struct sk_buff *skb);
 int ipv6_mc_check_mld(struct sk_buff *skb);
 void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp);
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 257ac4e25f6d..5f89ae3ae4d8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3075,25 +3075,14 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int br_ip6_multicast_mrd_rcv(struct net_bridge *br,
-				    struct net_bridge_port *port,
-				    struct sk_buff *skb)
+static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
+				     struct net_bridge_port *port,
+				     struct sk_buff *skb)
 {
-	int ret;
-
-	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6)
-		return -ENOMSG;
-
-	ret = ipv6_mc_check_icmpv6(skb);
-	if (ret < 0)
-		return ret;
-
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
-		return -ENOMSG;
+		return;
 
 	br_multicast_mark_router(br, port);
-
-	return 0;
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
@@ -3107,18 +3096,12 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 
 	err = ipv6_mc_check_mld(skb);
 
-	if (err == -ENOMSG) {
+	if (err == -ENOMSG || err == -ENODATA) {
 		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-
-		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
-			err = br_ip6_multicast_mrd_rcv(br, port, skb);
-
-			if (err < 0 && err != -ENOMSG) {
-				br_multicast_err_count(br, port, skb->protocol);
-				return err;
-			}
-		}
+		if (err == -ENODATA &&
+		    ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr))
+			br_ip6_multicast_mrd_rcv(br, port, skb);
 
 		return 0;
 	} else if (err < 0) {
diff --git a/net/ipv6/mcast_snoop.c b/net/ipv6/mcast_snoop.c
index d3d6b6a66e5f..04d5fcdfa6e0 100644
--- a/net/ipv6/mcast_snoop.c
+++ b/net/ipv6/mcast_snoop.c
@@ -109,7 +109,7 @@ static int ipv6_mc_check_mld_msg(struct sk_buff *skb)
 	struct mld_msg *mld;
 
 	if (!ipv6_mc_may_pull(skb, len))
-		return -EINVAL;
+		return -ENODATA;
 
 	mld = (struct mld_msg *)skb_transport_header(skb);
 
@@ -122,7 +122,7 @@ static int ipv6_mc_check_mld_msg(struct sk_buff *skb)
 	case ICMPV6_MGM_QUERY:
 		return ipv6_mc_check_mld_query(skb);
 	default:
-		return -ENOMSG;
+		return -ENODATA;
 	}
 }
 
@@ -131,7 +131,7 @@ static inline __sum16 ipv6_mc_validate_checksum(struct sk_buff *skb)
 	return skb_checksum_validate(skb, IPPROTO_ICMPV6, ip6_compute_pseudo);
 }
 
-int ipv6_mc_check_icmpv6(struct sk_buff *skb)
+static int ipv6_mc_check_icmpv6(struct sk_buff *skb)
 {
 	unsigned int len = skb_transport_offset(skb) + sizeof(struct icmp6hdr);
 	unsigned int transport_len = ipv6_transport_len(skb);
@@ -150,7 +150,6 @@ int ipv6_mc_check_icmpv6(struct sk_buff *skb)
 
 	return 0;
 }
-EXPORT_SYMBOL(ipv6_mc_check_icmpv6);
 
 /**
  * ipv6_mc_check_mld - checks whether this is a sane MLD packet
@@ -161,7 +160,10 @@ EXPORT_SYMBOL(ipv6_mc_check_icmpv6);
  *
  * -EINVAL: A broken packet was detected, i.e. it violates some internet
  *  standard
- * -ENOMSG: IP header validation succeeded but it is not an MLD packet.
+ * -ENOMSG: IP header validation succeeded but it is not an ICMPv6 packet
+ *  with a hop-by-hop option.
+ * -ENODATA: IP+ICMPv6 header with hop-by-hop option validation succeeded
+ *  but it is not an MLD packet.
  * -ENOMEM: A memory allocation failure happened.
  *
  * Caller needs to set the skb network header and free any returned skb if it
-- 
2.30.2



