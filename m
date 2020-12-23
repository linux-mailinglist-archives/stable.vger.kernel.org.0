Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0192E1634
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgLWCUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgLWCUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0017221E5;
        Wed, 23 Dec 2020 02:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690001;
        bh=Ysnw/aVaifEltk/97tyr/Nk32XUmkBUZtnAY149BcVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcy0XvENj4YAddpPUEaYxr26Iy+ZpboLpz76Fs8yBlQxyXo8IVy9Zg9YGlrLhlJVH
         g/w7yi7SfCPVB4tK0oXuyH+craMFztiCTkUhRhL2i2FzKLwuoZvNt/Oe07BtXttFbG
         1tjlyk/NLn0pJ6rhjyfKCX+Z3oaiKZt/nLr1oieS0Vf/hgMQSUIcEqEz8+01tZFf25
         Q/g1z+nYgmbtFTyH3UaJigWiHPAD99CTn1EN6Xlb5izgp/XLob10EI1uZYCHVBUz8j
         uTmy7ChziSgqnMlR5OS5FampyUXvcHOybjwK3kY6vDSS4BAagNz+rA8LOZXmJMCkvS
         5j87eBW8MBc5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Cline <jeremy@jcline.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 083/130] iio: accel: bmc150: Check for a second ACPI device for BOSC0200
Date:   Tue, 22 Dec 2020 21:17:26 -0500
Message-Id: <20201223021813.2791612-83-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jeremy@jcline.org>

[ Upstream commit 5bfb3a4bd8f6b5329464edb9b772738708509d4a ]

Some BOSC0200 acpi_device-s describe two accelerometers in a single ACPI
device. Normally we would handle this by letting the special
drivers/platform/x86/i2c-multi-instantiate.c driver handle the BOSC0200
ACPI id and let it instantiate 2 bmc150_accel type i2c_client-s for us.

But doing so changes the modalias for the first accelerometer
(which is already supported and used on many devices) from
acpi:BOSC0200 to i2c:bmc150_accel. The modalias is not only used
to load the driver, but is also used by hwdb matches in
/lib/udev/hwdb.d/60-sensor.hwdb which provide a mountmatrix to
userspace by setting the ACCEL_MOUNT_MATRIX udev property.

Switching the handling of the BOSC0200 over to i2c-multi-instantiate.c
will break the hwdb matches causing the ACCEL_MOUNT_MATRIX udev prop
to no longer be set. So switching over to i2c-multi-instantiate.c is
not an option.

Changes by Hans de Goede:
-Add explanation to the commit message why i2c-multi-instantiate.c
 cannot be used
-Also set the dev_name, fwnode and irq i2c_board_info struct members
 for the 2nd client

Signed-off-by: Jeremy Cline <jeremy@jcline.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20201130141954.339805-2-hdegoede@redhat.com
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=198671
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bmc150-accel-core.c | 21 ++++++++++++++
 drivers/iio/accel/bmc150-accel-i2c.c  | 41 +++++++++++++++++++++++++--
 drivers/iio/accel/bmc150-accel.h      |  2 ++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index bcdf25f32e220..f63743a62d2ed 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -204,6 +204,7 @@ struct bmc150_accel_data {
 	int ev_enable_state;
 	int64_t timestamp, old_timestamp; /* Only used in hw fifo mode. */
 	const struct bmc150_accel_chip_info *chip_info;
+	struct i2c_client *second_device;
 	struct iio_mount_matrix orientation;
 };
 
@@ -1663,6 +1664,26 @@ int bmc150_accel_core_probe(struct device *dev, struct regmap *regmap, int irq,
 }
 EXPORT_SYMBOL_GPL(bmc150_accel_core_probe);
 
+struct i2c_client *bmc150_get_second_device(struct i2c_client *client)
+{
+	struct bmc150_accel_data *data = i2c_get_clientdata(client);
+
+	if (!data)
+		return NULL;
+
+	return data->second_device;
+}
+EXPORT_SYMBOL_GPL(bmc150_get_second_device);
+
+void bmc150_set_second_device(struct i2c_client *client)
+{
+	struct bmc150_accel_data *data = i2c_get_clientdata(client);
+
+	if (data)
+		data->second_device = client;
+}
+EXPORT_SYMBOL_GPL(bmc150_set_second_device);
+
 int bmc150_accel_core_remove(struct device *dev)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
diff --git a/drivers/iio/accel/bmc150-accel-i2c.c b/drivers/iio/accel/bmc150-accel-i2c.c
index 06021c8685a70..8c45963fe3cdb 100644
--- a/drivers/iio/accel/bmc150-accel-i2c.c
+++ b/drivers/iio/accel/bmc150-accel-i2c.c
@@ -29,6 +29,8 @@ static int bmc150_accel_probe(struct i2c_client *client,
 		i2c_check_functionality(client->adapter, I2C_FUNC_I2C) ||
 		i2c_check_functionality(client->adapter,
 					I2C_FUNC_SMBUS_READ_I2C_BLOCK);
+	struct acpi_device __maybe_unused *adev;
+	int ret;
 
 	regmap = devm_regmap_init_i2c(client, &bmc150_regmap_conf);
 	if (IS_ERR(regmap)) {
@@ -39,12 +41,47 @@ static int bmc150_accel_probe(struct i2c_client *client,
 	if (id)
 		name = id->name;
 
-	return bmc150_accel_core_probe(&client->dev, regmap, client->irq, name,
-				       block_supported);
+	ret = bmc150_accel_core_probe(&client->dev, regmap, client->irq, name, block_supported);
+	if (ret)
+		return ret;
+
+	/*
+	 * Some BOSC0200 acpi_devices describe 2 accelerometers in a single ACPI
+	 * device, try instantiating a second i2c_client for an I2cSerialBusV2
+	 * ACPI resource with index 1. The !id check avoids recursion when
+	 * bmc150_accel_probe() gets called for the second client.
+	 */
+#ifdef CONFIG_ACPI
+	adev = ACPI_COMPANION(&client->dev);
+	if (!id && adev && strcmp(acpi_device_hid(adev), "BOSC0200") == 0) {
+		struct i2c_board_info board_info = {
+			.type = "bmc150_accel",
+			/*
+			 * The 2nd accel sits in the base of 2-in-1s. Note this
+			 * name is static, as there should never be more then 1
+			 * BOSC0200 ACPI node with 2 accelerometers in it.
+			 */
+			.dev_name = "BOSC0200:base",
+			.fwnode = client->dev.fwnode,
+			.irq = -ENOENT,
+		};
+		struct i2c_client *second_dev;
+
+		second_dev = i2c_acpi_new_device(&client->dev, 1, &board_info);
+		if (!IS_ERR(second_dev))
+			bmc150_set_second_device(second_dev);
+	}
+#endif
+
+	return 0;
 }
 
 static int bmc150_accel_remove(struct i2c_client *client)
 {
+	struct i2c_client *second_dev = bmc150_get_second_device(client);
+
+	i2c_unregister_device(second_dev);
+
 	return bmc150_accel_core_remove(&client->dev);
 }
 
diff --git a/drivers/iio/accel/bmc150-accel.h b/drivers/iio/accel/bmc150-accel.h
index ae6118ae11b1d..6e965a3ca3226 100644
--- a/drivers/iio/accel/bmc150-accel.h
+++ b/drivers/iio/accel/bmc150-accel.h
@@ -16,6 +16,8 @@ enum {
 int bmc150_accel_core_probe(struct device *dev, struct regmap *regmap, int irq,
 			    const char *name, bool block_supported);
 int bmc150_accel_core_remove(struct device *dev);
+struct i2c_client *bmc150_get_second_device(struct i2c_client *second_device);
+void bmc150_set_second_device(struct i2c_client *second_device);
 extern const struct dev_pm_ops bmc150_accel_pm_ops;
 extern const struct regmap_config bmc150_regmap_conf;
 
-- 
2.27.0

