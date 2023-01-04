Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4265D314
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjADMvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjADMvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:51:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7191013DE0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 042B56137C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB2CC433D2;
        Wed,  4 Jan 2023 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836693;
        bh=LRPTEUHGqLJTKfdjrHcAtBltmNQVwKCEcFboqJMoP4E=;
        h=Subject:To:Cc:From:Date:From;
        b=P13X8Uzzsk4/xw/pB4scPxWW/t06jwEeCFIRs7HzyMSMmjE5mZ4z08g/h/v1k/uMJ
         uABYhw6P+rqJ6TTcYJeEXI1YHQhoKEIkoeM43jAwuD8J3fztP/Owt3xLIhXt4O6OzS
         8WxgWHIQW8foEeq2U4GsKqwUsVMIhVADPm142xYk=
Subject: FAILED: patch "[PATCH] phy: qcom-qmp-combo: fix out-of-bounds clock access" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, dmitry.baryshkov@linaro.org,
        vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:51:29 +0100
Message-ID: <1672836689136142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d8a5b59c5fc7 ("phy: qcom-qmp-combo: fix out-of-bounds clock access")
712e5dffe911 ("phy: qcom-qmp-combo: Parameterize swing and pre_emphasis tables")
85936d4f3815 ("phy: qcom-qmp: add regulator_set_load to dp phy")
033f3a16fb92 ("phy: qcom-qmp-combo: change symbol prefix to qcom_qmp_phy_combo")
ee7ffc92a950 ("phy: qcom-qmp-combo: drop all non-combo compatibles support")
94a407cc17a4 ("phy: qcom-qmp: create copies of QMP PHY driver")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8a5b59c5fc75c99ba17e3eb1a8f580d8d172b28 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 14 Nov 2022 09:13:41 +0100
Subject: [PATCH] phy: qcom-qmp-combo: fix out-of-bounds clock access

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

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 5e11b6a1d189..bb38b18258ca 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1270,8 +1270,8 @@ static const struct qmp_phy_cfg sm8250_dpphy_cfg = {
 	.swing_hbr3_hbr2	= &qmp_dp_v3_voltage_swing_hbr3_hbr2,
 	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v3_pre_emphasis_hbr3_hbr2,
 
-	.clk_list		= qmp_v4_phy_clk_l,
-	.num_clks		= ARRAY_SIZE(qmp_v4_phy_clk_l),
+	.clk_list		= qmp_v4_sm8250_usbphy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v4_sm8250_usbphy_clk_l),
 	.reset_list		= msm8996_usb3phy_reset_l,
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,

