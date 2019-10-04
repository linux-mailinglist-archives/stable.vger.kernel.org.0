Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A760CB99E
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfJDL5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 07:57:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:33448 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDL5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 07:57:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 04:57:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="186229454"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2019 04:57:47 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Bill Kuzeja <William.Kuzeja@stratus.com>,
        "# v4 . 17+" <stable@vger.kernel.org>,
        Torez Smith <torez@redhat.com>,
        Bill Kuzeja <william.kuzeja@stratus.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6/8] xhci: Prevent deadlock when xhci adapter breaks during init
Date:   Fri,  4 Oct 2019 14:59:31 +0300
Message-Id: <1570190373-30684-7-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bill Kuzeja <William.Kuzeja@stratus.com>

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

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when
    endpoint is soft reset")
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Torez Smith <torez@redhat.com>
Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
Signed-off-by: Torez Smith <torez@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
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
2.7.4

