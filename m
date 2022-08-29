Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B033F5A4888
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiH2LMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiH2LLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:11:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E880211C22;
        Mon, 29 Aug 2022 04:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013DD611DA;
        Mon, 29 Aug 2022 11:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F8DC433D6;
        Mon, 29 Aug 2022 11:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771133;
        bh=wPYyykVn0ulUuxBdiSa4CoMss6WcVg6v0JcFxurrp+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl7yOJmPUSEWx6o1S9VPr9p0pBtn7ldi+RB/9StCVDBh9vAL5KBxJ1Rq2EIWjJ1KS
         GoYL/mvqibesOvT5hgvCSx38mX08n2Yx45uEJ/NOycCg1HqKqt5JGHmgdDqMswndwo
         WH/bk4dvzvjGtyYGkkeTwHUTQ+qliZOZQEqL/By8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/136] netfilter: nf_tables: upfront validation of data via nft_data_init()
Date:   Mon, 29 Aug 2022 12:58:52 +0200
Message-Id: <20220829105807.300791309@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 341b6941608762d8235f3fd1e45e4d7114ed8c2c ]

Instead of parsing the data and then validate that type and length are
correct, pass a description of the expected data so it can be validated
upfront before parsing it to bail out earlier.

This patch adds a new .size field to specify the maximum size of the
data area. The .len field is optional and it is used as an input/output
field, it provides the specific length of the expected data in the input
path. If then .len field is not specified, then obtained length from the
netlink attribute is stored. This is required by cmp, bitwise, range and
immediate, which provide no netlink attribute that describes the data
length. The immediate expression uses the destination register type to
infer the expected data type.

Relying on opencoded validation of the expected data might lead to
subtle bugs as described in 7e6bc1f6cabc ("netfilter: nf_tables:
stricter validation of element data").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  4 +-
 net/netfilter/nf_tables_api.c     | 78 ++++++++++++++++---------------
 net/netfilter/nft_bitwise.c       | 66 +++++++++++++-------------
 net/netfilter/nft_cmp.c           | 44 ++++++++---------
 net/netfilter/nft_immediate.c     | 22 +++++++--
 net/netfilter/nft_range.c         | 27 +++++------
 6 files changed, 126 insertions(+), 115 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af4d9f1049528..6a38bf8538f1e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -195,11 +195,11 @@ struct nft_ctx {
 
 struct nft_data_desc {
 	enum nft_data_types		type;
+	unsigned int			size;
 	unsigned int			len;
 };
 
-int nft_data_init(const struct nft_ctx *ctx,
-		  struct nft_data *data, unsigned int size,
+int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 		  struct nft_data_desc *desc, const struct nlattr *nla);
 void nft_data_hold(const struct nft_data *data, enum nft_data_types type);
 void nft_data_release(const struct nft_data *data, enum nft_data_types type);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4d38656d98fa..b19f4255b9018 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5120,19 +5120,13 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
 				 struct nft_data *key, struct nlattr *attr)
 {
-	struct nft_data_desc desc;
-	int err;
-
-	err = nft_data_init(ctx, key, NFT_DATA_VALUE_MAXLEN, &desc, attr);
-	if (err < 0)
-		return err;
-
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
-		nft_data_release(key, desc.type);
-		return -EINVAL;
-	}
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= NFT_DATA_VALUE_MAXLEN,
+		.len	= set->klen,
+	};
 
-	return 0;
+	return nft_data_init(ctx, key, &desc, attr);
 }
 
 static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
@@ -5141,24 +5135,17 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 				  struct nlattr *attr)
 {
 	u32 dtype;
-	int err;
-
-	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
-	if (err < 0)
-		return err;
 
 	if (set->dtype == NFT_DATA_VERDICT)
 		dtype = NFT_DATA_VERDICT;
 	else
 		dtype = NFT_DATA_VALUE;
 
-	if (dtype != desc->type ||
-	    set->dlen != desc->len) {
-		nft_data_release(data, desc->type);
-		return -EINVAL;
-	}
+	desc->type = dtype;
+	desc->size = NFT_DATA_VALUE_MAXLEN;
+	desc->len = set->dlen;
 
-	return 0;
+	return nft_data_init(ctx, data, desc, attr);
 }
 
 static void *nft_setelem_catchall_get(const struct net *net,
@@ -9524,7 +9511,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	}
 
 	desc->len = sizeof(data->verdict);
-	desc->type = NFT_DATA_VERDICT;
+
 	return 0;
 }
 
@@ -9577,20 +9564,25 @@ int nft_verdict_dump(struct sk_buff *skb, int type, const struct nft_verdict *v)
 }
 
 static int nft_value_init(const struct nft_ctx *ctx,
-			  struct nft_data *data, unsigned int size,
-			  struct nft_data_desc *desc, const struct nlattr *nla)
+			  struct nft_data *data, struct nft_data_desc *desc,
+			  const struct nlattr *nla)
 {
 	unsigned int len;
 
 	len = nla_len(nla);
 	if (len == 0)
 		return -EINVAL;
-	if (len > size)
+	if (len > desc->size)
 		return -EOVERFLOW;
+	if (desc->len) {
+		if (len != desc->len)
+			return -EINVAL;
+	} else {
+		desc->len = len;
+	}
 
 	nla_memcpy(data->data, nla, len);
-	desc->type = NFT_DATA_VALUE;
-	desc->len  = len;
+
 	return 0;
 }
 
@@ -9610,7 +9602,6 @@ static const struct nla_policy nft_data_policy[NFTA_DATA_MAX + 1] = {
  *
  *	@ctx: context of the expression using the data
  *	@data: destination struct nft_data
- *	@size: maximum data length
  *	@desc: data description
  *	@nla: netlink attribute containing data
  *
@@ -9620,24 +9611,35 @@ static const struct nla_policy nft_data_policy[NFTA_DATA_MAX + 1] = {
  *	The caller can indicate that it only wants to accept data of type
  *	NFT_DATA_VALUE by passing NULL for the ctx argument.
  */
-int nft_data_init(const struct nft_ctx *ctx,
-		  struct nft_data *data, unsigned int size,
+int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 		  struct nft_data_desc *desc, const struct nlattr *nla)
 {
 	struct nlattr *tb[NFTA_DATA_MAX + 1];
 	int err;
 
+	if (WARN_ON_ONCE(!desc->size))
+		return -EINVAL;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_DATA_MAX, nla,
 					  nft_data_policy, NULL);
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_DATA_VALUE])
-		return nft_value_init(ctx, data, size, desc,
-				      tb[NFTA_DATA_VALUE]);
-	if (tb[NFTA_DATA_VERDICT] && ctx != NULL)
-		return nft_verdict_init(ctx, data, desc, tb[NFTA_DATA_VERDICT]);
-	return -EINVAL;
+	if (tb[NFTA_DATA_VALUE]) {
+		if (desc->type != NFT_DATA_VALUE)
+			return -EINVAL;
+
+		err = nft_value_init(ctx, data, desc, tb[NFTA_DATA_VALUE]);
+	} else if (tb[NFTA_DATA_VERDICT] && ctx != NULL) {
+		if (desc->type != NFT_DATA_VERDICT)
+			return -EINVAL;
+
+		err = nft_verdict_init(ctx, data, desc, tb[NFTA_DATA_VERDICT]);
+	} else {
+		err = -EINVAL;
+	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(nft_data_init);
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d0c648b64cd40..d6ab7aa14adc2 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -93,7 +93,16 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 				 const struct nlattr *const tb[])
 {
-	struct nft_data_desc mask, xor;
+	struct nft_data_desc mask = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->mask),
+		.len	= priv->len,
+	};
+	struct nft_data_desc xor = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->xor),
+		.len	= priv->len,
+	};
 	int err;
 
 	if (tb[NFTA_BITWISE_DATA])
@@ -103,37 +112,30 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &mask,
-			    tb[NFTA_BITWISE_MASK]);
+	err = nft_data_init(NULL, &priv->mask, &mask, tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
-		err = -EINVAL;
-		goto err_mask_release;
-	}
 
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
-			    tb[NFTA_BITWISE_XOR]);
+	err = nft_data_init(NULL, &priv->xor, &xor, tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		goto err_mask_release;
-	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
-		err = -EINVAL;
-		goto err_xor_release;
-	}
+		goto err_xor_err;
 
 	return 0;
 
-err_xor_release:
-	nft_data_release(&priv->xor, xor.type);
-err_mask_release:
+err_xor_err:
 	nft_data_release(&priv->mask, mask.type);
+
 	return err;
 }
 
 static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 				  const struct nlattr *const tb[])
 {
-	struct nft_data_desc d;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+		.len	= sizeof(u32),
+	};
 	int err;
 
 	if (tb[NFTA_BITWISE_MASK] ||
@@ -143,13 +145,12 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	if (!tb[NFTA_BITWISE_DATA])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &d,
-			    tb[NFTA_BITWISE_DATA]);
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_BITWISE_DATA]);
 	if (err < 0)
 		return err;
-	if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
-	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
-		nft_data_release(&priv->data, d.type);
+
+	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}
 
@@ -291,22 +292,21 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 static int
 nft_bitwise_extract_u32_data(const struct nlattr * const tb, u32 *out)
 {
-	struct nft_data_desc desc;
 	struct nft_data data;
-	int err = 0;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+		.len	= sizeof(u32),
+	};
+	int err;
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc, tb);
+	err = nft_data_init(NULL, &data, &desc, tb);
 	if (err < 0)
 		return err;
 
-	if (desc.type != NFT_DATA_VALUE || desc.len != sizeof(u32)) {
-		err = -EINVAL;
-		goto err;
-	}
 	*out = data.data[0];
-err:
-	nft_data_release(&data, desc.type);
-	return err;
+
+	return 0;
 }
 
 static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 917072af09df9..461763a571f20 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -73,20 +73,16 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			const struct nlattr * const tb[])
 {
 	struct nft_cmp_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+	};
 	int err;
 
-	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
 
-	if (desc.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		nft_data_release(&priv->data, desc.type);
-		return err;
-	}
-
 	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
@@ -201,12 +197,14 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 			     const struct nlattr * const tb[])
 {
 	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
 	struct nft_data data;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+	};
 	int err;
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
 
@@ -299,11 +297,13 @@ static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
 			       const struct nlattr * const tb[])
 {
 	struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data),
+	};
 	int err;
 
-	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &priv->data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
 
@@ -365,8 +365,11 @@ const struct nft_expr_ops nft_cmp16_fast_ops = {
 static const struct nft_expr_ops *
 nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
-	struct nft_data_desc desc;
 	struct nft_data data;
+	struct nft_data_desc desc = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(data),
+	};
 	enum nft_cmp_ops op;
 	u8 sreg;
 	int err;
@@ -389,14 +392,10 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 		return ERR_PTR(-EINVAL);
 	}
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc,
-			    tb[NFTA_CMP_DATA]);
+	err = nft_data_init(NULL, &data, &desc, tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (desc.type != NFT_DATA_VALUE)
-		goto err1;
-
 	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
 
 	if (op == NFT_CMP_EQ || op == NFT_CMP_NEQ) {
@@ -408,9 +407,6 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 			return &nft_cmp16_fast_ops;
 	}
 	return &nft_cmp_ops;
-err1:
-	nft_data_release(&data, desc.type);
-	return ERR_PTR(-EINVAL);
 }
 
 struct nft_expr_type nft_cmp_type __read_mostly = {
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index d0f67d325bdfd..fcdbc5ed3f367 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -29,20 +29,36 @@ static const struct nla_policy nft_immediate_policy[NFTA_IMMEDIATE_MAX + 1] = {
 	[NFTA_IMMEDIATE_DATA]	= { .type = NLA_NESTED },
 };
 
+static enum nft_data_types nft_reg_to_type(const struct nlattr *nla)
+{
+	enum nft_data_types type;
+	u8 reg;
+
+	reg = ntohl(nla_get_be32(nla));
+	if (reg == NFT_REG_VERDICT)
+		type = NFT_DATA_VERDICT;
+	else
+		type = NFT_DATA_VALUE;
+
+	return type;
+}
+
 static int nft_immediate_init(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr,
 			      const struct nlattr * const tb[])
 {
 	struct nft_immediate_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc;
+	struct nft_data_desc desc = {
+		.size	= sizeof(priv->data),
+	};
 	int err;
 
 	if (tb[NFTA_IMMEDIATE_DREG] == NULL ||
 	    tb[NFTA_IMMEDIATE_DATA] == NULL)
 		return -EINVAL;
 
-	err = nft_data_init(ctx, &priv->data, sizeof(priv->data), &desc,
-			    tb[NFTA_IMMEDIATE_DATA]);
+	desc.type = nft_reg_to_type(tb[NFTA_IMMEDIATE_DREG]);
+	err = nft_data_init(ctx, &priv->data, &desc, tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index e4a1c44d7f513..e6bbe32c323df 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -51,7 +51,14 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 			const struct nlattr * const tb[])
 {
 	struct nft_range_expr *priv = nft_expr_priv(expr);
-	struct nft_data_desc desc_from, desc_to;
+	struct nft_data_desc desc_from = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data_from),
+	};
+	struct nft_data_desc desc_to = {
+		.type	= NFT_DATA_VALUE,
+		.size	= sizeof(priv->data_to),
+	};
 	int err;
 	u32 op;
 
@@ -61,26 +68,16 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	    !tb[NFTA_RANGE_TO_DATA])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->data_from, sizeof(priv->data_from),
-			    &desc_from, tb[NFTA_RANGE_FROM_DATA]);
+	err = nft_data_init(NULL, &priv->data_from, &desc_from,
+			    tb[NFTA_RANGE_FROM_DATA]);
 	if (err < 0)
 		return err;
 
-	if (desc_from.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		goto err1;
-	}
-
-	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
-			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
+	err = nft_data_init(NULL, &priv->data_to, &desc_to,
+			    tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
 		goto err1;
 
-	if (desc_to.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
-		goto err2;
-	}
-
 	if (desc_from.len != desc_to.len) {
 		err = -EINVAL;
 		goto err2;
-- 
2.35.1



