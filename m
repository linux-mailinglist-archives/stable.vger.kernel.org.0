Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1A3C49D2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbhGLGqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237236AbhGLGqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B9061108;
        Mon, 12 Jul 2021 06:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072107;
        bh=e3PSvxGQLDD4dem87u67/59qZcZxuxl3Ux/7cS8uqVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR4GXzGttD+4wDenX5AK0C5NGoE73t1KHJ5auFKHbnVDPXHMwWh9W02WLtNLEGIxk
         T9PQBki7r1NliTMNxbRVbRvoEIqoMcv2V2zRKl2f048UDMLLfUCN0zVflTpcXAleHL
         IEcVjb5WkAmpgtrQCeqy2vxdTukiQqyV6hreDAII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/593] netfilter: nft_exthdr: check for IPv6 packet before further processing
Date:   Mon, 12 Jul 2021 08:08:37 +0200
Message-Id: <20210712060925.649063490@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit cdd73cc545c0fb9b1a1f7b209f4f536e7990cff4 ]

ipv6_find_hdr() does not validate that this is an IPv6 packet. Add a
sanity check for calling ipv6_find_hdr() to make sure an IPv6 packet
is passed for parsing.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3c48cdc8935d..faa0844c01fb 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -42,6 +42,9 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	unsigned int offset = 0;
 	int err;
 
+	if (pkt->skb->protocol != htons(ETH_P_IPV6))
+		goto err;
+
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
 		nft_reg_store8(dest, err >= 0);
-- 
2.30.2



