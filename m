Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9856D6BB31F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjCOMlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjCOMl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B679D22135
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC26261D72
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE262C433D2;
        Wed, 15 Mar 2023 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883984;
        bh=V2KqiZ8S4llN8SpcxEofoWWm3mOxyYTJoqhTbgaLRBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcbrvMTkyQ8J8RVBWaqNQZmlRe9//2ufD0SAy9vO5ABOgGRnTj6csk4g+oRMB/h5S
         f/mUaqSvDzoyw6jPoAfmwZLMu41CZ8asXghYVbB8pY7ZzSExrkuuoS/O0Wv0fKeil9
         AU2DNI0P/Kd5+iuoa5fKo27D9KXFTsDBUqLtDbGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 061/141] netfilter: nft_quota: copy content when cloning expression
Date:   Wed, 15 Mar 2023 13:12:44 +0100
Message-Id: <20230315115741.818492198@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 123578e289179..3ba12a7471b0f 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -236,12 +236,16 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
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



