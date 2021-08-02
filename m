Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1513DD7D6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhHBNsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhHBNr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC300610FD;
        Mon,  2 Aug 2021 13:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912065;
        bh=joNAro/gVbiWLdK5wZF5BtH/rSA25Lcax58mBxFIgHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfd1SE7j4+ChRjH1IPt5sc9fU6WM5c32VtOMsKYK1eGCS8NVzuLFjF67hVFwSO1RC
         pf8p7nikD7YwYyjR+HCs4xpdwneDr/YYytGPjhBLAAy3e30Ws5RtvMRaVIQxVL8/Mb
         4gtU2OfqZAhY3W/C5bLSlw/sfQlLl8qOduvOnURY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 32/32] sis900: Fix missing pci_disable_device() in probe and remove
Date:   Mon,  2 Aug 2021 15:44:52 +0200
Message-Id: <20210802134333.940594691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 89fb62fde3b226f99b7015280cf132e2a7438edf ]

Replace pci_enable_device() with pcim_enable_device(),
pci_disable_device() and pci_release_regions() will be
called in release automatically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sis/sis900.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index ae9b983e8e5c..4a0e69a2d4f5 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -442,7 +442,7 @@ static int sis900_probe(struct pci_dev *pci_dev,
 #endif
 
 	/* setup various bits in PCI command register */
-	ret = pci_enable_device(pci_dev);
+	ret = pcim_enable_device(pci_dev);
 	if(ret) return ret;
 
 	i = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
@@ -468,7 +468,7 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	ioaddr = pci_iomap(pci_dev, 0, 0);
 	if (!ioaddr) {
 		ret = -ENOMEM;
-		goto err_out_cleardev;
+		goto err_out;
 	}
 
 	sis_priv = netdev_priv(net_dev);
@@ -576,8 +576,6 @@ err_unmap_tx:
 		sis_priv->tx_ring_dma);
 err_out_unmap:
 	pci_iounmap(pci_dev, ioaddr);
-err_out_cleardev:
-	pci_release_regions(pci_dev);
  err_out:
 	free_netdev(net_dev);
 	return ret;
@@ -2425,7 +2423,6 @@ static void sis900_remove(struct pci_dev *pci_dev)
 		sis_priv->tx_ring_dma);
 	pci_iounmap(pci_dev, sis_priv->ioaddr);
 	free_netdev(net_dev);
-	pci_release_regions(pci_dev);
 }
 
 #ifdef CONFIG_PM
-- 
2.30.2



