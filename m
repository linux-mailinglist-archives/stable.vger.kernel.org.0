Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E8A59416D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbiHOV2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348152AbiHOV07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:26:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4CEE97F1;
        Mon, 15 Aug 2022 12:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 607F560FDA;
        Mon, 15 Aug 2022 19:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63953C433D6;
        Mon, 15 Aug 2022 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591374;
        bh=Y2JRNAOW2EOmlGoFTTcKC2KjNshzPUJ73cPXUm8YcIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMYc9Ams5BffVckF0HS7IQUMeuD4+mnHpWPhcVBv2ByGFea5pe9VnXDwRBWRn2jrg
         5Ar5CsrcLbnppV9zACFZ/58AQseRAj71p4xN6I8LuXr4+QnO2Eu82TFnSDIZyp7F5r
         uSg+fDxJ3wrxN7K9JAUHvlziv5H6VITX3RXzPXHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0559/1095] phy: samsung: exynosautov9-ufs: correct TSRV register configurations
Date:   Mon, 15 Aug 2022 19:59:18 +0200
Message-Id: <20220815180452.689981782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



