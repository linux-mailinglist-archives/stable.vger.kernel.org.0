Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A16505236
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiDRMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240612AbiDRMjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FCA11A33;
        Mon, 18 Apr 2022 05:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B3660FB6;
        Mon, 18 Apr 2022 12:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F83C385A7;
        Mon, 18 Apr 2022 12:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284998;
        bh=G++U9rtoxfQSlDamiCXkUBLmwjBH2Lkb15OC1vNC2oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/VvbUXqmhln07+JuWlQWW3LougpKCD7lVGyyrBejKOZ/A3nAkucROovapA8onpyv
         oS7AP33DJexFZBso4nxBtOeNhc8+dHpMaaDGfE6PI/PRCK9CcEKD/r09Qes/B3won0
         GRBfQzT6FW7UiIAy7VZ7Aoe4B9O3nkW7hnKREd1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Topi Miettinen <toiwoton@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/189] netfilter: nft_socket: make cgroup match work in input too
Date:   Mon, 18 Apr 2022 14:11:34 +0200
Message-Id: <20220418121202.610066540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

[ Upstream commit 05ae2fba821c4d122ab4ba3e52144e21586c4010 ]

cgroupv2 helper function ignores the already-looked up sk
and uses skb->sk instead.

Just pass sk from the calling function instead; this will
make cgroup matching work for udp and tcp in input even when
edemux did not set skb->sk already.

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d601974c9d2e..b8f011145765 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -36,12 +36,11 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 
 #ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
-nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
+nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
 {
-	struct sock *sk = skb_to_full_sk(pkt->skb);
 	struct cgroup *cgrp;
 
-	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+	if (!sk_fullsock(sk))
 		return false;
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -108,7 +107,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
-		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
+		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-- 
2.35.1



