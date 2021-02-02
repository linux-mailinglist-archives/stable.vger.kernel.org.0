Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6304430C08D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhBBOBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233544AbhBBN7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230B264FEF;
        Tue,  2 Feb 2021 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273573;
        bh=V+qjLziZGt2v9LS4/iEvp3So9Gqd5wEfy7zca1lFNVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB3kFQCS0PKT4cvT7aygoA6vQKy9vz4U4h5c6wAlQxmvdwwRlH/mT5GBhMIcAPJvq
         E1HlX+BxvtQf8iZnlc55cvq7A4N2TmBpCNtrwQunZRrZuuftd7Ijjt3ZutcBriprNG
         OCiHIWTYPgUf/Zs+b9yi/PxefzpEny9m7YCxM/GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Aviraj CJ <acj@cisco.com>
Subject: [PATCH 5.4 02/61] IPv6: reply ICMP error if the first fragment dont include all headers
Date:   Tue,  2 Feb 2021 14:37:40 +0100
Message-Id: <20210202132946.588647725@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit 2efdaaaf883a143061296467913c01aa1ff4b3ce upstream.

Based on RFC 8200, Section 4.5 Fragment Header:

  -  If the first fragment does not include all headers through an
     Upper-Layer header, then that fragment should be discarded and
     an ICMP Parameter Problem, Code 3, message should be sent to
     the source of the fragment, with the Pointer field set to zero.

Checking each packet header in IPv6 fast path will have performance impact,
so I put the checking in ipv6_frag_rcv().

As the packet may be any kind of L4 protocol, I only checked some common
protocols' header length and handle others by (offset + 1) > skb->len.
Also use !(frag_off & htons(IP6_OFFSET)) to catch atomic fragments
(fragmented packet with only one fragment).

When send ICMP error message, if the 1st truncated fragment is ICMP message,
icmp6_send() will break as is_ineligible() return true. So I added a check
in is_ineligible() to let fragment packet with nexthdr ICMP but no ICMP header
return false.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aviraj CJ <acj@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/icmp.c       |    8 +++++++-
 net/ipv6/reassembly.c |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -158,7 +158,13 @@ static bool is_ineligible(const struct s
 		tp = skb_header_pointer(skb,
 			ptr+offsetof(struct icmp6hdr, icmp6_type),
 			sizeof(_type), &_type);
-		if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
+
+		/* Based on RFC 8200, Section 4.5 Fragment Header, return
+		 * false if this is a fragment packet with no icmp header info.
+		 */
+		if (!tp && frag_off != 0)
+			return false;
+		else if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
 			return true;
 	}
 	return false;
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -42,6 +42,8 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 
 #include <net/sock.h>
 #include <net/snmp.h>
@@ -322,7 +324,9 @@ static int ipv6_frag_rcv(struct sk_buff
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
-	int iif;
+	__be16 frag_off;
+	int iif, offset;
+	u8 nexthdr;
 
 	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
 		goto fail_hdr;
@@ -351,6 +355,33 @@ static int ipv6_frag_rcv(struct sk_buff
 		return 1;
 	}
 
+	/* RFC 8200, Section 4.5 Fragment Header:
+	 * If the first fragment does not include all headers through an
+	 * Upper-Layer header, then that fragment should be discarded and
+	 * an ICMP Parameter Problem, Code 3, message should be sent to
+	 * the source of the fragment, with the Pointer field set to zero.
+	 */
+	nexthdr = hdr->nexthdr;
+	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
+	if (offset >= 0) {
+		/* Check some common protocols' header */
+		if (nexthdr == IPPROTO_TCP)
+			offset += sizeof(struct tcphdr);
+		else if (nexthdr == IPPROTO_UDP)
+			offset += sizeof(struct udphdr);
+		else if (nexthdr == IPPROTO_ICMPV6)
+			offset += sizeof(struct icmp6hdr);
+		else
+			offset += 1;
+
+		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
+			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
+					IPSTATS_MIB_INHDRERRORS);
+			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+			return -1;
+		}
+	}
+
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {


