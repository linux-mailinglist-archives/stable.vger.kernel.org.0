Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA453F86B9
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 13:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbhHZLvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 07:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242100AbhHZLvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 07:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7556E61002;
        Thu, 26 Aug 2021 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629978638;
        bh=05lfnLEfbHVyUbVPqfJtcz+eBhsFNlYgblFzOqH1yrE=;
        h=Subject:To:From:Date:From;
        b=LBLGJ1JAEz2FcQ5gK9P0BZeI/NzShHDp7DZzkDcG/crRag/tGdbvRJLDc2ObFWzdv
         9YbmbE9xeEWuR44i5JXomjpl4N+xY7DGORwn8Wgspzd1JQZqAKLp2chq8q3TscGXC8
         kTRyAL7d7HIF5mQUtLrklghlgQzlLd6zDMZcB2qA=
Subject: patch "usb: dwc3: gadget: Stop EP0 transfers during pullup disable" added to usb-linus
To:     wcheng@codeaurora.org, Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Aug 2021 13:50:26 +0200
Message-ID: <162997862632185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Stop EP0 transfers during pullup disable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4a1e25c0a029b97ea4a3d423a6392bfacc3b2e39 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Tue, 24 Aug 2021 21:28:55 -0700
Subject: usb: dwc3: gadget: Stop EP0 transfers during pullup disable

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
---
 drivers/usb/dwc3/gadget.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1e6ddbc986ba..ccb68fe6202e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2243,10 +2243,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
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
@@ -2458,6 +2456,7 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);
-- 
2.32.0


