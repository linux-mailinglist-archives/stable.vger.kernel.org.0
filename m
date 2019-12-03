Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043AF111F8B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfLCWm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfLCWmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E43C20684;
        Tue,  3 Dec 2019 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412971;
        bh=hnzD5Qk9dvKC2ddqw81JWpMv4D3eIasuXCukLFQgb6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6COuy7nTPsbiYZAe/j15QJQxqcYBHKxWOTeQJyXr8o5uPtaxJnWzncQo+g26KIvy
         gcH2ZKLWk+qEJCPbs6mbSz9Iy1PbH6nZWWetCyQaywZKl3heI+6zxQ6vkxO48nWMSm
         AgOvwBn/nbk13WTLj2Y55eH2IkULWQ+yiF4h+E3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 047/135] bridge: ebtables: dont crash when using dnat target in output chains
Date:   Tue,  3 Dec 2019 23:34:47 +0100
Message-Id: <20191203213019.004429000@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index ed91ea31978af..12a4f4d936810 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -20,7 +20,6 @@ static unsigned int
 ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
-	struct net_device *dev;
 
 	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
@@ -33,10 +32,22 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
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



