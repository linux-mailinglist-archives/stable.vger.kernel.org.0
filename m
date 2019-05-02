Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F1A11F7B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfEBPsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfEBPXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:23:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60F52081C;
        Thu,  2 May 2019 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810590;
        bh=VkXJd7GfaGTCPs1rwOP60Aow9q6IaXg/4ZcqNq+ta3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znZC7yxAqgSKcCi6GLwzXvtMhpZCtAoEKfkW6MdQjZOFIqRmrXpNFEhUpe0h9y2wv
         Zv0puLsyrM/taZ4iqG3U2VS+7W0OfvAmiuTbuDrPfuNF4Ry/6m7AQq6BSBC7JCA98Q
         1UXfwYKqujcoV4/ZHe8JoSqg229ggdmeMj9bzyDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.9 17/32] net: ks8851: Delay requesting IRQ until opened
Date:   Thu,  2 May 2019 17:21:03 +0200
Message-Id: <20190502143320.148720624@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d268f31552794abf5b6aa5af31021643411f25f5 ]

The ks8851 driver currently requests the IRQ before registering the
net_device.  Because the net_device name is used as IRQ name and is
still "eth%d" when the IRQ is requested, it's impossibe to tell IRQs
apart if multiple ks8851 chips are present.  Most other drivers delay
requesting the IRQ until the net_device is opened.  Do the same.

The driver doesn't enable interrupts on the chip before opening the
net_device and disables them when closing it, so there doesn't seem to
be a need to request the IRQ already on probe.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Frank Pavlic <f.pavlic@kunbus.de>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index a8c5641ff955..ff6cab4f6343 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -797,6 +797,15 @@ static void ks8851_tx_work(struct work_struct *work)
 static int ks8851_net_open(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	int ret;
+
+	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   dev->name, ks);
+	if (ret < 0) {
+		netdev_err(dev, "failed to get irq\n");
+		return ret;
+	}
 
 	/* lock the card, even if we may not actually be doing anything
 	 * else at the moment */
@@ -911,6 +920,8 @@ static int ks8851_net_stop(struct net_device *dev)
 		dev_kfree_skb(txb);
 	}
 
+	free_irq(dev->irq, ks);
+
 	return 0;
 }
 
@@ -1542,14 +1553,6 @@ static int ks8851_probe(struct spi_device *spi)
 	ks8851_read_selftest(ks);
 	ks8851_init_mac(ks);
 
-	ret = request_threaded_irq(spi->irq, NULL, ks8851_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   ndev->name, ks);
-	if (ret < 0) {
-		dev_err(&spi->dev, "failed to get irq\n");
-		goto err_irq;
-	}
-
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(&spi->dev, "failed to register network device\n");
@@ -1562,11 +1565,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	return 0;
 
-
 err_netdev:
-	free_irq(ndev->irq, ks);
-
-err_irq:
 err_id:
 	if (gpio_is_valid(gpio))
 		gpio_set_value(gpio, 0);
@@ -1587,7 +1586,6 @@ static int ks8851_remove(struct spi_device *spi)
 		dev_info(&spi->dev, "remove\n");
 
 	unregister_netdev(priv->netdev);
-	free_irq(spi->irq, priv);
 	if (gpio_is_valid(priv->gpio))
 		gpio_set_value(priv->gpio, 0);
 	regulator_disable(priv->vdd_reg);
-- 
2.19.1



