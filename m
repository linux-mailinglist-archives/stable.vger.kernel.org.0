Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1821E7A26
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 12:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgE2KMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 06:12:19 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:45860 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726629AbgE2KMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 06:12:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7A4CC40914;
        Fri, 29 May 2020 10:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1590747138; bh=J1cOrJZusMLst7lsrpeM8Ti16IstZnIDLZV0EfLRdk4=;
        h=Date:From:Subject:To:Cc:From;
        b=DVoREkJihGPojAPCB1lSC6dXWgfZ4Q3Im8mCFLTRJvq6Ew1//poeGpOgtjEdZx0Ri
         M/ZP9tQn12Z5ZaNxWCzaLBBKE6WMTfAhgyy1+7HLlTraguzMuICBuFtN2J+huYrTEC
         dPujya3Che5W6L/PSgTZPz3DIYiTHhTIM8UQXS93d8FQfO0hExP36IkE1HH+KmUCdu
         oeJGOPCtC15GEcpZ3zd0PabHvZk593aN/rjUmyRNy2zOY9fT68d9y70c77SIH5GkJ7
         raLbQWS7hlyoARlZThm5Lhhv0ARmQ+HTxY+5KYrpmIfMuN9GpcSHcY4d1CABIp9OXK
         7l+2IdcpgT5aw==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id EC43CA005B;
        Fri, 29 May 2020 10:12:12 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Fri, 29 May 2020 14:12:11 +0400
Date:   Fri, 29 May 2020 14:12:11 +0400
Message-Id: <137e787bf7c7935bda3358c8f07230d3f4998fad.1590745119.git.hminas@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH] usb: dwc2: Postponed gadget registration to the udc class driver
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
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
 drivers/usb/dwc2/gadget.c   | 6 ------
 drivers/usb/dwc2/platform.c | 9 +++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

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
index e571c8ae65ec..6b4043117e97 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -575,6 +575,15 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
+	/* Postponed adding a new gadget to the udc class driver list */
+	if (hsotg->gadget_enabled) {
+		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
+		if (retval) {
+			dwc2_hsotg_remove(hsotg);
+			goto error_init;
+		}
+	}
+
 	return 0;
 
 error_init:
-- 
2.11.0

