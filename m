Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBC7EF63
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404268AbfHBIew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:34:52 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:48600 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729739AbfHBIew (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 04:34:52 -0400
X-IronPort-AV: E=Sophos;i="5.64,337,1559487600"; 
   d="scan'208";a="23157724"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Aug 2019 17:34:50 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 3462A41DCD1E;
        Fri,  2 Aug 2019 17:34:50 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     gregkh@linuxfoundation.org, mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] usb: host: xhci-rcar: Fix timeout in xhci_suspend()
Date:   Fri,  2 Aug 2019 17:33:35 +0900
Message-Id: <1564734815-17964-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a USB device is connected to the host controller and
the system enters suspend, the following error happens
in xhci_suspend():

	xhci-hcd ee000000.usb: WARN: xHC CMD_RUN timeout

Since the firmware/internal CPU control the USBSTS.STS_HALT
and the process speed is down when the roothub port enters U3,
long delay for the handshake of STS_HALT is neeed in xhci_suspend().
So, this patch adds to set the XHCI_SLOW_SUSPEND.

Fixes: 435cc1138ec9 ("usb: host: xhci-plat: set resume_quirk() for R-Car controllers")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/usb/host/xhci-rcar.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 671bce1..8616c52 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -238,10 +238,15 @@ int xhci_rcar_init_quirk(struct usb_hcd *hcd)
 	 * pointers. So, this driver clears the AC64 bit of xhci->hcc_params
 	 * to call dma_set_coherent_mask(dev, DMA_BIT_MASK(32)) in
 	 * xhci_gen_setup().
+	 *
+	 * And, since the firmware/internal CPU control the USBSTS.STS_HALT
+	 * and the process speed is down when the roothub port enters U3,
+	 * long delay for the handshake of STS_HALT is neeed in xhci_suspend().
 	 */
 	if (xhci_rcar_is_gen2(hcd->self.controller) ||
-			xhci_rcar_is_gen3(hcd->self.controller))
-		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
+			xhci_rcar_is_gen3(hcd->self.controller)) {
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT | XHCI_SLOW_SUSPEND;
+	}
 
 	if (!xhci_rcar_wait_for_pll_active(hcd))
 		return -ETIMEDOUT;
-- 
2.7.4

