Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079D3454814
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhKQOGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234903AbhKQOGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC3861B54;
        Wed, 17 Nov 2021 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157791;
        bh=nPbUgHyzoPaXlvnfkGLCYSlDzZYQ1TfQKPiueD1u1jE=;
        h=Subject:To:From:Date:From;
        b=FLYe/Pxn8Mbd3cyjvmgi2ej2FWF4JWtFLodQ8RKtj0ox4/ROIxfR/8Hca3lK9lN1+
         RWZ8B2VX5KZRGc1LCVJbA4SfVGtMOTrVjidvmjAxDBbJp/DHleaZByXKtFTyWP8ut2
         qM5yGdBpLeFlUnzFGP9fU/QanyPwGUPyoazFLBZU=
Subject: patch "usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:06 +0100
Message-ID: <16371577863471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 63c4c320ccf77074ffe9019ac596603133c1b517 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 25 Oct 2021 16:35:06 -0700
Subject: usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

The programming guide noted that the driver needs to verify if the link
state is in U0 before executing the Start Transfer command. If it's not
in U0, the driver needs to perform remote wakeup. This is not accurate.
If the link state is in U1/U2, then the controller will not respond to
link recovery request from DCTL.ULSTCHNGREQ. The Start Transfer command
will trigger a link recovery if it is in U1/U2. A clarification will be
added to the programming guide for all controller versions.

The current implementation shouldn't cause any functional issue. It may
occasionally report an invalid time out warning from failed link
recovery request. The driver will still go ahead with the Start Transfer
command if the remote wakeup fails. The new change only initiates remote
wakeup where it is needed, which is when the link state is in L1/L2/U3.

Fixes: c36d8e947a56 ("usb: dwc3: gadget: put link to U0 before Start Transfer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/05b4a5fbfbd0863fc9b1d7af934a366219e3d0b4.1635204761.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3d6f4adaa15a..daa8f8548a2e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -310,13 +310,24 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
 		int link_state;
 
+		/*
+		 * Initiate remote wakeup if the link state is in U3 when
+		 * operating in SS/SSP or L1/L2 when operating in HS/FS. If the
+		 * link state is in U1/U2, no remote wakeup is needed. The Start
+		 * Transfer command will initiate the link recovery.
+		 */
 		link_state = dwc3_gadget_get_link_state(dwc);
-		if (link_state == DWC3_LINK_STATE_U1 ||
-		    link_state == DWC3_LINK_STATE_U2 ||
-		    link_state == DWC3_LINK_STATE_U3) {
+		switch (link_state) {
+		case DWC3_LINK_STATE_U2:
+			if (dwc->gadget->speed >= USB_SPEED_SUPER)
+				break;
+
+			fallthrough;
+		case DWC3_LINK_STATE_U3:
 			ret = __dwc3_gadget_wakeup(dwc);
 			dev_WARN_ONCE(dwc->dev, ret, "wakeup failed --> %d\n",
 					ret);
+			break;
 		}
 	}
 
-- 
2.34.0


