Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0225658265
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbiL1Qfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiL1Qeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:34:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649581C101
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1B19B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BCEC433EF;
        Wed, 28 Dec 2022 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245127;
        bh=c1p2GGnfiBQv48CjHps/2/8lXoGXcBXw1/YdZC0f7IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiOmhBRUHnBvtqn/vQen01a4tftkKlFLJzsWqdSdu3rGUaYjgPCL45JnLICWCZQ01
         SZ7Rygtb/mFARLoTPxkNatvq5iCMW4vC7Jzr4D6d3kmbwY4Qu/WLfGDZuutkfZYag9
         A/jF2/jO8Wj8XeogsESwILV9pdmav0lafVs7XIBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0801/1146] phy: qcom-qmp-pcie: fix ipq6018 initialisation
Date:   Wed, 28 Dec 2022 15:39:00 +0100
Message-Id: <20221228144351.906623950@linuxfoundation.org>
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

[ Upstream commit 30518b19895789aa9101474af2ee0f62cd882d5e ]

The phy_status mask was never set for IPQ6018 which meant that the
driver would not wait for the PHY to be initialised during power-on and
would never detect PHY initialisation timeouts.

Fixes: 520264db3bf9 ("phy: qcom-qmp: add QMP V2 PCIe PHY support for ipq60xx")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20221012085002.24099-3-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 842ddc3e0a1c..6c6c4b7b6b25 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1525,6 +1525,7 @@ static const struct qmp_phy_cfg ipq6018_pciephy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.phy_status		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg sdm845_qmp_pciephy_cfg = {
-- 
2.35.1



