Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB132E64D9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbgL1Nhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389228AbgL1Nhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76F4207C9;
        Mon, 28 Dec 2020 13:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162646;
        bh=/3jwjIpS0vPT2AQx6sX1YnnOVuHbzpxIfb33fskAcGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Peccd8IkQbIcwrXOIGV4Did1laNybOJwWW34C3iZNa/hjKfOu/c2FMiXdpglGrS87
         fagRlvHYkpt8CTIXc3eKqRgvza+ZUFERL7dpyuKS6i3QHKOMzvXhmm0ZELzFR0WLBH
         sufH5+zjafvAq6XexaGA4RJg7txd2dIx0nqxcCM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/453] netfilter: nft_dynset: fix timeouts later than 23 days
Date:   Mon, 28 Dec 2020 13:44:20 +0100
Message-Id: <20201228124938.421091692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 917d80d376ffbaa9725fde9e3c0282f63643f278 ]

Use nf_msecs_to_jiffies64 and nf_jiffies64_to_msecs as provided by
8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23
days"), otherwise ruleset listing breaks.

Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 4 ++++
 net/netfilter/nf_tables_api.c     | 4 ++--
 net/netfilter/nft_dynset.c        | 8 +++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6a6fcd10d3185..f694f08ad635b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1464,4 +1464,8 @@ void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
 
 void nf_tables_trans_destroy_flush_work(void);
+
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
+__be64 nf_jiffies64_to_msecs(u64 input);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7753d6f1467c9..40216c2a7dd72 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3277,7 +3277,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 {
 	u64 ms = be64_to_cpu(nla_get_be64(nla));
 	u64 max = (u64)(~((u64)0));
@@ -3291,7 +3291,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 	return 0;
 }
 
-static __be64 nf_jiffies64_to_msecs(u64 input)
+__be64 nf_jiffies64_to_msecs(u64 input)
 {
 	return cpu_to_be64(jiffies64_to_msecs(input));
 }
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 8887295414dcb..217fd1bdc55e7 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -180,8 +180,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						tb[NFTA_DYNSET_TIMEOUT])));
+
+		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
+		if (err)
+			return err;
 	}
 
 	priv->sreg_key = nft_parse_register(tb[NFTA_DYNSET_SREG_KEY]);
@@ -296,7 +298,7 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_string(skb, NFTA_DYNSET_SET_NAME, priv->set->name))
 		goto nla_put_failure;
 	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
+			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
-- 
2.27.0



