Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518EA55C221
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbiF0Lix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiF0Lhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73182630;
        Mon, 27 Jun 2022 04:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5663CB81122;
        Mon, 27 Jun 2022 11:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A4C3411D;
        Mon, 27 Jun 2022 11:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329570;
        bh=nBwQpZBkMM39gY6r+F8ekVsav1X2LCZZ21G0wIdCbTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLqO66zBNyMza1/5tGvR25QChr8qcozMD3R2l7RiiiVf48GUydavrhAzzpcWEisML
         ddrarg8iYJFVFjWxC6db8+SxG6WMtb5tq8GBlVhnHUuTy9EuXxU1eGKj9UuomoVpVJ
         xW550zowNSNmfflD4yKbTW8WFpwldPd30goi7pEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/135] netfilter: use get_random_u32 instead of prandom
Date:   Mon, 27 Jun 2022 13:20:42 +0200
Message-Id: <20220627111939.178588612@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b1fd94e704571f98b21027340eecf821b2bdffba ]

bh might occur while updating per-cpu rnd_state from user context,
ie. local_out path.

BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
Call Trace:
 check_preemption_disabled+0xde/0xe0
 nft_ng_random_eval+0x24/0x54 [nft_numgen]

Use the random driver instead, this also avoids need for local prandom
state. Moreover, prandom now uses the random driver since d4150779e60f
("random32: use real rng for non-deterministic randomness").

Based on earlier patch from Pablo Neira.

Fixes: 6b2faee0ca91 ("netfilter: nft_meta: place prandom handling in a helper")
Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_meta.c   | 13 ++-----------
 net/netfilter/nft_numgen.c | 12 +++---------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index a7e01e9952f1..44d9b38e5f90 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
@@ -32,8 +33,6 @@
 #define NFT_META_SECS_PER_DAY		86400
 #define NFT_META_DAYS_PER_WEEK		7
 
-static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
-
 static u8 nft_meta_weekday(void)
 {
 	time64_t secs = ktime_get_real_seconds();
@@ -267,13 +266,6 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
-static noinline u32 nft_prandom_u32(void)
-{
-	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-
-	return prandom_u32_state(state);
-}
-
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
@@ -385,7 +377,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_PRANDOM:
-		*dest = nft_prandom_u32();
+		*dest = get_random_u32();
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
@@ -514,7 +506,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
-		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_XFRM
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 722cac1e90e0..4e43214e88de 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -9,12 +9,11 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/random.h>
 #include <linux/static_key.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 
-static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
-
 struct nft_ng_inc {
 	u8			dreg;
 	u32			modulus;
@@ -104,12 +103,9 @@ struct nft_ng_random {
 	u32			offset;
 };
 
-static u32 nft_ng_random_gen(struct nft_ng_random *priv)
+static u32 nft_ng_random_gen(const struct nft_ng_random *priv)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
-
-	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
-	       priv->offset;
+	return reciprocal_scale(get_random_u32(), priv->modulus) + priv->offset;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -137,8 +133,6 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	prandom_init_once(&nft_numgen_prandom_state);
-
 	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
-- 
2.35.1



