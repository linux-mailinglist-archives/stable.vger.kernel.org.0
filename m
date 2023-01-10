Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EFF664837
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbjAJSKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbjAJSJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F555872BB
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A606186D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8986AC433EF;
        Tue, 10 Jan 2023 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374022;
        bh=JSgkANJxzASJbUj139uJBCUAOxtMoo63WDT6nxqILbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfdevSYMdR+xFr6zuLN9SNJyqGF7lHUYhrZZOM0Lit/kf4CjYma7vNE/Z92clxpjl
         E7dWgxtpepTGo1TdSmZ0RGMxrcCPa4aED2NXjKPth9mu0tsCVRbmjcOAzRqoWBndqU
         RRLm4ESWh8QhDFtEzIiPekxtl7sa6RR9QEVasGQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 016/148] netfilter: nf_tables: consolidate set description
Date:   Tue, 10 Jan 2023 19:02:00 +0100
Message-Id: <20230110180017.705890365@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit bed4a63ea4ae77cfe5aae004ef87379f0655260a ]

Add the following fields to the set description:

- key type
- data type
- object type
- policy
- gc_int: garbage collection interval)
- timeout: element timeout

This prepares for stricter set type checks on updates in a follow up
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: f6594c372afd ("netfilter: nf_tables: perform type checking for existing sets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 12 +++++++
 net/netfilter/nf_tables_api.c     | 58 +++++++++++++++----------------
 2 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e25..ddcdde230747 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -311,17 +311,29 @@ struct nft_set_iter {
 /**
  *	struct nft_set_desc - description of set elements
  *
+ *	@ktype: key type
  *	@klen: key length
+ *	@dtype: data type
  *	@dlen: data length
+ *	@objtype: object type
+ *	@flags: flags
  *	@size: number of set elements
+ *	@policy: set policy
+ *	@gc_int: garbage collector interval
  *	@field_len: length of each field in concatenation, bytes
  *	@field_count: number of concatenated fields in element
  *	@expr: set must support for expressions
  */
 struct nft_set_desc {
+	u32			ktype;
 	unsigned int		klen;
+	u32			dtype;
 	unsigned int		dlen;
+	u32			objtype;
 	unsigned int		size;
+	u32			policy;
+	u32			gc_int;
+	u64			timeout;
 	u8			field_len[NFT_REG32_COUNT];
 	u8			field_count;
 	bool			expr;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7977f0422ecf..eb6a2e09ec7b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3732,8 +3732,7 @@ static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 flags)
 static const struct nft_set_ops *
 nft_select_set_ops(const struct nft_ctx *ctx,
 		   const struct nlattr * const nla[],
-		   const struct nft_set_desc *desc,
-		   enum nft_set_policies policy)
+		   const struct nft_set_desc *desc)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nft_set_ops *ops, *bops;
@@ -3762,7 +3761,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		if (!ops->estimate(desc, flags, &est))
 			continue;
 
-		switch (policy) {
+		switch (desc->policy) {
 		case NFT_SET_POL_PERFORMANCE:
 			if (est.lookup < best.lookup)
 				break;
@@ -4344,7 +4343,6 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -4357,10 +4355,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	size_t alloc_size;
-	u64 timeout;
 	char *name;
 	int err, i;
 	u16 udlen;
+	u32 flags;
 	u64 size;
 
 	if (nla[NFTA_SET_TABLE] == NULL ||
@@ -4371,10 +4369,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 
 	memset(&desc, 0, sizeof(desc));
 
-	ktype = NFT_DATA_VALUE;
+	desc.ktype = NFT_DATA_VALUE;
 	if (nla[NFTA_SET_KEY_TYPE] != NULL) {
-		ktype = ntohl(nla_get_be32(nla[NFTA_SET_KEY_TYPE]));
-		if ((ktype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK)
+		desc.ktype = ntohl(nla_get_be32(nla[NFTA_SET_KEY_TYPE]));
+		if ((desc.ktype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK)
 			return -EINVAL;
 	}
 
@@ -4399,17 +4397,17 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 	}
 
-	dtype = 0;
+	desc.dtype = 0;
 	if (nla[NFTA_SET_DATA_TYPE] != NULL) {
 		if (!(flags & NFT_SET_MAP))
 			return -EINVAL;
 
-		dtype = ntohl(nla_get_be32(nla[NFTA_SET_DATA_TYPE]));
-		if ((dtype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK &&
-		    dtype != NFT_DATA_VERDICT)
+		desc.dtype = ntohl(nla_get_be32(nla[NFTA_SET_DATA_TYPE]));
+		if ((desc.dtype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK &&
+		    desc.dtype != NFT_DATA_VERDICT)
 			return -EINVAL;
 
-		if (dtype != NFT_DATA_VERDICT) {
+		if (desc.dtype != NFT_DATA_VERDICT) {
 			if (nla[NFTA_SET_DATA_LEN] == NULL)
 				return -EINVAL;
 			desc.dlen = ntohl(nla_get_be32(nla[NFTA_SET_DATA_LEN]));
@@ -4424,34 +4422,34 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (!(flags & NFT_SET_OBJECT))
 			return -EINVAL;
 
-		objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
-		if (objtype == NFT_OBJECT_UNSPEC ||
-		    objtype > NFT_OBJECT_MAX)
+		desc.objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
+		if (desc.objtype == NFT_OBJECT_UNSPEC ||
+		    desc.objtype > NFT_OBJECT_MAX)
 			return -EOPNOTSUPP;
 	} else if (flags & NFT_SET_OBJECT)
 		return -EINVAL;
 	else
-		objtype = NFT_OBJECT_UNSPEC;
+		desc.objtype = NFT_OBJECT_UNSPEC;
 
-	timeout = 0;
+	desc.timeout = 0;
 	if (nla[NFTA_SET_TIMEOUT] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
-		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
 		if (err)
 			return err;
 	}
-	gc_int = 0;
+	desc.gc_int = 0;
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
+		desc.gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 
-	policy = NFT_SET_POL_PERFORMANCE;
+	desc.policy = NFT_SET_POL_PERFORMANCE;
 	if (nla[NFTA_SET_POLICY] != NULL)
-		policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		desc.policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
 
 	if (nla[NFTA_SET_DESC] != NULL) {
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
@@ -4496,7 +4494,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -ENOENT;
 
-	ops = nft_select_set_ops(&ctx, nla, &desc, policy);
+	ops = nft_select_set_ops(&ctx, nla, &desc);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
@@ -4536,18 +4534,18 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	set->table = table;
 	write_pnet(&set->net, net);
 	set->ops = ops;
-	set->ktype = ktype;
+	set->ktype = desc.ktype;
 	set->klen = desc.klen;
-	set->dtype = dtype;
-	set->objtype = objtype;
+	set->dtype = desc.dtype;
+	set->objtype = desc.objtype;
 	set->dlen = desc.dlen;
 	set->flags = flags;
 	set->size = desc.size;
-	set->policy = policy;
+	set->policy = desc.policy;
 	set->udlen = udlen;
 	set->udata = udata;
-	set->timeout = timeout;
-	set->gc_int = gc_int;
+	set->timeout = desc.timeout;
+	set->gc_int = desc.gc_int;
 
 	set->field_count = desc.field_count;
 	for (i = 0; i < desc.field_count; i++)
-- 
2.35.1



