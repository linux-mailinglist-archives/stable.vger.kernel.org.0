Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8204C756F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbiB1RzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbiB1RxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF16A9E29;
        Mon, 28 Feb 2022 09:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F400614C9;
        Mon, 28 Feb 2022 17:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD2C340E7;
        Mon, 28 Feb 2022 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070034;
        bh=MYv5chMPEwF/MLEvEC21x/Ewh4vWl1yYcspTrkmq+AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHxOOcTWWoJMRFGzytwGcQO3w/8Fq7ijgp0ad1jxwlvI6TDbWMYXzhvI9p9JhdqjH
         5N/5MPVU/J0AT2FJNRGsrS7Ok16GcD9awmsiDfL29OZGw1ZXsax8TRAsB67tXgncVi
         gvZEditsqEfn/TZQB3CtnRszyz5wY8AZyzS+JRj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 102/139] iio: Fix error handling for PM
Date:   Mon, 28 Feb 2022 18:24:36 +0100
Message-Id: <20220228172358.401125919@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 632fe0bb8c5b9c06ec961f575ee42a6fff5eceeb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bmc150-accel-core.c  |    5 ++++-
 drivers/iio/accel/kxcjk-1013.c         |    5 ++++-
 drivers/iio/accel/mma9551.c            |    5 ++++-
 drivers/iio/accel/mma9553.c            |    5 ++++-
 drivers/iio/gyro/bmg160_core.c         |    5 ++++-
 drivers/iio/imu/kmx61.c                |    5 ++++-
 drivers/iio/magnetometer/bmc150_magn.c |    5 +++--
 7 files changed, 27 insertions(+), 8 deletions(-)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1782,11 +1782,14 @@ int bmc150_accel_core_probe(struct devic
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
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1589,11 +1589,14 @@ static int kxcjk1013_probe(struct i2c_cl
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
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -495,11 +495,14 @@ static int mma9551_probe(struct i2c_clie
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
 
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1134,12 +1134,15 @@ static int mma9553_probe(struct i2c_clie
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
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -1188,11 +1188,14 @@ int bmg160_core_probe(struct device *dev
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
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1385,7 +1385,7 @@ static int kmx61_probe(struct i2c_client
 	ret = iio_device_register(data->acc_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register acc iio device\n");
-		goto err_buffer_cleanup_mag;
+		goto err_pm_cleanup;
 	}
 
 	ret = iio_device_register(data->mag_indio_dev);
@@ -1398,6 +1398,9 @@ static int kmx61_probe(struct i2c_client
 
 err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 err_buffer_cleanup_mag:
 	if (client->irq > 0)
 		iio_triggered_buffer_cleanup(data->mag_indio_dev);
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -962,13 +962,14 @@ int bmc150_magn_probe(struct device *dev
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


