Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C0724BA46
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHTJ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbgHTJ7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C5B20855;
        Thu, 20 Aug 2020 09:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917547;
        bh=AfPknJHdAKb1a61IvJ8rVc97ePVa5CPPTQ/JFx7t1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKdOM1iSeznX+CzyAvPnQ/zXzQfW/YBjLEA9bX0U88JF+hgMJjUAC5EY41iDVwWvX
         hu3L5ii4mnQYChDC3uHegGFdX4iN87CVnaEW0mvgzUjV92/m1TUIEX4r8JmpNWmsuQ
         PysQiljIQVJP//JzeFIDuvYbk6dJmoILmtHlrIag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 040/212] net: ethernet: ravb: exit if re-initialization fails in tx timeout
Date:   Thu, 20 Aug 2020 11:20:13 +0200
Message-Id: <20200820091604.386819049@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 015c5d5e6aa3523c758a70eb87b291cece2dbbb4 ]

According to the report of [1], this driver is possible to cause
the following error in ravb_tx_timeout_work().

ravb e6800000.ethernet ethernet: failed to switch device to config mode

This error means that the hardware could not change the state
from "Operation" to "Configuration" while some tx and/or rx queue
are operating. After that, ravb_config() in ravb_dmac_init() will fail,
and then any descriptors will be not allocaled anymore so that NULL
pointer dereference happens after that on ravb_start_xmit().

To fix the issue, the ravb_tx_timeout_work() should check
the return values of ravb_stop_dma() and ravb_dmac_init().
If ravb_stop_dma() fails, ravb_tx_timeout_work() re-enables TX and RX
and just exits. If ravb_dmac_init() fails, just exits.

[1]
https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 545cb6262cffd..93d3152752ff4 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1444,6 +1444,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	struct ravb_private *priv = container_of(work, struct ravb_private,
 						 work);
 	struct net_device *ndev = priv->ndev;
+	int error;
 
 	netif_tx_stop_all_queues(ndev);
 
@@ -1452,15 +1453,36 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
-	ravb_stop_dma(ndev);
+	if (ravb_stop_dma(ndev)) {
+		/* If ravb_stop_dma() fails, the hardware is still operating
+		 * for TX and/or RX. So, this should not call the following
+		 * functions because ravb_dmac_init() is possible to fail too.
+		 * Also, this should not retry ravb_stop_dma() again and again
+		 * here because it's possible to wait forever. So, this just
+		 * re-enables the TX and RX and skip the following
+		 * re-initialization procedure.
+		 */
+		ravb_rcv_snd_enable(ndev);
+		goto out;
+	}
 
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
 	/* Device init */
-	ravb_dmac_init(ndev);
+	error = ravb_dmac_init(ndev);
+	if (error) {
+		/* If ravb_dmac_init() fails, descriptors are freed. So, this
+		 * should return here to avoid re-enabling the TX and RX in
+		 * ravb_emac_init().
+		 */
+		netdev_err(ndev, "%s: ravb_dmac_init() failed, error %d\n",
+			   __func__, error);
+		return;
+	}
 	ravb_emac_init(ndev);
 
+out:
 	/* Initialise PTP Clock driver */
 	if (priv->chip_id == RCAR_GEN2)
 		ravb_ptp_init(ndev, priv->pdev);
-- 
2.25.1



