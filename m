Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD57A2D5BCE
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389329AbgLJNcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389313AbgLJNcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 08:32:42 -0500
From:   Peter Chen <peter.chen@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     pawell@cadence.com, rogerq@ti.com
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, a-govindraju@ti.com,
        frank.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] usb: cdns3: imx: fix can't create core device the second time issue
Date:   Thu, 10 Dec 2020 21:31:37 +0800
Message-Id: <20201210133137.20249-2-peter.chen@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210133137.20249-1-peter.chen@kernel.org>
References: <20201210133137.20249-1-peter.chen@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

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
index 7d38180c842b..ca8e2ad2913a 100644
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
2.17.1

