Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F85C56FC82
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiGKJpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiGKJnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE691A0273;
        Mon, 11 Jul 2022 02:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5199AB80E76;
        Mon, 11 Jul 2022 09:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F0AC341C0;
        Mon, 11 Jul 2022 09:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531300;
        bh=nopZrpn6fBT1DooGZhyQykFhCFEYOp3Mr0+AMNS+aJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zprQ8bsrkug6oVcivmu1vpqTn19ZqdHZ6asdZObNwr10bQvNM/jZoFJJ/aqAQ/kkE
         kvCYJ8/uW873GO6+rzWvF+5lRcFS+xreAdWLyjzsKzbCawUOfIfNmlIxBSOwTrNuzB
         DX2KYcUjF6J+knQYS0TrE0SPRmXlWrkwgCPFwqa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/230] netfilter: nf_tables: convert pktinfo->tprot_set to flags field
Date:   Mon, 11 Jul 2022 11:05:12 +0200
Message-Id: <20220711090605.669242621@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b5bdc6f9c24db9a0adf8bd00c0e935b184654f00 ]

Generalize boolean field to store more flags on the pktinfo structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h      | 8 ++++++--
 include/net/netfilter/nf_tables_ipv4.h | 7 ++++---
 include/net/netfilter/nf_tables_ipv6.h | 6 +++---
 net/netfilter/nf_tables_core.c         | 2 +-
 net/netfilter/nf_tables_trace.c        | 4 ++--
 net/netfilter/nft_meta.c               | 2 +-
 net/netfilter/nft_payload.c            | 4 ++--
 7 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2af1c2c64128..d005f87691da 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -21,10 +21,14 @@ struct module;
 
 #define NFT_JUMP_STACK_SIZE	16
 
+enum {
+	NFT_PKTINFO_L4PROTO	= (1 << 0),
+};
+
 struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct nf_hook_state	*state;
-	bool				tprot_set;
+	u8				flags;
 	u8				tprot;
 	u16				fragoff;
 	unsigned int			thoff;
@@ -75,7 +79,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
-	pkt->tprot_set = false;
+	pkt->flags = 0;
 	pkt->tprot = 0;
 	pkt->thoff = 0;
 	pkt->fragoff = 0;
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index eb4c094cd54d..c4a6147b0ef8 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -10,7 +10,7 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	struct iphdr *ip;
 
 	ip = ip_hdr(pkt->skb);
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = ip->protocol;
 	pkt->thoff = ip_hdrlen(pkt->skb);
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
@@ -36,7 +36,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	else if (len < thoff)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -71,7 +71,7 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 		goto inhdr_error;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -82,4 +82,5 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INHDRERRORS);
 	return -1;
 }
+
 #endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 7595e02b00ba..ec7eaeaf4f04 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -18,7 +18,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 		return;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -50,7 +50,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -96,7 +96,7 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		goto inhdr_error;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 907e848dbc17..d4d8f613af51 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -79,7 +79,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
 		ptr = skb_network_header(skb);
 	else {
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
 		ptr = skb_network_header(skb) + nft_thoff(pkt);
 	}
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e4fe2f0780eb..84a7dea46efa 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -113,13 +113,13 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 	int off = skb_network_offset(skb);
 	unsigned int len, nh_end;
 
-	nh_end = pkt->tprot_set ? nft_thoff(pkt) : skb->len;
+	nh_end = pkt->flags & NFT_PKTINFO_L4PROTO ? nft_thoff(pkt) : skb->len;
 	len = min_t(unsigned int, nh_end - skb_network_offset(skb),
 		    NFT_TRACETYPE_NETWORK_HSIZE);
 	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
 		return -1;
 
-	if (pkt->tprot_set) {
+	if (pkt->flags & NFT_PKTINFO_L4PROTO) {
 		len = min_t(unsigned int, skb->len - nft_thoff(pkt),
 			    NFT_TRACETYPE_TRANSPORT_HSIZE);
 		if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 44d9b38e5f90..14412f69a34e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -321,7 +321,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		nft_reg_store8(dest, pkt->tprot);
 		break;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 132875cd7fff..c3ccfff54a35 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -108,7 +108,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -613,7 +613,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
-- 
2.35.1



