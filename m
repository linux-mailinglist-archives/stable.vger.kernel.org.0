Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FD499D59
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583301AbiAXWRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580326AbiAXWJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6896EC0DDDB5;
        Mon, 24 Jan 2022 12:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C8160B89;
        Mon, 24 Jan 2022 20:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3517C340F5;
        Mon, 24 Jan 2022 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056991;
        bh=lkrwcZs1rqswsvxiGuBq5poRVJf34efWrzR6up4nC3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGnyjVoi4260KdJsydiO2mrPp1RkJdzJEVNCk55edPZDNFqaSTu8mgAsqu0NBH+fV
         u4yjRUSDgdOkxXjxgcvs3wQrWzhv+0OQyM5yirEQuYrH53ZFXZlMpjrOBMY22wOtc6
         fo2UGuKCQheJd0/meYKFvgOssQu0FXyKxetYIY80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 666/846] udp6: Use Segment Routing Header for dest address if present
Date:   Mon, 24 Jan 2022 19:43:03 +0100
Message-Id: <20220124184124.037991401@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 222a011efc839ca1f51bf89fe7a2b3705fa55ccd ]

When finding the socket to report an error on, if the invoking packet
is using Segment Routing, the IPv6 destination address is that of an
intermediate router, not the end destination. Extract the ultimate
destination address from the segment address.

This change allows traceroute to function in the presence of Segment
Routing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/seg6.h |   19 +++++++++++++++++++
 net/ipv6/udp.c     |    3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -65,4 +65,23 @@ extern int seg6_do_srh_encap(struct sk_b
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
 extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 			       u32 tbl_id);
+
+/* If the packet which invoked an ICMP error contains an SRH return
+ * the true destination address from within the SRH, otherwise use the
+ * destination address in the IP header.
+ */
+static inline const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
+						    struct inet6_skb_parm *opt)
+{
+	struct ipv6_sr_hdr *srh;
+
+	if (opt->flags & IP6SKB_SEG6) {
+		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
+		return  &srh->segments[0];
+	}
+
+	return NULL;
+}
+
+
 #endif
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -40,6 +40,7 @@
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/raw.h>
+#include <net/seg6.h>
 #include <net/tcp_states.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_tunnel.h>
@@ -561,7 +562,7 @@ int __udp6_lib_err(struct sk_buff *skb,
 	struct ipv6_pinfo *np;
 	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
 	const struct in6_addr *saddr = &hdr->saddr;
-	const struct in6_addr *daddr = &hdr->daddr;
+	const struct in6_addr *daddr = seg6_get_daddr(skb, opt) ? : &hdr->daddr;
 	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
 	bool tunnel = false;
 	struct sock *sk;


