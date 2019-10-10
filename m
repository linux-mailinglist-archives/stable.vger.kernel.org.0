Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753A6D248B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389381AbfJJIqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389380AbfJJIqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11720208C3;
        Thu, 10 Oct 2019 08:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697209;
        bh=+uCVdUA5lVCZ9a/ht/Z8yKNn/Mvm0QLIKe/8pzuMvFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6mOF9XoYvTRg3kWwEPgfAnMyX7+DuaLsM3/LuWpwExnSF9rKYWQlPf4fj613Q5t+
         ya3ES5DMz3WWRkEpwfDEdmHSyHyOv09ESpoB7MC67ka0EbfLxS9+sXGUVGDaBJZIwf
         e4BqC+gV0WZ6jhWZ+D4bRcSpQfz8LSnlQ7635xL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/114] netfilter: nf_tables: allow lookups in dynamic sets
Date:   Thu, 10 Oct 2019 10:36:05 +0200
Message-Id: <20191010083609.118048283@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit acab713177377d9e0889c46bac7ff0cfb9a90c4d ]

This un-breaks lookups in sets that have the 'dynamic' flag set.
Given this active example configuration:

table filter {
  set set1 {
    type ipv4_addr
    size 64
    flags dynamic,timeout
    timeout 1m
  }

  chain input {
     type filter hook input priority 0; policy accept;
  }
}

... this works:
nft add rule ip filter input add @set1 { ip saddr }

-> whenever rule is triggered, the source ip address is inserted
into the set (if it did not exist).

This won't work:
nft add rule ip filter input ip saddr @set1 counter
Error: Could not process rule: Operation not supported

In other words, we can add entries to the set, but then can't make
matching decision based on that set.

That is just wrong -- all set backends support lookups (else they would
not be very useful).
The failure comes from an explicit rejection in nft_lookup.c.

Looking at the history, it seems like NFT_SET_EVAL used to mean
'set contains expressions' (aka. "is a meter"), for instance something like

 nft add rule ip filter input meter example { ip saddr limit rate 10/second }
 or
 nft add rule ip filter input meter example { ip saddr counter }

The actual meaning of NFT_SET_EVAL however, is
'set can be updated from the packet path'.

'meters' and packet-path insertions into sets, such as
'add @set { ip saddr }' use exactly the same kernel code (nft_dynset.c)
and thus require a set backend that provides the ->update() function.

The only set that provides this also is the only one that has the
NFT_SET_EVAL feature flag.

Removing the wrong check makes the above example work.
While at it, also fix the flag check during set instantiation to
allow supported combinations only.

Fixes: 8aeff920dcc9b3f ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 net/netfilter/nft_lookup.c    | 3 ---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2145581d7b3dc..24fddf0322790 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3429,8 +3429,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_OBJECT))
 			return -EINVAL;
 		/* Only one of these operations is supported */
-		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
-			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
+		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
+			     (NFT_SET_MAP | NFT_SET_OBJECT))
+			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
+			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 161c3451a747a..55754d9939b50 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -76,9 +76,6 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (set->flags & NFT_SET_EVAL)
-		return -EOPNOTSUPP;
-
 	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
 	err = nft_validate_register_load(priv->sreg, set->klen);
 	if (err < 0)
-- 
2.20.1



