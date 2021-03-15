Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E1433B645
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCON5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhCON5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00ECF64EF3;
        Mon, 15 Mar 2021 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816622;
        bh=Ux5Nui7i5uAA02jA+/Fd1375riJrUm2Q5kXkTqXaIOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xi8dmbYn0KYWkwxFIwWRd8ivnO+XgtydhhxvHNoXMwExVvQPwhflwNmcg0xnNPgoi
         qTmK/TQGbV43HwQ1Y+Q/gWHAm1GiiKY0FBn3PiC3SNWn6ruAWQEHW9c+3Fi9KpBs3q
         k2uCHLHGwLsvNcsBopLh42/zc63Xv0eN3AlZkTJM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 018/290] netfilter: nf_nat: undo erroneous tcp edemux lookup
Date:   Mon, 15 Mar 2021 14:51:51 +0100
Message-Id: <20210315135542.552567324@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Florian Westphal <fw@strlen.de>

commit 03a3ca37e4c6478e3a84f04c8429dd5889e107fd upstream.

Under extremely rare conditions TCP early demux will retrieve the wrong
socket.

1. local machine establishes a connection to a remote server, S, on port
   p.

   This gives:
   laddr:lport -> S:p
   ... both in tcp and conntrack.

2. local machine establishes a connection to host H, on port p2.
   2a. TCP stack choses same laddr:lport, so we have
   laddr:lport -> H:p2 from TCP point of view.
   2b). There is a destination NAT rewrite in place, translating
        H:p2 to S:p.  This results in following conntrack entries:

   I)  laddr:lport -> S:p  (origin)  S:p -> laddr:lport (reply)
   II) laddr:lport -> H:p2 (origin)  S:p -> laddr:lport2 (reply)

   NAT engine has rewritten laddr:lport to laddr:lport2 to map
   the reply packet to the correct origin.

   When server sends SYN/ACK to laddr:lport2, the PREROUTING hook
   will undo-the SNAT transformation, rewriting IP header to
   S:p -> laddr:lport

   This causes TCP early demux to associate the skb with the TCP socket
   of the first connection.

   The INPUT hook will then reverse the DNAT transformation, rewriting
   the IP header to H:p2 -> laddr:lport.

Because packet ends up with the wrong socket, the new connection
never completes: originator stays in SYN_SENT and conntrack entry
remains in SYN_RECV until timeout, and responder retransmits SYN/ACK
until it gives up.

To resolve this, orphan the skb after the input rewrite:
Because the source IP address changed, the socket must be incorrect.
We can't move the DNAT undo to prerouting due to backwards
compatibility, doing so will make iptables/nftables rules to no longer
match the way they did.

After orphan, the packet will be handed to the next protocol layer
(tcp, udp, ...) and that will repeat the socket lookup just like as if
early demux was disabled.

Fixes: 41063e9dd1195 ("ipv4: Early TCP socket demux.")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1427
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_nat_proto.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -646,8 +646,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buf
 }
 
 static unsigned int
-nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
@@ -660,6 +660,23 @@ nf_nat_ipv4_in(void *priv, struct sk_buf
 }
 
 static unsigned int
+nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	__be32 saddr = ip_hdr(skb)->saddr;
+	struct sock *sk = skb->sk;
+	unsigned int ret;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+
+	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
+	    !inet_sk_transparent(sk))
+		skb_orphan(skb); /* TCP edemux obtained wrong socket */
+
+	return ret;
+}
+
+static unsigned int
 nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 		const struct nf_hook_state *state)
 {
@@ -736,7 +753,7 @@ nf_nat_ipv4_local_fn(void *priv, struct
 static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
-		.hook		= nf_nat_ipv4_in,
+		.hook		= nf_nat_ipv4_pre_routing,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
@@ -757,7 +774,7 @@ static const struct nf_hook_ops nf_nat_i
 	},
 	/* After packet filtering, change source */
 	{
-		.hook		= nf_nat_ipv4_fn,
+		.hook		= nf_nat_ipv4_local_in,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,


