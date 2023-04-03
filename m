Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEF36D4802
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbjDCOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjDCOZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:25:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A298D2C9EC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3988661D41
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBD4C433EF;
        Mon,  3 Apr 2023 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531899;
        bh=v/DrmL6x3dQouPDLvPT1zGKXr7GRxXgJyK/11jyi5xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrPE9RLbszJwRBJ+lU+0LNNXQic6k3cadETKO0MYsRo42kT6LWRq8w1QIGUCwwM9s
         3dU/VEQ3d/jimwOtqdRr5HPo0ahmpufDbxaFnmnncOa7bWxO0XGzPgMw3czWOa9brG
         fVet+dUFJ8ZKHoXsKSGjsKebREH5yKjnS9SrDNY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/173] power: supply: bq24190_charger: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Mon,  3 Apr 2023 16:07:14 +0200
Message-Id: <20230403140414.937400538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit d96a89407e5f682d1cb22569d91784506c784863 ]

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 47c29d692129 ("power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 63 +++++++++-----------------
 1 file changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 8c3c378dce0d5..81389fcc73e14 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -448,11 +448,9 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 	if (!info)
 		return -EINVAL;
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = bq24190_read_mask(bdi, info->reg, info->mask, info->shift, &v);
 	if (ret)
@@ -483,11 +481,9 @@ static ssize_t bq24190_sysfs_store(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = bq24190_write_mask(bdi, info->reg, info->mask, info->shift, v);
 	if (ret)
@@ -506,10 +502,9 @@ static int bq24190_set_charge_mode(struct regulator_dev *dev, u8 val)
 	struct bq24190_dev_info *bdi = rdev_get_drvdata(dev);
 	int ret;
 
-	ret = pm_runtime_get_sync(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
 	if (ret < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", ret);
-		pm_runtime_put_noidle(bdi->dev);
 		return ret;
 	}
 
@@ -539,10 +534,9 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
 	int ret;
 	u8 val;
 
-	ret = pm_runtime_get_sync(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
 	if (ret < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", ret);
-		pm_runtime_put_noidle(bdi->dev);
 		return ret;
 	}
 
@@ -1083,11 +1077,9 @@ static int bq24190_charger_get_property(struct power_supply *psy,
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
@@ -1157,11 +1149,9 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1420,11 +1410,9 @@ static int bq24190_battery_get_property(struct power_supply *psy,
 	dev_warn(bdi->dev, "warning: /sys/class/power_supply/bq24190-battery is deprecated\n");
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -1468,11 +1456,9 @@ static int bq24190_battery_set_property(struct power_supply *psy,
 	dev_warn(bdi->dev, "warning: /sys/class/power_supply/bq24190-battery is deprecated\n");
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1626,10 +1612,9 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 	int error;
 
 	bdi->irq_event = true;
-	error = pm_runtime_get_sync(bdi->dev);
+	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
 		return IRQ_NONE;
 	}
 	bq24190_check_status(bdi);
@@ -1849,11 +1834,9 @@ static int bq24190_remove(struct i2c_client *client)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 	if (bdi->battery)
@@ -1902,11 +1885,9 @@ static __maybe_unused int bq24190_pm_suspend(struct device *dev)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 
@@ -1927,11 +1908,9 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
 	bdi->f_reg = 0;
 	bdi->ss_reg = BQ24190_REG_SS_VBUS_STAT_MASK; /* impossible state */
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 	bq24190_set_config(bdi);
-- 
2.39.2



