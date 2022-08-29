Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45C5A4965
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiH2LYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiH2LXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B1BAA;
        Mon, 29 Aug 2022 04:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59664B80EF9;
        Mon, 29 Aug 2022 11:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0342C433D7;
        Mon, 29 Aug 2022 11:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771168;
        bh=jnbTVIEeMlwsEC0HOnDrK7gg//cPVaL3m7qOy+obV44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=job3WE6JFthsmNnPe8MeBC2awttisd/RFmqOXhw3ikeJ6lOQWXmsb9clkYWOiBGpo
         bWLWPvZJ7tJC55bpu4tRB8PzY+MvV10b6BO8scWuEZ11ICzFewh724g3xqwcXuRFgV
         lx6N5hAtFfHvV3QWaCXibNhf3dt494sQeQinykts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/86] netfilter: nf_tables: do not leave chain stats enabled on error
Date:   Mon, 29 Aug 2022 12:59:00 +0200
Message-Id: <20220829105757.952910160@linuxfoundation.org>
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

[ Upstream commit 43eb8949cfdffa764b92bc6c54b87cbe5b0003fe ]

Error might occur later in the nf_tables_addchain() codepath, enable
static key only after transaction has been created.

Fixes: 9f08ea848117 ("netfilter: nf_tables: keep chain counters away from hot path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 30bd4b867912c..456988b5c076e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1999,9 +1999,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, u32 flags)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
-	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	char name[NFT_NAME_MAXLEN];
 	struct nft_trans *trans;
@@ -2037,7 +2037,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 				return PTR_ERR(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
-			static_branch_inc(&nft_counters_enabled);
 		}
 
 		err = nft_basechain_init(basechain, family, &hook, flags);
@@ -2120,6 +2119,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
+	if (stats)
+		static_branch_inc(&nft_counters_enabled);
+
 	table->use++;
 
 	return 0;
-- 
2.35.1



