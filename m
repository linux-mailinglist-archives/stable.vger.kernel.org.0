Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8FE431DAE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhJRNyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233791AbhJRNv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFD8619A6;
        Mon, 18 Oct 2021 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564309;
        bh=BJfVGth+XBFXpcNfFwkBCwZOQDZcj4y8psZbfPfjugs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsO5NMBzdRYQcOYFODujZG/NfULfojoOczoWeTsemLNmnuJ5hR2/tSJOQ3plyaJtz
         sbTupEA4S0ma+pVuUvEanNa0qBVS/CM4/BFh1X4rXPR0AnZQwD6d9HJTX2rxSx0xeZ
         kv/82ImH6/f7IsORPhgZoufTOOVjvWzWh2FBoDx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bell <jonathan@raspberrypi.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.14 041/151] xhci: guard accesses to ep_state in xhci_endpoint_reset()
Date:   Mon, 18 Oct 2021 15:23:40 +0200
Message-Id: <20211018132342.032810455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.com>

commit a01ba2a3378be85538e0183ae5367c1bc1d5aaf3 upstream.

See https://github.com/raspberrypi/linux/issues/3981

Two read-modify-write cycles on ep->ep_state are not guarded by
xhci->lock. Fix these.

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211008092547.3996295-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3212,10 +3212,13 @@ static void xhci_endpoint_reset(struct u
 		return;
 
 	/* Bail out if toggle is already being cleared by a endpoint reset */
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_HARD_CLEAR_TOGGLE) {
 		ep->ep_state &= ~EP_HARD_CLEAR_TOGGLE;
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
 	}
+	spin_unlock_irqrestore(&xhci->lock, flags);
 	/* Only interrupt and bulk ep's use data toggle, USB2 spec 5.5.4-> */
 	if (usb_endpoint_xfer_control(&host_ep->desc) ||
 	    usb_endpoint_xfer_isoc(&host_ep->desc))
@@ -3301,8 +3304,10 @@ static void xhci_endpoint_reset(struct u
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	spin_lock_irqsave(&xhci->lock, flags);
 	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
 		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
+	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,


