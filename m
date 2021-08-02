Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F0A3DD807
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhHBNtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234655AbhHBNtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA12610A2;
        Mon,  2 Aug 2021 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912130;
        bh=5sT6IPa0R3i6SC+ECb6Kd3jrWd0vH06MCPYzrXHaFQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A84OkxJ+WJ2gLOMuXXx2TMw3CoQrvXsWCnlZtASkbFP3zfsp06vue2MAIVBT+XxdO
         cvLOxJsq9OpzbVCgekjDxi/KJS5F5MxZC8QWAAvMoe+YNK4Ru0vQMG4607wpVaPQfd
         h28xXfyReqTZG/4d9a4rouvKhTjv9ZrK+sRc+4Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/38] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Mon,  2 Aug 2021 15:44:51 +0200
Message-Id: <20210802134335.744303273@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
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
index a18cceecef88..04dd813ed775 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -153,7 +153,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
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



