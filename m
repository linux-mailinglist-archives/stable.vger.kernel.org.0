Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01E3DD87F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhHBNwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234865AbhHBNve (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920BA60EBB;
        Mon,  2 Aug 2021 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912263;
        bh=vrVy1tdHGkVyIMDh8usfnUdKqBLUha627ue1VAYCnjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08Pd7rYYTfAZaPdl9rFGebQd75omgfFfHET+HDK8EBaeM7bvQGlxOO3xURNpH6iaR
         ujTTbNCW4k1z+bwpUX6Gkdt4xEUTNfOxjkHTBmbhLCUg2ibbgQj79L6Rn/BdRzNnbz
         0SGu2O405tzX4DDBy0pNtSL32Xeqgu+/NtXXQ1wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/40] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Mon,  2 Aug 2021 15:45:01 +0200
Message-Id: <20210802134336.065762007@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
index 243e8107f456..17c0f75dfcdb 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -147,7 +147,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
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



