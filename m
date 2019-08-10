Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC48A88DF2
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfHJUu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54488 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053O-6F; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003lf-51; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Flavio Leitner" <fbl@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.252214026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 151/157] ipv4: hash net ptr into fragmentation bucket
 selection
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit b6a7719aedd7e5c0f2df7641aa47386111682df4 upstream.

As namespaces are sometimes used with overlapping ip address ranges,
we should also use the namespace as input to the hash to select the ip
fragmentation counter bucket.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ppp/pptp.c          |  2 +-
 include/net/ip.h                | 12 +++++++-----
 net/ipv4/igmp.c                 |  4 ++--
 net/ipv4/ip_output.c            |  7 ++++---
 net/ipv4/ip_tunnel_core.c       |  2 +-
 net/ipv4/ipmr.c                 |  7 ++++---
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/route.c                |  4 ++--
 net/ipv4/xfrm4_mode_tunnel.c    |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c |  5 +++--
 10 files changed, 26 insertions(+), 21 deletions(-)

--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -284,7 +284,7 @@ static int pptp_xmit(struct ppp_channel
 	nf_reset(skb);
 
 	skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(skb, NULL);
+	ip_select_ident(sock_net(sk), skb, NULL);
 	ip_send_check(iph);
 
 	ip_local_out(skb);
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -319,9 +319,10 @@ static inline unsigned int ip_skb_dst_mt
 }
 
 u32 ip_idents_reserve(u32 hash, int segs);
-void __ip_select_ident(struct iphdr *iph, int segs);
+void __ip_select_ident(struct net *net, struct iphdr *iph, int segs);
 
-static inline void ip_select_ident_segs(struct sk_buff *skb, struct sock *sk, int segs)
+static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
+					struct sock *sk, int segs)
 {
 	struct iphdr *iph = ip_hdr(skb);
 
@@ -338,13 +339,14 @@ static inline void ip_select_ident_segs(
 			iph->id = 0;
 		}
 	} else {
-		__ip_select_ident(iph, segs);
+		__ip_select_ident(net, iph, segs);
 	}
 }
 
-static inline void ip_select_ident(struct sk_buff *skb, struct sock *sk)
+static inline void ip_select_ident(struct net *net, struct sk_buff *skb,
+				   struct sock *sk)
 {
-	ip_select_ident_segs(skb, sk, 1);
+	ip_select_ident_segs(net, skb, sk, 1);
 }
 
 static inline __wsum inet_compute_pseudo(struct sk_buff *skb, int proto)
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -395,7 +395,7 @@ static struct sk_buff *igmpv3_newpack(st
 
 	pip->protocol = IPPROTO_IGMP;
 	pip->tot_len  = 0;	/* filled in later */
-	ip_select_ident(skb, NULL);
+	ip_select_ident(net, skb, NULL);
 	((u8 *)&pip[1])[0] = IPOPT_RA;
 	((u8 *)&pip[1])[1] = 4;
 	((u8 *)&pip[1])[2] = 0;
@@ -739,7 +739,7 @@ static int igmp_send_report(struct in_de
 	iph->daddr    = dst;
 	iph->saddr    = fl4.saddr;
 	iph->protocol = IPPROTO_IGMP;
-	ip_select_ident(skb, NULL);
+	ip_select_ident(net, skb, NULL);
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
 	((u8 *)&iph[1])[2] = 0;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -150,7 +150,7 @@ int ip_build_and_send_pkt(struct sk_buff
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(skb, sk);
+	ip_select_ident(sock_net(sk), skb, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -432,7 +432,8 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_segs(skb, sk, skb_shinfo(skb)->gso_segs ?: 1);
+	ip_select_ident_segs(sock_net(sk), skb, sk,
+			     skb_shinfo(skb)->gso_segs ?: 1);
 
 	/* TODO : should we use skb->sk here instead of sk ? */
 	skb->priority = sk->sk_priority;
@@ -1385,7 +1386,7 @@ struct sk_buff *__ip_make_skb(struct soc
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(skb, sk);
+	ip_select_ident(net, skb, sk);
 
 	if (opt) {
 		iph->ihl += opt->optlen>>2;
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -74,7 +74,7 @@ int iptunnel_xmit(struct sock *sk, struc
 	iph->daddr	=	dst;
 	iph->saddr	=	src;
 	iph->ttl	=	ttl;
-	__ip_select_ident(iph, skb_shinfo(skb)->gso_segs ?: 1);
+	__ip_select_ident(sock_net(sk), iph, skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out_sk(sk, skb);
 	if (unlikely(net_xmit_eval(err)))
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1647,7 +1647,8 @@ static struct notifier_block ip_mr_notif
  *	important for multicast video.
  */
 
-static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
+static void ip_encap(struct net *net, struct sk_buff *skb,
+		     __be32 saddr, __be32 daddr)
 {
 	struct iphdr *iph;
 	const struct iphdr *old_iph = ip_hdr(skb);
@@ -1666,7 +1667,7 @@ static void ip_encap(struct sk_buff *skb
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(skb, NULL);
+	ip_select_ident(net, skb, NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
@@ -1763,7 +1764,7 @@ static void ipmr_queue_xmit(struct net *
 	 * What do we do with netfilter? -- RR
 	 */
 	if (vif->flags & VIFF_TUNNEL) {
-		ip_encap(skb, vif->local, vif->remote);
+		ip_encap(net, skb, vif->local, vif->remote);
 		/* FIXME: extra output firewall step used to be here. --RR */
 		vif->dev->stats.tx_packets++;
 		vif->dev->stats.tx_bytes += skb->len;
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -399,7 +399,7 @@ static int raw_send_hdrinc(struct sock *
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(skb, NULL);
+			ip_select_ident(net, skb, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -484,7 +484,7 @@ u32 ip_idents_reserve(u32 hash, int segs
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 
-void __ip_select_ident(struct iphdr *iph, int segs)
+void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
 {
 	static u32 ip_idents_hashrnd __read_mostly;
 	u32 hash, id;
@@ -493,7 +493,7 @@ void __ip_select_ident(struct iphdr *iph
 
 	hash = jhash_3words((__force u32)iph->daddr,
 			    (__force u32)iph->saddr,
-			    iph->protocol,
+			    iph->protocol ^ net_hash_mix(net),
 			    ip_idents_hashrnd);
 	id = ip_idents_reserve(hash, segs);
 	iph->id = htons(id);
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -63,7 +63,7 @@ static int xfrm4_mode_tunnel_output(stru
 
 	top_iph->saddr = x->props.saddr.a4;
 	top_iph->daddr = x->id.daddr.a4;
-	ip_select_ident(skb, NULL);
+	ip_select_ident(dev_net(dst->dev), skb, NULL);
 
 	return 0;
 }
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -813,7 +813,8 @@ int
 ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
 {
-	struct netns_ipvs *ipvs = net_ipvs(skb_net(skb));
+	struct net *net = skb_net(skb);
+	struct netns_ipvs *ipvs = net_ipvs(net);
 	struct rtable *rt;			/* Route to the other host */
 	__be32 saddr;				/* Source for tunnel */
 	struct net_device *tdev;		/* Device to other host */
@@ -882,7 +883,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, s
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(skb, NULL);
+	ip_select_ident(net, skb, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;

