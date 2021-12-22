Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47FC47D17B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbhLVMIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:08:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48044 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMH7 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 22 Dec 2021 07:07:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7FA06198E
        for <Stable@vger.kernel.org>; Wed, 22 Dec 2021 12:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE26C36AE5;
        Wed, 22 Dec 2021 12:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174878;
        bh=cy/b50BFCQSNtUVGNwd433Fm4zx/FZBanMox0ucF3gM=;
        h=Subject:To:From:Date:From;
        b=nM4QJ+Zgl+0PQcj001lXn9k/TBBxxiL8/2Ub5U5Om9D0RXnKyL/QDuyxJvtYgepyZ
         x5ca+SI0AnZ6l78ijfrG156vcLbt/FcgwPDxmme+Ai3OOqRR2/myF36Q26lBC46Jft
         YGj2dt7B2Tzxgw0fIbo86zJzR8bO4sH4oz+pl9PA=
Subject: patch "iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs" added to char-misc-next
To:     Jonathan.Cameron@huawei.com, Kunyang_Fan@aaeon.com.tw,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 Dec 2021 12:52:05 +0100
Message-ID: <164017392521920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c9791a94384af07592d29504004d2255dbaf8663 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 5 Dec 2021 17:27:28 +0000
Subject: iio: adc: ti-adc081c: Partial revert of removal of ACPI IDs

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
---
 drivers/iio/adc/ti-adc081c.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ti-adc081c.c b/drivers/iio/adc/ti-adc081c.c
index 16fc608db36a..bd48b073e720 100644
--- a/drivers/iio/adc/ti-adc081c.c
+++ b/drivers/iio/adc/ti-adc081c.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
+#include <linux/property.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/buffer.h>
@@ -156,13 +157,16 @@ static int adc081c_probe(struct i2c_client *client,
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
@@ -210,10 +214,17 @@ static const struct i2c_device_id adc081c_id[] = {
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
@@ -222,6 +233,7 @@ static struct i2c_driver adc081c_driver = {
 	.driver = {
 		.name = "adc081c",
 		.of_match_table = adc081c_of_match,
+		.acpi_match_table = adc081c_acpi_match,
 	},
 	.probe = adc081c_probe,
 	.id_table = adc081c_id,
-- 
2.34.1


