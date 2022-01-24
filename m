Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59A499D58
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583253AbiAXWRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577039AbiAXWJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:09:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E783AC045935;
        Mon, 24 Jan 2022 12:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE82B815A3;
        Mon, 24 Jan 2022 20:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99716C36AE2;
        Mon, 24 Jan 2022 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056982;
        bh=jiEayLoAhWbKjVa/Q5aV7n37t1JTQNM25s13nAD9tQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbYlSo06Bqb7k10g7o4lL8rt37IGs2j1ti4k4mnS0dQu/s0s7NKGctNiK36V/WLRY
         MvSZSIe5PbUIFDF93a6n6SeRukxC15y+RXFn04I91BA1xlJzBPh1qV7FZh/hZP2HsB
         QmgGdR15mzmlAW5uexpz5JdY7J61wjd5ivwaY0KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 664/846] seg6: export get_srh() for ICMP handling
Date:   Mon, 24 Jan 2022 19:43:01 +0100
Message-Id: <20220124184123.974917128@linuxfoundation.org>
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

[ Upstream commit fa55a7d745de2d10489295b0674a403e2a5d490d ]

An ICMP error message can contain in its message body part of an IPv6
packet which invoked the error. Such a packet might contain a segment
router header. Export get_srh() so the ICMP code can make use of it.

Since his changes the scope of the function from local to global, add
the seg6_ prefix to keep the namespace clean. And move it into seg6.c
so it is always available, not just when IPV6_SEG6_LWTUNNEL is
enabled.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/seg6.h    |  1 +
 net/ipv6/seg6.c       | 29 +++++++++++++++++++++++++++++
 net/ipv6/seg6_local.c | 33 ++-------------------------------
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 9d19c15e8545c..a6f25983670aa 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -58,6 +58,7 @@ extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
+extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index e412817fba2f3..0718529088930 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -75,6 +75,35 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 	return true;
 }
 
+struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags)
+{
+	struct ipv6_sr_hdr *srh;
+	int len, srhoff = 0;
+
+	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, &flags) < 0)
+		return NULL;
+
+	if (!pskb_may_pull(skb, srhoff + sizeof(*srh)))
+		return NULL;
+
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+
+	len = (srh->hdrlen + 1) << 3;
+
+	if (!pskb_may_pull(skb, srhoff + len))
+		return NULL;
+
+	/* note that pskb_may_pull may change pointers in header;
+	 * for this reason it is necessary to reload them when needed.
+	 */
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+
+	if (!seg6_validate_srh(srh, len, true))
+		return NULL;
+
+	return srh;
+}
+
 static struct genl_family seg6_genl_family;
 
 static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 2dc40b3f373ef..ef88489c71f52 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -150,40 +150,11 @@ static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
 	return (struct seg6_local_lwt *)lwt->data;
 }
 
-static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb, int flags)
-{
-	struct ipv6_sr_hdr *srh;
-	int len, srhoff = 0;
-
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, &flags) < 0)
-		return NULL;
-
-	if (!pskb_may_pull(skb, srhoff + sizeof(*srh)))
-		return NULL;
-
-	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
-
-	len = (srh->hdrlen + 1) << 3;
-
-	if (!pskb_may_pull(skb, srhoff + len))
-		return NULL;
-
-	/* note that pskb_may_pull may change pointers in header;
-	 * for this reason it is necessary to reload them when needed.
-	 */
-	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
-
-	if (!seg6_validate_srh(srh, len, true))
-		return NULL;
-
-	return srh;
-}
-
 static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_srh(skb, IP6_FH_F_SKIP_RH);
+	srh = seg6_get_srh(skb, IP6_FH_F_SKIP_RH);
 	if (!srh)
 		return NULL;
 
@@ -200,7 +171,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	struct ipv6_sr_hdr *srh;
 	unsigned int off = 0;
 
-	srh = get_srh(skb, 0);
+	srh = seg6_get_srh(skb, 0);
 	if (srh && srh->segments_left > 0)
 		return false;
 
-- 
2.34.1



