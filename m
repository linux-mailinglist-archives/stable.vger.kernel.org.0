Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A706232E425
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCEJDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:03:31 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:44144 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229592AbhCEJDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:03:21 -0500
X-UUID: 72add01885ab4103978fc8f1637a6efd-20210305
X-UUID: 72add01885ab4103978fc8f1637a6efd-20210305
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1708881881; Fri, 05 Mar 2021 17:03:16 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 5 Mar 2021 17:03:15 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:03:14 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ikjoon Jang <ikjn@chromium.org>
CC:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        stable <stable@vger.kernel.org>, Yaqii Wu <yaqii.wu@mediatek.com>
Subject: [PATCH 02/17] usb: xhci-mtk: improve bandwidth scheduling with TT
Date:   Fri, 5 Mar 2021 17:02:40 +0800
Message-ID: <1614934975-15188-2-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1614934975-15188-1-git-send-email-chunfeng.yun@mediatek.com>
References: <1614934975-15188-1-git-send-email-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the USB headset is plug into an external hub, sometimes
can't set config due to not enough bandwidth, so need improve
LS/FS INT/ISOC bandwidth scheduling with TT.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yaqii Wu <yaqii.wu@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
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
2.18.0

