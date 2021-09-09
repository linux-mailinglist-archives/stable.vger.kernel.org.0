Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B3405944
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 16:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbhIIOlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 10:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbhIIOl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 10:41:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3EFC06641C;
        Thu,  9 Sep 2021 07:03:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mOKee-0003xp-80; Thu, 09 Sep 2021 16:03:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10.y 1/3] netfilter: nftables: avoid potential overflows on 32bit arches
Date:   Thu,  9 Sep 2021 16:03:35 +0200
Message-Id: <20210909140337.29707-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210909140337.29707-1-fw@strlen.de>
References: <20210909140337.29707-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6c8774a94e6ad26f29ef103c8671f55c255c6201 upstream.

User space could ask for very large hash tables, we need to make sure
our size computations wont overflow.

nf_tables_newset() needs to double check the u64 size
will fit into size_t field.

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c |  7 +++++--
 net/netfilter/nft_set_hash.c  | 10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e34d05cc5754..947d52cff582 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4115,6 +4115,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
+	size_t alloc_size;
 	char *name;
 	u64 size;
 	u64 timeout;
@@ -4263,8 +4264,10 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	size = 0;
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
-
-	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
+	alloc_size = sizeof(*set) + size + udlen;
+	if (alloc_size < size)
+		return -ENOMEM;
+	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index d7083bcb20e8..858c8d4d659a 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -604,7 +604,7 @@ static u64 nft_hash_privsize(const struct nlattr * const nla[],
 			     const struct nft_set_desc *desc)
 {
 	return sizeof(struct nft_hash) +
-	       nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
+	       (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
 }
 
 static int nft_hash_init(const struct nft_set *set,
@@ -644,8 +644,8 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 
@@ -662,8 +662,8 @@ static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 
-- 
2.32.0

