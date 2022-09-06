Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686225AEC9B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbiIFOFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiIFOEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F8252AD;
        Tue,  6 Sep 2022 06:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BF8EB818C0;
        Tue,  6 Sep 2022 13:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E201AC433D6;
        Tue,  6 Sep 2022 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471836;
        bh=BaZCLaoVmJWIPg4+A2ic5F4/q/MaPqyecEILBXQKRFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqPhfPqYF2ktUMFIFCLJ6EX8wEIsnne8Cuj5vFJ6Kv3RLnZPpAEQKoB6P29r2dkpQ
         Cbbk+yMK484oLkibmd/Mmv60U+dleJGVLJ7X0+/LayB2rLsikyZ0KU/EFbDcR/Q13o
         /D+INRI23Ol0NeK6/k4eoa4DmxzBtZ2h5bo898dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 055/155] platform/mellanox: mlxreg-lc: Fix locking issue
Date:   Tue,  6 Sep 2022 15:30:03 +0200
Message-Id: <20220906132831.744423991@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

[ Upstream commit 1e092b7faa6b507125b69c92a51bb22c2d549d37 ]

Fix locking issues:
- mlxreg_lc_state_update() takes a lock when set or clear
  "MLXREG_LC_POWERED".
- All the devices can be deleted before MLXREG_LC_POWERED flag is cleared.

To fix it:
- Add lock() / unlock() at the beginning / end of
  mlxreg_lc_event_handler() and remove locking from
  mlxreg_lc_power_on_off() and mlxreg_lc_enable_disable()
- Add locked version of mlxreg_lc_state_update() -
  mlxreg_lc_state_update_locked() for using outside
  mlxreg_lc_event_handler().

(2) Remove redundant NULL check for of if 'data->notifier'.

Fixes: 62f9529b8d5c87b ("platform/mellanox: mlxreg-lc: Add initial support for Nvidia line card devices")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20220823201937.46855-3-vadimp@nvidia.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxreg-lc.c | 37 ++++++++++++++++++---------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/mellanox/mlxreg-lc.c b/drivers/platform/mellanox/mlxreg-lc.c
index 9a1bfcd24317d..e578c7bc060bb 100644
--- a/drivers/platform/mellanox/mlxreg-lc.c
+++ b/drivers/platform/mellanox/mlxreg-lc.c
@@ -460,8 +460,6 @@ static int mlxreg_lc_power_on_off(struct mlxreg_lc *mlxreg_lc, u8 action)
 	u32 regval;
 	int err;
 
-	mutex_lock(&mlxreg_lc->lock);
-
 	err = regmap_read(mlxreg_lc->par_regmap, mlxreg_lc->data->reg_pwr, &regval);
 	if (err)
 		goto regmap_read_fail;
@@ -474,7 +472,6 @@ static int mlxreg_lc_power_on_off(struct mlxreg_lc *mlxreg_lc, u8 action)
 	err = regmap_write(mlxreg_lc->par_regmap, mlxreg_lc->data->reg_pwr, regval);
 
 regmap_read_fail:
-	mutex_unlock(&mlxreg_lc->lock);
 	return err;
 }
 
@@ -491,8 +488,6 @@ static int mlxreg_lc_enable_disable(struct mlxreg_lc *mlxreg_lc, bool action)
 	 * line card which is already has been enabled. Disabling does not affect the disabled line
 	 * card.
 	 */
-	mutex_lock(&mlxreg_lc->lock);
-
 	err = regmap_read(mlxreg_lc->par_regmap, mlxreg_lc->data->reg_ena, &regval);
 	if (err)
 		goto regmap_read_fail;
@@ -505,7 +500,6 @@ static int mlxreg_lc_enable_disable(struct mlxreg_lc *mlxreg_lc, bool action)
 	err = regmap_write(mlxreg_lc->par_regmap, mlxreg_lc->data->reg_ena, regval);
 
 regmap_read_fail:
-	mutex_unlock(&mlxreg_lc->lock);
 	return err;
 }
 
@@ -537,6 +531,15 @@ mlxreg_lc_sn4800_c16_config_init(struct mlxreg_lc *mlxreg_lc, void *regmap,
 
 static void
 mlxreg_lc_state_update(struct mlxreg_lc *mlxreg_lc, enum mlxreg_lc_state state, u8 action)
+{
+	if (action)
+		mlxreg_lc->state |= state;
+	else
+		mlxreg_lc->state &= ~state;
+}
+
+static void
+mlxreg_lc_state_update_locked(struct mlxreg_lc *mlxreg_lc, enum mlxreg_lc_state state, u8 action)
 {
 	mutex_lock(&mlxreg_lc->lock);
 
@@ -560,8 +563,11 @@ static int mlxreg_lc_event_handler(void *handle, enum mlxreg_hotplug_kind kind,
 	dev_info(mlxreg_lc->dev, "linecard#%d state %d event kind %d action %d\n",
 		 mlxreg_lc->data->slot, mlxreg_lc->state, kind, action);
 
-	if (!(mlxreg_lc->state & MLXREG_LC_INITIALIZED))
+	mutex_lock(&mlxreg_lc->lock);
+	if (!(mlxreg_lc->state & MLXREG_LC_INITIALIZED)) {
+		mutex_unlock(&mlxreg_lc->lock);
 		return 0;
+	}
 
 	switch (kind) {
 	case MLXREG_HOTPLUG_LC_SYNCED:
@@ -574,7 +580,7 @@ static int mlxreg_lc_event_handler(void *handle, enum mlxreg_hotplug_kind kind,
 		if (!(mlxreg_lc->state & MLXREG_LC_POWERED) && action) {
 			err = mlxreg_lc_power_on_off(mlxreg_lc, 1);
 			if (err)
-				return err;
+				goto mlxreg_lc_power_on_off_fail;
 		}
 		/* In case line card is configured - enable it. */
 		if (mlxreg_lc->state & MLXREG_LC_CONFIGURED && action)
@@ -588,12 +594,13 @@ static int mlxreg_lc_event_handler(void *handle, enum mlxreg_hotplug_kind kind,
 				/* In case line card is configured - enable it. */
 				if (mlxreg_lc->state & MLXREG_LC_CONFIGURED)
 					err = mlxreg_lc_enable_disable(mlxreg_lc, 1);
+				mutex_unlock(&mlxreg_lc->lock);
 				return err;
 			}
 			err = mlxreg_lc_create_static_devices(mlxreg_lc, mlxreg_lc->main_devs,
 							      mlxreg_lc->main_devs_num);
 			if (err)
-				return err;
+				goto mlxreg_lc_create_static_devices_fail;
 
 			/* In case line card is already in ready state - enable it. */
 			if (mlxreg_lc->state & MLXREG_LC_CONFIGURED)
@@ -620,6 +627,10 @@ static int mlxreg_lc_event_handler(void *handle, enum mlxreg_hotplug_kind kind,
 		break;
 	}
 
+mlxreg_lc_power_on_off_fail:
+mlxreg_lc_create_static_devices_fail:
+	mutex_unlock(&mlxreg_lc->lock);
+
 	return err;
 }
 
@@ -665,7 +676,7 @@ static int mlxreg_lc_completion_notify(void *handle, struct i2c_adapter *parent,
 		if (err)
 			goto mlxreg_lc_create_static_devices_failed;
 
-		mlxreg_lc_state_update(mlxreg_lc, MLXREG_LC_POWERED, 1);
+		mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_POWERED, 1);
 	}
 
 	/* Verify if line card is synchronized. */
@@ -676,7 +687,7 @@ static int mlxreg_lc_completion_notify(void *handle, struct i2c_adapter *parent,
 	/* Power on line card if necessary. */
 	if (regval & mlxreg_lc->data->mask) {
 		mlxreg_lc->state |= MLXREG_LC_SYNCED;
-		mlxreg_lc_state_update(mlxreg_lc, MLXREG_LC_SYNCED, 1);
+		mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_SYNCED, 1);
 		if (mlxreg_lc->state & ~MLXREG_LC_POWERED) {
 			err = mlxreg_lc_power_on_off(mlxreg_lc, 1);
 			if (err)
@@ -684,7 +695,7 @@ static int mlxreg_lc_completion_notify(void *handle, struct i2c_adapter *parent,
 		}
 	}
 
-	mlxreg_lc_state_update(mlxreg_lc, MLXREG_LC_INITIALIZED, 1);
+	mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_INITIALIZED, 1);
 
 	return 0;
 
@@ -904,6 +915,8 @@ static int mlxreg_lc_remove(struct platform_device *pdev)
 	struct mlxreg_core_data *data = dev_get_platdata(&pdev->dev);
 	struct mlxreg_lc *mlxreg_lc = platform_get_drvdata(pdev);
 
+	mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_INITIALIZED, 0);
+
 	/*
 	 * Probing and removing are invoked by hotplug events raised upon line card insertion and
 	 * removing. If probing procedure fails all data is cleared. However, hotplug event still
-- 
2.35.1



