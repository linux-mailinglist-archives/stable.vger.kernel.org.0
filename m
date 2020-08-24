Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3724F4D6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgHXIld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgHXIl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:41:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FA92075B;
        Mon, 24 Aug 2020 08:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258489;
        bh=P7b8TdtssGQHKnTBQceAxyIf20el3pcU+twLqNA708M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMlBaFm5oxI68SKxGdzsBBvhUTHrh66WQMZgXQlGih9EBLtAb9rhEWTCMa3JmFSfC
         btXBcmvleWNTLA/6Bbi97H+ocH1iVUl0PyfUci+k1ZIVR5vXkhXwy4xZk/fD56ZpHJ
         r47H9jxwOdg74oVT0pIZBraBdJaxt6Yo6V9rTok4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/124] netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian
Date:   Mon, 24 Aug 2020 10:29:57 +0200
Message-Id: <20200824082412.517851225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit b428336676dbca363262cc134b6218205df4f530 ]

On big-endian machine, the returned register data when the exthdr is
present is not being compared correctly because little-endian is
assumed. The function nft_cmp_fast_mask(), called by nft_cmp_fast_eval()
and nft_cmp_fast_init(), calls cpu_to_le32().

The following dump also shows that little endian is assumed:

$ nft --debug=netlink add rule ip recordroute forward ip option rr exists counter
ip
  [ exthdr load ipv4 1b @ 7 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x01000000 ]
  [ counter pkts 0 bytes 0 ]

Lastly, debug print in nft_cmp_fast_init() and nft_cmp_fast_eval() when
RR option exists in the packet shows that the comparison fails because
the assumption:

nft_cmp_fast_init:189 priv->sreg=4 desc.len=8 mask=0xff000000 data.data[0]=0x10003e0
nft_cmp_fast_eval:57 regs->data[priv->sreg=4]=0x1 mask=0xff000000 priv->data=0x1000000

v2: use nft_reg_store8() instead (Florian Westphal). Also to avoid the
    warnings reported by kernel test robot.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 07782836fad6e..3c48cdc8935df 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -44,7 +44,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
@@ -141,7 +141,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 
 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
-- 
2.25.1



