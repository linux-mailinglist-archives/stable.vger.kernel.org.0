Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE42C6BB265
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjCOMf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjCOMfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31149FE70
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BAA1B81E09
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A78DC433D2;
        Wed, 15 Mar 2023 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883632;
        bh=x7i46WTKycTTQNdw04EN2Pdg5Yo3C+7GBFnpLwkvoDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQcDJ4Idf/9xII1Zp9e4nWydzza+wbR7I1MOwxJr1Lz1tgvhcQdYiw1SlxobgeG2t
         i2Y4V0wyXppCKzW9awLIN2jO77Ym6Ba/uwxr2YIt/VvNxnF+Rg6UOa7U+XhT+8Whkr
         8Qj46Noc2PZfrFmrIv4TGl61s/6vvDeTnKXoEw34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/143] netfilter: nft_last: copy content when cloning expression
Date:   Wed, 15 Mar 2023 13:12:38 +0100
Message-Id: <20230315115742.737227387@linuxfoundation.org>
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

[ Upstream commit 860e874290fb3be08e966c9c8ffc510c5b0f2bd8 ]

If the ruleset contains last timestamps, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_last.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index bb15a55dad5c0..eaa54964cf23c 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -104,11 +104,15 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
 static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_last_priv *priv_src = nft_expr_priv(src);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
 	if (!priv_dst->last)
 		return -ENOMEM;
 
+	priv_dst->last->set = priv_src->last->set;
+	priv_dst->last->jiffies = priv_src->last->jiffies;
+
 	return 0;
 }
 
-- 
2.39.2



