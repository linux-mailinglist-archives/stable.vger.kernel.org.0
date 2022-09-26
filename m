Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D75EA228
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiIZLDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiIZLBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:01:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351735E330;
        Mon, 26 Sep 2022 03:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796C5B802C5;
        Mon, 26 Sep 2022 10:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0C6C433C1;
        Mon, 26 Sep 2022 10:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188298;
        bh=+NgYKkqX3/2DaegQLFRVsDcdbL8KVVTr9cI3+4NSSHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuroTcNpmIzSObG7N0UnOWef+I6MjZL2hpUEDRd6N9GM42+SEhcb3PLGERU1UqHfl
         7nofojZEyj9hPFHLx7XNJxSXxaSispcRKp39h3VtJl6l6EAS5WLutUKslnMxqQHY1b
         1j4Xe7t72syHxsDqBXuZ9/4kgLRBzGQ/sOahB6cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/141] netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
Date:   Mon, 26 Sep 2022 12:12:11 +0200
Message-Id: <20220926100758.232735866@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 921ebde3c0d22c8cba74ce8eb3cc4626abff1ccd ]

syzbot is reporting underflow of nft_counters_enabled counter at
nf_tables_addchain() [1], for commit 43eb8949cfdffa76 ("netfilter:
nf_tables: do not leave chain stats enabled on error") missed that
nf_tables_chain_destroy() after nft_basechain_init() in the error path of
nf_tables_addchain() decrements the counter because nft_basechain_init()
makes nft_is_base_chain() return true by setting NFT_CHAIN_BASE flag.

Increment the counter immediately after returning from
nft_basechain_init().

Link:  https://syzkaller.appspot.com/bug?extid=b5d82a651b71cd8a75ab [1]
Reported-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
Fixes: 43eb8949cfdffa76 ("netfilter: nf_tables: do not leave chain stats enabled on error")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b8e7e1c5c08a..d65c47bcbfc9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2001,7 +2001,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, u32 flags)
 {
 	const struct nlattr * const *nla = ctx->nla;
-	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
 	struct net *net = ctx->net;
@@ -2015,6 +2014,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		return -EOVERFLOW;
 
 	if (nla[NFTA_CHAIN_HOOK]) {
+		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook;
 
 		if (flags & NFT_CHAIN_BINDING)
@@ -2047,6 +2047,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			kfree(basechain);
 			return err;
 		}
+		if (stats)
+			static_branch_inc(&nft_counters_enabled);
 	} else {
 		if (flags & NFT_CHAIN_BASE)
 			return -EINVAL;
@@ -2121,9 +2123,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
-	if (stats)
-		static_branch_inc(&nft_counters_enabled);
-
 	table->use++;
 
 	return 0;
-- 
2.35.1



