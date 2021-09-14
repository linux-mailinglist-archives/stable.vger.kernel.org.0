Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418D940A963
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhINIgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhINIgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB12F6113B;
        Tue, 14 Sep 2021 08:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608538;
        bh=L1TksDe48lJNVonC9XWZXWNDrh+ZbQ/5srht4u8I1W0=;
        h=Subject:To:From:Date:From;
        b=EoHHusVbWHmDTBz3lB8LtSmoP1AWRmchSb0jgvt8lRnxwB21nSGI0mcxuCUHGumqd
         u2yWp4mO9Hq4GIKUaFUXoWC0sW1LNBpOnDAgCTNDWDKlo7++od1jaamEdk9X1iatdh
         zXq+HbkHw6CjvEMedn2OU6o48sfkNp9iXxnftKL8=
Subject: patch "usb: dwc3: core: balance phy init and exit" added to usb-linus
To:     jun.li@nxp.com, balbi@kernel.org, faqiang.zhu@nxp.com,
        gregkh@linuxfoundation.org, john.stultz@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:35:21 +0200
Message-ID: <1631608521238254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: core: balance phy init and exit

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8cfac9a6744fcb143cb3e94ce002f09fd17fadbb Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Wed, 8 Sep 2021 10:28:19 +0800
Subject: usb: dwc3: core: balance phy init and exit

After we start to do core soft reset while usb role switch,
the phy init is invoked at every switch to device mode, but
its counter part de-init is missing, this causes the actual
phy init can not be done when we really want to re-init phy
like system resume, because the counter maintained by phy
core is not 0. considering phy init is actually redundant for
role switch, so move out the phy init from core soft reset to
dwc3 core init where is the only place required.

Fixes: f88359e1588b ("usb: dwc3: core: Do core softreset when switch mode")
Cc: <stable@vger.kernel.org>
Tested-by: faqiang.zhu <faqiang.zhu@nxp.com>
Tested-by: John Stultz <john.stultz@linaro.org> #HiKey960
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1631068099-13559-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 01866dcb953b..0104a80b185e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -264,19 +264,6 @@ static int dwc3_core_soft_reset(struct dwc3 *dwc)
 {
 	u32		reg;
 	int		retries = 1000;
-	int		ret;
-
-	usb_phy_init(dwc->usb2_phy);
-	usb_phy_init(dwc->usb3_phy);
-	ret = phy_init(dwc->usb2_generic_phy);
-	if (ret < 0)
-		return ret;
-
-	ret = phy_init(dwc->usb3_generic_phy);
-	if (ret < 0) {
-		phy_exit(dwc->usb2_generic_phy);
-		return ret;
-	}
 
 	/*
 	 * We're resetting only the device side because, if we're in host mode,
@@ -310,9 +297,6 @@ static int dwc3_core_soft_reset(struct dwc3 *dwc)
 			udelay(1);
 	} while (--retries);
 
-	phy_exit(dwc->usb3_generic_phy);
-	phy_exit(dwc->usb2_generic_phy);
-
 	return -ETIMEDOUT;
 
 done:
@@ -982,9 +966,21 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->phys_ready = true;
 	}
 
+	usb_phy_init(dwc->usb2_phy);
+	usb_phy_init(dwc->usb3_phy);
+	ret = phy_init(dwc->usb2_generic_phy);
+	if (ret < 0)
+		goto err0a;
+
+	ret = phy_init(dwc->usb3_generic_phy);
+	if (ret < 0) {
+		phy_exit(dwc->usb2_generic_phy);
+		goto err0a;
+	}
+
 	ret = dwc3_core_soft_reset(dwc);
 	if (ret)
-		goto err0a;
+		goto err1;
 
 	if (hw_mode == DWC3_GHWPARAMS0_MODE_DRD &&
 	    !DWC3_VER_IS_WITHIN(DWC3, ANY, 194A)) {
-- 
2.33.0


