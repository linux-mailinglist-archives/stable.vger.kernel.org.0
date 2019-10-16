Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D392D9E2F
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437932AbfJPV4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437931AbfJPV4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:52 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3AE8218DE;
        Wed, 16 Oct 2019 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263011;
        bh=QnzyiG1RU6k+z3AYzuEm5NDXb59XVvAABJsQUEMmJf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xN0CGx/EHvmjbCaXeum43DjaegBVQtCklvrofDiPk6ZIsZQaSQ0NARUNMdfEWkWOY
         WNraNH+VnogbRmIA7jZcfTENtunmnJOcyxNZJe2JFZG+dVJjuEtgnGzBQttiJ2xRbb
         WUwFYfZZ8oI0iiQG6ntcyb4PrjUv/0eVUH834wr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Torez Smith <torez@redhat.com>,
        Bill Kuzeja <william.kuzeja@stratus.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 13/81] xhci: Prevent deadlock when xhci adapter breaks during init
Date:   Wed, 16 Oct 2019 14:50:24 -0700
Message-Id: <20191016214818.188637314@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bill Kuzeja <William.Kuzeja@stratus.com>

commit 8de66b0e6a56ff10dd00d2b0f2ae52e300178587 upstream.

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
 drivers/usb/host/xhci.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3065,6 +3065,7 @@ static void xhci_endpoint_reset(struct u
 	unsigned int ep_index;
 	unsigned long flags;
 	u32 ep_flag;
+	int err;
 
 	xhci = hcd_to_xhci(hcd);
 	if (!host_ep->hcpriv)
@@ -3114,7 +3115,17 @@ static void xhci_endpoint_reset(struct u
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
 
@@ -3128,8 +3139,16 @@ static void xhci_endpoint_reset(struct u
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
 


