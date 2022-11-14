Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5103A627737
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 09:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiKNIOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 03:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiKNIOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 03:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C83192A6;
        Mon, 14 Nov 2022 00:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73097B80D3B;
        Mon, 14 Nov 2022 08:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F37C433D6;
        Mon, 14 Nov 2022 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668413669;
        bh=IHFLp839t6wrDbrE/w7CcDSU1XWQfM/BgeoUJmtCdPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODGK87TO4Kb+6AjqtgTWH3OXfyp38/dR17p3O4ntsFWXrjw2Pt6NZZdLLvsKQcnhB
         XskAig3EVczgzeo3Z3JwPsJkEcZhqUivMOgOOPi+ZbY6Nc3qX+UZ+DbEfJx3xFYKI0
         ujOhwweSk+K9BpwItH0ExG5RnkncVuiyD4P65vRjjEJBgDY2BTgUwjmTUJkCKCmBv5
         s4xpp2xFCUhXi47+wU6R1BxnRlcHmrPKo+siGj/CL/x9yyLC6G2esQREdfPSjN6iSB
         un2nd5IHjfZWNRdEP14GRiITvTYbtazw0LmQnWEZT4tYwu3g37mQm4LDhuFeefXqXg
         2PRKcZIEgeIgA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1ouUbM-0001L2-RJ; Mon, 14 Nov 2022 09:13:56 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 3/6] phy: qcom-qmp-combo: fix sc8180x reset
Date:   Mon, 14 Nov 2022 09:13:43 +0100
Message-Id: <20221114081346.5116-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221114081346.5116-1-johan+linaro@kernel.org>
References: <20221114081346.5116-1-johan+linaro@kernel.org>
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
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
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

