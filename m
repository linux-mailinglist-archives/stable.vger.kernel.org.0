Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CDA38FC9F
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhEYIYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231292AbhEYIYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DDE611C9;
        Tue, 25 May 2021 08:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621930919;
        bh=wzrCxzCQWY/SLG3ushnPYuAZy5j8VRzLO59I2DRYmvo=;
        h=Subject:To:From:Date:From;
        b=Ae/OuBqYTtJV0yAFc/xLbou967ojEQvibJvsjPfQocAni02ezZvPMCJ/Dr6cYO3nm
         /gvt4JEEA8wO0scY/WJhoYFvPfFAYW2dDufGANwIrqga01Gxbgg6wbQk5zZMLhvglb
         P5Wsdl6IW9pseZEx2LWKy3wHAzmWsVFsmShtZ1DA=
Subject: patch "xhci: fix giving back URB with incorrect status regression in 5.12" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        peter.ganzhorn@googlemail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 25 May 2021 10:21:56 +0200
Message-ID: <162193091629225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: fix giving back URB with incorrect status regression in 5.12

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a80c203c3f1c06d2201c19ae071d0ae770a2b1ca Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 25 May 2021 10:40:59 +0300
Subject: xhci: fix giving back URB with incorrect status regression in 5.12

5.12 kernel changes how xhci handles cancelled URBs and halted
endpoints. Among these changes cancelled and stalled URBs are no longer
given back before they are cleared from xHC hardware cache.

These changes unfortunately cleared the -EPIPE status of a stalled
transfer in one case before giving bak the URB, causing a USB card reader
to fail from working.

Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> # 5.12
Reported-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Tested-by: Peter Ganzhorn <peter.ganzhorn@googlemail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210525074100.1154090-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a8e4189277da..256d336354a0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -828,14 +828,10 @@ static void xhci_giveback_invalidated_tds(struct xhci_virt_ep *ep)
 	list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list,
 				 cancelled_td_list) {
 
-		/*
-		 * Doesn't matter what we pass for status, since the core will
-		 * just overwrite it (because the URB has been unlinked).
-		 */
 		ring = xhci_urb_to_transfer_ring(ep->xhci, td->urb);
 
 		if (td->cancel_status == TD_CLEARED)
-			xhci_td_cleanup(ep->xhci, td, ring, 0);
+			xhci_td_cleanup(ep->xhci, td, ring, td->status);
 
 		if (ep->xhci->xhc_state & XHCI_STATE_DYING)
 			return;
-- 
2.31.1


