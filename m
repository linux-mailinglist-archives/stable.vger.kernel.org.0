Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33859658272
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbiL1QgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiL1QfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:35:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3D91CFEA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386FE61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45342C433F0;
        Wed, 28 Dec 2022 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245135;
        bh=xfe1geLni/049dd8UW+fHHqgU0vWLX3UsOWTwGo8oBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF1GaIruOQzLb2smjYGTikSiUCjn9maCQnIC3+rGZkXKbIf+3wNOorj8/EOX/V0V6
         U3A5JUDRcYmmzD838ZnMcjVTfowtL/y/0svjwp3bLFLSxum2F2SopsMYw8N82bJbu9
         UCncy6CDePLEZqGcp51kAo+CRwXsGSKAwUpupCAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0803/1146] phy: qcom-qmp-usb: drop sc8280xp power-down delay
Date:   Wed, 28 Dec 2022 15:39:02 +0100
Message-Id: <20221228144351.961357025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 898ab85d6b1e8f6271d180c47ef8a024dea9e357 ]

The SC8280XP PHY does not need a delay before starting the PHY (which is
what the has_pwrdn_delay config option really controls) so drop the
unnecessary delay.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20221012081241.18273-14-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 922adfd59efd ("phy: qcom-qmp-usb: correct registers layout for IPQ8074 USB3 PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 866955a36315..935d271f28a7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1731,10 +1731,6 @@ static const struct qmp_phy_cfg sc8280xp_usb3_uniphy_cfg = {
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
 	.phy_status		= PHYSTATUS,
-
-	.has_pwrdn_delay	= true,
-	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
-	.pwrdn_delay_max	= POWER_DOWN_DELAY_US_MAX,
 };
 
 static const struct qmp_phy_cfg qmp_v3_usb3_uniphy_cfg = {
-- 
2.35.1



