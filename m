Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D92B276BD0
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 10:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgIXI1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 04:27:42 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36042 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbgIXI1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 04:27:41 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E6B37C033F;
        Thu, 24 Sep 2020 08:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1600935705; bh=YxKLDUBCgq7shYYsFCjcpiogPu+ame6OLtK4Wfjsopc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=kDo9S8zhnbOrs4pbhIObW8atP1e0J6f4Ljf2bw7Uz3CfKRWkyxdmaow/CHn9geBSz
         ohRvcsazPFTj3nVuabohwOByfWlKBUvI2lMj2JHIS6IEWPRAB1ATRrAakvFIITIu48
         3qZ2OsYqdkeUYNVu1dS4D/VbUdrom8OXiLTQOIEFD2BxKmMRaAXrOLAPEs63Odn5tE
         CbUk6AC0vt2ZHvwGQmuoQBUw2BeNFaI3iZfBzd03NqFb7BqUkpH9rDmwwmV4z+1Edi
         S6/R8WIcsq+xBENNKEyK1BNQccT5WI1DoP9PCFn8CtJv9fqBlqU+j/HHXAtCw+RjEk
         eYUPOnsI4CcMw==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 2BF98A0075;
        Thu, 24 Sep 2020 08:21:43 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 24 Sep 2020 01:21:43 -0700
Date:   Thu, 24 Sep 2020 01:21:43 -0700
Message-Id: <b0fe759010a378322b12e8e661606ab2e510a736.1600935293.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
References: <cover.1600935293.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 05/10] usb: dwc3: ep0: Fix ZLP for OUT ep0 requests
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current ZLP handling for ep0 requests is only for control IN
requests. For OUT direction, DWC3 needs to check and setup for MPS
alignment.

Usually, control OUT requests can indicate its transfer size via the
wLength field of the control message. So usb_request->zero is usually
not needed for OUT direction. To handle ZLP OUT for control endpoint,
make sure the TRB is MPS size.

Cc: stable@vger.kernel.org
Fixes: c7fcdeb2627c ("usb: dwc3: ep0: simplify EP0 state machine")
Fixes: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/ep0.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index b0363e3ba4d1..5580caed8b0c 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -947,12 +947,16 @@ static void dwc3_ep0_xfer_complete(struct dwc3 *dwc,
 static void __dwc3_ep0_do_control_data(struct dwc3 *dwc,
 		struct dwc3_ep *dep, struct dwc3_request *req)
 {
+	unsigned int		trb_length = 0;
 	int			ret;
 
 	req->direction = !!dep->number;
 
 	if (req->request.length == 0) {
-		dwc3_ep0_prepare_one_trb(dep, dwc->ep0_trb_addr, 0,
+		if (!req->direction)
+			trb_length = dep->endpoint.maxpacket;
+
+		dwc3_ep0_prepare_one_trb(dep, dwc->bounce_addr, trb_length,
 				DWC3_TRBCTL_CONTROL_DATA, false);
 		ret = dwc3_ep0_start_trans(dep);
 	} else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)
@@ -999,9 +1003,12 @@ static void __dwc3_ep0_do_control_data(struct dwc3 *dwc,
 
 		req->trb = &dwc->ep0_trb[dep->trb_enqueue - 1];
 
+		if (!req->direction)
+			trb_length = dep->endpoint.maxpacket;
+
 		/* Now prepare one extra TRB to align transfer size */
 		dwc3_ep0_prepare_one_trb(dep, dwc->bounce_addr,
-					 0, DWC3_TRBCTL_CONTROL_DATA,
+					 trb_length, DWC3_TRBCTL_CONTROL_DATA,
 					 false);
 		ret = dwc3_ep0_start_trans(dep);
 	} else {
-- 
2.28.0

