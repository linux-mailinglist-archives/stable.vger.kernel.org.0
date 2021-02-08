Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0003137E6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhBHPc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233365AbhBHPSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4102764EC7;
        Mon,  8 Feb 2021 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797155;
        bh=UTAvX1Z2BIvkb/lCrVV8zz9Le16kHhfY0QGBnzvF21w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5S9vX8IGBHAaGMjZsWqCB9CKXTpjtS/F11j5VoyinxW9NdNhaCLtPhp9HgtO2LAw
         k4Yt5m9RP+HnmROVO/oVKO7UtyCCLmqTGeSlQ7ENq0CrfifA3SpFGKQoNzpwcGvt42
         Q68qJEUtvDfIxyr/VffBxdgJmoETkkAgMWoVu+TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Ikjoon Jang <ikjn@chromium.org>
Subject: [PATCH 5.10 012/120] usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints
Date:   Mon,  8 Feb 2021 15:59:59 +0100
Message-Id: <20210208145818.885690269@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 54f6a8af372213a254af6609758d99f7c0b6b5ad upstream.

For those unchecked endpoints, we don't allocate bandwidth for
them, so no need free the bandwidth, otherwise will decrease
the allocated bandwidth.
Meanwhile use xhci_dbg() instead of dev_dbg() to print logs and
rename bw_ep_list_new as bw_ep_chk_list.

Fixes: 1d69f9d901ef ("usb: xhci-mtk: fix unreleased bandwidth data")
Cc: stable <stable@vger.kernel.org>
Reviewed-and-tested-by: Ikjoon Jang <ikjn@chromium.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1612159064-28413-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |   61 +++++++++++++++++++++-------------------
 drivers/usb/host/xhci-mtk.h     |    4 +-
 2 files changed, 36 insertions(+), 29 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -200,6 +200,7 @@ static struct mu3h_sch_ep_info *create_s
 
 	sch_ep->sch_tt = tt;
 	sch_ep->ep = ep;
+	INIT_LIST_HEAD(&sch_ep->endpoint);
 	INIT_LIST_HEAD(&sch_ep->tt_endpoint);
 
 	return sch_ep;
@@ -374,6 +375,7 @@ static void update_bus_bw(struct mu3h_sc
 					sch_ep->bw_budget_table[j];
 		}
 	}
+	sch_ep->allocated = used;
 }
 
 static int check_sch_tt(struct usb_device *udev,
@@ -542,6 +544,22 @@ static int check_sch_bw(struct usb_devic
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
@@ -584,7 +602,7 @@ int xhci_mtk_sch_init(struct xhci_hcd_mt
 
 	mtk->sch_array = sch_array;
 
-	INIT_LIST_HEAD(&mtk->bw_ep_list_new);
+	INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
 
 	return 0;
 }
@@ -636,29 +654,12 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd
 
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
@@ -688,9 +689,8 @@ void xhci_mtk_drop_ep_quirk(struct usb_h
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
@@ -704,9 +704,9 @@ int xhci_mtk_check_bandwidth(struct usb_
 	struct mu3h_sch_ep_info *sch_ep, *tmp;
 	int bw_index, ret;
 
-	dev_dbg(&udev->dev, "%s\n", __func__);
+	xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
 
-	list_for_each_entry(sch_ep, &mtk->bw_ep_list_new, endpoint) {
+	list_for_each_entry(sch_ep, &mtk->bw_ep_chk_list, endpoint) {
 		bw_index = get_bw_index(xhci, udev, sch_ep->ep);
 		sch_bw = &mtk->sch_array[bw_index];
 
@@ -717,7 +717,7 @@ int xhci_mtk_check_bandwidth(struct usb_
 		}
 	}
 
-	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
 		struct xhci_ep_ctx *ep_ctx;
 		struct usb_host_endpoint *ep = sch_ep->ep;
 		unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
@@ -746,12 +746,17 @@ EXPORT_SYMBOL_GPL(xhci_mtk_check_bandwid
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


