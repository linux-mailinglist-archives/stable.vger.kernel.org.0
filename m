Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C23DD991
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhHBOBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236592AbhHBN7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE486113D;
        Mon,  2 Aug 2021 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912555;
        bh=5j7qW1QDc9cb8oLFv3IHKytcCPufOrNjkEtox/G9Hho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uysZ01csHn7mvyA7w1PG5wL+7gJMsbLAeL3rT4vUG00xSx1SoEW63Q5apgTgvHuAD
         uAPSzn9G7aDu7Tlq9sfyhQUKszklVf9QTqPV/PzRX3tab/XpZ7xNCRcDbp9yEHgR3c
         oCm28Kl6zxyMXcBk/rIswjOMyhvH8a5qUCV7/o9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 044/104] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Mon,  2 Aug 2021 15:44:41 +0200
Message-Id: <20210802134345.477988060@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
index 0840c635b752..be1595d6979d 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -201,7 +201,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		alen = sizeof_field(struct nf_nat_range, min_addr.ip6);
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



