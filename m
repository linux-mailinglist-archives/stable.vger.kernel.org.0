Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3F331080
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCHOMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231255AbhCHOL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B25B265121;
        Mon,  8 Mar 2021 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615212719;
        bh=1L5HBP1EpvQgYIBWNPSX8swGP0GIhhjSVsJnDmxyI0A=;
        h=Subject:To:From:Date:From;
        b=yInV9u5emHwGfswSEVam9WptNpObNHoOq7p+Z5cU/3b1AFYfZPtfMBeDyV2cVvwj5
         2KWWnE/wcm0WmWanuvPLTp0i+xCQIF4FjLSkEYxl1WJ/oQLBX3ya9slQpoERcqHj3u
         3EJxC0DzzsMR6IDRxa8Wq8CCKUBnpqufapIVufX8=
Subject: patch "usb: xhci-mtk: improve bandwidth scheduling with TT" added to usb-testing
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yaqii.wu@mediatek.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 14:25:40 +0100
Message-ID: <161520994018068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: improve bandwidth scheduling with TT

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 99ea56bd89aa3a644d6af34301a0b0f3f5f92314 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Mon, 8 Mar 2021 10:51:51 +0800
Subject: usb: xhci-mtk: improve bandwidth scheduling with TT

When the USB headset is plug into an external hub, sometimes
can't set config due to not enough bandwidth, so need improve
LS/FS INT/ISOC bandwidth scheduling with TT.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yaqii Wu <yaqii.wu@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/2f30e81400a59afef5f8231c98149169c7520519.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 74 ++++++++++++++++++++++++++-------
 drivers/usb/host/xhci-mtk.h     |  6 ++-
 2 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 5891f56c64da..8950d1f10a7f 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -378,6 +378,31 @@ static void update_bus_bw(struct mu3h_sch_bw_info *sch_bw,
 	sch_ep->allocated = used;
 }
 
+static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
+{
+	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
+	u32 num_esit, tmp;
+	int base;
+	int i, j;
+
+	num_esit = XHCI_MTK_MAX_ESIT / sch_ep->esit;
+	for (i = 0; i < num_esit; i++) {
+		base = offset + i * sch_ep->esit;
+
+		/*
+		 * Compared with hs bus, no matter what ep type,
+		 * the hub will always delay one uframe to send data
+		 */
+		for (j = 0; j < sch_ep->cs_count; j++) {
+			tmp = tt->fs_bus_bw[base + j] + sch_ep->bw_cost_per_microframe;
+			if (tmp > FS_PAYLOAD_MAX)
+				return -ERANGE;
+		}
+	}
+
+	return 0;
+}
+
 static int check_sch_tt(struct usb_device *udev,
 	struct mu3h_sch_ep_info *sch_ep, u32 offset)
 {
@@ -402,7 +427,7 @@ static int check_sch_tt(struct usb_device *udev,
 			return -ERANGE;
 
 		for (i = 0; i < sch_ep->cs_count; i++)
-			if (test_bit(offset + i, tt->split_bit_map))
+			if (test_bit(offset + i, tt->ss_bit_map))
 				return -ERANGE;
 
 	} else {
@@ -432,7 +457,7 @@ static int check_sch_tt(struct usb_device *udev,
 			cs_count = 7; /* HW limit */
 
 		for (i = 0; i < cs_count + 2; i++) {
-			if (test_bit(offset + i, tt->split_bit_map))
+			if (test_bit(offset + i, tt->ss_bit_map))
 				return -ERANGE;
 		}
 
@@ -448,24 +473,44 @@ static int check_sch_tt(struct usb_device *udev,
 			sch_ep->num_budget_microframes = sch_ep->esit;
 	}
 
-	return 0;
+	return check_fs_bus_bw(sch_ep, offset);
 }
 
 static void update_sch_tt(struct usb_device *udev,
-	struct mu3h_sch_ep_info *sch_ep)
+	struct mu3h_sch_ep_info *sch_ep, bool used)
 {
 	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
 	u32 base, num_esit;
+	int bw_updated;
+	int bits;
 	int i, j;
 
 	num_esit = XHCI_MTK_MAX_ESIT / sch_ep->esit;
+	bits = (sch_ep->ep_type == ISOC_OUT_EP) ? sch_ep->cs_count : 1;
+
+	if (used)
+		bw_updated = sch_ep->bw_cost_per_microframe;
+	else
+		bw_updated = -sch_ep->bw_cost_per_microframe;
+
 	for (i = 0; i < num_esit; i++) {
 		base = sch_ep->offset + i * sch_ep->esit;
-		for (j = 0; j < sch_ep->num_budget_microframes; j++)
-			set_bit(base + j, tt->split_bit_map);
+
+		for (j = 0; j < bits; j++) {
+			if (used)
+				set_bit(base + j, tt->ss_bit_map);
+			else
+				clear_bit(base + j, tt->ss_bit_map);
+		}
+
+		for (j = 0; j < sch_ep->cs_count; j++)
+			tt->fs_bus_bw[base + j] += bw_updated;
 	}
 
-	list_add_tail(&sch_ep->tt_endpoint, &tt->ep_list);
+	if (used)
+		list_add_tail(&sch_ep->tt_endpoint, &tt->ep_list);
+	else
+		list_del(&sch_ep->tt_endpoint);
 }
 
 static int check_sch_bw(struct usb_device *udev,
@@ -535,7 +580,7 @@ static int check_sch_bw(struct usb_device *udev,
 		if (!tt_offset_ok)
 			return -ERANGE;
 
-		update_sch_tt(udev, sch_ep);
+		update_sch_tt(udev, sch_ep, 1);
 	}
 
 	/* update bus bandwidth info */
@@ -548,15 +593,16 @@ static void destroy_sch_ep(struct usb_device *udev,
 	struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
 {
 	/* only release ep bw check passed by check_sch_bw() */
-	if (sch_ep->allocated)
+	if (sch_ep->allocated) {
 		update_bus_bw(sch_bw, sch_ep, 0);
+		if (sch_ep->sch_tt)
+			update_sch_tt(udev, sch_ep, 0);
+	}
 
-	list_del(&sch_ep->endpoint);
-
-	if (sch_ep->sch_tt) {
-		list_del(&sch_ep->tt_endpoint);
+	if (sch_ep->sch_tt)
 		drop_tt(udev);
-	}
+
+	list_del(&sch_ep->endpoint);
 	kfree(sch_ep);
 }
 
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index cbb09dfea62e..f42769c69249 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -20,13 +20,15 @@
 #define XHCI_MTK_MAX_ESIT	64
 
 /**
- * @split_bit_map: used to avoid split microframes overlay
+ * @ss_bit_map: used to avoid start split microframes overlay
+ * @fs_bus_bw: array to keep track of bandwidth already used for FS
  * @ep_list: Endpoints using this TT
  * @usb_tt: usb TT related
  * @tt_port: TT port number
  */
 struct mu3h_sch_tt {
-	DECLARE_BITMAP(split_bit_map, XHCI_MTK_MAX_ESIT);
+	DECLARE_BITMAP(ss_bit_map, XHCI_MTK_MAX_ESIT);
+	u32 fs_bus_bw[XHCI_MTK_MAX_ESIT];
 	struct list_head ep_list;
 	struct usb_tt *usb_tt;
 	int tt_port;
-- 
2.30.1


