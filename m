Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CD849951C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392221AbiAXUur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44910 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358934AbiAXUnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:43:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99121B812A8;
        Mon, 24 Jan 2022 20:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE5BC36AE9;
        Mon, 24 Jan 2022 20:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056988;
        bh=pgk68VQmWUcoZYmmQjXl9EKr5hlWK6mlbLTmvAUb+Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aZyXBR9MDfYNA/rQrESDpLU/Tw0mb2ys+4CbBGG5bagzIPnYKh9pKCVTY+IE3Lx7
         HjdU3mZnajI3RtiPlmO1dhkv52rFXDw+PjAjdXeLCId+5KNY1KC0yh2C8iCIiMur1J
         HLzFdtve62Mohc9eXy/h8sxo7v9L/FIpRYEPZpAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 665/846] icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
Date:   Mon, 24 Jan 2022 19:43:02 +0100
Message-Id: <20220124184124.005079836@linuxfoundation.org>
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

[ Upstream commit e41294408c56c68ea0f269d757527bf33b39118a ]

RFC8754 says:

ICMP error packets generated within the SR domain are sent to source
nodes within the SR domain.  The invoking packet in the ICMP error
message may contain an SRH.  Since the destination address of a packet
with an SRH changes as each segment is processed, it may not be the
destination used by the socket or application that generated the
invoking packet.

For the source of an invoking packet to process the ICMP error
message, the ultimate destination address of the IPv6 header may be
required.  The following logic is used to determine the destination
address for use by protocol-error handlers.

*  Walk all extension headers of the invoking IPv6 packet to the
   routing extension header preceding the upper-layer header.

   -  If routing header is type 4 Segment Routing Header (SRH)

      o  The SID at Segment List[0] may be used as the destination
         address of the invoking packet.

Mangle the skb so the network header points to the invoking packet
inside the ICMP packet. The seg6 helpers can then be used on the skb
to find any segment routing headers. If found, mark this fact in the
IPv6 control block of the skb, and store the offset into the packet of
the SRH. Then restore the skb back to its old state.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h |  2 ++
 include/net/seg6.h   |  1 +
 net/ipv6/icmp.c      |  6 +++++-
 net/ipv6/seg6.c      | 30 ++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c383630d3f065..07cba0b3496d5 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -132,6 +132,7 @@ struct inet6_skb_parm {
 	__u16			dsthao;
 #endif
 	__u16			frag_max_size;
+	__u16			srhoff;
 
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
@@ -141,6 +142,7 @@ struct inet6_skb_parm {
 #define IP6SKB_HOPBYHOP        32
 #define IP6SKB_L3SLAVE         64
 #define IP6SKB_JUMBOGRAM      128
+#define IP6SKB_SEG6	      256
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/include/net/seg6.h b/include/net/seg6.h
index a6f25983670aa..02b0cd3057876 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -59,6 +59,7 @@ extern void seg6_local_exit(void);
 
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
+extern void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a7c31ab67c5d6..96c5cc0f30ceb 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -57,6 +57,7 @@
 #include <net/protocol.h>
 #include <net/raw.h>
 #include <net/rawv6.h>
+#include <net/seg6.h>
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
@@ -820,6 +821,7 @@ out_bh_enable:
 
 void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 {
+	struct inet6_skb_parm *opt = IP6CB(skb);
 	const struct inet6_protocol *ipprot;
 	int inner_offset;
 	__be16 frag_off;
@@ -829,6 +831,8 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
+	seg6_icmp_srh(skb, opt);
+
 	nexthdr = ((struct ipv6hdr *)skb->data)->nexthdr;
 	if (ipv6_ext_hdr(nexthdr)) {
 		/* now skip over extension headers */
@@ -853,7 +857,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 
 	ipprot = rcu_dereference(inet6_protos[nexthdr]);
 	if (ipprot && ipprot->err_handler)
-		ipprot->err_handler(skb, NULL, type, code, inner_offset, info);
+		ipprot->err_handler(skb, opt, type, code, inner_offset, info);
 
 	raw6_icmp_error(skb, nexthdr, type, code, inner_offset, info);
 	return;
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 0718529088930..fa6b64c95d3ae 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -104,6 +104,36 @@ struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags)
 	return srh;
 }
 
+/* Determine if an ICMP invoking packet contains a segment routing
+ * header.  If it does, extract the offset to the true destination
+ * address, which is in the first segment address.
+ */
+void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
+{
+	__u16 network_header = skb->network_header;
+	struct ipv6_sr_hdr *srh;
+
+	/* Update network header to point to the invoking packet
+	 * inside the ICMP packet, so we can use the seg6_get_srh()
+	 * helper.
+	 */
+	skb_reset_network_header(skb);
+
+	srh = seg6_get_srh(skb, 0);
+	if (!srh)
+		goto out;
+
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		goto out;
+
+	opt->flags |= IP6SKB_SEG6;
+	opt->srhoff = (unsigned char *)srh - skb->data;
+
+out:
+	/* Restore the network header back to the ICMP packet */
+	skb->network_header = network_header;
+}
+
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
-- 
2.34.1



