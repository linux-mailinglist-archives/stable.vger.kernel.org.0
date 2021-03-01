Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F31328784
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhCARX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237938AbhCARSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:18:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8603264F8D;
        Mon,  1 Mar 2021 16:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617217;
        bh=wOVN1u2LGymUx/373gRg6Rpugo8cKvlLKTL4NLEV9QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK7Kyt5zQW9AqeUTLwTk6KVdYgVdLqqwV/sVno2EiTBll892qC8uEAjLUfd9vV3ug
         T/Xgh2pmql/5eTaqzdGrW1vf2mzOM0iW2PZlNkXW6zWf+cdWrSqA6LKxFmg5U8C+vv
         muocYn/O0tp2RDc1QyRYtlDe9eLHsPZH0WjeYIUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 243/247] ipv6: icmp6: avoid indirect call for icmpv6_send()
Date:   Mon,  1 Mar 2021 17:14:23 +0100
Message-Id: <20210301161043.606826156@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit cc7a21b6fbd945f8d8f61422ccd27203c1fafeb7 upstream.

If IPv6 is builtin, we do not need an expensive indirect call
to reach icmp6_send().

v2: put inline keyword before the type to avoid sparse warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/icmpv6.h |   22 +++++++++++++++++++++-
 net/ipv6/icmp.c        |    5 +++--
 net/ipv6/ip6_icmp.c    |   10 +++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -13,12 +13,32 @@ static inline struct icmp6hdr *icmp6_hdr
 #include <linux/netdevice.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
-extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
 
 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 			     const struct in6_addr *force_saddr);
+#if IS_BUILTIN(CONFIG_IPV6)
+void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		const struct in6_addr *force_saddr);
+static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+{
+	icmp6_send(skb, type, code, info, NULL);
+}
+static inline int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
+{
+	BUILD_BUG_ON(fn != icmp6_send);
+	return 0;
+}
+static inline int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
+{
+	BUILD_BUG_ON(fn != icmp6_send);
+	return 0;
+}
+#else
+extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
 extern int inet6_register_icmp_sender(ip6_icmp_send_t *fn);
 extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
+#endif
+
 int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 			       unsigned int data_len);
 
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -418,8 +418,8 @@ static int icmp6_iif(const struct sk_buf
 /*
  *	Send an ICMP message in response to a packet in error
  */
-static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		       const struct in6_addr *force_saddr)
+void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		const struct in6_addr *force_saddr)
 {
 	struct inet6_dev *idev = NULL;
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -592,6 +592,7 @@ out:
 out_bh_enable:
 	local_bh_enable();
 }
+EXPORT_SYMBOL(icmp6_send);
 
 /* Slightly more convenient version of icmp6_send.
  */
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -9,6 +9,8 @@
 
 #if IS_ENABLED(CONFIG_IPV6)
 
+#if !IS_BUILTIN(CONFIG_IPV6)
+
 static ip6_icmp_send_t __rcu *ip6_icmp_send;
 
 int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
@@ -37,14 +39,12 @@ void icmpv6_send(struct sk_buff *skb, u8
 
 	rcu_read_lock();
 	send = rcu_dereference(ip6_icmp_send);
-
-	if (!send)
-		goto out;
-	send(skb, type, code, info, NULL);
-out:
+	if (send)
+		send(skb, type, code, info, NULL);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmpv6_send);
+#endif
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_conntrack.h>


