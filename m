Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764F74F3727
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiDELKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348883AbiDEJso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79453B82F1;
        Tue,  5 Apr 2022 02:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECBAAB81C6F;
        Tue,  5 Apr 2022 09:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB99C385A0;
        Tue,  5 Apr 2022 09:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151407;
        bh=wrzKA6GCbzPNzzjub1bTM8BTkxgUSu+wwTfvBLMihEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8+T5/5aBzh4NOCCj0tAorkv9cTNqd/uM/VT3vtDUKajun3QWmw2ufI45Y1xkTShR
         +92Uvx4Q5wjuiS3o6JejvpSSk27/YhwohuYM035bbuk5/tCYB5LZSv9Ckvv9cQHZXT
         RU2SZHvBmKz9fNLMWaS3qadyHv2CXpFvRgCJHEic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/913] net: phy: at803x: move page selection fix to config_init
Date:   Tue,  5 Apr 2022 09:24:25 +0200
Message-Id: <20220405070351.927797234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 4f3a00c7f5b2cfe4e127fd3fe49b55e1b318c01f ]

The fix to select the copper page on AR8031 was being done in the probe
function rather than config_init, so it would not be redone after resume
from suspend. Move this to config_init so it is always redone when
needed.

Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bdac087058b2..5ae39d236b30 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -666,25 +666,7 @@ static int at803x_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	/* Some bootloaders leave the fiber page selected.
-	 * Switch to the copper page, as otherwise we read
-	 * the PHY capabilities from the fiber side.
-	 */
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
-		phy_unlock_mdio_bus(phydev);
-		if (ret)
-			goto err;
-	}
-
 	return 0;
-
-err:
-	if (priv->vddio)
-		regulator_disable(priv->vddio);
-
-	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -785,6 +767,22 @@ static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+		/* Some bootloaders leave the fiber page selected.
+		 * Switch to the copper page, as otherwise we read
+		 * the PHY capabilities from the fiber side.
+		 */
+		phy_lock_mdio_bus(phydev);
+		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		phy_unlock_mdio_bus(phydev);
+		if (ret)
+			return ret;
+
+		ret = at8031_pll_config(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
@@ -814,12 +812,6 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		ret = at8031_pll_config(phydev);
-		if (ret < 0)
-			return ret;
-	}
-
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.34.1



