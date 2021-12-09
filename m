Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD15646E132
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 04:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhLIDSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 22:18:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37178 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229637AbhLIDSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 22:18:03 -0500
X-UUID: ef216bd4c7554951a5776db1645ddd4a-20211209
X-UUID: ef216bd4c7554951a5776db1645ddd4a-20211209
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1095888264; Thu, 09 Dec 2021 11:14:27 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 9 Dec 2021 11:14:27 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Dec 2021 11:14:26 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Yuwen Ng <yuwen.ng@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/3] usb: mtu3: add memory barrier before set GPD's HWO
Date:   Thu, 9 Dec 2021 11:14:23 +0800
Message-ID: <20211209031424.17842-2-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209031424.17842-1-chunfeng.yun@mediatek.com>
References: <20211209031424.17842-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a seldom issue that the controller access invalid address
and trigger devapc or emimpu violation. That is due to memory access
is out of order and cause gpd data is not correct.
Make sure GPD is fully written before giving it to HW by setting its
HWO.

Fixes: 48e0d3735aa5 ("usb: mtu3: supports new QMU format")
Cc: stable@vger.kernel.org
Reported-by: Eddie Hung <eddie.hung@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
 drivers/usb/mtu3/mtu3_qmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_qmu.c b/drivers/usb/mtu3/mtu3_qmu.c
index 3f414f91b589..34bb5ac67efe 100644
--- a/drivers/usb/mtu3/mtu3_qmu.c
+++ b/drivers/usb/mtu3/mtu3_qmu.c
@@ -273,6 +273,8 @@ static int mtu3_prepare_tx_gpd(struct mtu3_ep *mep, struct mtu3_request *mreq)
 			gpd->dw3_info |= cpu_to_le32(GPD_EXT_FLAG_ZLP);
 	}
 
+	/* make sure GPD is fully written before giving it to HW */
+	mb();
 	gpd->dw0_info |= cpu_to_le32(GPD_FLAGS_IOC | GPD_FLAGS_HWO);
 
 	mreq->gpd = gpd;
@@ -306,6 +308,8 @@ static int mtu3_prepare_rx_gpd(struct mtu3_ep *mep, struct mtu3_request *mreq)
 	gpd->next_gpd = cpu_to_le32(lower_32_bits(enq_dma));
 	ext_addr |= GPD_EXT_NGP(mtu, upper_32_bits(enq_dma));
 	gpd->dw3_info = cpu_to_le32(ext_addr);
+	/* make sure GPD is fully written before giving it to HW */
+	mb();
 	gpd->dw0_info |= cpu_to_le32(GPD_FLAGS_IOC | GPD_FLAGS_HWO);
 
 	mreq->gpd = gpd;
@@ -445,7 +449,8 @@ static void qmu_tx_zlp_error_handler(struct mtu3 *mtu, u8 epnum)
 		return;
 	}
 	mtu3_setbits(mbase, MU3D_EP_TXCR0(mep->epnum), TX_TXPKTRDY);
-
+	/* make sure GPD is fully written before giving it to HW */
+	mb();
 	/* by pass the current GDP */
 	gpd_current->dw0_info |= cpu_to_le32(GPD_FLAGS_BPS | GPD_FLAGS_HWO);
 
-- 
2.18.0

