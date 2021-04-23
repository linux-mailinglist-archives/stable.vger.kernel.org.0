Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2726368DF7
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhDWHgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhDWHgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 03:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF04161404;
        Fri, 23 Apr 2021 07:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619163330;
        bh=TO8TIYOKdORydoyB9+5ekucQjDU3xXDonbcd8aMV34E=;
        h=Subject:To:From:Date:From;
        b=MZBHO9GHAEKRSa9mAFUbWH9p8tRpc2srLCG+5DJNXxW2JUsOZxe6/aUMnNseZg5nc
         VqaIJv22qT/QiuC1dR3/d1y1aUuChFjgEbY0kqoOvcrs4hdNul+0xS6pZjxokmudA9
         KnywQn0nFbu5/6OjQFX5wqYczczKjmy1H6W+cARg=
Subject: patch "usb: dwc3: gadget: Fix START_TRANSFER link state check" added to usb-next
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 23 Apr 2021 09:32:48 +0200
Message-ID: <1619163168147187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Fix START_TRANSFER link state check

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c560e76319a94a3b9285bc426c609903408e4826 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 19 Apr 2021 19:11:12 -0700
Subject: usb: dwc3: gadget: Fix START_TRANSFER link state check

The START_TRANSFER command needs to be executed while in ON/U0 link
state (with an exception during register initialization). Don't use
dwc->link_state to check this since the driver only tracks the link
state when the link state change interrupt is enabled. Check the link
state from DSTS register instead.

Note that often the host already brings the device out of low power
before it sends/requests the next transfer. So, the user won't see any
issue when the device starts transfer then. This issue is more
noticeable in cases when the device delays starting transfer, which can
happen during delayed control status after the host put the device in
low power.

Fixes: 799e9dc82968 ("usb: dwc3: gadget: conditionally disable Link State change events")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/bcefaa9ecbc3e1936858c0baa14de6612960e909.1618884221.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 6227641f2d31..1a632a3faf7f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -308,13 +308,12 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	}
 
 	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
-		int		needs_wakeup;
+		int link_state;
 
-		needs_wakeup = (dwc->link_state == DWC3_LINK_STATE_U1 ||
-				dwc->link_state == DWC3_LINK_STATE_U2 ||
-				dwc->link_state == DWC3_LINK_STATE_U3);
-
-		if (unlikely(needs_wakeup)) {
+		link_state = dwc3_gadget_get_link_state(dwc);
+		if (link_state == DWC3_LINK_STATE_U1 ||
+		    link_state == DWC3_LINK_STATE_U2 ||
+		    link_state == DWC3_LINK_STATE_U3) {
 			ret = __dwc3_gadget_wakeup(dwc);
 			dev_WARN_ONCE(dwc->dev, ret, "wakeup failed --> %d\n",
 					ret);
@@ -1989,6 +1988,8 @@ static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
 	case DWC3_LINK_STATE_RESET:
 	case DWC3_LINK_STATE_RX_DET:	/* in HS, means Early Suspend */
 	case DWC3_LINK_STATE_U3:	/* in HS, means SUSPEND */
+	case DWC3_LINK_STATE_U2:	/* in HS, means Sleep (L1) */
+	case DWC3_LINK_STATE_U1:
 	case DWC3_LINK_STATE_RESUME:
 		break;
 	default:
-- 
2.31.1


