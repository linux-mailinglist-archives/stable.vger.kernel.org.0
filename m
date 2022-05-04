Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE37051A743
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiEDRC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355623AbiEDRAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40974BB8A;
        Wed,  4 May 2022 09:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53947B8279F;
        Wed,  4 May 2022 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097E1C385A4;
        Wed,  4 May 2022 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683116;
        bh=RgeZqrWmezN2DZR7KTsOqWVW++36tiwICGCSZVp8xps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmF7LguNjgy2R7/ewbBX5O/1/1V6CIMXyio9x0mWGkhMNa6i5rzEeS2DcQPksmMiB
         GZzImaL1GK4IHq9KAXIVolebNg2laVAyMtycroXvk5kVHjMzPq26S6GM0Kx0tMalF8
         co5B+ervbkR0Sn7KweytNDtF4yjvLYbP1GtV5lJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 5.10 120/129] netfilter: nft_socket: only do sk lookups when indev is available
Date:   Wed,  4 May 2022 18:45:12 +0200
Message-Id: <20220504153030.950472872@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

commit 743b83f15d4069ea57c3e40996bf4a1077e0cdc1 upstream.

Check if the incoming interface is available and NFT_BREAK
in case neither skb->sk nor input device are set.

Because nf_sk_lookup_slow*() assume packet headers are in the
'in' direction, use in postrouting is not going to yield a meaningful
result.  Same is true for the forward chain, so restrict the use
to prerouting, input and output.

Use in output work if a socket is already attached to the skb.

Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Reported-and-tested-by: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_socket.c |   52 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -33,6 +33,32 @@ static void nft_socket_wildcard(const st
 	}
 }
 
+static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
+{
+	const struct net_device *indev = nft_in(pkt);
+	const struct sk_buff *skb = pkt->skb;
+	struct sock *sk = NULL;
+
+	if (!indev)
+		return NULL;
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, indev);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, indev);
+		break;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return sk;
+}
+
 static void nft_socket_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -46,20 +72,7 @@ static void nft_socket_eval(const struct
 		sk = NULL;
 
 	if (!sk)
-		switch(nft_pf(pkt)) {
-		case NFPROTO_IPV4:
-			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
-		case NFPROTO_IPV6:
-			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#endif
-		default:
-			WARN_ON_ONCE(1);
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		sk = nft_socket_do_lookup(pkt);
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
@@ -150,6 +163,16 @@ static int nft_socket_dump(struct sk_buf
 	return 0;
 }
 
+static int nft_socket_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_LOCAL_OUT));
+}
+
 static struct nft_expr_type nft_socket_type;
 static const struct nft_expr_ops nft_socket_ops = {
 	.type		= &nft_socket_type,
@@ -157,6 +180,7 @@ static const struct nft_expr_ops nft_soc
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.validate	= nft_socket_validate,
 };
 
 static struct nft_expr_type nft_socket_type __read_mostly = {


