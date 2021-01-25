Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D089830333A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbhAZEsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729998AbhAYSpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97C942083E;
        Mon, 25 Jan 2021 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600302;
        bh=Htx6PgQPWCpEABjyXQR66WLslRWX+D+EPaJOlMYiHTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJJb8xKFhYEM8cb3MmVT4OjMF+nFnC4gQKdHiivqqA+3bLPGXh9b/QOsn4oLCn0J9
         SfgFzRdbibWVwKms/cc3jeCw+XkhtVb80wt68MLCmKXxwT4I36wMXbJf++QV+9aKoH
         CS3e/+n7+sLecAzdOx2SRbdGHli6cZQWqUXEurZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/86] can: vxcan: vxcan_xmit: fix use after free bug
Date:   Mon, 25 Jan 2021 19:39:32 +0100
Message-Id: <20210125183203.169714464@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 75854cad5d80976f6ea0f0431f8cedd3bcc475cb ]

After calling netif_rx_ni(skb), dereferencing skb is unsafe.
Especially, the canfd_frame cfd which aliases skb memory is accessed
after the netif_rx_ni().

Fixes: a8f820a380a2 ("can: add Virtual CAN Tunnel driver (vxcan)")
Link: https://lore.kernel.org/r/20210120114137.200019-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/vxcan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index d6ba9426be4de..b1baa4ac1d537 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -39,6 +39,7 @@ static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_device *peer;
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	struct net_device_stats *peerstats, *srcstats = &dev->stats;
+	u8 len;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
@@ -61,12 +62,13 @@ static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->dev        = peer;
 	skb->ip_summed  = CHECKSUM_UNNECESSARY;
 
+	len = cfd->len;
 	if (netif_rx_ni(skb) == NET_RX_SUCCESS) {
 		srcstats->tx_packets++;
-		srcstats->tx_bytes += cfd->len;
+		srcstats->tx_bytes += len;
 		peerstats = &peer->stats;
 		peerstats->rx_packets++;
-		peerstats->rx_bytes += cfd->len;
+		peerstats->rx_bytes += len;
 	}
 
 out_unlock:
-- 
2.27.0



