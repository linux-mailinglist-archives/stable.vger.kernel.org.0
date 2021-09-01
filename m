Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E43FDC49
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbhIAMso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343780AbhIAMql (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E677610CE;
        Wed,  1 Sep 2021 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500004;
        bh=mmksP3toEwP3E/h3+vXYoGaiz957sYPMRJ31t9I3T2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8bHajBx+uACdoh2immSymAgoydPL8tcNa7wJ4X+ZVNjiV50NYOs6ck6C9xhAiis2
         A3mVj23OUZ0+Q+NXp7RNqwKRpLADXLETT9QsUcmilLm89b75UDG6qMFTqtvlWyrrO/
         qx/3yPg3kdgAS7oFZn60ejgw9xMJW7QH/y+GJ6Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.13 033/113] usb: dwc3: gadget: Stop EP0 transfers during pullup disable
Date:   Wed,  1 Sep 2021 14:27:48 +0200
Message-Id: <20210901122303.100909372@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 4a1e25c0a029b97ea4a3d423a6392bfacc3b2e39 upstream.

During a USB cable disconnect, or soft disconnect scenario, a pending
SETUP transaction may not be completed, leading to the following
error:

    dwc3 a600000.dwc3: timed out waiting for SETUP phase

If this occurs, then the entire pullup disable routine is skipped and
proper cleanup and halting of the controller does not complete.

Instead of returning an error (which is ignored from the UDC
perspective), allow the pullup disable routine to continue, which
will also handle disabling of EP0/1.  This will end any active
transfers as well.  Ensure to clear any delayed_status also, as the
timeout could happen within the STATUS stage.

Fixes: bb0147364850 ("usb: dwc3: gadget: don't clear RUN/STOP when it's invalid to do so")
Cc: <stable@vger.kernel.org>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/20210825042855.7977-1-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2243,10 +2243,8 @@ static int dwc3_gadget_pullup(struct usb
 
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		if (ret == 0) {
-			dev_err(dwc->dev, "timed out waiting for SETUP phase\n");
-			return -ETIMEDOUT;
-		}
+		if (ret == 0)
+			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
 	}
 
 	/*
@@ -2458,6 +2456,7 @@ static int __dwc3_gadget_start(struct dw
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);


