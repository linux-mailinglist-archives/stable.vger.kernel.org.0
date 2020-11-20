Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159FC2BA889
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgKTLI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbgKTLHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B692222F;
        Fri, 20 Nov 2020 11:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870438;
        bh=AwnE7xEz1lJBYgJlzvghGvyh64+67dao3smLqtQOII8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMJP2IzJxUiuTOzh0YRcKUSANNmWky2bELm95Ltt5TXlxl/2YnF1Vtfk3hdjg8ErN
         udRB2KDdHIt4rvZTg2AZKWkfIwuzqT19l32K/D/4NX7+lR1VjjNoGMIcib4RilG79K
         WwKBkX+UbtzewIPS0YQkVQN97siQ2g0PpYslUBTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 12/17] net: lantiq: Add locking for TX DMA channel
Date:   Fri, 20 Nov 2020 12:03:39 +0100
Message-Id: <20201120104541.666105796@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

commit f9317ae5523f99999fb54c513ebabbb2bc887ddf upstream.

The TX DMA channel data is accessed by the xrx200_start_xmit() and the
xrx200_tx_housekeeping() function from different threads. Make sure the
accesses are synchronized by acquiring the netif_tx_lock() in the
xrx200_tx_housekeeping() function too. This lock is acquired by the
kernel before calling xrx200_start_xmit().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/lantiq_xrx200.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -245,6 +245,7 @@ static int xrx200_tx_housekeeping(struct
 	int pkts = 0;
 	int bytes = 0;
 
+	netif_tx_lock(net_dev);
 	while (pkts < budget) {
 		struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->tx_free];
 
@@ -268,6 +269,7 @@ static int xrx200_tx_housekeeping(struct
 	net_dev->stats.tx_bytes += bytes;
 	netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
+	netif_tx_unlock(net_dev);
 	if (netif_queue_stopped(net_dev))
 		netif_wake_queue(net_dev);
 


