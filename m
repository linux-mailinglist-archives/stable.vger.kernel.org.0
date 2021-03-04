Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C12232CB83
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 05:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhCDEn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 23:43:29 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47112 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhCDEnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 23:43:18 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1244fclP052737;
        Wed, 3 Mar 2021 22:41:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1614832898;
        bh=2gdcGvIiei2/gTTob5OagdVE47Jl6d4UbQfoaMc8G3o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Tvntns1O9mFwr8M97BUwCpT6H8JQS6F8qX1mYCeFaoRcVBHqH4X415QeogWucA6Xz
         JT3Pva19t+sXEUYeXg5yvKr2c3rvl+GPP1D5fyXIUGgkycRacMfr6m1Hl+uwUKm0AU
         XyJZvnr44s38fq5RFW+ml8WA/oJDAif5cbYpirts=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1244fcLC087978
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Mar 2021 22:41:38 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 3 Mar
 2021 22:41:38 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 3 Mar 2021 22:41:38 -0600
Received: from a0393678-ssd.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1244fQfj042911;
        Wed, 3 Mar 2021 22:41:34 -0600
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Swapnil Jakhade <sjakhade@cadence.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH v4 02/13] phy: ti: j721e-wiz: Invoke wiz_init() before of_platform_device_create()
Date:   Thu, 4 Mar 2021 10:11:11 +0530
Message-ID: <20210304044122.15166-3-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210304044122.15166-1-kishon@ti.com>
References: <20210304044122.15166-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Invoke wiz_init() before configuring anything else in Sierra/Torrent
(invoked as part of of_platform_device_create()). wiz_init() resets the
SERDES device and any configuration done in the probe() of
Sierra/Torrent will be lost. In order to prevent SERDES configuration
from getting reset, invoke wiz_init() immediately before invoking
of_platform_device_create().

Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.10
---
 drivers/phy/ti/phy-j721e-wiz.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 995c7dbec77b..1bb73822f44a 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1262,27 +1262,24 @@ static int wiz_probe(struct platform_device *pdev)
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
2.17.1

