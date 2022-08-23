Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC659D363
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbiHWIMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242065AbiHWIKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A2B696ED;
        Tue, 23 Aug 2022 01:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBA19611A8;
        Tue, 23 Aug 2022 08:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFE9C433C1;
        Tue, 23 Aug 2022 08:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242043;
        bh=QNfINd91NqgJ9BUqFSr2vO2WJPc3BM8wKhR0VOZG5r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJSH4q6Az0TXVHESSsBBALcdckEZqwh486+SJOUt7nbX/oZ5SK+NCQHIA9G2gGUs5
         OZbYu3O85LM1pwtJNW6RZLi7ctzq5kXT96kePrg9cX/eYVS7Rlka+AtC4xCKYNZYgI
         G/hV7zX31WsB7mNcapOK5TRIUNb0Yx2sHlzoDTYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 050/365] netfilter: nf_tables: fix crash when nf_trace is enabled
Date:   Tue, 23 Aug 2022 09:59:11 +0200
Message-Id: <20220823080120.280846182@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 399a14ec7993d605740de7b2cd5c0ce8407d12ed upstream.

do not access info->pkt when info->trace is not 1.
nft_traceinfo is not initialized, except when tracing is enabled.

The 'nft_trace_enabled' static key cannot be used for this, we must
always check info->trace first.

Pass nft_pktinfo directly to avoid this.

Fixes: e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3ddce24ac76d..cee3e4e905ec 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -34,25 +34,23 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 	nft_trace_notify(info);
 }
 
-static inline void nft_trace_packet(struct nft_traceinfo *info,
+static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
 				    const struct nft_rule_dp *rule,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
-static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
+					  struct nft_traceinfo *info)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		if (info->trace)
 			info->nf_trace = pkt->skb->nf_trace;
 	}
@@ -96,7 +94,6 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -110,7 +107,9 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
-		info->nf_trace = pkt->skb->nf_trace;
+
+		if (info->trace)
+			info->nf_trace = info->pkt->skb->nf_trace;
 		break;
 	}
 
@@ -271,10 +270,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
-			nft_trace_copy_nftrace(&info);
+			nft_trace_copy_nftrace(pkt, &info);
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(&info, chain, rule,
+			nft_trace_packet(pkt, &info, chain, rule,
 					 NFT_TRACETYPE_RULE);
 			continue;
 		}
@@ -318,7 +317,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		goto next_rule;
 	}
 
-	nft_trace_packet(&info, basechain, NULL, NFT_TRACETYPE_POLICY);
+	nft_trace_packet(pkt, &info, basechain, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
-- 
2.37.2



