Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F015A356F64
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 16:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbhDGO4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 10:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345305AbhDGO4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 10:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF38B61363;
        Wed,  7 Apr 2021 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617807349;
        bh=WeIZ73fssOxdtL4yX0cgA5DVqYqIpc53nVVy082zvZA=;
        h=Subject:To:From:Date:From;
        b=VCaFhj5MLYPXX4eE8NzcBkzaqRvKGfVHc8V6cZVHkoG4Ie+y8XAtws/6Qy10/y/Wt
         E82H5h1tZJ8vEi5pXoJKZ8YRuFESPzk/w2ubIrUyRSuQyPJqNUaXFH8ESTiEtTL9zm
         pTLEFSPv0lWoITS/gvffZoOPs4ljBV9SJpfFkoOw=
Subject: patch "phy: ti: j721e-wiz: Invoke wiz_init() before" added to char-misc-testing
To:     kishon@ti.com, sjakhade@cadence.com, stable@vger.kernel.org,
        vkoul@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 16:53:27 +0200
Message-ID: <161780720765124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: ti: j721e-wiz: Invoke wiz_init() before

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f7eb147d306ad2efae6837e20d2944f03be42eb4 Mon Sep 17 00:00:00 2001
From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Fri, 19 Mar 2021 18:11:17 +0530
Subject: phy: ti: j721e-wiz: Invoke wiz_init() before
 of_platform_device_create()

Invoke wiz_init() before configuring anything else in Sierra/Torrent
(invoked as part of of_platform_device_create()). wiz_init() resets the
SERDES device and any configuration done in the probe() of
Sierra/Torrent will be lost. In order to prevent SERDES configuration
from getting reset, invoke wiz_init() immediately before invoking
of_platform_device_create().

Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Swapnil Jakhade <sjakhade@cadence.com>
Cc: <stable@vger.kernel.org> # v5.10
Link: https://lore.kernel.org/r/20210319124128.13308-3-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 3c003f9d0b6f..53d01da2894a 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1264,27 +1264,24 @@ static int wiz_probe(struct platform_device *pdev)
 		goto err_get_sync;
 	}
 
+	ret = wiz_init(wiz);
+	if (ret) {
+		dev_err(dev, "WIZ initialization failed\n");
+		goto err_wiz_init;
+	}
+
 	serdes_pdev = of_platform_device_create(child_node, NULL, dev);
 	if (!serdes_pdev) {
 		dev_WARN(dev, "Unable to create SERDES platform device\n");
 		ret = -ENOMEM;
-		goto err_pdev_create;
-	}
-	wiz->serdes_pdev = serdes_pdev;
-
-	ret = wiz_init(wiz);
-	if (ret) {
-		dev_err(dev, "WIZ initialization failed\n");
 		goto err_wiz_init;
 	}
+	wiz->serdes_pdev = serdes_pdev;
 
 	of_node_put(child_node);
 	return 0;
 
 err_wiz_init:
-	of_platform_device_destroy(&serdes_pdev->dev, NULL);
-
-err_pdev_create:
 	wiz_clock_cleanup(wiz, node);
 
 err_get_sync:
-- 
2.31.1


