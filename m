Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F4915C840
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgBMQbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:31:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgBMQbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 11:31:39 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5812082F;
        Thu, 13 Feb 2020 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581611499;
        bh=Tod5NLHzzx9e+bpKgjkbb6MEjQ3Gx+HBHVo+zKPOdNI=;
        h=Subject:To:From:Date:From;
        b=Me7cJSfXwDnGTHqFsSXbEsUglsmqX3ydw72FE703xlWd6z1Ls8QGabDV4IrfV0XMf
         U/kMswA3b6a+5QrvFSREaoZrj1mVL+5o8f1lJQxXLbDyZieVtAxnnZ3qxfoNKYKtVt
         QZLI/r/63aD70zqvt2DI7y2PRgGXBWfr37QGw7LI=
Subject: patch "usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields" added to usb-linus
To:     anurag.kumar.vulisha@xilinx.com, andrzej.p@collabora.com,
        balbi@kernel.org, fei.yang@intel.com, gregkh@linuxfoundation.org,
        jackp@codeaurora.org, john.stultz@linaro.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        tejas.joglekar@synopsys.com, thinhn@synopsys.com, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Feb 2020 08:31:38 -0800
Message-ID: <1581611498166148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5ee858975b13a9b40db00f456989a689fdbb296c Mon Sep 17 00:00:00 2001
From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
Date: Mon, 27 Jan 2020 19:30:46 +0000
Subject: usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields

The current code in dwc3_gadget_ep_reclaim_completed_trb() will
check for IOC/LST bit in the event->status and returns if
IOC/LST bit is set. This logic doesn't work if multiple TRBs
are queued per request and the IOC/LST bit is set on the last
TRB of that request.

Consider an example where a queued request has multiple queued
TRBs and IOC/LST bit is set only for the last TRB. In this case,
the core generates XferComplete/XferInProgress events only for
the last TRB (since IOC/LST are set only for the last TRB). As
per the logic in dwc3_gadget_ep_reclaim_completed_trb()
event->status is checked for IOC/LST bit and returns on the
first TRB. This leaves the remaining TRBs left unhandled.

Similarly, if the gadget function enqueues an unaligned request
with sglist already in it, it should fail the same way, since we
will append another TRB to something that already uses more than
one TRB.

To aviod this, this patch changes the code to check for IOC/LST
bits in TRB->ctrl instead.

At a practical level, this patch resolves USB transfer stalls seen
with adb on dwc3 based HiKey960 after functionfs gadget added
scatter-gather support around v4.20.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
[jstultz: forward ported to mainline, reworded commit log, reworked
 to only check trb->ctrl as suggested by Felipe]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1b8014ab0b25..1b7d2f9cb673 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2429,7 +2429,8 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
-	if (event->status & DEPEVT_STATUS_IOC)
+	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
+	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
 
 	return 0;
-- 
2.25.0


