Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C7D368DFC
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbhDWHgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhDWHgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 03:36:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A35613CC;
        Fri, 23 Apr 2021 07:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619163359;
        bh=oW5/d5hwDH0140V7gTAKZxFc/u7aWbrHo4xk397yUGI=;
        h=Subject:To:From:Date:From;
        b=R+pulORxfxbhXk80JNPKSLUcaV0+WP1VxnZyqKZEvZJ1U24a8bOcf2S6bZTvBm6MC
         eCQNiM2lfpwguDF7rErqJUTIzxzXk54i1SNeM5vPZAVPRhbXyEGo/6Kja4RlK+3O8a
         qKS0irTVY1sXw1fGd7saes2KXyUBc2n1yrC/rs1Y=
Subject: patch "usb: dwc3: gadget: Remove FS bInterval_m1 limitation" added to usb-next
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Apr 2021 09:32:54 +0200
Message-ID: <161916317424586@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Remove FS bInterval_m1 limitation

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3232a3ce55edfc0d7f8904543b4088a5339c2b2b Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 15 Apr 2021 00:41:58 -0700
Subject: usb: dwc3: gadget: Remove FS bInterval_m1 limitation

The programming guide incorrectly stated that the DCFG.bInterval_m1 must
be set to 0 when operating in fullspeed. There's no such limitation for
all IPs. See DWC_usb3x programming guide section 3.2.2.1.

Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/5d4139ae89d810eb0a2d8577fb096fc88e87bfab.1618472454.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1a632a3faf7f..90f4f9e69b22 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -607,12 +607,14 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		u8 bInterval_m1;
 
 		/*
-		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
-		 * must be set to 0 when the controller operates in full-speed.
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13.
+		 *
+		 * NOTE: The programming guide incorrectly stated bInterval_m1
+		 * must be set to 0 when operating in fullspeed. Internally the
+		 * controller does not have this limitation. See DWC_usb3x
+		 * programming guide section 3.2.2.1.
 		 */
 		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
-		if (dwc->gadget->speed == USB_SPEED_FULL)
-			bInterval_m1 = 0;
 
 		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
 		    dwc->gadget->speed == USB_SPEED_FULL)
-- 
2.31.1


