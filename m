Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB259DF2C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353507AbiHWKNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353595AbiHWKLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA4215A0B;
        Tue, 23 Aug 2022 01:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798E76155D;
        Tue, 23 Aug 2022 08:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8009EC433D6;
        Tue, 23 Aug 2022 08:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245056;
        bh=dA6ZEuwj7DPqjItnEoT4QchiUOKqV/ohRsxC0LHDOW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1b+F7fNB8tWrLbVNpxaLlzkxg5iPt3gLA4KkK+FcoCGGarPgVe7Acp6bxM7SALHG
         liy0b9Z8G57ab4G4lVuZWtxUcyRe5BK+Fi3hDYNseViYGRXBk2b93G5qla0AdZCamT
         8UAydrWp7prprXg9E4z4V2cQwl7rjn33ujD7Gw+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/244] phy: samsung: phy-exynos-pcie: sanitize init/power_on callbacks
Date:   Tue, 23 Aug 2022 10:25:59 +0200
Message-Id: <20220823080106.152465127@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit f2812227bb07e2eaee74253f11cea1576945df31 ]

The exynos-pcie driver called phy_power_on() before phy_init() for some
historical reasons. However the generic PHY framework assumes that the
proper sequence is to call phy_init() first, then phy_power_on(). The
operations done by both functions should be considered as one action and as
such they are called by the exynos-pcie driver (without doing anything
between them). The initialization is just a sequence of register writes,
which cannot be altered without breaking the hardware operation.

To match the generic PHY framework requirement, simply move all register
writes to the phy_init()/phy_exit() and drop power_on()/power_off()
callbacks. This way the driver will also work with the old (incorrect)
PHY initialization call sequence.

Link: https://lore.kernel.org/r/20220628220409.26545-1-m.szyprowski@samsung.com
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-By: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-exynos-pcie.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/samsung/phy-exynos-pcie.c b/drivers/phy/samsung/phy-exynos-pcie.c
index 578cfe07d07a..53c9230c2907 100644
--- a/drivers/phy/samsung/phy-exynos-pcie.c
+++ b/drivers/phy/samsung/phy-exynos-pcie.c
@@ -51,6 +51,13 @@ static int exynos5433_pcie_phy_init(struct phy *phy)
 {
 	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
 
+	regmap_update_bits(ep->pmureg, EXYNOS5433_PMU_PCIE_PHY_OFFSET,
+			   BIT(0), 1);
+	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_GLOBAL_RESET,
+			   PCIE_APP_REQ_EXIT_L1_MODE, 0);
+	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_L1SUB_CM_CON,
+			   PCIE_REFCLK_GATING_EN, 0);
+
 	regmap_update_bits(ep->fsysreg,	PCIE_EXYNOS5433_PHY_COMMON_RESET,
 			   PCIE_PHY_RESET, 1);
 	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_MAC_RESET,
@@ -109,20 +116,7 @@ static int exynos5433_pcie_phy_init(struct phy *phy)
 	return 0;
 }
 
-static int exynos5433_pcie_phy_power_on(struct phy *phy)
-{
-	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
-
-	regmap_update_bits(ep->pmureg, EXYNOS5433_PMU_PCIE_PHY_OFFSET,
-			   BIT(0), 1);
-	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_GLOBAL_RESET,
-			   PCIE_APP_REQ_EXIT_L1_MODE, 0);
-	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_L1SUB_CM_CON,
-			   PCIE_REFCLK_GATING_EN, 0);
-	return 0;
-}
-
-static int exynos5433_pcie_phy_power_off(struct phy *phy)
+static int exynos5433_pcie_phy_exit(struct phy *phy)
 {
 	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
 
@@ -135,8 +129,7 @@ static int exynos5433_pcie_phy_power_off(struct phy *phy)
 
 static const struct phy_ops exynos5433_phy_ops = {
 	.init		= exynos5433_pcie_phy_init,
-	.power_on	= exynos5433_pcie_phy_power_on,
-	.power_off	= exynos5433_pcie_phy_power_off,
+	.exit		= exynos5433_pcie_phy_exit,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.35.1



