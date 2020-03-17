Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2C1881EA
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCQK4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgCQK4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF19B20735;
        Tue, 17 Mar 2020 10:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442576;
        bh=gHOt1FK61dAdNJn82T3HA6sNEEu939tqNP5tA+pYTBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzHaDvxSlxnFtkpOd0ZsnbJvafkZTSZ3EsWqunmnnWKrGjfdDv0FEXGiszlAAGGmJ
         uncDru5NgaAiUvxUnSQib4LGBk7BPjzVquh+0yZvpghqFmADqXmermdNlX2s0Ru5z8
         1u7DsEqh7lDIGBGmkCNdt/XMACz9W2TmtBDnwItY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/89] ipvlan: dont deref eth hdr before checking its set
Date:   Tue, 17 Mar 2020 11:54:19 +0100
Message-Id: <20200317103301.062493650@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit ad8192767c9f9cf97da57b9ffcea70fb100febef ]

IPvlan in L3 mode discards outbound multicast packets but performs
the check before ensuring the ether-header is set or not. This is
an error that Eric found through code browsing.

Fixes: 2ad7bf363841 (“ipvlan: Initial check-in of the IPVLAN driver.”)
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipvlan/ipvlan_core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -505,19 +505,21 @@ static int ipvlan_process_outbound(struc
 	struct ethhdr *ethh = eth_hdr(skb);
 	int ret = NET_XMIT_DROP;
 
-	/* In this mode we dont care about multicast and broadcast traffic */
-	if (is_multicast_ether_addr(ethh->h_dest)) {
-		pr_debug_ratelimited("Dropped {multi|broad}cast of type=[%x]\n",
-				     ntohs(skb->protocol));
-		kfree_skb(skb);
-		goto out;
-	}
-
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
 	 * will have L2; which need to discarded and processed further
 	 * in the net-ns of the main-device.
 	 */
 	if (skb_mac_header_was_set(skb)) {
+		/* In this mode we dont care about
+		 * multicast and broadcast traffic */
+		if (is_multicast_ether_addr(ethh->h_dest)) {
+			pr_debug_ratelimited(
+				"Dropped {multi|broad}cast of type=[%x]\n",
+				ntohs(skb->protocol));
+			kfree_skb(skb);
+			goto out;
+		}
+
 		skb_pull(skb, sizeof(*ethh));
 		skb->mac_header = (typeof(skb->mac_header))~0U;
 		skb_reset_network_header(skb);


