Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE03FDA9E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbhIAMdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244981AbhIAMcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695DF6101B;
        Wed,  1 Sep 2021 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499469;
        bh=wfo9GdOiLDHNEyOrOG+5EplHHTkvXSKDzPpU7nrFuGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jq2PM7KRU9gQofYh+FW66fhwPS8MTQwpw0xtyoioZcDWlV49k3CnJjvtHSnRkxxAK
         YD1ElETBodogAm1gdScPpo0cO0tSIDJcoQuHKZOuMsab8MLKUBYSviEP6VHbjSB6n+
         ZbdNPugq9ICVKfr1CI9Dd9kDV9UVpexUljMXNtI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 12/48] usb: dwc3: gadget: Stop EP0 transfers during pullup disable
Date:   Wed,  1 Sep 2021 14:28:02 +0200
Message-Id: <20210901122253.810490195@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
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
@@ -2012,10 +2012,8 @@ static int dwc3_gadget_pullup(struct usb
 
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
@@ -2217,6 +2215,7 @@ static int __dwc3_gadget_start(struct dw
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);


