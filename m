Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8111F37C2C8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhELPOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhELPLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 608DE61965;
        Wed, 12 May 2021 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831800;
        bh=JOjVieOFzp5Rry6thbHGsf8Ji+h1yWGuq29DvHerkEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1dG8auITnZd4G4AgrrnoE4An/YrTEQETyUagqFWIVy3ZSsNwrJbYAjbgo6yWDxPm
         TtyEIkFRrmkHnKryOXziDrVfCJAtuZupUuPqlr5G+aVCFjQSBTq+ZgFFiKdgtWB0ag
         TS7VSyEPpKClqMH/YBn9tLDsqq6lE6mHVV7YUE0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yaqii Wu <yaqii.wu@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.10 020/530] usb: xhci-mtk: improve bandwidth scheduling with TT
Date:   Wed, 12 May 2021 16:42:10 +0200
Message-Id: <20210512144820.392640941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit e19ee44a3d07c232f9241024dab1ebd0748cdf5f upstream.

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
 drivers/usb/host/xhci-mtk-sch.c |   74 ++++++++++++++++++++++++++++++++--------
 drivers/usb/host/xhci-mtk.h     |    6 ++-
 2 files changed, 64 insertions(+), 16 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -378,6 +378,31 @@ static void update_bus_bw(struct mu3h_sc
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
@@ -402,7 +427,7 @@ static int check_sch_tt(struct usb_devic
 			return -ERANGE;
 
 		for (i = 0; i < sch_ep->cs_count; i++)
-			if (test_bit(offset + i, tt->split_bit_map))
+			if (test_bit(offset + i, tt->ss_bit_map))
 				return -ERANGE;
 
 	} else {
@@ -432,7 +457,7 @@ static int check_sch_tt(struct usb_devic
 			cs_count = 7; /* HW limit */
 
 		for (i = 0; i < cs_count + 2; i++) {
-			if (test_bit(offset + i, tt->split_bit_map))
+			if (test_bit(offset + i, tt->ss_bit_map))
 				return -ERANGE;
 		}
 
@@ -448,24 +473,44 @@ static int check_sch_tt(struct usb_devic
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
@@ -535,7 +580,7 @@ static int check_sch_bw(struct usb_devic
 		if (!tt_offset_ok)
 			return -ERANGE;
 
-		update_sch_tt(udev, sch_ep);
+		update_sch_tt(udev, sch_ep, 1);
 	}
 
 	/* update bus bandwidth info */
@@ -548,15 +593,16 @@ static void destroy_sch_ep(struct usb_de
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


