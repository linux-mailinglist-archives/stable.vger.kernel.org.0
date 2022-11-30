Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F5063DF7B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiK3Srg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiK3Srf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7084BA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3936B81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9DCC433D6;
        Wed, 30 Nov 2022 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834050;
        bh=nH/slBNpjmJnHrRrpF8e1Im2AvXLgxli+uQOzxpKcFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qz8MucHnOij8T9Pa7/e5ZcxNIrHeNrlF12Df01kSPZ8wpirNcHEkOARDrZ2v/KuiZ
         nydIRYWTN3FEAyOqpZMIZdzuCIEUivdkVXjpzSdFJg+ilN7CwKXZo08lSxhZ0rhbk6
         29oEkOjrImmMMkecvy9vjLxe1S0t3tV/xqSxmVZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 083/289] netfilter: nf_tables: do not set up extensions for end interval
Date:   Wed, 30 Nov 2022 19:21:08 +0100
Message-Id: <20221130180546.027653943@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 33c7aba0b4ffd6d7cdab862a034eb582a5120a38 ]

Elements with an end interval flag set on do not store extensions. The
global set definition is currently setting on the timeout and stateful
expression for end interval elements.

This leads to skipping end interval elements from the set->ops->walk()
path as the expired check bogusly reports true.

Moreover, do not set up stateful expressions for elements with end
interval flag set on since this is never used.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42e370575c30..0a6f3c1e9ab7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5958,7 +5958,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &timeout);
 		if (err)
 			return err;
-	} else if (set->flags & NFT_SET_TIMEOUT) {
+	} else if (set->flags & NFT_SET_TIMEOUT &&
+		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
 		timeout = set->timeout;
 	}
 
@@ -6024,7 +6025,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
-	} else if (set->num_exprs > 0) {
+	} else if (set->num_exprs > 0 &&
+		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
 		err = nft_set_elem_expr_clone(ctx, set, expr_array);
 		if (err < 0)
 			goto err_set_elem_expr_clone;
-- 
2.35.1



