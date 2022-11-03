Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76437618D08
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 00:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKCX4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 19:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCX4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 19:56:19 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C81DF23
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 16:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667519778; x=1699055778;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hqaatb+6PWrBMshMMlOMP+XA1wGiRWWnJtbCvFwZtwU=;
  b=Z1xUW+MmpYwucu4aj5+90TrRD5v0aTgb/k+bjJO5fAe3MTwPEsuiWWDw
   +TbotJ96JiC3eQXS8npg7lsSFyy5dyGPiM4DKxwd8fkr+zIn3hjBcfwK7
   b0DVsDLo/AV2bC5rHCa3PKl3NhvKo8IXIGNBzHTyV5Bi09Fqp0qHoIM8F
   c=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 23:56:17 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id E237D81B89;
        Thu,  3 Nov 2022 23:56:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 3 Nov 2022 23:56:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 3 Nov 2022 23:56:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10] tcp/udp: Make early_demux back namespacified.
Date:   Thu, 3 Nov 2022 16:56:04 -0700
Message-ID: <20221103235604.48199-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D30UWB004.ant.amazon.com (10.43.161.51) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 11052589cf5c0bab3b4884d423d5f60c38fcf25d upstream

Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
it possible to enable/disable early_demux on a per-netns basis.  Then, we
introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
tcp and udp").  However, the .proc_handler() was wrong and actually
disabled us from changing the behaviour in each netns.

We can execute early_demux if net.ipv4.ip_early_demux is on and each proto
.early_demux() handler is not NULL.  When we toggle (tcp|udp)_early_demux,
the change itself is saved in each netns variable, but the .early_demux()
handler is a global variable, so the handler is switched based on the
init_net's sysctl variable.  Thus, netns (tcp|udp)_early_demux knobs have
nothing to do with the logic.  Whether we CAN execute proto .early_demux()
is always decided by init_net's sysctl knob, and whether we DO it or not is
by each netns ip_early_demux knob.

This patch namespacifies (tcp|udp)_early_demux again.  For now, the users
of the .early_demux() handler are TCP and UDP only, and they are called
directly to avoid retpoline.  So, we can remove the .early_demux() handler
from inet6?_protos and need not dereference them in ip6?_rcv_finish_core().
If another proto needs .early_demux(), we can restore it at that time.

Fixes: dddb64bcb346 ("net: Add sysctl to toggle early demux for tcp and udp")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20220713175207.7727-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/protocol.h     |  4 ---
 include/net/tcp.h          |  2 +-
 include/net/udp.h          |  1 +
 net/ipv4/af_inet.c         | 14 ++-------
 net/ipv4/ip_input.c        | 37 ++++++++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 59 ++------------------------------------
 net/ipv6/ip6_input.c       | 26 ++++++++++-------
 net/ipv6/tcp_ipv6.c        |  9 ++----
 net/ipv6/udp.c             |  9 ++----
 9 files changed, 47 insertions(+), 114 deletions(-)

diff --git a/include/net/protocol.h b/include/net/protocol.h
index 2b778e1d2d8f..0fd2df844fc7 100644
--- a/include/net/protocol.h
+++ b/include/net/protocol.h
@@ -35,8 +35,6 @@
 
 /* This is used to register protocols. */
 struct net_protocol {
-	int			(*early_demux)(struct sk_buff *skb);
-	int			(*early_demux_handler)(struct sk_buff *skb);
 	int			(*handler)(struct sk_buff *skb);
 
 	/* This returns an error if we weren't able to handle the error. */
@@ -53,8 +51,6 @@ struct net_protocol {
 
 #if IS_ENABLED(CONFIG_IPV6)
 struct inet6_protocol {
-	void	(*early_demux)(struct sk_buff *skb);
-	void    (*early_demux_handler)(struct sk_buff *skb);
 	int	(*handler)(struct sk_buff *skb);
 
 	/* This returns an error if we weren't able to handle the error. */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index bf4af27f5620..9a8d98639b20 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -934,7 +934,7 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
 
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
-INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
+void tcp_v6_early_demux(struct sk_buff *skb);
 
 #endif
 
diff --git a/include/net/udp.h b/include/net/udp.h
index 010bc324f860..388e68c7bca0 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -176,6 +176,7 @@ INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 				struct udphdr *uh, struct sock *sk);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+void udp_v6_early_demux(struct sk_buff *skb);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features, bool is_ipv6);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 87d73a3e92ba..48223c264991 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1726,12 +1726,7 @@ static const struct net_protocol igmp_protocol = {
 };
 #endif
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol tcp_protocol = {
-	.early_demux	=	tcp_v4_early_demux,
-	.early_demux_handler =  tcp_v4_early_demux,
+static const struct net_protocol tcp_protocol = {
 	.handler	=	tcp_v4_rcv,
 	.err_handler	=	tcp_v4_err,
 	.no_policy	=	1,
@@ -1739,12 +1734,7 @@ static struct net_protocol tcp_protocol = {
 	.icmp_strict_tag_validation = 1,
 };
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol udp_protocol = {
-	.early_demux =	udp_v4_early_demux,
-	.early_demux_handler =	udp_v4_early_demux,
+static const struct net_protocol udp_protocol = {
 	.handler =	udp_rcv,
 	.err_handler =	udp_err,
 	.no_policy =	1,
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index b0c244af1e4d..f6b3237e88ca 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -309,14 +309,13 @@ static bool ip_can_use_hint(const struct sk_buff *skb, const struct iphdr *iph,
 	       ip_hdr(hint)->tos == iph->tos;
 }
 
-INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
+int tcp_v4_early_demux(struct sk_buff *skb);
+int udp_v4_early_demux(struct sk_buff *skb);
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			      struct sk_buff *skb, struct net_device *dev,
 			      const struct sk_buff *hint)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	struct rtable *rt;
 	int err;
 
@@ -327,21 +326,29 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			goto drop_error;
 	}
 
-	if (net->ipv4.sysctl_ip_early_demux &&
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
 	    !skb_dst(skb) &&
 	    !skb->sk &&
 	    !ip_is_fragment(iph)) {
-		const struct net_protocol *ipprot;
-		int protocol = iph->protocol;
-
-		ipprot = rcu_dereference(inet_protos[protocol]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
-			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
-					      udp_v4_early_demux, skb);
-			if (unlikely(err))
-				goto drop_error;
-			/* must reload iph, skb->head might have changed */
-			iph = ip_hdr(skb);
+		switch (iph->protocol) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
+				tcp_v4_early_demux(skb);
+
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_udp_early_demux)) {
+				err = udp_v4_early_demux(skb);
+				if (unlikely(err))
+					goto drop_error;
+
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
 		}
 	}
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 86f553864f98..439970e02ac6 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -361,61 +361,6 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 	return ret;
 }
 
-static void proc_configure_early_demux(int enabled, int protocol)
-{
-	struct net_protocol *ipprot;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_protocol *ip6prot;
-#endif
-
-	rcu_read_lock();
-
-	ipprot = rcu_dereference(inet_protos[protocol]);
-	if (ipprot)
-		ipprot->early_demux = enabled ? ipprot->early_demux_handler :
-						NULL;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	ip6prot = rcu_dereference(inet6_protos[protocol]);
-	if (ip6prot)
-		ip6prot->early_demux = enabled ? ip6prot->early_demux_handler :
-						 NULL;
-#endif
-	rcu_read_unlock();
-}
-
-static int proc_tcp_early_demux(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_tcp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_TCP);
-	}
-
-	return ret;
-}
-
-static int proc_udp_early_demux(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_udp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_UDP);
-	}
-
-	return ret;
-}
-
 static int proc_tfo_blackhole_detect_timeout(struct ctl_table *table,
 					     int write, void *buffer,
 					     size_t *lenp, loff_t *ppos)
@@ -685,14 +630,14 @@ static struct ctl_table ipv4_net_table[] = {
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_udp_early_demux
+		.proc_handler   = proc_douintvec_minmax,
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_tcp_early_demux
+		.proc_handler   = proc_douintvec_minmax,
 	},
 	{
 		.procname       = "nexthop_compat_mode",
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 15ea3d082534..4eb9fbfdce33 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -44,21 +44,25 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
-INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
+void udp_v6_early_demux(struct sk_buff *);
+void tcp_v6_early_demux(struct sk_buff *);
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 				struct sk_buff *skb)
 {
-	void (*edemux)(struct sk_buff *skb);
-
-	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
-		const struct inet6_protocol *ipprot;
-
-		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
-			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
-					udp_v6_early_demux, skb);
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
+	    !skb_dst(skb) && !skb->sk) {
+		switch (ipv6_hdr(skb)->nexthdr) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux))
+				tcp_v6_early_demux(skb);
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_udp_early_demux))
+				udp_v6_early_demux(skb);
+			break;
+		}
 	}
+
 	if (!skb_valid_dst(skb))
 		ip6_route_input(skb);
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c14eaec64a0b..a558dd9d177b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1818,7 +1818,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -2169,12 +2169,7 @@ struct proto tcpv6_prot = {
 };
 EXPORT_SYMBOL_GPL(tcpv6_prot);
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol tcpv6_protocol = {
-	.early_demux	=	tcp_v6_early_demux,
-	.early_demux_handler =  tcp_v6_early_demux,
+static const struct inet6_protocol tcpv6_protocol = {
 	.handler	=	tcp_v6_rcv,
 	.err_handler	=	tcp_v6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 514e6a55959f..1805cc5f7418 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1027,7 +1027,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1640,12 +1640,7 @@ int udpv6_getsockopt(struct sock *sk, int level, int optname,
 	return ipv6_getsockopt(sk, level, optname, optval, optlen);
 }
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol udpv6_protocol = {
-	.early_demux	=	udp_v6_early_demux,
-	.early_demux_handler =  udp_v6_early_demux,
+static const struct inet6_protocol udpv6_protocol = {
 	.handler	=	udpv6_rcv,
 	.err_handler	=	udpv6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
-- 
2.30.2

