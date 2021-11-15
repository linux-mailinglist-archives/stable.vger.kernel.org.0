Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A3A450BA2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbhKOR0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237455AbhKORVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C0F63269;
        Mon, 15 Nov 2021 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996721;
        bh=zUrUDR5ELm8lFu5yzsd1l9aPZSG3D1J3EhYATvNvVXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JecOTPuLMtD6jrbqaIhhp0XrleTUHlL6Azij3XDs3gT43erwRxNd24SCauXcoOmLL
         fMPLi799NOZCJz59Zshk+L9IOwVai9ypcBzq3ccnmDZxXGOK94reugl3rbgPivRW3J
         +4W6n/IxnxkJWUBJutF6MrQ+NR8Y+kqgyScvtLc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/355] netfilter: nft_dynset: relax superfluous check on set updates
Date:   Mon, 15 Nov 2021 18:02:15 +0100
Message-Id: <20211115165320.591195620@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7b1394892de8d95748d05e3ee41e85edb4abbfa1 ]

Relax this condition to make add and update commands idempotent for sets
with no timeout. The eval function already checks if the set element
timeout is available and updates it if the update command is used.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_dynset.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 95415d2b81c93..6fdea0e57db8a 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -164,17 +164,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		return -EBUSY;
 
 	priv->op = ntohl(nla_get_be32(tb[NFTA_DYNSET_OP]));
-	switch (priv->op) {
-	case NFT_DYNSET_OP_ADD:
-	case NFT_DYNSET_OP_DELETE:
-		break;
-	case NFT_DYNSET_OP_UPDATE:
-		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EOPNOTSUPP;
-		break;
-	default:
+	if (priv->op > NFT_DYNSET_OP_DELETE)
 		return -EOPNOTSUPP;
-	}
 
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
-- 
2.33.0



