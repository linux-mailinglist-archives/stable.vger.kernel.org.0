Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0D406BDA
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhIJMfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233737AbhIJMeV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2C7611EF;
        Fri, 10 Sep 2021 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277190;
        bh=Bkk1cmLGO+RFsmedEvWb0IG08er6IeUWhxQfQo5c388=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqOjWMrO5TMYvgbZG9N5O/V25TpKtTCrVoXbJLiIZN79M8BtRqdAmIL6eL+8rnScb
         zYDSfY0XjtNp9H8hvWSFK06dw/jm7UGCUDf0JaY/FZ/uTJ/1q5WpBVNUkAl4sRLLhQ
         YRjCMttCOtPyguhyjzrS6HwXjswZWQNIqK/YVb1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 13/26] netfilter: nftables: avoid potential overflows on 32bit arches
Date:   Fri, 10 Sep 2021 14:30:17 +0200
Message-Id: <20210910122916.682588706@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++--
 net/netfilter/nft_set_hash.c  |   10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4115,6 +4115,7 @@ static int nf_tables_newset(struct net *
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
+	size_t alloc_size;
 	char *name;
 	u64 size;
 	u64 timeout;
@@ -4263,8 +4264,10 @@ static int nf_tables_newset(struct net *
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
 
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -604,7 +604,7 @@ static u64 nft_hash_privsize(const struc
 			     const struct nft_set_desc *desc)
 {
 	return sizeof(struct nft_hash) +
-	       nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
+	       (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
 }
 
 static int nft_hash_init(const struct nft_set *set,
@@ -644,8 +644,8 @@ static bool nft_hash_estimate(const stru
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 
@@ -662,8 +662,8 @@ static bool nft_hash_fast_estimate(const
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 


