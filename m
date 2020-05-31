Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AFA1E9831
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgEaOnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 10:43:08 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:54646 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgEaOnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 10:43:07 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 00F3E40164;
        Sun, 31 May 2020 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1590936187; bh=cFrdruy77uNdpg61TGwbsmAVmXU2tcp8CGi7/X2nbL0=;
        h=Date:From:Subject:To:Cc:From;
        b=RT8kpGUEagbxF2SBdZkc0Jgw3Cyh+nrU0cX7B4SIm+3VyHI2ECo2BV66Y5Lhw5E3U
         f66E+fUHkapXbXyI4kNd7R60YQt+yYaaQti4Uk8mcQGWnuGy8ZOok6SMLUb4jHdIL/
         6/2hVBD46YVOyyQyx92VmBwOpkdYt437j7Hz4gVmybQerWDTVSlmoUJUsPO9ZdFr5T
         V4aZ9BBPsrOlFmK5GyHjwKetocC07HScgn7AizA0c8YVjKomTY/ljaX4VyMuLnGZHb
         UmxCFK3HuEJ+lzKqOst65QXtVphDjyifRanWE5zjcetZTjXQT3w9429v3CkHWcn8wp
         CqU7Se53sv5Ig==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 1F1A1A009C;
        Sun, 31 May 2020 14:43:01 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Sun, 31 May 2020 18:42:58 +0400
Date:   Sun, 31 May 2020 18:42:58 +0400
Message-Id: <631755afa9aa2504684322ec285c7fa4fabca9de.1590935792.git.hminas@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH v2] usb: dwc2: Postponed gadget registration to the udc class driver
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During dwc2 driver probe, after gadget registration to the udc class
driver, if exist any builtin function driver it immediately bound to
dwc2 and after init host side (dwc2_hcd_init()) stucked in host mode.
Patch postpone gadget registration after host side initialization done.

Cc: stable@vger.kernel.org
Fixes: 117777b2c3bb9 ("usb: dwc2: Move gadget probe function into
platform code")
Tested-by: Marek Vasut <marex@denx.de>

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
---

Changes in V2:
- add module configuration check

 drivers/usb/dwc2/gadget.c   |  6 ------
 drivers/usb/dwc2/platform.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 12b98b466287..7faf5f8c056d 100644
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
index e571c8ae65ec..c347d93eae64 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -575,6 +575,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
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
2.11.0

