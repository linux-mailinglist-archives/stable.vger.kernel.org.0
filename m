Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE99C38FCA0
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhEYIYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhEYIYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBC861401;
        Tue, 25 May 2021 08:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621930927;
        bh=RMh2s1flV1SxtkdnH8gTRbeXfuVDTPqIwYneYIOKCEQ=;
        h=Subject:To:From:Date:From;
        b=ch7bokXNICr1kCHFwJZ/O+iohFvRkjDYbm0xrsCvdUXnTiexOjQ/BPMtxH2Jqd3Bi
         HmcHz2GbjNptlBSLYQfLfQxE2/ufEqNbLEm72LQskmcEM23fWbRMRDw0oG7pE/VO6r
         kb3cKXEgZo2rNQQmwisoeppMi2gAYk9vWKxf+zkE=
Subject: patch "xhci: Fix 5.12 regression of missing xHC cache clearing command after" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        peter.ganzhorn@googlemail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 25 May 2021 10:21:57 +0200
Message-ID: <1621930917142177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix 5.12 regression of missing xHC cache clearing command after

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a7f2e9272aff1ccfe0fc801dab1d5a7a1c6b7ed2 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 25 May 2021 10:41:00 +0300
Subject: xhci: Fix 5.12 regression of missing xHC cache clearing command after
 a Stall

If endpoints halts due to a stall then the dequeue pointer read from
hardware may already be set ahead of the stalled TRB.
After commit 674f8438c121 ("xhci: split handling halted endpoints into two
steps") in 5.12 xhci driver won't issue a Set TR Dequeue if hardware
dequeue pointer is already in the right place.

Turns out the "Set TR Dequeue pointer" command is anyway needed as it in
addition to moving the dequeue pointer also clears endpoint state and
cache.

Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210525074100.1154090-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 256d336354a0..6acd2329e08d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -933,14 +933,18 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 			continue;
 		}
 		/*
-		 * If ring stopped on the TD we need to cancel, then we have to
+		 * If a ring stopped on the TD we need to cancel then we have to
 		 * move the xHC endpoint ring dequeue pointer past this TD.
+		 * Rings halted due to STALL may show hw_deq is past the stalled
+		 * TD, but still require a set TR Deq command to flush xHC cache.
 		 */
 		hw_deq = xhci_get_hw_deq(xhci, ep->vdev, ep->ep_index,
 					 td->urb->stream_id);
 		hw_deq &= ~0xf;
 
-		if (trb_in_td(xhci, td->start_seg, td->first_trb,
+		if (td->cancel_status == TD_HALTED) {
+			cached_td = td;
+		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
 			      td->last_trb, hw_deq, false)) {
 			switch (td->cancel_status) {
 			case TD_CLEARED: /* TD is already no-op */
-- 
2.31.1


