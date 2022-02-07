Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22AF4ABAEC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiBGLZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352845AbiBGLMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:12:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AB9C043181;
        Mon,  7 Feb 2022 03:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E4261314;
        Mon,  7 Feb 2022 11:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBD2C004E1;
        Mon,  7 Feb 2022 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232320;
        bh=GVclLUpV5I6fB7xF9BnCi/GSDE4G3lqHd2p6FC+z9kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alyJOE3b5xqHbSZpa1jkGOLntMxsLlgZl2If0NiAKD8UoQv5EMX0vtXT/SJ7YsyFn
         dyxFmrtWWu5Su/ucnxg97VWOZC1ZojnMRfeC0Bx4hmar1rYXOH24PzHiT7CpLiSws6
         rYPpowzxDJve1HPXJ/3h32pxC40nUpkipoOUrFbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 39/69] netfilter: nat: remove l4 protocol port rovers
Date:   Mon,  7 Feb 2022 12:06:01 +0100
Message-Id: <20220207103756.914150863@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_nat_l4proto.h |    2 +-
 net/netfilter/nf_nat_proto_common.c    |    7 ++-----
 net/netfilter/nf_nat_proto_dccp.c      |    5 +----
 net/netfilter/nf_nat_proto_sctp.c      |    5 +----
 net/netfilter/nf_nat_proto_tcp.c       |    5 +----
 net/netfilter/nf_nat_proto_udp.c       |   10 ++--------
 6 files changed, 8 insertions(+), 26 deletions(-)

--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -74,7 +74,7 @@ void nf_nat_l4proto_unique_tuple(const s
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct, u16 *rover);
+				 const struct nf_conn *ct);
 
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range *range);
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -38,8 +38,7 @@ void nf_nat_l4proto_unique_tuple(const s
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct,
-				 u16 *rover)
+				 const struct nf_conn *ct)
 {
 	unsigned int range_size, min, max, i;
 	__be16 *portptr;
@@ -84,15 +83,13 @@ void nf_nat_l4proto_unique_tuple(const s
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
@@ -27,8 +25,7 @@ dccp_unique_tuple(const struct nf_nat_l3
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &dccp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -12,8 +12,6 @@
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t nf_sctp_port_rover;
-
 static void
 sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -21,8 +19,7 @@ sctp_unique_tuple(const struct nf_nat_l3
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &nf_sctp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
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
@@ -27,8 +25,7 @@ tcp_unique_tuple(const struct nf_nat_l3p
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &tcp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
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
@@ -26,8 +24,7 @@ udp_unique_tuple(const struct nf_nat_l3p
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static void
@@ -78,8 +75,6 @@ static bool udp_manip_pkt(struct sk_buff
 }
 
 #ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-static u16 udplite_port_rover;
-
 static bool udplite_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
@@ -103,8 +98,7 @@ udplite_unique_tuple(const struct nf_nat
 		     enum nf_nat_manip_type maniptype,
 		     const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udplite_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {


