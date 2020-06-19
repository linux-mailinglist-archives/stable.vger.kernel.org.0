Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8CE2018CA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405974AbgFSQwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387744AbgFSOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:37:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC392070A;
        Fri, 19 Jun 2020 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577457;
        bh=YMVGyMftjFCL29CHvdRJ5Ees7rM6CcvpjSQgTN+22Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHIR1v1z+91iv8DblnSxniNYUfBOvo8wA/iVNDnVv3pfltsXsuGb20jZcvqvITrXI
         nHr/bkS+u1B3mL22p8BbPugrJXLbTV4zkB9ynfIgpRanaH6ISJ7DDh07AeVtIk4sZs
         JF+68chBRRJ4l2RVKWA57yr+dHxPfa3mGSMAwinc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/101] netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported
Date:   Fri, 19 Jun 2020 16:32:47 +0200
Message-Id: <20200619141617.086636254@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d7c83463fdf7841350f37960a7abadd3e650b41 ]

Instead of EINVAL which should be used for malformed netlink messages.

Fixes: eb31628e37a0 ("netfilter: nf_tables: Add support for IPv6 NAT")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d71753746..868480b83649 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -135,7 +135,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->type = NF_NAT_MANIP_DST;
 		break;
 	default:
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	err = nft_nat_validate(ctx, expr, NULL);
@@ -206,7 +206,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (tb[NFTA_NAT_FLAGS]) {
 		priv->flags = ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
 		if (priv->flags & ~NF_NAT_RANGE_MASK)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
-- 
2.25.1



