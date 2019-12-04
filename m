Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE6113491
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfLDSZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729555AbfLDSBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:22 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4466220659;
        Wed,  4 Dec 2019 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482481;
        bh=/vaTvR14aracHKWxFI1nwBvHEUr4TWkn1zIqaBp2qOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hi47oqYX4vIKYkMg3ND7lZ5/ILGp6nL2XpwGgCQZ7AYnhKDck3EKZT5wlUb02h7ZL
         pLhx4U3kwMe2kTKGn6Qz9kjLrhX6tSJDgvIN374UEEM6J9MPc1Zv7VLXjE4WciQD4J
         WEhZu/oDB4Camq7g8mllack1L8gzNtS+9Hox2lr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 014/209] bridge: ebtables: dont crash when using dnat target in output chains
Date:   Wed,  4 Dec 2019 18:53:46 +0100
Message-Id: <20191204175322.551394957@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b23c0742c2ce7e33ed79d10e451f70fdb5ca85d1 ]

xt_in() returns NULL in the output hook, skip the pkt_type change for
that case, redirection only makes sense in broute/prerouting hooks.

Reported-by: Tom Yan <tom.ty89@gmail.com>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Fixes: cf3cb246e277d ("bridge: ebtables: fix reception of frames DNAT-ed to bridge device/port")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebt_dnat.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index dfc86a0199dab..1d8c834d90189 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -19,7 +19,6 @@ static unsigned int
 ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
-	struct net_device *dev;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
@@ -32,10 +31,22 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		else
 			skb->pkt_type = PACKET_MULTICAST;
 	} else {
-		if (xt_hooknum(par) != NF_BR_BROUTING)
-			dev = br_port_get_rcu(xt_in(par))->br->dev;
-		else
+		const struct net_device *dev;
+
+		switch (xt_hooknum(par)) {
+		case NF_BR_BROUTING:
 			dev = xt_in(par);
+			break;
+		case NF_BR_PRE_ROUTING:
+			dev = br_port_get_rcu(xt_in(par))->br->dev;
+			break;
+		default:
+			dev = NULL;
+			break;
+		}
+
+		if (!dev) /* NF_BR_LOCAL_OUT */
+			return info->target;
 
 		if (ether_addr_equal(info->mac, dev->dev_addr))
 			skb->pkt_type = PACKET_HOST;
-- 
2.20.1



