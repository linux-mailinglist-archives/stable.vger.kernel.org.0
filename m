Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E489420E7F8
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgF2SfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20A52462D;
        Mon, 29 Jun 2020 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443961;
        bh=by+dh9vvHi+FcF9OlEwOPJ48yGlcNSRcknaKIsgnC3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYWZydpB/qFmYvZJlT42qK7YdCYc3jW1FgjzNObpjk/ErKv2r6TLy4ePKw1A13mWR
         10LH86b3379Spy723/fMUgw0XN4Dmhb33uypOlS3JOTGtW0q5s3i25KUeHyxfas7eB
         7537jG4MhAq6OsbCVf7yN3Lo3pQje9u0UGfzJSM8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        kbuild test robot <lkp@intel.com>,
        Marek Vasut <marex@denx.de>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 064/265] usb: dwc2: Postponed gadget registration to the udc class driver
Date:   Mon, 29 Jun 2020 11:14:57 -0400
Message-Id: <20200629151818.2493727-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index 12b98b4662872..7faf5f8c056d4 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4920,12 +4920,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg)
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
index 69972750e1612..5684c4781af9e 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -536,6 +536,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+	/* Postponed adding a new gadget to the udc class driver list */
+	if (hsotg->gadget_enabled) {
+		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
+		if (retval) {
+			dwc2_hsotg_remove(hsotg);
+			goto error_init;
+		}
+	}
+#endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
 error_init:
-- 
2.25.1

