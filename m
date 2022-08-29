Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7255A4847
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiH2LID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiH2LHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:07:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190EE2AE1E;
        Mon, 29 Aug 2022 04:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C546119A;
        Mon, 29 Aug 2022 11:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA1BC433C1;
        Mon, 29 Aug 2022 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771110;
        bh=MKAOp5BunxQydCXDXBUZgLp0fCjA0BY5+9AvL/fr8XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7n69Y7IKeNqzZdio/NIft2JqljmvGePAeL3nwgM4+K/QVBvn7TYc6mHcuTJmA2dO
         FlNIbnreLz81ygK4dnJtw400muD5/PeXJz1JkDvGwOsqBJ4ZfhCJbTf361a+AidzZ2
         ndTHQiuvyJF0fCcyLnlqqB+AE7t7dXF/DnALw29g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/136] netfilter: nft_cmp: optimize comparison for 16-bytes
Date:   Mon, 29 Aug 2022 12:58:50 +0200
Message-Id: <20220829105807.220101479@linuxfoundation.org>
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

[ Upstream commit 23f68d462984bfda47c7bf663dca347e8e3df549 ]

Allow up to 16-byte comparisons with a new cmp fast version. Use two
64-bit words and calculate the mask representing the bits to be
compared. Make sure the comparison is 64-bit aligned and avoid
out-of-bound memory access on registers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_core.h |   9 +++
 net/netfilter/nf_tables_core.c         |  16 ++++
 net/netfilter/nft_cmp.c                | 102 ++++++++++++++++++++++++-
 3 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 0fa5a6d98a00b..9dfa11d4224d2 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -40,6 +40,14 @@ struct nft_cmp_fast_expr {
 	bool			inv;
 };
 
+struct nft_cmp16_fast_expr {
+	struct nft_data		data;
+	struct nft_data		mask;
+	u8			sreg;
+	u8			len;
+	bool			inv;
+};
+
 struct nft_immediate_expr {
 	struct nft_data		data;
 	u8			dreg;
@@ -57,6 +65,7 @@ static inline u32 nft_cmp_fast_mask(unsigned int len)
 }
 
 extern const struct nft_expr_ops nft_cmp_fast_ops;
+extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
 struct nft_payload {
 	enum nft_payload_bases	base:8;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 7defe5a92e47f..2ab4216d2a903 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,20 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_cmp16_fast_eval(const struct nft_expr *expr,
+				struct nft_regs *regs)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
+
+	if (((reg_data[0] & mask[0]) == data[0] &&
+	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
+		return;
+	regs->verdict.code = NFT_BREAK;
+}
+
 static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
@@ -215,6 +229,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
+			else if (expr->ops == &nft_cmp16_fast_ops)
+				nft_cmp16_fast_eval(expr, &regs);
 			else if (expr->ops == &nft_bitwise_fast_ops)
 				nft_bitwise_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 47b6d05f1ae69..917072af09df9 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -272,12 +272,103 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.offload	= nft_cmp_fast_offload,
 };
 
+static u32 nft_cmp_mask(u32 bitlen)
+{
+	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
+}
+
+static void nft_cmp16_fast_mask(struct nft_data *data, unsigned int bitlen)
+{
+	int len = bitlen / BITS_PER_BYTE;
+	int i, words = len / sizeof(u32);
+
+	for (i = 0; i < words; i++) {
+		data->data[i] = 0xffffffff;
+		bitlen -= sizeof(u32) * BITS_PER_BYTE;
+	}
+
+	if (len % sizeof(u32))
+		data->data[i++] = nft_cmp_mask(bitlen);
+
+	for (; i < 4; i++)
+		data->data[i] = 0;
+}
+
+static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_data_desc desc;
+	int err;
+
+	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
+			    tb[NFTA_CMP_DATA]);
+	if (err < 0)
+		return err;
+
+	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	if (err < 0)
+		return err;
+
+	nft_cmp16_fast_mask(&priv->mask, desc.len * BITS_PER_BYTE);
+	priv->inv = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
+	priv->len = desc.len;
+
+	return 0;
+}
+
+static int nft_cmp16_fast_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_cmp_expr cmp = {
+		.data	= priv->data,
+		.sreg	= priv->sreg,
+		.len	= priv->len,
+		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
+	};
+
+	return __nft_cmp_offload(ctx, flow, &cmp);
+}
+
+static int nft_cmp16_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
+
+	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
+		goto nla_put_failure;
+
+	if (nft_data_dump(skb, NFTA_CMP_DATA, &priv->data,
+			  NFT_DATA_VALUE, priv->len) < 0)
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+
+const struct nft_expr_ops nft_cmp16_fast_ops = {
+	.type		= &nft_cmp_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp16_fast_expr)),
+	.eval		= NULL,	/* inlined */
+	.init		= nft_cmp16_fast_init,
+	.dump		= nft_cmp16_fast_dump,
+	.offload	= nft_cmp16_fast_offload,
+};
+
 static const struct nft_expr_ops *
 nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
 	struct nft_data_desc desc;
 	struct nft_data data;
 	enum nft_cmp_ops op;
+	u8 sreg;
 	int err;
 
 	if (tb[NFTA_CMP_SREG] == NULL ||
@@ -306,9 +397,16 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	if (desc.type != NFT_DATA_VALUE)
 		goto err1;
 
-	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
-		return &nft_cmp_fast_ops;
+	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
 
+	if (op == NFT_CMP_EQ || op == NFT_CMP_NEQ) {
+		if (desc.len <= sizeof(u32))
+			return &nft_cmp_fast_ops;
+		else if (desc.len <= sizeof(data) &&
+			 ((sreg >= NFT_REG_1 && sreg <= NFT_REG_4) ||
+			  (sreg >= NFT_REG32_00 && sreg <= NFT_REG32_12 && sreg % 2 == 0)))
+			return &nft_cmp16_fast_ops;
+	}
 	return &nft_cmp_ops;
 err1:
 	nft_data_release(&data, desc.type);
-- 
2.35.1



