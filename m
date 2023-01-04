Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3565D7F6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbjADQJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbjADQJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C823D9D7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2473B816BF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BD9C433EF;
        Wed,  4 Jan 2023 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848542;
        bh=T0R1tkypPpZwwD6lBgJwAM85AyfeaPihKptbd30BaVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcHVpWLuzx1OHabn5V1oXnQSvGvSTR0gHkUYvlSvm3AU5XJ43zJyanJ43Y+qgZgws
         ycSHq5NyQHl0Um/JTKwFJ2D0FA3k1xrkri4Liyi0WZkMrMG7zEFlsEyLIHj/Uuvebm
         l4lpFVylUaOFyvz9/Ub1o2SQA9HE+ubWcZra8g40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 017/207] phy: qcom-qmp-combo: fix out-of-bounds clock access
Date:   Wed,  4 Jan 2023 17:04:35 +0100
Message-Id: <20230104160512.455767851@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit d8a5b59c5fc75c99ba17e3eb1a8f580d8d172b28 upstream.

The SM8250 only uses three clocks but the DP configuration erroneously
described four clocks.

In case the DP part of the PHY is initialised before the USB part, this
would lead to uninitialised memory beyond the bulk-clocks array to be
treated as a clock pointer as the clocks are requested based on the USB
configuration.

Fixes: aff188feb5e1 ("phy: qcom-qmp: add support for sm8250-usb3-dp phy")
Cc: stable@vger.kernel.org	# 5.13
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1328,8 +1328,8 @@ static const struct qmp_phy_cfg sm8250_d
 	.swing_hbr3_hbr2	= &qmp_dp_v3_voltage_swing_hbr3_hbr2,
 	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v3_pre_emphasis_hbr3_hbr2,
 
-	.clk_list		= qmp_v4_phy_clk_l,
-	.num_clks		= ARRAY_SIZE(qmp_v4_phy_clk_l),
+	.clk_list		= qmp_v4_sm8250_usbphy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v4_sm8250_usbphy_clk_l),
 	.reset_list		= msm8996_usb3phy_reset_l,
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,


