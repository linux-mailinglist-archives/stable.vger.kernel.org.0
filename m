Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01A6450DDE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbhKOSIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5575963350;
        Mon, 15 Nov 2021 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997876;
        bh=Pn5CN1leSWAeKcMEAOS0osKrNufGb3AMkAW1MPGCqsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrNnSzTEODlnEXKXgLi4Wei0xvkv0MdIxt1uJFZINgj8MLstQICYmeqv987W8d8aO
         WmryK5LVPng1PMjsaEGBLhGPFUeyn111bpCRmW7ES8ELl2aNheRpFbFOnvqb2eahY1
         sUiV7/nCfk09VupzPO35aMQogt9EiVBJerVKvODc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/575] netfilter: nft_dynset: relax superfluous check on set updates
Date:   Mon, 15 Nov 2021 18:00:32 +0100
Message-Id: <20211115165354.404614027@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 5c84a968dae29..58904bee1a0df 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -141,17 +141,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
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



