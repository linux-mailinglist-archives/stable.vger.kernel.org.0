Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849F6314A7D
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBIIku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhBIIkr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 03:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A68564E79;
        Tue,  9 Feb 2021 08:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612860006;
        bh=otwgLlJf+A3aIEzGqOOPi2G4bqn/n0+qJOpUPTfxx9c=;
        h=Subject:To:From:Date:From;
        b=p3vu7UJPkGP3MWfmLJbMLDmEtz0+3P99NE9G91ObeITnqu9qejfDbMFzB2UoVpbm5
         BV93RpPqg6SycCDepk4U+j3/L1Z0fPrVbY+j2rN8xpXMX8s3+51Xqw1EibFWHeFf9F
         AUcXREXFoTWya8kEIu13V9cDp/x2BEDfhaAoZ55A=
Subject: patch "usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1" added to usb-testing
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Feb 2021 09:40:04 +0100
Message-ID: <1612860004125229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a1679af85b2ae35a2b78ad04c18bb069c37330cc Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 8 Feb 2021 13:53:10 -0800
Subject: usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1

Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it must be set
to 0 when the controller operates in full-speed. See the programming
guide for DEPCFG command section 3.2.2.1 (v3.30a).

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3f57026f993c0ce71498dbb06e49b3a47c4d0265.1612820995.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 97d707b4f384..d0f8d3ec855f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -605,7 +605,17 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		params.param0 |= DWC3_DEPCFG_FIFO_NUMBER(dep->number >> 1);
 
 	if (desc->bInterval) {
-		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(desc->bInterval - 1);
+		u8 bInterval_m1;
+
+		/*
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
+		 * must be set to 0 when the controller operates in full-speed.
+		 */
+		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
+		if (dwc->gadget->speed == USB_SPEED_FULL)
+			bInterval_m1 = 0;
+
+		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
 		dep->interval = 1 << (desc->bInterval - 1);
 	}
 
-- 
2.30.0


