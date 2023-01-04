Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B4665D959
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbjADQYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbjADQXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:23:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2015A43182
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA92B817C0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8FAC433D2;
        Wed,  4 Jan 2023 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849392;
        bh=z7uL9DTf585EcbdQXVyGyKM4hygBj4AtyPNiipQSnL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubZWkvzfexinIPd0SmUKEsjEgjyVWfiTWtt2bvlnDSs2DrI69T+IapPcWp++rhF49
         WFa4TBFx6B85YOqecpnnN0mYkZxiy4MwwIuEGC8sIOJYn6p1nGM/i5oR5C1/BlrmQw
         0wFhbZYMRUl+1np8oxhqOhxFvVT744uiTUYZoyoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 113/177] phy: qcom-qmp-combo: fix sc8180x reset
Date:   Wed,  4 Jan 2023 17:06:44 +0100
Message-Id: <20230104160511.067587962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit 910dd4883d757af5faac92590f33f0f7da963032 upstream.

The SC8180X has two resets but the DP configuration erroneously
described only one.

In case the DP part of the PHY is initialised before the USB part (e.g.
depending on probe order), then only the first reset would be asserted.

Fixes: 1633802cd4ac ("phy: qcom: qmp: Add SC8180x USB/DP combo")
Cc: stable@vger.kernel.org	# 5.15
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-4-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -959,8 +959,8 @@ static const struct qmp_phy_cfg sc8180x_
 
 	.clk_list		= qmp_v3_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
-	.reset_list		= sc7180_usb3phy_reset_l,
-	.num_resets		= ARRAY_SIZE(sc7180_usb3phy_reset_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
 	.regs			= qmp_v3_usb3phy_regs_layout,


