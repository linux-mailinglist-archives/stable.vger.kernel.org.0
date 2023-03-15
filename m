Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516046BB25C
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjCOMfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjCOMfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF49E679
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28E761D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2491C4339B;
        Wed, 15 Mar 2023 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883635;
        bh=DGYEc5X/QGc79/Mm7N81PbNywMsRC9SvTajrgrCd5v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9vnEmXJYDAIAtyr1zbUigUXgrwTt4FSyVyfM458D6RsLcOMSGvZ7aZDsF0iMlo0R
         PITHbB6UGc0KPFvga2WlQed7KJKE3aWGUw8To3kdBMTbcGMpiiEvN0n5Hn7azJ1Bc7
         SwkwTMB7YAaSEnjcbZgM8jHofGbBiScgfyhoqXuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/143] netfilter: nft_quota: copy content when cloning expression
Date:   Wed, 15 Mar 2023 13:12:39 +0100
Message-Id: <20230315115742.766252159@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit aabef97a35160461e9c576848ded737558d89055 ]

If the ruleset contains consumed quota, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Restore the user-defined quota and flags too.

Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_quota.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index e6b0df68feeaf..410a5fcf88309 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -235,12 +235,16 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
+	struct nft_quota *priv_src = nft_expr_priv(src);
+
+	priv_dst->quota = priv_src->quota;
+	priv_dst->flags = priv_src->flags;
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-	atomic64_set(priv_dst->consumed, 0);
+	*priv_dst->consumed = *priv_src->consumed;
 
 	return 0;
 }
-- 
2.39.2



