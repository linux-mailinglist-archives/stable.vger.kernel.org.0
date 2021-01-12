Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53672F3506
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392512AbhALQF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392471AbhALQF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 11:05:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 725C8221FD;
        Tue, 12 Jan 2021 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610467516;
        bh=7M6cBRWRIAgIt5YMyZMTkoNIC1nFUiv8iJoYUgXHFtM=;
        h=Subject:To:From:Date:From;
        b=vnLmJTgAHkvd9nW0YvTPP9Pl5KyZJN6/228UR58C6X45g9EIQj8kBjRNl7q8XHAKk
         HkM5NUzknndI/WQinIDFjc6gDPg4tgxCONVKUi13HU4221E3ayGrf12hebbnmrFhJO
         pTFZlNXy75eaAP7LRsdn6c0AZ8mIj/u287dh2IQs=
Subject: patch "usb: cdns3: imx: fix can't create core device the second time issue" added to usb-linus
To:     peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Jan 2021 17:06:15 +0100
Message-ID: <161046757512880@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: imx: fix can't create core device the second time issue

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2ef02b846ee2526249a562a66d6dcb25fcbca9d8 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Thu, 10 Dec 2020 21:31:37 +0800
Subject: usb: cdns3: imx: fix can't create core device the second time issue

The cdns3 core device is populated by calling of_platform_populate,
the flag OF_POPULATED is set for core device node, if this flag
is not cleared, when calling of_platform_populate the second time
after loading parent module again, the OF code will not try to create
platform device for core device.

To fix it, it uses of_platform_depopulate to depopulate the core
device which the parent created, and the flag OF_POPULATED for
core device node will be cleared accordingly.

Cc: <stable@vger.kernel.org>
Fixes: 1e056efab993 ("usb: cdns3: add NXP imx8qm glue layer")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/cdns3-imx.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-imx.c b/drivers/usb/cdns3/cdns3-imx.c
index 4d3fedc86753..6b358e8be579 100644
--- a/drivers/usb/cdns3/cdns3-imx.c
+++ b/drivers/usb/cdns3/cdns3-imx.c
@@ -218,20 +218,11 @@ static int cdns_imx_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int cdns_imx_remove_core(struct device *dev, void *data)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int cdns_imx_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 
-	device_for_each_child(dev, NULL, cdns_imx_remove_core);
+	of_platform_depopulate(dev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
2.30.0


