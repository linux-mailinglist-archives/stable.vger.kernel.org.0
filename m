Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C646C3C4C1B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbhGLHBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241744AbhGLG7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9BD61156;
        Mon, 12 Jul 2021 06:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072998;
        bh=yfM7ZqWbO13YvsM+/LpAFuOCbcq//zsYf8iFiW3mizg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjYrAQ84zVzSbmsipFJ6sv0DnyiiiWPP4gcwyAW9/PB8Went1Fl8sQRPPwMECcll3
         2HYvXZE2UcAeNhttkn78Leov1rFkFYQSNvtuj+fmz5qoOYao9/2MQsel9L5VUg64hH
         yVvIiQ8KJGVpEvgdiny7IgKkaW6CyNfNLI+Jn18k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 093/700] iio: accel: bmc150: Dont make the remove function of the second accelerometer unregister itself
Date:   Mon, 12 Jul 2021 08:02:56 +0200
Message-Id: <20210712060937.914051025@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f407e2dca0f559621114eeaf657880d83f237fbd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bmc150-accel-core.c |    4 ++--
 drivers/iio/accel/bmc150-accel-i2c.c  |    2 +-
 drivers/iio/accel/bmc150-accel.h      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1811,11 +1811,11 @@ struct i2c_client *bmc150_get_second_dev
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
 
--- a/drivers/iio/accel/bmc150-accel-i2c.c
+++ b/drivers/iio/accel/bmc150-accel-i2c.c
@@ -70,7 +70,7 @@ static int bmc150_accel_probe(struct i2c
 
 		second_dev = i2c_acpi_new_device(&client->dev, 1, &board_info);
 		if (!IS_ERR(second_dev))
-			bmc150_set_second_device(second_dev);
+			bmc150_set_second_device(client, second_dev);
 	}
 #endif
 
--- a/drivers/iio/accel/bmc150-accel.h
+++ b/drivers/iio/accel/bmc150-accel.h
@@ -18,7 +18,7 @@ int bmc150_accel_core_probe(struct devic
 			    const char *name, bool block_supported);
 int bmc150_accel_core_remove(struct device *dev);
 struct i2c_client *bmc150_get_second_device(struct i2c_client *second_device);
-void bmc150_set_second_device(struct i2c_client *second_device);
+void bmc150_set_second_device(struct i2c_client *client, struct i2c_client *second_dev);
 extern const struct dev_pm_ops bmc150_accel_pm_ops;
 extern const struct regmap_config bmc150_regmap_conf;
 


