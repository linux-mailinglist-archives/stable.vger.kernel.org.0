Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE037C6CD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhELPyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237498AbhELPuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B8C26162A;
        Wed, 12 May 2021 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833159;
        bh=gw1Afw53UvsovybQ58JuwZqUGKXyZQBYkUTIuOG48cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBMzBZKBe52nk8aHyzlP4uI7EUGjpKJdM2uPIxllZa7KaVSjy/2nQZghHjfMLhOBL
         iTCyfz6UL/iSu3UqcbWfKyulUzGqNeRgQLiuekkchC386pHZOfEXVIAkZ66zMdfoWS
         Z2KdMi5EaW89i+NAKWIwtkYpEO0jxY2+EG1iOvbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Swapnil Jakhade <sjakhade@cadence.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.11 042/601] phy: ti: j721e-wiz: Invoke wiz_init() before of_platform_device_create()
Date:   Wed, 12 May 2021 16:41:59 +0200
Message-Id: <20210512144829.203900515@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit f7eb147d306ad2efae6837e20d2944f03be42eb4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-j721e-wiz.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -947,27 +947,24 @@ static int wiz_probe(struct platform_dev
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


