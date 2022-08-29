Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540665A4842
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiH2LHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiH2LHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6352F165A4;
        Mon, 29 Aug 2022 04:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29761611B4;
        Mon, 29 Aug 2022 11:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CAAC43470;
        Mon, 29 Aug 2022 11:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771026;
        bh=Qr8GoTg/cfWYFWo+rcVaWvFs7/QOpJw12Y+cnBl4qH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs1DAnNxJOl5yuuSjNa3WhiexodXLCg+SQZ1p6wC2bQ5pFHGPamr9zL/qzJs4q4kX
         EeNAiJzi4NCPa2Iu9116d/U6BwLYPzVTw314AMa1cCRR8gr1vtNm/qbxX2fHxyiDP9
         apyAoRA2fZCQPS+mYBF7ZMJnV8PIchyVQJ426j4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/136] net: moxa: get rid of asymmetry in DMA mapping/unmapping
Date:   Mon, 29 Aug 2022 12:58:37 +0200
Message-Id: <20220829105806.679561964@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
index 54a91d2b33b53..fa4c596e6ec6f 100644
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



