Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27B1657B67
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiL1PVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiL1PVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:21:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4D11401A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA3861365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D817C433EF;
        Wed, 28 Dec 2022 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240868;
        bh=5peiNrkNBsv7bGcjt+t4q1vyW4NQxyc82pxlXUkEXnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9Ux3iuDmc0kW9MyCXFvOq0K2NZ/iHBVQQqqkjyJv92elSiSnQWX/6uEpk+MoxS0D
         eu+nRq8Z7pUJbakuYzbGrHBKEcIrotjqlHtXywLt+uQXi7B/Tk6jBi4AFKCwhcrSOL
         iul0DwOQuHvT6zdzR+KS0sXgg/pfk7JK6fce3KOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0212/1073] pinctrl: ocelot: add missing destroy_workqueue() in error path in ocelot_pinctrl_probe()
Date:   Wed, 28 Dec 2022 15:30:00 +0100
Message-Id: <20221228144333.776339305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 105771ff82e6..19a61f697e99 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -2046,6 +2046,11 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev,
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
@@ -2125,15 +2135,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
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
@@ -2141,7 +2142,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 		.suppress_bind_attrs = true,
 	},
 	.probe = ocelot_pinctrl_probe,
-	.remove = ocelot_pinctrl_remove,
 };
 module_platform_driver(ocelot_pinctrl_driver);
 MODULE_LICENSE("Dual MIT/GPL");
-- 
2.35.1



