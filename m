Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C463210F
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKULqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiKULpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:45:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C11FF6
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:45:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1507061124
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FC4C433D6;
        Mon, 21 Nov 2022 11:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031133;
        bh=d0+ZxWTrqkNhrXUoqnrOXgf/yPH9XJ+8KsgnKZci9nE=;
        h=Subject:To:Cc:From:Date:From;
        b=dBmmANGAPLhZ9NjiKSv8ANr2YHhtYddj/TmMTeYetgc6rxlSGsoXzqVrFYXBVdSr4
         DVEMc97v9QcmIMPbpswAzMSsNnwHrWVe1pUFsrIG53AEUpxQd9BGBvgtAfiatHV6FW
         zsfm2nu1wp/S034oVZQaJ42jtzy8lDvF0eo7log8=
Subject: FAILED: patch "[PATCH] usb: cdns3: host: fix endless superspeed hub port reset" failed to apply to 5.10-stable tree
To:     jun.li@nxp.com, Frank.Li@nxp.com, alexander.stein@ew.tq-group.com,
        gregkh@linuxfoundation.org, peter.chen@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:45:24 +0100
Message-ID: <1669031124240149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port reset")
88171f67a2c1 ("usb: cdns3: Removes xhci_cdns3_suspend_quirk from host-export.h")
3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
e93e58d27402 ("usb: cdnsp: Device side header file for CDNSP driver")
0b490046d8d7 ("usb: cdns3: Refactoring names in reusable code")
394c3a144de8 ("usb: cdns3: Moves reusable code to separate module")
f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
db8892bb1bb6 ("usb: cdns3: Add support for DRD CDNSP")
d2a968dddf98 ("Merge tag 'usb-v5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/peter.chen/usb into usb-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d5333c931347005352d5b8beaa43528c94cfc9c Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Wed, 26 Oct 2022 15:07:49 -0400
Subject: [PATCH] usb: cdns3: host: fix endless superspeed hub port reset

When usb 3.0 hub connect with one USB 2.0 device and NO USB 3.0 device,
some usb hub reports endless port reset message.

[  190.324169] usb 2-1: new SuperSpeed USB device number 88 using xhci-hcd
[  190.352834] hub 2-1:1.0: USB hub found
[  190.356995] hub 2-1:1.0: 4 ports detected
[  190.700056] usb 2-1: USB disconnect, device number 88
[  192.472139] usb 2-1: new SuperSpeed USB device number 89 using xhci-hcd
[  192.500820] hub 2-1:1.0: USB hub found
[  192.504977] hub 2-1:1.0: 4 ports detected
[  192.852066] usb 2-1: USB disconnect, device number 89

The reason is the runtime pm state of USB2.0 port is active and
USB 3.0 port is suspend, so parent device is active state.

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/usb2/power/runtime_status

 suspended

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/usb1/power/runtime_status

 active

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/power/runtime_status

 active

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/power/runtime_status

 active

So xhci_cdns3_suspend_quirk() have not called. U3 configure is not applied.

move U3 configure into host start. Reinit again in resume function in case
controller power lost during suspend.

Cc: stable@vger.kernel.org 5.10
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Acked-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20221026190749.2280367-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index 9643b905e2d8..6164fc4c96a4 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -24,11 +24,37 @@
 #define CFG_RXDET_P3_EN		BIT(15)
 #define LPM_2_STB_SWITCH_EN	BIT(25)
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd);
+static void xhci_cdns3_plat_start(struct usb_hcd *hcd)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	u32 value;
+
+	/* set usbcmd.EU3S */
+	value = readl(&xhci->op_regs->command);
+	value |= CMD_PM_INDEX;
+	writel(value, &xhci->op_regs->command);
+
+	if (hcd->regs) {
+		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
+		value |= CFG_RXDET_P3_EN;
+		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
+
+		value = readl(hcd->regs + XECP_PORT_CAP_REG);
+		value |= LPM_2_STB_SWITCH_EN;
+		writel(value, hcd->regs + XECP_PORT_CAP_REG);
+	}
+}
+
+static int xhci_cdns3_resume_quirk(struct usb_hcd *hcd)
+{
+	xhci_cdns3_plat_start(hcd);
+	return 0;
+}
 
 static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
 	.quirks = XHCI_SKIP_PHY_INIT | XHCI_AVOID_BEI,
-	.suspend_quirk = xhci_cdns3_suspend_quirk,
+	.plat_start = xhci_cdns3_plat_start,
+	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
 static int __cdns_host_init(struct cdns *cdns)
@@ -90,32 +116,6 @@ static int __cdns_host_init(struct cdns *cdns)
 	return ret;
 }
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
-{
-	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
-	u32 value;
-
-	if (pm_runtime_status_suspended(hcd->self.controller))
-		return 0;
-
-	/* set usbcmd.EU3S */
-	value = readl(&xhci->op_regs->command);
-	value |= CMD_PM_INDEX;
-	writel(value, &xhci->op_regs->command);
-
-	if (hcd->regs) {
-		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
-		value |= CFG_RXDET_P3_EN;
-		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
-
-		value = readl(hcd->regs + XECP_PORT_CAP_REG);
-		value |= LPM_2_STB_SWITCH_EN;
-		writel(value, hcd->regs + XECP_PORT_CAP_REG);
-	}
-
-	return 0;
-}
-
 static void cdns_host_exit(struct cdns *cdns)
 {
 	kfree(cdns->xhci_plat_data);

