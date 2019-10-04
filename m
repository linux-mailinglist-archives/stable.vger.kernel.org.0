Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7BCBA81
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbfJDMd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfJDMdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0737621D71;
        Fri,  4 Oct 2019 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192403;
        bh=O+34Z433+qWIQOMJcdoi9SXO2QO8Jm8MPqsrVP9HkUE=;
        h=Subject:To:From:Date:From;
        b=Jb6wu//omiouDcXNu6ChhU+5KuSsUxr1LY6ABpjzBRylzyXC+h4SUy15ZLotMApZ8
         rlLucD4GXlV9FW18XyI95kDaRpITHJiGKQL4VTJhd2a88OYoj40iMhDYYAATTH2kTs
         dstZG4c/rqaXKO7VJDsjQ90wJAhtOxAnf3hmigYE=
Subject: patch "xhci: Prevent deadlock when xhci adapter breaks during init" added to usb-linus
To:     William.Kuzeja@stratus.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        torez@redhat.com, william.kuzeja@stratus.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:07 +0200
Message-ID: <157019238714363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Prevent deadlock when xhci adapter breaks during init

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8de66b0e6a56ff10dd00d2b0f2ae52e300178587 Mon Sep 17 00:00:00 2001
From: Bill Kuzeja <William.Kuzeja@stratus.com>
Date: Fri, 4 Oct 2019 14:59:31 +0300
Subject: xhci: Prevent deadlock when xhci adapter breaks during init

The system can hit a deadlock if an xhci adapter breaks while initializing.
The deadlock is between two threads: thread 1 is tearing down the
adapter and is stuck in usb_unlocked_disable_lpm waiting to lock the
hcd->handwidth_mutex. Thread 2 is holding this mutex (while still trying
to add a usb device), but is stuck in xhci_endpoint_reset waiting for a
stop or config command to complete. A reboot is required to resolve.

It turns out when calling xhci_queue_stop_endpoint and
xhci_queue_configure_endpoint in xhci_endpoint_reset, the return code is
not checked for errors. If the timing is right and the adapter dies just
before either of these commands get issued, we hang indefinitely waiting
for a completion on a command that didn't get issued.

This wasn't a problem before the following fix because we didn't send
commands in xhci_endpoint_reset:

commit f5249461b504 ("xhci: Clear the host side toggle manually when
    endpoint is soft reset")

With the patch I am submitting, a duration test which breaks adapters
during initialization (and which deadlocks with the standard kernel) runs
without issue.

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Torez Smith <torez@redhat.com>
Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
Signed-off-by: Torez Smith <torez@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-7-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index fe8f9ff58015..8c068d0cc7c1 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3095,6 +3095,7 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 	unsigned int ep_index;
 	unsigned long flags;
 	u32 ep_flag;
+	int err;
 
 	xhci = hcd_to_xhci(hcd);
 	if (!host_ep->hcpriv)
@@ -3154,7 +3155,17 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 		xhci_free_command(xhci, cfg_cmd);
 		goto cleanup;
 	}
-	xhci_queue_stop_endpoint(xhci, stop_cmd, udev->slot_id, ep_index, 0);
+
+	err = xhci_queue_stop_endpoint(xhci, stop_cmd, udev->slot_id,
+					ep_index, 0);
+	if (err < 0) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, cfg_cmd);
+		xhci_dbg(xhci, "%s: Failed to queue stop ep command, %d ",
+				__func__, err);
+		goto cleanup;
+	}
+
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
@@ -3168,8 +3179,16 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 					   ctrl_ctx, ep_flag, ep_flag);
 	xhci_endpoint_copy(xhci, cfg_cmd->in_ctx, vdev->out_ctx, ep_index);
 
-	xhci_queue_configure_endpoint(xhci, cfg_cmd, cfg_cmd->in_ctx->dma,
+	err = xhci_queue_configure_endpoint(xhci, cfg_cmd, cfg_cmd->in_ctx->dma,
 				      udev->slot_id, false);
+	if (err < 0) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
+		xhci_free_command(xhci, cfg_cmd);
+		xhci_dbg(xhci, "%s: Failed to queue config ep command, %d ",
+				__func__, err);
+		goto cleanup;
+	}
+
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
-- 
2.23.0


