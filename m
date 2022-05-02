Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270C95176F6
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiEBS6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiEBS6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F82CB7E1
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0E03B819C5
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88774C385AF;
        Mon,  2 May 2022 18:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517677;
        bh=pc12KYDuts151jRSGXqDW3TFxOO+rBjlAhDLEQlJ2ek=;
        h=Subject:To:Cc:From:Date:From;
        b=LYrbmMVIZD9NkAW+/s+gfDPovtyEWsuhwYWJeW+gn3bDe8QR1Uk+2JaWnl1AvkSZI
         qGwq040nZ92fMMQBnCkrB3nNl9ShzGWNwRNxSZUBoc5Mgbu/fW+g3HVELCNoQkoSlo
         VCGWx0aYKhA11xgfE9/m1mTfPc8nRe/QZPkXXI84=
Subject: FAILED: patch "[PATCH] netfilter: nft_socket: only do sk lookups when indev is" failed to apply to 5.10-stable tree
To:     fw@strlen.de, pablo@netfilter.org, toiwoton@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:54:36 +0200
Message-ID: <165151767681209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 743b83f15d4069ea57c3e40996bf4a1077e0cdc1 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 28 Apr 2022 09:39:21 +0200
Subject: [PATCH] netfilter: nft_socket: only do sk lookups when indev is
 available

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

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 6d9e8e0a3a7d..05ae5a338b6f 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -54,6 +54,32 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
 }
 #endif
 
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
@@ -67,20 +93,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
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
@@ -224,6 +237,16 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 	return nft_expr_reduce_bitwise(track, expr);
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
@@ -231,6 +254,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.validate	= nft_socket_validate,
 	.reduce		= nft_socket_reduce,
 };
 

