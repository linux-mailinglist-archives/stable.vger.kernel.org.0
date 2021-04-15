Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5157735FEF4
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 02:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhDOAlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 20:41:22 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43964 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhDOAlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 20:41:21 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2EFC3C0556;
        Thu, 15 Apr 2021 00:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618447259; bh=vJnt/fnpWVbLJ17ULdv6D4GvQviiXUyq1zVCyddYdPU=;
        h=Date:From:Subject:To:Cc:From;
        b=V/iHtLHOlnvXhGdYrr0Lk5lMHlQnHnuNEqXoVx7hCObWCqhowdrxhlAXBXI3we94u
         OYtHC9vkpbcb/q000O+Ki8iuHnbGn5I495qdjpZHrUuguXOYmmzjtfh6g2HjE0eN6c
         5eq+X2Y3FoclU7IT2fgcIBWRIi0MW1wmE0Tl99Ceh4lGF1bUR0VBQnr2wjm5cJT9CD
         pigkZbCHoVxuJoS5Fc7KSlHMdeHjYN3kWFC2Zq+b3AbaXhVh1W0T5ZYWW5us59pWpq
         rced/9xnRixZX3Y7VGgBdoagjnZJ1WV9szDSROzj9xj49YJYZi34XDBx250YMAiZw9
         3olHVZiRucr/Q==
Received: from lab-vbox (unknown [10.205.131.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 87DE9A0070;
        Thu, 15 Apr 2021 00:40:53 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Wed, 14 Apr 2021 17:40:53 -0700
Date:   Wed, 14 Apr 2021 17:40:53 -0700
Message-Id: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The programming guide incorrectly stated that the DCFG.bInterval_m1 must
be set to 0 when operating in fullspeed. There's no such limitation for
all IPs.

Cc: <stable@vger.kernel.org>
Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 6227641f2d31..d87a29bd7d9b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -608,12 +608,13 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		u8 bInterval_m1;
 
 		/*
-		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
-		 * must be set to 0 when the controller operates in full-speed.
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13.
+		 *
+		 * NOTE: The programming guide incorrectly stated bInterval_m1
+		 * must be set to 0 when operating in fullspeed. Internally the
+		 * controller does not have this limitation.
 		 */
 		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
-		if (dwc->gadget->speed == USB_SPEED_FULL)
-			bInterval_m1 = 0;
 
 		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
 		    dwc->gadget->speed == USB_SPEED_FULL)

base-commit: 4b853c236c7b5161a2e444bd8b3c76fe5aa5ddcb
-- 
2.28.0

