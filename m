Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A5147CA6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388119AbgAXJxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388105AbgAXJxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:53:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9B820709;
        Fri, 24 Jan 2020 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859612;
        bh=o74+76/kuCXqvaLHp6R02DYGn5GgWSF0fOA+4ads9eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgrSgjHI+LXjyJRhnOA1Ivm+9wf3qupGMT87T63pQoHg0hxzvN6siFWdB9MZqI9my
         HGjCIqzLZVGlU4Xm3kyOjFasiS1JccRTYzXKg7j/3pH9SkF+pCE4sa1LP55U0hdUmF
         uL7KOqhADOq75o3n+ByqJuvS4kEgRFt9+eH143Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/343] netfilter: nft_set_hash: fix lookups with fixed size hash on big endian
Date:   Fri, 24 Jan 2020 10:29:11 +0100
Message-Id: <20200124092937.468157628@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3b02b0adc242a72b5e46019b6a9e4f84823592f6 ]

Call jhash_1word() for the 4-bytes key case from the insertion and
deactivation path, otherwise big endian arch set lookups fail.

Fixes: 446a8268b7f5 ("netfilter: nft_set_hash: add lookup variant for fixed size hashtable")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 33aa2ac3a62ef..73f8f99b1193b 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -442,6 +442,23 @@ static bool nft_hash_lookup_fast(const struct net *net,
 	return false;
 }
 
+static u32 nft_jhash(const struct nft_set *set, const struct nft_hash *priv,
+		     const struct nft_set_ext *ext)
+{
+	const struct nft_data *key = nft_set_ext_key(ext);
+	u32 hash, k1;
+
+	if (set->klen == 4) {
+		k1 = *(u32 *)key;
+		hash = jhash_1word(k1, priv->seed);
+	} else {
+		hash = jhash(key, set->klen, priv->seed);
+	}
+	hash = reciprocal_scale(hash, priv->buckets);
+
+	return hash;
+}
+
 static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 			   const struct nft_set_elem *elem,
 			   struct nft_set_ext **ext)
@@ -451,8 +468,7 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext),
 			    nft_set_ext_key(&he->ext), set->klen) &&
@@ -491,8 +507,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
 			    set->klen) ||
-- 
2.20.1



