Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3623C4A83F4
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 13:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiBCMmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 07:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiBCMmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 07:42:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D59C061714;
        Thu,  3 Feb 2022 04:42:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFbR9-0000Xd-Pv; Thu, 03 Feb 2022 13:42:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <stable@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14.y 1/2] netfilter: nat: remove l4 protocol port rovers
Date:   Thu,  3 Feb 2022 13:41:54 +0100
Message-Id: <20220203124155.16693-2-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203124155.16693-1-fw@strlen.de>
References: <20220203124155.16693-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6ed5943f8735e2b778d92ea4d9805c0a1d89bc2b upstream.

This is a leftover from days where single-cpu systems were common:
Store last port used to resolve a clash to use it as a starting point when
the next conflict needs to be resolved.

When we have parallel attempt to connect to same address:port pair,
its likely that both cores end up computing the same "available" port,
as both use same starting port, and newly used ports won't become
visible to other cores until the conntrack gets confirmed later.

One of the cores then has to drop the packet at insertion time because
the chosen new tuple turns out to be in use after all.

Lets simplify this: remove port rover and use a pseudo-random starting
point.

Note that this doesn't make netfilter default to 'fully random' mode;
the 'rover' was only used if NAT could not reuse source port as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h |  2 +-
 net/netfilter/nf_nat_proto_common.c    |  7 ++-----
 net/netfilter/nf_nat_proto_dccp.c      |  5 +----
 net/netfilter/nf_nat_proto_sctp.c      |  5 +----
 net/netfilter/nf_nat_proto_tcp.c       |  5 +----
 net/netfilter/nf_nat_proto_udp.c       | 10 ++--------
 6 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 67835ff8a2d9..103ecea6afdb 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -74,7 +74,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct, u16 *rover);
+				 const struct nf_conn *ct);
 
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range *range);
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 7d7466dbf663..ac57e47aded2 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -38,8 +38,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct,
-				 u16 *rover)
+				 const struct nf_conn *ct)
 {
 	unsigned int range_size, min, max, i;
 	__be16 *portptr;
@@ -84,15 +83,13 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 		off = prandom_u32();
 	} else {
-		off = *rover;
+		off = prandom_u32();
 	}
 
 	for (i = 0; ; ++off) {
 		*portptr = htons(min + off % range_size);
 		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
 			continue;
-		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
-			*rover = off;
 		return;
 	}
 }
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 269fcd5dc34c..04c671300a14 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t dccp_port_rover;
-
 static void
 dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &dccp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index c57ee3240b1d..7329c9b1dc1e 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -12,8 +12,6 @@
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t nf_sctp_port_rover;
-
 static void
 sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -21,8 +19,7 @@ sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &nf_sctp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index 4f8820fc5148..882e79c6df73 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static u16 tcp_port_rover;
-
 static void
 tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &tcp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 167ad0dd269c..f48bacd38d9d 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -17,8 +17,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u16 udp_port_rover;
-
 static void
 udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -26,8 +24,7 @@ udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static void
@@ -78,8 +75,6 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-static u16 udplite_port_rover;
-
 static bool udplite_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
@@ -103,8 +98,7 @@ udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		     enum nf_nat_manip_type maniptype,
 		     const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udplite_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-- 
2.34.1

