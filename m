Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975B916769D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbgBUIgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731492AbgBUIFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13749222C4;
        Fri, 21 Feb 2020 08:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272343;
        bh=wySVuzOAKsVfP2zWPLQgRaUCUUY7XFfw5EC5uuHR3qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUxByzR1X1yXH0FoWJZ81OQ3U5DcLH61mFDfjHVD5pVWP65SNV0bbsPwSvRXu6FXa
         TifsYVdpAKzbUviXK6m5FH+e68DVPegoMhhWAU+3JKUXhhhmbfYwgw4xVLBCufNjxq
         cFraDjtdMNdLi+V/VI1bLqe694MrFHTup1Jp79eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/344] wan/hdlc_x25: fix skb handling
Date:   Fri, 21 Feb 2020 08:37:50 +0100
Message-Id: <20200221072355.441387749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 953c4a08dfc9ffe763a8340ac10f459d6c6cc4eb ]

o call skb_reset_network_header() before hdlc->xmit()
 o change skb proto to HDLC (0x0019) before hdlc->xmit()
 o call dev_queue_xmit_nit() before hdlc->xmit()

This changes make it possible to trace (tcpdump) outgoing layer2
(ETH_P_HDLC) packets

Additionally call skb_reset_network_header() after each skb_push() /
skb_pull().

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 5643675ff7241..bf78073ee7fd9 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -62,11 +62,12 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	unsigned char *ptr;
 
-	skb_push(skb, 1);
-
 	if (skb_cow(skb, 1))
 		return NET_RX_DROP;
 
+	skb_push(skb, 1);
+	skb_reset_network_header(skb);
+
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
 
@@ -79,6 +80,13 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+
+	skb_reset_network_header(skb);
+	skb->protocol = hdlc_type_trans(skb, dev);
+
+	if (dev_nit_active(dev))
+		dev_queue_xmit_nit(skb, dev);
+
 	hdlc->xmit(skb, dev); /* Ignore return value :-( */
 }
 
@@ -93,6 +101,7 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
+		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
-- 
2.20.1



