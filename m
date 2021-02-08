Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF06313803
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhBHPfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhBHPSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6260364EE2;
        Mon,  8 Feb 2021 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797153;
        bh=iWxHKFs2bpPOm3K08HRDYFOm15vsvjrr4NBS7x4z/7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWBQe55nRlSQVsGapDKHddd3FSST0vY3WwW/WGjHSgUumI10X0XLm29G+4yPKwONA
         Vcm7MKyOpw0pt2BtN20K7cyuf7nO2BHuMeuCYkqy76fP07ujCuTK9RhFzlOeXSLEL8
         80gRgDCnsF7zDBsnyVPVTxpszlPZRT3UswN1xVL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ikjoon Jang <ikjn@chromium.org>
Subject: [PATCH 5.10 011/120] usb: xhci-mtk: fix unreleased bandwidth data
Date:   Mon,  8 Feb 2021 15:59:58 +0100
Message-Id: <20210208145818.844579598@linuxfoundation.org>
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

From: Ikjoon Jang <ikjn@chromium.org>

commit 1d69f9d901ef14d81c3b004e3282b8cc7b456280 upstream.

xhci-mtk needs XHCI_MTK_HOST quirk functions in add_endpoint() and
drop_endpoint() to handle its own sw bandwidth management.

It stores bandwidth data into an internal table every time
add_endpoint() is called, and drops those in drop_endpoint().
But when bandwidth allocation fails at one endpoint, all earlier
allocation from the same interface could still remain at the table.

This patch moves bandwidth management codes to check_bandwidth() and
reset_bandwidth() path. To do so, this patch also adds those functions
to xhci_driver_overrides and lets mtk-xhci to release all failed
endpoints in reset_bandwidth() path.

Fixes: 08e469de87a2 ("usb: xhci-mtk: supports bandwidth scheduling with multi-TT")
Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Link: https://lore.kernel.org/r/20210113180444.v6.1.Id0d31b5f3ddf5e734d2ab11161ac5821921b1e1e@changeid
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |  123 +++++++++++++++++++++++++++-------------
 drivers/usb/host/xhci-mtk.c     |    2 
 drivers/usb/host/xhci-mtk.h     |   13 ++++
 drivers/usb/host/xhci.c         |    8 +-
 drivers/usb/host/xhci.h         |    4 +
 5 files changed, 111 insertions(+), 39 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -200,6 +200,7 @@ static struct mu3h_sch_ep_info *create_s
 
 	sch_ep->sch_tt = tt;
 	sch_ep->ep = ep;
+	INIT_LIST_HEAD(&sch_ep->tt_endpoint);
 
 	return sch_ep;
 }
@@ -583,6 +584,8 @@ int xhci_mtk_sch_init(struct xhci_hcd_mt
 
 	mtk->sch_array = sch_array;
 
+	INIT_LIST_HEAD(&mtk->bw_ep_list_new);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_sch_init);
@@ -601,19 +604,14 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_virt_device *virt_dev;
-	struct mu3h_sch_bw_info *sch_bw;
 	struct mu3h_sch_ep_info *sch_ep;
-	struct mu3h_sch_bw_info *sch_array;
 	unsigned int ep_index;
-	int bw_index;
-	int ret = 0;
 
 	xhci = hcd_to_xhci(hcd);
 	virt_dev = xhci->devs[udev->slot_id];
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
 	ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
-	sch_array = mtk->sch_array;
 
 	xhci_dbg(xhci, "%s() type:%d, speed:%d, mpkt:%d, dir:%d, ep:%p\n",
 		__func__, usb_endpoint_type(&ep->desc), udev->speed,
@@ -632,39 +630,34 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd
 		return 0;
 	}
 
-	bw_index = get_bw_index(xhci, udev, ep);
-	sch_bw = &sch_array[bw_index];
-
 	sch_ep = create_sch_ep(udev, ep, ep_ctx);
 	if (IS_ERR_OR_NULL(sch_ep))
 		return -ENOMEM;
 
 	setup_sch_info(udev, ep_ctx, sch_ep);
 
-	ret = check_sch_bw(udev, sch_bw, sch_ep);
-	if (ret) {
-		xhci_err(xhci, "Not enough bandwidth!\n");
-		if (is_fs_or_ls(udev->speed))
-			drop_tt(udev);
-
-		kfree(sch_ep);
-		return -ENOSPC;
-	}
+	list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_list_new);
 
-	list_add_tail(&sch_ep->endpoint, &sch_bw->bw_ep_list);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xhci_mtk_add_ep_quirk);
 
-	ep_ctx->reserved[0] |= cpu_to_le32(EP_BPKTS(sch_ep->pkts)
-		| EP_BCSCOUNT(sch_ep->cs_count) | EP_BBM(sch_ep->burst_mode));
-	ep_ctx->reserved[1] |= cpu_to_le32(EP_BOFFSET(sch_ep->offset)
-		| EP_BREPEAT(sch_ep->repeat));
+static void xhci_mtk_drop_ep(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
+			     struct mu3h_sch_ep_info *sch_ep)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(mtk->hcd);
+	int bw_index = get_bw_index(xhci, udev, sch_ep->ep);
+	struct mu3h_sch_bw_info *sch_bw = &mtk->sch_array[bw_index];
 
-	xhci_dbg(xhci, " PKTS:%x, CSCOUNT:%x, BM:%x, OFFSET:%x, REPEAT:%x\n",
-			sch_ep->pkts, sch_ep->cs_count, sch_ep->burst_mode,
-			sch_ep->offset, sch_ep->repeat);
+	update_bus_bw(sch_bw, sch_ep, 0);
+	list_del(&sch_ep->endpoint);
 
-	return 0;
+	if (sch_ep->sch_tt) {
+		list_del(&sch_ep->tt_endpoint);
+		drop_tt(udev);
+	}
+	kfree(sch_ep);
 }
-EXPORT_SYMBOL_GPL(xhci_mtk_add_ep_quirk);
 
 void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 		struct usb_host_endpoint *ep)
@@ -675,7 +668,7 @@ void xhci_mtk_drop_ep_quirk(struct usb_h
 	struct xhci_virt_device *virt_dev;
 	struct mu3h_sch_bw_info *sch_array;
 	struct mu3h_sch_bw_info *sch_bw;
-	struct mu3h_sch_ep_info *sch_ep;
+	struct mu3h_sch_ep_info *sch_ep, *tmp;
 	int bw_index;
 
 	xhci = hcd_to_xhci(hcd);
@@ -694,17 +687,73 @@ void xhci_mtk_drop_ep_quirk(struct usb_h
 	bw_index = get_bw_index(xhci, udev, ep);
 	sch_bw = &sch_array[bw_index];
 
-	list_for_each_entry(sch_ep, &sch_bw->bw_ep_list, endpoint) {
+	list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
 		if (sch_ep->ep == ep) {
-			update_bus_bw(sch_bw, sch_ep, 0);
-			list_del(&sch_ep->endpoint);
-			if (is_fs_or_ls(udev->speed)) {
-				list_del(&sch_ep->tt_endpoint);
-				drop_tt(udev);
-			}
-			kfree(sch_ep);
-			break;
+			xhci_mtk_drop_ep(mtk, udev, sch_ep);
 		}
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_mtk_drop_ep_quirk);
+
+int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct xhci_virt_device *virt_dev = xhci->devs[udev->slot_id];
+	struct mu3h_sch_bw_info *sch_bw;
+	struct mu3h_sch_ep_info *sch_ep, *tmp;
+	int bw_index, ret;
+
+	dev_dbg(&udev->dev, "%s\n", __func__);
+
+	list_for_each_entry(sch_ep, &mtk->bw_ep_list_new, endpoint) {
+		bw_index = get_bw_index(xhci, udev, sch_ep->ep);
+		sch_bw = &mtk->sch_array[bw_index];
+
+		ret = check_sch_bw(udev, sch_bw, sch_ep);
+		if (ret) {
+			xhci_err(xhci, "Not enough bandwidth!\n");
+			return -ENOSPC;
+		}
+	}
+
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
+		struct xhci_ep_ctx *ep_ctx;
+		struct usb_host_endpoint *ep = sch_ep->ep;
+		unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
+
+		bw_index = get_bw_index(xhci, udev, ep);
+		sch_bw = &mtk->sch_array[bw_index];
+
+		list_move_tail(&sch_ep->endpoint, &sch_bw->bw_ep_list);
+
+		ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
+		ep_ctx->reserved[0] |= cpu_to_le32(EP_BPKTS(sch_ep->pkts)
+			| EP_BCSCOUNT(sch_ep->cs_count)
+			| EP_BBM(sch_ep->burst_mode));
+		ep_ctx->reserved[1] |= cpu_to_le32(EP_BOFFSET(sch_ep->offset)
+			| EP_BREPEAT(sch_ep->repeat));
+
+		xhci_dbg(xhci, " PKTS:%x, CSCOUNT:%x, BM:%x, OFFSET:%x, REPEAT:%x\n",
+			sch_ep->pkts, sch_ep->cs_count, sch_ep->burst_mode,
+			sch_ep->offset, sch_ep->repeat);
+	}
+
+	return xhci_check_bandwidth(hcd, udev);
+}
+EXPORT_SYMBOL_GPL(xhci_mtk_check_bandwidth);
+
+void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
+	struct mu3h_sch_ep_info *sch_ep, *tmp;
+
+	dev_dbg(&udev->dev, "%s\n", __func__);
+
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
+		xhci_mtk_drop_ep(mtk, udev, sch_ep);
+	}
+
+	xhci_reset_bandwidth(hcd, udev);
+}
+EXPORT_SYMBOL_GPL(xhci_mtk_reset_bandwidth);
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -347,6 +347,8 @@ static void usb_wakeup_set(struct xhci_h
 static int xhci_mtk_setup(struct usb_hcd *hcd);
 static const struct xhci_driver_overrides xhci_mtk_overrides __initconst = {
 	.reset = xhci_mtk_setup,
+	.check_bandwidth = xhci_mtk_check_bandwidth,
+	.reset_bandwidth = xhci_mtk_reset_bandwidth,
 };
 
 static struct hc_driver __read_mostly xhci_mtk_hc_driver;
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -130,6 +130,7 @@ struct mu3c_ippc_regs {
 struct xhci_hcd_mtk {
 	struct device *dev;
 	struct usb_hcd *hcd;
+	struct list_head bw_ep_list_new;
 	struct mu3h_sch_bw_info *sch_array;
 	struct mu3c_ippc_regs __iomem *ippc_regs;
 	bool has_ippc;
@@ -166,6 +167,8 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd
 		struct usb_host_endpoint *ep);
 void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 		struct usb_host_endpoint *ep);
+int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 
 #else
 static inline int xhci_mtk_add_ep_quirk(struct usb_hcd *hcd,
@@ -179,6 +182,16 @@ static inline void xhci_mtk_drop_ep_quir
 {
 }
 
+static inline int xhci_mtk_check_bandwidth(struct usb_hcd *hcd,
+		struct usb_device *udev)
+{
+	return 0;
+}
+
+static inline void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd,
+		struct usb_device *udev)
+{
+}
 #endif
 
 #endif		/* _XHCI_MTK_H_ */
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2861,7 +2861,7 @@ static void xhci_check_bw_drop_ep_stream
  * else should be touching the xhci->devs[slot_id] structure, so we
  * don't need to take the xhci->lock for manipulating that.
  */
-static int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
+int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	int i;
 	int ret = 0;
@@ -2959,7 +2959,7 @@ command_cleanup:
 	return ret;
 }
 
-static void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
+void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci;
 	struct xhci_virt_device	*virt_dev;
@@ -5385,6 +5385,10 @@ void xhci_init_driver(struct hc_driver *
 			drv->reset = over->reset;
 		if (over->start)
 			drv->start = over->start;
+		if (over->check_bandwidth)
+			drv->check_bandwidth = over->check_bandwidth;
+		if (over->reset_bandwidth)
+			drv->reset_bandwidth = over->reset_bandwidth;
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_init_driver);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1916,6 +1916,8 @@ struct xhci_driver_overrides {
 	size_t extra_priv_size;
 	int (*reset)(struct usb_hcd *hcd);
 	int (*start)(struct usb_hcd *hcd);
+	int (*check_bandwidth)(struct usb_hcd *, struct usb_device *);
+	void (*reset_bandwidth)(struct usb_hcd *, struct usb_device *);
 };
 
 #define	XHCI_CFC_DELAY		10
@@ -2070,6 +2072,8 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 void xhci_shutdown(struct usb_hcd *hcd);
 void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
+int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
 int xhci_ext_cap_init(struct xhci_hcd *xhci);
 


