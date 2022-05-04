Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD551A974
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355583AbiEDRML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356983AbiEDRJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA114830B;
        Wed,  4 May 2022 09:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F22C5B827A3;
        Wed,  4 May 2022 16:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15DBC385A5;
        Wed,  4 May 2022 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683410;
        bh=ILpcJ1EnEQUwhSywYQ3IAqyxmDYiAyN1DkLdFFHSEvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5CoNnl27rR9eOUEV65JcK9fdfJ8/iWGdgtpeg/Z/XYie8jcDiimz5sjBp7FHQt3d
         ZIXpB4XyDOlwg9ohzGlIYFZg4ZZzv7Cz1sB9+VEc3+6D7G35pVCoIR3V3Ch17m/kMt
         ktgNWpGyIkXvR7Ye/bXTDda3ch197ixCR58zCagQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 095/225] phy: amlogic: fix error path in phy_g12a_usb3_pcie_probe()
Date:   Wed,  4 May 2022 18:45:33 +0200
Message-Id: <20220504153119.292839850@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2c8045d48dee703ad8eab2be7d6547765a89c069 ]

If clk_prepare_enable() fails we call clk_disable_unprepare()
in the error path what results in a warning that the clock
is disabled and unprepared already.
And if we fail later in phy_g12a_usb3_pcie_probe() then we
bail out w/o calling clk_disable_unprepare().
This patch fixes both errors.

Fixes: 36077e16c050 ("phy: amlogic: Add Amlogic G12A USB3 + PCIE Combo PHY Driver")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/8e416f95-1084-ee28-860e-7884f7fa2e32@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/amlogic/phy-meson-g12a-usb3-pcie.c    | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c b/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
index 5b471ab80fe2..54d65a6f0fcc 100644
--- a/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
+++ b/drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c
@@ -414,19 +414,19 @@ static int phy_g12a_usb3_pcie_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(priv->clk_ref);
 	if (ret)
-		goto err_disable_clk_ref;
+		return ret;
 
 	priv->reset = devm_reset_control_array_get_exclusive(dev);
-	if (IS_ERR(priv->reset))
-		return PTR_ERR(priv->reset);
+	if (IS_ERR(priv->reset)) {
+		ret = PTR_ERR(priv->reset);
+		goto err_disable_clk_ref;
+	}
 
 	priv->phy = devm_phy_create(dev, np, &phy_g12a_usb3_pcie_ops);
 	if (IS_ERR(priv->phy)) {
 		ret = PTR_ERR(priv->phy);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "failed to create PHY\n");
-
-		return ret;
+		dev_err_probe(dev, ret, "failed to create PHY\n");
+		goto err_disable_clk_ref;
 	}
 
 	phy_set_drvdata(priv->phy, priv);
@@ -434,8 +434,12 @@ static int phy_g12a_usb3_pcie_probe(struct platform_device *pdev)
 
 	phy_provider = devm_of_phy_provider_register(dev,
 						     phy_g12a_usb3_pcie_xlate);
+	if (IS_ERR(phy_provider)) {
+		ret = PTR_ERR(phy_provider);
+		goto err_disable_clk_ref;
+	}
 
-	return PTR_ERR_OR_ZERO(phy_provider);
+	return 0;
 
 err_disable_clk_ref:
 	clk_disable_unprepare(priv->clk_ref);
-- 
2.35.1



