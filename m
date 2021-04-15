Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB6360398
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 09:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhDOHm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 03:42:26 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:58970 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhDOHmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 03:42:23 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AD717C063D;
        Thu, 15 Apr 2021 07:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618472520; bh=1R3A1+CrXL2wZ1Q7bP7xL0OTwOy7UrbMG7yt4dnK+5U=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=DflxfW+SVm2rDF5T5DZEPN6gRjqlVPsW96v7BSNG5cdmFck42pwih+iAMOH5NqiTV
         AiKWj930BhyDCGI2plWYZnGmiXcgxsaIVIiGl3AhE8oxIH4SZhR9+THY6rE4K4VlTX
         TmqnnHCyqp7i+lh2S9oYp4rWjYUGwKCwmOozUEWbzpLvHDJOMZ8K7hENylVAcH5SL1
         l1xy4oTOlP046jpSxBkg8D/w1Rrm30vOd1qYCgr3doGLR0yS1nVWAPpf3Ha242ha8C
         uLLPyrOCTPtWzbl9P+x0kD1mz5bFY06WkWDMo/XFX3ULI8Df6YzjQqdVgx7fSPCFjm
         XgejWNwVy03Xg==
Received: from lab-vbox (unknown [10.205.128.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 495A7A005F;
        Thu, 15 Apr 2021 07:41:59 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Thu, 15 Apr 2021 00:41:58 -0700
Date:   Thu, 15 Apr 2021 00:41:58 -0700
Message-Id: <5d4139ae89d810eb0a2d8577fb096fc88e87bfab.1618472454.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
References: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The programming guide incorrectly stated that the DCFG.bInterval_m1 must
be set to 0 when operating in fullspeed. There's no such limitation for
all IPs. See DWC_usb3x programming guide section 3.2.2.1.

Cc: <stable@vger.kernel.org>
Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - Noted programming guide section number

 drivers/usb/dwc3/gadget.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 6227641f2d31..3609311b24f1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -608,12 +608,14 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		u8 bInterval_m1;
 
 		/*
-		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
-		 * must be set to 0 when the controller operates in full-speed.
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13.
+		 *
+		 * NOTE: The programming guide incorrectly stated bInterval_m1
+		 * must be set to 0 when operating in fullspeed. Internally the
+		 * controller does not have this limitation. See DWC_usb3x
+		 * programming guide section 3.2.2.1.
 		 */
 		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
-		if (dwc->gadget->speed == USB_SPEED_FULL)
-			bInterval_m1 = 0;
 
 		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
 		    dwc->gadget->speed == USB_SPEED_FULL)

base-commit: 4b853c236c7b5161a2e444bd8b3c76fe5aa5ddcb
-- 
2.28.0

