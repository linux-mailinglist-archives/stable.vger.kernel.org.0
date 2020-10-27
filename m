Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A3E29B0E6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900745AbgJ0OY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368336AbgJ0OY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4B82072D;
        Tue, 27 Oct 2020 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808697;
        bh=UC1q3kDNRZBss0V/M47wkAQAkEjiHoGZBjWNlr76+Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWPtjaf4DLQQV9a8SDwzzJxWNi4WlgtXigkc1wfjm/IslsHOmyt4z6aX+L+sL2zTw
         tdYcrYLXopn3mK3BU5UfFfHJdagS7OLa1qkA/nBusDF8b5C4Ng0ky6XgTN1C+795eg
         jrQjJWzu+KTlvSOJGLEyQzfVpY81TUgRA98+FgPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/264] netfilter: nf_fwd_netdev: clear timestamp in forwarding path
Date:   Tue, 27 Oct 2020 14:54:08 +0100
Message-Id: <20201027135439.583643640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c77761c8a59405cb7aa44188b30fffe13fbdd02d ]

Similar to 7980d2eabde8 ("ipvs: clear skb->tstamp in forwarding path").
fq qdisc requires tstamp to be cleared in forwarding path.

Fixes: 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths")
Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_dup_netdev.c  | 1 +
 net/netfilter/nft_fwd_netdev.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index f4a566e672135..98d117f3340ce 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -21,6 +21,7 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
 		skb_push(skb, skb->mac_len);
 
 	skb->dev = dev;
+	skb->tstamp = 0;
 	dev_queue_xmit(skb);
 }
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 649edbe77a205..10a12e0949299 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -129,6 +129,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		return;
 
 	skb->dev = dev;
+	skb->tstamp = 0;
 	neigh_xmit(neigh_table, dev, addr, skb);
 out:
 	regs->verdict.code = verdict;
-- 
2.25.1



