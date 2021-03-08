Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F2330714
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 06:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhCHFIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 00:08:15 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36254 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhCHFHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 00:07:54 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 12857nDv077155;
        Sun, 7 Mar 2021 23:07:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1615180069;
        bh=2gdcGvIiei2/gTTob5OagdVE47Jl6d4UbQfoaMc8G3o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=HNefMIbSZj4d7XSMezl3owZ8s1uwfLtuC4P/YROmgunGCfIy545yocU9oOIBytdAY
         Uzpbm2Y1LZuaRK1CHuPZBH7L4wOVPYZt4ENisDayDwBuhOm+iP73otTCVoCNud5qKk
         a2f7lqnlm+KeEUVJ8AIfGKDpkpDTMltYl7GA48zQ=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 12857nVV039450
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 7 Mar 2021 23:07:49 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Sun, 7 Mar
 2021 23:07:49 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Sun, 7 Mar 2021 23:07:49 -0600
Received: from a0393678-ssd.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 12857aL0086547;
        Sun, 7 Mar 2021 23:07:45 -0600
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Swapnil Jakhade <sjakhade@cadence.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH v5 02/13] phy: ti: j721e-wiz: Invoke wiz_init() before of_platform_device_create()
Date:   Mon, 8 Mar 2021 10:37:21 +0530
Message-ID: <20210308050732.7140-3-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210308050732.7140-1-kishon@ti.com>
References: <20210308050732.7140-1-kishon@ti.com>
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

