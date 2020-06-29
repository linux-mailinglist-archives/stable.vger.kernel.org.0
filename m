Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2E20D3A8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgF2TBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbgF2TAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E65A32553B;
        Mon, 29 Jun 2020 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446103;
        bh=R6p6CPvab4qXGoi74cHq70AKz/fSLbmbm+2atUmsmYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrECYSAK6AWbWmWSVhdBjC1FayZ3jOKoewA4k1CR6+EodIGXwOpVA64PGadrjxIra
         7oNF38brfp31L/HQj8mPP372zL5KhwbAcuSY10UzMVUEveQVUTW3fIUZGJkKFWlmt7
         iqwH/cizEfKRiAkNKZmgzVWCUdTbKoADOh+1BxkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        kbuild test robot <lkp@intel.com>,
        Marek Vasut <marex@denx.de>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 095/135] usb: dwc2: Postponed gadget registration to the udc class driver
Date:   Mon, 29 Jun 2020 11:52:29 -0400
Message-Id: <20200629155309.2495516-96-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
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
index 842c1ae7a2911..e5ad717cba22f 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3656,12 +3656,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
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
index 39c1cbf0e75d9..5e554b1d5a8f9 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -452,6 +452,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
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

