Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF7F23A681
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgHCMsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgHCMYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A7C204EC;
        Mon,  3 Aug 2020 12:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457488;
        bh=kTonF4eWHt52DeZ898QNeEouGbHV74JSsFJIkPdxvng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7hQGxyvKmhr4x3pH+WryWl3s7XYGLDc+5BouJYnxYfKOWIxF9EF8OFcv9T/tt3a0
         2uR8KSacrxOL52YFD05GnQNCKEI1MoXLhjOGPNr47HGD6nhu90ggPMKEOde17zV3UA
         aaBgyBFHDhaY/90NE6Dj/LzZF4by7nDL5dHI9Yec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Lu Wei <luwei32@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 086/120] net: nixge: fix potential memory leak in nixge_probe()
Date:   Mon,  3 Aug 2020 14:19:04 +0200
Message-Id: <20200803121907.059730829@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 366228ed01f6882cc203e3d5b40010dfae0be1c3 ]

If some processes in nixge_probe() fail, free_netdev(dev)
needs to be called to aviod a memory leak.

Fixes: 87ab207981ec ("net: nixge: Separate ctrl and dma resources")
Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 2fdd0753b3afd..0e776131a3ef3 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1298,19 +1298,21 @@ static int nixge_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &priv->napi, nixge_poll, NAPI_POLL_WEIGHT);
 	err = nixge_of_get_resources(pdev);
 	if (err)
-		return err;
+		goto free_netdev;
 	__nixge_hw_set_mac_address(ndev);
 
 	priv->tx_irq = platform_get_irq_byname(pdev, "tx");
 	if (priv->tx_irq < 0) {
 		netdev_err(ndev, "could not find 'tx' irq");
-		return priv->tx_irq;
+		err = priv->tx_irq;
+		goto free_netdev;
 	}
 
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx");
 	if (priv->rx_irq < 0) {
 		netdev_err(ndev, "could not find 'rx' irq");
-		return priv->rx_irq;
+		err = priv->rx_irq;
+		goto free_netdev;
 	}
 
 	priv->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
-- 
2.25.1



