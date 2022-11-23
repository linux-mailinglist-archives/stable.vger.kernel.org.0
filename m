Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB6F63573C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiKWJkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbiKWJkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB81C105
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:37:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C23EEB81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E780C433D7;
        Wed, 23 Nov 2022 09:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196264;
        bh=qamekBnLTOxdoKN8MH7bW1uz8tCruoDYwcdhw1C4anY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ef41pOCLbfbqYtvPcCVVz/TfbZEn2L51DnHgiNPdBJnoghZWOXz0WrraTECFNRuWU
         OSdQXhtA3UxBLvLSU4KduVoPA3ZeyGQ+NIFKkftmTWAFb0BeAQbB9RZEPGBXjt7RaM
         n30p5q4h7OZAV2S0v9og6U5ZwBzUgf1YvZGzkj6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Jun <jun.li@nxp.com>,
        Frank Li <Frank.Li@nxp.com>,
        Peter Chen <peter.chen@kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 5.15 133/181] usb: cdns3: host: fix endless superspeed hub port reset
Date:   Wed, 23 Nov 2022 09:51:36 +0100
Message-Id: <20221123084608.092902786@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 9d5333c931347005352d5b8beaa43528c94cfc9c upstream.

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
---
 drivers/usb/cdns3/host.c |   56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -23,11 +23,37 @@
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
@@ -89,32 +115,6 @@ err1:
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


