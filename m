Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED751331E8
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgAGVFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgAGVFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3A620678;
        Tue,  7 Jan 2020 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431121;
        bh=X/6xvICbw8hI0o2RYXjRcQM+iteqfLO9+pizoBcrLNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nemj3vooMIMPc6gVkWJBurGwAg8sHzbyPxHAVRx8hilTotuss1FWOzuD55d1I0lVJ
         ubPBJG4WiPssHKaWP4zKvJk9arUVD3apkSDumlCK3pcnwLN4nTDhD7oeyS+6y0IpLn
         t4OYja0T/QJzDqXPMIiMBBX2o/FSmRkRdyLE28l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/115] netfilter: nft_tproxy: Fix port selector on Big Endian
Date:   Tue,  7 Jan 2020 21:54:11 +0100
Message-Id: <20200107205301.834289203@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 8cb4ec44de42b99b92399b4d1daf3dc430ed0186 ]

On Big Endian architectures, u16 port value was extracted from the wrong
parts of u32 sreg_port, just like commit 10596608c4d62 ("netfilter:
nf_tables: fix mismatch in big-endian system") describes.

Fixes: 4ed8eb6570a49 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Florian Westphal <fw@strlen.de>
Acked-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tproxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f92a82c73880..95980154ef02 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -50,7 +50,7 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -117,7 +117,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.20.1



