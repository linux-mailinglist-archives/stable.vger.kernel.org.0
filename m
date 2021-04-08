Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383CF357D61
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 09:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhDHHab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 03:30:31 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:60094 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhDHHa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 03:30:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EE05240788;
        Thu,  8 Apr 2021 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617867016; bh=h0c3Ab83WtpD8J1J8C8z3WJ3MO7dMp3GAkYTqraf9Vc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=hGIaa/EpXp+V22hvNBBeiXM17BgQRP5bYEiBzNlBAMVluuyy+BTo4ZDYjVKU+GHXn
         pv3Y/NTLxtO5ucaCtNxYiH6G7YXcMRY4VVQZWrZnBFMS25TNLCLZ/akz1so60kudPG
         IBzPb5f7CNfb1FpA8K5086yXNFJdHxfbP0qkwKXZXluXiPxk/MyfP9D5Krr7dkm7r8
         iwv8+Gwq7V6iGpLdVGhsW5v/RbJzoElKDIOsKUIoZbsIhi1W2sK97JtOaSplSwxOi8
         tViNPq6b18IF7ZoV+uliALIAtZjxc2jbjvXaY6Nxid5jt4jEBEAmufPANpNqBfnPUg
         WbSQP/INwRoLw==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5BF7FA0094;
        Thu,  8 Apr 2021 07:30:12 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Thu, 08 Apr 2021 11:30:11 +0400
Date:   Thu, 08 Apr 2021 11:30:11 +0400
In-Reply-To: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH v2 13/14] usb: dwc2: Fix partial power down exiting by system resume
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, <stable@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>
Message-Id: <20210408073012.5BF7FA0094@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: <stable@vger.kernel.org>
Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with DWC2_POWER_DOWN_PARAM_NONE")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
---
 Changes in v2:
 - None

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
2.25.1

