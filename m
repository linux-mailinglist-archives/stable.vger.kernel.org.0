Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32F9404DD0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbhIIMGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343682AbhIIL7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4481C61131;
        Thu,  9 Sep 2021 11:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187954;
        bh=8wUWyjv2VowB7j2ah4Q5WzP/4v15GT1phmrrIu7Xg8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVqdZl6xuGGqOmCcPEMkf3XFoRkw25Tzcr43jwoZM9vuWzNowT4vjw9JlH0I9SL9/
         XZKC9NigXujO6/NoYQboQcp9dinq3Mxc6rwbs6IyJrECA0Q1d3KEy/5fGSJAQu5rHX
         RXdlIls4Dtyic2sY1+lVm9gq+kLDPJ07Tgd3fizlYD3P2IVRDEiyuwFAMSJvV5/7N9
         vGRN64NNIwiqqDE9uLxt11aK6TQpEFSvOO5FMrZXTuFMfOgUIAam/LCsZYqHS7atPK
         KMSsH2WMeTa6wBb1KXM8/roVgC2EBZBXTTtPBSOLhPf/KcI9UqGMDQWx1IoDKcWceV
         Md6bouTF0ZODg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Ikjoon Jang <ikjn@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 221/252] usb: xhci-mtk: Do not use xhci's virt_dev in drop_endpoint
Date:   Thu,  9 Sep 2021 07:40:35 -0400
Message-Id: <20210909114106.141462-221-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit b8731209958a1dffccc2888121f4c0280c990550 ]

xhci-mtk depends on xhci's internal virt_dev when it retrieves its
internal data from usb_host_endpoint both in add_endpoint and
drop_endpoint callbacks. But when setup packet was retired by
transaction errors in xhci_setup_device() path, a virt_dev for the slot
is newly created with real_port 0. This leads to xhci-mtks's NULL pointer
dereference from drop_endpoint callback as xhci-mtk assumes that virt_dev's
real_port is always started from one. The similar problems were addressed
by [1] but that can't cover the failure cases from setup_device.

This patch drops the usages of xhci's virt_dev in xhci-mtk's drop_endpoint
callback by adopting rhashtable for searching mtk's schedule entity
from a given usb_host_endpoint pointer instead of searching a linked list.
So mtk's drop_endpoint callback doesn't have to rely on virt_dev at all.

[1] https://lore.kernel.org/r/1617179142-2681-2-git-send-email-chunfeng.yun@mediatek.com

Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Link: https://lore.kernel.org/r/20210805133731.1.Icc0f080e75b1312692d4c7c7d25e7df9fe1a05c2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 100 ++++++++++++++++----------------
 drivers/usb/host/xhci-mtk.h     |  11 +++-
 2 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index cffcaf4dfa9f..19482f0f3230 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -80,7 +80,7 @@ decode_ep(struct usb_host_endpoint *ep, enum usb_device_speed speed)
 		interval /= 1000;
 	}
 
-	snprintf(buf, DBG_BUF_EN, "%s ep%d%s %s, mpkt:%d, interval:%d/%d%s\n",
+	snprintf(buf, DBG_BUF_EN, "%s ep%d%s %s, mpkt:%d, interval:%d/%d%s",
 		 usb_speed_string(speed), usb_endpoint_num(epd),
 		 usb_endpoint_dir_in(epd) ? "in" : "out",
 		 usb_ep_type_string(usb_endpoint_type(epd)),
@@ -129,6 +129,10 @@ get_bw_info(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
 	int bw_index;
 
 	virt_dev = xhci->devs[udev->slot_id];
+	if (!virt_dev->real_port) {
+		WARN_ONCE(1, "%s invalid real_port\n", dev_name(&udev->dev));
+		return NULL;
+	}
 
 	if (udev->speed >= USB_SPEED_SUPER) {
 		if (usb_endpoint_dir_out(&ep->desc))
@@ -236,14 +240,20 @@ static void drop_tt(struct usb_device *udev)
 	}
 }
 
-static struct mu3h_sch_ep_info *create_sch_ep(struct usb_device *udev,
-	struct usb_host_endpoint *ep, struct xhci_ep_ctx *ep_ctx)
+static struct mu3h_sch_ep_info *
+create_sch_ep(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
+	      struct usb_host_endpoint *ep, struct xhci_ep_ctx *ep_ctx)
 {
 	struct mu3h_sch_ep_info *sch_ep;
+	struct mu3h_sch_bw_info *bw_info;
 	struct mu3h_sch_tt *tt = NULL;
 	u32 len_bw_budget_table;
 	size_t mem_size;
 
+	bw_info = get_bw_info(mtk, udev, ep);
+	if (!bw_info)
+		return ERR_PTR(-ENODEV);
+
 	if (is_fs_or_ls(udev->speed))
 		len_bw_budget_table = TT_MICROFRAMES_MAX;
 	else if ((udev->speed >= USB_SPEED_SUPER)
@@ -266,11 +276,13 @@ static struct mu3h_sch_ep_info *create_sch_ep(struct usb_device *udev,
 		}
 	}
 
+	sch_ep->bw_info = bw_info;
 	sch_ep->sch_tt = tt;
 	sch_ep->ep = ep;
 	sch_ep->speed = udev->speed;
 	INIT_LIST_HEAD(&sch_ep->endpoint);
 	INIT_LIST_HEAD(&sch_ep->tt_endpoint);
+	INIT_HLIST_NODE(&sch_ep->hentry);
 
 	return sch_ep;
 }
@@ -585,9 +597,9 @@ static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
 	return boundary;
 }
 
-static int check_sch_bw(struct mu3h_sch_bw_info *sch_bw,
-			struct mu3h_sch_ep_info *sch_ep)
+static int check_sch_bw(struct mu3h_sch_ep_info *sch_ep)
 {
+	struct mu3h_sch_bw_info *sch_bw = sch_ep->bw_info;
 	const u32 esit_boundary = get_esit_boundary(sch_ep);
 	const u32 bw_boundary = get_bw_boundary(sch_ep->speed);
 	u32 offset;
@@ -633,23 +645,26 @@ static int check_sch_bw(struct mu3h_sch_bw_info *sch_bw,
 	return load_ep_bw(sch_bw, sch_ep, true);
 }
 
-static void destroy_sch_ep(struct usb_device *udev,
-	struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
+static void destroy_sch_ep(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
+			   struct mu3h_sch_ep_info *sch_ep)
 {
 	/* only release ep bw check passed by check_sch_bw() */
 	if (sch_ep->allocated)
-		load_ep_bw(sch_bw, sch_ep, false);
+		load_ep_bw(sch_ep->bw_info, sch_ep, false);
 
 	if (sch_ep->sch_tt)
 		drop_tt(udev);
 
 	list_del(&sch_ep->endpoint);
+	hlist_del(&sch_ep->hentry);
 	kfree(sch_ep);
 }
 
-static bool need_bw_sch(struct usb_host_endpoint *ep,
-	enum usb_device_speed speed, int has_tt)
+static bool need_bw_sch(struct usb_device *udev,
+			struct usb_host_endpoint *ep)
 {
+	bool has_tt = udev->tt && udev->tt->hub->parent;
+
 	/* only for periodic endpoints */
 	if (usb_endpoint_xfer_control(&ep->desc)
 		|| usb_endpoint_xfer_bulk(&ep->desc))
@@ -660,7 +675,7 @@ static bool need_bw_sch(struct usb_host_endpoint *ep,
 	 * a TT are also ignored, root-hub will schedule them directly,
 	 * but need set @bpkts field of endpoint context to 1.
 	 */
-	if (is_fs_or_ls(speed) && !has_tt)
+	if (is_fs_or_ls(udev->speed) && !has_tt)
 		return false;
 
 	/* skip endpoint with zero maxpkt */
@@ -675,7 +690,6 @@ int xhci_mtk_sch_init(struct xhci_hcd_mtk *mtk)
 	struct xhci_hcd *xhci = hcd_to_xhci(mtk->hcd);
 	struct mu3h_sch_bw_info *sch_array;
 	int num_usb_bus;
-	int i;
 
 	/* ss IN and OUT are separated */
 	num_usb_bus = xhci->usb3_rhub.num_ports * 2 + xhci->usb2_rhub.num_ports;
@@ -684,12 +698,10 @@ int xhci_mtk_sch_init(struct xhci_hcd_mtk *mtk)
 	if (sch_array == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < num_usb_bus; i++)
-		INIT_LIST_HEAD(&sch_array[i].bw_ep_list);
-
 	mtk->sch_array = sch_array;
 
 	INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
+	hash_init(mtk->sch_ep_hash);
 
 	return 0;
 }
@@ -713,9 +725,7 @@ static int add_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 	ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
 
-	xhci_dbg(xhci, "%s %s\n", __func__, decode_ep(ep, udev->speed));
-
-	if (!need_bw_sch(ep, udev->speed, !!virt_dev->tt_info)) {
+	if (!need_bw_sch(udev, ep)) {
 		/*
 		 * set @bpkts to 1 if it is LS or FS periodic endpoint, and its
 		 * device does not connected through an external HS hub
@@ -727,13 +737,16 @@ static int add_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 		return 0;
 	}
 
-	sch_ep = create_sch_ep(udev, ep, ep_ctx);
+	xhci_dbg(xhci, "%s %s\n", __func__, decode_ep(ep, udev->speed));
+
+	sch_ep = create_sch_ep(mtk, udev, ep, ep_ctx);
 	if (IS_ERR_OR_NULL(sch_ep))
 		return -ENOMEM;
 
 	setup_sch_info(ep_ctx, sch_ep);
 
 	list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_chk_list);
+	hash_add(mtk->sch_ep_hash, &sch_ep->hentry, (unsigned long)ep);
 
 	return 0;
 }
@@ -743,22 +756,18 @@ static void drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 {
 	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct xhci_virt_device *virt_dev;
-	struct mu3h_sch_bw_info *sch_bw;
-	struct mu3h_sch_ep_info *sch_ep, *tmp;
-
-	virt_dev = xhci->devs[udev->slot_id];
-
-	xhci_dbg(xhci, "%s %s\n", __func__, decode_ep(ep, udev->speed));
+	struct mu3h_sch_ep_info *sch_ep;
+	struct hlist_node *hn;
 
-	if (!need_bw_sch(ep, udev->speed, !!virt_dev->tt_info))
+	if (!need_bw_sch(udev, ep))
 		return;
 
-	sch_bw = get_bw_info(mtk, udev, ep);
+	xhci_err(xhci, "%s %s\n", __func__, decode_ep(ep, udev->speed));
 
-	list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
+	hash_for_each_possible_safe(mtk->sch_ep_hash, sch_ep,
+				    hn, hentry, (unsigned long)ep) {
 		if (sch_ep->ep == ep) {
-			destroy_sch_ep(udev, sch_bw, sch_ep);
+			destroy_sch_ep(mtk, udev, sch_ep);
 			break;
 		}
 	}
@@ -769,30 +778,22 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev = xhci->devs[udev->slot_id];
-	struct mu3h_sch_bw_info *sch_bw;
-	struct mu3h_sch_ep_info *sch_ep, *tmp;
+	struct mu3h_sch_ep_info *sch_ep;
 	int ret;
 
 	xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
 
 	list_for_each_entry(sch_ep, &mtk->bw_ep_chk_list, endpoint) {
-		sch_bw = get_bw_info(mtk, udev, sch_ep->ep);
+		struct xhci_ep_ctx *ep_ctx;
+		struct usb_host_endpoint *ep = sch_ep->ep;
+		unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
 
-		ret = check_sch_bw(sch_bw, sch_ep);
+		ret = check_sch_bw(sch_ep);
 		if (ret) {
 			xhci_err(xhci, "Not enough bandwidth! (%s)\n",
 				 sch_error_string(-ret));
 			return -ENOSPC;
 		}
-	}
-
-	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
-		struct xhci_ep_ctx *ep_ctx;
-		struct usb_host_endpoint *ep = sch_ep->ep;
-		unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
-
-		sch_bw = get_bw_info(mtk, udev, ep);
-		list_move_tail(&sch_ep->endpoint, &sch_bw->bw_ep_list);
 
 		ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
 		ep_ctx->reserved[0] = cpu_to_le32(EP_BPKTS(sch_ep->pkts)
@@ -806,22 +807,23 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 			sch_ep->offset, sch_ep->repeat);
 	}
 
-	return xhci_check_bandwidth(hcd, udev);
+	ret = xhci_check_bandwidth(hcd, udev);
+	if (!ret)
+		INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
+
+	return ret;
 }
 
 void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct mu3h_sch_bw_info *sch_bw;
 	struct mu3h_sch_ep_info *sch_ep, *tmp;
 
 	xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
 
-	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
-		sch_bw = get_bw_info(mtk, udev, sch_ep->ep);
-		destroy_sch_ep(udev, sch_bw, sch_ep);
-	}
+	list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint)
+		destroy_sch_ep(mtk, udev, sch_ep);
 
 	xhci_reset_bandwidth(hcd, udev);
 }
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index ace432356c41..f87d199b0818 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -10,11 +10,15 @@
 #define _XHCI_MTK_H_
 
 #include <linux/clk.h>
+#include <linux/hashtable.h>
 
 #include "xhci.h"
 
 #define BULK_CLKS_NUM	5
 
+/* support at most 64 ep, use 32 size hash table */
+#define SCH_EP_HASH_BITS	5
+
 /**
  * To simplify scheduler algorithm, set a upper limit for ESIT,
  * if a synchromous ep's ESIT is larger than @XHCI_MTK_MAX_ESIT,
@@ -36,14 +40,12 @@ struct mu3h_sch_tt {
  * struct mu3h_sch_bw_info: schedule information for bandwidth domain
  *
  * @bus_bw: array to keep track of bandwidth already used at each uframes
- * @bw_ep_list: eps in the bandwidth domain
  *
  * treat a HS root port as a bandwidth domain, but treat a SS root port as
  * two bandwidth domains, one for IN eps and another for OUT eps.
  */
 struct mu3h_sch_bw_info {
 	u32 bus_bw[XHCI_MTK_MAX_ESIT];
-	struct list_head bw_ep_list;
 };
 
 /**
@@ -53,8 +55,10 @@ struct mu3h_sch_bw_info {
  * @num_budget_microframes: number of continuous uframes
  *		(@repeat==1) scheduled within the interval
  * @bw_cost_per_microframe: bandwidth cost per microframe
+ * @hentry: hash table entry
  * @endpoint: linked into bandwidth domain which it belongs to
  * @tt_endpoint: linked into mu3h_sch_tt's list which it belongs to
+ * @bw_info: bandwidth domain which this endpoint belongs
  * @sch_tt: mu3h_sch_tt linked into
  * @ep_type: endpoint type
  * @maxpkt: max packet size of endpoint
@@ -82,7 +86,9 @@ struct mu3h_sch_ep_info {
 	u32 num_budget_microframes;
 	u32 bw_cost_per_microframe;
 	struct list_head endpoint;
+	struct hlist_node hentry;
 	struct list_head tt_endpoint;
+	struct mu3h_sch_bw_info *bw_info;
 	struct mu3h_sch_tt *sch_tt;
 	u32 ep_type;
 	u32 maxpkt;
@@ -135,6 +141,7 @@ struct xhci_hcd_mtk {
 	struct usb_hcd *hcd;
 	struct mu3h_sch_bw_info *sch_array;
 	struct list_head bw_ep_chk_list;
+	DECLARE_HASHTABLE(sch_ep_hash, SCH_EP_HASH_BITS);
 	struct mu3c_ippc_regs __iomem *ippc_regs;
 	int num_u2_ports;
 	int num_u3_ports;
-- 
2.30.2

