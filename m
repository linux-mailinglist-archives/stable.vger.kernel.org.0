Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8E65EA0C0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiIZKlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiIZKj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120DC543E7;
        Mon, 26 Sep 2022 03:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B0BAB8092B;
        Mon, 26 Sep 2022 10:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64155C433C1;
        Mon, 26 Sep 2022 10:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187823;
        bh=RKOpVFNMZWBiILH99dSIKHVuiodIBHC1WyT1+BwZlKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoKN56LEYiloB992S5QCYJHwDnjch+ZlQPiVYUw7J1gvENGm4gZIJq1dzd8JyVXrq
         pyRMCTw0vJeqXkesn+rxKhtFr9GEgE6rtHVFHWmtOZ1ABtPFNqsZN2u/q76LWJRaRV
         dj5vkH/wMvhP8xV6wy0QVa7z9eMpQXBe8BjMTp14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/120] usb: xhci-mtk: add some schedule error number
Date:   Mon, 26 Sep 2022 12:11:12 +0200
Message-Id: <20220926100752.123244444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit ccda8c224c0701caac007311d06a2de9543a7590 ]

This is used to provide more information about which case
causes bandwidth schedule failure.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/9771f44093053b581e9c4be4b7fb68d9fcecad08.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 44 ++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 9a9685f74940..a6ec75bf2def 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -25,6 +25,13 @@
  */
 #define TT_MICROFRAMES_MAX 9
 
+/* schedule error type */
+#define ESCH_SS_Y6		1001
+#define ESCH_SS_OVERLAP		1002
+#define ESCH_CS_OVERFLOW	1003
+#define ESCH_BW_OVERFLOW	1004
+#define ESCH_FIXME		1005
+
 /* mtk scheduler bitmasks */
 #define EP_BPKTS(p)	((p) & 0x7f)
 #define EP_BCSCOUNT(p)	(((p) & 0x7) << 8)
@@ -32,6 +39,24 @@
 #define EP_BOFFSET(p)	((p) & 0x3fff)
 #define EP_BREPEAT(p)	(((p) & 0x7fff) << 16)
 
+static char *sch_error_string(int err_num)
+{
+	switch (err_num) {
+	case ESCH_SS_Y6:
+		return "Can't schedule Start-Split in Y6";
+	case ESCH_SS_OVERLAP:
+		return "Can't find a suitable Start-Split location";
+	case ESCH_CS_OVERFLOW:
+		return "The last Complete-Split is greater than 7";
+	case ESCH_BW_OVERFLOW:
+		return "Bandwidth exceeds the maximum limit";
+	case ESCH_FIXME:
+		return "FIXME, to be resolved";
+	default:
+		return "Unknown";
+	}
+}
+
 static int is_fs_or_ls(enum usb_device_speed speed)
 {
 	return speed == USB_SPEED_FULL || speed == USB_SPEED_LOW;
@@ -395,7 +420,7 @@ static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
 		for (j = 0; j < sch_ep->cs_count; j++) {
 			tmp = tt->fs_bus_bw[base + j] + sch_ep->bw_cost_per_microframe;
 			if (tmp > FS_PAYLOAD_MAX)
-				return -ERANGE;
+				return -ESCH_BW_OVERFLOW;
 		}
 	}
 
@@ -421,11 +446,11 @@ static int check_sch_tt(struct usb_device *udev,
 		 * must never schedule Start-Split in Y6
 		 */
 		if (!(start_ss == 7 || last_ss < 6))
-			return -ERANGE;
+			return -ESCH_SS_Y6;
 
 		for (i = 0; i < sch_ep->cs_count; i++)
 			if (test_bit(offset + i, tt->ss_bit_map))
-				return -ERANGE;
+				return -ESCH_SS_OVERLAP;
 
 	} else {
 		u32 cs_count = DIV_ROUND_UP(sch_ep->maxpkt, FS_PAYLOAD_MAX);
@@ -435,14 +460,14 @@ static int check_sch_tt(struct usb_device *udev,
 		 * must never schedule Start-Split in Y6
 		 */
 		if (start_ss == 6)
-			return -ERANGE;
+			return -ESCH_SS_Y6;
 
 		/* one uframe for ss + one uframe for idle */
 		start_cs = (start_ss + 2) % 8;
 		last_cs = start_cs + cs_count - 1;
 
 		if (last_cs > 7)
-			return -ERANGE;
+			return -ESCH_CS_OVERFLOW;
 
 		if (sch_ep->ep_type == ISOC_IN_EP)
 			extra_cs_count = (last_cs == 7) ? 1 : 2;
@@ -454,7 +479,7 @@ static int check_sch_tt(struct usb_device *udev,
 			cs_count = 7; /* HW limit */
 
 		if (test_bit(offset, tt->ss_bit_map))
-			return -ERANGE;
+			return -ESCH_SS_OVERLAP;
 
 		sch_ep->cs_count = cs_count;
 		/* one for ss, the other for idle */
@@ -547,7 +572,7 @@ static int check_sch_bw(struct usb_device *udev,
 	u32 esit_boundary;
 	u32 min_num_budget;
 	u32 min_cs_count;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Search through all possible schedule microframes.
@@ -588,7 +613,7 @@ static int check_sch_bw(struct usb_device *udev,
 
 	/* check bandwidth */
 	if (min_bw > bw_boundary)
-		return -ERANGE;
+		return ret ? ret : -ESCH_BW_OVERFLOW;
 
 	sch_ep->offset = min_index;
 	sch_ep->cs_count = min_cs_count;
@@ -765,7 +790,8 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 
 		ret = check_sch_bw(udev, sch_bw, sch_ep);
 		if (ret) {
-			xhci_err(xhci, "Not enough bandwidth!\n");
+			xhci_err(xhci, "Not enough bandwidth! (%s)\n",
+				 sch_error_string(-ret));
 			return -ENOSPC;
 		}
 	}
-- 
2.35.1



