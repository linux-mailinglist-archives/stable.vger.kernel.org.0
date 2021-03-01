Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A463284D6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhCAQnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233026AbhCAQhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B0064EC8;
        Mon,  1 Mar 2021 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615984;
        bh=/M/a+jzGimRPRY1pBq2JTlNM2kSflUMO7Fcliuwng7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+NR5EjQwPDhzFFyQk6UYNfnS9N/0xji+Dg6CZ9IlvGqx4Rhu6y77nnQ+nv4K1fBm
         bSkfsGdIu9sGwP4P637Z5nEydhd2dTppw/q2Jrm0K78ON9Wuq3cfuwVplrcIOTsNf1
         HZKZRnNlVYBUnaNrPGPNRRH+Bo9+OtJLxBadJVCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 128/134] icmp: introduce helper for natd source address in network device context
Date:   Mon,  1 Mar 2021 17:13:49 +0100
Message-Id: <20210301161019.893661461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 0b41713b606694257b90d61ba7e2712d8457648b upstream.

This introduces a helper function to be called only by network drivers
that wraps calls to icmp[v6]_send in a conntrack transformation, in case
NAT has been used. We don't want to pollute the non-driver path, though,
so we introduce this as a helper to be called by places that actually
make use of this, as suggested by Florian.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/icmpv6.h |    6 ++++++
 include/net/icmp.h     |    6 ++++++
 net/ipv4/icmp.c        |   33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_icmp.c    |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -30,6 +30,12 @@ static inline void icmpv6_send(struct sk
 }
 #endif
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
+#else
+#define icmpv6_ndo_send icmpv6_send
+#endif
+
 extern int				icmpv6_init(void);
 extern int				icmpv6_err_convert(u8 type, u8 code,
 							   int *err);
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -47,6 +47,12 @@ static inline void icmp_send(struct sk_b
 	__icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
+#else
+#define icmp_ndo_send icmp_send
+#endif
+
 int icmp_rcv(struct sk_buff *skb);
 void icmp_err(struct sk_buff *skb, u32 info);
 int icmp_init(void);
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -738,6 +738,39 @@ out:;
 }
 EXPORT_SYMBOL(__icmp_send);
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	struct sk_buff *cloned_skb = NULL;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	__be32 orig_ip;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		icmp_send(skb_in, type, code, info);
+		return;
+	}
+
+	if (skb_shared(skb_in))
+		skb_in = cloned_skb = skb_clone(skb_in, GFP_ATOMIC);
+
+	if (unlikely(!skb_in || skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct iphdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct iphdr))))
+		goto out;
+
+	orig_ip = ip_hdr(skb_in)->saddr;
+	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	icmp_send(skb_in, type, code, info);
+	ip_hdr(skb_in)->saddr = orig_ip;
+out:
+	consume_skb(cloned_skb);
+}
+EXPORT_SYMBOL(icmp_ndo_send);
+#endif
 
 static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 {
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -44,4 +44,38 @@ out:
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+#include <net/netfilter/nf_conntrack.h>
+void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
+	struct sk_buff *cloned_skb = NULL;
+	enum ip_conntrack_info ctinfo;
+	struct in6_addr orig_ip;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb_in, &ctinfo);
+	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+		icmpv6_send(skb_in, type, code, info);
+		return;
+	}
+
+	if (skb_shared(skb_in))
+		skb_in = cloned_skb = skb_clone(skb_in, GFP_ATOMIC);
+
+	if (unlikely(!skb_in || skb_network_header(skb_in) < skb_in->head ||
+	    (skb_network_header(skb_in) + sizeof(struct ipv6hdr)) >
+	    skb_tail_pointer(skb_in) || skb_ensure_writable(skb_in,
+	    skb_network_offset(skb_in) + sizeof(struct ipv6hdr))))
+		goto out;
+
+	orig_ip = ipv6_hdr(skb_in)->saddr;
+	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	icmpv6_send(skb_in, type, code, info);
+	ipv6_hdr(skb_in)->saddr = orig_ip;
+out:
+	consume_skb(cloned_skb);
+}
+EXPORT_SYMBOL(icmpv6_ndo_send);
+#endif
 #endif


