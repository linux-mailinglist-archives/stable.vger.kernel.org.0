Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7865832C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiL1Qov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiL1QgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D5112754
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D81DEB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39DDC433EF;
        Wed, 28 Dec 2022 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245159;
        bh=Xja0qEQ0ZQr1rBpWA+DH8ZeKLJiDkHDrQFrXuQz03ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPkOAH5fWlXKXRetlrSO3Q0ROQ7OVdIZGs/+A4mjqCkt3tIzNUgr5EObReso0QMgl
         lHoPskq0hHx/PfVmR9Msz4CYclTK99U8tGuj7cxg+BkXX5bhB56mOZaOFj57y0SMaF
         ynCj12rpLrED7IEVGnJeqazSx0jGXrWKwmrP2vNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Kathiravan T <quic_kathirav@quicinc.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0807/1146] phy: qcom-qmp-usb: correct registers layout for IPQ8074 USB3 PHY
Date:   Wed, 28 Dec 2022 15:39:06 +0100
Message-Id: <20221228144352.072687359@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 922adfd59efd337059f8445a8d8968552b06ed4e ]

According to the kernel 4.4 sources from NHSS.QSDK.9.0.2 and according
to hardware docs, the PHY registers layout used for IPQ8074 USB3 PHY is
incorrect. This platform uses offset 0x174 for the PCS_STATUS register,
0xd8 for PCS_AUTONOMOUS_MODE_CTRL, etc.

Correct the PHY registers layout.

Fixes: 94a407cc17a4 ("phy: qcom-qmp: create copies of QMP PHY driver")
Fixes: 507156f5a99f ("phy: qcom-qmp: Add USB QMP PHY support for IPQ8074")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Kathiravan T<quic_kathirav@quicinc.com>
Link: https://lore.kernel.org/r/20220929190017.529207-1-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 868511bbefcb..4960ebe674ec 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1608,7 +1608,7 @@ static const struct qmp_phy_cfg ipq8074_usb3phy_cfg = {
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
-	.regs			= usb3phy_regs_layout,
+	.regs			= qmp_v3_usb3phy_regs_layout,
 };
 
 static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
-- 
2.35.1



