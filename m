Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135DC1D0D6C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbgEMJw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387860AbgEMJwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F60206D6;
        Wed, 13 May 2020 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363575;
        bh=xqrh2MopQeipAcdHacog6ivfLRVDwUVB/2W23jrA/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jok1ZPMZMc4D25jrfM1gzlHeZJ5+1XGKu1TxuCaT4ZtK8V1f+6OKb3SwsAHj5Po9I
         GWcheY6C82PvHD/x+j5mQ2lWMNNtnXTr/e1KQTEDHS9TUlylZu9K58e2dWXxthTiQs
         qmTOwkVMDCGQA2SihEqnDfungc6HNzKokQ3o5/do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Briscoe <ietf@bobbriscoe.net>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 040/118] tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040
Date:   Wed, 13 May 2020 11:44:19 +0200
Message-Id: <20200513094420.866941098@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke H�iland-J�rgensen" <toke@redhat.com>

[ Upstream commit b723748750ece7d844cdf2f52c01d37f83387208 ]

RFC 6040 recommends propagating an ECT(1) mark from an outer tunnel header
to the inner header if that inner header is already marked as ECT(0). When
RFC 6040 decapsulation was implemented, this case of propagation was not
added. This simply appears to be an oversight, so let's fix that.

Fixes: eccc1bb8d4b4 ("tunnel: drop packet if ECN present with not-ECT")
Reported-by: Bob Briscoe <ietf@bobbriscoe.net>
Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Cc: Dave Taht <dave.taht@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_ecn.h |   57 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -99,6 +99,20 @@ static inline int IP_ECN_set_ce(struct i
 	return 1;
 }
 
+static inline int IP_ECN_set_ect1(struct iphdr *iph)
+{
+	u32 check = (__force u32)iph->check;
+
+	if ((iph->tos & INET_ECN_MASK) != INET_ECN_ECT_0)
+		return 0;
+
+	check += (__force u16)htons(0x100);
+
+	iph->check = (__force __sum16)(check + (check>=0xFFFF));
+	iph->tos ^= INET_ECN_MASK;
+	return 1;
+}
+
 static inline void IP_ECN_clear(struct iphdr *iph)
 {
 	iph->tos &= ~INET_ECN_MASK;
@@ -134,6 +148,22 @@ static inline int IP6_ECN_set_ce(struct
 	return 1;
 }
 
+static inline int IP6_ECN_set_ect1(struct sk_buff *skb, struct ipv6hdr *iph)
+{
+	__be32 from, to;
+
+	if ((ipv6_get_dsfield(iph) & INET_ECN_MASK) != INET_ECN_ECT_0)
+		return 0;
+
+	from = *(__be32 *)iph;
+	to = from ^ htonl(INET_ECN_MASK << 20);
+	*(__be32 *)iph = to;
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)from),
+				     (__force __wsum)to);
+	return 1;
+}
+
 static inline void ipv6_copy_dscp(unsigned int dscp, struct ipv6hdr *inner)
 {
 	dscp &= ~INET_ECN_MASK;
@@ -159,6 +189,25 @@ static inline int INET_ECN_set_ce(struct
 	return 0;
 }
 
+static inline int INET_ECN_set_ect1(struct sk_buff *skb)
+{
+	switch (skb->protocol) {
+	case cpu_to_be16(ETH_P_IP):
+		if (skb_network_header(skb) + sizeof(struct iphdr) <=
+		    skb_tail_pointer(skb))
+			return IP_ECN_set_ect1(ip_hdr(skb));
+		break;
+
+	case cpu_to_be16(ETH_P_IPV6):
+		if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
+		    skb_tail_pointer(skb))
+			return IP6_ECN_set_ect1(skb, ipv6_hdr(skb));
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * RFC 6040 4.2
  *  To decapsulate the inner header at the tunnel egress, a compliant
@@ -208,8 +257,12 @@ static inline int INET_ECN_decapsulate(s
 	int rc;
 
 	rc = __INET_ECN_decapsulate(outer, inner, &set_ce);
-	if (!rc && set_ce)
-		INET_ECN_set_ce(skb);
+	if (!rc) {
+		if (set_ce)
+			INET_ECN_set_ce(skb);
+		else if ((outer & INET_ECN_MASK) == INET_ECN_ECT_1)
+			INET_ECN_set_ect1(skb);
+	}
 
 	return rc;
 }


