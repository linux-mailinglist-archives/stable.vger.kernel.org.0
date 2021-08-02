Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578383DD8EC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhHBNzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236138AbhHBNzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFF661101;
        Mon,  2 Aug 2021 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912406;
        bh=9eraPd7F0GpE6e0FfPsLMF2EuL8kWXIqoMRRAsaVHqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKXIWTvCZ9EsrF8EyK09Wv/kJ9xg4W5LFH2QL9ZekCoHlccipKNE7p93qKa4biZVi
         UdECTjBxelObgPaNuwiKUi8yhGJOqHN4WEH6eh+KvrN3OjWpePeJycd2TdnWmK09Ur
         0rWC5T4NnLJbBW+bkEI2fitEjGyU5vdka11IEykE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/67] octeontx2-pf: Fix interface down flag on error
Date:   Mon,  2 Aug 2021 15:45:08 +0200
Message-Id: <20210802134340.561715991@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
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
index 662fb80dbb9d..c6d408de0605 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -230,15 +230,14 @@ static int otx2_set_channels(struct net_device *dev,
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
@@ -342,7 +341,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->rqe_cnt = rx_count;
 
 	if (if_up)
-		netdev->netdev_ops->ndo_open(netdev);
+		return netdev->netdev_ops->ndo_open(netdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9fef9be015e5..044a5b1196ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1592,6 +1592,7 @@ int otx2_open(struct net_device *netdev)
 err_tx_stop_queues:
 	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
+	pf->flags |= OTX2_FLAG_INTF_DOWN;
 err_free_cints:
 	otx2_free_cints(pf, qidx);
 	vec = pci_irq_vector(pf->pdev,
@@ -1619,6 +1620,10 @@ int otx2_stop(struct net_device *netdev)
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



