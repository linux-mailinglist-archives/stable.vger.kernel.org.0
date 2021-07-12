Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E233C53FA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349300AbhGLH4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351322AbhGLHvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C39A60241;
        Mon, 12 Jul 2021 07:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076132;
        bh=fX0+pF6/xUT7JJk46iILP4k0cW++awh9AH5CNWzFG4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGuPS9BKUqwgCmaiWpIpxsIJ6mfWP9Gx3u1W3J7LvFkS3xzTo85a5HYb6EQPTKWqw
         GkioufyialHUs2oTGI81F2QRFIvPfmCYsVkjb0PLRrWC1oCUJIOP/s0oNFsC+5ahP3
         3OMbzALBcIaqCW5fjmwuGh9VFndQqacysRcf0qOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 475/800] netfilter: nft_osf: check for TCP packet before further processing
Date:   Mon, 12 Jul 2021 08:08:18 +0200
Message-Id: <20210712061017.730398670@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index ac61f708b82d..d82677e83400 100644
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



