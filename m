Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23332A940D
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 11:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKFKWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 05:22:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41502 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726832AbgKFKWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 05:22:00 -0500
X-UUID: d3225b862b624616881e03d3eb86a970-20201106
X-UUID: d3225b862b624616881e03d3eb86a970-20201106
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 489818813; Fri, 06 Nov 2020 18:21:53 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 6 Nov 2020 18:21:48 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Nov 2020 18:21:48 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Chunfeng Yun <Chunfeng.Yun@mediatek.com>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        "Macpaul Lin" <macpaul@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 2/2] usb: host: XHCI: xhci-mtk.c: support mediatek,str-clock-on
Date:   Fri, 6 Nov 2020 18:21:37 +0800
Message-ID: <1604658097-5127-2-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1604658097-5127-1-git-send-email-macpaul.lin@mediatek.com>
References: <1604301530-31546-1-git-send-email-macpaul.lin@mediatek.com>
 <1604658097-5127-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some platform dose not support turn off clock when system suspending.
We add an option "mediatek,str-clock-on" for distinquish these platforms.
When "mediatek,str-clock-on" has been set, xhci-mtk driver will skip
turning clock on and off during system suspend and resume.

Fixes: 0cbd4b34cda9 ("xhci: mediatek: support MTK xHCI host controller")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: stable@vger.kernel.org
---
Changes for v3:
  - Add "Fixes" tag as a bug fix on phone system.
Changes for v2:
  - Replace "mediatek,keep-clock-on" to "mediatek,str-clock-on" which implies
    this option related to STR functions.

 drivers/usb/host/xhci-mtk.c |    9 +++++++--
 drivers/usb/host/xhci-mtk.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index 4311d4c..77b0d7a 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -464,6 +464,9 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	of_property_read_u32(node, "mediatek,u3p-dis-msk",
 			     &mtk->u3p_dis_msk);
 
+	/* STR: keep clock on when suspending on some platform */
+	mtk->str_clk_on = of_property_read_bool(node, "mediatek,str-clock-on");
+
 	ret = usb_wakeup_of_property_parse(mtk, node);
 	if (ret) {
 		dev_err(dev, "failed to parse uwk property\n");
@@ -624,7 +627,8 @@ static int __maybe_unused xhci_mtk_suspend(struct device *dev)
 	del_timer_sync(&xhci->shared_hcd->rh_timer);
 
 	xhci_mtk_host_disable(mtk);
-	xhci_mtk_clks_disable(mtk);
+	if (!mtk->str_clk_on)
+		xhci_mtk_clks_disable(mtk);
 	usb_wakeup_set(mtk, true);
 	return 0;
 }
@@ -636,7 +640,8 @@ static int __maybe_unused xhci_mtk_resume(struct device *dev)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
 	usb_wakeup_set(mtk, false);
-	xhci_mtk_clks_enable(mtk);
+	if (!mtk->str_clk_on)
+		xhci_mtk_clks_enable(mtk);
 	xhci_mtk_host_enable(mtk);
 
 	xhci_dbg(xhci, "%s: restart port polling\n", __func__);
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index a93cfe8..4039b025 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -152,6 +152,7 @@ struct xhci_hcd_mtk {
 	struct regmap *uwk;
 	u32 uwk_reg_base;
 	u32 uwk_vers;
+	bool str_clk_on;
 };
 
 static inline struct xhci_hcd_mtk *hcd_to_mtk(struct usb_hcd *hcd)
-- 
1.7.9.5

