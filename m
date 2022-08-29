Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF3F5A4858
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiH2LJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiH2LIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C956867447;
        Mon, 29 Aug 2022 04:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30482B80EF6;
        Mon, 29 Aug 2022 11:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74932C433D7;
        Mon, 29 Aug 2022 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771158;
        bh=44DCdyDNg95hzS1cCLGqf95ZmDYKPi0bt9FW6VXMyWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncZGh/XbVe4QFle/D7FC4G5NWfXkmnsr2ifsNBde59MkzWK/eFzFVvkBj8EU4p9tP
         AvMVkIJapZnN2U+mPYiLYtwZ7HNcqWthXNFs0nqAI0eJJiNqWQ+pMq64d8uAvKbh6s
         PImkg1g6CrlRnTBM18ARxCAAR1JEKK6D44MlUtps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/86] netfilter: nft_payload: do not truncate csum_offset and csum_type
Date:   Mon, 29 Aug 2022 12:58:59 +0200
Message-Id: <20220829105757.916432111@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index bdb07362c0ef0..551e0d6cf63d4 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -660,17 +660,23 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
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
 
@@ -681,7 +687,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
@@ -695,6 +701,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
 				       priv->len);
-- 
2.35.1



