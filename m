Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414D420DA98
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgF2T6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387576AbgF2TkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95CD32485C;
        Mon, 29 Jun 2020 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444359;
        bh=7FER3X3bF/BuUo4GLN1LKSdPZ7JlrMU5UDI7zCGaRC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEhBK65UMcGeKTZK+OoL2yKdr5bEDzJQzM+LHA4L1aW4mxY5FF/AlXv6/spzS0nyx
         6nPqOjZEcFmGmYVvwaBZBumteSFzre6O+FWntA4d8ykO+nLoiobPKpacVJ4Vwp93lK
         9cHmtf0f8eomVp4d48hlMDftitzJ/RrELxl4Lvdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        kbuild test robot <lkp@intel.com>,
        Marek Vasut <marex@denx.de>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 035/178] usb: dwc2: Postponed gadget registration to the udc class driver
Date:   Mon, 29 Jun 2020 11:23:00 -0400
Message-Id: <20200629152523.2494198-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 207324a321a866401b098cadf19e4a2dd6584622 upstream.

During dwc2 driver probe, after gadget registration to the udc class
driver, if exist any builtin function driver it immediately bound to
dwc2 and after init host side (dwc2_hcd_init()) stucked in host mode.
Patch postpone gadget registration after host side initialization done.

Fixes: 117777b2c3bb9 ("usb: dwc2: Move gadget probe function into platform code")
Reported-by: kbuild test robot <lkp@intel.com>
Tested-by: Marek Vasut <marex@denx.de>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/f21cb38fecc72a230b86155d94c7e60c9cb66f58.1591690938.git.hminas@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c   |  6 ------
 drivers/usb/dwc2/platform.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7fd0900a9cb0c..f7528f732b2aa 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4886,12 +4886,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg)
 					  epnum, 0);
 	}
 
-	ret = usb_add_gadget_udc(dev, &hsotg->gadget);
-	if (ret) {
-		dwc2_hsotg_ep_free_request(&hsotg->eps_out[0]->ep,
-					   hsotg->ctrl_req);
-		return ret;
-	}
 	dwc2_hsotg_dump(hsotg);
 
 	return 0;
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 3c6ce09a6db56..15e55808cf4ea 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -507,6 +507,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+	/* Postponed adding a new gadget to the udc class driver list */
+	if (hsotg->gadget_enabled) {
+		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
+		if (retval) {
+			dwc2_hsotg_remove(hsotg);
+			goto error;
+		}
+	}
+#endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
 error:
-- 
2.25.1

