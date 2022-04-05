Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F774F3109
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiDEI2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272CD260B;
        Tue,  5 Apr 2022 01:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD0F0B81B90;
        Tue,  5 Apr 2022 08:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3620AC385A1;
        Tue,  5 Apr 2022 08:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146580;
        bh=zjOTbd3CARdzRs6xAsD11lBU1bt2Z1JXAl//e9EerwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQ/SlzzlizttBOMGh5QCNY3dv6wh9OVDpEQav2uRbELtxv82U3M/ksiXdGHUA6ArY
         FjLoVos8tXPG4YJzURx3f4LFcE9JcIYjgyVuSOeo7Sz0Q5kIumS7xJBq17gWfogHtX
         lBW1H/CAIOsU4AXE/Jn31rbIWJ2KwR39PaLN8UDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0815/1126] net: hns3: fix ethtool tx copybreak buf size indicating not aligned issue
Date:   Tue,  5 Apr 2022 09:26:02 +0200
Message-Id: <20220405070431.485883939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 8778372118023e2258612c03573c47efef41d755 ]

When use ethtoool set tx copybreak buf size to a large value
which causes order exceeding 10 or memory is not enough,
it causes allocating tx copybreak buffer failed and print
"the active tx spare buf is 0, not enabled tx spare buffer",
however, use --get-tunable parameter query tx copybreak buf
size and it indicates setting value not 0.

So, it's necessary to change the print value from setting
value to 0.

Set kinfo.tx_spare_buf_size to 0 when set tx copybreak buf size failed.

Fixes: e445f08af2b1 ("net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 20 +++++++++++--------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 ++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index babc5d7a3b52..49943775713f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1028,13 +1028,12 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 
 static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
+	u32 alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	struct hns3_tx_spare *tx_spare;
 	struct page *page;
-	u32 alloc_size;
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
@@ -1044,30 +1043,35 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	if (!tx_spare) {
 		/* The driver still work without the tx spare buffer */
 		dev_warn(ring_to_dev(ring), "failed to allocate hns3_tx_spare\n");
-		return;
+		goto devm_kzalloc_error;
 	}
 
 	page = alloc_pages_node(dev_to_node(ring_to_dev(ring)),
 				GFP_KERNEL, order);
 	if (!page) {
 		dev_warn(ring_to_dev(ring), "failed to allocate tx spare pages\n");
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto alloc_pages_error;
 	}
 
 	dma = dma_map_page(ring_to_dev(ring), page, 0,
 			   PAGE_SIZE << order, DMA_TO_DEVICE);
 	if (dma_mapping_error(ring_to_dev(ring), dma)) {
 		dev_warn(ring_to_dev(ring), "failed to map pages for tx spare\n");
-		put_page(page);
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto dma_mapping_error;
 	}
 
 	tx_spare->dma = dma;
 	tx_spare->buf = page_address(page);
 	tx_spare->len = PAGE_SIZE << order;
 	ring->tx_spare = tx_spare;
+	return;
+
+dma_mapping_error:
+	put_page(page);
+alloc_pages_error:
+	devm_kfree(ring_to_dev(ring), tx_spare);
+devm_kzalloc_error:
+	ring->tqp->handle->kinfo.tx_spare_buf_size = 0;
 }
 
 /* Use hns3_tx_spare_space() to make sure there is enough buffer
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c06c39ece80d..7591772c9a6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1816,7 +1816,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
 		new_tx_spare_buf_size = *(u32 *)data;
 		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
-		if (ret) {
+		if (ret ||
+		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
 			int ret1;
 
 			netdev_warn(netdev,
-- 
2.34.1



