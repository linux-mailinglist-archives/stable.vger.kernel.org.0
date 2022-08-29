Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A195A4835
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiH2LHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiH2LGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:06:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45539642F9;
        Mon, 29 Aug 2022 04:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D562C611D3;
        Mon, 29 Aug 2022 11:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0308C433C1;
        Mon, 29 Aug 2022 11:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771078;
        bh=Vh6S2afy4VhQO2PuXzVrdXeYWcbjnS70h+9CbDxuxKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn/8+sOQ0ZqNN7ZLW9Lz+tQzHcfLF6Dr/AmgIPe+jnw4jGrX/aA+6fBiBjZDdOV+i
         jxRQMxRdMxGxwHVC1aF0iGAdVtVJ1jbkc1w8wCvcYN8hhr5f0TtlRucFpEcgTpZfoy
         99dOdWmVSIEzFYlDeqB0rRD7gGARB1QGSXjsQScI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/136] netfilter: nft_payload: do not truncate csum_offset and csum_type
Date:   Mon, 29 Aug 2022 12:58:45 +0200
Message-Id: <20220829105807.001017919@linuxfoundation.org>
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

[ Upstream commit 7044ab281febae9e2fa9b0b247693d6026166293 ]

Instead report ERANGE if csum_offset is too long, and EOPNOTSUPP if type
is not support.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index da0ed3430bb9d..da652c21368e1 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -712,17 +712,23 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
+	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
-		priv->csum_type =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
-	if (tb[NFTA_PAYLOAD_CSUM_OFFSET])
-		priv->csum_offset =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
+	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
+		err = nft_parse_u32_check(tb[NFTA_PAYLOAD_CSUM_OFFSET], U8_MAX,
+					  &csum_offset);
+		if (err < 0)
+			return err;
+
+		priv->csum_offset = csum_offset;
+	}
 	if (tb[NFTA_PAYLOAD_CSUM_FLAGS]) {
 		u32 flags;
 
@@ -733,7 +739,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
@@ -747,6 +753,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
 				       priv->len);
-- 
2.35.1



