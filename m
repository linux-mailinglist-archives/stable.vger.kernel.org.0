Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01F53CDD3D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhGSO4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242700AbhGSOzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0176A6128C;
        Mon, 19 Jul 2021 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708811;
        bh=YWGX6vbHixNJ4drq6fflf4HzsfFUNrph8Hax0HMmA0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW96J2vbN/IPshB2JZ3B8VCP1/Mb+dhY/j+f6GoTwnrYrwd5nDs3shq8TfX3AGT0F
         AX/+7ROkIblmmwieydhNMdsiItAPI2mVR87j1uadSjVx3ILuZ/aZcriNznnbRGERPl
         Qqu48OcBo1TaxmE45TzJxeCq3fzJ+62DFQJ/9lDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/421] netfilter: nft_osf: check for TCP packet before further processing
Date:   Mon, 19 Jul 2021 16:49:09 +0200
Message-Id: <20210719144951.288826253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index a003533ff4d9..e259454b6a64 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -22,6 +22,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct tcphdr _tcph;
 	const char *os_name;
 
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



