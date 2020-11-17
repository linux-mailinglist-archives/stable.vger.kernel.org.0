Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5D2B5C47
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKQJw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgKQJw5 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D272465B;
        Tue, 17 Nov 2020 09:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606776;
        bh=2I3RdNuQbxkiJG7Z9mLeENHTgDIP/NtY/XV59i0GT+g=;
        h=Subject:To:From:Date:From;
        b=ssc/LzZ61qwncURUfBPpdEzqGxqXW+Q5DIGXu2krcT+tdZHs1kho7kFyAiSH0GFGx
         T2xgdWnLmbE/y0yN5+hd6En90lYjWQL0hDalQU3HCCq4pJXJpGuFly4I7Um8NdE5hh
         280iPHb/bg+UnzDApC5xqxqE1ggmi8yBhaQ/kEQw=
Subject: patch "iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type" added to staging-linus
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:27 +0100
Message-ID: <160560680714092@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 11e94f28c3de35d5ad1ac6a242a5b30f4378991a Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Tue, 10 Nov 2020 14:38:34 +0100
Subject: iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type
 enum

Replace the boolean is_smo8500_device variable with an acpi_type enum.

For now this can be either ACPI_GENERIC or ACPI_SMO8500, this is a
preparation patch for adding special handling for the KIOX010A ACPI HID,
which will add a ACPI_KIOX010A acpi_type to the introduced enum.

For stable as needed as precursor for next patch.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Fixes: 7f6232e69539 ("iio: accel: kxcjk1013: Add KIOX010A ACPI Hardware-ID")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201110133835.129080-2-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/kxcjk-1013.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index beb38d9d607d..abeb0d254046 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -126,6 +126,11 @@ enum kx_chipset {
 	KX_MAX_CHIPS /* this must be last */
 };
 
+enum kx_acpi_type {
+	ACPI_GENERIC,
+	ACPI_SMO8500,
+};
+
 struct kxcjk1013_data {
 	struct i2c_client *client;
 	struct iio_trigger *dready_trig;
@@ -143,7 +148,7 @@ struct kxcjk1013_data {
 	bool motion_trigger_on;
 	int64_t timestamp;
 	enum kx_chipset chipset;
-	bool is_smo8500_device;
+	enum kx_acpi_type acpi_type;
 };
 
 enum kxcjk1013_axis {
@@ -1247,7 +1252,7 @@ static irqreturn_t kxcjk1013_data_rdy_trig_poll(int irq, void *private)
 
 static const char *kxcjk1013_match_acpi_device(struct device *dev,
 					       enum kx_chipset *chipset,
-					       bool *is_smo8500_device)
+					       enum kx_acpi_type *acpi_type)
 {
 	const struct acpi_device_id *id;
 
@@ -1256,7 +1261,7 @@ static const char *kxcjk1013_match_acpi_device(struct device *dev,
 		return NULL;
 
 	if (strcmp(id->id, "SMO8500") == 0)
-		*is_smo8500_device = true;
+		*acpi_type = ACPI_SMO8500;
 
 	*chipset = (enum kx_chipset)id->driver_data;
 
@@ -1299,7 +1304,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
 	} else if (ACPI_HANDLE(&client->dev)) {
 		name = kxcjk1013_match_acpi_device(&client->dev,
 						   &data->chipset,
-						   &data->is_smo8500_device);
+						   &data->acpi_type);
 	} else
 		return -ENODEV;
 
@@ -1316,7 +1321,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &kxcjk1013_info;
 
-	if (client->irq > 0 && !data->is_smo8500_device) {
+	if (client->irq > 0 && data->acpi_type != ACPI_SMO8500) {
 		ret = devm_request_threaded_irq(&client->dev, client->irq,
 						kxcjk1013_data_rdy_trig_poll,
 						kxcjk1013_event_handler,
-- 
2.29.2


