Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89B03AEE37
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhFUQ0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhFUQZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C2F613BE;
        Mon, 21 Jun 2021 16:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292497;
        bh=KKHN1tZqk9vOiF5zfiekK61Ol5daYmg0Vt7OKUL8Xxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbiMiQ+w5Ki/xOD7wGUaGwvStipUSW8hTGU/V61wOqVe5pABwQtkSIyCdk+xXM3x3
         ySWVpEYkINokmu/39jw2dbNQ7idZq42P4OlJEhTftVMd5mrvCZlTMh9+jJUt+JEihP
         14p0OmlX9HN1ebgs/6JDlchSf40aIAU2iTozfQbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/146] netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local
Date:   Mon, 21 Jun 2021 18:14:12 +0200
Message-Id: <20210621154912.027676066@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 12f36e9bf678a81d030ca1b693dcda62b55af7c5 ]

The ip6tables rpfilter match has an extra check to skip packets with
"::" source address.

Extend this to ipv6 fib expression.  Else ipv6 duplicate address detection
packets will fail rpf route check -- lookup returns -ENETUNREACH.

While at it, extend the prerouting check to also cover the ingress hook.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1543
Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index e204163c7036..92f3235fa287 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -135,6 +135,17 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 }
 EXPORT_SYMBOL_GPL(nft_fib6_eval_type);
 
+static bool nft_fib_v6_skip_icmpv6(const struct sk_buff *skb, u8 next, const struct ipv6hdr *iph)
+{
+	if (likely(next != IPPROTO_ICMPV6))
+		return false;
+
+	if (ipv6_addr_type(&iph->saddr) != IPV6_ADDR_ANY)
+		return false;
+
+	return ipv6_addr_type(&iph->daddr) & IPV6_ADDR_LINKLOCAL;
+}
+
 void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -163,10 +174,13 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
-	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, nft_in(pkt));
-		return;
+	if (nft_hook(pkt) == NF_INET_PRE_ROUTING ||
+	    nft_hook(pkt) == NF_INET_INGRESS) {
+		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
+		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
+			nft_fib_store_result(dest, priv, nft_in(pkt));
+			return;
+		}
 	}
 
 	*dest = 0;
-- 
2.30.2



