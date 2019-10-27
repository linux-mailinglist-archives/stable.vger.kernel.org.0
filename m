Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A73E6727
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbfJ0VSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbfJ0VSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:33 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5029A20717;
        Sun, 27 Oct 2019 21:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211111;
        bh=WxL+isxSLqVyP/vPvSWCFfVBslLsA4hnCVMimY/E5uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmm4rxFjhnhVaXTwYxXoynRFyS+e8Ut7ARuoHN9ARuNwRBaVVmuiUuAE9maQN5pst
         1Ek93tztsuEpM7NorC3Ap5glm/QfEGdc273IBwteSKxZOBtbpK8HG6AlPGR+1HIkIq
         +x8Tm9QijLdH5IOebteGc8b6mvkg1nnuRQoju5Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Garcia Liebana <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 035/197] netfilter: nft_connlimit: disable bh on garbage collection
Date:   Sun, 27 Oct 2019 21:59:13 +0100
Message-Id: <20191027203353.623742303@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 34a4c95abd25ab41fb390b985a08a651b1fa0b0f ]

BH must be disabled when invoking nf_conncount_gc_list() to perform
garbage collection, otherwise deadlock might happen.

  nf_conncount_add+0x1f/0x50 [nf_conncount]
  nft_connlimit_eval+0x4c/0xe0 [nft_connlimit]
  nft_dynset_eval+0xb5/0x100 [nf_tables]
  nft_do_chain+0xea/0x420 [nf_tables]
  ? sch_direct_xmit+0x111/0x360
  ? noqueue_init+0x10/0x10
  ? __qdisc_run+0x84/0x510
  ? tcp_packet+0x655/0x1610 [nf_conntrack]
  ? ip_finish_output2+0x1a7/0x430
  ? tcp_error+0x130/0x150 [nf_conntrack]
  ? nf_conntrack_in+0x1fc/0x4c0 [nf_conntrack]
  nft_do_chain_ipv4+0x66/0x80 [nf_tables]
  nf_hook_slow+0x44/0xc0
  ip_rcv+0xb5/0xd0
  ? ip_rcv_finish_core.isra.19+0x360/0x360
  __netif_receive_skb_one_core+0x52/0x70
  netif_receive_skb_internal+0x34/0xe0
  napi_gro_receive+0xba/0xe0
  e1000_clean_rx_irq+0x1e9/0x420 [e1000e]
  e1000e_poll+0xbe/0x290 [e1000e]
  net_rx_action+0x149/0x3b0
  __do_softirq+0xde/0x2d8
  irq_exit+0xba/0xc0
  do_IRQ+0x85/0xd0
  common_interrupt+0xf/0xf
  </IRQ>
  RIP: 0010:nf_conncount_gc_list+0x3b/0x130 [nf_conncount]

Fixes: 2f971a8f4255 ("netfilter: nf_conncount: move all list iterations under spinlock")
Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_connlimit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index af1497ab94642..69d6173f91e2b 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -218,8 +218,13 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
+	bool ret;
 
-	return nf_conncount_gc_list(net, &priv->list);
+	local_bh_disable();
+	ret = nf_conncount_gc_list(net, &priv->list);
+	local_bh_enable();
+
+	return ret;
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.20.1



