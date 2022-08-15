Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C789594531
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244729AbiHOWUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350791AbiHOWSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9471419AC;
        Mon, 15 Aug 2022 12:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F2A8B80EB2;
        Mon, 15 Aug 2022 19:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D193C433D7;
        Mon, 15 Aug 2022 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592504;
        bh=dXkowuWnXR/whURw9FmRM5OATjvkSl4KRBfeUx9ZHbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyd4fdcQGPdcMs1xeOqSf7VOkWEuwia6cOdjgqi+nsc7YT7jMYHpgHNwz2iPjSzB2
         NuL9DsAdRpXFT0sYsaSFNUnYU6ZsiSQ1YNyKZpOcqojx8+7JnQkeql0Zf5IF/+9rqP
         3xawNA+Wg2JmPNS9vXaUCSetNStOnYbGGgv/aW4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0800/1095] platform/mellanox: mlxreg-lc: Fix error flow and extend verbosity
Date:   Mon, 15 Aug 2022 20:03:19 +0200
Message-Id: <20220815180502.348251593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit b4b830a34d8046633231b7fe87f6f2cb6240dc9f ]

Fix error flow:
- Clean-up client object in case of probing failure.
- Prevent running remove routine in case of probing failure.
  Probing and removing are invoked by hotplug events raised upon line
  card insertion and removing. If probing procedure failed all data is
  cleared and there is nothing to do in remove routine.

Fixes: 62f9529b8d5c ("platform/mellanox: mlxreg-lc: Add initial support for Nvidia line card devices")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20220719153540.61304-1-vadimp@nvidia.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxreg-lc.c | 82 ++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/mellanox/mlxreg-lc.c b/drivers/platform/mellanox/mlxreg-lc.c
index c897a2f15840..55834ccb4ac7 100644
--- a/drivers/platform/mellanox/mlxreg-lc.c
+++ b/drivers/platform/mellanox/mlxreg-lc.c
@@ -716,8 +716,12 @@ mlxreg_lc_config_init(struct mlxreg_lc *mlxreg_lc, void *regmap,
 	switch (regval) {
 	case MLXREG_LC_SN4800_C16:
 		err = mlxreg_lc_sn4800_c16_config_init(mlxreg_lc, regmap, data);
-		if (err)
+		if (err) {
+			dev_err(dev, "Failed to config client %s at bus %d at addr 0x%02x\n",
+				data->hpdev.brdinfo->type, data->hpdev.nr,
+				data->hpdev.brdinfo->addr);
 			return err;
+		}
 		break;
 	default:
 		return -ENODEV;
@@ -730,8 +734,11 @@ mlxreg_lc_config_init(struct mlxreg_lc *mlxreg_lc, void *regmap,
 	mlxreg_lc->mux = platform_device_register_resndata(dev, "i2c-mux-mlxcpld", data->hpdev.nr,
 							   NULL, 0, mlxreg_lc->mux_data,
 							   sizeof(*mlxreg_lc->mux_data));
-	if (IS_ERR(mlxreg_lc->mux))
+	if (IS_ERR(mlxreg_lc->mux)) {
+		dev_err(dev, "Failed to create mux infra for client %s at bus %d at addr 0x%02x\n",
+			data->hpdev.brdinfo->type, data->hpdev.nr, data->hpdev.brdinfo->addr);
 		return PTR_ERR(mlxreg_lc->mux);
+	}
 
 	/* Register IO access driver. */
 	if (mlxreg_lc->io_data) {
@@ -740,6 +747,9 @@ mlxreg_lc_config_init(struct mlxreg_lc *mlxreg_lc, void *regmap,
 		platform_device_register_resndata(dev, "mlxreg-io", data->hpdev.nr, NULL, 0,
 						  mlxreg_lc->io_data, sizeof(*mlxreg_lc->io_data));
 		if (IS_ERR(mlxreg_lc->io_regs)) {
+			dev_err(dev, "Failed to create regio for client %s at bus %d at addr 0x%02x\n",
+				data->hpdev.brdinfo->type, data->hpdev.nr,
+				data->hpdev.brdinfo->addr);
 			err = PTR_ERR(mlxreg_lc->io_regs);
 			goto fail_register_io;
 		}
@@ -753,6 +763,9 @@ mlxreg_lc_config_init(struct mlxreg_lc *mlxreg_lc, void *regmap,
 						  mlxreg_lc->led_data,
 						  sizeof(*mlxreg_lc->led_data));
 		if (IS_ERR(mlxreg_lc->led)) {
+			dev_err(dev, "Failed to create LED objects for client %s at bus %d at addr 0x%02x\n",
+				data->hpdev.brdinfo->type, data->hpdev.nr,
+				data->hpdev.brdinfo->addr);
 			err = PTR_ERR(mlxreg_lc->led);
 			goto fail_register_led;
 		}
@@ -809,7 +822,8 @@ static int mlxreg_lc_probe(struct platform_device *pdev)
 	if (!data->hpdev.adapter) {
 		dev_err(&pdev->dev, "Failed to get adapter for bus %d\n",
 			data->hpdev.nr);
-		return -EFAULT;
+		err = -EFAULT;
+		goto i2c_get_adapter_fail;
 	}
 
 	/* Create device at the top of line card I2C tree.*/
@@ -818,32 +832,40 @@ static int mlxreg_lc_probe(struct platform_device *pdev)
 	if (IS_ERR(data->hpdev.client)) {
 		dev_err(&pdev->dev, "Failed to create client %s at bus %d at addr 0x%02x\n",
 			data->hpdev.brdinfo->type, data->hpdev.nr, data->hpdev.brdinfo->addr);
-
-		i2c_put_adapter(data->hpdev.adapter);
-		data->hpdev.adapter = NULL;
-		return PTR_ERR(data->hpdev.client);
+		err = PTR_ERR(data->hpdev.client);
+		goto i2c_new_device_fail;
 	}
 
 	regmap = devm_regmap_init_i2c(data->hpdev.client,
 				      &mlxreg_lc_regmap_conf);
 	if (IS_ERR(regmap)) {
+		dev_err(&pdev->dev, "Failed to create regmap for client %s at bus %d at addr 0x%02x\n",
+			data->hpdev.brdinfo->type, data->hpdev.nr, data->hpdev.brdinfo->addr);
 		err = PTR_ERR(regmap);
-		goto mlxreg_lc_probe_fail;
+		goto devm_regmap_init_i2c_fail;
 	}
 
 	/* Set default registers. */
 	for (i = 0; i < mlxreg_lc_regmap_conf.num_reg_defaults; i++) {
 		err = regmap_write(regmap, mlxreg_lc_regmap_default[i].reg,
 				   mlxreg_lc_regmap_default[i].def);
-		if (err)
-			goto mlxreg_lc_probe_fail;
+		if (err) {
+			dev_err(&pdev->dev, "Failed to set default regmap %d for client %s at bus %d at addr 0x%02x\n",
+				i, data->hpdev.brdinfo->type, data->hpdev.nr,
+				data->hpdev.brdinfo->addr);
+			goto regmap_write_fail;
+		}
 	}
 
 	/* Sync registers with hardware. */
 	regcache_mark_dirty(regmap);
 	err = regcache_sync(regmap);
-	if (err)
-		goto mlxreg_lc_probe_fail;
+	if (err) {
+		dev_err(&pdev->dev, "Failed to sync regmap for client %s at bus %d at addr 0x%02x\n",
+			data->hpdev.brdinfo->type, data->hpdev.nr, data->hpdev.brdinfo->addr);
+		err = PTR_ERR(regmap);
+		goto regcache_sync_fail;
+	}
 
 	par_pdata = data->hpdev.brdinfo->platform_data;
 	mlxreg_lc->par_regmap = par_pdata->regmap;
@@ -854,12 +876,27 @@ static int mlxreg_lc_probe(struct platform_device *pdev)
 	/* Configure line card. */
 	err = mlxreg_lc_config_init(mlxreg_lc, regmap, data);
 	if (err)
-		goto mlxreg_lc_probe_fail;
+		goto mlxreg_lc_config_init_fail;
 
 	return err;
 
-mlxreg_lc_probe_fail:
+mlxreg_lc_config_init_fail:
+regcache_sync_fail:
+regmap_write_fail:
+devm_regmap_init_i2c_fail:
+	if (data->hpdev.client) {
+		i2c_unregister_device(data->hpdev.client);
+		data->hpdev.client = NULL;
+	}
+i2c_new_device_fail:
 	i2c_put_adapter(data->hpdev.adapter);
+	data->hpdev.adapter = NULL;
+i2c_get_adapter_fail:
+	/* Clear event notification callback and handle. */
+	if (data->notifier) {
+		data->notifier->user_handler = NULL;
+		data->notifier->handle = NULL;
+	}
 	return err;
 }
 
@@ -868,11 +905,18 @@ static int mlxreg_lc_remove(struct platform_device *pdev)
 	struct mlxreg_core_data *data = dev_get_platdata(&pdev->dev);
 	struct mlxreg_lc *mlxreg_lc = platform_get_drvdata(pdev);
 
-	/* Clear event notification callback. */
-	if (data->notifier) {
-		data->notifier->user_handler = NULL;
-		data->notifier->handle = NULL;
-	}
+	/*
+	 * Probing and removing are invoked by hotplug events raised upon line card insertion and
+	 * removing. If probing procedure fails all data is cleared. However, hotplug event still
+	 * will be raised on line card removing and activate removing procedure. In this case there
+	 * is nothing to remove.
+	 */
+	if (!data->notifier || !data->notifier->handle)
+		return 0;
+
+	/* Clear event notification callback and handle. */
+	data->notifier->user_handler = NULL;
+	data->notifier->handle = NULL;
 
 	/* Destroy static I2C device feeding by main power. */
 	mlxreg_lc_destroy_static_devices(mlxreg_lc, mlxreg_lc->main_devs,
-- 
2.35.1



