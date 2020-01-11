Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F47137FCF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgAKKXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbgAKKXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18397205F4;
        Sat, 11 Jan 2020 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738195;
        bh=gFZNpGJApJIvKCCoZj4wHFDnvyaGOvkhUJkx1IjrRt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GC6vJ4JEPynUm9iZNBOw49ZamN8TN5p3QLxS/rS7TcqvZ4hzxJCyH6x991WGE9yDd
         3lNl6IMtCidx5g7ld1xLY2JgD3X5M2M0dgSP+FoQ94omk27HFQgnC8Tv6ZhhNShgYb
         Rs9unTD7Y9q8ktg5IZhQq5BV6LB87rQ//wF/3wRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/165] netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
Date:   Sat, 11 Jan 2020 10:49:09 +0100
Message-Id: <20200111094923.222578226@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d2c96af797ba149e559c5875c0151384ab6dd14 ]

Userspace might bogusly sent NFT_DATA_VERDICT in several netlink
attributes that assume NFT_DATA_VALUE. Moreover, make sure that error
path invokes nft_data_release() to decrement the reference count on the
chain object.

Fixes: 96518518cc41 ("netfilter: add nftables")
Fixes: 0f3cd9b36977 ("netfilter: nf_tables: add range expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c |  4 +++-
 net/netfilter/nft_bitwise.c   |  4 ++--
 net/netfilter/nft_cmp.c       |  6 ++++++
 net/netfilter/nft_range.c     | 10 ++++++++++
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7120eba71ac5..4c03c14e46bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4252,8 +4252,10 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = -EINVAL;
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
+		nft_data_release(&elem.key.val, desc.type);
 		return err;
+	}
 
 	priv = set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 02afa752dd2e..10e9d50e4e19 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -80,7 +80,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len != priv->len) {
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
@@ -89,7 +89,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.len != priv->len) {
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 0744b2bb46da..ae730dba60c8 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -80,6 +80,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
+	if (desc.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		nft_data_release(&priv->data, desc.type);
+		return err;
+	}
+
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
 	if (err < 0)
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 4701fa8a45e7..89efcc5a533d 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -66,11 +66,21 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	if (err < 0)
 		return err;
 
+	if (desc_from.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err1;
+	}
+
 	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
 			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
 		goto err1;
 
+	if (desc_to.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err2;
+	}
+
 	if (desc_from.len != desc_to.len) {
 		err = -EINVAL;
 		goto err2;
-- 
2.20.1



