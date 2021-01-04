Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4612E9935
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhADPwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADPwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:52:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D77020735;
        Mon,  4 Jan 2021 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775519;
        bh=4ZnamOLaoNRo3PeXr9M79NOt4CcuPTczo1KfucPjLos=;
        h=Subject:To:From:Date:From;
        b=0NVkXY7Fv4LVRHnoRU0bSFNC8YgOguU2OTlayV4AIc9KqRAojty4QGKY7ILFlJt8+
         WusmBMzlVBfv5XKJUbN+xmMGw7nE5uDr9Rppi3Wvq1KABMGpoD61VDEb30xkl1r/jp
         +jM4MzzwzSMFFH1kyH0EG3794/dP2UTKY0sBpeVU=
Subject: patch "usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup" added to usb-linus
To:     wcheng@codeaurora.org, gregkh@linuxfoundation.org,
        m.tretter@pengutronix.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 16:53:16 +0100
Message-ID: <1609775596250196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a1383b3537a7bea1c213baa7878ccc4ecf4413b5 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Tue, 29 Dec 2020 15:00:37 -0800
Subject: usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup

usb_gadget_deactivate/usb_gadget_activate does not execute the UDC start
operation, which may leave EP0 disabled and event IRQs disabled when
re-activating the function. Move the enabling/disabling of USB EP0 and
device event IRQs to be performed in the pullup routine.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Tested-by: Michael Tretter <m.tretter@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1609282837-21666-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 78cb4db8a6e4..25f654b79e48 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2083,6 +2083,7 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 
 static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
 static void __dwc3_gadget_stop(struct dwc3 *dwc);
+static int __dwc3_gadget_start(struct dwc3 *dwc);
 
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
@@ -2145,6 +2146,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+	} else {
+		__dwc3_gadget_start(dwc);
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
@@ -2319,10 +2322,6 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 	}
 
 	dwc->gadget_driver	= driver;
-
-	if (pm_runtime_active(dwc->dev))
-		__dwc3_gadget_start(dwc);
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
@@ -2348,13 +2347,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-
-	if (pm_runtime_suspended(dwc->dev))
-		goto out;
-
-	__dwc3_gadget_stop(dwc);
-
-out:
 	dwc->gadget_driver	= NULL;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-- 
2.30.0


