Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE34657C30
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiL1P3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiL1P3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D201581C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DECCB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0717C433EF;
        Wed, 28 Dec 2022 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241387;
        bh=XGUY2vKQlHbct94xX1+yTxtC0goDttCGVV4NX+By5rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWBK6fsLs11VBkHX1evwPPzJ36w3rqImjiQK/Xh9D8PMG6SfaASbATedxMP2fjGZ5
         t7tuAooSBm28NauyBUga+pte4b+ObQvIrRVrw+3q1OYKmN6TiibwJTV6t5/CUw+AVg
         Y6oHnA/bMwwZ/r+lSUc+hybniR6qN1Gyd5StrinQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/731] iio:imu:adis: Move exports into IIO_ADISLIB namespace
Date:   Wed, 28 Dec 2022 15:39:43 +0100
Message-Id: <20221228144310.350313045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 6c9304d6af122f9afea41885ad82ed627e9442a8 ]

In order to avoid unneessary pollution of the global symbol namespace
move the common/library functions into a specific namespace and import
that into the various specific device drivers that use them.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220130205701.334592-9-jic23@kernel.org
Stable-dep-of: 99c05e4283a1 ("iio: adis: add '__adis_enable_irq()' implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adis16201.c         |  1 +
 drivers/iio/accel/adis16209.c         |  1 +
 drivers/iio/gyro/adis16136.c          |  1 +
 drivers/iio/gyro/adis16260.c          |  1 +
 drivers/iio/imu/adis.c                | 20 ++++++++++----------
 drivers/iio/imu/adis16400.c           |  1 +
 drivers/iio/imu/adis16460.c           |  1 +
 drivers/iio/imu/adis16475.c           |  1 +
 drivers/iio/imu/adis16480.c           |  1 +
 drivers/iio/imu/adis_buffer.c         |  4 ++--
 drivers/iio/imu/adis_trigger.c        |  2 +-
 drivers/staging/iio/accel/adis16203.c |  1 +
 drivers/staging/iio/accel/adis16240.c |  1 +
 13 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/accel/adis16201.c b/drivers/iio/accel/adis16201.c
index 7a434e2884d4..dfb8e2e5bdf5 100644
--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -300,3 +300,4 @@ MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16201 Dual-Axis Digital Inclinometer and Accelerometer");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("spi:adis16201");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/accel/adis16209.c b/drivers/iio/accel/adis16209.c
index ac08e866d612..5a9c6e2296f1 100644
--- a/drivers/iio/accel/adis16209.c
+++ b/drivers/iio/accel/adis16209.c
@@ -310,3 +310,4 @@ MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16209 Dual-Axis Digital Inclinometer and Accelerometer");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("spi:adis16209");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/gyro/adis16136.c b/drivers/iio/gyro/adis16136.c
index 36879f01e28c..71295709f2b9 100644
--- a/drivers/iio/gyro/adis16136.c
+++ b/drivers/iio/gyro/adis16136.c
@@ -591,3 +591,4 @@ module_spi_driver(adis16136_driver);
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("Analog Devices ADIS16133/ADIS16135/ADIS16136 gyroscope driver");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/gyro/adis16260.c b/drivers/iio/gyro/adis16260.c
index 66b6b7bd5e1b..eaf57bd339ed 100644
--- a/drivers/iio/gyro/adis16260.c
+++ b/drivers/iio/gyro/adis16260.c
@@ -433,3 +433,4 @@ module_spi_driver(adis16260_driver);
 MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16260/5 Digital Gyroscope Sensor");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index 638957001653..f7fcfd04f659 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -121,7 +121,7 @@ int __adis_write_reg(struct adis *adis, unsigned int reg, unsigned int value,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__adis_write_reg);
+EXPORT_SYMBOL_NS_GPL(__adis_write_reg, IIO_ADISLIB);
 
 /**
  * __adis_read_reg() - read N bytes from register (unlocked version)
@@ -218,7 +218,7 @@ int __adis_read_reg(struct adis *adis, unsigned int reg, unsigned int *val,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__adis_read_reg);
+EXPORT_SYMBOL_NS_GPL(__adis_read_reg, IIO_ADISLIB);
 /**
  * __adis_update_bits_base() - ADIS Update bits function - Unlocked version
  * @adis: The adis device
@@ -243,7 +243,7 @@ int __adis_update_bits_base(struct adis *adis, unsigned int reg, const u32 mask,
 
 	return __adis_write_reg(adis, reg, __val, size);
 }
-EXPORT_SYMBOL_GPL(__adis_update_bits_base);
+EXPORT_SYMBOL_NS_GPL(__adis_update_bits_base, IIO_ADISLIB);
 
 #ifdef CONFIG_DEBUG_FS
 
@@ -265,7 +265,7 @@ int adis_debugfs_reg_access(struct iio_dev *indio_dev, unsigned int reg,
 
 	return adis_write_reg_16(adis, reg, writeval);
 }
-EXPORT_SYMBOL(adis_debugfs_reg_access);
+EXPORT_SYMBOL_NS(adis_debugfs_reg_access, IIO_ADISLIB);
 
 #endif
 
@@ -314,7 +314,7 @@ int adis_enable_irq(struct adis *adis, bool enable)
 	mutex_unlock(&adis->state_lock);
 	return ret;
 }
-EXPORT_SYMBOL(adis_enable_irq);
+EXPORT_SYMBOL_NS(adis_enable_irq, IIO_ADISLIB);
 
 /**
  * __adis_check_status() - Check the device for error conditions (unlocked)
@@ -346,7 +346,7 @@ int __adis_check_status(struct adis *adis)
 
 	return -EIO;
 }
-EXPORT_SYMBOL_GPL(__adis_check_status);
+EXPORT_SYMBOL_NS_GPL(__adis_check_status, IIO_ADISLIB);
 
 /**
  * __adis_reset() - Reset the device (unlocked version)
@@ -370,7 +370,7 @@ int __adis_reset(struct adis *adis)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__adis_reset);
+EXPORT_SYMBOL_NS_GPL(__adis_reset, IIO_ADIS_LIB);
 
 static int adis_self_test(struct adis *adis)
 {
@@ -461,7 +461,7 @@ int __adis_initial_startup(struct adis *adis)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__adis_initial_startup);
+EXPORT_SYMBOL_NS_GPL(__adis_initial_startup, IIO_ADISLIB);
 
 /**
  * adis_single_conversion() - Performs a single sample conversion
@@ -509,7 +509,7 @@ int adis_single_conversion(struct iio_dev *indio_dev,
 	mutex_unlock(&adis->state_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adis_single_conversion);
+EXPORT_SYMBOL_NS_GPL(adis_single_conversion, IIO_ADISLIB);
 
 /**
  * adis_init() - Initialize adis device structure
@@ -546,7 +546,7 @@ int adis_init(struct adis *adis, struct iio_dev *indio_dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adis_init);
+EXPORT_SYMBOL_NS_GPL(adis_init, IIO_ADISLIB);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index b12917a7cb60..9bcd9a9261b9 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -1230,3 +1230,4 @@ module_spi_driver(adis16400_driver);
 MODULE_AUTHOR("Manuel Stahl <manuel.stahl@iis.fraunhofer.de>");
 MODULE_DESCRIPTION("Analog Devices ADIS16400/5 IMU SPI driver");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/imu/adis16460.c b/drivers/iio/imu/adis16460.c
index a6f9fba3e03f..40fc0e582a9f 100644
--- a/drivers/iio/imu/adis16460.c
+++ b/drivers/iio/imu/adis16460.c
@@ -444,3 +444,4 @@ module_spi_driver(adis16460_driver);
 MODULE_AUTHOR("Dragos Bogdan <dragos.bogdan@analog.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16460 IMU driver");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index 287fff39a927..9d28534db3b0 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -1382,3 +1382,4 @@ module_spi_driver(adis16475_driver);
 MODULE_AUTHOR("Nuno Sa <nuno.sa@analog.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16475 IMU driver");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index f9b4540db1f4..44bbe3d19907 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -1538,3 +1538,4 @@ module_spi_driver(adis16480_driver);
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("Analog Devices ADIS16480 IMU driver");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index d3527cf5ed37..928933027ae3 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -124,7 +124,7 @@ int adis_update_scan_mode(struct iio_dev *indio_dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adis_update_scan_mode);
+EXPORT_SYMBOL_NS_GPL(adis_update_scan_mode, IIO_ADISLIB);
 
 static irqreturn_t adis_trigger_handler(int irq, void *p)
 {
@@ -212,5 +212,5 @@ devm_adis_setup_buffer_and_trigger(struct adis *adis, struct iio_dev *indio_dev,
 	return devm_add_action_or_reset(&adis->spi->dev, adis_buffer_cleanup,
 					adis);
 }
-EXPORT_SYMBOL_GPL(devm_adis_setup_buffer_and_trigger);
+EXPORT_SYMBOL_NS_GPL(devm_adis_setup_buffer_and_trigger, IIO_ADISLIB);
 
diff --git a/drivers/iio/imu/adis_trigger.c b/drivers/iio/imu/adis_trigger.c
index 0e7fb00ba241..f890bf842db8 100644
--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -87,5 +87,5 @@ int devm_adis_probe_trigger(struct adis *adis, struct iio_dev *indio_dev)
 
 	return devm_iio_trigger_register(&adis->spi->dev, adis->trig);
 }
-EXPORT_SYMBOL_GPL(devm_adis_probe_trigger);
+EXPORT_SYMBOL_NS_GPL(devm_adis_probe_trigger, IIO_ADISLIB);
 
diff --git a/drivers/staging/iio/accel/adis16203.c b/drivers/staging/iio/accel/adis16203.c
index 1d3026dae827..62d5397ff1f9 100644
--- a/drivers/staging/iio/accel/adis16203.c
+++ b/drivers/staging/iio/accel/adis16203.c
@@ -312,3 +312,4 @@ MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
 MODULE_DESCRIPTION("Analog Devices ADIS16203 Programmable 360 Degrees Inclinometer");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("spi:adis16203");
+MODULE_IMPORT_NS(IIO_ADISLIB);
diff --git a/drivers/staging/iio/accel/adis16240.c b/drivers/staging/iio/accel/adis16240.c
index 2a8aa83b8d9e..bca857eef92e 100644
--- a/drivers/staging/iio/accel/adis16240.c
+++ b/drivers/staging/iio/accel/adis16240.c
@@ -440,3 +440,4 @@ MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
 MODULE_DESCRIPTION("Analog Devices Programmable Impact Sensor and Recorder");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("spi:adis16240");
+MODULE_IMPORT_NS(IIO_ADISLIB);
-- 
2.35.1



