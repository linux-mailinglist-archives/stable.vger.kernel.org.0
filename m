Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471357FE61
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389728AbfHBQOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388740AbfHBQOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 12:14:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB7A20449;
        Fri,  2 Aug 2019 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564762483;
        bh=s7G1CZ11b1xmPb5OcuNjdDc8UfVrOeNGqKNBdFIW5N0=;
        h=Subject:To:From:Date:From;
        b=cvDZBQP6AJM8+jhI1oDTspiVJXFwTcQUsv0sjSzUvp9Eolfk5QhKzLdWS/61y0HM0
         EENlzNsg8k8lQlsAXy+815z14CqOt8qbGrPyO8CAaiTZtYb+xYrdx8V+JHRbrRWQOs
         yxt9W0nuhEToV4CQ4d/BaV6mTklU3es0kuTzI/bc=
Subject: patch "usb: host: xhci-rcar: Fix timeout in xhci_suspend()" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 02 Aug 2019 18:14:40 +0200
Message-ID: <15647624809311@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-rcar: Fix timeout in xhci_suspend()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 783bda5e41acc71f98336e1a402c180f9748e5dc Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Fri, 2 Aug 2019 17:33:35 +0900
Subject: usb: host: xhci-rcar: Fix timeout in xhci_suspend()

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
Link: https://lore.kernel.org/r/1564734815-17964-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-rcar.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 671bce18782c..8616c52849c6 100644
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
2.22.0


