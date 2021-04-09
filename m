Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB1C359FAB
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhDINRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 09:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 09:17:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5671610FB;
        Fri,  9 Apr 2021 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974245;
        bh=LUy1HUsPYV5O/oOTPGzVNr2m4Tz8Bdh5/B0m+iY2zPc=;
        h=Subject:To:From:Date:From;
        b=SwLy2q/iUJqCBq3pztti8voPXtcPHUCe97XwX5HiglfPtG4sRKT1dxrleIZukK3Wb
         ugs3zbtZ22lQ6d0yuRP5TSZ3CknB8POQ7qw0aa41Fx57YevTkhM+2KkWO2ZNQs4BKx
         c48Hsjw5kDW+cUuQlIKe8Zwv1PIJ7TYQBrjGLDvw=
Subject: patch "usb: dwc2: Fix partial power down exiting by system resume" added to usb-testing
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 15:17:01 +0200
Message-ID: <16179742211138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Fix partial power down exiting by system resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c74c26f6e398387cc953b3fdb54858f09bfb696b Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Thu, 8 Apr 2021 13:46:06 +0400
Subject: usb: dwc2: Fix partial power down exiting by system resume

Fixes the implementation of exiting from partial power down
power saving mode when PC is resumed.

Added port connection status checking which prevents exiting from
Partial Power Down mode from _dwc2_hcd_resume() if not in Partial
Power Down mode.

Rearranged the implementation to get rid of many "if"
statements.

NOTE: Switch case statement is used for hibernation partial
power down and clock gating mode determination. In this patch
only Partial Power Down is implemented the Hibernation and
clock gating implementations are planned to be added.

Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with DWC2_POWER_DOWN_PARAM_NONE")
Cc: <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210408094607.1A9BAA0094@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c | 90 +++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 34030bafdff4..f096006df96f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4427,7 +4427,7 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 {
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	unsigned long flags;
-	u32 pcgctl;
+	u32 hprt0;
 	int ret = 0;
 
 	spin_lock_irqsave(&hsotg->lock, flags);
@@ -4438,11 +4438,40 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 	if (hsotg->lx_state != DWC2_L2)
 		goto unlock;
 
-	if (hsotg->params.power_down > DWC2_POWER_DOWN_PARAM_PARTIAL) {
+	hprt0 = dwc2_read_hprt0(hsotg);
+
+	/*
+	 * Added port connection status checking which prevents exiting from
+	 * Partial Power Down mode from _dwc2_hcd_resume() if not in Partial
+	 * Power Down mode.
+	 */
+	if (hprt0 & HPRT0_CONNSTS) {
+		hsotg->lx_state = DWC2_L0;
+		goto unlock;
+	}
+
+	switch (hsotg->params.power_down) {
+	case DWC2_POWER_DOWN_PARAM_PARTIAL:
+		ret = dwc2_exit_partial_power_down(hsotg, 0, true);
+		if (ret)
+			dev_err(hsotg->dev,
+				"exit partial_power_down failed\n");
+		/*
+		 * Set HW accessible bit before powering on the controller
+		 * since an interrupt may rise.
+		 */
+		set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+		break;
+	case DWC2_POWER_DOWN_PARAM_HIBERNATION:
+	case DWC2_POWER_DOWN_PARAM_NONE:
+	default:
 		hsotg->lx_state = DWC2_L0;
 		goto unlock;
 	}
 
+	/* Change Root port status, as port status change occurred after resume.*/
+	hsotg->flags.b.port_suspend_change = 1;
+
 	/*
 	 * Enable power if not already done.
 	 * This must not be spinlocked since duration
@@ -4454,52 +4483,25 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 		spin_lock_irqsave(&hsotg->lock, flags);
 	}
 
-	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_PARTIAL) {
-		/*
-		 * Set HW accessible bit before powering on the controller
-		 * since an interrupt may rise.
-		 */
-		set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-
-
-		/* Exit partial_power_down */
-		ret = dwc2_exit_partial_power_down(hsotg, 0, true);
-		if (ret && (ret != -ENOTSUPP))
-			dev_err(hsotg->dev, "exit partial_power_down failed\n");
-	} else {
-		pcgctl = readl(hsotg->regs + PCGCTL);
-		pcgctl &= ~PCGCTL_STOPPCLK;
-		writel(pcgctl, hsotg->regs + PCGCTL);
-	}
-
-	hsotg->lx_state = DWC2_L0;
-
+	/* Enable external vbus supply after resuming the port. */
 	spin_unlock_irqrestore(&hsotg->lock, flags);
+	dwc2_vbus_supply_init(hsotg);
 
-	if (hsotg->bus_suspended) {
-		spin_lock_irqsave(&hsotg->lock, flags);
-		hsotg->flags.b.port_suspend_change = 1;
-		spin_unlock_irqrestore(&hsotg->lock, flags);
-		dwc2_port_resume(hsotg);
-	} else {
-		if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_PARTIAL) {
-			dwc2_vbus_supply_init(hsotg);
-
-			/* Wait for controller to correctly update D+/D- level */
-			usleep_range(3000, 5000);
-		}
+	/* Wait for controller to correctly update D+/D- level */
+	usleep_range(3000, 5000);
+	spin_lock_irqsave(&hsotg->lock, flags);
 
-		/*
-		 * Clear Port Enable and Port Status changes.
-		 * Enable Port Power.
-		 */
-		dwc2_writel(hsotg, HPRT0_PWR | HPRT0_CONNDET |
-				HPRT0_ENACHG, HPRT0);
-		/* Wait for controller to detect Port Connect */
-		usleep_range(5000, 7000);
-	}
+	/*
+	 * Clear Port Enable and Port Status changes.
+	 * Enable Port Power.
+	 */
+	dwc2_writel(hsotg, HPRT0_PWR | HPRT0_CONNDET |
+			HPRT0_ENACHG, HPRT0);
 
-	return ret;
+	/* Wait for controller to detect Port Connect */
+	spin_unlock_irqrestore(&hsotg->lock, flags);
+	usleep_range(5000, 7000);
+	spin_lock_irqsave(&hsotg->lock, flags);
 unlock:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-- 
2.31.1


