Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C472472FE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403875AbgHQSty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387635AbgHQPyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FD620729;
        Mon, 17 Aug 2020 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679647;
        bh=lxJmkJbciIbSE8r9qbKuRDh+Fx1MAM8KlWvJ5hIi8lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgJYRovB8wAzOebIVuZ/YEhFPySuNKPU2YTe4jXFAlF/JxginwNFm8PSf8K89+umO
         08r3zkSUXlAS9stcSSyN6U716NfYVx8LSYZpZhZa/3dSpTJGL1ygSocBRlvMCRf4Fx
         3Q40815F/3drmzNuxaOOnI8EvjqhTTauG6qhHIT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Demi M. Obenour" <demiobenour@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 285/393] netfilter: nft_meta: fix iifgroup matching
Date:   Mon, 17 Aug 2020 17:15:35 +0200
Message-Id: <20200817143833.447081629@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 78470d9d0d9f2f8d16f28382a4071568e839c0d5 ]

iifgroup matching erroneously checks the output interface.

Fixes: 8724e819cc9a ("netfilter: nft_meta: move all interface related keys to helper")
Reported-by: Demi M. Obenour <demiobenour@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 951b6e87ed5d9..7bc6537f3ccb5 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -253,7 +253,7 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 			return false;
 		break;
 	case NFT_META_IIFGROUP:
-		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+		if (!nft_meta_store_ifgroup(dest, nft_in(pkt)))
 			return false;
 		break;
 	case NFT_META_OIFGROUP:
-- 
2.25.1



