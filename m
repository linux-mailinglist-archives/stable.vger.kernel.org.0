Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788F3148136
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbgAXLSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390583AbgAXLSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A14720708;
        Fri, 24 Jan 2020 11:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864679;
        bh=3NiqEoj2Y5pVgGxdEdDMggCoFAh4dCge3GczTBOPzQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0V1hV73wvLAQr8qwyi8Tf3swvK2icfBbAwLf9LcP/3qD8kw/8W4+ka/Su22iCa/YE
         SrQ6lpA7P5sP0/FmM3ETxiVe3gpJfVh6ycb9J5K+gO9lofJ6SyVsy9f6RHjFuBVOHK
         lGSbZtkAcL0MUCIvNpn+HHJ5RLCL1g/wriwpe2xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 335/639] netfilter: nft_flow_offload: add entry to flowtable after confirmation
Date:   Fri, 24 Jan 2020 10:28:25 +0100
Message-Id: <20200124093129.078918958@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 270a8a297f42ecff82060aaa53118361f09c1f7d ]

This is fixing flow offload for UDP traffic where packets only follow
one single direction.

The flow_offload_fixup_tcp() mechanism works fine in case that the
offloaded entry remains in SYN_RECV state, given sequence tracking is
reset and that conntrack handles syn+ack packets as a retransmission, ie.

	sES + synack => sIG

for reply traffic.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 1ef8cb789c41a..166edea0e4527 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -103,8 +103,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	    ct->status & IPS_SEQ_ADJUST)
 		goto out;
 
-	if (ctinfo == IP_CT_NEW ||
-	    ctinfo == IP_CT_RELATED)
+	if (!nf_ct_is_confirmed(ct))
 		goto out;
 
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
-- 
2.20.1



