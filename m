Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439703C49D4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbhGLGq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237284AbhGLGqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF42A6112D;
        Mon, 12 Jul 2021 06:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072109;
        bh=EqOVOBlPobOlKTw3Zj46xqvHEq8KJr8JVBdzSS3wo6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlFt555QmdO7A3SGmssXWunT1Owxw43XQBwxqCePoB7oGwZGVt3zu5Lfza+Ry8rXh
         BUu1cHxTrHuevATeG08add3SaVL4Rzjnn1jaNrOashpLjW0CYS64P8jLCXONMjYO2A
         mgVkS3/Ln1PXlVV3VpGrr3nOILTLk444gVc8m5No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/593] netfilter: nft_osf: check for TCP packet before further processing
Date:   Mon, 12 Jul 2021 08:08:38 +0200
Message-Id: <20210712060925.784704456@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8f518d43f89ae00b9cf5460e10b91694944ca1a8 ]

The osf expression only supports for TCP packets, add a upfront sanity
check to skip packet parsing if this is not a TCP packet.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c261d57a666a..2c957629ea66 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
+	if (pkt->tprot != IPPROTO_TCP) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
 				 sizeof(struct tcphdr), &_tcph);
 	if (!tcp) {
-- 
2.30.2



