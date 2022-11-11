Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562AB625594
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiKKIo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiKKIoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:44:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09197748EC;
        Fri, 11 Nov 2022 00:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E5561EF6;
        Fri, 11 Nov 2022 08:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9163C43470;
        Fri, 11 Nov 2022 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668156293;
        bh=w13zs6FKj0SdIEJZ1oD2GuvAHcCJq00Kw69kuCxONBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idK/EQQBCwNV4wB58B/l10bmWyvHS9yGNUlpzFrwtEpBJGEPdvCL/84dB7jSl1kDM
         OihJsY+hpaUwzKI4nRXJ5owiDvoC5FTeQb3RfJ6TIn3tXZpZ1uGoUeYC4nCgBVEghN
         o3GTpM3ClR7li8cwqUhQdA8V9F+4QCOy7ibFaSMPfHloso3z+JnPL/O56SnSxWNBwv
         +kpuhQEMK/rBdMqyd8kPXG4kTgaoR/cZHkGP1+GPBhz3HUIQHPW03auv6bsP8YopVK
         q+Kr9NSeof7uABfUum+jmrd5q96rQFhJH4KxUg3xVV9xm1GV/RCBe7/3BsLrD4tkjK
         C10775VzrrHWg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1otPeD-0002Mk-Ox; Fri, 11 Nov 2022 09:44:25 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/6] phy: qcom-qmp-combo: fix sc8180x reset
Date:   Fri, 11 Nov 2022 09:42:52 +0100
Message-Id: <20221111084255.8963-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221111084255.8963-1-johan+linaro@kernel.org>
References: <20221111084255.8963-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SC8180X has two resets but the DP configuration erroneously
described only one.

In case the DP part of the PHY is initialised before the USB part (e.g.
depending on probe order), then only the first reset would be asserted.

Fixes: 1633802cd4ac ("phy: qcom: qmp: Add SC8180x USB/DP combo")
Cc: stable@vger.kernel.org	# 5.15
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index cc53e2f99121..40c25a0ead23 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1177,8 +1177,8 @@ static const struct qmp_phy_cfg sc8180x_dpphy_cfg = {
 
 	.clk_list		= qmp_v3_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
-	.reset_list		= sc7180_usb3phy_reset_l,
-	.num_resets		= ARRAY_SIZE(sc7180_usb3phy_reset_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
 	.regs			= qmp_v3_usb3phy_regs_layout,
-- 
2.37.4

