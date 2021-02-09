Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36431560C
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhBIScs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:32:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233442AbhBIS1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 13:27:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1169264ECB;
        Tue,  9 Feb 2021 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612893647;
        bh=iJhPhRm1H5EM9IPWCzqH62R48suHp4qRtHqi6fh5JLo=;
        h=Subject:To:From:Date:From;
        b=1dSSClkrDod4hl8/x1dgMWlFvqXieY3ASwP36MEXBJpR6zi+jXIn3mekpVJYNUZ+Z
         tHNVt3HJyCbwVGEV4bKglpqrDs0GbL1caOw45rZ1hs4gvPKpC35OKaHYnAoT04mYaj
         eMHloGysajct3MXC8yDxCRUuwAPihIQ8AWm3pyU8=
Subject: patch "usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt" added to usb-next
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Feb 2021 18:55:09 +0100
Message-ID: <161289330920429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4b049f55ed95cd889bcdb3034fd75e1f01852b38 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 8 Feb 2021 13:53:16 -0800
Subject: usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

The dep->interval captures the number of frames/microframes per interval
from bInterval. Fullspeed interrupt endpoint bInterval is the number of
frames per interval and not 2^(bInterval - 1). So fix it here. This
change is only for debugging purpose and should not affect the interrupt
endpoint operation.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1263b563dedc4ab8b0fb854fba06ce4bc56bd495.1612820995.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d0f8d3ec855f..aebcf8ec0716 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -615,8 +615,13 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		if (dwc->gadget->speed == USB_SPEED_FULL)
 			bInterval_m1 = 0;
 
+		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
+		    dwc->gadget->speed == USB_SPEED_FULL)
+			dep->interval = desc->bInterval;
+		else
+			dep->interval = 1 << (desc->bInterval - 1);
+
 		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
-		dep->interval = 1 << (desc->bInterval - 1);
 	}
 
 	return dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETEPCONFIG, &params);
-- 
2.30.0


