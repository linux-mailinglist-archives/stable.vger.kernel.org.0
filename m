Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BE63AB98B
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhFQQ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhFQQ1W (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4FC3610A5;
        Thu, 17 Jun 2021 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947114;
        bh=PF4OZ8/CGAo+MA/JLpY2Ywz9eArmkyzbI9BMDlTsZLc=;
        h=Subject:To:From:Date:From;
        b=twzjvfEAjW88YxXMxJMX4QiVYOsyCxW1Twy9jORxc89n+DPE8ZWfKsiR2wHGEJpTu
         JF//u33j4WAv+bE7C73POBAwPWrWmi+BjNstYoLItuoyE/0eyg3xX1Q5ZP3ECOmFXD
         cAYsMrn3YKUiE8DrFXvRchlruxTWHejyioDmZmo4=
Subject: patch "iio: accel: bmc150: Don't make the remove function of the second" added to staging-testing
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        jeremy@jcline.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:24:36 +0200
Message-ID: <1623947076233200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bmc150: Don't make the remove function of the second

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f407e2dca0f559621114eeaf657880d83f237fbd Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 23 May 2021 19:00:56 +0200
Subject: iio: accel: bmc150: Don't make the remove function of the second
 accelerometer unregister itself

On machines with dual accelerometers described in a single ACPI fwnode,
the bmc150_accel_probe() instantiates a second i2c-client for the second
accelerometer.

A pointer to this manually instantiated second i2c-client is stored
inside the iio_dev's private-data through bmc150_set_second_device(),
so that the i2c-client can be unregistered from bmc150_accel_remove().

Before this commit bmc150_set_second_device() took only 1 argument so it
would store the pointer in private-data of the iio_dev belonging to the
manually instantiated i2c-client, leading to the bmc150_accel_remove()
call for the second_dev trying to unregister *itself* while it was
being removed, leading to a deadlock and rmmod hanging.

Change bmc150_set_second_device() to take 2 arguments: 1. The i2c-client
which is instantiating the second i2c-client for the 2nd accelerometer and
2. The second-device pointer itself (which also is an i2c-client).

This will store the second_device pointer in the private data of the
iio_dev belonging to the (ACPI instantiated) i2c-client for the first
accelerometer and will make bmc150_accel_remove() unregister the
second_device i2c-client when called for the first client,
avoiding the deadlock.

Fixes: 5bfb3a4bd8f6 ("iio: accel: bmc150: Check for a second ACPI device for BOSC0200")
Cc: Jeremy Cline <jeremy@jcline.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/bmc150-accel-core.c | 4 ++--
 drivers/iio/accel/bmc150-accel-i2c.c  | 2 +-
 drivers/iio/accel/bmc150-accel.h      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index c526d83f14d5..1aec873bee03 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1811,11 +1811,11 @@ struct i2c_client *bmc150_get_second_device(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(bmc150_get_second_device);
 
-void bmc150_set_second_device(struct i2c_client *client)
+void bmc150_set_second_device(struct i2c_client *client, struct i2c_client *second_dev)
 {
 	struct bmc150_accel_data *data = iio_priv(i2c_get_clientdata(client));
 
-	data->second_device = client;
+	data->second_device = second_dev;
 }
 EXPORT_SYMBOL_GPL(bmc150_set_second_device);
 
diff --git a/drivers/iio/accel/bmc150-accel-i2c.c b/drivers/iio/accel/bmc150-accel-i2c.c
index 69f709319484..2afaae0294ee 100644
--- a/drivers/iio/accel/bmc150-accel-i2c.c
+++ b/drivers/iio/accel/bmc150-accel-i2c.c
@@ -70,7 +70,7 @@ static int bmc150_accel_probe(struct i2c_client *client,
 
 		second_dev = i2c_acpi_new_device(&client->dev, 1, &board_info);
 		if (!IS_ERR(second_dev))
-			bmc150_set_second_device(second_dev);
+			bmc150_set_second_device(client, second_dev);
 	}
 #endif
 
diff --git a/drivers/iio/accel/bmc150-accel.h b/drivers/iio/accel/bmc150-accel.h
index 6024f15b9700..e30c1698f6fb 100644
--- a/drivers/iio/accel/bmc150-accel.h
+++ b/drivers/iio/accel/bmc150-accel.h
@@ -18,7 +18,7 @@ int bmc150_accel_core_probe(struct device *dev, struct regmap *regmap, int irq,
 			    const char *name, bool block_supported);
 int bmc150_accel_core_remove(struct device *dev);
 struct i2c_client *bmc150_get_second_device(struct i2c_client *second_device);
-void bmc150_set_second_device(struct i2c_client *second_device);
+void bmc150_set_second_device(struct i2c_client *client, struct i2c_client *second_dev);
 extern const struct dev_pm_ops bmc150_accel_pm_ops;
 extern const struct regmap_config bmc150_regmap_conf;
 
-- 
2.32.0


