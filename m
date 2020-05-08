Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F491CAF5A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgEHNRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgEHMoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 973BF206B8;
        Fri,  8 May 2020 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941855;
        bh=TvfbYBTLe48ezPCa92LcT/+8D3hZGY64cqarCQCTxXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgyhs0BQUhlpesc1EM5pZ+kFF1glK8/XWDo6J5McBsFdD7zss8PpXVCCJ49ckVDfC
         zVt2cVg4hqvIlv105hiXSxMHzWS5o5Q35oSdS7llpOUQJktGLS59KJEqzR0tTXDug5
         UIKpk2vCp3FS6Ve3hvj+M1gApoi+YNBSco32+D5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 200/312] netfilter: nft_dup: do not use sreg_dev if the user doesnt specify it
Date:   Fri,  8 May 2020 14:33:11 +0200
Message-Id: <20200508123138.502362323@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

commit b73b8a1ba598236296a46103d81c10d629d9a470 upstream.

The NFTA_DUP_SREG_DEV attribute is not a must option, so we should use it
in routing lookup only when the user specify it.

Fixes: d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/nft_dup_ipv4.c |    6 ++++--
 net/ipv6/netfilter/nft_dup_ipv6.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -28,7 +28,7 @@ static void nft_dup_ipv4_eval(const stru
 	struct in_addr gw = {
 		.s_addr = (__force __be32)regs->data[priv->sreg_addr],
 	};
-	int oif = regs->data[priv->sreg_dev];
+	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
 
 	nf_dup_ipv4(pkt->net, pkt->skb, pkt->hook, &gw, oif);
 }
@@ -59,7 +59,9 @@ static int nft_dup_ipv4_dump(struct sk_b
 {
 	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
 
-	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr) ||
+	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr))
+		goto nla_put_failure;
+	if (priv->sreg_dev &&
 	    nft_dump_register(skb, NFTA_DUP_SREG_DEV, priv->sreg_dev))
 		goto nla_put_failure;
 
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -26,7 +26,7 @@ static void nft_dup_ipv6_eval(const stru
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 	struct in6_addr *gw = (struct in6_addr *)&regs->data[priv->sreg_addr];
-	int oif = regs->data[priv->sreg_dev];
+	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
 
 	nf_dup_ipv6(pkt->net, pkt->skb, pkt->hook, gw, oif);
 }
@@ -57,7 +57,9 @@ static int nft_dup_ipv6_dump(struct sk_b
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 
-	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr) ||
+	if (nft_dump_register(skb, NFTA_DUP_SREG_ADDR, priv->sreg_addr))
+		goto nla_put_failure;
+	if (priv->sreg_dev &&
 	    nft_dump_register(skb, NFTA_DUP_SREG_DEV, priv->sreg_dev))
 		goto nla_put_failure;
 


