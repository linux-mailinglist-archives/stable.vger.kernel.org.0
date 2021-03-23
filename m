Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1735345DF4
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCWMWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhCWMVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8124A6197F;
        Tue, 23 Mar 2021 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502107;
        bh=RrWGtCfLCjGrW2d8C5CGt42A+Hg/ThAIN/YQi+XM15U=;
        h=Subject:To:From:Date:From;
        b=ue/XC2in84kp/oPf5xga27JBK1Wodfy/xUFyieF+rW5Aw81T5/XUg4wgqVIJhdrzp
         I6yFIQX2GhA79cX+vIqu5HkEjPQCxALjkqT9TIbNSM+7o0Z0Bf9BsH1w8+lniGxsGH
         1YyjeiLV1IrWAqRzxGn2Tw44UrjeuIbHLiuPDHL4=
Subject: patch "usb: dwc3: gadget: Use max speed if unspecified" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:21:34 +0100
Message-ID: <161650209416759@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Use max speed if unspecified

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 93f1d43c5767d70a1af89f54ef16a7d3e99af048 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 8 Mar 2021 18:16:50 -0800
Subject: usb: dwc3: gadget: Use max speed if unspecified

If the gadget driver doesn't specify a max_speed, then use the
controller's maximum supported speed as default. For DWC_usb32 IP, the
gadget's speed maybe limited to gen2x1 rate only if the driver's
max_speed is unknown. This scenario should not occur with the current
implementation since the default gadget driver's max_speed should always
be specified. However, to make the driver more robust and help with
readability, let's cover all the scenarios in __dwc3_gadget_set_speed().

Fixes: 450b9e9fabd8 ("usb: dwc3: gadget: Set speed only up to the max supported")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/55ac7001af73bfe9bc750c6446ef4ac8cf6f9313.1615254129.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 006476a4737b..4c15c3fce303 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2083,7 +2083,7 @@ static void __dwc3_gadget_set_speed(struct dwc3 *dwc)
 	u32			reg;
 
 	speed = dwc->gadget_max_speed;
-	if (speed > dwc->maximum_speed)
+	if (speed == USB_SPEED_UNKNOWN || speed > dwc->maximum_speed)
 		speed = dwc->maximum_speed;
 
 	if (speed == USB_SPEED_SUPER_PLUS &&
-- 
2.31.0


