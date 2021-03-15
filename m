Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11EF33B55E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhCONyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhCONxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF9B064EF0;
        Mon, 15 Mar 2021 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816423;
        bh=kSqBe/A4bqMgkGYMNTqU0l0cCvmalAM90/thRxHwqzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGij01MzqGcQjuZao30fsMpysypIeZWpXU/xq+AncM/nexjczHhuOWf9vbVxNem4O
         0PWSPVr3nEWdEcU5Qe9vP6cYLIf/vH9PCKMOCCAQzksJON5qxW3uHET7xGt31k3LV/
         8OxvCt28NruRI4Nt+8RiaGifNSK0BsQU6IpSuJX0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 35/75] xhci: Improve detection of device initiated wake signal.
Date:   Mon, 15 Mar 2021 14:51:49 +0100
Message-Id: <20210315135209.395589774@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 253f588c70f66184b1f3a9bbb428b49bbda73e80 upstream.

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
 drivers/usb/host/xhci.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1018,6 +1018,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
 	bool			comp_timer_running = false;
+	bool			pending_portevent = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1151,13 +1152,22 @@ int xhci_resume(struct xhci_hcd *xhci, b
 
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


