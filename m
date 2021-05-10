Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1C737871E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhEJLNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236024AbhEJLHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4086194B;
        Mon, 10 May 2021 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644245;
        bh=VeoYrpX0w42wUk3oct7e9z8D++Z1g/izGdPTLk9JEf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJr+e2o28vhiDBS9wo4p8FkVJJ/b+jrCk/053qE49dVYPuLOa2FNaSaXonY0ue/na
         YGSOeuNCmuKwace6nwaAmXyV3APwppMoM20OoFaxJRrDfNUscZfNxrI91/Xf07/pDg
         z/AuVaHmhw/qv+pRX2tvkV/6HSLiKeQ5JMtyQNok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ferry Toth <fntoth@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Yu Chen <chenyu56@huawei.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.11 327/342] usb: dwc3: core: Do core softreset when switch mode
Date:   Mon, 10 May 2021 12:21:57 +0200
Message-Id: <20210510102020.911430387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Chen <chenyu56@huawei.com>

commit f88359e1588b85cf0e8209ab7d6620085f3441d9 upstream.

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

Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Wesley Cheng <wcheng@codeaurora.org>
Cc: <stable@vger.kernel.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Tested-by: Wesley Cheng <wcheng@codeaurora.org>
Signed-off-by: Yu Chen <chenyu56@huawei.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   27 +++++++++++++++++++++++++++
 drivers/usb/dwc3/core.h |    5 +++++
 2 files changed, 32 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -114,6 +114,8 @@ void dwc3_set_prtcap(struct dwc3 *dwc, u
 	dwc->current_dr_role = mode;
 }
 
+static int dwc3_core_soft_reset(struct dwc3 *dwc);
+
 static void __dwc3_set_mode(struct work_struct *work)
 {
 	struct dwc3 *dwc = work_to_dwc(work);
@@ -121,6 +123,8 @@ static void __dwc3_set_mode(struct work_
 	int ret;
 	u32 reg;
 
+	mutex_lock(&dwc->mutex);
+
 	pm_runtime_get_sync(dwc->dev);
 
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
@@ -154,6 +158,25 @@ static void __dwc3_set_mode(struct work_
 		break;
 	}
 
+	/* For DRD host or device mode only */
+	if (dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
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
@@ -178,6 +201,8 @@ static void __dwc3_set_mode(struct work_
 		}
 		break;
 	case DWC3_GCTL_PRTCAP_DEVICE:
+		dwc3_core_soft_reset(dwc);
+
 		dwc3_event_buffers_setup(dwc);
 
 		if (dwc->usb2_phy)
@@ -200,6 +225,7 @@ static void __dwc3_set_mode(struct work_
 out:
 	pm_runtime_mark_last_busy(dwc->dev);
 	pm_runtime_put_autosuspend(dwc->dev);
+	mutex_unlock(&dwc->mutex);
 }
 
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
@@ -1529,6 +1555,7 @@ static int dwc3_probe(struct platform_de
 	dwc3_cache_hwparams(dwc);
 
 	spin_lock_init(&dwc->lock);
+	mutex_init(&dwc->mutex);
 
 	pm_runtime_set_active(dev);
 	pm_runtime_use_autosuspend(dev);
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
@@ -942,6 +943,7 @@ struct dwc3_scratchpad_array {
  * @scratch_addr: dma address of scratchbuf
  * @ep0_in_setup: one control transfer is completed and enter setup phase
  * @lock: for synchronizing
+ * @mutex: for mode switching
  * @dev: pointer to our struct device
  * @sysdev: pointer to the DMA-capable device
  * @xhci: pointer to our xHCI child
@@ -1078,6 +1080,9 @@ struct dwc3 {
 	/* device lock */
 	spinlock_t		lock;
 
+	/* mode switching lock */
+	struct mutex		mutex;
+
 	struct device		*dev;
 	struct device		*sysdev;
 


