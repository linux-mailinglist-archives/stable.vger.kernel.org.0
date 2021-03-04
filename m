Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF29D32CB77
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 05:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhCDEm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 23:42:57 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47100 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbhCDEm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 23:42:29 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1244fYKo052726;
        Wed, 3 Mar 2021 22:41:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1614832894;
        bh=HHTvmMjtTJRPNFpN3zkcx0PIiGXY1RMP1eK0a1ouBO4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Q+sF68pnb33I4wcR61zZ5mYu/WLg39P07W8zX0Yr1c6t9R9yPkJ3grgvX5MmuCZ3r
         JOsLBFUk2iBjCO33hkqPatG1XYBNdHpLkbiBJkV36z0kl4pchSrqY9h3Q9JIQKZ2vo
         nyjgnz3mpktfy7O8sTP/p/5J3z0gSBmOunWVyYVY=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1244fY9e087940
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Mar 2021 22:41:34 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 3 Mar
 2021 22:41:34 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 3 Mar 2021 22:41:34 -0600
Received: from a0393678-ssd.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1244fQfi042911;
        Wed, 3 Mar 2021 22:41:31 -0600
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Swapnil Jakhade <sjakhade@cadence.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH v4 01/13] phy: cadence: Sierra: Fix PHY power_on sequence
Date:   Thu, 4 Mar 2021 10:11:10 +0530
Message-ID: <20210304044122.15166-2-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210304044122.15166-1-kishon@ti.com>
References: <20210304044122.15166-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
de-asserts PHY_RESET even before the configurations are loaded in
phy_init(). However PHY_RESET should be de-asserted only after
all the configurations has been initialized, instead of de-asserting
in probe. Fix it here.

Fixes: 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/phy/cadence/phy-cadence-sierra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index 26a0badabe38..19f32ae877b9 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -319,6 +319,12 @@ static int cdns_sierra_phy_on(struct phy *gphy)
 	u32 val;
 	int ret;
 
+	ret = reset_control_deassert(sp->phy_rst);
+	if (ret) {
+		dev_err(dev, "Failed to take the PHY out of reset\n");
+		return ret;
+	}
+
 	/* Take the PHY lane group out of reset */
 	ret = reset_control_deassert(ins->lnk_rst);
 	if (ret) {
@@ -616,7 +622,6 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	reset_control_deassert(sp->phy_rst);
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 put_child:
-- 
2.17.1

