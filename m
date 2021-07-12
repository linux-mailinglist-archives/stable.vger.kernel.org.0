Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB7E3C53D8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345462AbhGLH4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350735AbhGLHvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C25961973;
        Mon, 12 Jul 2021 07:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076072;
        bh=3IQJ1W7w6EW+2OxO216yswM0KdnNnj2phzYTOeIckKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQiV9B9YKvJD2nxSB2Pyd7k3bOVvXCszRmUKh8bqDPVhzViEttt9ru7xvLptQiE+i
         BsPikMWqjwDrgImK9l43vnXHk7U+YplSHvaH2fALEeTytV2Jo6Z9kzdc2/Gcmn59uk
         SnJ4ta+MBi+FmJE3I7Px2VNVFUlE8mT4DDwscq9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 487/800] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Mon, 12 Jul 2021 08:08:30 +0200
Message-Id: <20210712061018.985227812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

[ Upstream commit bd70957438f0cc4879cbdff8bbc8614bc1cddf49 ]

Commit 0571a753cb07 cancelled delayed work too late, keeping small
race. Cancel work sooner to close it completely.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: 0571a753cb07 ("net: pxa168_eth: Fix a potential data race in pxa168_eth_remove")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index e967867828d8..9b48ae4bac39 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1528,6 +1528,7 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 
+	cancel_work_sync(&pep->tx_timeout_task);
 	if (pep->htpr) {
 		dma_free_coherent(pep->dev->dev.parent, HASH_ADDR_TABLE_SIZE,
 				  pep->htpr, pep->htpr_dma);
@@ -1539,7 +1540,6 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
-	cancel_work_sync(&pep->tx_timeout_task);
 	unregister_netdev(dev);
 	free_netdev(dev);
 	return 0;
-- 
2.30.2



