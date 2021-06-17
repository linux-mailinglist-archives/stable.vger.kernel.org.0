Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0894C3AB98A
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhFQQ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhFQQ1T (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:27:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A4C61166;
        Thu, 17 Jun 2021 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947112;
        bh=quCPV44/IdUxnRtGBStPZBHZoMQB7GfvG1tWgcWlXMU=;
        h=Subject:To:From:Date:From;
        b=mMmHZKxUeekrgWElOSOwDqiDx1a8u5wKaEY7XXgkqGASYgtigI+HBf7eZBf+CwqzB
         KYErsyG3RZhQOlxywbFy0cTj06gI4mnvNo83D6FtkXH5HBz10VuR9OMqfn0CREJizw
         W9rVZqhLhGvHITqiRpyEr63nZkCqHceJL5/aGqzA=
Subject: patch "iio: accel: bmc150: Fix dereferencing the wrong pointer in" added to staging-testing
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        jeremy@jcline.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:24:35 +0200
Message-ID: <162394707572203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bmc150: Fix dereferencing the wrong pointer in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f2bf22dc9ea8ead180fc0221874bd556bf1d2685 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 23 May 2021 19:00:55 +0200
Subject: iio: accel: bmc150: Fix dereferencing the wrong pointer in
 bmc150_get/set_second_device

The drvdata for iio-parent devices points to the struct iio_dev for
the iio-device. So by directly casting the return from i2c_get_clientdata()
to struct bmc150_accel_data * the code was ending up storing the second_dev
pointer in (and retrieving it from) some semi-random offset inside
struct iio_dev, rather then storing it in the second_dev member of the
bmc150_accel_data struct.

Fix the code to get the struct bmc150_accel_data * pointer to call
iio_priv() on the struct iio_dev * returned by i2c_get_clientdata(),
so that the correct pointer gets dereferenced.

This fixes the following oops on rmmod, caused by trying to
dereference the wrong return of bmc150_get_second_device():

[  238.980737] BUG: unable to handle page fault for address: 0000000000004710
[  238.980755] #PF: supervisor read access in kernel mode
[  238.980760] #PF: error_code(0x0000) - not-present page
...
[  238.980841]  i2c_unregister_device.part.0+0x19/0x60
[  238.980856]  0xffffffffc0815016
[  238.980863]  i2c_device_remove+0x25/0xb0
[  238.980869]  __device_release_driver+0x180/0x240
[  238.980876]  driver_detach+0xd4/0x120
[  238.980882]  bus_remove_driver+0x5b/0xd0
[  238.980888]  i2c_del_driver+0x44/0x70

While at it also remove the now no longer sensible checks for data
being NULL, iio_priv never returns NULL for an iio_dev with non 0
sized private-data.

Fixes: 5bfb3a4bd8f6 ("iio: accel: bmc150: Check for a second ACPI device for BOSC0200")
Cc: Jeremy Cline <jeremy@jcline.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/bmc150-accel-core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index 46ab7675186c..c526d83f14d5 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1805,10 +1805,7 @@ EXPORT_SYMBOL_GPL(bmc150_accel_core_probe);
 
 struct i2c_client *bmc150_get_second_device(struct i2c_client *client)
 {
-	struct bmc150_accel_data *data = i2c_get_clientdata(client);
-
-	if (!data)
-		return NULL;
+	struct bmc150_accel_data *data = iio_priv(i2c_get_clientdata(client));
 
 	return data->second_device;
 }
@@ -1816,10 +1813,9 @@ EXPORT_SYMBOL_GPL(bmc150_get_second_device);
 
 void bmc150_set_second_device(struct i2c_client *client)
 {
-	struct bmc150_accel_data *data = i2c_get_clientdata(client);
+	struct bmc150_accel_data *data = iio_priv(i2c_get_clientdata(client));
 
-	if (data)
-		data->second_device = client;
+	data->second_device = client;
 }
 EXPORT_SYMBOL_GPL(bmc150_set_second_device);
 
-- 
2.32.0


