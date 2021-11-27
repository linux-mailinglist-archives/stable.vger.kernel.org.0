Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699AC45FEA7
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhK0Mzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 07:55:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54796 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbhK0Mxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 07:53:36 -0500
X-Greylist: delayed 3271 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Nov 2021 07:53:36 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 770BFCE09E6
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEBAC53FC7;
        Sat, 27 Nov 2021 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638017418;
        bh=3xISPk1qjx2meahrWrIc74JAzX4ckQFfMAg3moG77b4=;
        h=Subject:To:Cc:From:Date:From;
        b=infURcXVK3fSjuPoVx8ySpYG843pyYRw3ci/Qc/L+lymTSGPdltc92bf1k4iLK0s9
         ZLKGrPZJx4zkDpgmiE2lxgHch+zChvsBHnSHpRxOiYUnPgkzkP3XYFGj9Cwyjx2z5o
         7mtrmGMY7HjB/Rzevy44jKaM6KUGTHu1Y2vksY34=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer" failed to apply to 4.19-stable tree
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Nov 2021 13:50:16 +0100
Message-ID: <16380174163724@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63c4c320ccf77074ffe9019ac596603133c1b517 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 25 Oct 2021 16:35:06 -0700
Subject: [PATCH] usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

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
 

