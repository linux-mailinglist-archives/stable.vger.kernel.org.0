Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C4F2B64DA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbgKQNuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731935AbgKQNcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D402168B;
        Tue, 17 Nov 2020 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619964;
        bh=I5VsDkfZ/Kg5Wu2VzDmH8nOlDCtHDNa0Of/J8wIebE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0L3hPBTBj0C/h2uV+vl98BpnW46R54sRF2x1RleAiHn2cAuOHaWHRlZEH8xOQYdM
         Nc8wM5nOk0Pf9oUD5UsUOFBPuBj9iZHZlu2DdNsBOZmY0mVBu5+GfjHOh7CQBwuV0+
         CpAR5/a38j2Xze8EwdmyH9zzvs6ciBnabRG1Eld4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 023/255] netfilter: nftables: fix netlink report logic in flowtable and genid
Date:   Tue, 17 Nov 2020 14:02:43 +0100
Message-Id: <20201117122140.072117870@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit dceababac29d1c53cbc1f7ddf6f688d2df01da87 ]

The netlink report should be sent regardless the available listeners.

Fixes: 84d7fce69388 ("netfilter: nf_tables: export rule-set generation ID")
Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72f3ee47e478f..1c90bd1fce60c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7076,7 +7076,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 			GFP_KERNEL);
 	kfree(buf);
 
-	if (ctx->report &&
+	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
 		return;
 
@@ -7198,7 +7198,7 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
 			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
 
-	if (nlmsg_report(nlh) &&
+	if (!nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
 
-- 
2.27.0



