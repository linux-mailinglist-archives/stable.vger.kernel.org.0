Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEEC4991CB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347525AbiAXUO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:14:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347605AbiAXUMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:12:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FC9B811F9;
        Mon, 24 Jan 2022 20:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D02C340E8;
        Mon, 24 Jan 2022 20:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055141;
        bh=lAgpecVtFPKqz8XYq912/7qZ284lwJXrzMb0Oc/wRyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ao9EpMXyMpscYWR7BFyC1Pkc8iLUUtlPhzTluuJcY0zIqS+3LmaI3TLMriW0A+BRu
         3HuWsawSjdrXRndWqXp8zFKE5/rTY98KQsx5QqigJ0eii3NN74rq6sFW59DFOh/lNZ
         Kq54dM6BSzQ/6lvwH+bjoCLk3XhYZn2iucEN1lf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kunyang Fan <Kunyang_Fan@aaeon.com.tw>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.15 055/846] iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs
Date:   Mon, 24 Jan 2022 19:32:52 +0100
Message-Id: <20220124184102.867586321@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit c9791a94384af07592d29504004d2255dbaf8663 upstream.

Unfortuanately a non standards compliant ACPI ID is known to be
in the wild on some AAEON boards.

Partly revert the removal of these IDs so that ADC081C will again
work + add a comment to that affect for future reference.

Whilst here use generic firmware properties rather than the ACPI
specific handling previously found in this driver.

Reported-by: Kunyang Fan <Kunyang_Fan@aaeon.com.tw>
Fixes: c458b7ca3fd0 ("iio:adc:ti-adc081c: Drop ACPI ids that seem very unlikely to be official.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Kunyang Fan <Kunyang_Fan@aaeon.com.tw> #UP-extremei11
Link: https://lore.kernel.org/r/20211205172728.2826512-1-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-adc081c.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/iio/adc/ti-adc081c.c
+++ b/drivers/iio/adc/ti-adc081c.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
+#include <linux/property.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/buffer.h>
@@ -156,13 +157,16 @@ static int adc081c_probe(struct i2c_clie
 {
 	struct iio_dev *iio;
 	struct adc081c *adc;
-	struct adcxx1c_model *model;
+	const struct adcxx1c_model *model;
 	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EOPNOTSUPP;
 
-	model = &adcxx1c_models[id->driver_data];
+	if (dev_fwnode(&client->dev))
+		model = device_get_match_data(&client->dev);
+	else
+		model = &adcxx1c_models[id->driver_data];
 
 	iio = devm_iio_device_alloc(&client->dev, sizeof(*adc));
 	if (!iio)
@@ -210,10 +214,17 @@ static const struct i2c_device_id adc081
 };
 MODULE_DEVICE_TABLE(i2c, adc081c_id);
 
+static const struct acpi_device_id adc081c_acpi_match[] = {
+	/* Used on some AAEON boards */
+	{ "ADC081C", (kernel_ulong_t)&adcxx1c_models[ADC081C] },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, adc081c_acpi_match);
+
 static const struct of_device_id adc081c_of_match[] = {
-	{ .compatible = "ti,adc081c" },
-	{ .compatible = "ti,adc101c" },
-	{ .compatible = "ti,adc121c" },
+	{ .compatible = "ti,adc081c", .data = &adcxx1c_models[ADC081C] },
+	{ .compatible = "ti,adc101c", .data = &adcxx1c_models[ADC101C] },
+	{ .compatible = "ti,adc121c", .data = &adcxx1c_models[ADC121C] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adc081c_of_match);
@@ -222,6 +233,7 @@ static struct i2c_driver adc081c_driver
 	.driver = {
 		.name = "adc081c",
 		.of_match_table = adc081c_of_match,
+		.acpi_match_table = adc081c_acpi_match,
 	},
 	.probe = adc081c_probe,
 	.id_table = adc081c_id,


