Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49ED3326FB
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCINYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhCINYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 08:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850EC650F5;
        Tue,  9 Mar 2021 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615296245;
        bh=9ionGWb2H5/1t5nl1H6UaJseLLKfmw6/CdkeDyhSxhQ=;
        h=Subject:To:From:Date:From;
        b=x5svahxZqOFPMGmePNaKGQgI4+D1ktZBQqdNibdk4Dqji3vcrG+vNY0y8ZKc/tWjk
         f60Y7p4hh0MBr0a4F8TqaX1R7fhcYXrGUS+E7fk2ZY8nAR1bdxDjfRCXlpdm7IMPC3
         XffLej8JAmN9okZMyqn98PVrbDE5z5RG2K0u/XS8=
Subject: patch "usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement" added to usb-linus
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Mar 2021 14:24:02 +0100
Message-ID: <161529624212223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 58f3367b2359e88b83bcfca5b77d48b609eb2123 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Fri, 12 Feb 2021 23:55:19 +0300
Subject: usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

of_get_child_by_name() increments the reference counter of the OF node it
managed to find. So after the code is done using the device node, the
refcount must be decremented. Add missing of_node_put() invocation then
to the dwc3_qcom_of_register_core() method, since DWC3 OF node is being
used only there.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20210212205521.14280-1-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 730e8d6a2aa6..fcaf04483ad0 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -653,16 +653,19 @@ static int dwc3_qcom_of_register_core(struct platform_device *pdev)
 	ret = of_platform_populate(np, NULL, NULL, dev);
 	if (ret) {
 		dev_err(dev, "failed to register dwc3 core - %d\n", ret);
-		return ret;
+		goto node_put;
 	}
 
 	qcom->dwc3 = of_find_device_by_node(dwc3_np);
 	if (!qcom->dwc3) {
+		ret = -ENODEV;
 		dev_err(dev, "failed to get dwc3 platform device\n");
-		return -ENODEV;
 	}
 
-	return 0;
+node_put:
+	of_node_put(dwc3_np);
+
+	return ret;
 }
 
 static struct platform_device *
-- 
2.30.1


