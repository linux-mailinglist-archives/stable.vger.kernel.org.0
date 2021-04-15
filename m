Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B47A35FFF4
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 04:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhDOCX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 22:23:56 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:47226 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhDOCXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 22:23:53 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B4903C0562;
        Thu, 15 Apr 2021 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618453398; bh=RaUK/KJznydQREyHTPtE+LPWuoJujAsugtAVDFiu5QM=;
        h=Date:From:Subject:To:Cc:From;
        b=Fi3vSDsr6m+JHPG2Ri9OGU5wwwVMcYQ0vTxglGjH29iUqpzd38BBebD7KQPxYeE9j
         bpkiRIrpdXwb3VgvbReTzcb6kDLgWxBgxz8NjeluGYD6cB3Sp/4841BwkoyaxALanQ
         uCifMMM758w51/tAEyhw81Ezgo/zL1Vv2/7YhEAWDKlGKMe3QsvSNbMOHOTgVaPpr2
         5AP2qosb2WQHBpPAdRI1O+E3t8Pd0h1CQXCQviz5jRGnpdxfA8koOS4E+ckgyjqBsQ
         Ia6qUoCB6KhNZIUJvWLAXfzKjyUhVNPttQrP91TetWGZ5H5QrrCDw0ddy8GHsWEPMJ
         YLyd6Rh0ovMNw==
Received: from lab-vbox (unknown [10.205.129.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 424F7A005E;
        Thu, 15 Apr 2021 02:23:14 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Wed, 14 Apr 2021 19:23:14 -0700
Date:   Wed, 14 Apr 2021 19:23:14 -0700
Message-Id: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: core: Do core softreset when switch mode
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Chen <chenyu56@huawei.com>
From: John Stultz <john.stultz@linaro.org>

According to the programming guide, to switch mode for DRD controller,
the driver needs to do the following.

To switch from device to host:
1. Reset controller with GCTL.CoreSoftReset
2. Set GCTL.PrtCapDir(host mode)
3. Reset the host with USBCMD.HCRESET
4. Then follow up with the initializing host registers sequence

To switch from host to device:
1. Reset controller with GCTL.CoreSoftReset
2. Set GCTL.PrtCapDir(device mode)
3. Reset the device with DCTL.CSftRst
4. Then follow up with the initializing registers sequence

Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
switching from host to device. John Stult reported a lockup issue seen
with HiKey960 platform without these steps[1]. Similar issue is observed
with Ferry's testing platform[2].

So, apply the required steps along with some fixes to Yu Chen's and John
Stultz's version. The main fixes to their versions are the missing wait
for clocks synchronization before clearing GCTL.CoreSoftReset and only
apply DCTL.CSftRst when switching from host to device.

[1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
[2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/

Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Wesley Cheng <wcheng@codeaurora.org>
Cc: <stable@vger.kernel.org>
Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Signed-off-by: Yu Chen <chenyu56@huawei.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
Note:
Only some basic mode switching tests were done using our HAPS platform. It'd
be great if we can have some "Tested-by" with some real hardwares. Thanks.

 drivers/usb/dwc3/core.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 5c25e6a72dbd..4ac2895331b7 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
@@ -40,6 +41,8 @@
 
 #define DWC3_DEFAULT_AUTOSUSPEND_DELAY	5000 /* ms */
 
+static DEFINE_MUTEX(mode_switch_lock);
+
 /**
  * dwc3_get_dr_mode - Validates and sets dr_mode
  * @dwc: pointer to our context structure
@@ -114,13 +117,20 @@ void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode)
 	dwc->current_dr_role = mode;
 }
 
+static int dwc3_core_soft_reset(struct dwc3 *dwc);
+
 static void __dwc3_set_mode(struct work_struct *work)
 {
 	struct dwc3 *dwc = work_to_dwc(work);
 	unsigned long flags;
+	unsigned int hw_mode;
 	int ret;
 	u32 reg;
 
+	mutex_lock(&mode_switch_lock);
+
+	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
+
 	pm_runtime_get_sync(dwc->dev);
 
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
@@ -154,6 +164,24 @@ static void __dwc3_set_mode(struct work_struct *work)
 		break;
 	}
 
+	if (hw_mode == DWC3_GHWPARAMS0_MODE_DRD) {
+		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
+		reg |= DWC3_GCTL_CORESOFTRESET;
+		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
+
+		/*
+		 * Wait for internal clocks to synchronized. DWC_usb31 and
+		 * DWC_usb32 may need at least 50ms (less for DWC_usb3). To
+		 * keep it consistent across different IPs, let's wait up to
+		 * 100ms before clearing GCTL.CORESOFTRESET.
+		 */
+		msleep(100);
+
+		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
+		reg &= ~DWC3_GCTL_CORESOFTRESET;
+		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
 
 	dwc3_set_prtcap(dwc, dwc->desired_dr_role);
@@ -178,6 +206,9 @@ static void __dwc3_set_mode(struct work_struct *work)
 		}
 		break;
 	case DWC3_GCTL_PRTCAP_DEVICE:
+		if (hw_mode == DWC3_GHWPARAMS0_MODE_DRD)
+			dwc3_core_soft_reset(dwc);
+
 		dwc3_event_buffers_setup(dwc);
 
 		if (dwc->usb2_phy)
@@ -200,6 +231,7 @@ static void __dwc3_set_mode(struct work_struct *work)
 out:
 	pm_runtime_mark_last_busy(dwc->dev);
 	pm_runtime_put_autosuspend(dwc->dev);
+	mutex_unlock(&mode_switch_lock);
 }
 
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)

base-commit: 4b853c236c7b5161a2e444bd8b3c76fe5aa5ddcb
-- 
2.28.0

