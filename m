Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1C657BE4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiL1P0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiL1P01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B45FF5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72FEBB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C7C433D2;
        Wed, 28 Dec 2022 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241183;
        bh=8L2PcGEli8Hm1CSaPBM8Gp1Z/5rQDUi3GMj5KUVG/CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/aOovpwSfiWPbDkzf1LFkTW+9+AIocvDRW57i0cVQDkVSN79v2r/ePj8twFGPjLU
         6JKTjuFhq2bVqN7+ira0tVJ+UylsEITRnvZVPki8ULDSARho5KMDQvPlLrwFskvg10
         plCDGs7Gxbtd7BZWpD9lTSTKDjoONRbDPqw536g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0216/1146] pinctrl: ocelot: add missing destroy_workqueue() in error path in ocelot_pinctrl_probe()
Date:   Wed, 28 Dec 2022 15:29:15 +0100
Message-Id: <20221228144336.013490722@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8ada020ade3bc4125b639a1dca50a6df687dd986 ]

Using devm_add_action_or_reset() to make workqueue device-managed, so it can be
destroy whenever the driver is unbound.

Fixes: c297561bc98a ("pinctrl: ocelot: Fix interrupt controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220925021258.1492905-1-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 687aaa601555..3d5995cbcb78 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -2047,6 +2047,11 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev,
 	return devm_regmap_init_mmio(&pdev->dev, base, &regmap_config);
 }
 
+static void ocelot_destroy_workqueue(void *data)
+{
+	destroy_workqueue(data);
+}
+
 static int ocelot_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct ocelot_match_data *data;
@@ -2078,6 +2083,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	if (!info->wq)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(dev, ocelot_destroy_workqueue,
+				       info->wq);
+	if (ret)
+		return ret;
+
 	info->pincfg_data = &data->pincfg_data;
 
 	reset = devm_reset_control_get_optional_shared(dev, "switch");
@@ -2119,15 +2129,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ocelot_pinctrl_remove(struct platform_device *pdev)
-{
-	struct ocelot_pinctrl *info = platform_get_drvdata(pdev);
-
-	destroy_workqueue(info->wq);
-
-	return 0;
-}
-
 static struct platform_driver ocelot_pinctrl_driver = {
 	.driver = {
 		.name = "pinctrl-ocelot",
@@ -2135,7 +2136,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 		.suppress_bind_attrs = true,
 	},
 	.probe = ocelot_pinctrl_probe,
-	.remove = ocelot_pinctrl_remove,
 };
 module_platform_driver(ocelot_pinctrl_driver);
 
-- 
2.35.1



