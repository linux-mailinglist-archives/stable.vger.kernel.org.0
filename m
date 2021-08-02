Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753E43DD7E6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhHBNs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhHBNrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1CB61106;
        Mon,  2 Aug 2021 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912052;
        bh=8G3Wb+6OXBJJ4C+pVYqw5cEC5/+uqdpJgwVsGIa16sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUoxLgaMhmG0MtpIk5a5mugFjWgU6HHmbe8ywl3545Lu9dqMMy1yJNyKASRAOxjYG
         03Is19+cEvPc+z5rDdDwQxH2ubnuCu2JU7SXTL3o22YWM3T5qw9A2BDt3aDqdlwoSV
         J/ReJzp+vLOYGzcFtCrPCD2AX1i1M3IDLobMYAEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/32] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Mon,  2 Aug 2021 15:44:46 +0200
Message-Id: <20210802134333.748856187@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a33f387ecd5aafae514095c2c4a8c24f7aea7e8b ]

nft_nat reports a bogus EAFNOSUPPORT if no layer 3 information is specified.

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index d2510e432c18..d338d69a0e0b 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -157,7 +157,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		alen = FIELD_SIZEOF(struct nf_nat_range, min_addr.ip6);
 		break;
 	default:
-		return -EAFNOSUPPORT;
+		if (tb[NFTA_NAT_REG_ADDR_MIN])
+			return -EAFNOSUPPORT;
+		break;
 	}
 	priv->family = family;
 
-- 
2.30.2



