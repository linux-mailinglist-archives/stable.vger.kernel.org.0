Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4575A4BC9
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiH2M2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiH2M1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5A7ADCFF;
        Mon, 29 Aug 2022 05:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE39561199;
        Mon, 29 Aug 2022 11:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B47C433D6;
        Mon, 29 Aug 2022 11:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771084;
        bh=rFzMF7sdG+pDEMuyG9RCAEK/LYblMveUadnbsf2Sj0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNhDjJkgaqSvNOdkqY2r1KeauNpxRSPf8cztP39bECGwDVdfkJJsKHj0k2x20UPuO
         XggnBNd1tsGfz+S3gysGLD6JurgTxsuGc7TjN/7G9wVesnyPEi2ZKAZnROMGIy2MAG
         Vsoz0guBNugRirLYSksiduKavw+2BM1GQpl9FNR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/136] netfilter: nf_tables: do not leave chain stats enabled on error
Date:   Mon, 29 Aug 2022 12:58:46 +0200
Message-Id: <20220829105807.039857957@linuxfoundation.org>
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
index 96903c72ebb45..b4d38656d98fa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2101,9 +2101,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
-	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	char name[NFT_NAME_MAXLEN];
 	struct nft_trans *trans;
@@ -2140,7 +2140,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 				return PTR_ERR(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
-			static_branch_inc(&nft_counters_enabled);
 		}
 
 		err = nft_basechain_init(basechain, family, &hook, flags);
@@ -2223,6 +2222,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
+	if (stats)
+		static_branch_inc(&nft_counters_enabled);
+
 	table->use++;
 
 	return 0;
-- 
2.35.1



