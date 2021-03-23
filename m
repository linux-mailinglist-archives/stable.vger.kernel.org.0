Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192D0345DF5
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCWMWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCWMVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8E1F619B1;
        Tue, 23 Mar 2021 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502104;
        bh=BLC1J31urxPSOp777GH+1n134NLYV3x8ODl5bC36ywY=;
        h=Subject:To:From:Date:From;
        b=UB13LxcDg+vO7y6/YRcbOBCrEFhn2zTSbnM0MCW1IoguC5tG8bH+CC2tzXdFpugLE
         tKMx1NCjpmfG5ZivgDOVrElax2G4hWTip2QK4p/N2E2i6tGpNVXHOzGJPfLpBqtngn
         YyJ5ZwOQh5zvFC3iOL11JvEsMOKiB5fPUSN2G6fg=
Subject: patch "usb: dwc3: gadget: Set gadget_max_speed when set ssp_rate" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:21:33 +0100
Message-ID: <161650209379231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Set gadget_max_speed when set ssp_rate

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cdb651b6021ee091abc24e9fbd9774d318ab96a6 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 8 Mar 2021 18:16:44 -0800
Subject: usb: dwc3: gadget: Set gadget_max_speed when set ssp_rate

Set the dwc->gadget_max_speed to SuperSpeed Plus if the user sets the
ssp_rate. The udc_set_ssp_rate() is intended for setting the gadget's
speed to SuperSpeed Plus at the specified rate.

Fixes: 072cab8a0fe2 ("usb: dwc3: gadget: Implement setting of SSP rate")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/0b2732e2f380d9912ee87f39dc82c2139223bad9.1615254129.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4a337f348651..006476a4737b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2523,6 +2523,7 @@ static void dwc3_gadget_set_ssp_rate(struct usb_gadget *g,
 	unsigned long		flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	dwc->gadget_max_speed = USB_SPEED_SUPER_PLUS;
 	dwc->gadget_ssp_rate = rate;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
-- 
2.31.0


