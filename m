Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542681865CD
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 08:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgCPHkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 03:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgCPHkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 03:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AF720674;
        Mon, 16 Mar 2020 07:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584344441;
        bh=SLJnRJInQOainNM/1nFZo6oOux3tPsFtH2P3Pu1By+0=;
        h=Subject:To:From:Date:From;
        b=sMZFuIrFBI4hjulYfMnSbyIAivJ9EhaigusuQpfx0ewcgiFplWzeBnpB44gCaFoel
         5Va2Jemf70pYKK332MlwZELc23vWI593KOMOFWSHOojYaGPV0tsN5iqHcbBAvhoW6a
         PvSgt/cB/RdZ+w9Ht3VcfktInHuj6Ftwdiv+BmAI=
Subject: patch "usb: dwc3: gadget: Wrap around when skip TRBs" added to usb-next
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 08:40:04 +0100
Message-ID: <1584344404194248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Wrap around when skip TRBs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2dedea035ae82c5af0595637a6eda4655532b21e Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 5 Mar 2020 13:24:01 -0800
Subject: usb: dwc3: gadget: Wrap around when skip TRBs

When skipping TRBs, we need to account for wrapping around the ring
buffer and not modifying some invalid TRBs. Without this fix, dwc3 won't
be able to check for available TRBs.

Cc: stable <stable@vger.kernel.org>
Fixes: 7746a8dfb3f9 ("usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b032e62fff0f..4d3c79d90a6e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1521,7 +1521,7 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 	for (i = 0; i < req->num_trbs; i++) {
 		struct dwc3_trb *trb;
 
-		trb = req->trb + i;
+		trb = &dep->trb_pool[dep->trb_dequeue];
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 		dwc3_ep_inc_deq(dep);
 	}
-- 
2.25.1


