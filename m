Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67833CD958
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243451AbhGSO2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243656AbhGSO1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A4061245;
        Mon, 19 Jul 2021 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707243;
        bh=S79m0TmXjuywQgFCPipcQIRcCmH8FvNIsgjueqnZ13o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbEEnbA4PL0JZVWhR+f7gm3V+8hI/zPC6UG25As49GwTbYZTstdUcOgyTg6QxXqZ+
         q+soJsyK6p2jW9/GlqgcrKj0HxSKqQW9AEtwOehxZKKX20AT8sDuN6i4Ke7ZmeIUEh
         KxZAEeag67nFkrzERKcblU2h2XQQfA6RPsJkq5vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/245] netfilter: nft_exthdr: check for IPv6 packet before further processing
Date:   Mon, 19 Jul 2021 16:50:25 +0200
Message-Id: <20210719144943.089377018@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 47beb3abcc9d..e2c815ee06d0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -34,6 +34,9 @@ static void nft_exthdr_eval(const struct nft_expr *expr,
 	unsigned int offset = 0;
 	int err;
 
+	if (pkt->skb->protocol != htons(ETH_P_IPV6))
+		goto err;
+
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (err < 0)
 		goto err;
-- 
2.30.2



