Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4CD6BB30E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjCOMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjCOMky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8216231C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CC8CB81E17
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DA3C433EF;
        Wed, 15 Mar 2023 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883978;
        bh=N8GvDc8kXEwY0TJiZARrEWIq4/JtWXZVfuGvJkLHK+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5kIaPABSJP/J/UDz72R4qDIYTMJghwqz5wTEm5/Uh3d1NQvH5IsEHIJCLBJNjlqO
         niTGm+ll8Cj2n/Nj9Y27P0HjRLUvbiOo9dTIAlUxC+K5LpeL4fC65DXoZamZcu3Kif
         dDhts0Y2XFWdz7FQMPhfV0Yz4gzHyK2H80q/8C7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 060/141] netfilter: nft_last: copy content when cloning expression
Date:   Wed, 15 Mar 2023 13:12:43 +0100
Message-Id: <20230315115741.790202941@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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
index 7f2bda6641bd8..8e6d7eaf9dc8b 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -105,11 +105,15 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
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



