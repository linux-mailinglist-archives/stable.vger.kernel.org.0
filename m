Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C705AAF12
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiIBMdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiIBMc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D7E2C48;
        Fri,  2 Sep 2022 05:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A714B82AA1;
        Fri,  2 Sep 2022 12:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E0FC43142;
        Fri,  2 Sep 2022 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121638;
        bh=zFzdsXRNGhgpzL0zy6R6uex/IZJ/4hFDVtMV0UFxGGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkfge/YHGBiS88Od/englGEB8q01UjlCPro340LFXlSmKmwFn+ZvHaOZw3e0mL3IQ
         9sEyVtLIQIPBvo9Iyd/N5L2CX9TKR92/RUW/Owjo8gfc+XFNiOEjQc9d6BjE9Zhkyo
         chV6EnLYXsQcCdAIoanSoGdh8b/6T7OMMHJida4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/77] net: moxa: get rid of asymmetry in DMA mapping/unmapping
Date:   Fri,  2 Sep 2022 14:18:26 +0200
Message-Id: <20220902121404.221001880@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

[ Upstream commit 0ee7828dfc56e97d71e51e6374dc7b4eb2b6e081 ]

Since priv->rx_mapping[i] is maped in moxart_mac_open(), we
should unmap it from moxart_mac_stop(). Fixes 2 warnings.

1. During error unwinding in moxart_mac_probe(): "goto init_fail;",
then moxart_mac_free_memory() calls dma_unmap_single() with
priv->rx_mapping[i] pointers zeroed.

WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:963 check_unmap+0x704/0x980
DMA-API: moxart-ethernet 92000000.mac: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=1600 bytes]
CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0+ #60
Hardware name: Generic DT based system
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x34/0x44
 dump_stack_lvl from __warn+0xbc/0x1f0
 __warn from warn_slowpath_fmt+0x94/0xc8
 warn_slowpath_fmt from check_unmap+0x704/0x980
 check_unmap from debug_dma_unmap_page+0x8c/0x9c
 debug_dma_unmap_page from moxart_mac_free_memory+0x3c/0xa8
 moxart_mac_free_memory from moxart_mac_probe+0x190/0x218
 moxart_mac_probe from platform_probe+0x48/0x88
 platform_probe from really_probe+0xc0/0x2e4

2. After commands:
 ip link set dev eth0 down
 ip link set dev eth0 up

WARNING: CPU: 0 PID: 55 at kernel/dma/debug.c:570 add_dma_entry+0x204/0x2ec
DMA-API: moxart-ethernet 92000000.mac: cacheline tracking EEXIST, overlapping mappings aren't supported
CPU: 0 PID: 55 Comm: ip Not tainted 5.19.0+ #57
Hardware name: Generic DT based system
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x34/0x44
 dump_stack_lvl from __warn+0xbc/0x1f0
 __warn from warn_slowpath_fmt+0x94/0xc8
 warn_slowpath_fmt from add_dma_entry+0x204/0x2ec
 add_dma_entry from dma_map_page_attrs+0x110/0x328
 dma_map_page_attrs from moxart_mac_open+0x134/0x320
 moxart_mac_open from __dev_open+0x11c/0x1ec
 __dev_open from __dev_change_flags+0x194/0x22c
 __dev_change_flags from dev_change_flags+0x14/0x44
 dev_change_flags from devinet_ioctl+0x6d4/0x93c
 devinet_ioctl from inet_ioctl+0x1ac/0x25c

v1 -> v2:
Extraneous change removed.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220819110519.1230877-1-saproj@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 383d72415c659..87327086ea8ca 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -74,11 +74,6 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 static void moxart_mac_free_memory(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
-	int i;
-
-	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
-				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
 		dma_free_coherent(&priv->pdev->dev,
@@ -193,6 +188,7 @@ static int moxart_mac_open(struct net_device *ndev)
 static int moxart_mac_stop(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
+	int i;
 
 	napi_disable(&priv->napi);
 
@@ -204,6 +200,11 @@ static int moxart_mac_stop(struct net_device *ndev)
 	/* disable all functions */
 	writel(0, priv->base + REG_MAC_CTRL);
 
+	/* unmap areas mapped in moxart_mac_setup_desc_ring() */
+	for (i = 0; i < RX_DESC_NUM; i++)
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
+				 priv->rx_buf_size, DMA_FROM_DEVICE);
+
 	return 0;
 }
 
-- 
2.35.1



