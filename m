Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298225A4834
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiH2LHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiH2LG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770AD2AC7A;
        Mon, 29 Aug 2022 04:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6959B80EF3;
        Mon, 29 Aug 2022 11:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EF2C433D7;
        Mon, 29 Aug 2022 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771072;
        bh=g4WLSj1TONbIglnTksYB7pqrvJ3K6NIWi6cf4DY+HP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkD31EpOISLYgmgqqqjTployNH8A8vBNPHsLjj9f04hNtLUO4fhoeheZYSomnzDMn
         G4u9v9O/xgJF0EwKc3Cg/ZGG8lkiL0FSrGu5YXay4ZIB4zRH9KE+PPd2DEQzOQQK5b
         5CG5BXXSrM1+/yCQISlHA0oF024qBiqtA+z1mWok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/136] netfilter: nft_payload: report ERANGE for too long offset and length
Date:   Mon, 29 Aug 2022 12:58:44 +0200
Message-Id: <20220829105806.961172269@linuxfoundation.org>
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

[ Upstream commit 94254f990c07e9ddf1634e0b727fab821c3b5bf9 ]

Instead of offset and length are truncation to u8, report ERANGE.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b46e01365bd96..da0ed3430bb9d 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -785,6 +785,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 {
 	enum nft_payload_bases base;
 	unsigned int offset, len;
+	int err;
 
 	if (tb[NFTA_PAYLOAD_BASE] == NULL ||
 	    tb[NFTA_PAYLOAD_OFFSET] == NULL ||
@@ -811,8 +812,13 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_PAYLOAD_DREG] == NULL)
 		return ERR_PTR(-EINVAL);
 
-	offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
-	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_LEN], U8_MAX, &len);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
 	    base != NFT_PAYLOAD_LL_HEADER && base != NFT_PAYLOAD_INNER_HEADER)
-- 
2.35.1



