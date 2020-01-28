Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251DB14BAEE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgA1OMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgA1OMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:12:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505392468A;
        Tue, 28 Jan 2020 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220755;
        bh=VH3Bij5zgMyfH1s4oU+Dx0I4FOa5rMtwEj5H9Y0PFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3WHfsLY+syEpGzrbSfDhu/NsEeJzskZz0AQZ3jPoHbhFurh1POrSy+ZpKugBChzh
         vVtH211j4+9P6yBtAumICmRocPv9GPuOh1DUNQfialACGKR2eV0hK0QMv4oWgwl2Td
         DCahJonzNKvWAUz9kCT5iUOw86n6bhaJiSk5Dv2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 134/183] net: sonic: return NETDEV_TX_OK if failed to map buffer
Date:   Tue, 28 Jan 2020 15:05:53 +0100
Message-Id: <20200128135843.178628972@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit 6e1cdedcf0362fed3aedfe051d46bd7ee2a85fe1 ]

NETDEV_TX_BUSY really should only be used by drivers that call
netif_tx_stop_queue() at the wrong moment. If dma_map_single() is
failed to map tx DMA buffer, it might trigger an infinite loop.
This patch use NETDEV_TX_OK instead of NETDEV_TX_BUSY, and change
printk to pr_err_ratelimited.

Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 0798b4adb0394..b5f1f4ea9d4a3 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -221,9 +221,9 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
 	if (!laddr) {
-		printk(KERN_ERR "%s: failed to map tx DMA buffer.\n", dev->name);
+		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb(skb);
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
 
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
-- 
2.20.1



