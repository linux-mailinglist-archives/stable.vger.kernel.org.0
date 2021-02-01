Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF29330A1C7
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 07:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhBAGCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 01:02:49 -0500
Received: from mailgw02.mediatek.com ([1.203.163.81]:58450 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231846AbhBAF7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 00:59:04 -0500
X-UUID: 4e8daef9ca0d4d6a939c80119b1f19be-20210201
X-UUID: 4e8daef9ca0d4d6a939c80119b1f19be-20210201
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1854773642; Mon, 01 Feb 2021 13:58:00 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 MTKMBS31N1.mediatek.inc (172.27.4.69) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Feb 2021 13:57:50 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Feb 2021 13:57:50 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ikjoon Jang <ikjn@chromium.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Zhanyong Wang <zhanyong.wang@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: [next PATCH] usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints
Date:   Mon, 1 Feb 2021 13:57:44 +0800
Message-ID: <1612159064-28413-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7B8658DABE72D61BB90A22D8DACFB89029C9D3F4800EC3985BB294711E3736262000:8
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For those unchecked endpoints, we don't allocate bandwidth for
them, so no need free the bandwidth, otherwise will decrease
the allocated bandwidth.
Meanwhile use xhci_dbg() instead of dev_dbg() to print logs and
rename bw_ep_list_new as bw_ep_chk_list.

Fixes: 1d69f9d901ef ("usb: xhci-mtk: fix unreleased bandwidth data")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
 drivers/usb/host/xhci-mtk-sch.c | 61 ++++++++++++++++++---------------
 drivers/usb/host/xhci-mtk.h     |  4 ++-
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index a313e75ff1c6..dee8a329076d 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -200,6 +200,7 @@ static struct mu3h_sch_ep_info *create_sch_ep(struct usb_device *udev,
 
 	sch_ep->sch_tt = tt;
 	sch_ep->ep = ep;
+	INIT_LIST_HEAD(&sch_ep->endpoint);
 	INIT_LIST_HEAD(&sch_ep->tt_endpoint);
 
 	return sch_ep;
@@ -374,6 +375,7 @@ static void update_bus_bw(struct mu3h_sch_bw_info *sch_bw,
 					sch_ep->bw_budget_table[j];
 		}
 	}
+	sch_ep->allocated = used;
 }
 
 static int check_sch_tt(struct usb_device *udev,
@@ -542,6 +544,22 @@ static int check_sch_bw(struct usb_device *udev,
 	return 0;
 }
 
+static void destroy_sch_ep(struct usb_device *udev,
+	struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
+{
+	/* only release ep bw check passed by check_sch_bw() */
+	if (sch_ep->allocated)
+		update_bus_bw(sch_bw, sch_ep, 0);
+
+	list_del(&sch_ep->endpoint);
+
+	if (sch_ep->sch_tt) {
+		list_del(&sch_ep->tt_endpoint);
+		drop_tt(udev);
+	}
+	kfree(sch_ep);
+}
+
 static bool need_bw_sch(struct usb_host_endpoint *ep,
 	enum usb_device_speed speed, int has_tt)
 {
@@ -584,7 +602,7 @@ int xhci_mtk_sch_init(struct xhci_hcd_mtk *mtk)
 
 	mtk->sch_array = sch_array;
 
-	INIT_LIST_HEAD(&mtk->bw_ep_list_new);
+	INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
 
 	return 0;
 }
@@ -636,29 +654,12 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 
 	setup_sch_info(udev, ep_ctx, sch_ep);
 
-	list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_list_new);
+	list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_chk_list);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_add_ep_quirk);
 
-static void xhci_mtk_drop_ep(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
-			     struct mu3h_sch_ep_info *sch_ep)
-{
-	struct xhci_hcd *xhci = hcd_to_xhci(mtk->hcd);
-	int bw_index = get_bw_index(xhci, udev, sch_ep->ep);
-	struct mu3h_sch_bw_info *sch_bw = &mtk->sch_array[bw_index];
-
-	update_bus_bw(sch_bw, sch_ep, 0);
-	list_del(&sch_ep->endpoint);
-
-	if (sch_ep->sch_tt) {
-		list_del(&sch_ep->tt_endpoint);
-		drop_tt(udev);
-	}
-	kfree(sch_ep);
-}
-
 void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 		struct usb_host_endpoint *ep)
 {
@@ -688,9 +689,8 @@ void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 	sch_bw = &sch_array[bw_index];
 
 	list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
-		if (sch_ep->ep == ep) {
-			xhci_mtk_drop_ep(mtk, udev, sch_ep);
-		}
+		if (sch_ep->ep == ep)
+			destroy_sch_ep(udev, sch_bw, sch_ep);
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_drop_ep_quirk);
@@ -704,9 +704,9 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 	struct mu3h_sch_ep_info *sch_ep, *tmp;
 	int bw_index, ret;
 
-	dev_dbg(&udev->dev, "%s\n", __func__);
+	xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
 
-	list_for_each_entry(sch_ep, &mtk->bw_ep_list_new, endpoint) {
+	list_for_each_entry(sch_ep, &mtk->bw_ep_chk_list, endpoint) {
 		bw_index = get_bw_index(xhci, udev, sch_ep->ep);
 		sch_bw = &mtk->sch_array[bw_index];
 
@@ -717,7 +717,7 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		}
 	}
 
-	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
 		struct xhci_ep_ctx *ep_ctx;
 		struct usb_host_endpoint *ep = sch_ep->ep;
 		unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
@@ -746,12 +746,17 @@ EXPORT_SYMBOL_GPL(xhci_mtk_check_bandwidth);
 void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct mu3h_sch_bw_info *sch_bw;
 	struct mu3h_sch_ep_info *sch_ep, *tmp;
+	int bw_index;
 
-	dev_dbg(&udev->dev, "%s\n", __func__);
+	xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
 
-	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
-		xhci_mtk_drop_ep(mtk, udev, sch_ep);
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
+		bw_index = get_bw_index(xhci, udev, sch_ep->ep);
+		sch_bw = &mtk->sch_array[bw_index];
+		destroy_sch_ep(udev, sch_bw, sch_ep);
 	}
 
 	xhci_reset_bandwidth(hcd, udev);
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index 577f431c5c93..cbb09dfea62e 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -59,6 +59,7 @@ struct mu3h_sch_bw_info {
  * @ep_type: endpoint type
  * @maxpkt: max packet size of endpoint
  * @ep: address of usb_host_endpoint struct
+ * @allocated: the bandwidth is aready allocated from bus_bw
  * @offset: which uframe of the interval that transfer should be
  *		scheduled first time within the interval
  * @repeat: the time gap between two uframes that transfers are
@@ -86,6 +87,7 @@ struct mu3h_sch_ep_info {
 	u32 ep_type;
 	u32 maxpkt;
 	void *ep;
+	bool allocated;
 	/*
 	 * mtk xHCI scheduling information put into reserved DWs
 	 * in ep context
@@ -130,8 +132,8 @@ struct mu3c_ippc_regs {
 struct xhci_hcd_mtk {
 	struct device *dev;
 	struct usb_hcd *hcd;
-	struct list_head bw_ep_list_new;
 	struct mu3h_sch_bw_info *sch_array;
+	struct list_head bw_ep_chk_list;
 	struct mu3c_ippc_regs __iomem *ippc_regs;
 	bool has_ippc;
 	int num_u2_ports;
-- 
2.18.0

