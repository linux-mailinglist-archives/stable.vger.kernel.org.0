Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E487A594AAB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353064AbiHPAF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352284AbiHPAAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D2095E69;
        Mon, 15 Aug 2022 13:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57BBEB80EB1;
        Mon, 15 Aug 2022 20:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87A8C433C1;
        Mon, 15 Aug 2022 20:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594893;
        bh=Y2JRNAOW2EOmlGoFTTcKC2KjNshzPUJ73cPXUm8YcIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5yOTA2TFVa0i/xno9ABXYtLoG/ZhEh2j7C5awFBLD79sip8aJ/nlZ9y1CPMfYNLM
         Ui/73b6pDnx9PFGWeTNzSOb7yKtoCCe+kKlUmV2p0DvDWpewGH5bATcU60cnVhLLjG
         9wdeQBMroq/cVTLqxfA04htIwf+DlaPk+QuWxcpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0593/1157] phy: samsung: exynosautov9-ufs: correct TSRV register configurations
Date:   Mon, 15 Aug 2022 19:59:09 +0200
Message-Id: <20220815180503.373791520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit f7fdc4db071f7ee7d408ea3f083222a060c76623 ]

For exynos auto v9's UFS MPHY, We should use 0x50 offset of TSRV register
configurations. So, it must be

s/PHY_TRSV_REG_CFG/PHY_TRSV_REG_CFG_AUTOV9/g

Fixes: d64519249e1d ("phy: samsung-ufs: support exynosauto ufs phy driver")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220603050536.61957-1-chanho61.park@samsung.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-exynosautov9-ufs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/samsung/phy-exynosautov9-ufs.c b/drivers/phy/samsung/phy-exynosautov9-ufs.c
index 36398a15c2db..d043dfdb598a 100644
--- a/drivers/phy/samsung/phy-exynosautov9-ufs.c
+++ b/drivers/phy/samsung/phy-exynosautov9-ufs.c
@@ -31,22 +31,22 @@ static const struct samsung_ufs_phy_cfg exynosautov9_pre_init_cfg[] = {
 	PHY_COMN_REG_CFG(0x023, 0xc0, PWR_MODE_ANY),
 	PHY_COMN_REG_CFG(0x023, 0x00, PWR_MODE_ANY),
 
-	PHY_TRSV_REG_CFG(0x042, 0x5d, PWR_MODE_ANY),
-	PHY_TRSV_REG_CFG(0x043, 0x80, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG_AUTOV9(0x042, 0x5d, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG_AUTOV9(0x043, 0x80, PWR_MODE_ANY),
 
 	END_UFS_PHY_CFG,
 };
 
 /* Calibration for HS mode series A/B */
 static const struct samsung_ufs_phy_cfg exynosautov9_pre_pwr_hs_cfg[] = {
-	PHY_TRSV_REG_CFG(0x032, 0xbc, PWR_MODE_HS_ANY),
-	PHY_TRSV_REG_CFG(0x03c, 0x7f, PWR_MODE_HS_ANY),
-	PHY_TRSV_REG_CFG(0x048, 0xc0, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG_AUTOV9(0x032, 0xbc, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG_AUTOV9(0x03c, 0x7f, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG_AUTOV9(0x048, 0xc0, PWR_MODE_HS_ANY),
 
-	PHY_TRSV_REG_CFG(0x04a, 0x00, PWR_MODE_HS_G3_SER_B),
-	PHY_TRSV_REG_CFG(0x04b, 0x10, PWR_MODE_HS_G1_SER_B |
-				      PWR_MODE_HS_G3_SER_B),
-	PHY_TRSV_REG_CFG(0x04d, 0x63, PWR_MODE_HS_G3_SER_B),
+	PHY_TRSV_REG_CFG_AUTOV9(0x04a, 0x00, PWR_MODE_HS_G3_SER_B),
+	PHY_TRSV_REG_CFG_AUTOV9(0x04b, 0x10, PWR_MODE_HS_G1_SER_B |
+				PWR_MODE_HS_G3_SER_B),
+	PHY_TRSV_REG_CFG_AUTOV9(0x04d, 0x63, PWR_MODE_HS_G3_SER_B),
 
 	END_UFS_PHY_CFG,
 };
-- 
2.35.1



