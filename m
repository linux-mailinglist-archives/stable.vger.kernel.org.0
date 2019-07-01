Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA74D78A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfFTSOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbfFTSOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10D1205F4;
        Thu, 20 Jun 2019 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054473;
        bh=/rhL/A3PQgdjwJ8R6PBU+305++TRCOKguxekVG+24rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkiuRMkYJVvEAMr3bx9yM0sWLE3obffa0FyCn0oLkXF1XyO79AeBTA1ejh0ZTf0+R
         YQK8u+JDQ+xg2qaP30zT7sExdfFringFbD/flgWAsitiPcE8K2mh8wsYrgDJBa7JT4
         xKJAjNAaOFHeGgGm9a50cIzLm/veWeKDHFioh9nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 40/98] netfilter: nft_fib: Fix existence check support
Date:   Thu, 20 Jun 2019 19:57:07 +0200
Message-Id: <20190620174350.919140859@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e633508a95289489d28faacb68b32c3e7e68ef6f ]

NFTA_FIB_F_PRESENT flag was not always honored since eval functions did
not call nft_fib_store_result in all cases.

Given that in all callsites there is a struct net_device pointer
available which holds the interface data to be stored in destination
register, simplify nft_fib_store_result() to just accept that pointer
instead of the nft_pktinfo pointer and interface index. This also
allows to drop the index to interface lookup previously needed to get
the name associated with given index.

Fixes: 055c4b34b94f6 ("netfilter: nft_fib: Support existence check")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nft_fib.h   |  2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c | 23 +++--------------------
 net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++--------------
 net/netfilter/nft_fib.c           |  6 +++---
 4 files changed, 9 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index a88f92737308..e4c4d8eaca8c 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -34,5 +34,5 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index);
+			  const struct net_device *dev);
 #endif
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 94eb25bc8d7e..c8888e52591f 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -58,11 +58,6 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
-static int get_ifindex(const struct net_device *dev)
-{
-	return dev ? dev->ifindex : 0;
-}
-
 void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -94,8 +89,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -108,8 +102,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (ipv4_is_zeronet(iph->saddr)) {
 		if (ipv4_is_lbcast(iph->daddr) ||
 		    ipv4_is_local_multicast(iph->daddr)) {
-			nft_fib_store_result(dest, priv, pkt,
-					     get_ifindex(pkt->skb->dev));
+			nft_fib_store_result(dest, priv, pkt->skb->dev);
 			return;
 		}
 	}
@@ -150,17 +143,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		found = oif;
 	}
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = found->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, found->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	nft_fib_store_result(dest, priv, found);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval);
 
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 73cdc0bc63f7..ec068b0cffca 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -169,8 +169,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -187,18 +186,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (oif && oif != rt->rt6i_idev->dev)
 		goto put_rt_err;
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = rt->rt6i_idev->dev->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, rt->rt6i_idev->dev->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
+	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
  put_rt_err:
 	ip6_rt_put(rt);
 }
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 21df8cccea65..77f00a99dfab 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -135,17 +135,17 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr)
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index)
+			  const struct net_device *dev)
 {
-	struct net_device *dev;
 	u32 *dreg = reg;
+	int index;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
+		index = dev ? dev->ifindex : 0;
 		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
-		dev = dev_get_by_index_rcu(nft_net(pkt), index);
 		if (priv->flags & NFTA_FIB_F_PRESENT)
 			*dreg = !!dev;
 		else
-- 
2.20.1



