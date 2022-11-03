Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AAB618D07
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 00:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKCXyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 19:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCXyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 19:54:49 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC51A1CB30
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 16:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667519689; x=1699055689;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rNp924a5mg3Snat2+S8ktQ6J4NaKQbyMaKgW0V5vMJc=;
  b=a7EVVjXbf8wIOxI+I4G3xl6iwAj8C1ZBQw1+vaEeTMBNE2cYNlWcXTLu
   BnaOIjVPSZ+fDR4YSVEMxqK9lNBBn1K0zc4VcqA2S3DS76B1A2kif1M8u
   NfkgPTTuDilwt8C7BuUTqfcHLuiLW3KEf+oYREtQBdEU1ezSdXnCfpiWc
   o=;
X-IronPort-AV: E=Sophos;i="5.96,135,1665446400"; 
   d="scan'208";a="276541862"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 23:54:44 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id CAEFF600FA;
        Thu,  3 Nov 2022 23:54:43 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 3 Nov 2022 23:54:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 3 Nov 2022 23:54:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4] tcp/udp: Make early_demux back namespacified.
Date:   Thu, 3 Nov 2022 16:54:32 -0700
Message-ID: <20221103235432.48021-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/tcp.h          |  2 ++
 include/net/udp.h          |  1 +
 net/ipv4/af_inet.c         | 14 ++-------
 net/ipv4/ip_input.c        | 37 ++++++++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 59 ++------------------------------------
 net/ipv6/ip6_input.c       | 26 ++++++++++-------
 net/ipv6/tcp_ipv6.c        |  9 ++----
 net/ipv6/udp.c             |  9 ++----
 9 files changed, 48 insertions(+), 113 deletions(-)

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
index 5b2473a08241..077feeca6c99 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -922,6 +922,8 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 #endif
 	return 0;
 }
+
+void tcp_v6_early_demux(struct sk_buff *skb);
 #endif
 
 static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
diff --git a/include/net/udp.h b/include/net/udp.h
index e66854e767dc..bbd607fb939a 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -169,6 +169,7 @@ typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 				struct udphdr *uh, udp_lookup_t lookup);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+void udp_v6_early_demux(struct sk_buff *skb);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 058dbcb90541..3c6412cb4b48 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1702,12 +1702,7 @@ static const struct net_protocol igmp_protocol = {
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
@@ -1715,12 +1710,7 @@ static struct net_protocol tcp_protocol = {
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
index c59a78a267c3..1464e2738211 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -302,31 +302,38 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 	return true;
 }
 
-INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
+int udp_v4_early_demux(struct sk_buff *);
+int tcp_v4_early_demux(struct sk_buff *);
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			      struct sk_buff *skb, struct net_device *dev)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	struct rtable *rt;
 	int err;
 
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
index c83a5d05aeaa..4d4dba1d42ae 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -363,61 +363,6 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
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
-				void __user *buffer, size_t *lenp, loff_t *ppos)
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
-				void __user *buffer, size_t *lenp, loff_t *ppos)
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
 					     int write,
 					     void __user *buffer,
@@ -701,14 +646,14 @@ static struct ctl_table ipv4_net_table[] = {
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
 		.procname	= "ip_default_ttl",
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e6c4966aa956..ebf90bce063a 100644
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
index 397c4597c438..831f779aba7b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1729,7 +1729,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -2084,12 +2084,7 @@ struct proto tcpv6_prot = {
 	.diag_destroy		= tcp_abort,
 };
 
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
index 62c0db6df563..fd1ce0405b7e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -973,7 +973,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1603,12 +1603,7 @@ int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
 }
 #endif
 
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

