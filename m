Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B70E2F5D2C
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbhANJV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727693AbhANJV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 04:21:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E60223A05;
        Thu, 14 Jan 2021 09:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610616047;
        bh=SvgtDERwHxTvhHA2BYaTy5jtlIh95UXNvxOFOQTl+bM=;
        h=Subject:To:From:Date:From;
        b=rsx6WAAPg1sHj00uKAuCg1ArR9USJHZmKwLHGopQBXlNE2J+EJGdSfSudP97drt2h
         TL2RbU3Eh9Jaeam1f7TSuagiMZWtVNdNqtgo0TJLXaXx2b7ZdjJBmHBiRUI+/Up14z
         Ru8+Rlkc2Wp2m5GTZMAPu9DWKfYf9nvjEafNAsWA=
Subject: patch "USB: gadget: dummy-hcd: Fix errors in port-reset handling" added to usb-linus
To:     stern@rowland.harvard.edu, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Jan 2021 10:21:52 +0100
Message-ID: <1610616112210232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: dummy-hcd: Fix errors in port-reset handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6e6aa61d81194c01283880950df563b1b9abec46 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 13 Jan 2021 14:45:10 -0500
Subject: USB: gadget: dummy-hcd: Fix errors in port-reset handling

Commit c318840fb2a4 ("USB: Gadget: dummy-hcd: Fix shift-out-of-bounds
bug") messed up the way dummy-hcd handles requests to turn on the
RESET port feature (I didn't notice that the original switch case
ended with a fallthrough).  The call to set_link_state() was
inadvertently removed, as was the code to set the USB_PORT_STAT_RESET
flag when the speed is USB2.

In addition, the original code never checked whether the port was
connected before handling the port-reset request.  There was a check
for the port being powered, but it was removed by that commit!  In
practice this doesn't matter much because the kernel doesn't try to
reset disconnected ports, but it's still bad form.

This patch fixes these problems by changing the fallthrough to break,
adding back in the missing set_link_state() call, setting the
port-reset status flag, adding a port-is-connected test, and removing
a redundant assignment statement.

Fixes: c318840fb2a4 ("USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug")
CC: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210113194510.GA1290698@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 1a953f44183a..57067763b100 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2270,17 +2270,20 @@ static int dummy_hub_control(
 			}
 			fallthrough;
 		case USB_PORT_FEAT_RESET:
+			if (!(dum_hcd->port_status & USB_PORT_STAT_CONNECTION))
+				break;
 			/* if it's already enabled, disable */
 			if (hcd->speed == HCD_USB3) {
-				dum_hcd->port_status = 0;
 				dum_hcd->port_status =
 					(USB_SS_PORT_STAT_POWER |
 					 USB_PORT_STAT_CONNECTION |
 					 USB_PORT_STAT_RESET);
-			} else
+			} else {
 				dum_hcd->port_status &= ~(USB_PORT_STAT_ENABLE
 					| USB_PORT_STAT_LOW_SPEED
 					| USB_PORT_STAT_HIGH_SPEED);
+				dum_hcd->port_status |= USB_PORT_STAT_RESET;
+			}
 			/*
 			 * We want to reset device status. All but the
 			 * Self powered feature
@@ -2292,7 +2295,8 @@ static int dummy_hub_control(
 			 * interval? Is it still 50msec as for HS?
 			 */
 			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
-			fallthrough;
+			set_link_state(dum_hcd);
+			break;
 		case USB_PORT_FEAT_C_CONNECTION:
 		case USB_PORT_FEAT_C_RESET:
 		case USB_PORT_FEAT_C_ENABLE:
-- 
2.30.0


