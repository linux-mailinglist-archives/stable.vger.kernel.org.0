Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45EC101630
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbfKSFvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbfKSFu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:50:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F6B20862;
        Tue, 19 Nov 2019 05:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142658;
        bh=M2yOs9afGDUJ0xsdPlqgFgcEldyZBxj7OSIeQV5vXzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjrftUXJ9ruN+Z11DJt1ckeNLnpySrNt3vJG8+uHCd/HKey9cJVO/O4gBpdIjOkcm
         z8mJ6T0tS9Y6vLn0uRrtgB/H4CgcEZf/ur5wDzPBcpZ9l9lwjL97tHvGdiwZEEX7t3
         j/hdiEkxP6OJklsksAMi4t3k9sAOOEzZQdvA89Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/239] nfp: provide a better warning when ring allocation fails
Date:   Tue, 19 Nov 2019 06:19:15 +0100
Message-Id: <20191119051332.996563602@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 23d9f5531c7c28546954b0bf332134a9b8a38c0a ]

NFP supports fairly enormous ring sizes (up to 256k descriptors).
In commit 466271703867 ("nfp: use kvcalloc() to allocate SW buffer
descriptor arrays") we have started using kvcalloc() functions to
make sure the allocation of software state arrays doesn't hit
the MAX_ORDER limit.  Unfortunately, we can't use virtual mappings
for the DMA region holding HW descriptors.  In case this allocation
fails instead of the generic (and fairly scary) warning/splat in
the logs print a helpful message explaining what happened and
suggesting how to fix it.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c  | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 6df2c8b2ce6f3..bffa25d6dc294 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2169,9 +2169,13 @@ nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 
 	tx_ring->size = sizeof(*tx_ring->txds) * tx_ring->cnt;
 	tx_ring->txds = dma_zalloc_coherent(dp->dev, tx_ring->size,
-					    &tx_ring->dma, GFP_KERNEL);
-	if (!tx_ring->txds)
+					    &tx_ring->dma,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!tx_ring->txds) {
+		netdev_warn(dp->netdev, "failed to allocate TX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    tx_ring->cnt);
 		goto err_alloc;
+	}
 
 	sz = sizeof(*tx_ring->txbufs) * tx_ring->cnt;
 	tx_ring->txbufs = kzalloc(sz, GFP_KERNEL);
@@ -2314,9 +2318,13 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 	rx_ring->cnt = dp->rxd_cnt;
 	rx_ring->size = sizeof(*rx_ring->rxds) * rx_ring->cnt;
 	rx_ring->rxds = dma_zalloc_coherent(dp->dev, rx_ring->size,
-					    &rx_ring->dma, GFP_KERNEL);
-	if (!rx_ring->rxds)
+					    &rx_ring->dma,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!rx_ring->rxds) {
+		netdev_warn(dp->netdev, "failed to allocate RX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    rx_ring->cnt);
 		goto err_alloc;
+	}
 
 	sz = sizeof(*rx_ring->rxbufs) * rx_ring->cnt;
 	rx_ring->rxbufs = kzalloc(sz, GFP_KERNEL);
-- 
2.20.1



