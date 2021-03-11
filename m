Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792613371F8
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 13:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhCKMEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 07:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhCKMDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 07:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2563264FC0;
        Thu, 11 Mar 2021 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615464233;
        bh=mWGJoL1oaB6Ietj5BjyF1bmfbX2nTau3UJgFTPH+Cs4=;
        h=Subject:To:From:Date:From;
        b=z7kuROnj5+PBjBWvFJWZoJo+Wwn0LhXpAZj8pxe2A0jSng1liw/TawqH9fcvGpXcM
         kCZFVC4+QK9n3abMszHLBD//+ZEQlzhDQ7n+hPvbdLZ0GThKZXTy/QIltCV0nwGwHP
         lrfwS5EyEX24PBSutWZk/FhR5ISy1F7l49CEWOJc=
Subject: patch "xhci: Improve detection of device initiated wake signal." added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 13:03:40 +0100
Message-ID: <1615464220172191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Improve detection of device initiated wake signal.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 253f588c70f66184b1f3a9bbb428b49bbda73e80 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 11 Mar 2021 13:53:51 +0200
Subject: xhci: Improve detection of device initiated wake signal.

A xHC USB 3 port might miss the first wake signal from a USB 3 device
if the port LFPS reveiver isn't enabled fast enough after xHC resume.

xHC host will anyway be resumed by a PME# signal, but will go back to
suspend if no port activity is seen.
The device resends the U3 LFPS wake signal after a 100ms delay, but
by then host is already suspended, starting all over from the
beginning of this issue.

USB 3 specs say U3 wake LFPS signal is sent for max 10ms, then device
needs to delay 100ms before resending the wake.

Don't suspend immediately if port activity isn't detected in resume.
Instead add a retry. If there is no port activity then delay for 120ms,
and re-check for port activity.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210311115353.2137560-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bd27bd670104..48a68fcf2b36 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1088,6 +1088,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
 	bool			comp_timer_running = false;
+	bool			pending_portevent = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1226,13 +1227,22 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
  done:
 	if (retval == 0) {
-		/* Resume root hubs only when have pending events. */
-		if (xhci_pending_portevent(xhci)) {
+		/*
+		 * Resume roothubs only if there are pending events.
+		 * USB 3 devices resend U3 LFPS wake after a 100ms delay if
+		 * the first wake signalling failed, give it that chance.
+		 */
+		pending_portevent = xhci_pending_portevent(xhci);
+		if (!pending_portevent) {
+			msleep(120);
+			pending_portevent = xhci_pending_portevent(xhci);
+		}
+
+		if (pending_portevent) {
 			usb_hcd_resume_root_hub(xhci->shared_hcd);
 			usb_hcd_resume_root_hub(hcd);
 		}
 	}
-
 	/*
 	 * If system is subject to the Quirk, Compliance Mode Timer needs to
 	 * be re-initialized Always after a system resume. Ports are subject
-- 
2.30.2


