Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD340A980
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhINIno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhINInn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1023D60EE0;
        Tue, 14 Sep 2021 08:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608946;
        bh=8+6Uo8CPl2E1oWwkbNZPQ32/QLXzCLOwrmmVFZCKvYM=;
        h=Subject:To:From:Date:From;
        b=zMxZ9Aw8BGNXxSJJR8UOUjd4GoxCqXK5sYyzHuQO3p5AcHb82jJDPV/7fBUGkGsPt
         Jn2/XD8yWYiS9MRaBN4kf0lWC09DEnyHf+/ThywEveNoU+rAgN+OCDKN/Qr3Ouc9yT
         g7t9//InnKIjYEwY3yp/VziNpoCAsxXfdRrONLv0=
Subject: patch "usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA" added to usb-linus
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:42:12 +0200
Message-ID: <163160893225484@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dbe2518b2d8eabffa74dbf7d9fdd7dacddab7fc0 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Sat, 11 Sep 2021 22:58:30 +0400
Subject: usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

When last descriptor in a descriptor list completed with XferComplete
interrupt, core switching to handle next descriptor and assert BNA
interrupt. Both these interrupts are set while dwc2_hsotg_epint()
handler called. Each interrupt should be handled separately: first
XferComplete interrupt then BNA interrupt, otherwise last completed
transfer will not be giveback to function driver as completed
request.

Fixes: 729cac693eec ("usb: dwc2: Change ISOC DDMA flow")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/a36981accc26cd674c5d8f8da6164344b94ec1fe.1631386531.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index f09cbdfac9df..11d85a6e0b0d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3067,9 +3067,7 @@ static void dwc2_hsotg_epint(struct dwc2_hsotg *hsotg, unsigned int idx,
 
 		/* In DDMA handle isochronous requests separately */
 		if (using_desc_dma(hsotg) && hs_ep->isochronous) {
-			/* XferCompl set along with BNA */
-			if (!(ints & DXEPINT_BNAINTR))
-				dwc2_gadget_complete_isoc_request_ddma(hs_ep);
+			dwc2_gadget_complete_isoc_request_ddma(hs_ep);
 		} else if (dir_in) {
 			/*
 			 * We get OutDone from the FIFO, so we only
-- 
2.33.0


