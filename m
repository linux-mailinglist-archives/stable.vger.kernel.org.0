Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BDC56FC84
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiGKJpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiGKJnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019FAA23BE;
        Mon, 11 Jul 2022 02:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4D00B80E7A;
        Mon, 11 Jul 2022 09:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C822C34115;
        Mon, 11 Jul 2022 09:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531305;
        bh=6OGDwIFv/5XaLp9/EoSSAjeNh5wIQiQh6P3Zams+wAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIBu4DpOJSiDWI998am5HYpqYjlA4XDk0VMU4KjjDupcI8D4x4CFc+5ZDsKWQTnN5
         AhnH7TI5JdTOWPYKU/ZChxMyxjXtrJJOYigFKCSb2gOW3oIPK+ko27PG2fpQXpc+sr
         xzMdV/965qT7HWJjCt2bMwUH+EBan4i1tFXnBxy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/230] netfilter: nft_payload: dont allow th access for fragments
Date:   Mon, 11 Jul 2022 11:05:14 +0200
Message-Id: <20220711090605.724516881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a9e8503def0fd4ed89ade1f61c315f904581d439 ]

Loads relative to ->thoff naturally expect that this points to the
transport header, but this is only true if pkt->fragoff == 0.

This has little effect for rulesets with connection tracking/nat because
these enable ip defra. For other rulesets this prevents false matches.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c  | 2 +-
 net/netfilter/nft_payload.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dbe1f2e7dd9e..9e927ab4df15 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -167,7 +167,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 {
 	struct tcphdr *tcph;
 
-	if (pkt->tprot != IPPROTO_TCP)
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
 		return NULL;
 
 	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index ee359a4a60f5..b46e01365bd9 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -84,7 +84,7 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 {
 	unsigned int thoff = nft_thoff(pkt);
 
-	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 		return -1;
 
 	switch (pkt->tprot) {
@@ -148,7 +148,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -658,7 +658,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -697,7 +697,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
 	    pkt->tprot == IPPROTO_SCTP &&
 	    skb->ip_summed != CHECKSUM_PARTIAL) {
-		if (nft_payload_csum_sctp(skb, nft_thoff(pkt)))
+		if (pkt->fragoff == 0 &&
+		    nft_payload_csum_sctp(skb, nft_thoff(pkt)))
 			goto err;
 	}
 
-- 
2.35.1



