Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E46583A7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiL1Qtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiL1QtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:49:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A8C1C901
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFB6AB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30938C433EF;
        Wed, 28 Dec 2022 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245882;
        bh=VIJ2QCNwUHQPVJxK9Tx2yGHdTM2Tp3MXY2m/G2fhz08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDA5Tv4b+BKYdhPk/WN6VvNbrnLh/paCew51GUCs0HCkupitpt9/SquBOzc4RGHBo
         FryRuLrEJTQsReO0z4K3kxF1/7V0PfqppVCQ5LmHiIdXRnApSTlKojd4Fyeyr2ugDo
         5v3WnVaX/P2BbwiSahtqPLOmNVM0t/GcuxiVQPp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0974/1073] regulator: core: Use different devices for resource allocation and DT lookup
Date:   Wed, 28 Dec 2022 15:42:42 +0100
Message-Id: <20221228144354.525391672@linuxfoundation.org>
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

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 8f3cbcd6b440032ebc7f7d48a1689dcc70a4eb98 ]

Following by the below discussion, there's the potential UAF issue
between regulator and mfd.
https://lore.kernel.org/all/20221128143601.1698148-1-yangyingliang@huawei.com/

>From the analysis of Yingliang

CPU A				|CPU B
mt6370_probe()			|
  devm_mfd_add_devices()	|
				|mt6370_regulator_probe()
				|  regulator_register()
				|    //allocate init_data and add it to devres
				|    regulator_of_get_init_data()
i2c_unregister_device()		|
  device_del()			|
    devres_release_all()	|
      // init_data is freed	|
      release_nodes()		|
				|  // using init_data causes UAF
				|  regulator_register()

It's common to use mfd core to create child device for the regulator.
In order to do the DT lookup for init data, the child that registered
the regulator would pass its parent as the parameter. And this causes
init data resource allocated to its parent, not itself. The issue happen
when parent device is going to release and regulator core is still doing
some operation of init data constraint for the regulator of child device.

To fix it, this patch expand 'regulator_register' API to use the
different devices for init data allocation and DT lookup.

Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1670311341-32664-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/clk_and_regulator.c | 3 ++-
 drivers/regulator/core.c                               | 8 ++++----
 drivers/regulator/devres.c                             | 2 +-
 drivers/regulator/of_regulator.c                       | 2 +-
 drivers/regulator/stm32-vrefbuf.c                      | 2 +-
 include/linux/regulator/driver.h                       | 3 ++-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
index 1cf958983e86..b2342b3d78c7 100644
--- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -185,7 +185,8 @@ int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
 	cfg.init_data = &init_data;
 	cfg.ena_gpiod = int3472->regulator.gpio;
 
-	int3472->regulator.rdev = regulator_register(&int3472->regulator.rdesc,
+	int3472->regulator.rdev = regulator_register(int3472->dev,
+						     &int3472->regulator.rdesc,
 						     &cfg);
 	if (IS_ERR(int3472->regulator.rdev)) {
 		ret = PTR_ERR(int3472->regulator.rdev);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1c1710d367d3..c095ca9f01e8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5388,6 +5388,7 @@ static struct regulator_coupler generic_regulator_coupler = {
 
 /**
  * regulator_register - register regulator
+ * @dev: the device that drive the regulator
  * @regulator_desc: regulator to register
  * @cfg: runtime configuration for regulator
  *
@@ -5396,7 +5397,8 @@ static struct regulator_coupler generic_regulator_coupler = {
  * or an ERR_PTR() on error.
  */
 struct regulator_dev *
-regulator_register(const struct regulator_desc *regulator_desc,
+regulator_register(struct device *dev,
+		   const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *cfg)
 {
 	const struct regulator_init_data *init_data;
@@ -5405,7 +5407,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct regulator_dev *rdev;
 	bool dangling_cfg_gpiod = false;
 	bool dangling_of_gpiod = false;
-	struct device *dev;
 	int ret, i;
 
 	if (cfg == NULL)
@@ -5417,8 +5418,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		goto rinse;
 	}
 
-	dev = cfg->dev;
-	WARN_ON(!dev);
+	WARN_ON(!dev || !cfg->dev);
 
 	if (regulator_desc->name == NULL || regulator_desc->ops == NULL) {
 		ret = -EINVAL;
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 32823a87fd40..d94db64cd490 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -221,7 +221,7 @@ struct regulator_dev *devm_regulator_register(struct device *dev,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	rdev = regulator_register(regulator_desc, config);
+	rdev = regulator_register(dev, regulator_desc, config);
 	if (!IS_ERR(rdev)) {
 		*ptr = rdev;
 		devres_add(dev, ptr);
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index e12b681c72e5..bd0c5d1fd647 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -505,7 +505,7 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 	struct device_node *child;
 	struct regulator_init_data *init_data = NULL;
 
-	child = regulator_of_get_init_node(dev, desc);
+	child = regulator_of_get_init_node(config->dev, desc);
 	if (!child)
 		return NULL;
 
diff --git a/drivers/regulator/stm32-vrefbuf.c b/drivers/regulator/stm32-vrefbuf.c
index 30ea3bc8ca19..7a454b7b6eab 100644
--- a/drivers/regulator/stm32-vrefbuf.c
+++ b/drivers/regulator/stm32-vrefbuf.c
@@ -210,7 +210,7 @@ static int stm32_vrefbuf_probe(struct platform_device *pdev)
 						      pdev->dev.of_node,
 						      &stm32_vrefbuf_regu);
 
-	rdev = regulator_register(&stm32_vrefbuf_regu, &config);
+	rdev = regulator_register(&pdev->dev, &stm32_vrefbuf_regu, &config);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "register failed with error %d\n", ret);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index f9a7461e72b8..d3b4a3d4514a 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -687,7 +687,8 @@ static inline int regulator_err2notif(int err)
 
 
 struct regulator_dev *
-regulator_register(const struct regulator_desc *regulator_desc,
+regulator_register(struct device *dev,
+		   const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *config);
 struct regulator_dev *
 devm_regulator_register(struct device *dev,
-- 
2.35.1



