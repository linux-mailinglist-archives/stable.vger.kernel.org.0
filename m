Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255AEACE63
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfIHMr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730670AbfIHMr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:27 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9B2218AC;
        Sun,  8 Sep 2019 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946847;
        bh=SAHsHnMvyscJ7r82CopdaOIYpTmE+pyunMQT2p9mYVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkv4jSiTT/hZkVgxIPI9w5ArJKwejJwyAMEw9tu+UuU5w5aZkA8k1X816WqklHymP
         vEMCdXJ5Y7Xhfc9aNHTegrIIbOqm37KB8Y15FocBes0JapnFhb3JGkJ/ToHfttSlks
         a56Le9uqVgmtcRtNIymngf1pnPZ8H55NicNzkfys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/57] netfilter: nft_flow_offload: skip tcp rst and fin packets
Date:   Sun,  8 Sep 2019 13:41:46 +0100
Message-Id: <20190908121134.633656644@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dfe42be15fde16232340b8b2a57c359f51cc10d9 ]

TCP rst and fin packets do not qualify to place a flow into the
flowtable. Most likely there will be no more packets after connection
closure. Without this patch, this flow entry expires and connection
tracking picks up the entry in ESTABLISHED state using the fixup
timeout, which makes this look inconsistent to the user for a connection
that is actually already closed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6e0c26025ab13..69decbe2c9884 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -71,11 +71,11 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	struct tcphdr _tcph, *tcph = NULL;
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
-	bool is_tcp = false;
 	struct nf_conn *ct;
 	int ret;
 
@@ -88,7 +88,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
-		is_tcp = true;
+		tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff,
+					  sizeof(_tcph), &_tcph);
+		if (unlikely(!tcph || tcph->fin || tcph->rst))
+			goto out;
 		break;
 	case IPPROTO_UDP:
 		break;
@@ -115,7 +118,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
-	if (is_tcp) {
+	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
-- 
2.20.1



