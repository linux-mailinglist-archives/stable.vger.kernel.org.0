Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC754B01F6
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiBJBVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:21:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiBJBVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:21:34 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FF6764B;
        Wed,  9 Feb 2022 17:21:34 -0800 (PST)
X-UUID: 1ea264424cbd4dea919c7650eed40350-20220210
X-UUID: 1ea264424cbd4dea919c7650eed40350-20220210
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <qizhong.cheng@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1356681870; Thu, 10 Feb 2022 09:21:31 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Feb 2022 09:21:31 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Feb
 2022 09:21:31 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 09:21:30 +0800
From:   qizhong cheng <qizhong.cheng@mediatek.com>
To:     Ryder Lee <ryder.lee@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC:     <linux-pci@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>,
        <qizhong.cheng@mediatek.com>, <chuanjia.liu@mediatek.com>
Subject: [PATCH v2] PCI: mediatek: Clear interrupt status before dispatching handler
Date:   Thu, 10 Feb 2022 09:21:25 +0800
Message-ID: <20220210012125.6420-1-qizhong.cheng@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found a failure when used iperf tool for wifi performance testing,
there are some MSIs received while clearing the interrupt status,
these MSIs cannot be serviced.

The interrupt status can be cleared even the MSI status still remaining,
as an edge-triggered interrupts, its interrupt status should be cleared
before dispatching to the handler of device.

Signed-off-by: qizhong cheng <qizhong.cheng@mediatek.com>
---
v2:
 - Update the subject line.
 - Improve the commit log and code comments.

 drivers/pci/controller/pcie-mediatek.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 2f3f974977a3..2856d74b2513 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -624,12 +624,17 @@ static void mtk_pcie_intr_handler(struct irq_desc *desc)
 		if (status & MSI_STATUS){
 			unsigned long imsi_status;
 
+			/*
+			 * The interrupt status can be cleared even the MSI
+			 * status still remaining, hence as an edge-triggered
+			 * interrupts, its interrupt status should be cleared
+			 * before dispatching handler.
+			 */
+			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
 			while ((imsi_status = readl(port->base + PCIE_IMSI_STATUS))) {
 				for_each_set_bit(bit, &imsi_status, MTK_MSI_IRQS_NUM)
 					generic_handle_domain_irq(port->inner_domain, bit);
 			}
-			/* Clear MSI interrupt status */
-			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
 		}
 	}
 
-- 
2.25.1

