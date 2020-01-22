Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D051450E0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgAVJuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732216AbgAVJiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAC682467F;
        Wed, 22 Jan 2020 09:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685931;
        bh=gOoqDapAgWemltSr8xNI+gVi5z+jdsz65BF+ESTxLRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+7MicaACCjkAQO1uSZP3P3QyD+NETLlOuYqLM4bnhAaXENhRd+gOeBboaqP7iOxn
         GyTabsLLO8+F9uc9EyoHuz1ZYmO5KoCYf/4B5/Cg9ck4Ye9cHQTL90SIxeeBYzZBDq
         1nNB3ua/Uxk6bEqdMrkF5gYQq58NCFxeWWWOnhBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jurgen Van Ham <juvanham@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/65] macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
Date:   Wed, 22 Jan 2020 10:29:26 +0100
Message-Id: <20200122092756.869503775@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1712b2fff8c682d145c7889d2290696647d82dab ]

I missed the fact that macvlan_broadcast() can be used both
in RX and TX.

skb_eth_hdr() makes only sense in TX paths, so we can not
use it blindly in macvlan_broadcast()

Fixes: 96cc4b69581d ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jurgen Van Ham <juvanham@gmail.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -263,7 +263,7 @@ static void macvlan_broadcast(struct sk_
 			      struct net_device *src,
 			      enum macvlan_mode mode)
 {
-	const struct ethhdr *eth = skb_eth_hdr(skb);
+	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
 	struct sk_buff *nskb;
 	unsigned int i;
@@ -515,10 +515,11 @@ static int macvlan_queue_xmit(struct sk_
 	const struct macvlan_dev *dest;
 
 	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
-		const struct ethhdr *eth = (void *)skb->data;
+		const struct ethhdr *eth = skb_eth_hdr(skb);
 
 		/* send to other bridge ports directly */
 		if (is_multicast_ether_addr(eth->h_dest)) {
+			skb_reset_mac_header(skb);
 			macvlan_broadcast(skb, port, dev, MACVLAN_MODE_BRIDGE);
 			goto xmit_world;
 		}


