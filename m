Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2055A48B1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiH2LOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiH2LMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A719D6F252;
        Mon, 29 Aug 2022 04:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F0AB611E9;
        Mon, 29 Aug 2022 11:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19872C433D6;
        Mon, 29 Aug 2022 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771199;
        bh=4zRt2mmXK7bqaw+EBMj1hNrUL/9q8bursdtt3AUzJSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V34saVS0+IJBCwrVG2Mo7E3tL08atSE9rpYabHiKo21z1sdc+v8FGLZKK9o9G2oQA
         cW2nusNH/yhuiuMA1lcPWu512E6wqJEuoYj03kgrGupU2qQR31hVzyPPX8ZRS/3AgJ
         btF1ac17grpYC1CiVu1jjUAl3uYtqvOcLUKW3j5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/86] netfilter: nf_tables: consolidate rule verdict trace call
Date:   Mon, 29 Aug 2022 12:59:04 +0200
Message-Id: <20220829105758.124884369@linuxfoundation.org>
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

[ Upstream commit 4765473fefd4403b5eeca371637065b561522c50 ]

Add function to consolidate verdict tracing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_core.c | 39 ++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a61b5bf5aa0fb..6dd27c8cd4253 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,36 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+					 const struct nft_chain *chain,
+					 const struct nft_regs *regs)
+{
+	enum nft_trace_types type;
+
+	switch (regs->verdict.code) {
+	case NFT_CONTINUE:
+	case NFT_RETURN:
+		type = NFT_TRACETYPE_RETURN;
+		break;
+	default:
+		type = NFT_TRACETYPE_RULE;
+		break;
+	}
+
+	__nft_trace_packet(info, chain, type);
+}
+
+static inline void nft_trace_verdict(struct nft_traceinfo *info,
+				     const struct nft_chain *chain,
+				     const struct nft_rule *rule,
+				     const struct nft_regs *regs)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		info->rule = rule;
+		__nft_trace_verdict(info, chain, regs);
+	}
+}
+
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -207,13 +237,13 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
+	nft_trace_verdict(&info, chain, rule, &regs);
+
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -226,15 +256,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
-
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
 	case NFT_RETURN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.35.1



