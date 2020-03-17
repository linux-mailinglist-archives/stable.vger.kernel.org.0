Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F111891FB
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCQX1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:55 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgCQX1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oo891GI2rmEEJObksNG3mdsfLm7YBAUOfU2UppbQ39k=;
        b=G7l6f8WsPCks9SIulxxD3hIdsG9mNh2QmDhgVkOWmqeTAbTKbqyhkATalWdpwYAf50h2Ij
        A+THsRY1vtTakpKkx9lLZTPtcSAKaWObKGPRdWOBks/0DGWhK7qAgwq5jxTbpSjC1jnzxY
        9ROVZuu93pFCZWJY2T5lVGHs3w9+ydI=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 12/48] batman-adv: fix skb deref after free
Date:   Wed, 18 Mar 2020 00:26:58 +0100
Message-Id: <20200317232734.6127-13-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 63d443efe8be2c1d02b30d7e4edeb9aa085352b3 upstream.

batadv_send_skb_to_orig() calls dev_queue_xmit() so we can't use skb->len.

Fixes: 953324776d6d ("batman-adv: network coding - buffer unicast packets before forward")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/routing.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index d8a2f33e60e5..de24ab1cf67f 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -585,6 +585,7 @@ static int batadv_route_unicast_packet(struct sk_buff *skb,
 	struct batadv_unicast_packet *unicast_packet;
 	struct ethhdr *ethhdr = eth_hdr(skb);
 	int res, hdr_len, ret = NET_RX_DROP;
+	unsigned int len;
 
 	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 
@@ -625,6 +626,7 @@ static int batadv_route_unicast_packet(struct sk_buff *skb,
 	if (hdr_len > 0)
 		batadv_skb_set_priority(skb, hdr_len);
 
+	len = skb->len;
 	res = batadv_send_skb_to_orig(skb, orig_node, recv_if);
 
 	/* translate transmit result into receive result */
@@ -632,7 +634,7 @@ static int batadv_route_unicast_packet(struct sk_buff *skb,
 		/* skb was transmitted and consumed */
 		batadv_inc_counter(bat_priv, BATADV_CNT_FORWARD);
 		batadv_add_counter(bat_priv, BATADV_CNT_FORWARD_BYTES,
-				   skb->len + ETH_HLEN);
+				   len + ETH_HLEN);
 
 		ret = NET_RX_SUCCESS;
 	} else if (res == NET_XMIT_POLICED) {
-- 
2.20.1

