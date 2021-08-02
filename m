Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A413DD9BA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhHBODS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235085AbhHBOBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34E5611CC;
        Mon,  2 Aug 2021 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912590;
        bh=3LFOd4PwfknOxOLtsuVzLg1QZNOdncPJDeADEZJeLxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpAhsC0DbB1Ny+JNNoJw1/p/CT2yCT/ltSyIbTDcjePiWki2sDAvn+D6mhKzDReKa
         wA3E63ejizTzQuBB2n8dQ5ByJ0+fhb6nzhzA+bYIgwuAo6OKSci6Ei1MRIzMED5mSg
         HN0MNYl5pK4M3RZctp1f33Tj9vzjT1IDd1L8Z5XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/104] octeontx2-pf: Fix interface down flag on error
Date:   Mon,  2 Aug 2021 15:44:59 +0200
Message-Id: <20210802134346.036098009@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 69f0aeb13bb548e2d5710a350116e03f0273302e ]

In the existing code while changing the number of TX/RX
queues using ethtool the PF/VF interface resources are
freed and reallocated (otx2_stop and otx2_open is called)
if the device is in running state. If any resource allocation
fails in otx2_open, driver free already allocated resources
and return. But again, when the number of queues changes
as the device state still running oxt2_stop is called.
In which we try to free already freed resources leading
to driver crash.
This patch fixes the issue by setting the INTF_DOWN flag on
error and free the resources in otx2_stop only if the flag is
not set.

Fixes: 50fe6c02e5ad ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 7 +++----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      | 5 +++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 9d9a2e438acf..ae06eeeb5a45 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -292,15 +292,14 @@ static int otx2_set_channels(struct net_device *dev,
 	err = otx2_set_real_num_queues(dev, channel->tx_count,
 				       channel->rx_count);
 	if (err)
-		goto fail;
+		return err;
 
 	pfvf->hw.rx_queues = channel->rx_count;
 	pfvf->hw.tx_queues = channel->tx_count;
 	pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
 
-fail:
 	if (if_up)
-		dev->netdev_ops->ndo_open(dev);
+		err = dev->netdev_ops->ndo_open(dev);
 
 	netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
 		    pfvf->hw.tx_queues, pfvf->hw.rx_queues);
@@ -404,7 +403,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->rqe_cnt = rx_count;
 
 	if (if_up)
-		netdev->netdev_ops->ndo_open(netdev);
+		return netdev->netdev_ops->ndo_open(netdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 03004fdac0c6..2af50250d13c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1648,6 +1648,7 @@ int otx2_open(struct net_device *netdev)
 err_tx_stop_queues:
 	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
+	pf->flags |= OTX2_FLAG_INTF_DOWN;
 err_free_cints:
 	otx2_free_cints(pf, qidx);
 	vec = pci_irq_vector(pf->pdev,
@@ -1675,6 +1676,10 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
+	/* If the DOWN flag is set resources are already freed */
+	if (pf->flags & OTX2_FLAG_INTF_DOWN)
+		return 0;
+
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
-- 
2.30.2



