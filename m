Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F285AAF4C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiIBMgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbiIBMeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:34:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1814BD9EBC;
        Fri,  2 Sep 2022 05:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CDE6218D;
        Fri,  2 Sep 2022 12:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2216BC433C1;
        Fri,  2 Sep 2022 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121711;
        bh=02dvi00mHdGtZ2LxDeSycdfEgjyDOflIKnkQinHHrZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR4Rmkpb08hi1RGDUD+h74aG4YJnY18mAvMxq9DdDZOHvIVq3ZILSG310NSWGu0uR
         BdBHthNR3R+b9Iex724MztBnxQHcXzYIe+kTPLza2LKJBrHDXBaSeYJPysd56UGsuo
         eJijuq8jCq/rWA6HG73pHQSEcbjxkA2++Jiq3hNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/77] netfilter: nft_payload: do not truncate csum_offset and csum_type
Date:   Fri,  2 Sep 2022 14:18:32 +0200
Message-Id: <20220902121404.420648109@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
index 7520ec17cabb7..6ed6ccef5e1ad 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -558,6 +558,8 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
+	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
@@ -565,11 +567,15 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	priv->sreg        = nft_parse_register(tb[NFTA_PAYLOAD_SREG]);
 
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
 
@@ -580,13 +586,14 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_validate_register_load(priv->sreg, priv->len);
 }
-- 
2.35.1



