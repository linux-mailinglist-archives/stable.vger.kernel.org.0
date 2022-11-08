Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815AD6212DE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiKHNnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiKHNno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:43:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9915B12AFD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:43:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE87EB81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28417C433B5;
        Tue,  8 Nov 2022 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915017;
        bh=/QgvgJHtJ4OqoN66a/F5B3SU7FUOQbcMBzzrK4t86Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoTKS2hW+aA7Pyjz9rbUtAAJeXxabxtKQCaUpnyB7rXyBYC0oO61s5ZAw4M17glUz
         J5EQ7XZYoAgibhIuHRqQCTlHeME9fSpQtepVbrx24oz0Rf6RB4AEcc5KXESyqwlYPu
         ax3NtX01wtZhHOo0zXlggIpS/3oAEgyft+p07e3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 26/40] tcp/udp: Make early_demux back namespacified.
Date:   Tue,  8 Nov 2022 14:39:11 +0100
Message-Id: <20221108133329.363720341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 11052589cf5c0bab3b4884d423d5f60c38fcf25d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/protocol.h     |    4 ---
 include/net/tcp.h          |    2 +
 include/net/udp.h          |    1 
 net/ipv4/af_inet.c         |   14 +---------
 net/ipv4/ip_input.c        |   32 ++++++++++++++++--------
 net/ipv4/sysctl_net_ipv4.c |   59 +--------------------------------------------
 net/ipv6/ip6_input.c       |   23 +++++++++++------
 net/ipv6/tcp_ipv6.c        |    9 +-----
 net/ipv6/udp.c             |    9 +-----
 9 files changed, 47 insertions(+), 106 deletions(-)

--- a/include/net/protocol.h
+++ b/include/net/protocol.h
@@ -39,8 +39,6 @@
 
 /* This is used to register protocols. */
 struct net_protocol {
-	int			(*early_demux)(struct sk_buff *skb);
-	int			(*early_demux_handler)(struct sk_buff *skb);
 	int			(*handler)(struct sk_buff *skb);
 	void			(*err_handler)(struct sk_buff *skb, u32 info);
 	unsigned int		no_policy:1,
@@ -54,8 +52,6 @@ struct net_protocol {
 
 #if IS_ENABLED(CONFIG_IPV6)
 struct inet6_protocol {
-	void	(*early_demux)(struct sk_buff *skb);
-	void    (*early_demux_handler)(struct sk_buff *skb);
 	int	(*handler)(struct sk_buff *skb);
 
 	void	(*err_handler)(struct sk_buff *skb,
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -890,6 +890,8 @@ static inline int tcp_v6_sdif(const stru
 #endif
 	return 0;
 }
+
+void tcp_v6_early_demux(struct sk_buff *skb);
 #endif
 
 static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -173,6 +173,7 @@ typedef struct sock *(*udp_lookup_t)(str
 struct sk_buff **udp_gro_receive(struct sk_buff **head, struct sk_buff *skb,
 				 struct udphdr *uh, udp_lookup_t lookup);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+void udp_v6_early_demux(struct sk_buff *skb);
 
 static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 {
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1608,12 +1608,7 @@ static const struct net_protocol igmp_pr
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
@@ -1621,12 +1616,7 @@ static struct net_protocol tcp_protocol
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
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -307,10 +307,11 @@ drop:
 	return true;
 }
 
+int udp_v4_early_demux(struct sk_buff *);
+int tcp_v4_early_demux(struct sk_buff *);
 static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	struct net_device *dev = skb->dev;
 	struct rtable *rt;
 	int err;
@@ -322,20 +323,29 @@ static int ip_rcv_finish(struct net *net
 	if (!skb)
 		return NET_RX_SUCCESS;
 
-	if (net->ipv4.sysctl_ip_early_demux &&
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
 	    !skb_dst(skb) &&
 	    !skb->sk &&
 	    !ip_is_fragment(iph)) {
-		const struct net_protocol *ipprot;
-		int protocol = iph->protocol;
+		switch (iph->protocol) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
+				tcp_v4_early_demux(skb);
 
-		ipprot = rcu_dereference(inet_protos[protocol]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
-			err = edemux(skb);
-			if (unlikely(err))
-				goto drop_error;
-			/* must reload iph, skb->head might have changed */
-			iph = ip_hdr(skb);
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
 
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -311,61 +311,6 @@ bad_key:
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
@@ -853,14 +798,14 @@ static struct ctl_table ipv4_net_table[]
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_udp_early_demux
+		.proc_handler   = proc_douintvec,
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_tcp_early_demux
+		.proc_handler   = proc_douintvec,
 	},
 	{
 		.procname	= "ip_default_ttl",
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -47,10 +47,10 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
+void udp_v6_early_demux(struct sk_buff *);
+void tcp_v6_early_demux(struct sk_buff *);
 int ip6_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	void (*edemux)(struct sk_buff *skb);
-
 	/* if ingress device is enslaved to an L3 master device pass the
 	 * skb to its handler for processing
 	 */
@@ -58,13 +58,20 @@ int ip6_rcv_finish(struct net *net, stru
 	if (!skb)
 		return NET_RX_SUCCESS;
 
-	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
-		const struct inet6_protocol *ipprot;
-
-		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
-			edemux(skb);
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
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1635,7 +1635,7 @@ do_time_wait:
 	goto discard_it;
 }
 
-static void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -1991,12 +1991,7 @@ struct proto tcpv6_prot = {
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
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -932,7 +932,7 @@ static struct sock *__udp6_lib_demux_loo
 	return NULL;
 }
 
-static void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1491,12 +1491,7 @@ int compat_udpv6_getsockopt(struct sock
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


