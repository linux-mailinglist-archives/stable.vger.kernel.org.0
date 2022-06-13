Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4552D548FF4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351649AbiFMLJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352083AbiFMLJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCFD33E32;
        Mon, 13 Jun 2022 03:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70AEB60F9A;
        Mon, 13 Jun 2022 10:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85632C34114;
        Mon, 13 Jun 2022 10:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116516;
        bh=EoOtVIPnZtBAk5PHnk/EdTVPGj9ymbTn6H6YTfuhnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ou7X/oUSWBywbw75uuTXKGa6RZFCfV046Z7MIlAOUddLdO7epX7NMCYAL35LeVdH
         Le/MOMorYybK1SklpZ46F5yLUO2dQiqMP6zbA+EX4fNUlE8HRgx2P13SEsXkqu/n9k
         UX/oPgXQkBIcRyJ0Rztb444iEE0dvY1S70cpMcyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/411] drm/bridge: Fix error handling in analogix_dp_probe
Date:   Mon, 13 Jun 2022 12:06:13 +0200
Message-Id: <20220613094931.678424952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9f15930bb2ef9f031d62ffc49629cbae89137733 ]

In the error handling path, the clk_prepare_enable() function
call should be balanced by a corresponding 'clk_disable_unprepare()'
call, as already done in the remove function.

Fixes: 3424e3a4f844 ("drm: bridge: analogix/dp: split exynos dp driver to bridge directory")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220420011644.25730-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/bridge/analogix/analogix_dp_core.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 1f26890a8da6..3db0a631a6be 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1696,8 +1696,10 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	dp->reg_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dp->reg_base))
-		return ERR_CAST(dp->reg_base);
+	if (IS_ERR(dp->reg_base)) {
+		ret = PTR_ERR(dp->reg_base);
+		goto err_disable_clk;
+	}
 
 	dp->force_hpd = of_property_read_bool(dev->of_node, "force-hpd");
 
@@ -1709,7 +1711,8 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 	if (IS_ERR(dp->hpd_gpiod)) {
 		dev_err(dev, "error getting HDP GPIO: %ld\n",
 			PTR_ERR(dp->hpd_gpiod));
-		return ERR_CAST(dp->hpd_gpiod);
+		ret = PTR_ERR(dp->hpd_gpiod);
+		goto err_disable_clk;
 	}
 
 	if (dp->hpd_gpiod) {
@@ -1729,7 +1732,8 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 
 	if (dp->irq == -ENXIO) {
 		dev_err(&pdev->dev, "failed to get irq\n");
-		return ERR_PTR(-ENODEV);
+		ret = -ENODEV;
+		goto err_disable_clk;
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, dp->irq,
@@ -1738,11 +1742,15 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 					irq_flags, "analogix-dp", dp);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		return ERR_PTR(ret);
+		goto err_disable_clk;
 	}
 	disable_irq(dp->irq);
 
 	return dp;
+
+err_disable_clk:
+	clk_disable_unprepare(dp->clock);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(analogix_dp_probe);
 
-- 
2.35.1



