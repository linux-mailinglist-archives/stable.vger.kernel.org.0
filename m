Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3632C7F43F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407091AbfHBKDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404657AbfHBJli (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:41:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F642171F;
        Fri,  2 Aug 2019 09:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738897;
        bh=i/RkCux2/qSe+RvX0SoGsoZJJS7duwt+AOFDJsmwiyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOebadgWoeXcPIwKPpYN2cCghnIc849L88mivf40130b3g6EJ2pLkHpxkFRM1TSqM
         VZqMa80RAJT3MDh48mjevHnMMgtW6A1t3b1AZ5eVJETASjmhxk5mfFDO4+2rTo33Xl
         9JmVMaPla1AmAm7sO11WrKmFkskJf0EPAKWXzPl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancock@sedsystems.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/223] net: axienet: Fix race condition causing TX hang
Date:   Fri,  2 Aug 2019 11:34:15 +0200
Message-Id: <20190802092240.953467634@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7de44285c1f69ccfbe8be1d6a16fcd956681fee6 ]

It is possible that the interrupt handler fires and frees up space in
the TX ring in between checking for sufficient TX ring space and
stopping the TX queue in axienet_start_xmit. If this happens, the
queue wake from the interrupt handler will occur before the queue is
stopped, causing a lost wakeup and the adapter's transmit hanging.

To avoid this, after stopping the queue, check again whether there is
sufficient space in the TX ring. If so, wake up the queue again.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a8afc92cbfca..5f21ddff9e0f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -612,6 +612,10 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 
 	ndev->stats.tx_packets += packets;
 	ndev->stats.tx_bytes += size;
+
+	/* Matches barrier in axienet_start_xmit */
+	smp_mb();
+
 	netif_wake_queue(ndev);
 }
 
@@ -666,9 +670,19 @@ static int axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (axienet_check_tx_bd_space(lp, num_frag)) {
-		if (!netif_queue_stopped(ndev))
-			netif_stop_queue(ndev);
-		return NETDEV_TX_BUSY;
+		if (netif_queue_stopped(ndev))
+			return NETDEV_TX_BUSY;
+
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in axienet_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (axienet_check_tx_bd_space(lp, num_frag))
+			return NETDEV_TX_BUSY;
+
+		netif_wake_queue(ndev);
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-- 
2.20.1



