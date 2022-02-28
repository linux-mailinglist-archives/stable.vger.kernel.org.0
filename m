Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2924C6316
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiB1GhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiB1Gg4 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Feb 2022 01:36:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7788966CA4
        for <Stable@vger.kernel.org>; Sun, 27 Feb 2022 22:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20F42B80E1C
        for <Stable@vger.kernel.org>; Mon, 28 Feb 2022 06:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3096C340E7;
        Mon, 28 Feb 2022 06:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646030175;
        bh=R06b0AC6GPx+bL08akwYtJLIIbQE9OGQmjo7TUpWMBg=;
        h=Subject:To:Cc:From:Date:From;
        b=iA9SOW0O3DC6PYSIzz0ceiIRT2ZQxPvR7sU0I/tL2KK4+x0R9gaT0Nh04dgCpDyj0
         BJlNG+fY1Asim30rAwtjoQRRKS89ANuYSwGqXOeNRo0kDBlykaB5ScJ9VKoeyC1O6y
         xvpWBJh4mkzMLyDGNPYhMqwreWBJ7yb65Hbf2HPI=
Subject: FAILED: patch "[PATCH] iio: Fix error handling for PM" failed to apply to 4.14-stable tree
To:     linmq006@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 07:36:01 +0100
Message-ID: <16460301612589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 632fe0bb8c5b9c06ec961f575ee42a6fff5eceeb Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Thu, 6 Jan 2022 11:23:09 +0000
Subject: [PATCH] iio: Fix error handling for PM

The pm_runtime_enable will increase power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable(). In the PM Runtime docs:
    Drivers in ->remove() callback should undo the runtime PM changes done
    in ->probe(). Usually this means calling pm_runtime_disable(),
    pm_runtime_dont_use_autosuspend() etc.
We should do this in error handling.

Fix this problem for the following drivers: bmc150, bmg160, kmx61,
kxcj-1013, mma9551, mma9553.

Fixes: 7d0ead5c3f00 ("iio: Reconcile operation order between iio_register/unregister and pm functions")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220106112309.16879-1-linmq006@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index e6081dd0a880..d11f668016a6 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1783,11 +1783,14 @@ int bmc150_accel_core_probe(struct device *dev, struct regmap *regmap, int irq,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "Unable to register iio device\n");
-		goto err_trigger_unregister;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
 err_trigger_unregister:
 	bmc150_accel_unregister_triggers(data, BMC150_ACCEL_TRIGGERS - 1);
 err_buffer_cleanup:
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 0fe570316848..ac74cdcd2bc8 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1590,11 +1590,14 @@ static int kxcjk1013_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto err_buffer_cleanup;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index 4c359fb05480..c53a3398b14c 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -495,11 +495,14 @@ static int mma9551_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto out_poweroff;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 out_poweroff:
 	mma9551_set_device_state(client, false);
 
diff --git a/drivers/iio/accel/mma9553.c b/drivers/iio/accel/mma9553.c
index 0570ab1cc064..5ff6bc70708b 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1134,12 +1134,15 @@ static int mma9553_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto out_poweroff;
+		goto err_pm_cleanup;
 	}
 
 	dev_dbg(&indio_dev->dev, "Registered device %s\n", name);
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 out_poweroff:
 	mma9551_set_device_state(client, false);
 	return ret;
diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
index 17b939a367ad..81a6d09788bd 100644
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -1188,11 +1188,14 @@ int bmg160_core_probe(struct device *dev, struct regmap *regmap, int irq,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "unable to register iio device\n");
-		goto err_buffer_cleanup;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 1dabfd615dab..f89724481df9 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1385,7 +1385,7 @@ static int kmx61_probe(struct i2c_client *client,
 	ret = iio_device_register(data->acc_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register acc iio device\n");
-		goto err_buffer_cleanup_mag;
+		goto err_pm_cleanup;
 	}
 
 	ret = iio_device_register(data->mag_indio_dev);
@@ -1398,6 +1398,9 @@ static int kmx61_probe(struct i2c_client *client,
 
 err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 err_buffer_cleanup_mag:
 	if (client->irq > 0)
 		iio_triggered_buffer_cleanup(data->mag_indio_dev);
diff --git a/drivers/iio/magnetometer/bmc150_magn.c b/drivers/iio/magnetometer/bmc150_magn.c
index f96f53175349..3d4d21f979fa 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -962,13 +962,14 @@ int bmc150_magn_probe(struct device *dev, struct regmap *regmap,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "unable to register iio device\n");
-		goto err_disable_runtime_pm;
+		goto err_pm_cleanup;
 	}
 
 	dev_dbg(dev, "Registered device %s\n", name);
 	return 0;
 
-err_disable_runtime_pm:
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);

