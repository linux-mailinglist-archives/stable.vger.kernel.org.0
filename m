Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E137C5F6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhELPoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhELPlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA10B6157F;
        Wed, 12 May 2021 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832890;
        bh=qdPPJ/JuIsoB/i4uKbZzoghLW9byITxSWLAp6REjdTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G214uGFLKdzx4FqPZizKqZI4Sa1s8rYGLKBeaRepWo3S95A/W1us33nWc2UpvnklA
         SrTQSUQBR2VEl2Jz5Nfa7p1ShhOsMS0LECM15YKyHU24ZZtn12EqxCnc+NYR0aZm8y
         VAZ5sf+uMvYCYAH9Ku8BdHciBmFY6o22fXNsWPWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 464/530] netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector
Date:   Wed, 12 May 2021 16:49:34 +0200
Message-Id: <20210512144835.019640540@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ff4d90a89d3d4d9814e0a2696509a7d495be4163 ]

The flow dissector representation expects the VLAN id in host byteorder.
Add the NFT_OFFLOAD_F_NETWORK2HOST flag to swap the bytes from nft_cmp.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_offload.h | 11 +++++-
 net/netfilter/nft_cmp.c                   | 41 +++++++++++++++++++++--
 net/netfilter/nft_payload.c               | 10 +++---
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index b4d080061399..434a6158852f 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -4,11 +4,16 @@
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_tables.h>
 
+enum nft_offload_reg_flags {
+	NFT_OFFLOAD_F_NETWORK2HOST	= (1 << 0),
+};
+
 struct nft_offload_reg {
 	u32		key;
 	u32		len;
 	u32		base_offset;
 	u32		offset;
+	u32		flags;
 	struct nft_data data;
 	struct nft_data	mask;
 };
@@ -72,13 +77,17 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rul
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
 
-#define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
+#define NFT_OFFLOAD_MATCH_FLAGS(__key, __base, __field, __len, __reg, __flags)	\
 	(__reg)->base_offset	=					\
 		offsetof(struct nft_flow_key, __base);			\
 	(__reg)->offset		=					\
 		offsetof(struct nft_flow_key, __base.__field);		\
 	(__reg)->len		= __len;				\
 	(__reg)->key		= __key;				\
+	(__reg)->flags		= __flags;
+
+#define NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
+	NFT_OFFLOAD_MATCH_FLAGS(__key, __base, __field, __len, __reg, 0)
 
 #define NFT_OFFLOAD_MATCH_EXACT(__key, __base, __field, __len, __reg)	\
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 00e563a72d3d..1d42d06f5b64 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -115,19 +115,56 @@ nla_put_failure:
 	return -1;
 }
 
+union nft_cmp_offload_data {
+	u16	val16;
+	u32	val32;
+	u64	val64;
+};
+
+static void nft_payload_n2h(union nft_cmp_offload_data *data,
+			    const u8 *val, u32 len)
+{
+	switch (len) {
+	case 2:
+		data->val16 = ntohs(*((u16 *)val));
+		break;
+	case 4:
+		data->val32 = ntohl(*((u32 *)val));
+		break;
+	case 8:
+		data->val64 = be64_to_cpu(*((u64 *)val));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
 static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 			     struct nft_flow_rule *flow,
 			     const struct nft_cmp_expr *priv)
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->sreg];
+	union nft_cmp_offload_data _data, _datamask;
 	u8 *mask = (u8 *)&flow->match.mask;
 	u8 *key = (u8 *)&flow->match.key;
+	u8 *data, *datamask;
 
 	if (priv->op != NFT_CMP_EQ || priv->len > reg->len)
 		return -EOPNOTSUPP;
 
-	memcpy(key + reg->offset, &priv->data, reg->len);
-	memcpy(mask + reg->offset, &reg->mask, reg->len);
+	if (reg->flags & NFT_OFFLOAD_F_NETWORK2HOST) {
+		nft_payload_n2h(&_data, (u8 *)&priv->data, reg->len);
+		nft_payload_n2h(&_datamask, (u8 *)&reg->mask, reg->len);
+		data = (u8 *)&_data;
+		datamask = (u8 *)&_datamask;
+	} else {
+		data = (u8 *)&priv->data;
+		datamask = (u8 *)&reg->mask;
+	}
+
+	memcpy(key + reg->offset, data, reg->len);
+	memcpy(mask + reg->offset, datamask, reg->len);
 
 	flow->match.dissector.used_keys |= BIT(reg->key);
 	flow->match.dissector.offset[reg->key] = reg->base_offset;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e43863a1761f..1ebee25de677 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -226,8 +226,9 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
-				  vlan_tci, sizeof(__be16), reg);
+		NFT_OFFLOAD_MATCH_FLAGS(FLOW_DISSECTOR_KEY_VLAN, vlan,
+					vlan_tci, sizeof(__be16), reg,
+					NFT_OFFLOAD_F_NETWORK2HOST);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto):
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
@@ -241,8 +242,9 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
-				  vlan_tci, sizeof(__be16), reg);
+		NFT_OFFLOAD_MATCH_FLAGS(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
+					vlan_tci, sizeof(__be16), reg,
+					NFT_OFFLOAD_F_NETWORK2HOST);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
 							sizeof(struct vlan_hdr):
-- 
2.30.2



