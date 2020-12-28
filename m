Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650452E3FBC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503778AbgL1OoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgL1OoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:44:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D159207B2;
        Mon, 28 Dec 2020 14:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166613;
        bh=MKrWUOVjKPrc8/WgWek5tKBeA1/YxkrPkRUxLwiG/58=;
        h=Subject:To:From:Date:From;
        b=PGjhX4tzO0l826jSlCahmdHkb/QMiE1ul91K1Y+7PcImXvUiR5gW959pI+9dqWff6
         jHCH4BDY2w0rLW/ATEcRRIgi5TbaMDZh/3YyEcB8u2uoKJaqypbbk1E7QFMp4S/A9N
         i/qJlxvEkK7Km7Gtz8y99a/WkAHMVZ8xg78xIbzc=
Subject: patch "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk" added to usb-linus
To:     m.grzeschik@pengutronix.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:44:45 +0100
Message-ID: <1609166685182227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5d5323a6f3625f101dbfa94ba3ef7706cce38760 Mon Sep 17 00:00:00 2001
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Tue, 15 Dec 2020 20:31:47 +0100
Subject: USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk
 set

The commit 0472bf06c6fd ("xhci: Prevent U1/U2 link pm states if exit
latency is too long") was constraining the xhci code not to allow U1/U2
sleep states if the latency to wake up from the U-states reached the
service interval of an periodic endpoint. This fix was not taking into
account that in case the quirk XHCI_INTEL_HOST is set, the wakeup time
will be calculated and configured differently.

It checks for u1_params.mel/u2_params.mel as a limit. But the code could
decide to write another MEL into the hardware. This leads to broken
cases where not enough bandwidth is available for other devices:

usb 1-2: can't set config #1, error -28

This patch is fixing that case by checking for timeout_ns after the
wakeup time was calculated depending on the quirks.

Fixes: 0472bf06c6fd ("xhci: Prevent U1/U2 link pm states if exit latency is too long")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201215193147.11738-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 91ab81c3fc79..e86940571b4c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4770,19 +4770,19 @@ static u16 xhci_calculate_u1_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
+	else
+		timeout_ns = udev->u1_params.sel;
+
 	/* Prevent U1 if service interval is shorter than U1 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= udev->u1_params.mel) {
+		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
 			dev_dbg(&udev->dev, "Disable U1, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
-	else
-		timeout_ns = udev->u1_params.sel;
-
 	/* The U1 timeout is encoded in 1us intervals.
 	 * Don't return a timeout of zero, because that's USB3_LPM_DISABLED.
 	 */
@@ -4834,19 +4834,19 @@ static u16 xhci_calculate_u2_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
+	else
+		timeout_ns = udev->u2_params.sel;
+
 	/* Prevent U2 if service interval is shorter than U2 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= udev->u2_params.mel) {
+		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
 			dev_dbg(&udev->dev, "Disable U2, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
-	else
-		timeout_ns = udev->u2_params.sel;
-
 	/* The U2 timeout is encoded in 256us intervals */
 	timeout_ns = DIV_ROUND_UP_ULL(timeout_ns, 256 * 1000);
 	/* If the necessary timeout value is bigger than what we can set in the
-- 
2.29.2


