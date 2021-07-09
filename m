Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7003C1FDC
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 09:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGIHLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 03:11:40 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:58738 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230121AbhGIHLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 03:11:40 -0400
X-UUID: 5d6e8de1c19f437fbe5038b7416755df-20210709
X-UUID: 5d6e8de1c19f437fbe5038b7416755df-20210709
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 221871096; Fri, 09 Jul 2021 15:08:53 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 9 Jul 2021 15:08:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 15:08:51 +0800
From:   Deren Wu <Deren.Wu@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Deren Wu <deren.wu@mediatek.com>
Subject: [PATCH 1/1] mt76: mt7921: get rid of mcu_reset function pointer
Date:   Fri, 9 Jul 2021 15:07:19 +0800
Message-ID: <05ba0c23ecacf740942f62b12fe2f39ed31be106.1625806023.git.deren.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1625806023.git.deren.wu@mediatek.com>
References: <cover.1625806023.git.deren.wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d43b3257621dfe57c71d875afd3f624b9a042fc5 ]

since mcu_reset it used only by mt7921, move the reset callback to
mt7921_mcu_parse_response routine and get rid of the function pointer.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/linux-wireless/364293ec8609dd254067d8173c1599526ffd662c.1619000828.git.lorenzo@kernel.org/
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.12: f92f81d35ac2 mt76: mt7921: check mcu returned values in mt7921_start
Cc: <stable@vger.kernel.org> # 5.12: d32464e68ffc mt76: mt7921: introduce mt7921_run_firmware utility routine.
Cc: <stable@vger.kernel.org> # 5.12: 1f7396acfef4 mt76: mt7921: introduce __mt7921_start utility routine
Cc: <stable@vger.kernel.org> # 5.12: 3990465db682 mt76: dma: introduce mt76_dma_queue_reset routine
Cc: <stable@vger.kernel.org> # 5.12: c001df978e4c mt76: dma: export mt76_dma_rx_cleanup routine
Cc: <stable@vger.kernel.org> # 5.12: 0c1ce9884607 mt76: mt7921: add wifi reset support
Cc: <stable@vger.kernel.org> # 5.12: e513ae49088b mt76: mt7921: abort uncompleted scan by wifi reset
Cc: <stable@vger.kernel.org> # 5.12
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index d0d6de3f6d41..a4f070cd78fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -161,6 +161,8 @@ mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	if (!skb) {
 		dev_err(mdev->dev, "Message %d (seq %d) timeout\n",
 			cmd, seq);
+		mt7921_reset(mdev);
+
 		return -ETIMEDOUT;
 	}
 
@@ -952,7 +954,6 @@ int mt7921_mcu_init(struct mt7921_dev *dev)
 		.mcu_skb_send_msg = mt7921_mcu_send_message,
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
-		.mcu_reset = mt7921_reset,
 	};
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;
-- 
2.25.1

