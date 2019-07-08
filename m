Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9974621BE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGHPTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733161AbfGHPTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:19:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA07821537;
        Mon,  8 Jul 2019 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599140;
        bh=uR1AjF105+UTf4n2pmOKr80VoeSOIiGe1oknHSF5fWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HP/G6prMK8JgvnHIC96pcgAJS0WYlbqUwOymBCBdNaxSM4T6pHKe3CpQVHbSNvGLc
         /T8Ldo3e5/ous45uooj60A5aHvZLLpTgi7R7G/v/kp58Ni8ma/N6hrjo+MNLgpWYvc
         +I6r5hBBF/yOU6euDBywh13FOp6crO7H/by35GRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Lee <mark-mc.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/102] net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled
Date:   Mon,  8 Jul 2019 17:12:12 +0200
Message-Id: <20190708150527.177997526@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 880c2d4b2fdfd580ebcd6bb7240a8027a1d34751 ]

Should only enable HW RX_2BYTE_OFFSET function in the case NET_IP_ALIGN
equals to 2.

Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 03b599109619..d10c8a8156bc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1700,6 +1700,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 static int mtk_start_dma(struct mtk_eth *eth)
 {
+	u32 rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
 	int err;
 
 	err = mtk_dma_init(eth);
@@ -1714,7 +1715,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		MTK_QDMA_GLO_CFG);
 
 	mtk_w32(eth,
-		MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
+		MTK_RX_DMA_EN | rx_2b_offset |
 		MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
 		MTK_PDMA_GLO_CFG);
 
-- 
2.20.1



