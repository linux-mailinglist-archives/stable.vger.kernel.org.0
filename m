Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB83C4E6E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbhGLHSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243582AbhGLHRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48E6611ED;
        Mon, 12 Jul 2021 07:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074095;
        bh=XKqbOAf8faM+Ie/RiraBNzC5aOntABgO/iL79yGUqx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfCiIXYN3qATAtnaa3l05IgGni8n5Tz6HWkiQGt2pCCXSthAjzLzHkbYFuSMHQ0aG
         5HqGu3imZ4Ftzreke1deR/iDmO7s9Y0WiLLguDaAAX4J30Yc6JpzSexbO3yXvAkp9I
         UdXDLkZZsopp6L1hwNHiuJTIb49kVOuubeYT20Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 463/700] net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues
Date:   Mon, 12 Jul 2021 08:09:06 +0200
Message-Id: <20210712061025.832380327@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit ce8eb4c728ef40b554b4f3d8963f11ed44502e00 ]

When changing number of TX queues using ethtool:

	# ethtool -L eth0 tx 1
	[  135.301047] Unable to handle kernel paging request at virtual address 00000000af5d0000
	[...]
	[  135.525128] Call trace:
	[  135.525142]  dma_release_from_dev_coherent+0x2c/0xb0
	[  135.525148]  dma_free_attrs+0x54/0xe0
	[  135.525156]  k3_cppi_desc_pool_destroy+0x50/0xa0
	[  135.525164]  am65_cpsw_nuss_remove_tx_chns+0x88/0xdc
	[  135.525171]  am65_cpsw_set_channels+0x3c/0x70
	[...]

This is because k3_cppi_desc_pool_destroy() which is called after
k3_udma_glue_release_tx_chn() in am65_cpsw_nuss_remove_tx_chns()
references struct device that is unregistered at the end of
k3_udma_glue_release_tx_chn()

Therefore the right order is to call k3_cppi_desc_pool_destroy() and
destroy desc pool before calling k3_udma_glue_release_tx_chn().
Fix this throughout the driver.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 638d7b03be4b..a98182b2d19b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1506,12 +1506,12 @@ static void am65_cpsw_nuss_free_tx_chns(void *data)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
-			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
-
 		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
 			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
 
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
 		memset(tx_chn, 0, sizeof(*tx_chn));
 	}
 }
@@ -1531,12 +1531,12 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 
 		netif_napi_del(&tx_chn->napi_tx);
 
-		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
-			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
-
 		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
 			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
 
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
 		memset(tx_chn, 0, sizeof(*tx_chn));
 	}
 }
@@ -1624,11 +1624,11 @@ static void am65_cpsw_nuss_free_rx_chns(void *data)
 
 	rx_chn = &common->rx_chns;
 
-	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
-		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
-
 	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
 		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+
+	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
 }
 
 static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
-- 
2.30.2



