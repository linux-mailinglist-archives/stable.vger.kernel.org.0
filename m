Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5B106EFC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKVKyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbfKVKyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488BB2073B;
        Fri, 22 Nov 2019 10:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420091;
        bh=Xly+WwSRVQd4TwyrC8/aeq8ryWsEK+3hHMKmq1lem7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWRDvATT/aFIvEhUCVcbuYBqxTIKzggQFbdhxTHAY8l9TiyCEnqBZ0pwPPkZXEUxN
         4s8twNDC2qj9wHKfvSIfoxXTvktqbWERSNIvto+moVgxvx8MpgZOuH4MUM9OWhtg0r
         i9sFa9dTAt1E+TPv63OoxZcJeQ092M4syOs3VOE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/122] netfilter: nft_compat: do not dump private area
Date:   Fri, 22 Nov 2019 11:29:25 +0100
Message-Id: <20191122100834.767315450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d701d8117200399d85e63a737d2e4e897932f3b6 ]

Zero pad private area, otherwise we expose private kernel pointer to
userspace. This patch also zeroes the tail area after the ->matchsize
and ->targetsize that results from XT_ALIGN().

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7344ec7fff2a7..8281656808aee 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -291,6 +291,24 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 		module_put(me);
 }
 
+static int nft_extension_dump_info(struct sk_buff *skb, int attr,
+				   const void *info,
+				   unsigned int size, unsigned int user_size)
+{
+	unsigned int info_size, aligned_size = XT_ALIGN(size);
+	struct nlattr *nla;
+
+	nla = nla_reserve(skb, attr, aligned_size);
+	if (!nla)
+		return -1;
+
+	info_size = user_size ? : size;
+	memcpy(nla_data(nla), info, info_size);
+	memset(nla_data(nla) + info_size, 0, aligned_size - info_size);
+
+	return 0;
+}
+
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct xt_target *target = expr->ops->data;
@@ -298,7 +316,8 @@ static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_string(skb, NFTA_TARGET_NAME, target->name) ||
 	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(target->revision)) ||
-	    nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(target->targetsize), info))
+	    nft_extension_dump_info(skb, NFTA_TARGET_INFO, info,
+				    target->targetsize, target->usersize))
 		goto nla_put_failure;
 
 	return 0;
@@ -534,7 +553,8 @@ static int __nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr,
 
 	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
 	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(match->revision)) ||
-	    nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(match->matchsize), info))
+	    nft_extension_dump_info(skb, NFTA_MATCH_INFO, info,
+				    match->matchsize, match->usersize))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.20.1



