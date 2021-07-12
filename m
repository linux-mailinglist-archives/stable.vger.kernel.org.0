Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876A43C46F9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhGLGau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhGLG1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0FB6117A;
        Mon, 12 Jul 2021 06:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071060;
        bh=5MKF9ghdCm53P2i9jAYJVmLiAUJx29b33TKlIav/K7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE4+W0L4hUV29a7Q6k++LU3ImDObPPcdn0e68HbnRdJZY4n43F7kY4hBHY0dQfPud
         ZADCi94//GwYdxpDT05cixju7bqqUGbRaW5WGbg1YqTSnD4+3OTHkL45laVWe+4t15
         Z8Oika5Ze1K5t8KIHW6u4mBVYqEl5sOhfCSN+/sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/348] netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
Date:   Mon, 12 Jul 2021 08:09:58 +0200
Message-Id: <20210712060729.957877385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 52f0f4e178c757b3d356087376aad8bd77271828 ]

Add unfront check for TCP and UDP packets before performing further
processing.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tproxy.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 95980154ef02..b97ab1198b03 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -30,6 +30,12 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	__be16 tport = 0;
 	struct sock *sk;
 
+	if (pkt->tprot != IPPROTO_TCP &&
+	    pkt->tprot != IPPROTO_UDP) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
 	if (!hp) {
 		regs->verdict.code = NFT_BREAK;
@@ -91,7 +97,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 
 	memset(&taddr, 0, sizeof(taddr));
 
-	if (!pkt->tprot_set) {
+	if (pkt->tprot != IPPROTO_TCP &&
+	    pkt->tprot != IPPROTO_UDP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.30.2



