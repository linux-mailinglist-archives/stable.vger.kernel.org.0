Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7293A36501F
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 04:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhDTCLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 22:11:46 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56932 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhDTCLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 22:11:46 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B042F401D9;
        Tue, 20 Apr 2021 02:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618884675; bh=5ZQ/Yf2/T5z4gntPUEJn0WfZeYQcjqGcfL9z/NZ+l/c=;
        h=Date:From:Subject:To:Cc:From;
        b=QW3uqWLPRDvDHiLb20qPVX6wm/GRUVzY1EcgxKnqXbGuPUlMexEY8AajXpdsbI5PV
         jYLBZd9oLl7CYF0dPSKXc2KzTj7goyHWSEsYebYcYmdQsjDDLgL9Rou+eAERk6GxY3
         JM2p0aVv6Vtn2MWNSJpqBG1Q0jlAETPgQ+7aawIOU4xXWV4duo8R5+vOnjEeELHUBI
         zT2N57mi2i7ypQKj/22IEPE825A780MlNs2r+4zPHKMFfhvCH0O78nNXN+LubP4DBG
         UAbvmZUx6SVkkt7ct1T2mPAE2P6DFPGy7Sw509Ms1RQoA1ZrpbhP4ev7Hv968duAUA
         Gbff7GTh1B+nA==
Received: from lab-vbox (unknown [10.205.130.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5AD12A007C;
        Tue, 20 Apr 2021 02:11:13 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Mon, 19 Apr 2021 19:11:12 -0700
Date:   Mon, 19 Apr 2021 19:11:12 -0700
Message-Id: <bcefaa9ecbc3e1936858c0baa14de6612960e909.1618884221.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Fix START_TRANSFER link state check
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: <stable@vger.kernel.org>
Fixes: 799e9dc82968 ("usb: dwc3: gadget: conditionally disable Link State change events")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
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

base-commit: 4b853c236c7b5161a2e444bd8b3c76fe5aa5ddcb
-- 
2.28.0

