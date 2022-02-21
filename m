Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FA04BDDA6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352498AbiBUQ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350922AbiBUQ7g (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012F422BE2
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:59:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9261C61386
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73495C340EC;
        Mon, 21 Feb 2022 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462752;
        bh=CYT7eLqQ8/75iPDoLffF5oLKeFNflu3ehdx6NJz8Qf4=;
        h=Subject:To:From:Date:From;
        b=jfM2LuON0YfPCdzv29bR8Uai5OvniERCJHvq76uNnpZgqQ3aURvjLJQRDL7V0ZUFX
         by+2XWz4qOIfHYx/4Uk9I0gn2aPUYs/Yp4BBSjgI9FUE2BO3bIe/1/7uNBrQQgGg3/
         3GcDqpflHt4LA3PmXMs9AeQmr3/sRkp4uqmhXs/E=
Subject: patch "iio: Fix error handling for PM" added to char-misc-linus
To:     linmq006@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:44 +0100
Message-ID: <164546272440160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    iio: Fix error handling for PM

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 632fe0bb8c5b9c06ec961f575ee42a6fff5eceeb Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Thu, 6 Jan 2022 11:23:09 +0000
Subject: iio: Fix error handling for PM

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
---
 drivers/iio/accel/bmc150-accel-core.c  | 5 ++++-
 drivers/iio/accel/kxcjk-1013.c         | 5 ++++-
 drivers/iio/accel/mma9551.c            | 5 ++++-
 drivers/iio/accel/mma9553.c            | 5 ++++-
 drivers/iio/gyro/bmg160_core.c         | 5 ++++-
 drivers/iio/imu/kmx61.c                | 5 ++++-
 drivers/iio/magnetometer/bmc150_magn.c | 5 +++--
 7 files changed, 27 insertions(+), 8 deletions(-)

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
-- 
2.35.1


