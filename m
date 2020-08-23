Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB0024EDDE
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 17:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgHWPM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 11:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgHWPMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 11:12:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F1E4206B5;
        Sun, 23 Aug 2020 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598195574;
        bh=K6d7EYRizb6q67hJOzX7aI58fuwaboJiuqPCDkYxAlU=;
        h=Subject:To:From:Date:From;
        b=Tfxk4/DARiq1x3AczZngi9I1FMN9D6ZU9PAcHTAdvEn2x9g2iC1zAmj3d5cr7c7aI
         XUx8InMrUMqa2T870yLleWnXgWjGpb6IxIWGsml+AjViFqrh+FU7/gbafe2UIvVHx1
         MiWFe0YDXSIOqO2EAfRlG/9bmYOwUJSuG/terfUk=
Subject: patch "xhci: Do warm-reset when both CAS and XDEV_RESUME are set" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 17:13:06 +0200
Message-ID: <159819558691182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Do warm-reset when both CAS and XDEV_RESUME are set

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 904df64a5f4d5ebd670801d869ca0a6d6a6e8df6 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 21 Aug 2020 12:15:48 +0300
Subject: xhci: Do warm-reset when both CAS and XDEV_RESUME are set

Sometimes re-plugging a USB device during system sleep renders the device
useless:
[  173.418345] xhci_hcd 0000:00:14.0: Get port status 2-4 read: 0x14203e2, return 0x10262
...
[  176.496485] usb 2-4: Waited 2000ms for CONNECT
[  176.496781] usb usb2-port4: status 0000.0262 after resume, -19
[  176.497103] usb 2-4: can't resume, status -19
[  176.497438] usb usb2-port4: logical disconnect

Because PLS equals to XDEV_RESUME, xHCI driver reports U3 to usbcore,
despite of CAS bit is flagged.

So proritize CAS over XDEV_RESUME to let usbcore handle warm-reset for
the port.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200821091549.20556-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index c3554e37e09f..4e14e164cb68 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -740,15 +740,6 @@ static void xhci_hub_report_usb3_link_state(struct xhci_hcd *xhci,
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
-	/* resume state is a xHCI internal state.
-	 * Do not report it to usb core, instead, pretend to be U3,
-	 * thus usb core knows it's not ready for transfer
-	 */
-	if (pls == XDEV_RESUME) {
-		*status |= USB_SS_PORT_LS_U3;
-		return;
-	}
-
 	/* When the CAS bit is set then warm reset
 	 * should be performed on port
 	 */
@@ -770,6 +761,16 @@ static void xhci_hub_report_usb3_link_state(struct xhci_hcd *xhci,
 		 */
 		pls |= USB_PORT_STAT_CONNECTION;
 	} else {
+		/*
+		 * Resume state is an xHCI internal state.  Do not report it to
+		 * usb core, instead, pretend to be U3, thus usb core knows
+		 * it's not ready for transfer.
+		 */
+		if (pls == XDEV_RESUME) {
+			*status |= USB_SS_PORT_LS_U3;
+			return;
+		}
+
 		/*
 		 * If CAS bit isn't set but the Port is already at
 		 * Compliance Mode, fake a connection so the USB core
-- 
2.28.0


